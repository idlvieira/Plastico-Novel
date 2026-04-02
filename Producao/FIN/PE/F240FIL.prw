#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F240FIL  º Autor ³ NEWTON RECA ALVES  º Data ³  06/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui Filtro na Geracao do Bordero.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINANCEIRO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//------------------------------- Alterações ------------------------------\\
//17/07/2018 Leonardo Bergamasco - Inserido (cAliasSE2) nos filtros existente

User Function F240FIL
local cBanco_:=SA6->A6_COD
    uret := " "
	/*
	If ( CMODPGTO=="01" )		// Credito C.Corrente
		uret := " Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') == AllTrim(U_MYCFG02('FIN000001','001','P',,'C')) .and. (cAliasSE2)->E2_TIPO <> 'DAR' .and. (cAliasSE2)->E2_TIPO <> 'GPS' .and. (cAliasSE2)->E2_TIPO <> 'TX ' .and. (cAliasSE2)->E2_TIPO <> 'BB ' .and. (cAliasSE2)->E2_TIPO <> 'ISS' .and. (cAliasSE2)->E2_TIPO <> 'INS' .and. empty((cAliasSE2)->E2_CODBAR) "
	ElseIf ( CMODPGTO=="03" )	// DOC
		uret := " Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> AllTrim(U_MYCFG02('FIN000001','001','P',,'C')) .and. Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> ' ' .and.  Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> '000' .and. (cAliasSE2)->E2_TIPO <> 'DAR' .and. (cAliasSE2)->E2_TIPO <> 'GPS' .and. (cAliasSE2)->E2_TIPO <> 'TX ' .and. (cAliasSE2)->E2_VALOR < 699.99 .and. (cAliasSE2)->E2_TIPO <> 'BB ' .and. (cAliasSE2)->E2_TIPO <> 'ISS' .and. (cAliasSE2)->E2_TIPO <> 'INS' .and. empty((cAliasSE2)->E2_CODBAR) "
	ElseIf ( CMODPGTO=="13" )	// CONCESSIONARIAS
		uret := " Substr((cAliasSE2)->E2_CODBAR,48,1)<>' ' "
	ElseIf ( CMODPGTO=="16" )	// Tributos - DARF
		uret := " (cAliasSE2)->E2_TIPO  == 'DP ' .or. (cAliasSE2)->E2_TIPO  == 'GPE' .or. (cAliasSE2)->E2_TIPO  == 'FOL' .or. (cAliasSE2)->E2_TIPO  == 'TNC' .or. (cAliasSE2)->E2_TIPO  == 'TX ' "
	ElseIf ( CMODPGTO=="17" )	// Tributos - GPS
		uret := " (cAliasSE2)->E2_TIPO  == 'GPS' .or. (cAliasSE2)->E2_TIPO  == 'FOL' .or. (cAliasSE2)->E2_TIPO  == 'INS' .or. (cAliasSE2)->E2_TIPO  == 'GPE' "
	ElseIf ( CMODPGTO=="30" )	// Boleto Santander
		uret := " Substr((cAliasSE2)->E2_CODBAR,1,3) == AllTrim(U_MYCFG02('FIN000001','001','P',,'C')) .and. (cAliasSE2)->E2_TIPO  <> 'DAR' .and. (cAliasSE2)->E2_TIPO  <> 'GPS' .and. (cAliasSE2)->E2_TIPO <> 'TX ' "
	ElseIf ( CMODPGTO=="31" )	// Boleto em outros banco
		uret := " ( Substr((cAliasSE2)->E2_CODBAR,1,3)<>AllTrim(U_MYCFG02('FIN000001','001','P',,'C')) .and. (cAliasSE2)->E2_TIPO<>'DAR' .and. (cAliasSE2)->E2_TIPO<>'GPS' .and. (cAliasSE2)->E2_TIPO<>'TX ' .and. !empty((cAliasSE2)->E2_CODBAR) )"
	ElseIf ( CMODPGTO=="41" )	// TED outros bancos
		uret := " (cAliasSE2)->E2_VALOR >= 0.01 .and. (Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> AllTrim(U_MYCFG02('FIN000001','001','P',,'C'))) .and. (Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> '000') .and. (cAliasSE2)->E2_TIPO  <> 'DAR' .and. (cAliasSE2)->E2_TIPO  <> 'GPS' .and. (cAliasSE2)->E2_TIPO <> 'TX ' .and. empty((cAliasSE2)->E2_CODBAR) .and. Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> ' ' "
	ElseIf ( CMODPGTO=="43" )	// TED mesma titularidade
		uret := " (cAliasSE2)->E2_VALOR >= 0.01 .and. (Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> AllTrim(U_MYCFG02('FIN000001','001','P',,'C'))) .and. (Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> '000') .and. (cAliasSE2)->E2_TIPO  <> 'DAR' .and. (cAliasSE2)->E2_TIPO  <> 'GPS' .and. (cAliasSE2)->E2_TIPO <> 'TX ' .and. empty((cAliasSE2)->E2_CODBAR) .and. Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_BANCO') <> ' ' .and. Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE,'A2_CGC') == TRIM(GETMV('MV_MYSYS01')) "
	EndIf
    */
    If ( CMODPGTO=="01" )		// Credito C.Corrente
	    uret := " (Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,'A2_ZBOL')<>'S')  "
       uret += "  .and. Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,'A2_BANCO')=='"+alltrim(cBanco_)+"'" 
    ElseIf ( CMODPGTO=="41" ) .or. ( CMODPGTO=="20" )	// TED outros bancos
        uret := " (Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,'A2_ZBOL')<>'S') " 
        uret += "  .and. Posicione('SA2',1,xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,'A2_BANCO')<>'"+alltrim(cBanco_)+"'" 
    else
        uret := ""
    EndIf
        

RETURN(uret)

