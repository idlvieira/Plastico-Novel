#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ F240FIL  บ Autor ณ NEWTON RECA ALVES  บ Data ณ  06/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui Filtro na Geracao do Bordero.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FINANCEIRO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F240FIL



uret := " "

//If mv_par06==1
	
    //alert(LEN(TRIM(E2_CODBAR)))
	
	If ( CMODPGTO=="01" )		// Credito C.Corrente
		
		uret := " Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') == '341' .and. E2_TIPO <> 'DAR' .and. E2_TIPO <> 'GPS' .and. E2_TIPO <> 'TX ' .and. E2_TIPO <> 'BB ' .and. E2_TIPO <> 'ISS' .and. E2_TIPO <> 'INS' .and. empty(E2_CODBAR) "
		
	ElseIf ( CMODPGTO=="03" )	// DOC
		
		uret := " Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> '341' .and. Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> ' ' .and.  Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> '000' .and. E2_TIPO <> 'DAR' .and. E2_TIPO <> 'GPS' .and. E2_TIPO <> 'TX ' .and. E2_VALOR < 699.99 .and. E2_TIPO <> 'BB ' .and. E2_TIPO <> 'ISS' .and. E2_TIPO <> 'INS' .and. empty(E2_CODBAR) "
		
	ElseIf ( CMODPGTO=="13" )	// CONCESSIONARIAS
	
    	//alert(len(SE2->E2_CODBAR))
		uret := " Substr(E2_CODBAR,48,1)<>' ' " //.and. SE2->E2_TIPO <> 'DAR' .and. SE2->E2_TIPO <> 'GPS' .and. SE2->E2_TIPO <> 'TX ' .and. SE2->E2_TIPO <> 'ISS' "

	ElseIf ( CMODPGTO=="16" )	// Tributos - DARF
		
		uret := " E2_TIPO  == 'DP ' .or. E2_TIPO  == 'GPE' .or. E2_TIPO  == 'FOL' .or. E2_TIPO  == 'TNC' .or. E2_TIPO  == 'TX ' "
		
	ElseIf ( CMODPGTO=="17" )	// Tributos - GPS
		
		uret := " E2_TIPO  == 'GPS' .or. E2_TIPO  == 'FOL' .or. E2_TIPO  == 'INS' .or. E2_TIPO  == 'GPE' "
		
	ElseIf ( CMODPGTO=="30" )	// Boleto Santander
		
		uret := " Substr(E2_CODBAR,1,3) == '341' .and. E2_TIPO  <> 'DAR' .and. E2_TIPO  <> 'GPS' .and. E2_TIPO <> 'TX ' "
		
	ElseIf ( CMODPGTO=="31" )	// Boleto em outros banco
		
		//uret := " Substr(SE2->E2_CODBAR,1,3)<>'341' .and. SE2->E2_TIPO<>'DAR' .and. SE2->E2_TIPO<>'GPS' .and. SE2->E2_TIPO<>'TX ' "
		
		uret := " ( Substr(E2_CODBAR,1,3)<>'341' .and. E2_TIPO<>'DAR' .and. E2_TIPO<>'GPS' .and. E2_TIPO<>'TX ' .and. !empty(E2_CODBAR) )" //.and. SE2->E2_TIPO<>'DAR' .and. SE2->E2_TIPO<>'GPS' .and. SE2->E2_TIPO<>'TX ' "
		
	ElseIf ( CMODPGTO=="41" )	// TED outros bancos
		
		uret := " E2_VALOR >= 750.00 .and. (Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> '341') .and. (Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> '000') .and. E2_TIPO  <> 'DAR' .and. E2_TIPO  <> 'GPS' .and. E2_TIPO <> 'TX ' .and. empty(E2_CODBAR) .and. Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> ' ' "

	ElseIf ( CMODPGTO=="43" )	// TED mesma titularidade
		
		uret := " E2_VALOR >= 750.00 .and. (Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> '341') .and. (Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> '000') .and. E2_TIPO  <> 'DAR' .and. E2_TIPO  <> 'GPS' .and. E2_TIPO <> 'TX ' .and. empty(E2_CODBAR) .and. Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_BANCO') <> ' ' .and. Posicione('SA2',1,xFilial('SA2')+E2_FORNECE,'A2_CGC') == TRIM(GETMV('MV_MYSYS01')) "
	EndIf

	
	// CTIPOPAG
	
	
//EndIF


RETURN(uret)


//		//uret := " (Substr(E2_CODBAR,1,1)=='7' .or. Substr(E2_CODBAR,1,1)=='8') .AND. (SE2->E2_TIPO<>'DAR' .and. SE2->E2_TIPO<>'TX ' .and. SE2->E2_TIPO<>'GPE' .and. SE2->E2_TIPO<>'FOL' .and. SE2->E2_TIPO<>'TNC' )" //.and. LEN(TRIM(SE2->E2_CODBAR))==48 )"