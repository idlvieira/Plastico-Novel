#INCLUDE "rwmake.ch"  

/*/
	Programa......:	MVDTFIS
	Autor.........:	Microsiga         
	Data..........:	17/09/04
	Descricao.....:	GRAVACAO DATA LIMITE PARA OPERACOES FISCAIS          
/*/

User Function MVDTFIS
dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial() + "MV_DATAFIS")

//Private dDataFis := CtoD(Trim(SX6->X6_CONTEUD))
Private dDataFis := GetMv("MV_DATAFIS") // CtoD(Trim(SX6->X6_CONTEUD))
@ 200,250 TO 330,475 DIALOG oDlg2 TITLE "Altera Data"
@ 010,010 TO 045,110 TITLE "Data limite para Operacoes Fiscais:"
@ 025,020 GET dDataFis SIZE 50, 9
@ 050,050 BMPBUTTON TYPE 01 ACTION Grava()
@ 050,080 BMPBUTTON TYPE 02 ACTION Close(oDlg2)
ACTIVATE DIALOG oDlg2 CENTERED

Return()

Static Function Grava()
If !Empty(dDataFis)
	If dtos(dDataFis) >= dtos(date())
		Alert("Informar data menor que a de hoje !")
		Alert("Nao foi gravado !")
	Else
		dbSelectArea("SX6")
		dbSetOrder(1)
		If dbSeek(cFilant + "MV_DATAFIS")
	   	   RecLock("SX6",.F.)
	       SX6->X6_CONTEUD := Dtos(dDataFis)
	   	   MsUnlock()
		Else
		   If dbSeek(Space(Len(cFilant)) + "MV_DATAFIS")
	    	  RecLock("SX6",.F.)
		      SX6->X6_CONTEUD := Dtos(dDataFis)
	    	  MsUnlock()
	       EndIf	  
		EndIf
	EndIf
Endif
Close(oDlg2)

Return()