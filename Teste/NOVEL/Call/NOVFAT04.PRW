
Static STR0001 := "Relacao de Pedidos nao entregues"
Static STR0002 := "Este programa ira emitir a relacao dos Pedidos Pendentes,"
Static STR0003 := "imprimindo o numero do Pedido, Cliente, Data da Entrega, "
Static STR0004 := "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
Static STR0005 := "Zebrado"
Static STR0006 := "Administracao"
#define STR0007  "Por Pedido"
Static STR0008 := "Por Produto"
#define STR0009  "Por Cliente"
Static STR0010 := "Por Dt.Entrega"
Static STR0011 := "NUMERO DATA DE    CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                   DATA DE         QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
Static STR0012 := "PEDIDO EMISSAO                                                          PRODUTO         MATERIAL                       ENTREGA         PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
#define STR0013  "CODIGO DO       DESCRICAO DO                   NUMERO IT DATA DE      DATA DE      CODIGO LOJA /NOME DO CLIENTE                        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
Static STR0014 := "PRODUTO         MATERIAL                       PEDIDO    EMISSAO      ENTREGA                                                          PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
Static STR0015 := "Selecionando Registros..."
#define STR0016  "CODIGO-LOJA/NOME DO CLIENTE                        NUMERO IT DATA DE      CODIGO DO        DESCRICAO DO                   DATA DE      QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
Static STR0017 := "                                                   PEDIDO    EMISSAO      PRODUTO          MATERIAL                       ENTREGA      PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
Static STR0018 := " - Por Data de Entrega"
#define STR0019  " DATA DE      NUMERO DATA DE      CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                   QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
Static STR0020 := " ENTREGA      PEDIDO EMISSAO                                                            PRODUTO         MATERIAL                       PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
Static STR0021 := "CANCELADO PELO OPERADOR"
#define STR0022  "Por Vendedor"
#define STR0023  "CODIGO VENDEDOR                                 NUMERO IT  DATA DE      CODIGO DO       DESCRICAO DO                   DATA DE         QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
Static STR0024 := "                                                PEDIDO     EMISSAO      PRODUTO         MATERIAL                       ENTREGA         PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
Static STR0025 := "TOTAL --------->"
Static STR0026 := "TOTAL GERAL --->"
Static STR0027 := "Relacao de Pedidos nao entregues"
Static STR0028 := "Este programa ira emitir a relacao dos Pedidos Pendentes,"
Static STR0029 := "imprimindo o numero do Pedido, Cliente, Data da Entrega, "
Static STR0030 := "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
Static STR0031 := "Total do Pedido"
Static STR0032 := "Total do Produto"
Static STR0033 := "Total do Cliente"
Static STR0034 := "Total da Dt.Entrega"
Static STR0035 := "Total do Vendedor"
Static STR0036 := "Quant.Pendente"
Static STR0037 := "ValorTotal Pendente"
Static STR0038 := "Gerando Tabela de Trabalho. Aguarde..."
Static STR0039 := "TOTAL ----->"
Static STR0040 := "Selecionando Registros..."
#define STR0041  "Por Pedido"
Static STR0042 := "Por Produto"
#define STR0043  "Por Cliente"
#define STR0044  "Por Data"
#define STR0045  "Por Vendedor"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ NOVFAT04 ³ Autor Rui Ronaldo Scandiuzzi  ³ Data ³ 02.06.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NOVFAT04()

LOCAL titulo     := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL cDesc1     := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2     := OemToAnsi(STR0003)	//"imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3     := OemToAnsi(STR0004)	//"Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL cString    := "SC6"
LOCAL tamanho    := "G"
LOCAL wnrel      := "NOVFAT04"
LOCAL aregs      := {}

PRIVATE aReturn  := { STR0005, 1,STR0006, 1, 2, 1, "", IIf(isBlind(), val(SX4->X4_ORDEM), 1) }      //"Zebrado"###"Administracao"
PRIVATE nTamRef  := Val(Substr(GetMv("MV_MASCGRD"),1,2))
PRIVATE nomeprog := "NOVFAT04"
PRIVATE cPerg	 :=	"NOVFAT04  "
PRIVATE cArqTrab := ""
PRIVATE cFilTrab := ""
PRIVATE nLastKey := 0

