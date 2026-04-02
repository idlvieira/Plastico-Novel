#INCLUDE "PROTHEUS.CH"

User Function MYCTB04(cTab)

Local cRegra := ""
Local cConta := ""
Local aAreaCTT := CTT->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSRV := SRV->(GetArea())

If cTab = "SB1"
	
	If SD1->D1_CC <> ""
		CTT->(DbSelectArea("CTT"))
		CTT->(DbSetOrder(1))
		If CTT->(DbSeek(xFilial("CTT") + SD1->D1_CC))
			cRegra := ALLTRIM(CTT->CTT_CRGNV1)
		Endif
		
		SB1->(DbSelectArea("SB1"))
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1") + SD1->D1_COD))
			Do Case
				Case cRegra="4"
					cConta := SB1->B1_ZZCTAA
				Case cRegra="5"
					cConta := SB1->B1_ZZCTAC
				Case cRegra="3"
					cConta := SB1->B1_ZZCTAI
				Case cRegra="2"
					cConta := SB1->B1_ZZCTAD
				OtherWise && outra regra ou vazio
					cConta :="REGRA CC INVALIDA"
			EndCase
		EndIf
		
	EndIf
	
	If ALLTRIM(cConta) == ""
		cConta := "CONTA NAO CADASTRADA"
	EndIf
	
Endif

IF cTab = "SRV"
	
	If SD1->D1_CC <> ""
		CTT->(DbSelectArea("CTT"))
		CTT->(DbSetOrder(1))
		If CTT->(DbSeek(xFilial("CTT") + SD1->D1_CC))
			cRegra := ALLTRIM(CTT->CTT_CRGNV1)
		Endif
		
		SRV->(DbSelectArea("SRV"))
		SRV->(DbSetOrder(1))
		If SRV->(DbSeek(xFilial("SRV") + SRV->RV_COD))
			Do Case
				Case cRegra="A"
					cConta := SRV->RV_ZZCTAA
				Case cRegra="C"
					cConta := SRV->RV_ZZCTAC
				Case cRegra="D"
					cConta := SRV->RV_ZZCTAD
				OtherWise && outra regra ou vazio
					cConta :="REGRA CC INVALIDA"
			EndCase
		EndIf
		
	EndIf
	
	If ALLTRIM(cConta) == ""
		cConta := "CONTA NAO CADASTRADA"
	EndIf
	
Endif

RestArea(aAreaSRV)
RestArea(aAreaSB1)
RestArea(aAreaCTT)


Return (cConta)

