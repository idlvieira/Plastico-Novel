#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

User Function POSPED()        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ POSPED    ³ Autor ³   Eliene Cerqueira   ³ Data ³ 26.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para Consultar posição dos pedidos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
SetPrvt("WLOCAL,CPROG1,CPROG2,AROTINA")
SetPrvt("CCADASTRO,")

cPROG1 := 'EXECBLOCK("VerPos")'
*
aRotina := {{"Pesquisa","AxPesqui",0,1},;
            {"Visualiza","AxVisual",0,2},;
            {"Posição",cProg1,0,3}}
cCadastro := "Pedidos"
Mbrowse(3,8,22,78,"SC5")

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04


// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotOk1
User Function VerPos()
***************       
xITEM_PED := {}
xPROD_PED := {}
xDESC_PED := {}
xQTDE_PED := {}
xSIT_PED := {}
dbSelectArea("SC9")
dbSetOrder(1)
dbSeek(xFilial("SC9")+SC5->C5_NUM,.F.)
If !Found()// Bloqueado em vendas
   MsgBox("PEDIDO BLOQUEADO EM VENDAS")
Else
   dbSelectArea("SC6")
   dbSetOrder(1)
   dbSeek(xFilial("SC6")+SC5->C5_NUM,.F.)
   While !EOF() .and. SC5->C5_NUM=SC6->C6_NUM
     AADD(xITEM_PED ,SC6->C6_ITEM)
     AADD(xPROD_PED ,SC6->C6_PRODUTO)
     AADD(xDESC_PED ,SC6->C6_DESCRI)
     XQUANT:=0
     BLCRED:="99"
     BLEST :="99"
     dbSelectArea("SC9")
     dbSetOrder(1)
     dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
     While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
        BLCRED:=C9_BLCRED               
        BLEST :=C9_BLEST
        XQUANT:=C9_QTDLIB
      	dbSkip()
     Enddo
     AADD(xQTDE_PED ,XQUANT)
     If BLCRED="10" .and. BLEST="10" // Já faturado
        AADD(xSIT_PED ,"JÁ FATURADO")
     ElseIf (BLCRED="01" .and. BLEST="02") .or. (BLCRED="01" .and. BLEST="  ") // Bloqueado no crédito
        AADD(xSIT_PED ,"BLOQUEADO NO CRÉDITO")
     ElseIf BLCRED="  " .and. BLEST="02" // Bloqueado no estoque
        AADD(xSIT_PED ,"BLOQUEADO NO ESTOQUE")
     ElseIf BLCRED="  " .and. BLEST="  "
        AADD(xSIT_PED ,"LIBERADO PARA FATURAR")
     Else
        AADD(xSIT_PED ," ")
     Endif
     dbSelectArea("SC6")
   	 dbSkip()
   Enddo
   @ 0,0 TO 350,610 DIALOG oDlg5 TITLE "Situação por Item"
   @ 3,5 TO 140,300
   @ 10,10 SAY "ITEM    PRODUTO"
   @ 10,200 SAY "QUANT.      SITUAÇÃO"
   lin:=20
   For I:=1 to Len(xITEM_PED)
     @ lin,10 SAY xITEM_PED[I] + "       " + xPROD_PED[I] + "-" + xDESC_PED[I]
     @ lin,200 SAY xQTDE_PED[I]
     @ lin,230 SAY xSIT_PED[I]
     lin := lin + 10
   Next
   @ 150,150 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
   ACTIVATE DIALOG oDlg5 CENTER
   
Endif
Return
