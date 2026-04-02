#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"  

User Function PEDPEND
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PEDPEND  ³ Autor ³ Eliene Cerqueira      ³ Data ³ 22.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Relacao dos Pedidos Pendentes com status - MATR680          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  	 := "PEDPEND"    
titulo 	 := "Relacao de Pedidos de Vendas nao entregues"
cDesc1 	 := "Este programa ira emitir a relacao dos Pedidos de Vendas"
cDesc2 	 := "pendentes com o seu status atual."
cDesc3 	 := ""
tamanho	 := "G"
limite 	 := 220
cString  := "SC6"
lEnd     := .F.
lContinua:= .T.
nTipo	 := GetMv("MV_COMP")
//aOrd := {"DATA ENTREGA","PRODUTO","CLIENTE"}
LI       := 80
m_pag    := 1
nLastKey := 0
cPerg            :="RELPEN"
XSTATUS:=" "      
XFRETE:= " "
DATLIB:=CTOD("  /  /  ")
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"    
//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//AjustaSx1()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                      ³
//³ mv_par01              Ordem "DATA ENTREGA","PRODUTO","CLIENTE"            ³
//³ mv_par02              Data Entrega Inicial                                ³
//³ mv_par03              Data Entrega Final                                  ³
//³ mv_par04              Cliente Inicial                                     ³
//³ mv_par05              Cliente Final                                       ³
//³ mv_par06              Vendedor                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint("",wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho)
If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

//nOrdem  := aReturn[8]

If mv_par01=1  // data de entrega
   RptStatus({|lEnd| Imp1(@lEnd,wnrel,cString,aReturn,tamanho,limite,;	
						  titulo,cDesc1,cDesc2,cDesc3)},Titulo)
   DbSelectArea("PEND")
   dbCloseArea()
ElseIf mv_par01=2  // produto
   RptStatus({|lEnd| Imp2(@lEnd,wnrel,cString,aReturn,tamanho,limite,;	
						  titulo,cDesc1,cDesc2,cDesc3)},Titulo)
   DbSelectArea("PEND")
   dbCloseArea()
ElseIf mv_par01=3  // cliente
   RptStatus({|lEnd| Imp3(@lEnd,wnrel,cString,aReturn,tamanho,limite,;	
						  titulo,cDesc1,cDesc2,cDesc3)},Titulo)
   DbSelectArea("PEND")
   dbCloseArea()
Endif

Return 

Static Function Imp1(lEnd,WnRel,cString,aReturn,tamanho,limite,titulo,;
						cDesc1,cDesc2,cDesc3)
// cabec1 	 := "PEDIDO  CLIENTE                      EMISSAO     OC    IT   PRODUTO       DESCRICAO                               STATUS      OP     FRETE  ENTREGA  LIBERAÇÃO  ENCOMENDA    ---------------  PEDIDO  ----------------" 
cabec1 	 := "PEDIDO  CLIENTE                      EMISSAO     OC    IT   PRODUTO       DESCRICAO                               STATUS      OP     FRETE  ENTREGA  LIBERAÇÃO    VLR R$         ---------------  PEDIDO  ----------------" 
cabec2 	 := "                                                                                                                                                                  S/IPI           VENDIDO        ATENDIDO          SALDO"

cQry := " SELECT SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_TPFRETE, SC5.C5_EMISSAO, SC5.C5_NOVULT, SC5.C5_VEND1, SC5.C5_PEDCLI,"
cQry := cQry + " SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_PRCVEN, SC6.C6_VALOR, SB1.B1_DESC, "
cQry := cQry + " SC6.C6_ENCOMED, SC6.C6_QTDVEN, SC6.C6_QTDENT,"
cQry := cQry + " SC6.C6_ENTREG, SC6.C6_TES, SA1.A1_NREDUZ, SA3.A3_NREDUZ"
cQry := cQry + " FROM SC5010 AS SC5, SC6010 AS SC6, SA1010 AS SA1, SB1010 AS SB1, SA3010 AS SA3"
cQry := cQry + " WHERE SC5.C5_NUM = SC6.C6_NUM"
cQry := cQry + " AND SA1.A1_COD = SC5.C5_CLIENTE"
cQry := cQry + " AND SA1.A1_LOJA = SC5.C5_LOJACLI"
cQry := cQry + " AND SB1.B1_COD = SC6.C6_PRODUTO"
cQry := cQry + " AND SC5.C5_VEND1 = SA3.A3_COD"
cQry := cQry + " AND SC6.C6_ENTREG >= '"+DTOS(MV_PAR02)+"'"
cQry := cQry + " AND SC6.C6_ENTREG <= '"+DTOS(MV_PAR03)+"'"
cQry := cQry + " AND SC5.C5_CLIENTE >= '"+MV_PAR04+"'"
cQry := cQry + " AND SC5.C5_CLIENTE <= '"+MV_PAR05+"'"
If !Empty(MV_PAR06)
   cQry := cQry + " AND SC5.C5_VEND1 = '"+MV_PAR06+"'"
