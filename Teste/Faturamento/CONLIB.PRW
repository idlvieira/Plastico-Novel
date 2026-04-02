#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

User Function CONLIB()        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

wPed:=Space(6)
wItem:=Space(2)
SetPrvt("WCONTINUA")
WCONTINUA:=.T.
WHILE WCONTINUA
   TLPROD()
ENDDO
REturn

Static Function TLPROD()
@ 0,0 TO 230,430 DIALOG oDlg1 TITLE "Consulta Liberação Estoque"
@ 3,5 TO 90,210
@ 12,12 SAY "Pedido :"
@ 22,12 SAY "Item   :"
@ 12,40 GET wPed    PICTURE X3Picture("C5_NUM") VALID NaoVazio() .and. ExistCpo("SC5")
@ 22,40 GET wItem   PICTURE X3Picture("C6_ITEM") VALID NaoVazio()
@ 100,070 BMPBUTTON TYPE 1 ACTION nseqOk1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
@ 100,100 BMPBUTTON TYPE 2 ACTION nseqCan1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
ACTIVATE DIALOG oDlg1 CENTER
REturn

****************
// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> Function OkProc2
Static Function nseqOk1()
****************
//Close(oDlg1)

DbSelectArea("SC6")
DbSetOrder(1) // 
Dbgotop()
DbSeek(xFilial("SC6")+WPed+WItem,.F.)
If EOF()
   Msgbox("Pedido/item não existe!")
   Return .F.
Endif

If SC6->C6_QTDVEN-SC6->C6_QTDENT = 0
   Msgbox("Pedido/item totalmente atendido!")
   Return .F.
Endif                 

dbSelectArea("SC9")
dbSetOrder(1)
dbSeek(xFilial("SC9")+wPed+wItem,.F.)
   
If !Found()// Bloqueado em vendas
   Msgbox("Pedido está bloqueado em vendas!")
   Return .F.
Else
   While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
   	  dbSkip()
   Enddo
   dbSkip(-1)
   If C9_BLCRED="10" .and. C9_BLEST="10" // Já faturado
      Msgbox("Pedido já foi totalmente faturado!")
      Return .F.
   ElseIf (C9_BLCRED="01" .and. C9_BLEST="02") .or. (C9_BLCRED="01" .and. C9_BLEST="  ") // Bloqueado no crédito
      Msgbox("Pedido está bloqueado no crédito!")
      Return .F.
   Else
      QLIB:=C9_QTDLIB
   Endif
Endif

dbSelectArea("SB2")
DbSeek(xFilial("SB2") + SC6->C6_PRODUTO, .T.)
Mostra()
Close(oDlg1)

REturn

Static Function Mostra()
*********************

@ 0,0 TO 230,430 DIALOG oDlg5 TITLE "Consulta Liberação Estoque"
@ 3,5 TO 90,210
@ 12,12 SAY "Pedido : " + wPed
@ 22,12 SAY "Item   : " + wItem
@ 22,60 SAY SC6->C6_PRODUTO + " - " + SC6->C6_DESCRI
If SC9->C9_BLCRED="  " .and. SC9->C9_BLEST="  "
   @ 42,12 SAY "QTDE JÁ LIBERADA : " + Transform(QLIB,"@E 999,999.99")
Else
   @ 42,12 SAY "QTDE P/LIBERAR     : " + Transform(QLIB,"@E 999,999.99")
   @ 52,12 SAY "SB2->B2_QATU      : " + Transform(SB2->B2_QATU,"@E 999,999.99")
   @ 62,12 SAY "SB2->B2_RESERVA : " + Transform(SB2->B2_RESERVA,"@E 999,999.99")
   @ 72,12 SAY "SB2->B2_QACLASS : " + Transform(SB2->B2_QACLASS,"@E 999,999.99")
   @ 82,12 SAY "QTDE DISPONIVEL   : " + Transform(SB2->B2_QATU-SB2->B2_RESERVA-SB2->B2_QACLASS,"@E 999,999.99")
Endif
@ 100,100 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5 CENTER

Static Function nseqCan1()
***************
WCONTINUA:=.F.
Close(oDlg1)
Return
