#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03
#INCLUDE "TOPCONN.CH"

User Function GERROMAN()        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ GERROMAN  ³ Autor ³   Eliene Cerqueira   ³ Data ³ 02.05.05    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para gerar romaneio                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

wnrel  	:= "ROMANEIO"    
titulo 	:= "ROMANEIO"
cDesc1 	:= "Este programa ira emitir o romaneio"
cDesc2 	:= ""
cDesc3 	:= ""
tamanho	:= "G"
limite 	:= 80
cString := "SC6"
lEnd    := .F.
cabec1 	:= "" 
cabec2 	:= ""
lContinua  := .T.
LI       := 80
m_pag      := 1
nLastKey := 0
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"

cArqTrb1:=cArqTrb2:=cArqTrb3:=""
Processa({|| IMPROM() },"Gerando Arquivo para Romaneio...")
DbSelectArea("EXP")
dbCloseArea()
If !Empty( cArqTrb1 )
   dbSelectArea("QUERY1")
   dbCloseArea()
   FErase( cArqTrb1+".*")
Endif
If !Empty( cArqTrb2 )
   dbSelectArea("QUERY2")
   dbCloseArea()
   FErase( cArqTrb2+".*")
Endif
If !Empty( cArqTrb3 )
   dbSelectArea("QUERY3")
   dbCloseArea()
   FErase( cArqTrb3+".*")
Endif

Return

Static Function IMPROM()

SetPrvt("WCONTINUA")

aStru:={}
AADD( aStru, {"PEDIDO"  ,"C" ,6 ,0} )
AADD( astru, {"CLIENTE" ,"C" ,6 ,0} )
AADD( astru, {"CIDADE"  ,"C" ,20,0} )
AADD( astru, {"UF"      ,"C" ,2 ,0} )
AADD( astru, {"PAGTO"   ,"C" ,25,0} )
AADD( aStru, {"STATUS"  ,"C" ,1 ,0} ) // Parcial, Total ou Branco
AADD( aStru, {"TOTQTD"  ,"N" ,18,2} ) 
AADD( aStru, {"TOTPESO" ,"N" ,18,2} ) 
AADD( aStru, {"TOTCUB"  ,"N" ,18,2} ) 
AADD( astru, {"MARCA"   ,"C" ,1 ,0} )
AADD( aStru, {"FRETE"   ,"C" ,30 ,0} ) 
AADD( aStru, {"OBS1"    ,"C" ,200,0} ) 
AADD( astru, {"ENTREGA" ,"D" ,8  ,0} ) // A menor data de entrega dos itens
cArqTrb1:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb1,"QUERY1",.F.)
IndRegua("QUERY1",cArqTrb1,"PEDIDO")

aStru:={}
AADD( aStru, {"PEDIDO"  ,"C" ,6 ,0} )
AADD( astru, {"ITEM"    ,"C" ,2 ,0} )
AADD( astru, {"PRODUTO" ,"C" ,14 ,0} )
AADD( astru, {"DESCPRO" ,"C" ,40,0} )
AADD( astru, {"TPEMB"   ,"C" ,10,0} )
AADD( astru, {"QUANT"   ,"N" ,18,2} ) 
AADD( astru, {"PESO"    ,"N" ,18,2} ) 
AADD( astru, {"CUB"    ,"N" ,18,2} ) 
cArqTrb2:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb2,"QUERY2",.F.)
IndRegua("QUERY2",cArqTrb2,"PEDIDO+ITEM")

