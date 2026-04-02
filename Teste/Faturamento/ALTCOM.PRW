#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

User Function ALTCOM()        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ ALTCOM    ³ Autor ³   Eliene Cerqueira   ³ Data ³ 08.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para alteração de comissões para vendedor e suplente³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Call Center                                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
SetPrvt("WLOCAL,CPROG1,CPROG2,AROTINA")
SetPrvt("CCADASTRO,")

cPROG1 := 'EXECBLOCK("ALTCOMI")'
cPROG2 := 'EXECBLOCK("ALTCOMT")'
*
aRotina := {{"Pesquisa","AxPesqui",0,1},;
            {"Visualiza","AxVisual",0,2},;
            {"Alt.Individual",cProg1,0,3},;
            {"Alt.P/Grupo",cProg2,0,4}}
cCadastro := "Alteração de Comissões"
Mbrowse(3,8,22,78,"SB1")

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

User Function ALTCOMI()        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

SetPrvt("WSEQ,")

wPreco:=SB1->B1_PRV2
wCom1:=SB1->B1_COMIS
wCom2:=SB1->B1_CMSUPLE
@ 0,0 TO 140,210 DIALOG oDlg1 TITLE "Altera Comissões"
@ 3,5 TO 45,100
// Montagem dos titulos dos campos
@ 15,10 say  "Comissao Vendedor"
@ 25,10 say  "Comissao Suplente"

// Montagem dos campos
@ 15,60  GET  wCom1     PICTURE "@E 999.99" 
@ 25,60  GET  wCom2     PICTURE "@E 999.99" 

// Botoes
@  55,40 BMPBUTTON TYPE 1 ACTION nseqOk1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
@  55,70 BMPBUTTON TYPE 2 ACTION nseqCan1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
ACTIVATE DIALOG oDlg1 CENTER
REturn


// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotOk1
Static Function nseqOk1()
***************
Reclock("SB1",.F.)
SB1->B1_COMIS:=wCom1
SB1->B1_CMSUPLE:=wCom2
Dbunlock()
Close(oDlg1)
Return


// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotCan1
Static Function nseqCan1()
***************
Close(oDlg1)
Return

User Function ALTCOMT()        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

SetPrvt("WCONTINUA")
WCONTINUA:=.T.
WHILE WCONTINUA
   COMISSAO()
ENDDO
REturn

Static Function COMISSAO()

  wSubgru:= "  "
  wCom1:=0
  wCom2:=0
  @ 0,0 TO 230,430 DIALOG oDlg TITLE "Altera Comissao"
    @ 3,5 TO 90,210
    // Montagem dos titulos dos campos
    @ 20,10 say  "Sub-Grupo  "
    @ 40,10 say  "Comissao Vendedor"
    @ 50,10 say  "Comissao Suplente"

    // Montagem dos campos
    @ 20,50  GET  wSubgru   PICTURE X3Picture("B1_SUBGRUP") VALID NaoVazio() .and. ExistCpo("SZ1") .and. Mostrasub(wSubgru) F3 "SZ1"
    @ 40,60  GET  wCom1     PICTURE "@E 999.99" 
    @ 50,60  GET  wCom2     PICTURE "@E 999.99" 

    // Botoes
    @  95,65 BMPBUTTON TYPE 1 ACTION BotOk()// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==>     @  75,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
    @  95,95 BMPBUTTON TYPE 2 ACTION BotCan()// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==>     @  75,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
  ACTIVATE DIALOG oDlg CENTER
REturn

// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotOk1
Static Function MostraSub()
***************
@ 20,80  SAY SPACE(30)
dbSelectArea("SZ1")
DbSeek(xFilial("SZ1") + wSubgru, .T.)
@ 20,80  SAY  SZ1->Z1_DESC
dbSelectArea("SB1")
dbSetOrder(9)
DbSeek(xFilial("SB1") + wSubgru, .T.)
wCom1:=SB1->B1_COMIS
wCom2:=SB1->B1_CMSUPLE
Return

// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotOk1
Static Function BotOk()
***************
While SB1->( !Eof() ) .And. B1_SUBGRUP = WSUBGRU
   Reclock("SB1",.F.)
   SB1->B1_COMIS:=wCom1
   SB1->B1_CMSUPLE:=wCom2
   Dbunlock()          
   SB1->( DbSkip() )       
Enddo
Close(oDlg)
Return

// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotCan1
Static Function BotCan()
***************
Close(oDlg)
WCONTINUA:=.F.
Return