AADD(AREGS,{CPERG,"01","Do Pedido ?","¿De Pedido ?","From order ?","mv_ch1","C",6,0,0,"G","","mv_ped_de","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"02","Ate o Pedido ?","¿A Pedido ?","To order ?","mv_ch2","C",6,0,0,"G","","mv_ped_ate","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"03","Do Produto ?","¿De Producto ?","From product ?","mv_ch3","C",15,0,0,"G","","mv_prod_de","","","","","","","","","","","","","","","","","","","","","","","","","SB1","S","030","","",""})
AADD(AREGS,{CPERG,"04","Ate o Produto ?","¿A Producto ?","To product ?","mv_ch4","C",15,0,0,"G","","mv_prod_ate","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1","S","030","","",""})
AADD(AREGS,{CPERG,"05","Do Cliente ?","¿De Cliente ?","From customer ?","mv_ch5","C",6,0,0,"G","","mv_cli_de","","","","","","","","","","","","","","","","","","","","","","","","","CLI","S","001","","",""})
AADD(AREGS,{CPERG,"06","Ate o Cliente ?","¿A Cliente ?","To customer ?","mv_ch6","C",6,0,0,"G","","mv_cli_ate","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","CLI","S","001","","",""})
AADD(AREGS,{CPERG,"07","Da Data de Entrega ?","¿De fecha de Entrega ?","From delivery date ?","mv_ch7","D",8,0,0,"G","","mv_dt_de","","","","20090101","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"08","Ate a Data Entrega ?","¿A fecha Entrega ?","To delivery date ?","mv_ch8","D",8,0,0,"G","","mv_dt_ate","","","","20111231","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"09","Situacao do Pedido ?","¿Situacion de Pedido ?","Order status ?","mv_ch9","N",1,0,2,"C","","mv_ch9","Em aberto","Pendiente","Pending","","","Todos","Todos","All","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"10","Com Geracao Duplic. ?","¿Con Generac.Fac. Cred. ?","With Generation of T. Notes ?","mv_cha","N",1,0,3,"C","","mv_cha","Sim","Si","Yes","","","Nao","No","No","","","Ambos","Ambos","Both","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"11","Máscara do Produto ?","¿Mascara del Producto ?","Product mask ?","mv_chb","C",15,0,0,"G","","mv_parB","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"12","Aglutina prod.Grade ?","¿Agrega prod.Grilla ?","Group grid prod. ?","mv_chc","N",1,0,1,"C","","mv_par12","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","N","","","",""})
AADD(AREGS,{CPERG,"13","Cons.Res.Eliminados ?","¿Cons.Res.Eliminados ?","Consid. Eliminated Residues ?","mv_chd","N",1,0,2,"C","","mv_par13","Sim","Si","Yes","","","Nao","No","No","","","Somente","Solamente","Only","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"14","Lista Tot.Faturados ?","¿Lista Tot.Facturados ?","List total billed ?","mv_che","N",1,0,2,"C","","mv_par14","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"15","Pula pag. na Quebra ?","¿Separa pag en salto ?","Skip page in break ?","mv_chf","N",1,0,2,"C","","mv_par15","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"16","Do Vendedor ?","¿De Vendedor ?","From Sales Representative ?","mv_chg","C",6,0,0,"G","","mv_par16","","","","001006","","","","","","","","","","","","","","","","","","","","","SA3","S","","","",""})
AADD(AREGS,{CPERG,"17","Ate o Vendedor ?","¿A Vendedor ?","To Sales Representative ?","mv_chh","C",6,0,0,"G","","mv_par17","","","","001006","","","","","","","","","","","","","","","","","","","","","SA3","S","","","",""})
AADD(AREGS,{CPERG,"18","Qual moeda ?","¿Que moneda ?","Which currency ?","MV_CHI","N",1,0,1,"C","","mv_par18","Moeda 1","Moneda 1","Currency 1","","","Moeda 2","Moneda 2","Currency 2","","","Moeda 3","Moneda 3","Currency 3","","","Moeda 4","Moneda 4","Currency 4","","","Moeda 5","Moneda 5","Currency 5","","","S","","","",""})
AADD(AREGS,{CPERG,"19","Imprime ?","¿Imprime ?","Print ?","MV_CHJ","N",1,0,2,"C","","mv_par19","Valor Total","Valor Total","Total Value","","","Saldo","Saldo","Balance","","","","","","","","","","","","","","","","","","S","","","",""})
DBSELECTAREA("SX1")
DBSETORDER(1)
FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT

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
//³ As proximas pertencem ao grupo MR680A que eh so para         |
//³ Localizacoes...                                     	     ³
//³ mv_par18				// Movimenta stock    (Sim/Nao)	     ³
//³ mv_par19		 // Gen. Doc (Factura/Remito/Ent. Fut/Todos) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 					     ³
//| aOrd = Ordems Por Pedido/Produto/Cliente/Dt.Entrega/Vendedor |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aOrd :={STR0007,STR0008,STR0009,STR0010,STR0022}
aOrd :={}
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
±±³Fun‡…o	 ³ C680IMP	³ Autor ³ Alexandre Incaio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATR680													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C680Imp(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis   										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
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
LOCAL nTVGeral  := 0
LOCAL nTEGeral  := 0
LOCAL nTSGeral  := 0
LOCAL nTIGeral  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

nTipo   := IIF(aReturn[4]==1,15,18)
nOrdem  := aReturn[8]

Processa({|lEnd| C680Trb(@lEnd,wnRel,"TRB")},Titulo)

//                   999999 99/99/9999 999999xxxxxxxxxxxxxx/XXXXXXXX XX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 99/99/9999 999999999999 999999999999 999999999999
//                             1         2         3         4         5         6         7         8         9        10        11        12        13
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
dbSelectArea("TRB")

cQuebra := "NUM = cNum"
titulo  := titulo +" - "+ STR0007 //"Por Pedido"
//cabec1  := STR0011 //"NUMERO  DATA DE   CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                    DATA DE        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
cabec1  := "       IT CODIGO DO       DESCRICAO DO                    DATA DE        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL   QUANTIDADE    LIBERAC   LIBERAC   LIBERAC   EMISSAO   TIPO"
//cabec2  := STR0012 //"PEDIDO  EMISSAO                                                         PRODUTO         MATERIAL                        ENTREGA        PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
cabec2  := "          PRODUTO         MATERIAL                        ENTREGA        PEDIDA       ENTREGUE     PENDENTE        DO ITEM.      PARCIAL       PEDIDO    CREDITO   ESTOQUE   NF        FRETE"

titulo += " - " + GetMv("MV_MOEDA"+STR(nMoeda,1))		//" MOEDA "
dbSelectArea("TRB")
dbGoTop()
SetRegua(RecCount())                    	// TOTAL DE ELEMENTOS DA REGUA

nFirst := 0

While !Eof() .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay STR0021        //    "CANCELADO PELO OPERADOR"
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
	
	IF nFirst = 0
		
		li++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o cabecalho da linha		    					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@li,  0 Psay "PEDIDO  EMISSAO   CODIGO LOJA /NOME DO CLIENTE"
		li++
		@li,  0 Psay NUM
		@li,  7 Psay TRB->EMISSAO
		@li, 18 Psay Left(CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI, 80)
		li++

		IF nFirst = 0 .And. nOrdem != 4
			nFirst := 1
		Endif
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrutina os produtos da grade conforme o parametro MV_PAR12  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF TRB->GRADE == "S" .And. MV_PAR12 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		cAgrutina := cQuebra
		
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
	@li,  7 Psay ITEM
	@li, 10 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
	@li, 26 Psay Left(TRB->DESCRICAO, 30)
	@li, 57 Psay DATENTR

	@li, 74 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotVen,QUANTIDADE)	PICTURE PesqPictQt("C6_QTDVEN",12)
	@li, 87 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotEnt,ENTREGUE)	PICTURE PesqPictQt("C6_QTDENT",12)
	@li,100 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",12)
	@li,114 Psay nValor	PICTURE PesqPict("SC6","C6_VALOR",12)

	DBSELECTAREA("SC9")
	DBSETORDER(1)
	DBSEEK(TRB->FILIAL+CNUM+TRB->ITEM)
	WHILE !EOF() .AND. C9_FILIAL+C9_PEDIDO+C9_ITEM == TRB->FILIAL+CNUM+TRB->ITEM
		@li, 129 Psay C9_QTDLIB PICTURE PesqPictQt("C6_QTDVEN",12)
		@li, 143 Psay IIF(EMPTY(C9_ULIBPV),SPACE(10),C9_ULIBPV)
		@li, 153 Psay IIF(EMPTY(C9_UDTCRED),SPACE(10),C9_UDTCRED)
		@li, 163 Psay IIF(EMPTY(C9_UDTEST),SPACE(10),C9_UDTEST)
		DBSELECTAREA("SD2")
		DBSETORDER(3)
		IF !EMPTY(SC9->C9_NFISCAL)
			IF DBSEEK(SC9->C9_FILIAL+SC9->C9_NFISCAL+SC9->C9_SERIENF+SC9->C9_CLIENTE+SC9->C9_LOJA+SC9->C9_PRODUTO+SC9->C9_ITEM)
				@li, 173 Psay IIF(EMPTY(D2_EMISSAO),SPACE(10),D2_EMISSAO)
		    ENDIF
		ENDIF
		DBSELECTAREA("SC5")
		DBSETORDER(1)
		IF DBSEEK(SC9->C9_FILIAL+SC9->C9_PEDIDO)
			IF C5_TPFRETE == "C"
				@li,183 Psay "CIF"
			ELSEIF C5_TPFRETE == "F"
				@li,183 Psay "FOB"
			ELSE
				@li,183 Psay "NAO INFORMADO"
			ENDIF
		ENDIF
		DBSELECTAREA("SC9")
		DBSKIP()
		IF !EOF() .AND. C9_FILIAL+C9_PEDIDO+C9_ITEM == TRB->FILIAL+CNUM+TRB->ITEM
			li++
		ENDIF
	ENDDO
	
	nCont++
	li++
	
	dbSelectArea("TRB")
	IncRegua()
	dbSkip()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total do Pedido                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cTotPed
		@Li,000 Psay STR0025
		@Li,114 Psay nTotItem PICTURE PesqPict("SC6","C6_VALOR",12)
		li++
		nTotitem:= 0
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total ou linha divisora conforme a quebra		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cQuebra
		
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
	@Li,000 Psay STR0026
	@Li, 74 Psay nTVGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li, 87 Psay nTEGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li,100 Psay nTSGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li,114 Psay nTIGeral PICTURE PesqPict("SC6","C6_VALOR",12)
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

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ C680TRB	³ Autor ³ Alexandre Inacio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria Arquivo de Trabalho                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATR660													  ³±±
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
LOCAL nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
LOCAL nValor	:= 0
LOCAL cQueryAdd := ""

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
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

nOrdem  := aReturn[8]

dbSelectArea("TRB")
IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,STR0015)       //"Selecionando Registros..."

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)

cAliasSC6 := "MR680Trab"
aStruSC6  := SC6->(dbStruct())
cQuery    := "SELECT * "
cQuery += "FROM "+RetSqlName("SC6")+" "
cQuery += "WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND "
cQuery += "C6_NUM >= '"+cPedIni+"' AND "
cQuery += "C6_NUM <= '"+cPedFim+"' AND "
cQuery += "C6_PRODUTO >= '"+cProIni+"' AND "
cQuery += "C6_PRODUTO <= '"+cProFim+"' AND "
cQuery += "C6_CLI >= '"+cCliIni+"' AND "
cQuery += "C6_CLI <= '"+cCliFim+"' AND "
cQuery += "C6_ENTREG >= '"+Dtos(cDatIni)+"' AND "
cQuery += "C6_ENTREG <= '"+Dtos(cDatFim)+"' AND  "

If mv_par13 == 3
	cQuery += "C6_BLQ = 'R ' AND "
Endif

cQuery += "D_E_L_E_T_ = ' ' "

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


ProcRegua(RecCount())                                         // Total de Elementos da Regua

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
			
			lVend := .F.
			cVend := "1"
			
			For nX := 1 to nQtdVend
				cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
				If (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
					lVend :=.T.
					Exit
				Endif
				cVend := Soma1(cVend,1)
			Next nX
			
			If lVend
				
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
	
	dbSelectArea(cAliasSC6)
	IncProc()
	dbSkip()
	
End

dbSelectArea(cAliasSC6)
dbClosearea()
dbSelectArea("SC6")

RETURN()