Endif
cQry := cQry + " AND SC5.C5_TIPO = 'N'"
cQry := cQry + " AND SC6.C6_QTDVEN-SC6.C6_QTDENT>0"
cQry := cQry + " AND SC6.C6_TES NOT  IN ('508', '515', '516', '517', '521', '522', '523', '524', '528', '529', '531', '536', '537', '543', '544', '545', '546', '547', '548', '549', '550', '555', '556', '557', '535', '541')"
cQry := cQry + " AND SC6.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SC5.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SC6.C6_ENTREG, SC6.C6_NUM, SC6.C6_ITEM ASC"

Tcquery cQry new alias "PEND"

OK:=.F.
dbSelectArea("PEND")
SetRegua(RecCount())

While !EOF()

  IncRegua()
  If lAbortPrint
   	  @LI,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
  Endif 

  DATLIB:=CTOD("  /  /  ")
  TSTSTAT()
  DbSelectArea("PEND") 
  If xStatus = " "
     dbSkip()
   	 Loop
  Endif                                          

  If LI > 58
     If Ok
        LI := 62
        @ LI,01 PSAY Replicate("_",220)
        LI := LI + 1
        @ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
        LI := LI + 1
        @ LI,01 PSAY Replicate("_",220)
     Endif
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
     If !Empty(MV_PAR06)
        @ LI,00 PSAY "*** VENDEDOR : " + PEND->C5_VEND1 + " - " + PEND->A3_NREDUZ
        LI := LI + 2
     Endif
  Endif   

  OK:=.T.
//  999999  XXXXXX-XXXXXXXXXXXXXXXXXXXX 99/99/99  99  99999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    1    99999999999  99/99/99     Sim     000.200,00     000.000.00  000.000.00   
//  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
  @ LI,00       PSAY PEND->C5_NUM + "  " + PEND->C5_CLIENTE+"-"+PEND->A1_NREDUZ
  @ LI,PCol()+2 PSAY SUBSTR(PEND->C5_EMISSAO,7,2)+"/"+SUBSTR(PEND->C5_EMISSAO,5,2)+"/"+SUBSTR(PEND->C5_EMISSAO,3,2)
  @ LI,PCol()+2 PSAY PEND->C5_PEDCLI
