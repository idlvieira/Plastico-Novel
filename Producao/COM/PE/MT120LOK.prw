#INCLUDE "RWMAKE.CH"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120LOK  ºAutor  ³    º Data ³  1                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. para validação dos itens adicionados com tabela de     º±±
±±º          ³preços se os mesmos estão liberados.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120LOK()
	Local  lRet   	:= .T.            
	Local aArea  	:= GetArea()
	Local aAreaCTT 	:= CTT->(GetArea())
	Local  nPosCC  	:=  aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CC"})
	Local cCCusto 	:= aCols[n][nPosCC]
	Local nPosQtde	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT"})
	Local nQuant	:= aCols[n][nPosQtde]
	Local nPosAE	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC"})
	Local nPositAE	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMSC"})
	Private cQuery 	:= ""
	Private Oqry 	:= NVLxFUN():New(.f.) //, cQuery

	// Valida Centro de custo do Pedido
	If Empty(cCCusto)                  
		Alert('Campo Centro de Custo obrigatório!')
		lRet := .F.
	Else 
		CTT->(dbSetOrder(1))
		If CTT->(dbSeek(xFilial('CTT')+cCCusto))
			If CTT->CTT_BLOQ == '1'
				Alert('Centro de Custo Bloqueado!')  
				lRet := .F.
			EndIf
			//If Empty(CTT->CTT_ZZAPRO)
			//	Alert('Centro de Custo sem aprovador!(CTT)')  
			//	lRet := .F.
			//EndIf   
		Else
			Alert('Centro de Custo informado inválido!')
			lRet := .F.
		EndIf
	EndIf

	if lRet .AND. FUNNAME() == "MATA122" .AND. nQuant > 1 
		Alert('Somente é permitido uma unidade por AE')
		lRet := .F.
	EndIf 
	if lRet .AND. FUNNAME() == "MATA122" 

		cQuery := " SELECT " + linha
		cQuery += " C7_NUM "
		cQuery += " FROM " + RetSqlName("SC7") + " (nolock) " + linha
		cQuery += " WHERE " + linha
		cQuery += " C7_FILIAL = '" + xFilial("SC7") +  "' " + linha
		cQuery += " AND C7_TIPO = '2' " + linha
		cQuery += " AND C7_NUMSC = '" + aCols[n][nPosAE] + "' " + linha
		cQuery += " and C7_ITEMSC = '" + aCols[n][nPositAE] + "' " + linha
		cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = SUBSTRING('" + DTOS(DA120EMIS)+ "',1,6) " + linha  
		
		Oqry:TcQry("TRB", cQuery,1,.f.)
		dbSelectArea("TRB")
		dbGoTop()
		IF AllTrim(("TRB")->C7_NUM) != ""

			Alert('Este contrato já possui para este AE neste mês!!! Número da AE: '+ ("TRB")->C7_NUM)
			lRet := .F.
		ENDIF
		("TRB")->(DbCloseArea())
	EndIf 

	RestArea(aAreaCTT)
	RestArea(aArea)
Return lRet
