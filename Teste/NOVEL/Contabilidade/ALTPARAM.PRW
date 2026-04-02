#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

User Function ALTPARAM()        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

SetPrvt("WDATADE,WDATATE")

DbSelectArea("SX6")
DbSeek(xFilial()+"MV_DATADE",.T.)
WDATADE:=X6_Conteud
DbSeek(xFilial()+"MV_DATAATE",.T.)
WDATATE:=X6_Conteud
@ 0,0 TO 120,210 DIALOG oDlg1 TITLE "Alteração de Competencia"
@ 3,5 TO 35,100
// Montagem dos titulos dos campos
@ 12,10 say  "Data inicio "
@ 22,10 say  "Data fim "

// Montagem dos campos
@ 12,45 GET WDATADE SIZE 40,40 PICTURE "XXXXXXXXXX"  VALID NaoVazio()
@ 22,45 GET WDATATE SIZE 40,40 PICTURE "XXXXXXXXXX"  VALID NaoVazio()

// Botoes
@  45,40 BMPBUTTON TYPE 1 ACTION nseqOk1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
@  45,70 BMPBUTTON TYPE 2 ACTION nseqCan1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
ACTIVATE DIALOG oDlg1 CENTER
REturn


// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotOk1
Static Function nseqOk1()
***************
Close(oDlg1)

DbSelectArea("SX6")
DbSeek(xFilial()+"MV_DATADE",.T.)
Reclock("SX6",.F.)
Replace X6_Conteud With WDATADE
MsUnlock()
DbSeek(xFilial()+"MV_DATAATE",.T.)
Reclock("SX6",.F.)
Replace X6_Conteud With WDATATE
MsUnlock()

Return


// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotCan1
Static Function nseqCan1()
***************
Close(oDlg1)
Return