//  XFRETE:=IIF(PEND->C5_TPFRETE="C","CIF","FOB")
    IF PEND->C5_TPFRETE="F"
       XFRETE := "FOB"
    ENDIF
    
    IF PEND->C5_TPFRETE="C"
       XFRETE := "CIF"
    ENDIF
 
    IF PEND->C5_TPFRETE <> "C" .AND. PEND->C5_TPFRETE <> "F" 
       XFRETE := "   "
    ENDIF
    
  PEDIDO:=PEND->C5_NUM
  While !EOF() .AND. PEND->C5_NUM=PEDIDO
     DATLIB:=CTOD("  /  /  ")
     TSTSTAT()
     DbSelectArea("PEND") 
     If xStatus = " "
        dbSkip()
     	Loop
     Endif                                          
     If LI > 58
        If Ok
           LI := 62
           @ LI,01 PSAY Replicate("_",220)
           LI := LI + 1
           @ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
           LI := LI + 1
           @ LI,01 PSAY Replicate("_",220)
        Endif
        Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
        If !Empty(MV_PAR06)
           @ LI,00 PSAY "*** VENDEDOR : " + PEND->C5_VEND1 + " - " + PEND->A3_NREDUZ
           LI := LI + 2
        Endif
     Endif   
     xOp:=Space(11)
     dbSelectArea("SC2")                           
     dbSetOrder(9)
     dbSeek(xFilial("SC2")+PEND->C5_NUM+PEND->C6_ITEM,.F.)
     If Found()
        xOp:=C2_NUM+C2_ITEM+C2_SEQUEN
     Endif
     @ LI,55       PSAY PEND->C6_ITEM+"  "+SUBSTR(PEND->C6_PRODUTO,1,11)+" "+PEND->B1_DESC+"            "+XSTATUS+"    "+xOP+"  "+XFRETE
     @ LI,PCol()+2 PSAY SUBSTR(PEND->C6_ENTREG,7,2)+"/"+SUBSTR(PEND->C6_ENTREG,5,2)+"/"+SUBSTR(PEND->C6_ENTREG,3,2)
     If !Empty(PEND->C5_NOVULT)
        @ LI,PCol()+2 PSAY SUBSTR(PEND->C5_NOVULT,7,2)+"/"+SUBSTR(PEND->C5_NOVULT,5,2)+"/"+SUBSTR(PEND->C5_NOVULT,3,2)
     Else
        @ LI,PCol()+2 PSAY DATLIB
     Endif
     // @ LI,PCol()+6 PSAY IIF(PEND->C6_ENCOMED='N',"NAO","SIM")   
     mvalor := 0.00
     mvalor := (PEND->C6_QTDVEN-PEND->C6_QTDENT)*PEND->C6_PRCVEN 
     @ LI,PCol()+1 PSAY mvalor Picture "9,999,999.99"    
     @ LI,PCol()+6 PSAY PEND->C6_QTDVEN-PEND->C6_QTDENT Picture "@E 999,999.99"
     @ LI,PCol()+6 PSAY PEND->C6_QTDENT Picture "@E 999,999.99"
     @ LI,PCol()+6 PSAY PEND->C6_QTDVEN-PEND->C6_QTDENT Picture "@E 999,999.99"
     LI := LI + 1
     DbSelectArea("PEND") 
     dbSkip()
  Enddo
  LI := LI + 1
EndDo
LI := 62
@ LI,01 PSAY Replicate("_",220)
LI := LI + 1
@ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
LI := LI + 1
@ LI,01 PSAY Replicate("_",220)
LI := LI + 1
@ LI,01 PSAY "."
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function Imp2(lEnd,WnRel,cString,aReturn,tamanho,limite,titulo,;
						cDesc1,cDesc2,cDesc3)
cabec1 	 := "PRODUTO                                                   PEDIDO IT  EMISSAO   ENTREGA   LIBERAÇÃO  CLIENTE                        OC    STATUS      OP     FRETE     VLR R$    --------------  PEDIDO  ----------------" 
cabec2 	 := "                                                                                                                                                                      S/IPI     VENDIDO        ATENDIDO          SALDO"

cQry := " SELECT SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_TPFRETE, SC5.C5_EMISSAO, SC5.C5_NOVULT, SC5.C5_VEND1, SC5.C5_PEDCLI,"
cQry := cQry + " SC6.C6_ITEM, SC6.C6_PRODUTO, SB1.B1_DESC, "
cQry := cQry + " SC6.C6_ENCOMED, SC6.C6_QTDVEN, SC6.C6_QTDENT, SC6.C6_PRCVEN, SC6.C6_VALOR,"
cQry := cQry + " SC6.C6_ENTREG, SC6.C6_TES, SA1.A1_NREDUZ, SA3.A3_NREDUZ"
cQry := cQry + " FROM SC5010 AS SC5, SC6010 AS SC6, SA1010 AS SA1, SB1010 AS SB1, SA3010 AS SA3"
cQry := cQry + " WHERE SC5.C5_NUM = SC6.C6_NUM"
cQry := cQry + " AND SA1.A1_COD = SC5.C5_CLIENTE"
cQry := cQry + " AND SA1.A1_LOJA = SC5.C5_LOJACLI"
cQry := cQry + " AND SB1.B1_COD = SC6.C6_PRODUTO"
cQry := cQry + " AND SC5.C5_VEND1 = SA3.A3_COD"
cQry := cQry + " AND SC6.C6_ENTREG >= '"+DTOS(MV_PAR02)+"'"
cQry := cQry + " AND SC6.C6_ENTREG <= '"+DTOS(MV_PAR03)+"'"
cQry := cQry + " AND SC5.C5_CLIENTE >= '"+MV_PAR04+"'"
cQry := cQry + " AND SC5.C5_CLIENTE <= '"+MV_PAR05+"'"
If !Empty(MV_PAR06)
   cQry := cQry + " AND SC5.C5_VEND1 = '"+MV_PAR06+"'"
