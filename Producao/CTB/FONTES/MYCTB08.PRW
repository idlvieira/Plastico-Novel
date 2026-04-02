#Include "rwmake.ch"
#INCLUDE "protheus.ch"

User Function MYCTB08()

/*
Myctb08.prw
23/07/2018 - Claudio Iabuki
* Programa buscar NF Origem do CTE (SF8)
*/

Local _xArea := GetArea()
Local cRet   := ""

dbSelectArea("SF8")  
dbSetOrder(3)
dbSeek(xFilial("SF8") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
If Found()
	cRet := "- NF Origem " + ALLTRIM(SF8->F8_NFORIG) + "/" + ALLTRIM(SF8->F8_SERORIG)
EndIf

RestArea(_xArea)

Return (cRet)
