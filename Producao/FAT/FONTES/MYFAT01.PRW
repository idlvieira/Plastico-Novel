#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MYFAT01  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 16/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos nao entregues x Prazos                  ³±±
±±³          ³ Com observação de entrega, importação e disponibilidade.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT - R4                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteração ³ Descrição                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³13/06/2008³ Neto - Cópia do advpl MYFAT01, para inclusão de observação³±±
±±³          ³ referente ao cabeçalho do pedido de venda.                 ³±±
±±³  /  /    ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante      Motivo
// 29/08/2023  Leandro Ferreira          Totvs		   	  Migração para banco

User Function MYFAT01()

Local	oReport
Private	nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))

//MYRFAT98X()
MYFAT01X()


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MYFAT01X  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 16/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos nao entregues	x Prazos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³	MOTIVO DA ALTERACAO					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MYFAT01X()

LOCAL titulo    := OemToAnsi("Relacao de Pedidos nao entregues x Prazos")
LOCAL cDesc1    := OemToAnsi("Este programa ira emitir a relacao dos Pedidos Pendentes,")
LOCAL cDesc2    := OemToAnsi("imprimindo o numero do Pedido, Cliente, Data da Entrega, ")
LOCAL cDesc3    := OemToAnsi("Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso.")
LOCAL cString   := "SC6"
LOCAL tamanho   := "G"
LOCAL wnrel     := "MYFAT01" //"MYRFAT98"

