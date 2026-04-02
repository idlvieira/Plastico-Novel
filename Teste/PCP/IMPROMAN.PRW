#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

User Function IMPROMAN()        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ IMPROMAN  ³ Autor ³   Eliene Cerqueira   ³ Data ³ 02.05.05    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para reimprimir romaneio                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

cArqTrb1:=cArqTrb2:=cArqTrb3:=""
WCONTINUA:=.T.
WHILE WCONTINUA
   TLPROD()
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
ENDDO

REturn

Static Function TLPROD()
cArqTrb1:=cArqTrb2:=cArqTrb3:=""
dbSelectArea("SC6")
dbSetOrder(9) // romaneio+pedido+item
dbGoBottom()
NRom:=SPACE(5)
@ 0,0 TO 100,430 DIALOG oDlg1 TITLE "Impressão Romaneio"
@ 3,5 TO 30,210
// Montagem dos titulos dos campos
@ 15,10 say "Romaneio"

@ 15,35 GET NRom PICTURE "99999"

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

dbSelectArea("SC6")
dbSetOrder(9) // romaneio+pedido+item
dbSeek(xFilial("SC6")+NROM,.F.)	
If !Found()
   msgBox("Romaneio não existe.")
   Close(oDlg1)
   Return
Endif

aStru:={}
AADD( aStru, {"PEDIDO"  ,"C" ,6  ,0} )
AADD( astru, {"CLIENTE" ,"C" ,6  ,0} )
AADD( astru, {"CIDADE"  ,"C" ,20 ,0} )
AADD( astru, {"UF"      ,"C" ,2  ,0} )
AADD( aStru, {"FRETE"   ,"C" ,30 ,0} ) 
AADD( aStru, {"OBS1"    ,"C" ,200,0} ) 
AADD( astru, {"QUANT"   ,"N" ,18 ,2} ) 
cArqTrb1:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb1,"QUERY1",.F.)
IndRegua("QUERY1",cArqTrb1,"PEDIDO")

aStru:={}
AADD( aStru, {"PEDIDO"  ,"C" ,6 ,0} )
AADD( astru, {"ITEM"    ,"C" ,2 ,0} )
AADD( astru, {"PRODUTO" ,"C" ,14 ,0} )
AADD( astru, {"DESCPRO" ,"C" ,40,0} )
AADD( astru, {"TPEMB"   ,"C" ,10,0} )
AADD( astru, {"QTDPED"  ,"N" ,18,2} ) 
AADD( astru, {"QUANT"   ,"N" ,18,2} ) 
AADD( astru, {"PESO"   ,"N" ,18,2} ) 
AADD( astru, {"CUB"   ,"N" ,18,2} ) 
cArqTrb3:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb3,"QUERY3",.F.)
IndRegua("QUERY3",cArqTrb3,"PRODUTO+PEDIDO+ITEM")

dbSelectArea("SC6")
While !EOF() .AND. C6_ROMAN=NROM
   dbSelectArea("SC5")
   dbSetOrder(1) 
   dbSeek(xFilial("SC5")+SC6->C6_NUM,.F.)	
   DbSelectArea("SA1") 
   DbSetOrder(1) 
   DbSeek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, .T.)
   TQUANT:=0
   While !EOF() .AND. SC6->C6_NUM=SC5->C5_NUM
      XQUANT:=0
      DbSelectArea("SC9")
      dbSetOrder(1)
      dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
      While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
         BLCRED:=C9_BLCRED               
         BLEST :=C9_BLEST           
         XQUANT:=SC9->C9_QTDLIB
         dbSkip()
      Enddo
      DbSelectArea("SB1") 
      DbSeek( xFilial("SB1") + SC6->C6_PRODUTO, .T.)
      DbSelectArea("SX5")
      DbSetOrder(1)
      DbSeek( xFilial()+"97" + SB1->B1_TPEMB )
      DbSelectArea("QUERY3")
      Reclock("QUERY3",.T.)
      QUERY3->PEDIDO := SC6->C6_NUM
      QUERY3->ITEM   := SC6->C6_ITEM
      QUERY3->PRODUTO:= SC6->C6_PRODUTO
      QUERY3->DESCPRO:= SB1->B1_DESC
      QUERY3->TPEMB  := Alltrim( SX5->X5_DESCRI )
      QUERY3->QTDPED := XQUANT
      QUERY3->QUANT  := XQUANT/SB1->B1_QE
      QUERY3->PESO   := (SB1->B1_PESO*XQUANT)+(SB1->B1_PESOEMB*(XQUANT/SB1->B1_QE))
      QUERY3->CUB    := SB1->B1_PSE*(XQUANT/SB1->B1_QE)
      MSUnlock()         
      If  trim(SB1->B1_CLASSE1) = "031" .or. trim(SB1->B1_CLASSE1) = "035" .or. trim(SB1->B1_CLASSE1) = "039"
          DbSelectArea("SB1") 
          DbSeek( xFilial("SB1") + "10103240003   ", .T.)
          Reclock("QUERY3",.F.)
          QUERY3->QUANT  := QUERY3->QUANT+(XQUANT/SB1->B1_QE)
          QUERY3->PESO   := QUERY3->PESO+(SB1->B1_PESO*XQUANT)+(SB1->B1_PESOEMB*(XQUANT/SB1->B1_QE))
          QUERY3->CUB    := QUERY3->CUB+SB1->B1_PSE*(XQUANT/SB1->B1_QE)
          MSUnlock()
      Endif
      TQUANT:=TQUANT+QUERY3->QUANT                                           //QUANT / QTDE. EMBALAGEM
      dbSelectArea("SC6")
      dbSkip()
   Enddo
   DbSelectArea("QUERY1")
   Reclock("QUERY1",.T.)
   QUERY1->PEDIDO := QUERY3->PEDIDO
   QUERY1->CLIENTE:= SC5->C5_CLIENTE
   QUERY1->CIDADE := SA1->A1_MUN
   QUERY1->UF     := SA1->A1_EST
   QUERY1->FRETE  := IIF(SC5->C5_TPFRETE="C","CIF ate "+AllTrim(SC5->C5_CIF_ATE),"FOB")
   QUERY1->OBS1   := ALLTRIM(SC5->C5_OBS1)+" "+ALLTRIM(SC5->C5_OBS2)+" "+ALLTRIM(SC5->C5_OBS3)
   QUERY1->QUANT  := TQUANT
   MSUnlock()         