cQry := " SELECT SC5.C5_NUM, SC5.C5_CLIENTE, SA1.A1_NREDUZ, SA1.A1_MUN, SA1.A1_EST, SC5.C5_TPFRETE, SC5.C5_CIF_ATE, SC5.C5_EMISSAO," 
cQry := cQry + " SC5.C5_NOVULT, SC6.C6_ITEM, SC6.C6_PRODUTO, SB1.B1_DESC, SB1.B1_TPEMB, SB1.B1_QE, SB1.B1_PESO,"
cQry := cQry + " SB1.B1_PESOEMB, SB1.B1_PSE, SB1.B1_CLASSE1, SC6.C6_ENCOMED, SC6.C6_QTDVEN,"
cQry := cQry + " SC6.C6_QTDENT, SC6.C6_VALOR, SC6.C6_ENTREG, SC5.C5_MUNE, SC5.C5_ESTE, SC5.C5_CONDPAG, SC5.C5_TRANSP,"
cQry := cQry + " SC5.C5_OBS1, SC5.C5_OBS2, SC5.C5_OBS3, SC5.C5_VOLUME1, SC5.C5_ESPECI1, SA4.A4_NREDUZ, SE4.E4_DESCRI"
cQry := cQry + " FROM DB2ADMIN.SC5010 AS SC5, DB2ADMIN.SC6010 AS SC6, DB2ADMIN.SA1010 AS SA1, DB2ADMIN.SB1010 AS SB1, DB2ADMIN.SA4010 AS SA4, DB2ADMIN.SE4010 AS SE4"
cQry := cQry + " WHERE SC5.C5_NUM = SC6.C6_NUM"
cQry := cQry + " AND SC6.C6_ROMAN='      '"
cQry := cQry + " AND SC6.C6_QTDVEN-SC6.C6_QTDENT>0"
cQry := cQry + " AND SA1.A1_COD = SC5.C5_CLIENTE"
cQry := cQry + " AND SA1.A1_LOJA = SC5.C5_LOJACLI" 
cQry := cQry + " AND SB1.B1_COD = SC6.C6_PRODUTO" 
cQry := cQry + " AND SA4.A4_COD = SC5.C5_TRANSP" 
cQry := cQry + " AND SE4.E4_CODIGO = SC5.C5_CONDPAG" 
cQry := cQry + " AND SC5.C5_TIPO = 'N'"
cQry := cQry + " AND SC6.C6_TES NOT  IN ('508', '515', '516', '517', '521', '522', '523', '524', '528', '529', '531', '536', '537', '543', '544', '545', '546', '547', '548', '549', '550', '555', '556', '557')"
cQry := cQry + " AND SC6.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SC5.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SC6.C6_ENTREG, SC5.C5_NUM, SC6.C6_ITEM ASC"

Tcquery cQry new alias "EXP"