PRIVATE aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))
PRIVATE nomeprog:= "MYFAT01"
PRIVATE cPerg	:= "MTR680"
PRIVATE cArqTrab:= ""
PRIVATE cFilTrab:= ""
PRIVATE nLastKey:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 				    	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    			 ³
//³ mv_par01				// Do Pedido	                     ³
//³ mv_par02				// Ate o Pedido	                     ³
//³ mv_par03				// Do Produto				         ³
//³ mv_par04				// Ate o Produto					 ³
//³ mv_par05				// Do Cliente						 ³
//³ mv_par06				// Ate o cliente					 ³
//³ mv_par07				// Da data de entrega	    		 ³
//³ mv_par08				// Ate a data de entrega			 ³
//³ mv_par09				// Em Aberto , Todos 				 ³
//³ mv_par10				// C/Fatur.,S/Fatur.,Todos 			 ³
//³ mv_par11				// Mascara							 ³
//³ mv_par12				// Aglutina itens grade 			 ³
//³ mv_par13				// Considera Residuos (Sim/Nao)		 ³
//³ mv_par14				// Lista Tot.Faturados(Sim/Nao)		 ³
//³ mv_par15				// Salta pagina na Quebra(Sim/Nao)	     ³
//³ mv_par16				// Do vendedor                 		 ³
//³ mv_par17				// Ate o vendedor                    |
//³ mv_par18				// Qual a moeda                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 					     ³
//| aOrd = Ordems Por Pedido/Produto/Cliente/Dt.Entrega/Vendedor |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aOrd :={"Por Pedido","Por Produto","Por Cliente","Por Dt.Entrega","Por Vendedor"}//alterado Daniel Coelho
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C680Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ C680Imp  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 16/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Chamada do Relatorio 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MYFAT01													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C680Imp(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis   										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL titulo    := OemToAnsi("Relacao de Pedidos nao entregues x Prazos")
LOCAL dData     := CtoD("  /  /  ")
LOCAL cTotPed   := "NUM = cNum"
LOCAL CbTxt     := ""
LOCAL cabec1    := ""
LOCAL cabec2    := ""
LOCAL tamanho   := "G"
LOCAL cNumPed   := ""
LOCAL cNumCli   := ""
LOCAL limite    := 220
LOCAL CbCont    := 0
LOCAL nOrdem    := 0
LOCAL nTotVen   := 0
LOCAL nTotEnt   := 0
LOCAL nTotSal   := 0
LOCAL nTotItem  := 0
LOCAL nFirst    := 0
LOCAL nSaldo    := 0
LOCAL nValor    := 0
LOCAL nCont     := 0
LOCAL lImpTot   := .F.
LOCAL lContinua := .T.
LOCAL nMoeda    := IIF(cPaisLoc == "BRA",MV_PAR18,1)
LOCAL nValorLq  := 0
LOCAL nTVGeral  := 0
LOCAL nTEGeral  := 0
LOCAL nTSGeral  := 0
LOCAL nTIGeral  := 0             
Local _cMens1	:= ""
Local _cMens2	:= ""
Local nCount	:= 0
Local ctipoCli	:= ""//Alterado Renato Castro em 21/03/14
Local cEstCli	:= ""//Alterado Renato Castro em 21/03/14
Local nTotalLiq	:= 0 //Alterado Renato Castro em 21/03/14
Local nTotalLiqPed	:= 0 //Alterado Renato Castro em 21/03/14
Local aDadosXLS := {}
Local nPrintXLS := 1
Local ti:='=t("'
Local tf:='")'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

nTipo   := IIF(aReturn[4]==1,15,18)
nOrdem  := aReturn[8]

aadd(aDadosXLS, {"Filial: "+AllTrim(SM0->M0_NOME)+": "+AllTrim(SM0->M0_CODFIL)+" - "+AllTrim(SM0->M0_NOMECOM),,,,,,,,,,,"Dt.Relatorio",date()})
aadd(aDadosXLS, {""})
aadd(aDadosXLS, {"CLIENTE","LOJA","NOME CLIENTE","SEGMENTO","DESC.SEGMENTO","NUMERO PEDIDO","ITEM PEDIDO","EMISSAO","ENTREGA","PRODUTO","DESCR.PRODUTO","QUANTIDADE PEDIDA","QUANTIDADE ENTREGUE","QUANTIDADE PENDENTE","VR TOTAL PENDENTE","VR LIQUIDO","SALDO EM ESTOQUE","QUANT.RECEBER","VENDEDOR","NOME VENDEDOR","FRETE","TES","ORÇAMENTO","PEDIDO CLIENTE","ITEM PED CLIENTE","1a.MENSAGEM","2a.MENSAGEM"})

Processa({|lEnd| C680Trb(@lEnd,wnRel,"TRB")},Titulo)

//                   999999 99/99/9999 999999xxxxxxxxxxxxxx/XXXXXXXX XX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 99/99/9999 999999999999 999999999999 999999999999
//                             1         2         3         4         5         6         7         8         9        10        11        12        13
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
dbSelectArea("TRB")

Do Case
	Case nOrdem = 1
		cQuebra := "NUM = cNum"
		titulo  := titulo +" - "+ "Por Pedido"
		cabec1  := "NUMERO  SEGMENTO DATA DE  SOLICIT. DATA DE             CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO              QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL   VALOR     SALDO EM   QUANT. "//Alterado Renato Castro em 21/03/14
		cabec2  := "PEDIDO           EMISSAO  ENTREGA  DISPONI.                                                                  PRODUTO                PEDIDA       ENTREGUE     PENDENTE        PENDENTE      LIQUIDO   ESTOQUE    RECEBER"//Daniel Coelho /Alterado Renato Castro em 21/03/14
//                  0123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x1234567890123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x
//					          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
	Case nOrdem = 2
		cQuebra := "PRODUTO = cProduto"
		titulo  := titulo + " - "+"Por Produto"
		cabec1  := "CODIGO DO       NUMERO SEGMENTO IT DATA DE   SOLICIT. DATA DE             CODIGO LOJA /NOME DO CLIENTE                              QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL   VALOR     SALDO EM   QUANT. " //Daniel Coelho
		cabec2  := "PRODUTO         PEDIDO             EMISSAO   ENTREGA  DISPONI.                                                                      PEDIDA       ENTREGUE     PENDENTE        PENDENTE      LIQUIDO   ESTOQUE    RECEBER"
//                  0123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x1234567890123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x
//					          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
	Case nOrdem = 3
		cQuebra := "CLIENTE+LOJA = cCli"
		titulo  := titulo + " - "+"Por Cliente"
		cabec1  := "CODIGO-LOJA/NOME DO CLIENTE                        NUMERO  SEGMENTO  IT DATA DE   SOLICIT. DATA DE             CODIGO DO              QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL  VALOR      SALDO EM   QUANT. "//Alterado Renato Castro em 21/03/14
		cabec2  := "                                                   PEDIDO               EMISSAO   ENTREGA  DISPONI.            PRODUTO                PEDIDA       ENTREGUE     PENDENTE        PENDENTE     LIQUIDO    ESTOQUE    RECEBER"//daniel Coelho / Alterado Renato Castro em 21/03/14
//                  0123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x1234567890123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x
//					          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
	Case nOrdem = 4
		cQuebra := "DATENTR = dEntreg"
		titulo  := titulo + " - Por Data de Entrega"
		cabec1  := "              NUMERO  SEGMENTO  DATA DE   SOLICIT. DATA DE   DATA DE   CODIGO LOJA /NOME DO CLIENTE         IT CODIGO DO              QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL  VALOR      SALDO EM   QUANT. "
		cabec2  := "              PEDIDO            EMISSAO   ENTREGA  DISPONI.  ENTREGA                                           PRODUTO                PEDIDA       ENTREGUE     PENDENTE        PENDENTE     LIQUIDO    ESTOQUE    RECEBER" //Daniel Coelho
//                  0123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x1234567890123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x
//					          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
	Case nOrdem = 5
		cQuebra := "VENDEDOR = cVde"
		titulo  := titulo + " - Por Vendedor"
		cabec1  := "CODIGO VENDEDOR                                 NUMERO  SEGMENTO  NUMERO  IT CODIGO DO              DATA DE   SOLICIT. DATA DE                QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL  VALOR      SALDO EM   QUANT. "
		cabec2  := "                                                PEDIDO            CLIENTE    PRODUTO                EMISSAO   ENTREGA  DISPONI.               PEDIDA       ENTREGUE     PENDENTE        PENDENTE     LIQUIDO    ESTOQUE    RECEBER" //Daniel Coelho
//                  0123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x1234567890123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x
//			          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1

EndCase

titulo += " - " + GetMv("MV_MOEDA"+STR(nMoeda,1))		//" MOEDA "
dbSelectArea("TRB")
dbGoTop()
Count to nCount
dbGoTop()
SetRegua(nCount)                    	// TOTAL DE ELEMENTOS DA REGUA

nFirst 	:= 0
_cMens1	:= ""
_cMens2	:= ""
cMensImp := ''
cMensDis := ''
cMensEnt := ''

While !Eof() .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF li > 58 .Or.( MV_PAR15 = 1 .And.!&cQuebra)
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica campo para quebra									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNum	:= NUM
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	cSeg    := SEGMENTO  //Daniel Coelho
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis Totalizadoras     		    					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotSal += nSaldo
	nTotVen += QUANTIDADE
	nTotEnt += ENTREGUE
    nValor  := xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
    
	If !(TRB->GRADE == "S" .And. MV_PAR12 == 1)
       nTotItem+= nValor
       nTIGeral+= nValor
    EndIf	
    
	If nTotVen > QUANTIDADE .Or. nTotEnt > ENTREGUE
		lImpTot := .T.
	Else
		lImpTot := .F.
	EndIf
	
	IF (nFirst = 0 .And. nOrdem != 4).Or. nOrdem == 4
		
		li++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o cabecalho da linha		    					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case nOrdem = 1

			Case nOrdem = 2

			Case nOrdem = 3
				@li,  0 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 45)
