#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PEDPROD  ³ Autor ³ Eliene Cerqueira      ³ Data ³ 09.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Relacao dos Pedidos Pendentes para Producao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

User Function PEDPROD
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  	:= "PEDPROD"    
titulo 	:= "Relacao de Pedidos de Vendas a serem Produzidos"
cDesc1 	:= "Este programa ira emitir a relacao dos Pedidos de Vendas"
cDesc2 	:= "pendentes com o seu status atual - Status=2 devem ser "
cDesc3 	:= "produzidos."
tamanho	:= "G"
limite 	:= 220
cString 	:= "SC6"
lEnd      := .F.
cabec1 	 := " PRODUTO                                                PEDIDO/IT  NR.FG      OP      CLIENTE                       EMISSAO  ENTREGA  LIBERACAO  ENCOM  ---------  PEDIDO  ---------    ESTOQUE   RESERVADO  A PRODUZIR" 
cabec2 	 := "                                                                                                                                                        VENDIDO   ATENDIDO    SALDO   DISPONIVEL"
lContinua  := .T.
nTipo		 := GetMv("MV_COMP")
LI       := 80
m_pag      := 1
nLastKey := 0
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"

//wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)
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

RptStatus({|lEnd| C700Imp(@lEnd,wnrel,cString,aReturn,tamanho,limite,;	
						  titulo,cDesc1,cDesc2,cDesc3)},Titulo)

Return 

Static Function C700Imp(lEnd,WnRel,cString,aReturn,tamanho,limite,titulo,;
						cDesc1,cDesc2,cDesc3)
dbSelectArea("SC6")
dbSetOrder(10) // produto+data entrega
dbGoTop()

xCod:=Space(6)
Ok:=.F.
xQuant:=xEst:=xRes:=0    
SetRegua(RecCount())

While !EOF()

  IncRegua()
  IF SC6->C6_TES$"508/515/516/517/521/522/523/524/528/529/531/536/537/538/543/544/545/546/547/548/549/550/555/556/557"
     dbSelectArea("SC6")
     dbSkip()
	 Loop
  Endif
  If SC6->C6_QTDVEN-SC6->C6_QTDENT = 0
     dbSelectArea("SC6")
     dbSkip()
     Loop
  Endif

  If lAbortPrint
   	  @LI,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
  Endif

  dbSelectArea("SC5")
  dbSetOrder(1) 
  dbSeek(xFilial("SC5")+SC6->C6_NUM,.F.)	
  If !Found()
     dbSelectArea("SC6")
  	 dbSkip()
	 Loop
  Endif
  If SC5->C5_CONDPAG="040"
     dbSelectArea("SC6")
  	 dbSkip()
	 Loop
  Endif
  dbSelectArea("SC9")
  dbSetOrder(1)
  dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
   
  If !Found() // Bloqueado em vendas
     dbSelectArea("SC6")
     dbSkip()
     Loop
  Else
     While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
        BLCRED:=C9_BLCRED               
        BLEST :=C9_BLEST
        DATLIB:=C9_DATALIB
   	    dbSkip()
     Enddo
     If BLCRED="10" .and. BLEST="10" // Já faturado
        dbSelectArea("SC6")
        dbSkip()
	    Loop
	 ElseIf (BLCRED="01" .and. BLEST="02") .or. (BLCRED="01" .and. BLEST="  ")  // Bloqueado no crédito
        dbSelectArea("SC6")
        dbSkip()
	    Loop
        Status:=3
	 ElseIf (BLCRED="  " .and. BLEST="02")
        Status:=2 // Bloqueado no estoque
	 ElseIf BLCRED="  " .and. BLEST="  " // Liberado para faturar
        dbSelectArea("SC6")
        dbSkip()
	    Loop
        Status:=1
     Endif
  Endif

  xOp:=Space(11)
  dbSelectArea("SC2")
  dbSetOrder(9)
  dbSeek(xFilial("SC2")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
  If Found()
     xOp:=C2_NUM+C2_ITEM+C2_SEQUEN
  Endif
  If xCod<>SC6->C6_PRODUTO
     If Ok
        @ LI,172 PSAY xQuant     Picture "@E 999,999"
   	    @ LI,184 PSAY xEst       Picture "@E 999,999"
   	    @ LI,195 PSAY xRes       Picture "@E 999,999"
        xProd:=xQuant-(xEst-xRes)
      	@ LI,207 PSAY xProd      Picture "@E 999,999"
     	LI := LI + 2
     Endif
     xCod:=SC6->C6_PRODUTO
     DbSelectArea("SB1")
     DbSetOrder(1)
     DbSeek(xFilial("SB1")+xCod,.F.)
     DbSelectArea("SB2")
     DbSetOrder(1)
     DbSeek(xFilial("SB2")+xCod+"01",.T.)
     If Found()
        xEst:=SB2->B2_QATU
        xRes:=SB2->B2_RESERVA
     Endif                   
     If LI < 58
        @ LI,01 PSAY Alltrim(xCod)+" - "+SB1->B1_DESC
        LI := LI + 1
     Endif
     xQuant:=0
  Endif

  If LI > 58
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
     DbSelectArea("SB1")
     DbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.F.)
     @ LI,01 PSAY Alltrim(SC6->C6_PRODUTO)+" - "+SB1->B1_DESC
     LI := LI + 1
  Endif   

  @ LI,56  PSAY SC6->C6_NUM+"/"+SC6->C6_ITEM+"  "+SC6->C6_NRFG
