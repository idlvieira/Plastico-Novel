#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบClasse    ณMT110LOK  บAutor  ณWinston D. de Castroบ Data ณ  23/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVALIDACAO DE LINHA NA SOLICITACAO DE COMPRA                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 10 Ms-Sql Server                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
&& Dios libre al Usuario/Analista de cambiar una sola linea de este fichero!
*/
&& MATA110 - solicitacoes de compra

User Function MT110LOK()

Local aArea	   := GetArea()    &&Salva Area
local lRet     := .T.
local oValid   := nil
local nPosCC   := gdFieldPos("C1_CC")
local nPosProd := gdFieldPos("C1_PRODUTO")
local nPosCapex:= gdFieldPos("C1_ZZCAPEX")
Local cUser    := retcodusr()  && Codigo do Usuario que esta Solicitando
Local cGaAprov := ""
Local nx	   := 0	
Local cGProd   := ""

/*
oValid := MyComX001():new(aCols[n][nPosProd],aCols[n][nPosCC],"")

lRet := oValid:vldCCusto()


&& Criado para validar se o APROVADOR e o mesmo para os diversos PRODUTOS
For nx:=1 To Len(aCols)

	If	aCols[nx][len(aHeader)+1]		// Deletado
		Loop
	EndIf

	
	nPosPd 	:= aScan(aHeader, {|x| alltrim(x[2])=="C1_PRODUTO"})
	cGProd	:= aCols[nx][nPosPd]
	DbSelectArea("SAI")
	DbOrderNickName("M_USERPRO")
	IF (DbSeek(xFilial("SAI")+cUser+cGProd)) && Procuro por Produto
		If  (cGaAprov <> SAI->AI_MYAPROV)
			IF 	Empty(cGaAprov)
				cGaAprov := SAI->AI_MYAPROV
			Else
				AVISO('Atencao','Este produto tem um APROVADOR diferente do Produto Anterior, NAO PODE ser lan็ado JUNTO!!',{'OK'})
				lRet := .F.
				Exit
			Endif
		Endif
	Else && Procurar o Grupo do Produto
		cGrupo := POSICIONE("SB1",1,xFILIAL("SB1")+cGProd,"B1_GRUPO")
		DbSelectArea("SAI")
		DbOrderNickName("M_USERGRP")
		IF (DbSeek(xFilial("SAI")+cUser+cGrupo)) && Procuro por Grupo
			If  (cGaAprov <> SAI->AI_MYAPROV)
				IF Empty(cGaAprov)
					cGaAprov := SAI->AI_MYAPROV
				Else
					AVISO('Atencao','Este produto tem um APROVADOR diferente do Produto Anterior, NAO PODE ser lan็ado JUNTO!!',{'OK'})
					lRet := .F.  
					Exit
				Endif
			Endif
		Endif
	Endif
Next nx
*/

_cTipo := Posicione("SB1",1,xFilial("SB1")+aCols[N,nPosProd],"B1_TIPO")
If _cTipo=="AF" .AND. Empty(aCols[N,nPosCapex])
	AVISO('Atencao','Este produto ้ um Ativo, favor preencher o campo Capex',{'OK'})
	lRet := .F.
EndIf



RestArea(aArea)


return lRet
