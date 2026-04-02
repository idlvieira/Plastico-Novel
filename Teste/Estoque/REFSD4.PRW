#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04
#INCLUDE "TOPCONN.CH"

User Function REFSD4()   // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ REFSD4    ³ Autor ³   Eliene Cerqueira   ³ Data ³ 29.12.05    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Elimina empenhos de OP´s já encerradas                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Estoque                                                       ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

SetPrvt("CPROG1,AROTINA,CCADASTRO")

@ 0,0 TO 140,310 DIALOG oDlg5 TITLE "Atualiza SD4"
@ 3,5 TO 40,150

@ 50,45 BMPBUTTON TYPE 1 ACTION OkProc1()// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> @ 105,155 BMPBUTTON TYPE 1 ACTION Execute(OkProc2)
@ 50,75 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5 CENTER
Return

****************
// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> Function OkProc2
Static Function OkProc1()
****************
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP6 IDE em 22/04/04 ==> Processa( {|| Execute(RunProc) } )
DbSelectArea("REF")
dbCloseArea()
Return

Static Function RunProc()
/*
cQry := " SELECT CONCAT(CONCAT(SC2010.C2_NUM, SC2010.C2_ITEM), SC2010.C2_SEQUEN) AS OP, SC2010.C2_PRODUTO, "
cQry := cQry + " SC2010.C2_QUANT - SC2010.C2_QUJE - SC2010.C2_PERDA AS SALDOOP, "
cQry := cQry + " SC2010.C2_DATRF AS DTFECHA, SD4010.D4_QUANT AS SALDOEMP"
cQry := cQry + " FROM SC2010 AS SC2010, SD4010 AS SD4010"
cQry := cQry + " WHERE SD4010.D4_OP = CONCAT(CONCAT(SC2010.C2_NUM, SC2010.C2_ITEM), SC2010.C2_SEQUEN) "
cQry := cQry + " AND SD4010.D4_QUANT > 0 "
cQry := cQry + " AND (SC2010.C2_QUANT - SC2010.C2_QUJE - SC2010.C2_PERDA = 0 OR SC2010.C2_DATRF <> '        ')"

Tcquery cQry new alias "REF"

DbSelectArea("REF")
dbGoTop()
ProcRegua(RecCount()) 
While !EOF()
  IncProc()                
  dbSelectArea("SD4")
  dbSetOrder(2)
  dbSeek(xFilial("SD4")+REF->OP,.F.)
   
  WHILE !EOF() .AND. SD4->D4_OP=REF->OP
     Reclock("SD4",.F.)
     D4_QUANT:=0
     Dbunlock()     
     dbSkip()
  End
  dbSelectArea("REF")
  dbSkip()
End
       

DbSelectArea("SB2")
dbGoTop()
ProcRegua(RecCount()) 
While !EOF()
  IncProc()                
  Reclock("SB2",.F.)
  B2_QEMP:=0
  Dbunlock()     
  dbSkip()
End
*/
cQry := " SELECT SD4.D4_COD, SUM(SD4.D4_QUANT) AS SALDO"
cQry := cQry + " FROM SD4010 AS SD4"
cQry := cQry + " WHERE SD4.D4_QUANT > 0"
cQry := cQry + " AND SD4.D_E_L_E_T_<>'*'"
cQry := cQry + " GROUP BY SD4.D4_COD"

Tcquery cQry new alias "REF"
DbSelectArea("REF")
dbGoTop()
ProcRegua(RecCount()) 
While !EOF()
  IncProc()                
  dbSelectArea("SB2")
  dbSetOrder(1)
  dbSeek(xFilial("SB2")+REF->D4_COD,.F.)
   
  IF FOUND()
     Reclock("SB2",.F.)
     B2_QEMP:=REF->SALDO
     Dbunlock()     
  End
  dbSelectArea("REF")
  dbSkip()
End

Return
