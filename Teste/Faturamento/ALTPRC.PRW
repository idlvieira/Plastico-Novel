#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

User Function ALTPRC()        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ ALTPRC    ³ Autor ³   Eliene Cerqueira   ³ Data ³ 08.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para Alteração de preços de produtos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Call Center                                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
SetPrvt("WLOCAL,CPROG1,CPROG2,AROTINA")
SetPrvt("CCADASTRO,")

cPROG1 := 'EXECBLOCK("altprcI")'
cPROG2 := 'EXECBLOCK("altprcT")'
*
aRotina := {{"Pesquisa","AxPesqui",0,1},;
            {"Visualiza","AxVisual",0,2},;
            {"Alt.Individual",cProg1,0,3},;
            {"Alt.P/Grupo",cProg2,0,4}}
cCadastro := "Alteração de Preços"
Mbrowse(3,8,22,78,"SB1")

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

User Function altprcI()        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

SetPrvt("WSEQ,")

wPreco:=SB1->B1_PRV2
@ 0,0 TO 120,210 DIALOG oDlg1 TITLE "Altera Preço"
@ 3,5 TO 35,100
// Montagem dos titulos dos campos
@ 15,10 say  "Preco      "

// Montagem dos campos
@ 15,50 GET  wPreco PICTURE "@E 999.99" VALID NaoVazio()

// Botoes
@  45,40 BMPBUTTON TYPE 1 ACTION nseqOk1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
@  45,70 BMPBUTTON TYPE 2 ACTION nseqCan1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
ACTIVATE DIALOG oDlg1 CENTER
REturn


// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotOk1
Static Function nseqOk1()
***************
Reclock("SB1",.F.)
SB1->B1_PRV2:=wPreco
Dbunlock()
Close(oDlg1)
Return


// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotCan1
Static Function nseqCan1()
***************
Close(oDlg1)
Return

// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotOk1
User Function altprcT()
***************

SetPrvt("WCONTINUA")
WCONTINUA:=.T.
WHILE WCONTINUA
   PRECO()
ENDDO
REturn

Static Function PRECO()

  wGrupo:= "    "
  wSubgru:= "  "
  wClas1:= "   "
  wClas2:= "  "           
  wPreco:=0
  @ 0,0 TO 230,430 DIALOG oDlg TITLE "Altera Preço"
    @ 3,5 TO 90,210
    // Montagem dos titulos dos campos
    @ 20,10 say  "Grupo      "
    @ 30,10 say  "Sub-Grupo  "
    @ 40,10 say  "Classific 1"
    @ 50,10 say  "Classific 2"
    @ 70,10 say  "Preco      "

    // Montagem dos campos
    @ 20,50  GET  wGrupo    PICTURE X3Picture("B1_Grupo") VALID NaoVazio() .and. ExistCpo("SBM") .and. Mostragru(wGrupo) F3 "SBM"
    @ 30,50  GET  wSubgru   PICTURE X3Picture("B1_SUBGRUP") VALID NaoVazio() .and. ExistCpo("SZ1") .and. Mostrasub(wSubgru) F3 "SZ1"
    @ 40,50  GET  wClas1    PICTURE X3Picture("B1_CLASSE1") VALID NaoVazio() .and. ExistCpo("SZ2") .and. Mostracl1(wClas1) F3 "SZ2"  
    @ 50,50  GET  wClas2    PICTURE X3Picture("B1_CLASSE2") VALID Mostracl2(wClas2) F3 "SZ3"  
    @ 70,50  GET  wPreco    PICTURE "@E 9,999.99" 

    // Botoes
    @  95,65 BMPBUTTON TYPE 1 ACTION BotOk()// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==>     @  75,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
    @  95,95 BMPBUTTON TYPE 2 ACTION BotCan()// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==>     @  75,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
  ACTIVATE DIALOG oDlg CENTER
REturn

// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotOk1
Static Function MostraGru()
***************
dbSelectArea("SBM")
DbSeek(xFilial("SBM") + wGrupo, .T.)
@ 20,80  SAY  SBM->BM_DESC

Return

// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotOk1
Static Function MostraSub()
***************
dbSelectArea("SZ1")
DbSeek(xFilial("SZ1") + wSubgru, .T.)
@ 30,80  SAY  SZ1->Z1_DESC

Return
// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotOk1
Static Function MostraCl1()
***************
dbSelectArea("SZ2")
DbSeek(xFilial("SZ2") + wClas1, .T.)
@ 40,80  SAY  SZ2->Z2_DESC

Return                  

// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotOk1
Static Function MostraCl2()
***************
If wClas2<>"  "
   dbSelectArea("SZ3")
   DbSeek(xFilial("SZ3") + wClas2, .T.)
   @ 50,80  SAY  SZ3->Z3_DESC
   dbSelectArea("SB1")
   dbSetOrder(8)
   DbSeek(xFilial("SB1") + wGrupo + wSubgru + wClas1 + wClas2, .F.)
   If !Found()
      Msgbox("Produtos não existem!")
      Return
   Endif
Else
   dbSelectArea("SB1")
   dbSetOrder(8)
   DbSeek(xFilial("SB1") + wGrupo + wSubgru + wClas1, .F.)
   If !Found()
      Msgbox("Produtos não existem!")
      Return
   Endif                                            
Endif
wPreco:=SB1->B1_PRV2

Return

// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotOk1
Static Function BotOk()
***************
If wClas2<>"  "
   While SB1->( !Eof() ) .And. B1_GRUPO = WGRUPO .And. B1_SUBGRUP = WSUBGRU .And. B1_CLASSE1 = WCLAS1 .And. B1_CLASSE2 = WCLAS2
      Reclock("SB1",.F.)
      SB1->B1_PRV2:=wPreco
      Dbunlock()          
      SB1->( DbSkip() )       
   Enddo
Else
   While SB1->( !Eof() ) .And. B1_GRUPO = WGRUPO .And. B1_SUBGRUP = WSUBGRU .And. B1_CLASSE1 = WCLAS1
      Reclock("SB1",.F.)
      SB1->B1_PRV2:=wPreco
      Dbunlock()          
      SB1->( DbSkip() )       
   Enddo
Endif
Close(oDlg)

Return

// Substituido pelo assistente de conversao do AP6 IDE em 08/05/03 ==> Function BotCan1
Static Function BotCan()
***************
Close(oDlg)
WCONTINUA:=.F.
Return