Endif
cQry := cQry + " AND SC5.C5_TIPO = 'N'"
cQry := cQry + " AND SC6.C6_QTDVEN-SC6.C6_QTDENT>0"
cQry := cQry + " AND SC6.C6_TES NOT  IN ('508', '515', '516', '517', '521', '522', '523', '524', '528', '529', '531', '536', '537', '543', '544', '545', '546', '547', '548', '549', '550', '555', '556', '557')"
cQry := cQry + " AND SC6.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SC5.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SC6.C6_PRODUTO, SC6.C6_ENTREG ASC"

Tcquery cQry new alias "PEND"

xCod:=Space(6)
Ok:=.F.
xQPed:=0
xQEnt:=0
xQPen:=0
dbSelectArea("PEND")
SetRegua(RecCount())

While !EOF()

  IncRegua()

  If lAbortPrint
   	  @LI,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
  Endif

  DATLIB:=CTOD("  /  /  ")
  TSTSTAT()
  DbSelectArea("PEND") 
  If xStatus = " "
     dbSkip()
   	 Loop
  Endif                                          

  If LI > 58
     If Ok
        LI := 62
        @ LI,01 PSAY Replicate("_",220)
        LI := LI + 1
        @ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
        LI := LI + 1
        @ LI,01 PSAY Replicate("_",220)
     Endif
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
     If !Empty(MV_PAR06)
        @ LI,00 PSAY "*** VENDEDOR : " + PEND->C5_VEND1 + " - " + PEND->A3_NREDUZ
        LI := LI + 2
     Endif
  Endif   

  @ LI,00 PSAY ALLTRIM(PEND->C6_PRODUTO)+" - "+PEND->B1_DESC
  xQPed:=0
  xQEnt:=0
  xQPen:=0
  xCod:=PEND->C6_PRODUTO
//  XFRETE:=IIF(PEND->C5_TPFRETE="C","CIF","FOB")
  IF PEND->C5_TPFRETE="F"
       XFRETE := "FOB"
  ENDIF
    
  IF PEND->C5_TPFRETE="C"
     XFRETE := "CIF"
  ENDIF

  IF PEND->C5_TPFRETE <> "C" .AND. PEND->C5_TPFRETE <> "F" 
     XFRETE := "   "
  ENDIF
   
  While !EOF() .AND. PEND->C6_PRODUTO=xCod
     DATLIB:=CTOD("  /  /  ")
     TSTSTAT()
     DbSelectArea("PEND") 
     If xStatus = " "
        dbSkip()
     	Loop
     Endif                                          
     If LI > 58
        If Ok
           LI := 62
           @ LI,01 PSAY Replicate("_",220)
           LI := LI + 1
           @ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
           LI := LI + 1
           @ LI,01 PSAY Replicate("_",220)
        Endif
        Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
        If !Empty(MV_PAR06)
           @ LI,00 PSAY "*** VENDEDOR : " + PEND->C5_VEND1 + " - " + PEND->A3_NREDUZ
           LI := LI + 2
        Endif
        @ LI,00 PSAY ALLTRIM(PEND->C6_PRODUTO)+" - "+PEND->B1_DESC
     Endif   
     xOp:=Space(11)
     dbSelectArea("SC2")
     dbSetOrder(9)
     dbSeek(xFilial("SC2")+PEND->C5_NUM+PEND->C6_ITEM,.F.)
     If Found()
        xOp:=C2_NUM+C2_ITEM+C2_SEQUEN
     Endif
     @ LI,58       PSAY PEND->C5_NUM+" "+PEND->C6_ITEM
     @ LI,PCol()+2 PSAY SUBSTR(PEND->C5_EMISSAO,7,2)+"/"+SUBSTR(PEND->C5_EMISSAO,5,2)+"/"+SUBSTR(PEND->C5_EMISSAO,3,2)
     @ LI,PCol()+2 PSAY SUBSTR(PEND->C6_ENTREG,7,2)+"/"+SUBSTR(PEND->C6_ENTREG,5,2)+"/"+SUBSTR(PEND->C6_ENTREG,3,2)
     If !Empty(PEND->C5_NOVULT)
        @ LI,PCol()+2 PSAY SUBSTR(PEND->C5_NOVULT,7,2)+"/"+SUBSTR(PEND->C5_NOVULT,5,2)+"/"+SUBSTR(PEND->C5_NOVULT,3,2)
     Else
        @ LI,PCol()+2 PSAY DATLIB
     Endif
 

     mvalor := 0.00
     mvalor := (PEND->C6_QTDVEN - PEND->C6_QTDENT)*PEND->C6_PRCVEN 
     @ LI,PCol()+3 PSAY PEND->C5_CLIENTE+"-"+PEND->A1_NREDUZ+"  "+PEND->C5_PEDCLI+"    "+XSTATUS+"    "+xOP+"  "+XFRETE
