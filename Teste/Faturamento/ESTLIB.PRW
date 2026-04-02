#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02

User Function ESTLIB()        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ ESTLIB    ³ Autor ³  Eliene Cerqueira    ³ Data ³ 22.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para estorno da liberação parcial do pedido/item    ³±±
±±³            para ser executado após o cancelamento de NF ou depois de  ³±±
±±³            liberaçao parcial                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
SetPrvt("WCONTINUA")
SetPrvt("WPEDIDO,WITEM")
wPedido:=Space(6)
wItem:=Space(2)
WCONTINUA:=.T.
WHILE WCONTINUA
   LIB()
ENDDO
REturn

Static Function LIB()

QTDLIB:=0
@ 0,0 TO 120,500 DIALOG oDlg1 TITLE "Estorno Liberação Parcial de Pedido"
@ 3,5 TO 35,250

@ 12,12 SAY "Pedido :"
@ 22,12 SAY "Item   :"

@ 12,40 GET wPedido PICTURE X3Picture("C5_NUM") VALID NaoVazio() .and. ExistCpo("SC5")
/* @ 22,40 GET wItem   PICTURE X3Picture("C6_ITEM") VALID NaoVazio() .And. TSTITEM()   
*/   
@ 22,40 GET wItem   PICTURE "99" 

@ 40,40  BMPBUTTON TYPE 1 ACTION OkProc1()// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> @ 105,155 BMPBUTTON TYPE 1 ACTION Execute(OkProc2)
@ 40,100 BMPBUTTON TYPE 2 ACTION nseqCan1()
ACTIVATE DIALOG oDlg1 CENTER

Return

****************
// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> Function OkProc2
Static Function TSTITEM()
****************
//Close(oDlg1)

DbSelectArea("SC6")
DbSetOrder(1) // 
Dbgotop()
DbSeek(xFilial("SC6")+WPedido+WItem,.F.)
If EOF()
   Msgbox("Pedido/item não existe!")
   Return .F.
Endif

If SC6->C6_QTDVEN-SC6->C6_QTDENT = 0
   Msgbox("Pedido/item totalmente atendido!")
   Return .F.
Endif                 

@ 22,60 SAY C6_PRODUTO + " - " + C6_DESCRI

Return

****************
// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> Function OkProc2
Static Function OkProc1()
****************

xseq:="  "
FAZ:=.T.
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+SC6->C6_NUM,.F.)
DbSelectArea("SE4")
DbSetOrder(1)
DbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
DbSelectArea("SB1") 
DbSeek( xFilial("SB1") + SC6->C6_PRODUTO, .T.)
dbSelectArea("SC9")
dbSetOrder(1)
dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
   
If Found()
   While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
      If C9_BLCRED="10" .and. C9_BLEST="10" // Já faturado
         XSEQ:=C9_SEQUEN
         XOK :=C9_OK
         XFILIAL:=C9_FILIAL
         XCLIENTE:=C9_CLIENTE
         XLOJA:=C9_LOJA
         XPRODUTO:=C9_PRODUTO
         XDATALIB:=C9_DATALIB
         XGRUPO:=C9_GRUPO
         XPRCVEN:=C9_PRCVEN
         XLOCAL:=C9_LOCAL
         XCONDPAG:=C9_CONDPAG
         XDESCCP:=C9_DESCCP
      ElseIf (C9_BLCRED="01" .and. C9_BLEST="02") .or. (C9_BLCRED="01" .and. C9_BLEST="  ") // Bloqueado no crédito
         Msgbox("Pedido/Item está bloqueado no crédito!")
         FAZ:=.F.
      Else
         Reclock("SC9",.F.)
         SC9->( DBDELETE( ) )
         Dbunlock()
      Endif
   	  dbSkip()
   Enddo
Endif
If XSEQ="  "
   XOK :="  "
   XFILIAL:=SC6->C6_FILIAL
   XCLIENTE:=SC5->C5_CLIENTE
   XLOJA:=SC5->C5_LOJAENT
   XPRODUTO:=SC6->C6_PRODUTO
   XDATALIB:=SC5->C5_NOVULT
   XGRUPO:=SB1->B1_GRUPO
   XPRCVEN:=SC6->C6_PRCVEN
   XLOCAL:=SC6->C6_LOCAL
   XCONDPAG:=SC5->C5_CONDPAG
   XDESCCP:=SE4->E4_DESCRI
Endif

If FAZ
   XSEQ:=STRZERO(VAL(XSEQ)+1,3)
   XSLD:=SC6->C6_QTDVEN-SC6->C6_QTDENT
   XBLCRED:="  "
   XBLEST:="02"
   Reclock("SC9",.T.)
   C9_OK  := XOK
   C9_FILIAL:=XFILIAL
   C9_PEDIDO:=WPEDIDO
   C9_ITEM:=WITEM
   C9_CLIENTE:=XCLIENTE
   C9_LOJA:=XLOJA
   C9_PRODUTO:=XPRODUTO
   C9_QTDLIB:=XSLD
   C9_DATALIB:=XDATALIB
   C9_SEQUEN:=XSEQ
   C9_GRUPO:=XGRUPO
   C9_PRCVEN:=XPRCVEN
   C9_BLCRED:=XBLCRED
   C9_BLEST:=XBLEST
   C9_LOCAL:=XLOCAL
   C9_CONDPAG:=XCONDPAG
   C9_DESCCP:=XDESCCP
   MSUnlock()

   Reclock("SC5",.F.)
   C5_LIBEROK:="S"
   Dbunlock()
   
// Recalcula a reserva do produto   
   XQTDRES:=0
   dbSelectArea("SC6")
   dbSetOrder(2) // produto+pedido+item
   dbGoTop()
   dbSeek(xFilial("SC6")+XPRODUTO,.F.)	
   While !EOF() .AND. SC6->C6_PRODUTO=XPRODUTO
      dbSelectArea("SC5")
      dbSetOrder(1) 
      dbSeek(xFilial("SC5")+SC6->C6_NUM,.F.)	
      If !Found()
         dbSelectArea("SC6")
         dbSkip()
	     Loop
      Endif
      dbSelectArea("SC6")
      IF SC6->C6_TES$"508/515/516/517/521/522/523/524/528/529/531/536/537/538/543/544/545/546/547/548/549/550/555/556/557"
	     dbSkip()
    	 Loop
      Endif
      If SC6->C6_QTDVEN-SC6->C6_QTDENT = 0
    	 dbSkip()
         Loop
      Endif
      dbSelectArea("SC9")
      dbSetOrder(1)
      dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
      If !Found()// Bloqueado em vendas
         dbSelectArea("SC6")
     	 dbSkip()
         Loop
      Else
         While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
            BLCRED:=C9_BLCRED               
            BLEST :=C9_BLEST           
            DATLIB:=C9_DATALIB
            If BLCRED="  " .and. BLEST="  "
               XQTDRES:=XQTDRES+SC9->C9_QTDLIB
            Endif
        	dbSkip()
         Enddo
      Endif
      dbSelectArea("SC6")
	  dbSkip()
   Enddo
   dbSelectArea("SB2")
   Reclock("SB2",.F.)
   B2_RESERVA  := XQTDRES
   MSUnlock()
Endif
Close(oDlg1)

Return

Static Function nseqCan1()
***************
WCONTINUA:=.F.
Close(oDlg1)
Return
