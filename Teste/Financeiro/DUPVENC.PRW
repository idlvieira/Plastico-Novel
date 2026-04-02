#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

User Function DUPVENC()        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ DUPVENC   ³ Autor ³   Eliene Cerqueira   ³ Data ³ 11.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de percentual de dupl. vencidas                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro                                                 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

wEmiIni:=Ctod("  /  /  ")
wEmiFin:=Ctod("  /  /  ")
@ 0,0 TO 140,280 DIALOG oDlg1 TITLE "Consulta % de Títulos Vencidos"
@ 3,5 TO 45,130

@ 12,14 SAY "Vencimento Inicial : "
@ 22,14 SAY "Vencimento Final   : "

@ 12,63 GET  wEmiIni   SIZE 40,20 PICTURE X3Picture("E1_Emissao")  VALID NaoVazio()
@ 22,63 GET  wEmiFin   SIZE 40,20 PICTURE X3Picture("E1_Emissao")  VALID NaoVazio()

@ 50,40 BMPBUTTON TYPE 1 ACTION OkProc1()// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> @ 105,155 BMPBUTTON TYPE 1 ACTION Execute(OkProc2)
@ 50,70 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

Return

****************
// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> Function OkProc2
Static Function OkProc1()
****************
VencTot := 0
Venc15 := 0
DbSelectArea("SE1")
DbSetOrder(7)
Dbgotop()
While !EOF() .AND. E1_VENCREA <= WEmiFin
  If E1_VENCTO<=CTOD("01/01/2000")
     DbSkip()
     Loop
  Endif
  If !Empty(E1_BAIXA) .or. E1_VENCREA>=Date()
     DbSkip()
     Loop
  Endif
  If E1_VENCREA >= WEmiIni
     Venc15 := Venc15 + E1_VALOR
  Endif
  VencTot := VencTot + E1_VALOR
  DbSkip()
End
Media:=(Venc15/VencTot)*100
  
@ 0,0 TO 190,280 DIALOG oDlg5 TITLE "Consulta % de Títulos Vencidos"
@ 3,5 TO 95,130

@ 12,14 SAY "Vencimento Inicial : "+Dtoc(wEmiIni)
@ 22,14 SAY "Vencimento Final   : "+Dtoc(wEmiFin)
@ 42,14 SAY "Títulos Vencidos (1 a 15 dias) : "+Transform(Venc15,"@E 999,999,999.99")
@ 52,14 SAY "Títulos Vencidos (Total)           : "+Transform(VencTot,"@E 999,999,999.99")
@ 62,14 SAY "Percentual de Títulos Vencidos :            "+Transform(Media,"@E 999")
@ 62,120 SAY "%"
@ 80,55 BMPBUTTON TYPE 1 ACTION OkProc2()// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> @ 105,155 BMPBUTTON TYPE 1 ACTION Execute(OkProc2)
ACTIVATE DIALOG oDlg5 CENTER

Close(oDlg1)

Return

****************
// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> Function OkProc2
Static Function OkProc2()
****************
Close(oDlg5)

Return
