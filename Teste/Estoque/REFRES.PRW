#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04
#INCLUDE "TOPCONN.CH"

User Function REFRES()   // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ REFRES    ³ Autor ³   Eliene Cerqueira   ³ Data ³ 07.03.05    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para refazer a reserva B2_RESERVA por ordem da entrega ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Call Center                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

SetPrvt("CPROG1,AROTINA,CCADASTRO")

@ 0,0 TO 140,310 DIALOG oDlg5 TITLE "Atualiza Reserva"
@ 3,5 TO 40,150

@ 10,10 SAY "ANTES DE EXECUTAR ESTA ROTINA, "
@ 20,10 SAY "PEÇA AO SETOR DE COBRANÇA E AO "
@ 30,10 SAY "ASSESSOR DE VENDAS PARA SAÍREM DO SISTEMA" 

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
Close(oDlg5)
Return

Static Function RunProc()
DbSelectArea("SB2")
DbSetOrder(1) // B2_COD+B2_LOCAL
dbGoTop()
ProcRegua(RecCount()) 
While !EOF()
  IncProc()                
  Reclock("SB2",.F.)
  B2_RESERVA:=0
  B2_QACLASS := 0
  B2_QPEDVEN:=0
  Dbunlock()     
  DbSkip()
End

cQry := " SELECT SC5.C5_NUM, SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_QTDENT"
cQry := cQry + " FROM SC5010 AS SC5, SC6010 AS SC6, SF4010 AS SF4"
cQry := cQry + " WHERE SC5.C5_NUM = SC6.C6_NUM"
cQry := cQry + " AND SC6.C6_QTDVEN-SC6.C6_QTDENT>0"
cQry := cQry + " AND SC6.C6_TES NOT  IN ('508', '515', '516', '517', '521', '522', '523', '524', '528', '529', '531', '536', '537', '543', '544', '545', '546', '547', '548', '549', '550', '555', '556', '557')"

cQry := cQry + " AND SC6.C6_TES=SF4.F4_CODIGO"
cQry := cQry + " AND SF4.F4_DUPLIC='S'"

cQry := cQry + " AND SC6.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SC6.C6_PRODUTO, SC6.C6_NUM, SC6.C6_ITEM ASC"

Tcquery cQry new alias "REF"

DbSelectArea("REF")
dbGoTop()
ProcRegua(RecCount()) 
While !EOF()
  IncProc()                
  dbSelectArea("SC9")
  dbSetOrder(1)
  dbSeek(xFilial("SC9")+REF->C6_NUM+REF->C6_ITEM,.F.)
   
  If !Found() // Bloqueado em vendas
     dbSelectArea("REF")
  	 dbSkip()
	 Loop
  Else
     While !EOF() .AND. REF->C6_NUM=SC9->C9_PEDIDO .AND. REF->C6_ITEM=SC9->C9_ITEM
        BLCRED:=C9_BLCRED               
        BLEST :=C9_BLEST
   	    dbSkip()
     Enddo
     dbSkip(-1)
     If BLCRED="10" .and. BLEST="10" // Já faturado
        dbSelectArea("REF")
        dbSkip()
	    Loop
	 ElseIf (BLCRED="01" .and. BLEST="02") .or. (BLCRED="01" .and. BLEST="  ")  // Bloqueado no crédito
        dbSelectArea("REF")
        dbSkip()
	    Loop
	 Else
        // Bloqueado no estoque (BLCRED="  " .and. BLEST="02") // Liberado para faturar (BLCRED="  " .and. BLEST="  " )
        dbSelectArea("SB2")
        dbSetOrder(1)
        dbSeek(xFilial("SB2")+REF->C6_PRODUTO+"01",.F.)
        IF SB2->B2_QATU - SB2->B2_RESERVA - SC9->C9_QTDLIB >= 0
           Reclock("SB2",.F.)
           B2_RESERVA:=B2_RESERVA+SC9->C9_QTDLIB
           B2_QACLASS := 0
           Dbunlock()     
           dbSelectArea("SC9")
           Reclock("SC9",.F.)
           C9_BLCRED:="  "
           C9_BLEST:="  "
           Dbunlock()
        Else           
           dbSelectArea("SC9")
           Reclock("SC9",.F.)
           C9_BLEST:="02"
           Dbunlock()
        Endif
        dbSelectArea("REF")
        dbSkip()
     Endif
  Endif
End

Return
