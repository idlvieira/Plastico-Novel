#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³ TKEVALI  ºAutor  ³ NEWTON ALVES       º Data ³  14/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executado na confirmacao da linha do      º±±
±±º          ³ atendimento, para validar produtos e regras da SOX         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//--------------------------- Alterações ----------------------------------\\
//10/07/2018 Leonardo Bergamasco Chamado 29 - G7D-1Z4-VAJJ - Tela de alerta para usuario quando data entrega for divergente da padrão Noval	

user function TKEVALI()
    
   	local lRet		:= .T.
	local aArea		:= getArea()
	local aAreaSUA	:= SUA->(getArea())
	local aAreaSUB	:= SUB->(getArea())
	local aAreaSC5	:= SC5->(getArea())
	local aAreaSC6	:= SC6->(getArea())
	local nPosDTSEN	:= gdFieldPos("UB_ZZDATEN") //gdFieldPos("UB_ZZDATEN")
	local nPosCOD	:= gdFieldPos("UB_PRODUTO")
	local nPosFD	:= gdFieldPos("UB_ZZDATAF") //gdFieldPos("UB_MYDATAF")
	local _lDel		:= GdDeleted()
	Local dDtEPadrao:= dDataBase
	Local nOpcDtEntr:= 0
	Local lParamixB := IIF(Type("PARAMIXB")=='U',.F.,.T.)
	//Local _lDel	:= aCols[Len(aCols),nUsado+1]
	//Local _nPPantone:= gdFieldPos("UB_PANTONE") //aScan(aHeader,{|x| UPPER(Alltrim(x[2])) == "UB_PANTONE"})
	//if avalores[4]<=0

    //10/07/2018 Leonardo Bergamasco Chamado 29 - G7D-1Z4-VAJJ - Tela de alerta para usuario quando data entrega for divergente da padrão Noval
	If lParamixB
      IF (Posicione("SB1",1,xFilial("SB1")+PARAMIXB[1],"B1_ORIGEM") == "1")
        dDtEPadrao := ddatabase + U_MYCFG02("TMK000001","003","P",,"N")
 	  ElseIf (Posicione("SB1",1,xFilial("SB1")+PARAMIXB[1],"B1_ORIGEM") == "0")
        dDtEPadrao := ddatabase + U_MYCFG02("TMK000001","004","P",,"N")
  	  EndIf
  	  If PARAMIXB[2] <> dDtEPadrao
  	    While nOpcDtEntr < 1 .or. nOpcDtEntr > 2
          If PARAMIXB[2] < dDtEPadrao
            nOpcDtEntr := Aviso("Data de Entrega","Data de entrega informada ("+DtoC(PARAMIXB[2])+") é MENOR que a data padrão da Novel ("+DtoC(dDtEPadrao)+"). Deseja manter a data informada?",{"SIM","NAO"},3,"Produto: "+PARAMIXB[1])
          ElseIf PARAMIXB[2] > dDtEPadrao
            nOpcDtEntr := Aviso("Data de Entrega","Data de entrega informada ("+DtoC(PARAMIXB[2])+") é MAIOR que a data padrão da Novel ("+DtoC(dDtEPadrao)+"). Deseja manter a data informada?",{"SIM","NAO"},3,"Produto: "+PARAMIXB[1])
          EndIf 
        EndDo
  	  EndIf
  	  Return IIF(nOpcDtEntr > 0 .and. nOpcDtEntr < 2, PARAMIXB[2], dDtEPadrao)
    EndIf
    //-----------------------------------------------------------------------------------------------------------------------------------------\\
	
	if Posicione("ZZZ",1,xFilial("ZZZ")+"TMK000016"+"001","ZZZ_RETORN")=="S"
		if M->UA_TPFRETE=="C"
			if M->UA_FRETE<=0
				MSGALERT("Favor preencher o Valor do Frete, pois o frete está como CIF!")
				return .f.
			endif
		endif  
	endif   

	/*
	If len(trim(aCols[n][_nPPantone]))==0
		Alert("Favor preencher o campo Pantone")
		Return .F.
	EndIf
	*/   
		
	IF POSICIONE("DA1",1,xFilial("DA1")+M->UA_TABELA+aCols[N,nPosCOD],"DA1_PRCVEN") == 0 .and. _lDel==.F. //(aCols[N,nPosFD]<>"1")
		Alert("Este produto nao esta cadastrado na tabela de preco corrente")
		lRet := .F.
	EndIf
	
	If aCols[N,nPosDTSEN] < DDATABASE
		AVISO('Atencao','Data de entrega anterior a data atual',{'OK'})
		lRet := .F.
    EndIf

/*
	IF (EMPTY(Posicione("SB1",1,xFilial("SB1")+aCols[N,nPosCOD],"B1_GRUPO")))  .and. _lDel==.F. //(aCols[N,nPosFD]<>"1")
		AVISO('Atencao','Favor solicitar para area de Materiais o preenchimento do campo GRUPO DE PRODUTO no cadastro de Produto',{'OK'})
		lRet := .F.
	EndIf
*/
	//U_MYTMK10() // CHAMA O FONTE DE COMISSAO
	
	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aAreaSUB)
	restArea(aAreaSUA)
	restArea(aArea)


//Valida Comissao - Novel
//VLD_COM()

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³VldTabPrecºAutor  ³ Thiago - Totvs IP  º Data ³  25/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validaçao da tabela de preços de vendas                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldTabPrec()