dbSelectArea("EXP")
ProcRegua(RecCount()) 
Do While !Eof()
   IncProc()
   xStatus:="T"                                 
   DtEntr:=DTOS(CTOD("31/12/2090"))
   GRAVA:=.F.
   TQtd:=TPESO:=TCUB:=0
   XNUM:=EXP->C5_NUM
   XCLI:=EXP->C5_CLIENTE
   XMUN:=EXP->A1_MUN
   XUF :=EXP->A1_EST
   X4DS:=EXP->E4_DESCRI
   XTPF:=EXP->C5_TPFRETE
   XATE:=EXP->C5_CIF_ATE
   XOBS:= ALLTRIM(EXP->C5_OBS1)+" "+ALLTRIM(EXP->C5_OBS2)+" "+ALLTRIM(EXP->C5_OBS3)
   While !EOF() .AND. EXP->C5_NUM=XNUM
      dbSelectArea("SC9")
      dbSetOrder(1)
      dbSeek(xFilial("SC9")+EXP->C5_NUM+EXP->C6_ITEM,.F.)
   
      If !Found()// Bloqueado em vendas
         xStatus:="P"        
      Else
         While !EOF() .AND. EXP->C5_NUM=SC9->C9_PEDIDO .AND. EXP->C6_ITEM=SC9->C9_ITEM
            BLCRED:=C9_BLCRED               
            BLEST :=C9_BLEST           
            XQUANT:=SC9->C9_QTDLIB
            dbSkip()
         Enddo
         If BLCRED="10" .and. BLEST="10" // Já faturado
            xStatus:="P"
         ElseIf (BLCRED="01" .and. BLEST="02") .or. (BLCRED="01" .and. BLEST="  ") // Bloqueado no crédito
            xStatus:="P"
     	 ElseIf BLCRED="  " .and. BLEST="02" // Bloqueado no estoque
            xStatus:="P"
	     ElseIf BLCRED="  " .and. BLEST="  "
            GRAVA:=.T.                    
            DbSelectArea("SX5")
	        DbSetOrder(1)
	        DbSeek( xFilial()+"97" + EXP->B1_TPEMB )
            DbSelectArea("QUERY2")
            Reclock("QUERY2",.T.)
            QUERY2->PEDIDO := EXP->C5_NUM
            QUERY2->ITEM   := EXP->C6_ITEM
            QUERY2->PRODUTO:= EXP->C6_PRODUTO
            QUERY2->DESCPRO:= EXP->B1_DESC
            QUERY2->TPEMB  := Alltrim( SX5->X5_DESCRI )
            QUERY2->QUANT  := XQUANT/EXP->B1_QE
            QUERY2->PESO   := (EXP->B1_PESO*XQUANT)+(EXP->B1_PESOEMB*(XQUANT/EXP->B1_QE))
            QUERY2->CUB    := EXP->B1_PSE*(XQUANT/EXP->B1_QE)
            MSUnlock()
            If EXP->C6_ENTREG < DtEntr
               DtEntr:=EXP->C6_ENTREG
            Endif
 		    If  trim(EXP->B1_CLASSE1) = "031" .or. trim(EXP->B1_CLASSE1) = "035" .or. trim(EXP->B1_CLASSE1) = "039"
                DbSelectArea("SB1") 
                DbSeek( xFilial("SB1") + "10103240003   ", .T.)
                Reclock("QUERY2",.F.)
                QUERY2->QUANT  := QUERY2->QUANT+(XQUANT/SB1->B1_QE)
                QUERY2->PESO   := QUERY2->PESO+(SB1->B1_PESO*XQUANT)+(SB1->B1_PESOEMB*(XQUANT/SB1->B1_QE))
                QUERY2->CUB    := QUERY2->CUB+SB1->B1_PSE*(XQUANT/SB1->B1_QE)
                MSUnlock()
            Endif
            TQtd :=TQtd+QUERY2->QUANT                                           //QUANT / QTDE. EMBALAGEM
            TPESO:=TPESO+QUERY2->PESO  //(PESO LIQ. * QUANT)+(PESO EMBALAGEM * QUANT de embalagem)
            TCUB :=TCUB+QUERY2->CUB                             //CUBAGEM * CUBAGEM
         Endif
      Endif
      dbSelectArea("EXP")
	  dbSkip()
   Enddo
   If GRAVA .and. xStatus="T"
      XREC:=0
      dbSelectArea("SE1")
      dbSetOrder(1)
      dbSeek(xFilial("SE1")+"NCC"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="NCC" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"DIN"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="DIN" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CHQ"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CHQ" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH1"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH1" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH2"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH2" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH3"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH3" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH4"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH4" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH5"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH5" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH6"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH6" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH7"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH7" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH8"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH8" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo
      dbSeek(xFilial("SE1")+"CH9"+XNUM,.F.)
      While !EOF() .AND. SE1->E1_PREFIXO="CH9" .AND. SE1->E1_NUM=XNUM
         XREC:=XREC+E1_VALOR
         dbSkip()
      Enddo  
      XVAL:=0
      dbSelectArea("SC6")
      dbSetOrder(1)
      dbSeek(xFilial("SC6")+XNUM,.F.)
      While !EOF() .AND. SC6->C6_NUM=XNUM
         XVAL:=XVAL+SC6->C6_VALOR
         dbSkip()
      Enddo  
      DbSelectArea("QUERY1")
      Reclock("QUERY1",.T.)
      QUERY1->PEDIDO := XNUM
      QUERY1->CLIENTE:= XCLI
      QUERY1->CIDADE := XMUN
      QUERY1->UF     := XUF
      If XVAL-XREC<=1
         QUERY1->PAGTO  := ALLTRIM(X4DS)+" - PAGO"
      Else
         QUERY1->PAGTO  := X4DS
      Endif
      QUERY1->STATUS := xStatus
      QUERY1->TOTQTD := TQtd
      QUERY1->TOTPESO:= TPESO
      QUERY1->TOTCUB := TCUB
      QUERY1->MARCA  := "N"
      QUERY1->FRETE  := IIF(XTPF="C","CIF ate "+AllTrim(XATE),"FOB")
      QUERY1->OBS1   := XOBS
      QUERY1->ENTREGA:= CTOD(SUBSTR(DtEntr,7,2)+"/"+SUBSTR(DtEntr,5,2)+"/"+SUBSTR(DtEntr,1,4))
      MSUnlock()
   Endif
Enddo

DbSelectArea("QUERY1")
IndRegua("QUERY1",cArqTrb1,"DTOS(ENTREGA)")

WCONTINUA:=.T.
WHILE WCONTINUA
   TLPROD()
ENDDO
REturn

Static Function TLPROD()
dbSelectArea("SC6")
dbSetOrder(9) // romaneio+pedido+item
dbGoBottom()
NRom:=STRZERO(VAL(C6_ROMAN)+1,5)
@ 0,0 TO 100,430 DIALOG oDlg1 TITLE "Gera Romaneio"
@ 3,5 TO 30,210
// Montagem dos titulos dos campos
@ 15,10 say "Romaneio"

@ 15,35 SAY NRom PICTURE "99999"

// Botoes
@  38,070 BMPBUTTON TYPE 1 ACTION nseqOk1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
@  38,100 BMPBUTTON TYPE 2 ACTION ncanc1(oDlg1)// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
ACTIVATE DIALOG oDlg1 CENTER
REturn

Static Function ncanc1()
***************
WCONTINUA:=.F.
Close(oDlg1)
Return

Static Function nseqOk1()
***************

aStru:={}
AADD( aStru, {"PEDIDO"  ,"C" ,6 ,0} )
AADD( astru, {"ITEM"    ,"C" ,2 ,0} )
AADD( astru, {"PRODUTO" ,"C" ,14 ,0} )
AADD( astru, {"DESCPRO" ,"C" ,40,0} )
AADD( astru, {"TPEMB"   ,"C" ,10,0} )
AADD( astru, {"QUANT"   ,"N" ,18,2} ) 
AADD( astru, {"PESO"    ,"N" ,18,2} ) 
AADD( astru, {"CUB"     ,"N" ,18,2} ) 
cArqTrb3:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb3,"QUERY3",.F.)
IndRegua("QUERY3",cArqTrb3,"PRODUTO+PEDIDO+ITEM")

