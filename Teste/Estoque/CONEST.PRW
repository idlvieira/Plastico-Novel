#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

User Function CONEST()        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

SetPrvt("WCONTINUA")
WCONTINUA:=.T.
WHILE WCONTINUA
   TLPROD()
ENDDO
REturn

Static Function TLPROD()
wProd:=Space(15)
walx:=space(2)
@ 0,0 TO 180,430 DIALOG oDlg1 TITLE "Saldos em Estoque e Reserva"
@ 3,5 TO 60,210
@ 15,10 say  "Produto :"
@ 35,10 say  "Alx     :"        
@ 15,35 GET  wProd SIZE  50,20 PICTURE "999999999999999" VALID NaoVazio() F3 "SB1"
@ 35,35 GET  walx  SIZE  10,1  PICTURE "@!" valid NaoVazio()          
@  70,070 BMPBUTTON TYPE 1 ACTION nseqOk1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
@  70,100 BMPBUTTON TYPE 2 ACTION nseqCan1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
ACTIVATE DIALOG oDlg1 CENTER
REturn

Static Function nseqOk1()
***************
QATU:=RES:=EMP:=DISP:=0
dbSelectArea("SB1")
DbSeek(xFilial("SB1") + wProd, .T.)
If found() .AND. B1_COD=wProd
   WDESC:=SB1->B1_DESC
   dbSelectArea("SB2")
   DbSeek(xFilial("SB2") + wProd + walx, .T.)
   If Found()
      QATU:= SB2->B2_QATU
      RES:=  SB2->B2_RESERVA
//      EMP:=  SB2->B2_QEMP
//      DISP:= SB2->B2_QATU-(SB2->B2_RESERVA + SB2->B2_QEMP)
      DISP:= SB2->B2_QATU-SB2->B2_RESERVA
   Endif          
   Mostra()
Endif         
Close(oDlg1)
REturn

Static Function nseqCan1()
***************
WCONTINUA:=.F.
Close(oDlg1)
Return


Static Function Mostra()
*********************

@ 0,0 TO 190,430 DIALOG oDlg5 TITLE "Saldos em Estoque"
@ 3,5 TO 80,210
@ 15,10 say "Produto   :  " + WPROD + " -   " + WDESC
@ 25,10 SAY "Saldo Atual         : " + Transform(QATU,"@E 999,999.99")
@ 35,10 SAY "Qtd. Reservada  : " + Transform(RES,"@E 999,999.99")
@ 45,10 SAY "Qtd. Empenhada  : " + Transform(EMP,"@E 999,999.99")
@ 55,10 SAY "Saldo Disponível : " + Transform(DISP,"@E 999,999.99")
@ 80,100 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5 CENTER

Return