//   @ LI,PCol()+6 PSAY IIF(PEND->C6_ENCOMED='N',"NAO","SIM")
     @ LI,PCol()+1 PSAY mvalor Picture "9,999,999.99"    
     @ LI,PCol()+6 PSAY PEND->C6_QTDVEN Picture "@E 999,999.99"
     @ LI,PCol()+6 PSAY PEND->C6_QTDENT Picture "@E 999,999.99"
     @ LI,PCol()+6 PSAY PEND->C6_QTDVEN-PEND->C6_QTDENT Picture "@E 999,999.99"
     LI := LI + 1
     xQPed:=xQPed+PEND->C6_QTDVEN
     xQEnt:=xQEnt+PEND->C6_QTDENT
     xQPen:=xQPen+(PEND->C6_QTDVEN-PEND->C6_QTDENT)
     Ok:=.T. 
     DbSelectArea("PEND") 
     dbSkip()
  Enddo
  If Ok
     @ LI,173 PSAY xQPed     Picture "@E 999,999.99"
     @ LI,189 PSAY xQEnt     Picture "@E 999,999.99"
     @ LI,205 PSAY xQPen     Picture "@E 999,999.99"
   	 LI := LI + 2
  Endif
EndDo
LI := 62
@ LI,01 PSAY Replicate("_",220)
LI := LI + 1
@ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
LI := LI + 1
@ LI,01 PSAY Replicate("_",220)
LI := LI + 1
@ LI,01 PSAY "."
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function Imp3(lEnd,WnRel,cString,aReturn,tamanho,limite,titulo,;
						cDesc1,cDesc2,cDesc3)
cabec1 	 := "CLIENTE                      PEDIDO  IT   EMISSAO    OC    PRODUTO      DESCRICAO                                 STATUS     OP      FRETE  ENTREGA  LIBERAÇÃO    VLR R$      ---------------  PEDIDO  ----------------" 
cabec2 	 := "                                                                                                                                                                  S/IPI       VENDIDO         ATENDIDO          SALDO   "