//				@li, 51 Psay NUM
			Case nOrdem = 4
				If cNumPed+cNumCli+DtoS(dData) != NUM+CLIENTE+DtoS(DATENTR)
					cNumPed := NUM
					cNumCli := CLIENTE
				Else
					li--
				EndIf
				dData := DATENTR
			Case nOrdem = 5
				@li,  0 Psay Left(TRB->VENDEDOR+" "+NOMEVEN, 47)    
//     		Case nOrdem = 6  //Daniel Coelho
     			
		EndCase
		
		IF nFirst = 0 .And. nOrdem != 4
			nFirst := 1
		Endif
		
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aglutina os produtos da grade conforme o parametro MV_PAR12  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF TRB->GRADE == "S" .And. MV_PAR12 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nOrdem = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
        nValor  := 0
		nReg    := 0
		
		While !Eof() .And.xFilial("SC6") == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNum == NUM
			
			nReg	 := Recno()
			
			nTotVen += QUANTIDADE
			nTotEnt += ENTREGUE
			nSaldo  += QUANTIDADE-ENTREGUE
    	    nValor  += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
			
			dbSelectArea("TRB")
			IncRegua()
			dbSkip()
			
			lImpTot := .T.
			
		End
		
		nTotSal += nSaldo
        nTotItem+= nValor
		nTIGeral+= nValor
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime a linha Conforme a ordem selecionada na setprint	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		Case nOrdem = 1
			@li,  0 Psay NUM
        	@li, 08 Psay Substr(TRB->SEGMENTO,1,10)
			@li, 16 Psay TRB->EMISSAO
			@li, 55 Psay Left(CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI, 45)//Alterado Renato Castro em 21/03/14
			@li, 27 Psay MYDATEN
			@li,107 Psay ITEM //Alterado Renato Castro em 21/03/14
			@li,110 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)//Alterado Renato Castro em 21/03/14
		Case nOrdem = 2
			@li,  0 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 16 Psay NUM
        	@li, 24 Psay Substr(TRB->SEGMENTO,1,10)
			@li, 32 Psay ITEM
			@li, 35 Psay EMISSAO
			@li, 45 Psay MYDATEN
			@li, 74 Psay Left(TRB->CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI,45)//Alterado Renato Castro em 21/03/14
		Case nOrdem = 3     
			@li, 51 Psay NUM					// MARCIO DIAS
        	@li, 59 Psay Substr(TRB->SEGMENTO,1,10)
			@li, 69 Psay ITEM
			@li, 72 Psay EMISSAO
			@li, 82 Psay MYDATEN
			@li,111 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO) //Alterado Renato Castro em 21/03/14
		Case nOrdem = 4
			@li, 14 Psay NUM
         	@li, 22 Psay Substr(TRB->SEGMENTO,1,10)
			@li, 30 Psay EMISSAO
			@li, 40 Psay MYDATEN
			@li, 69 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 35)//Alterado Renato Castro em 21/03/14
			@li,106 Psay ITEM //Alterado Renato Castro em 21/03/14
			@li,109 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamRef),PRODUTO)//Alterado Renato Castro em 21/03/14
		OtherWise
			@li, 48 Psay NUM
        	@li, 56 Psay Substr(TRB->SEGMENTO,1,10)
			@li, 64 Psay ITEM
			@li, 67 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 90 Psay EMISSAO
			@li,100 Psay MYDATEN
	EndCase
	
	@li,128 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotVen,QUANTIDADE)	    PICTURE PesqPictQt("C6_QTDVEN",12)//Alterado Renato Castro em 21/03/14
	@li,141 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotEnt,ENTREGUE)		PICTURE PesqPictQt("C6_QTDENT",12)//Alterado Renato Castro em 21/03/14
	@li,154 Psay nSaldo														PICTURE PesqPictQt("C6_QTDVEN",12)//Alterado Renato Castro em 21/03/14
	@li,170 Psay nValor														PICTURE PesqPict("SC6","C6_VALOR",13) //Alterado Renato Castro em 21/03/14

	//INICIO Alterado Renato Castro em 21/03/14
	ctipoCli := Posicione("SA1",1,xFilial("SA1")+CLIENTE+LOJA,"A1_TIPO")
	If cTipoCli == 'X'
	    nValorLq := nValor
		@li,183 Psay nValor													PICTURE PesqPict("SC6","C6_VALOR",13)//Alterado Renato Castro em 21/03/14  
		nTotalLiq += nValor
		nTotalLiqPed += nValor
	Else
		cEstCli := Posicione("SA1",1,xFilial("SA1")+CLIENTE+LOJA,"A1_EST")
		Do Case
			Case cEstCli $ ("AC;AL;AM;AP;BA;CE;DF;ES;GO;MA;MS;MT;PA;PB;PE;PI;RN;RO;RR;SE;TO")
			    nValorLq := nValor*0.8375
				@li,183 Psay nValorLq										PICTURE PesqPict("SC6","C6_VALOR",13)//Alterado Renato Castro em 21/03/14  
				nTotalLiq += nValorLq
				nTotalLiqPed += nValorLq
			Case cEstCli $ ("MG;PR;RJ;RS;SC")
			    nValorLq := nValor*0.7875
				@li,183 Psay nValorLq										PICTURE PesqPict("SC6","C6_VALOR",13)//Alterado Renato Castro em 21/03/14  
				nTotalLiq += nValorLq
				nTotalLiqPed += nValorLq
			Case cEstCli $ ("SP;EX")
			    nValorLq := nValor*0.7275
				@li,183 Psay nValorLq										PICTURE PesqPict("SC6","C6_VALOR",13)//Alterado Renato Castro em 21/03/14  	
				nTotalLiq += nValorLq
				nTotalLiqPed += nValorLq
			OtherWise                                                                                                           
				nValorLq := nValor*0.7275
				@li,183 Psay nValorLq										PICTURE PesqPict("SC6","C6_VALOR",13)//Alterado Renato Castro em 21/03/14  	
				nTotalLiq += nValorLq
				nTotalLiqPed += nValorLq
		EndCase
	EndIf
	
	// Incluido por Michel em 24/09/07
	_cMens1	 := TRB->MENNOTA
	_cMens2	 := TRB->MYOBS2

	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+TRB->PRODUTO )
	
	dbSelectArea("SB2")		
	dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD )	
	                                                      
	@li,196 Psay SB2->B2_QATU		PICTURE "@E 999999.99"//Alterado Renato Castro em 21/03/14
	@li,205 Psay SB2->B2_SALPEDI	PICTURE "@E 9999999.99" //Alterado Renato Castro em 21/03/14
		
	dbSelectArea("TRB")
	
	nCont++
	li++
	
	//04/01/2019 Leonardo Bergamasco - Ticket 89J-XEN-RYLY - Inserido recurso para envio dados para excel
	aadd(aDadosXLS, {ti+CLIENTE+tf,ti+LOJA+tf,AllTrim(TRB->NOMECLI),ti+Substr(TRB->SEGMENTO,1,10)+tf,AllTrim(LEFT(TRB->DESCSEG,30)),ti+NUM+tf,ti+ITEM+tf,EMISSAO,MYDATEN,ti+IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)+tf,AllTrim(DESCRICAO),IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotVen,QUANTIDADE),IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotEnt,ENTREGUE),nSaldo,nValor,nValorLq,SB2->B2_QATU,SB2->B2_SALPEDI,ti+TRB->VENDEDOR+tf,AllTrim(NOMEVEN),ti+TRB->TPFRETE+tf,ti+TRB->TES+tf,ti+TRB->PEDCLI+tf,ti+TRB->NUMPCOM+tf,ti+TRB->ITEMPC+tf,_cMens1,_cMens2})
		
	dbSelectArea("TRB")
	IncRegua()
	dbSkip()   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total do Pedido                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !&cTotPed
       If nOrdem = 1 .Or. nOrdem = 3 .Or.  nOrdem = 4 .Or. (nOrdem == 5 .And. !&cQuebra)
                     
           If !Empty(_cMens1)	//	TRB->MENNOTA	//	Fabricio M Vieira	25/04/2008
           		@Li,000 Psay "Obs.: " + _cMens1
           		If !Empty(_cMens2)
           			Li++
           			@Li,000 Psay _cMens2
           		Endif                                  
           ElseIf Empty(_cMens1) .AND. !Empty(_cMens2) 
           		@Li,000 Psay "Obs.: " + _cMens2
           Endif           
           		
           Li ++
           if ! empty(cMensImp)
              @Li,000 Psay 'Obs.Importação: ' + cMensImp
              ++Li
           endif
           if ! empty(cMensDis)
              @Li,000 Psay 'Obs.Disponibilidade: ' + cMensDis
              ++Li
           endif
           if ! empty(cMensEnt)
              @Li,000 Psay 'Obs.Entrega: ' + cMensEnt
              ++Li
           endif
                      
           @Li,000 Psay "TOTAL --------->"
           @Li,170 Psay nTotItem picture pesqpict('SC6', 'C6_VALOR', 15)//Alterado Renato Castro em 21/03/14
           @Li,183 Psay nTotalLiqPed picture pesqpict('SC6', 'C6_VALOR', 15)//Alterado Renato Castro em 21/03/14
           If nOrdem = 3 
              li+=2
           Else
              li++
           ENdif
	       nTotitem:= 0	
	       nTotalLiqPed:= 0	
       EndIf
    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total ou linha divisora conforme a quebra		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cQuebra
		
		If (MV_PAR15 = 1 .And. nOrdem = 2) .Or. MV_PAR15 = 2
			
			If nOrdem = 2         
	           If !Empty(TRB->MENNOTA)
	           		@Li,000 Psay "Obs.: " + TRB->MENNOTA
	           		If !Empty(TRB->MYOBS2)
	           			Li++
	           			@Li,000 Psay TRB->MYOBS2
	           		Endif                                  
	           ElseIf Empty(TRB->MENNOTA) .AND. !Empty(TRB->MYOBS2) 
	           		@Li,000 Psay "Obs.: " + TRB->MYOBS2
	           Endif           
	           		
	           Li ++			
	           If !Empty(TRB->MENNOTA)
	           		@Li,000 Psay "Obs.: " + TRB->MENNOTA
	           		If !Empty(TRB->MYOBS2)
	           			Li++
	           			@Li,000 Psay TRB->MYOBS2
	           		Endif                                  
	           ElseIf Empty(TRB->MENNOTA) .AND. !Empty(TRB->MYOBS2) 
	           		@Li,000 Psay "Obs.: " + TRB->MYOBS2
	           Endif           
	           		
	           Li ++
   			   @Li,000 Psay "TOTAL --------->"

			   //Alterado Renato Castro em 21/03/14                                                 
			   @Li,132 Psay nTotVen PICTURE PesqPictQt("C6_QTDVEN",12)
			   @Li,145 Psay nTotEnt PICTURE PesqPictQt("C6_QTDENT",12)
			   @Li,158 Psay nTotSal PICTURE PesqPictQt("C6_QTDVEN",12)
			   li++
			Endif
			
			If nTotVen > 0 .And. nOrdem != 1
				@li,  0 Psay __PrtThinLine()
				li++
			Endif
			
		Endif

		nTVGeral += nTotVen
		nTEGeral += nTotEnt
		nTSGeral += nTotSal
				
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
		nCont   := 0
		nFirst  := 0
		
	Endif
	