wQtdGer:=wPesoGer:=wCubGer:=0
dbSelectArea("QUERY1")
dbGoTop()

aCampos := {}
AADD(aCampos,{"MARCA","ROMANEIO","@!"})
AADD(aCampos,{"ENTREGA","ENTREGA","@!"})
AADD(aCampos,{"PEDIDO","PEDIDO","@!"})
AADD(aCampos,{"TOTQTD","QUANT.","@E 99,999.99"})
AADD(aCampos,{"TOTPESO","PESO","@E 99,999.99"})
AADD(aCampos,{"TOTCUB","CUBAGEM","@E 99,999.99"})
AADD(aCampos,{"PAGTO","COND.PAG.",})
AADD(aCampos,{"CIDADE","CIDADE",})
AADD(aCampos,{"UF","UF",})

@ 200,1 TO 500,765 DIALOG oDlg7 TITLE "Romaneio "+NRom
@ 6,5 TO 130,380 BROWSE "QUERY1" FIELDS aCampos
@ 135,005 BUTTON "_Marca" SIZE 40,15 ACTION Marca()
@ 135,160 BUTTON "_Conclui"  SIZE 40,15 ACTION Bloq()
@ 135,340 BUTTON "_Fecha"  SIZE 40,15 ACTION Fecha()
ACTIVATE DIALOG oDlg7 CENTER

Close(oDlg1)

Return

Static Function Marca()        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

If QUERY1->MARCA = "N"
   Reclock("QUERY1",.F.)
   QUERY1->MARCA  := "S"
   MSUnlock()
   wQtdGer :=wQtdGer+QUERY1->TOTQTD
   wPesoGer:=wPesoGer+QUERY1->TOTPESO
   wCubGer :=wCubGer+QUERY1->TOTCUB
Else
   Reclock("QUERY1",.F.)
   QUERY1->MARCA  := "N"
   MSUnlock()
   wQtdGer :=wQtdGer-QUERY1->TOTQTD
   wPesoGer:=wPesoGer-QUERY1->TOTPESO
   wCubGer :=wCubGer-QUERY1->TOTCUB
Endif
Return

Static Function Bloq()        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

@ 0,0 TO 100,430 DIALOG oDlg2
@ 3,5 TO 30,210
@ 15,010 SAY "Total Romaneio : "  + Transform(wQtdGer,"@E 99,999.99") + "    " + Transform(wPesoGer,"@E 99,999.99") + "    " + Transform(wCubGer,"@E 99,999.99")
@ 38,070 BMPBUTTON TYPE 1 ACTION Ok1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,65 BMPBUTTON TYPE 1 ACTION Execute(BotOk1)
@ 38,100 BMPBUTTON TYPE 2 ACTION Can1()// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==>     @  60,95 BMPBUTTON TYPE 2 ACTION Execute(BotCan1)
ACTIVATE DIALOG oDlg2 CENTER

Return

Static Function Ok1()