cQry := " SELECT SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_TPFRETE, SC5.C5_EMISSAO, SC5.C5_NOVULT, SC5.C5_VEND1, SC5.C5_PEDCLI,"
cQry := cQry + " SC6.C6_ITEM, SC6.C6_PRODUTO, SB1.B1_DESC, "
cQry := cQry + " SC6.C6_ENCOMED, SC6.C6_QTDVEN, SC6.C6_QTDENT, SC6.C6_PRCVEN,"
cQry := cQry + " SC6.C6_ENTREG, SC6.C6_TES, SA1.A1_NREDUZ, SA3.A3_NREDUZ"
cQry := cQry + " FROM SC5010 AS SC5, SC6010 AS SC6, SA1010 AS SA1, SB1010 AS SB1, SA3010 AS SA3"
cQry := cQry + " WHERE SC5.C5_NUM = SC6.C6_NUM"
cQry := cQry + " AND SA1.A1_COD = SC5.C5_CLIENTE"
cQry := cQry + " AND SA1.A1_LOJA = SC5.C5_LOJACLI"
cQry := cQry + " AND SB1.B1_COD = SC6.C6_PRODUTO"
cQry := cQry + " AND SC5.C5_VEND1 = SA3.A3_COD"
cQry := cQry + " AND SC6.C6_ENTREG >= '"+DTOS(MV_PAR02)+"'"
cQry := cQry + " AND SC6.C6_ENTREG <= '"+DTOS(MV_PAR03)+"'"
cQry := cQry + " AND SC5.C5_CLIENTE >= '"+MV_PAR04+"'"
cQry := cQry + " AND SC5.C5_CLIENTE <= '"+MV_PAR05+"'"
If !Empty(MV_PAR06)
   cQry := cQry + " AND SC5.C5_VEND1 = '"+MV_PAR06+"'"
Endif
cQry := cQry + " AND SC5.C5_TIPO = 'N'"
cQry := cQry + " AND SC6.C6_QTDVEN-SC6.C6_QTDENT>0"
cQry := cQry + " AND SC6.C6_TES NOT  IN ('508', '515', '516', '517', '521', '522', '523', '524', '528', '529', '531', '536', '537', '543', '544', '545', '546', '547', '548', '549', '550', '555', '556', '557')"
cQry := cQry + " AND SC6.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SC5.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SC5.C5_CLIENTE, SC6.C6_ENTREG ASC"

Tcquery cQry new alias "PEND"

xCod:=Space(6)
Ok:=.F.
xQPed:=0
xQEnt:=0
xQPen:=0
dbSelectArea("PEND")
SetRegua(RecCount())

While !EOF()

  IncRegua()

  If lAbortPrint
   	  @LI,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
  Endif

  DATLIB:=CTOD("  /  /  ")
  TSTSTAT()
  DbSelectArea("PEND") 
  If xStatus = " "
     dbSkip()
   	 Loop
  Endif                                          

  If LI > 58
     If Ok
        LI := 62
        @ LI,01 PSAY Replicate("_",220)
        LI := LI + 1
        @ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
        LI := LI + 1
        @ LI,01 PSAY Replicate("_",220)
     Endif
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
     If !Empty(MV_PAR06)
        @ LI,00 PSAY "*** VENDEDOR : " + PEND->C5_VEND1 + " - " + PEND->A3_NREDUZ
        LI := LI + 2
     Endif
  Endif   

  @ LI,00 PSAY PEND->C5_CLIENTE+"-"+PEND->A1_NREDUZ
  xQPed:=0
  xQEnt:=0
  xQPen:=0
  xCod:=PEND->C5_CLIENTE