End

If nTIGeral > 0 
	If li >= 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	li++
	@Li,000 Psay "TOTAL GERAL --->"

	//Alterado Renato Castro em 21/03/14
	@Li,132 Psay nTVGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li,145 Psay nTEGeral PICTURE PesqPictQt("C6_QTDENT",12)
	@Li,158 Psay nTSGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li,170 Psay nTIGeral PICTURE PesqPict("SC6","C6_VALOR",15)
	@Li,185 Psay nTotalLiq PICTURE PesqPict("SC6","C6_VALOR",15)
EndIf

If li != 80
	Roda(cbcont,cbtxt)
Endif

dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Do While nPrintXLS > 0 .and. nPrintXLS < 2
  nPrintXLS := Aviso("Novel","Deseja enviar dados para Excel?",{"Sim","Não/Sair"},2,"Relação Pedido não entregues x prazos")
  If nPrintXLS > 0 .and. nPrintXLS < 2
    DlgToExcel({ {"ARRAY", "Relação de Pedidos não entregues x prazos", {""}, aDadosXLS} })	
  EndIf
EndDo

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ C680TRB  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 16/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria Arquivo de Trabalho                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MYFAT01													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C680TRB(nOrdem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aCampos   := {}
LOCAL aTam      := ""
LOCAL cKey      := ""
LOCAL cCondicao := ""
LOCAL cVend     := ""
LOCAL cVendedor := ""
LOCAL cAliasSC6 := "SC6"
LOCAL cPedIni   := MV_PAR01
LOCAL cPedFim   := MV_PAR02
LOCAL cProIni   := MV_PAR03
LOCAL cProFim   := MV_PAR04
LOCAL cCliIni   := MV_PAR05
LOCAL cCliFim   := MV_PAR06
LOCAL cDatIni   := MV_PAR07
LOCAL cDatFim   := MV_PAR08
LOCAL nTipVal   := IIF(cPaisLoc == "BRA",MV_PAR19,MV_PAR20)
LOCAL nSaldo    := 0
LOCAL nX        := 0
LOCAL nQtdVend  := 1 //FA440CntVen() // Retorna a quantidade maxima de Vendedores - Comentado por Daniel
LOCAL nValor	:= 0
LOCAL cQueryAdd := ""
LOCAL nCount	:= 0
Local oTemp	
Local cTable 	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NOME")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"     ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"     ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MENNOTA")
AADD(aCampos,{ "MENNOTA"   ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("C5_ZZOBS2")
AADD(aCampos,{ "MYOBS2"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("C6_ZZDATEN")
AADD(aCampos,{"MYDATEN"    ,"D",aTam[1],aTam[2] } )

aTam:=TamSX3("A1_ZZSEG")
aadd(aCampos,{"SEGMENTO"   ,"C",aTam[1],aTam[2] } )  

aTam:=TamSX3("C6_DESCRI")
aadd(aCampos,{"DESCSEG"   ,"C",aTam[1],aTam[2] } )  
aTam:=TamSX3("C6_PEDCLI")
aadd(aCampos,{"PEDCLI"   ,"C",aTam[1],aTam[2] } )  
aTam:=TamSX3("C6_NUMPCOM")
aadd(aCampos,{"NUMPCOM"   ,"C",aTam[1],aTam[2] } )  
aTam:=TamSX3("C6_ITEMPC")
aadd(aCampos,{"ITEMPC"   ,"C",aTam[1],aTam[2] } )  
aTam:=TamSX3("C5_TPFRETE")
aadd(aCampos,{"TPFRETE"    ,"C",aTam[1],aTam[2] } )  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cArqTrab := CriaTrab(aCampos,.T.)
//dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)
		oTemp := FWTemporaryTable():New( "TRB" )
		oTemp:SetFields(aCampos)
		oTemp:AddIndex("1", {"FILIAL","NUM","ITEM","PRODUTO"} )
		oTemp:AddIndex("2", {"FILIAL","PRODUTO","NUM","ITEM"} )
		oTemp:AddIndex("3", {"FILIAL","CLIENTE","LOJA","NUM","ITEM"} )
		oTemp:AddIndex("4", {"FILIAL","DATENTR","NUM","ITEM"} )
		oTemp:AddIndex("5", {"FILIAL","VENDEDOR","NUM","ITEM"} )
		oTemp:Create()

nOrdem  := aReturn[8]
		cTable := oTemp:GetRealName() 
dbSelectArea("TRB")
/*Do Case
	Case nOrdem = 1
		IndRegua("TRB",cTable,"FILIAL+NUM+ITEM+PRODUTO",,,"Selecionando Registros...")
	Case nOrdem = 2
		IndRegua("TRB",cTable,"FILIAL+PRODUTO+NUM+ITEM",,,"Selecionando Registros...")
	Case nOrdem = 3
		IndRegua("TRB",cTable,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,"Selecionando Registros...")
	Case nOrdem = 4
		IndRegua("TRB",cTable,"FILIAL+DTOS(DATENTR)+NUM+ITEM",,,"Selecionando Registros...")
	Case nOrdem = 5
		IndRegua("TRB",cTable,"FILIAL+VENDEDOR+NUM+ITEM",,,"Selecionando Registros...")   
EndCase*/

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)

#IFDEF TOP
	
	cAliasSC6 := "MR680Trab"
	aStruSC6  := SC6->(dbStruct())
	cQuery    := "SELECT SC6.*, ZZZ.ZZZ_RETORN "
	cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += "LEFT JOIN SA1010 AS SA1 ON A1_COD=C6_CLI AND A1_LOJA=C6_LOJA AND SA1.D_E_L_E_T_!='*' "
	cQuery += "LEFT JOIN ZZZ010 AS ZZZ ON ZZZ_FILIAL=C6_FILIAL AND ZZZ_COD='FAT000005' AND ZZZ_DESCCO=A1_ZZSEG AND ZZZ.D_E_L_E_T_!='*' "
	cQuery += "WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND "
	cQuery += "C6_NUM >= '"+cPedIni+"' AND "
	cQuery += "C6_NUM <= '"+cPedFim+"' AND "
	cQuery += "C6_PRODUTO >= '"+cProIni+"' AND "
	cQuery += "C6_PRODUTO <= '"+cProFim+"' AND "
	cQuery += "C6_CLI >= '"+cCliIni+"' AND "
	cQuery += "C6_CLI <= '"+cCliFim+"' AND "
	cQuery += "C6_ZZDATEN >= '"+Dtos(cDatIni)+"' AND "
	cQuery += "C6_ZZDATEN <= '"+Dtos(cDatFim)+"' AND  "
	
	If mv_par13 == 3
		cQuery += "C6_BLQ = 'R ' AND "
	Endif	
	
	cQuery += "SC6.D_E_L_E_T_ = ' ' "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para tratamento do filtro do usuario.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("F680QRY")
		cQueryAdd := ExecBlock("F680QRY", .F., .F., {aReturn[7]})
		If ValType(cQueryAdd) == "C"
			cQuery += " AND ( " + cQueryAdd + ")"
		EndIf
	EndIf
	
	cQuery += "ORDER BY "+SqlOrder(IndexKey())
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)
	
	For nX := 1 To Len(aStruSC6)
		If ( aStruSC6[nX][2] <> "C" )
			TcSetField(cAliasSC6,aStruSC6[nX][1],aStruSC6[nX][2],aStruSC6[nX][3],aStruSC6[nX][4])
		EndIf
	Next nX
	
	dbSelectArea(cAliasSC6)
	
#ELSE
	
	cFilTrab   := CriaTrab("",.F.)
	cCondicao  := "C6_FILIAL=='"+xFilial("SC6")+"'.And."
	cCondicao  += "C6_NUM>='"+MV_PAR01+"'.And.C6_NUM<='"+MV_PAR02+"'.And."
	cCondicao  += "C6_PRODUTO>='"+MV_PAR03+"'.And.C6_PRODUTO<='"+MV_PAR04+"'.And."
	cCondicao  += "C6_CLI>='"+MV_PAR05+"'.And.C6_CLI<='"+MV_PAR06+"'.And."
	cCondicao  += "Dtos(C6_ZZDATEN)>='"+Dtos(MV_PAR07)+"'.And.Dtos(C6_ZZDATEN)<='"+Dtos(MV_PAR08)+"'"
	If mv_par13 == 3
		cCondicao += " .And. C6_BLQ == 'R ' "
	Endif	
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	IndRegua("SC6",cFilTrab,IndexKey(),,cCondicao,"Selecionando Registros...")
	dbGoTop()
	
#ENDIF

Count to nCount
dbGoTop()

ProcRegua(nCount)                                         // Total de Elementos da Regua

While !Eof() .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6")
	
	If ( Empty(aReturn[7]) .Or. &(aReturn[7]) )
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial()+ (cAliasSC6)->C6_CLI + (cAliasSC6)->C6_LOJA )
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek( xFilial(("SF4"))+(cAliasSC6)->C6_TES )
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( xFilial(("SC5"))+(cAliasSC6)->C6_NUM )
		
		dbSelectArea(cAliasSC6)
		
		If cPaisLoc <> "BRA"
			If ( SF4->F4_ESTOQUE == "S" .And. mv_par18 == 2 ) .Or. ( SF4->F4_ESTOQUE!= "S" .And. mv_par18 == 1 )
				dbSkip()
				Loop
			Endif
			If mv_par19 <> 4 .And. SC5->(FIELDPOS("C5_DOCGER")) > 0
				If (mv_par19 == 1 .And. SC5->C5_DOCGER <> '1' ) .Or.;//Gera nota
					(mv_par19 == 2 .And. SC5->C5_DOCGER <> '2' ) .Or.;//Gera REMITO
					(mv_par19 == 3 .And. SC5->C5_DOCGER <> '3' ) //Entrega futura
					dbSkip()
					Loop
				Endif
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta dentro dos parametros						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc((cAliasSC6)->C6_PRODUTO,MV_PAR11)
		
		If Alltrim((cAliasSC6)->C6_BLQ) == "R" .and. mv_par13 == 2 // Se Foi Eliminado Residuos
			nSaldo  := 0
		Else
			nSaldo  := C6_QTDVEN-C6_QTDENT
		Endif
		
		If ((C6_QTDENT < C6_QTDVEN .And. MV_PAR09 == 1) .Or. (MV_PAR09 == 2)).And.;
			((nSaldo == 0 .And. MV_PAR14 == 1.And.Alltrim((cAliasSC6)->C6_BLQ)<>"R").Or. nSaldo <> 0).And.;
			((SF4->F4_DUPLIC == "S" .And. MV_PAR10 == 1) .Or. (SF4->F4_DUPLIC == "N";
			.And. MV_PAR10 == 2).Or.(MV_PAR10 == 3));
			.And. At(SC5->C5_TIPO,"DB") = 0 .And.lRet
			
			If nOrdem = 5
				
				cVend := "1"
				
				For nX := 1 to nQtdVend
					
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					
					If !EMPTY(cVendedor) .And. (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						
						dbSelectArea("SA3")
						dbSetOrder(1)
						dbSeek( xFilial()+cVendedor)
						
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						
						REPLACE VENDEDOR   WITH cVendedor
						REPLACE NOMEVEN    WITH SA3->A3_NOME
						REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
						REPLACE NUM        WITH (cAliasSC6)->C6_NUM
						REPLACE EMISSAO    WITH SC5->C5_EMISSAO
						REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
						REPLACE NOMECLI    WITH SA1->A1_NOME
						REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
						REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
						REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
						REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
						REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
						REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
						REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
						REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
						REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
						REPLACE TES        WITH (cAliasSC6)->C6_TES
						REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
						REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI
						
						REPLACE MENNOTA    WITH SC5->C5_MENNOTA
						REPLACE MYOBS2     WITH SC5->C5_ZZOBS2
						REPLACE MYDATEN    WITH (cAliasSC6)->C6_ZZDATEN

						REPLACE SEGMENTO   WITH SA1->A1_ZZSEG
						
						REPLACE DESCSEG    WITH (cAliasSC6)->ZZZ_RETORN
						REPLACE PEDCLI     WITH (cAliasSC6)->C6_PEDCLI
						REPLACE NUMPCOM    WITH (cAliasSC6)->C6_NUMPCOM
						REPLACE ITEMPC     WITH (cAliasSC6)->C6_ITEMPC
						REPLACE TPFRETE    WITH SC5->C5_TPFRETE
						REPLACE TES        WITH (cAliasSC6)->C6_TES
						
						
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasSC6)->C6_VALOR						
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasSC6)->C6_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf							
						REPLACE VALOR      WITH nValor
						REPLACE MOEDA      WITH SC5->C5_MOEDA
						
						MsUnLock()
						
					Endif
					
					dbSelectArea("SC5")
					dbSetOrder(1)
					
				Next nX
				
			Else
				
				lVend := .F.
				cVend := "1"
				
				For nX := 1 to nQtdVend
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					If (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						lVend :=.T.
						Exit
					Endif

				Next nX
				
				If lVend
				
				    dbSelectArea("SA3")
				    dbSetOrder(1)
  				    dbSeek( xFilial()+cVendedor)
					
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					
					REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
					REPLACE NUM        WITH (cAliasSC6)->C6_NUM
					REPLACE EMISSAO    WITH SC5->C5_EMISSAO
					REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
					REPLACE NOMECLI    WITH SA1->A1_NOME
					REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
					REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
					REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
					REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
					REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
					REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
					REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
					REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
					REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
					REPLACE TES        WITH (cAliasSC6)->C6_TES
					REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
					REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI
					
					REPLACE VENDEDOR   WITH cVendedor
					REPLACE NOMEVEN    WITH SA3->A3_NOME
					
					REPLACE MENNOTA    WITH SC5->C5_MENNOTA
					REPLACE MYOBS2     WITH SC5->C5_ZZOBS2 

					REPLACE MYDATEN    WITH (cAliasSC6)->C6_ZZDATEN

                    REPLACE SEGMENTO   WITH SA1->A1_ZZSEG
                    
					REPLACE DESCSEG    WITH (cAliasSC6)->ZZZ_RETORN
					REPLACE PEDCLI     WITH (cAliasSC6)->C6_PEDCLI
					REPLACE NUMPCOM    WITH (cAliasSC6)->C6_NUMPCOM
					REPLACE ITEMPC     WITH (cAliasSC6)->C6_ITEMPC
					REPLACE TPFRETE    WITH SC5->C5_TPFRETE
					REPLACE TES        WITH (cAliasSC6)->C6_TES
                    
					If nTipVal == 1 //--  Imprime Valor Total do Item
						nValor:=(cAliasSC6)->C6_VALOR						
					Else
						//--  Imprime Saldo
						If TRB->QUANTIDADE==0
							nValor:=(cAliasSC6)->C6_VALOR
						Else
							nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
							nValor := If(nValor<0,0,nValor)
						EndIf
					EndIf						
					REPLACE VALOR      WITH nValor
					REPLACE MOEDA      WITH SC5->C5_MOEDA
					
					lVend := .F.
					
					MsUnLock()
					
				Endif
				
			Endif
			
		Endif
		
	Endif
	
	dbSelectArea(cAliasSC6)
	IncProc()
	dbSkip()
	
End

#IFDEF TOP
	dbSelectArea(cAliasSC6)
	dbClosearea()
	dbSelectArea("SC6")
#ELSE
	dbSelectArea("SC6")
	RetIndex("SC6")
#ENDIF