dbSelectArea("QUERY1")
dbGoTop()
While !EOF()

   If MARCA = "N"
   	  dbSkip()
	  Loop
   Endif

   DbSelectArea("QUERY2") 
   DbSeek( QUERY1->PEDIDO, .T.)
   While !EOF() .AND. QUERY2->PEDIDO=QUERY1->PEDIDO
      DbSelectArea("QUERY3")
      Reclock("QUERY3",.T.)
      QUERY3->PEDIDO := QUERY2->PEDIDO
      QUERY3->ITEM   := QUERY2->ITEM
      QUERY3->PRODUTO:= QUERY2->PRODUTO
      QUERY3->DESCPRO:= QUERY2->DESCPRO
      QUERY3->TPEMB  := QUERY2->TPEMB
      QUERY3->QUANT  := QUERY2->QUANT
      QUERY3->PESO   := QUERY2->PESO
      QUERY3->CUB    := QUERY2->CUB
      MSUnlock()
      dbSelectArea("SC6")
      dbSetOrder(1)
      dbGoTop()
      dbSeek(xFilial("SC6")+QUERY2->PEDIDO+QUERY2->ITEM,.F.)
      Reclock("SC6",.F.)
      C6_ROMAN  := NROM
      MSUnlock()
      dbSelectArea("QUERY2")
      dbSkip()
   Enddo
   dbSelectArea("QUERY1")
   dbSkip()
Enddo

wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
   dbSelectArea("QUERY3")
   dbCloseArea()
   If !Empty( cArqTrb3 )
      cArqTrb3:=""
      FErase( cArqTrb3+".*")
   Endif
   Close(oDlg2)
   Close(oDlg7)
   Set Filter to
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
   dbSelectArea("QUERY3")
   dbCloseArea()
   If !Empty( cArqTrb3 )
      cArqTrb3:=""
      FErase( cArqTrb3+".*")
   Endif
   Close(oDlg2)
   Close(oDlg7)
   Set Filter to
   Return
Endif

xCod:=Space(6)
Ok:=.F.
xQuant:=xPeso:=xCub:=0    
tQuant:=tPeso:=tCub:=0    
LI := 80
Limite:=80
Tamanho:="G"
@ 0,0 PSay AvalImp(limite)
DbselectArea("QUERY3")
dbGoTop()
While !EOF()

  If xCod<>QUERY3->PRODUTO
     If Ok
        @ LI,07 PSAY "TOTAL"
        @ LI,14 PSAY xQuant     Picture "@E 999,999.99"
        @ LI,25 PSAY xEmb
   	    @ LI,37 PSAY xPeso      Picture "@E 999,999.999"
   	    @ LI,57 PSAY xCub       Picture "@E 999,999.99"
        tQuant:=tQuant+xQuant
        tPeso :=tPeso+xPeso
        tCub  :=tCub+xCub
     	LI := LI + 2
     Endif
     If LI < 64
        @ LI,001 PSAY "  PRODUTO: " +ALLTRIM(QUERY3->PRODUTO)+" - "+QUERY3->DESCPRO
        xCod:=QUERY3->PRODUTO
        xEmb:=QUERY3->TPEMB
        LI := LI + 1
     Endif
     xQuant:=xPeso:=xCub:=0
  Endif

  If LI > 64
     LI:=0
     @ LI,000 Psay "PLASTICOS NOVEL DO NORDESTE S.A                                                 "   