//  XFRETE:=IIF(PEND->C5_TPFRETE="C","CIF","FOB")
    IF PEND->C5_TPFRETE="F"
       XFRETE := "FOB"
    ENDIF
    
    IF PEND->C5_TPFRETE="C"
       XFRETE := "CIF"
    ENDIF

    IF PEND->C5_TPFRETE <> "C" .AND. PEND->C5_TPFRETE <> "F" 
       XFRETE := "   "
    ENDIF
 

   
  While !EOF() .AND. PEND->C5_CLIENTE=xCod
     DATLIB:=CTOD("  /  /  ")
     TSTSTAT()
     DbSelectArea("PEND") 
     If xStatus = " "
        dbSkip()
     	Loop
     Endif                                          
     If LI > 58
        If Ok
           LI := 62
           @ LI,01 PSAY Replicate("_",220)
           LI := LI + 1
           @ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
           LI := LI + 1
           @ LI,01 PSAY Replicate("_",220)
        Endif
        Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
        If !Empty(MV_PAR06)
           @ LI,00 PSAY "*** VENDEDOR : " + PEND->C5_VEND1 + " - " + PEND->A3_NREDUZ
           LI := LI + 2
        Endif
        @ LI,00 PSAY PEND->C5_CLIENTE+"-"+PEND->A1_NREDUZ
     Endif   
     xOp:=Space(11)
     dbSelectArea("SC2")
     dbSetOrder(9)
     dbSeek(xFilial("SC2")+PEND->C5_NUM+PEND->C6_ITEM,.F.)
     If Found()
        xOp:=C2_NUM+C2_ITEM+C2_SEQUEN
     Endif
     @ LI,29       PSAY PEND->C5_NUM+"  "+PEND->C6_ITEM
     @ LI,PCol()+2 PSAY SUBSTR(PEND->C5_EMISSAO,7,2)+"/"+SUBSTR(PEND->C5_EMISSAO,5,2)+"/"+SUBSTR(PEND->C5_EMISSAO,3,2)
     @ LI,PCol()+2 PSAY PEND->C5_PEDCLI+"  "+ALLTRIM(PEND->C6_PRODUTO)+"  "+PEND->B1_DESC+"           "+XSTATUS+"    "+xOP+"  "+XFRETE
     @ LI,PCol()+3 PSAY SUBSTR(PEND->C6_ENTREG,7,2)+"/"+SUBSTR(PEND->C6_ENTREG,5,2)+"/"+SUBSTR(PEND->C6_ENTREG,3,2)
     If !Empty(PEND->C5_NOVULT)
        @ LI,PCol()+2 PSAY SUBSTR(PEND->C5_NOVULT,7,2)+"/"+SUBSTR(PEND->C5_NOVULT,5,2)+"/"+SUBSTR(PEND->C5_NOVULT,3,2)
     Else
        @ LI,PCol()+2 PSAY DATLIB
     Endif                                                      
     mvalor := 0.00
     mvalor := (PEND->C6_QTDVEN-PEND->C6_QTDENT)*PEND->C6_PRCVEN 
    // @ LI,PCol()+6 PSAY IIF(SC6->C6_ENCOMED='N',"NAO","SIM")
     @ LI,PCol()+1 PSAY mvalor Picture "9,999,999.99"    
     @ LI,PCol()+4 PSAY PEND->C6_QTDVEN Picture "@E 999,999.99"
     @ LI,PCol()+4 PSAY PEND->C6_QTDENT Picture "@E 999,999.99"
     @ LI,PCol()+4 PSAY PEND->C6_QTDVEN-PEND->C6_QTDENT Picture "@E 999,999.99"
     LI := LI + 1
     xQPed:=xQPed+PEND->C6_QTDVEN
     xQEnt:=xQEnt+PEND->C6_QTDENT
     xQPen:=xQPen+(PEND->C6_QTDVEN-PEND->C6_QTDENT)
     Ok:=.T. 
     DbSelectArea("PEND") 
     dbSkip()
  Enddo
  If Ok
     @ LI,173 SAY xQPed     Picture "@E 999,999.99"
     @ LI,189 PSAY xQEnt     Picture "@E 999,999.99"
     @ LI,205 PSAY xQPen     Picture "@E 999,999.99"
   	 LI := LI + 2
  Endif
EndDo
LI := 62
@ LI,01 PSAY Replicate("_",220)
LI := LI + 1
@ LI,01 PSAY "Status: 1-Liberado para faturar          2-Bloqueado no estoque          3-Bloqueado no crédito          4-Bloqueado em vendas"
LI := LI + 1
@ LI,01 PSAY Replicate("_",220)
LI := LI + 1
@ LI,01 PSAY "."
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function TSTSTAT()
  dbSelectArea("SC9")
  dbSetOrder(1)
  dbSeek(xFilial("SC9")+PEND->C5_NUM+PEND->C6_ITEM,.F.)
   
  If !Found()// Bloqueado em vendas
     xStatus:="4"
  Else
     While !EOF() .AND. PEND->C5_NUM=SC9->C9_PEDIDO .AND. PEND->C6_ITEM=SC9->C9_ITEM
        BLCRED:=C9_BLCRED               
        BLEST :=C9_BLEST
        DATLIB:=C9_DATALIB
      	dbSkip()
     Enddo
     If BLCRED="10" .and. BLEST="10" // Já faturado
        xStatus:=" "
     ElseIf (BLCRED="01" .and. BLEST="02") .or. (BLCRED="01" .and. BLEST="  ") // Bloqueado no crédito
        xStatus:="3"
     ElseIf BLCRED="  " .and. BLEST="02" // Bloqueado no estoque
        xStatus:="2"
     ElseIf BLCRED="  " .and. BLEST="  "
        xStatus:="1"  // Liberado para faturar
     Endif
  Endif

