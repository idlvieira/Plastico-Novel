#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04
#INCLUDE "TOPCONN.CH"

User Function COPPREV()        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ COPPREV   ³ Autor ³   Eliene Cerqueira   ³ Data ³ 24.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Copia Previsão de Vendas de um mes para outro              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

SetPrvt("WMESO,WANOO,WMESD,WANOD")

wMesO:=0
wMesD:=0
wAnoO:=0
wAnoD:=0
@ 0,0 TO 120,210 DIALOG oDlg5 TITLE "Copia Previsão de Vendas"
@ 3,5 TO 35,100

@ 12,12 SAY "Mes/Ano Origem  :      /"
@ 22,12 SAY "Mes/Ano Destino :      /"

@ 12,58 GET  wMesO   PICTURE "99" VALID naovazio() .And. TSTMES1() 
@ 12,78 GET  wAnoO   PICTURE "9999" VALID naovazio() .And. TSTANO1()
@ 22,58 GET  wMesD   PICTURE "99" VALID naovazio() .And. TSTMES2()
@ 22,78 GET  wAnoD   PICTURE "9999" VALID naovazio() .And. TSTANO2()

@ 40,40 BMPBUTTON TYPE 1 ACTION OkProc1()// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> @ 105,155 BMPBUTTON TYPE 1 ACTION Execute(OkProc2)
@ 40,70 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5 CENTER

Return

****************
// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> Function OkProc2
Static Function OkProc1()
****************

WdataI:=Ctod("01/"+Strzero(WmesO,2)+"/"+Strzero(WanoO,4))
If WmesO<12
   WdataF:=Ctod("01/"+Strzero(WmesO+1,2)+"/"+Strzero(WanoO,4))-1
Else
   WdataF:=Ctod("01/01/"+Strzero(WanoO+1,4))-1
Endif
WdataDI:=Ctod("01/"+Strzero(WmesD,2)+"/"+Strzero(WanoD,4))
If WmesD<12
   WdataDF:=Ctod("01/"+Strzero(WmesD+1,2)+"/"+Strzero(WanoD,4))-1
Else
   WdataDF:=Ctod("01/01/"+Strzero(WanoD+1,4))-1
Endif
DbSelectArea("SC4")
DbSetOrder(2) // C4_DATA
Dbgotop()
DbSeek(xFilial("SC4")+Dtos(WdataDI),.T.)
If !EOF() .AND. C4_DATA <= WdataDF
   Msgbox("Mes/Ano Destino já existe!")
   Return()
Endif

cQry := " SELECT SC4.C4_PRODUTO, SC4.C4_QUANT FROM SC4010 AS SC4"
cQry := cQry + " WHERE SC4.C4_DATA = '"+Dtos(WdataF)+"'"
cQry := cQry + " AND SC4.D_E_L_E_T_<>'*'"

Tcquery cQry new alias "PREV"

DbSelectArea("PREV")
Dbgotop()
While PREV->( !Eof() )
  DbSelectArea("SC4")
  Reclock("SC4",.T.)
  SC4->C4_FILIAL  := "01"
  SC4->C4_PRODUTO := PREV->C4_PRODUTO
  SC4->C4_DATA    := WdataDF
  SC4->C4_QUANT   := PREV->C4_QUANT
  SC4->C4_LOCAL   := "01"
  MSUnlock()                           
  PREV->( DbSkip() )
End

DbSelectArea("PREV")
dbCloseArea()
Close(oDlg5)
Return

Static Function TSTMES1()
   If wMesO < 1 .or. wMesO > 12
      Msgbox("Mes inválido!")
      wMesO = 0
      Return .F.
   Endif
Return     

Static Function TSTMES2()
   If wMesD < 1 .or. wMesD > 12
      Msgbox("Mes inválido!")
      wMesD = 0
      Return .F.
   Endif
Return     

Static Function TSTANO1()
   If wANOO < 2001 .or. wANOO > 2015
      Msgbox("Ano inválido!")
      wANOO = 0
      Return .F.
   Endif
Return     

Static Function TSTANO2()
   If wANOD < 2001 .or. wANOD > 2015
      Msgbox("Ano inválido!")
      wANOD = 0
      Return .F.
   Endif
Return     