Enddo

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

wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
    Close(oDlg1)
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
    Close(oDlg1)
	Set Filter to
	Return
Endif

LI := 80
Limite:=80
Tamanho:="G"
@ 0,0 PSay AvalImp(limite)
xCod:=Space(6)
Ok:=.F.
xQuant:=xEmb:=xPeso:=xCub:=0    
tQuant:=tEmb:=tPeso:=tCub:=0    
DbselectArea("QUERY3")
dbGoTop()
While !EOF()

  If xCod<>QUERY3->PRODUTO
     If Ok
        @ LI,04        PSAY "TOTAL"
        @ LI,PCOL()+3  PSAY xQuant     Picture "@E 999,999.99"
        @ LI,PCOL()+2  PSAY xEmb       Picture "@E 9,999.99"
        @ LI,PCOL()+1  PSAY xTPEmb
   	    @ LI,PCOL()+2  PSAY xPeso      Picture "@E 999,999.999"
   	    @ LI,PCOL()+2  PSAY xCub      Picture "@E 999,999.99"
        tQuant:=tQuant+xQuant
        tEmb:=tEmb+xEmb
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
     xQuant:=xEmb:=xPeso:=xCub:=0
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
     @ LI+10,000 PSAY "    PEDIDO      QTD.     EMBAL.              PESO BRUTO      CUBAGEM    QT/AT"
     @ LI+11,000 Psay "--------------------------------------------------------------------------------"   
     @ LI+13,001 PSAY "  PRODUTO: " +ALLTRIM(QUERY3->PRODUTO)+" - "+QUERY3->DESCPRO
     xCod:=QUERY3->PRODUTO
     xTPEmb:=QUERY3->TPEMB
     Li:=14
  Endif   

  @ LI,04  PSAY QUERY3->PEDIDO
  @ LI,PCOL()+2  PSAY QUERY3->QTDPED Picture "@E 999,999.99"
  @ LI,PCOL()+2  PSAY QUERY3->QUANT  Picture "@E 9,999.99"
  @ LI,PCOL()+13 PSAY QUERY3->PESO   Picture "@E 999,999.999"
  @ LI,PCOL()+2  PSAY QUERY3->CUB    Picture "@E 999,999.99"
  @ LI,PCOL()+3 PSAY "________"
  xQuant:=xQuant+QUERY3->QTDPED
  xEmb:=xEmb+QUERY3->QUANT
  xPeso :=xPeso+QUERY3->PESO
  xCub  :=xCub+QUERY3->CUB
  Ok:=.T. 
  LI := LI + 1
  dbSelectArea("QUERY3")
  dbSkip()
EndDo
If Ok
   @ LI,04 PSAY "TOTAL"
   @ LI,PCOL()+3 PSAY xQuant     Picture "@E 999,999.99"
   @ LI,PCOL()+2 PSAY xEmb       Picture "@E 9,999.99"
   @ LI,PCOL()+1 PSAY xTPEmb
   @ LI,PCOL()+2 PSAY xPeso      Picture "@E 999,999.999"
   @ LI,PCOL()+2 PSAY xCub       Picture "@E 999,999.99"
   LI := LI + 1
   tQuant:=tQuant+xQuant
   tEmb:=tEmb+xEmb
   tPeso :=tPeso+xPeso
   tCub  :=tCub+xCub
Endif
If tQuant<>0 .or. tEmb<>0 .or. tPeso<>0 .or. tCub<>0
   LI := LI + 1
   @ LI,02 PSAY "GERAL"
   @ LI,PCOL()+3  PSAY tQuant     Picture "@E 9,999,999.99"
   @ LI,PCOL()+2  PSAY tEmb       Picture "@E 9,999.99"
   @ LI,PCOL()+13 PSAY tPeso/1000 Picture "@E 999,999.999"
   @ LI,PCOL()+1  PSAY "(t)
   @ LI,PCOL()+1  PSAY tCub       Picture "@E 9999.99"
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
    Close(oDlg1)
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
    Close(oDlg1)
	Set Filter to
	Return
Endif

DbSelectArea("QUERY1")
DbGoTop()   
While !EOF()

   If LI > 68
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
   Endif   
   @ LI,01 PSAY QUERY1->PEDIDO +"  "+QUERY1->CLIENTE+"  "+ALLTRIM(QUERY1->CIDADE)+"-"+QUERY1->UF
   @ LI,42 PSAY ALLTRIM(QUERY1->FRETE)
   @ LI,74 PSAY QUERY1->QUANT Picture "@E 99,999.99"
   @ LI,85 PSAY ALLTRIM(QUERY1->OBS1)
   LI := LI + 1
   dbSelectArea("QUERY1")
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
Close(oDlg1)
Return