Return(NIL)

Static Function AjustaSX1()

LOCAL aArea    := GetArea()
LOCAL aReg     := {}

LOCAL nLoop    := 0
LOCAL nLoop2   := 0
LOCAL nPosCpo  := 0

AAdd(aReg,{	{"X1_GRUPO","RELPEN"},;
{"X1_ORDEM","01"},;
{"X1_PERGUNT","Entrega de        ?"},;
{"X1_PERSPA","Entrega de        ?"},;
{"X1_PERENG","Entrega de        ?"},;
{"X1_VARIAVL","mv_ch1"},;
{"X1_TIPO","D"},;
{"X1_TAMANHO",8},;
{"X1_DECIMAL",0},;
{"X1_PRESEL",0},;
{"X1_GSC","G"},;
{"X1_VALID",""},;
{"X1_VAR01","mv_par01"},;
{"X1_PYME","N"} })

AAdd(aReg,{	{"X1_GRUPO","RELPEN"},;
{"X1_ORDEM","02"},;
{"X1_PERGUNT","Entrega Ate        ?"},;
{"X1_PERSPA","Entrega Ate        ?"},;
{"X1_PERENG","Entrega Ate        ?"},;
{"X1_VARIAVL","mv_ch2"},;
{"X1_TIPO","D"},;
{"X1_TAMANHO",8},;
{"X1_DECIMAL",0},;
{"X1_PRESEL",0},;
{"X1_GSC","G"},;
{"X1_VALID","NAOVAZIO"},;
{"X1_VAR01","mv_par02"},;
{"X1_PYME","N"} })

AAdd(aReg,{	{"X1_GRUPO","RELPEN"},;
{"X1_ORDEM","03"},;
{"X1_PERGUNT","Cliente de        ?"},;
{"X1_PERSPA","Cliente de        ?"},;
{"X1_PERENG","Cliente de        ?"},;
{"X1_VARIAVL","mv_ch3"},;
{"X1_TIPO","C"},;
{"X1_TAMANHO",6},;
{"X1_DECIMAL",0},;
{"X1_PRESEL",0},;
{"X1_GSC","G"},;
{"X1_VALID",""},;
{"X1_VAR01","mv_par03"},;
{"X1_F3","SA1"},;
{"X1_PYME","N"} })

AAdd(aReg,{	{"X1_GRUPO","RELPEN"},;
{"X1_ORDEM","04"},;
{"X1_PERGUNT","Cliente Ate        ?"},;
{"X1_PERSPA","Cliente Ate        ?"},;
{"X1_PERENG","Cliente Ate        ?"},;
{"X1_VARIAVL","mv_ch4"},;
{"X1_TIPO","C"},;
{"X1_TAMANHO",6},;
{"X1_DECIMAL",0},;
{"X1_PRESEL",0},;
{"X1_GSC","G"},;
{"X1_VALID",""},;
{"X1_VAR01","mv_par04"},;
{"X1_F3","SA1"},;
{"X1_PYME","N"} })

dbSelectArea("SX1")
dbSetOrder(1)
For nLoop := 1 to Len(aReg)
	If !dbSeek(aReg[nLoop][1][2]+aReg[nLoop][2][2])
		RecLock("SX1",.T.)
		For nLoop2 := 1 to Len(aReg[nLoop])
			nPosCpo := SX1->(FieldPos(aReg[nLoop][nLoop2][1]))
			If nPosCpo > 0
				SX1->(FieldPut(nPosCpo,aReg[nLoop][nLoop2][2]))
			EndIf
		Next nLoop2
		MsUnlock()
	EndIf
Next nLoop

RestArea(aArea)
Return(NIL)