//    @ LI,000 BITMAP SIZE 13,218 FILE lgrl01
     @ LI+01,000 Psay "--------------------------------------------------------------------------------"   
     @ LI+02,000 Psay "| ROMANEIO N.: " + NROM + SPACE(42)+"DATA: "+SubStr(Dtos(Date()),7,2)+"/"+SubStr(Dtos(Date()),5,2)+"/"+SubStr(Dtos(Date()),1,4)+" |"
     @ LI+03,000 Psay "|                                                                              |"   
     @ LI+04,000 Psay "| SEPARADOR  : _________________________________/____________________________  |"   
     @ LI+05,000 Psay "|                                                                              |"   
     @ LI+06,000 Psay "| CONFERENTE : _____________________________________PLACA : _________________  |"   
     @ LI+07,000 Psay "|                                                                              |"   
     @ LI+08,000 Psay "| HORA INICIO : _______________ HORA FIM : _______________                     |"   
     @ LI+09,000 Psay "--------------------------------------------------------------------------------"   
     @ LI+10,000 PSAY "       PEDIDO      QTD.              PESO BRUTO             CUBAGEM    QT/AT"
     @ LI+11,000 Psay "--------------------------------------------------------------------------------"   
     @ LI+13,000 PSAY "  PRODUTO: " +ALLTRIM(QUERY3->PRODUTO)+" - "+QUERY3->DESCPRO
     xCod:=QUERY3->PRODUTO
     xEmb:=QUERY3->TPEMB
     Li:=14
  Endif   

  @ LI,07  PSAY QUERY3->PEDIDO
  @ LI,14  PSAY QUERY3->QUANT  Picture "@E 999,999.99"
  @ LI,37  PSAY QUERY3->PESO   Picture "@E 999,999.999"
  @ LI,57  PSAY QUERY3->CUB    Picture "@E 999,999.99"
  @ LI,70  PSAY "________"
  xQuant:=xQuant+QUERY3->QUANT
  xPeso :=xPeso+QUERY3->PESO
  xCub  :=xCub+QUERY3->CUB
  Ok:=.T. 
  LI := LI + 1
  dbSelectArea("QUERY3")
  dbSkip()
Enddo
If Ok
   @ LI,07 PSAY "TOTAL"
   @ LI,14 PSAY xQuant     Picture "@E 999,999.99"
   @ LI,25 PSAY xEmb
   @ LI,37 PSAY xPeso      Picture "@E 999,999.999"
   @ LI,57 PSAY xCub       Picture "@E 999,999.99"
   LI := LI + 1
   tQuant:=tQuant+xQuant
   tPeso :=tPeso+xPeso
   tCub  :=tCub+xCub
Endif
If tQuant<>0 .or. tPeso<>0 .or. tCub<>0
   LI := LI + 1
   @ LI,02 PSAY "GERAL"
   @ LI,12 PSAY tQuant     Picture "@E 9,999,999.99"
   @ LI,35 PSAY tPeso/1000 Picture "@E 9,999,999.999"
   @ LI,48 PSAY "(t)
   @ LI,55 PSAY tCub       Picture "@E 9,999,999.99"
Endif
LI := LI + 1
@ LI,01 PSAY "."
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

wnrel  	:= "PEDFAT"    
titulo 	:= "PEDIDOS A FATURAR - ROMANEIO Nº " + NROM
cDesc1 	:= "Este programa ira emitir a relacao dos Pedidos selecionados"
cDesc2 	:= "para o romaneio."
cDesc3 	:= ""
tamanho	:= "G"
limite 	:= 220
cString 	:= "SC6"
lEnd      := .F.
cabec1 	 := " PEDIDO  CLIENTE CIDADE/UF                TIPO FRETE                     VOLUMES     OBSERVACOES             "
cabec2 	 := ""
lContinua  := .T.
nTipo		 := GetMv("MV_COMP")
LI       := 80
m_pag      := 1
nLastKey := 0
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"

wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

DbSelectArea("QUERY1")
DbGoTop()   
While !EOF()

   If MARCA = "N"
   	  dbSkip()
	  Loop
   Endif
   If LI > 68
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
   Endif   
   @ LI,01 PSAY QUERY1->PEDIDO +"  "+QUERY1->CLIENTE+"  "+ALLTRIM(QUERY1->CIDADE)+"-"+QUERY1->UF
   @ LI,42 PSAY ALLTRIM(QUERY1->FRETE)
   @ LI,74 PSAY QUERY1->TOTQTD Picture "@E 99,999.99"
   @ LI,85 PSAY ALLTRIM(QUERY1->OBS1)
   LI := LI + 1
   dbSelectArea("QUERY1")
   Reclock("QUERY1",.F.)
   QUERY1->( DbDelete() )
   MsUnlock()
   dbSkip()
EndDo
@ LI,01 PSAY "."
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

dbSelectArea("QUERY3")
dbCloseArea()
If !Empty( cArqTrb3 )
   cArqTrb3:=""
   FErase( cArqTrb3+".*")
Endif
Close(oDlg2)
Close(oDlg7)
Return

Static Function Can1()
//Close(oDlg1)
Close(oDlg2)
Return

Static Function Fecha()
dbSelectArea("QUERY3")
dbCloseArea()
If !Empty( cArqTrb3 )
   cArqTrb3:=""
   FErase( cArqTrb3+".*")
Endif
Close(oDlg7)
Return
