#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

user function TKEVALI()

	local lRet		:= .T.
	local aArea		:= getArea()
	local aAreaSUA	:= SUA->(getArea())
	local aAreaSUB	:= SUB->(getArea())
	local aAreaSC5	:= SC5->(getArea())
	local aAreaSC6	:= SC6->(getArea())
	local nPosDTSEN	:= gdFieldPos("UB_ZZDATEN")
	local nPosCOD	:= gdFieldPos("UB_PRODUTO")
	local _lDel		:= GdDeleted()
	Local dDtEPadrao:= dDataBase
	Local nOpcDtEntr:= 0
	Local lParamixB := IIF(Type("PARAMIXB")=='U',.F.,.T.)

	If lParamixB
		IF (Posicione("SB1",1,xFilial("SB1")+PARAMIXB[1],"B1_ORIGEM") == "1")
			dDtEPadrao := ddatabase + U_MYCFG02("TMK000001","003","P",,"N")
		ElseIf (Posicione("SB1",1,xFilial("SB1")+PARAMIXB[1],"B1_ORIGEM") == "0")
			dDtEPadrao := ddatabase + U_MYCFG02("TMK000001","004","P",,"N")
		EndIf
		If PARAMIXB[2] <> dDtEPadrao
			While nOpcDtEntr < 1 .or. nOpcDtEntr > 2
				If PARAMIXB[2] < dDtEPadrao
					nOpcDtEntr := Aviso("Data de Entrega","Data de entrega informada ("+DtoC(PARAMIXB[2])+")  MENOR que a data padro da Novel ("+DtoC(dDtEPadrao)+"). Deseja manter a data informada?",{"SIM","NAO"},3,"Produto: "+PARAMIXB[1])
				ElseIf PARAMIXB[2] > dDtEPadrao
					nOpcDtEntr := Aviso("Data de Entrega","Data de entrega informada ("+DtoC(PARAMIXB[2])+")  MAIOR que a data padro da Novel ("+DtoC(dDtEPadrao)+"). Deseja manter a data informada?",{"SIM","NAO"},3,"Produto: "+PARAMIXB[1])
				EndIf
			EndDo
		EndIf
		Return IIF(nOpcDtEntr > 0 .and. nOpcDtEntr < 2, PARAMIXB[2], dDtEPadrao)
	EndIf

	if Posicione("ZZZ",1,xFilial("ZZZ")+"TMK000016"+"001","ZZZ_RETORN")=="S"
		if M->UA_TPFRETE=="C"
			if M->UA_FRETE<=0
				MSGALERT("Favor preencher o Valor do Frete, pois o frete est como CIF!")
				return .f.
			endif
		endif
	endif

	IF POSICIONE("DA1",1,xFilial("DA1")+M->UA_TABELA+aCols[N,nPosCOD],"DA1_PRCVEN") == 0 .and. _lDel==.F. //(aCols[N,nPosFD]<>"1")
		Alert("Este produto nao esta cadastrado na tabela de preco corrente")
		lRet := .F.
	EndIf

	If aCols[N,nPosDTSEN] < DDATABASE
		AVISO('Atencao','Data de entrega anterior a data atual',{'OK'})
		lRet := .F.
	EndIf

	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aAreaSUB)
	restArea(aAreaSUA)
	restArea(aArea)
Return lRet