//  @ LI,67  PSAY Status
  @ LI,74  PSAY xOp
  DbSelectArea("SA1") 
  DbSetOrder(1) 
  DbSeek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, .T.)
  @ LI,86  PSAY SC5->C5_CLIENTE+" - "+SA1->A1_NREDUZ
  @ LI,116 PSAY SC5->C5_EMISSAO    
  @ LI,125 PSAY SC6->C6_ENTREG
  If !Empty(SC5->C5_NOVULT)
    @ LI,134 PSAY SC5->C5_NOVULT
  Else
    @ LI,134 PSAY DATLIB
  Endif
  If SC6->C6_ENCOMED='N'
     @ LI,146 PSAY 'Nao'
  Else   
     @ LI,146 PSAY 'Sim'
  Endif

  " PRODUTO                                                 PEDIDO/IT  NR.FG       OP       CLIENTE  EMISSAO   ENTREGA   LIBERACAO  ENCOM   ------------  PEDIDO  --------------    ESTOQUE     RESERVADO    A PRODUZIR" 
  "                                                                                                                                         VENDIDO      ATENDIDO       SALDO      DISPONIVEL"
//  99999999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999999/01  999999  99999999999  999999   99/99/99  99/99/99  99/99/99    Sim    000.200,00   000.000.00   000.000.00   000.000.00   000.000.00   000.000.00
  " PRODUTO                                                PEDIDO/IT  NR.FG      OP      CLIENTE                       EMISSAO  ENTREGA  LIBERACAO  ENCOM  ---------  PEDIDO  ---------    ESTOQUE   RESERVADO  A PRODUZIR" 
  "                                                                                                                                                        VENDIDO   ATENDIDO    SALDO   DISPONIVEL"
//  99999999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999/01  999999 99999999999 999999 - XXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99    Sim   000.200   000.000   000.000     000.000    000.000     000.000
//  123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
  xQuant:=xQuant+(SC6->C6_QTDVEN-SC6->C6_QTDENT)                                                                                                     
  @ LI,152 PSAY SC6->C6_QTDVEN Picture "@E 999,999"
  @ LI,162 PSAY SC6->C6_QTDENT Picture "@E 999,999"
  @ LI,172 PSAY SC6->C6_QTDVEN-SC6->C6_QTDENT Picture "@E 999,999"
  Ok:=.T. 
  LI := LI + 1
  dbSelectArea("SC6")
  dbSkip()
EndDo
If Ok
   @ LI,172 PSAY xQuant     Picture "@E 999,999"
   @ LI,184 PSAY xEst       Picture "@E 999,999"
   @ LI,195 PSAY xRes       Picture "@E 999,999"
   xProd:=xQuant-(xEst-xRes)
   @ LI,207 PSAY xProd      Picture "@E 999,999"
Endif
@ LI,01 PSAY "."
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