Local lRet			:= .T.
Local cTabela		:= RetField("DA0",1,xFilial("DA0")+M->UA_TABELA,"DA0_ZZTPTB")
Local aAreaSA1		:= SA1->(GetArea())
Local cTipo			:= ""
Local cTpPes		:=  ""
Local cIncR			:=""
Local cEst			:= ""

/*

SA1->(dbSetOrder(1))                                           
SA1->(dbSeek(xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA))) 

cTipo			:= SA1->A1_TIPO 
cTpPes			:= SA1->A1_TPESSOA
cIncR			:= SA1->A1_INSCR
cEst			:= SA1->A1_EST
cPosIPI			:= SB1->B1_POSIPI


//ZY
//SP=07
//RJ=07
//BA=07


If SM0->M0_ESTCOB == "PR" .or. SM0->M0_ESTCOB == "SP" 

	If (Empty(cIncR) .OR. cIncR $ "ISENTO|ISENTA") .and. SubStr(cTabela,1,1) <> "O" //.AND. cTipo $ "R|S" .AND. 
		lRet := .F.
	EndIf
	
	If cTipo $ "R" .and. SubStr(cTabela,1,1) <> "C"
		lRet := .F.
	EndIf
	
	If cTipo <> "R" .and. SubStr(cTabela,1,1) <> "O"
		lRet := .F.
	EndIf
	
	If Trim(cPosIPI)=="39231090" .and. SubStr(cTabela,2,2)=="18"
		lRet := .F.
	EndIf
	
	If Trim(cPosIPI)<>"39231090" .and. SubStr(cTabela,2,2)<>"18"
		lRet := .F.
	EndIf
	
	If cEst $ GetMv("MV_NORTE") .and. SubStr(cTabela,2,2)<>"07"
		lRet := .F.
	EndIf
	
	If !cEst $ GetMv("MV_NORTE") .and. SubStr(cTabela,2,2)=="07"
		lRet := .F.
	EndIf
	
//	If SubStr(cTabela,2,2)=="07" 
//		lRet := .F.
//	EndIf


EndIf


If SM0->M0_ESTCOB == "BA" 

	If (Empty(cIncR) .OR. cIncR $ "ISENTO|ISENTA") .and. SubStr(cTabela,1,1) <> "O" //.AND. cTipo $ "R|S" .AND. 
		lRet := .F.
	EndIf
	
	If cTipo $ "R" .and. SubStr(cTabela,1,1) <> "C"
		lRet := .F.
	EndIf
	
	If cTipo <> "R" .and. SubStr(cTabela,1,1) <> "O"
		lRet := .F.
	EndIf
	
	If Trim(cPosIPI)=="39231090" .and. SubStr(cTabela,2,2)=="18"
		lRet := .F.
	EndIf
	
	If Trim(cPosIPI)<>"39231090" .and. SubStr(cTabela,2,2)<>"18"
		lRet := .F.
	EndIf
	
	If !cEst $ SM0->M0_ESTCOB .and. SubStr(cTabela,2,2)<>"12"
		lRet := .F.
	EndIf
	
	If cEst $ SM0->M0_ESTCOB .and. SubStr(cTabela,2,2)<>"18"
		lRet := .F.
	EndIf
	
EndIf

*/

/*    
If SubStr(cTabela,1,1) == "C" .AND. !cTipo $ "R|S"
	lRet := .F.
ElseIf SubStr(cTabela,1,1) == "C" .AND. cTipo $ "R|S" .AND. (Empty(cIncR) .OR. cIncR $ "ISENTO|ISENTA")
	lRet := .F.
ElseIf SubStr(cTabela,1,1) == "C" .AND. cTipo $ "R|S" .AND. ! (Empty(cIncR) .OR. cIncR $ "ISENTO|ISENTA") .AND. cTpPes == "PF"
	lRet := .F.
EndIf

If SubStr(cTabela,1,1) == "O" .AND. cTipo $ "R|S"
	lRet := .F.
ElseIf SubStr(cTabela,1,1) == "O" .AND. !cTipo $ "R|S" .AND. cTpPes <> "PF"
	lRet := .F.
EndIf

If SM0->M0_ESTCOB == "PR" 

	If cEst $ GetMv("MV_NORTE")
	    If SubStr(cTabela,2,2) == "12" .AND. cTipo $ "R|S"
	    	lRet := .F.
	    EndIf
	Else
	 	If SubStr(cTabela,2,2) == "07"
	    	lRet := .F.
	    EndIf
	EndIf

ElseIf SM0->M0_ESTCOB == "SP"
	
    If SubStr(cTabela,2,2) <> "18" .AND. cTipo $ "R|S"  .AND.  cEst <> "SP"
    	lRet := .F.
    EndIf

	If cEst $ GetMv("MV_NORTE")
	    If SubStr(cTabela,2,2) <> "07"
	    	lRet := .F.
	    EndIf
	ElseIf cEst == "SP"
		If SubStr(cTabela,2,2) <> "18"
			lRet := .F.
		EndIf
	Else
	 	If SubStr(cTabela,2,2) <> "12"
	    	lRet := .F.
	    EndIf 
	    
	EndIf
	
ElseIf SM0->M0_ESTCOB == "BA"
    
	If SubStr(cTabela,2,2) == "18" .AND. cTipo $ "R|S"    
		lRet := .F.
	EndIf

	If cEst == "BA"
	    If SubStr(cTabela,2,2) <> "18"
	    	lRet := .F.
	    EndIf
	Else
	 	If SubStr(cTabela,2,2) <> "12" 
	    	lRet := .F.
	    EndIf
	EndIf
	
Endif

*/

RestArea(aAreaSA1)

Return lRet



