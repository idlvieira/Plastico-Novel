#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   ºAutor  ³Daniel Gouvea       º Data ³  12/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na exclusao do doc. de saida              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Novel Parana                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2520E
Local _area := getarea()
Local _aSD2 := SD2->(getarea())
Local _aSC5 := SC5->(getarea())

aPEDIDO := {}
DbSelectArea("SD2")
DbSetOrder(3)
if DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
	While SD2->D2_FILIAL  == xFilial("SD2") 		.and. ;
		SD2->D2_DOC     == SF2->F2_DOC 		.and. ;
		SD2->D2_SERIE   == SF2->F2_SERIE		.and. ;
		SD2->D2_CLIENTE == SF2->F2_CLIENTE    .and. ;
		SD2->D2_LOJA    == SF2->F2_LOJA  		.and. ;
		!EOF()
		
		dbselectarea("SC5")
		dbsetorder(1)
		if dbseek(xFilial()+SD2->D2_PEDIDO)                                             
		  /*	//VAI VERIFICAR SE JA TEVE FATURAMENTOS PRA ESSE PEDIDO
			cQuery := " SELECT COUNT(*) AS REG FROM "+RetSqlName("SC9")+" WHERE C9_FILIAL='"+xFilial("SC5")+"' "
			cQuery += " AND C9_PEDIDO='"+SC5->C5_NUM+"' AND C9_NFISCAL<>' ' AND D_E_L_E_T_=' ' "
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
		    IF TEMP->REG > 1
				_aux := "C"
			else
				_aux := "N"
			endif          
			TEMP->(dbclosearea())  */
			reclock("SC5",.f.)
			SC5->C5_ZZUANA3 := "N"
			msunlock()
		endif
		
		dbselectarea("SD2")
		DbSkip()
	EndDo
endif


restarea(_aSC5)
restarea(_aSD2)
restarea(_area)
return