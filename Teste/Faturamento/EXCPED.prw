#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

User Function EXCPED()        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ EXCPED    ³ Autor ³ Eliene Cerqueira     ³ Data ³ 01.11.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Excluir pedido de venda já liberado                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

SetPrvt("WLOCAL,CPROG1,CPROG2,CPROG3,CPROG4,AROTINA")
SetPrvt("CCADASTRO,")

cPROG1 := 'EXECBLOCK("exclui")'
*
aRotina := {{"Pesquisa","AxPesqui",0,1},;
            {"Visualiza","AxVisual",0,2},;
            {"Exclui Pedido",cProg1,0,5}}
cCadastro := "Pedidos de Venda"
Mbrowse(3,8,22,78,"SC5")

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

User Function exclui()        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

If !Empty(C5_NOTA)
   MsgBox("PEDIDO TOTALMENTE FATURADO!")
   Return
Endif               

dbSelectArea("SC2")
dbSetOrder(9)
dbSeek(xFilial("SC2")+SC5->C5_NUM,.F.)
If Found()
   MsgBox("PEDIDO GEROU ORDEM DE PRODUÇÃO!")
   Return
Endif               
IF  MsgBox("CONFIRMA EXCLUSAO??","CONFIRMA ?","YESNO")
    delOK1()
ENDIF

REturn

// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotOk1
Static Function delOk1()
***************
PODE:=.T.
dbSelectArea("SC6")
dbSetOrder(1) // pedido+item
dbSeek(xFilial("SC6")+SC5->C5_NUM,.F.)	
While !EOF() .AND. SC6->C6_NUM=SC5->C5_NUM
    If SC6->C6_QTDENT <> 0
       MsgBox("JÁ TEM ITEM FATURADO!")
       PODE:=.F.
    Endif               
    If !Empty(SC6->C6_ROMAN)
       MsgBox("JÁ ESTÁ NO ROMANEIO!")
       PODE:=.F.
    Endif               
    dbSkip()
Enddo
If PODE
   dbSelectArea("SC9")
   dbSetOrder(1)
   dbSeek(xFilial("SC9")+SC5->C5_NUM,.F.)
   
   If Found()
      While !EOF() .AND. SC5->C5_NUM=SC9->C9_PEDIDO
         If SC9->C9_BLCRED="  " .and. SC9->C9_BLEST="  "
            dbSelectArea("SB2")
            Reclock("SB2",.F.)
            B2_RESERVA  := B2_RESERVA-SC9->C9_QTDLIB
            B2_QACLASS := 0
            MSUnlock()
         Endif
         Reclock("SC9",.F.)
         SC9->( DBDELETE( ) )
         Dbunlock()
         dbSkip()
      Enddo
   Endif

   dbSelectArea("SC6")
   dbSetOrder(1) // pedido+item
   dbSeek(xFilial("SC6")+SC5->C5_NUM,.F.)	
   While !EOF() .AND. SC5->C5_NUM=SC6->C6_NUM
      Reclock("SC6",.F.)
      SC6->( DBDELETE( ) )
      Dbunlock()
      dbSkip()
   Enddo
   Reclock("SC5",.F.)
   SC5->( DBDELETE( ) )
   Dbunlock()
Endif
Return

