#INCLUDE "PROTHEUS.CH"

User Function MYCTB05(cTab,cTipo,cCC,cProduto)

Local cRegra := ""
Local cConta := ""
Local aAreaCTT := CTT->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSRV := SRV->(GetArea())
Local aAreaSED := SED->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local aAreaSEZ := SEZ->(GetArea())
Local aAreaSE2 := SE2->(GetArea())
Local aAreaSRZ := SRZ->(GetArea())

If cTab = "SB1"
	
	CTT->(DbSelectArea("CTT"))
	CTT->(DbSetOrder(1))
	IF cTipo <> "R" //Busca CC no SD1
		If CTT->(DbSeek(xFilial("CTT") + SD1->D1_CC))
			cRegra := ALLTRIM(CTT->CTT_CRGNV1)
		Endif
	Endif
	IF cTipo = "R" //Busca CC no SDE (rateios)
		If CTT->(DbSeek(xFilial("CTT") + SDE->DE_CC))
			cRegra := ALLTRIM(CTT->CTT_CRGNV1)
		Endif
	Endif
	
	SB1->(DbSelectArea("SB1"))
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1") + SD1->D1_COD))
		Do Case
			Case cRegra="4"  //Administrativo
				cConta := SB1->B1_ZZCTAA
			Case cRegra="5" .or. cRegra="6"  //Comercial
				cConta := SB1->B1_ZZCTAC
			Case cRegra="3"  //Custo Direto
				cConta := SB1->B1_ZZCTAI
			Case cRegra="2" .or. cRegra="9"  //Custos Indireto
				cConta := SB1->B1_ZZCTAD
			OtherWise && outra regra ou vazio
				cConta :="REGRA CC INVALIDA"
		EndCase
	EndIf
	
Endif

IF cTab = "SRV"
	
	If SRZ->RZ_CC <> ""
		CTT->(DbSelectArea("CTT"))
		CTT->(DbSetOrder(1))
		If CTT->(DbSeek(xFilial("CTT") + SRZ->RZ_CC))
			cRegra := ALLTRIM(CTT->CTT_CRGNV1)
		Endif
		
		SRV->(DbSelectArea("SRV"))
		SRV->(DbSetOrder(1))
		If SRV->(DbSeek(xFilial("SRV") + SRZ->RZ_PD))
			Do Case
				Case cRegra="4" .and.  cTipo = "D"  //Administrativo Debito
					cConta := SRV->RV_ZZADMD
				Case cRegra="5" .and.  cTipo = "D"  //Comercial Debito
					cConta := SRV->RV_ZZCMLD
				Case cRegra="2" .and.  cTipo = "D"  //Custos Direto Debito
					cConta := SRV->RV_ZZCDIRD
				Case cRegra="3" .and.  cTipo = "D"  //Custos Indiretos Debito
					cConta := SRV->RV_ZZCINDD
				Case cRegra="4" .and.  cTipo = "C"  //Administrativo Credito
					cConta := SRV->RV_ZZADMC
				Case cRegra="5" .and.  cTipo = "C"  //Comercial Credito
					cConta := SRV->RV_ZZCMLC
				Case cRegra="2" .and.  cTipo = "C"  //Custos Direto Credito
					cConta := SRV->RV_ZZCDIRC
				Case cRegra="3" .and.  cTipo = "C"  //Custos Indiretos Credito
					cConta := SRV->RV_ZZCINDC
				OtherWise && outra regra ou vazio
					cConta :="REGRA CC INVALIDA"
			EndCase
		EndIf
		
	EndIf
	
Endif

If cTab = "SED"
	
	CTT->(DbSelectArea("CTT"))
	CTT->(DbSetOrder(1))
	IF cTipo = "N" //Busca CC no SE2 (TITULO)
		If CTT->(DbSeek(xFilial("CTT") + SE2->E2_CCUSTO))
			cRegra := ALLTRIM(CTT->CTT_CRGNV1)
		Endif
	Endif
	IF cTipo = "Z" //Busca CC no SEZ (TITULO)
		If CTT->(DbSeek(xFilial("CTT") + SEZ->EZ_CCUSTO))
			cRegra := ALLTRIM(CTT->CTT_CRGNV1)
		Endif
	Endif
	
	SED->(DbSelectArea("SED"))
	SED->(DbSetOrder(1))
	If SED->(DbSeek(xFilial("SED") + SED->ED_CODIGO))
		Do Case
			Case cRegra="4"  //Administrativo
				cConta := SED->ED_ZZCTAA
			Case cRegra="5" .or. cRegra="6"  //Comercial
				cConta := SED->ED_ZZCTAC
			Case cRegra="3"  //Custo Direto
				cConta := SED->ED_ZZCTAI
			Case cRegra="2"  //Custos Indireto
				cConta := SED->ED_ZZCTAD
			OtherWise && outra regra ou vazio
				cConta :="REGRA CC INVALIDA"
		EndCase
	EndIf	
	
Endif

If cTab = "" .and. cTipo == "GATILHO"
	
	CTT->(DbSelectArea("CTT"))
	CTT->(DbSetOrder(1))
	If CTT->(DbSeek(xFilial("CTT") + cCC))
		cRegra := ALLTRIM(CTT->CTT_CRGNV1)
	Endif
	
	SB1->(DbSelectArea("SB1"))
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1") + cProduto))
		Do Case
			Case cRegra="4"  //Administrativo
				cConta := SB1->B1_ZZCTAA
			Case cRegra="5" .or. cRegra="6"  //Comercial
				cConta := SB1->B1_ZZCTAC
			Case cRegra="3"  //Custo Direto
				cConta := SB1->B1_ZZCTAI
			Case cRegra="2" .or. cRegra="9"  //Custos Indireto
				cConta := SB1->B1_ZZCTAD
			OtherWise && outra regra ou vazio
				cConta := SB1->B1_CONTA
		EndCase
	EndIf
	
Endif

RestArea(aAreaSD1)
RestArea(aAreaSEZ)
RestArea(aAreaSE2)
RestArea(aAreaSRZ)
RestArea(aAreaSED)
RestArea(aAreaSRV)
RestArea(aAreaSB1)
RestArea(aAreaCTT)


Return (cConta)

