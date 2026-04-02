#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPROGRAMA  ณ NOVCOM01 บ AUTOR Rui Ronaldo Scandiuzzi DATA ณ  03/06/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDESCRICAO ณ DIVERGENCIAS DE PEDIDO DE COMPRAS                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUSO       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER FUNCTION NOVCOM01()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ DECLARACAO DE VARIAVEIS                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

LOCAL CDESC1        := "ESTE PROGRAMA TEM COMO OBJETIVO IMPRIMIR RELATORIO "
LOCAL CDESC2        := "DE ACORDO COM OS PARAMETROS INFORMADOS PELO USUARIO."
LOCAL CDESC3        := "CONFERENCIA DO PEDIDO DE COMPRAS COM A NOTA DE ENTRADA"
LOCAL CPICT         := ""
LOCAL TITULO        := "PEDIDO DE COMPRAS X NOTA DE ENTRADA"
LOCAL NLIN          := 80
LOCAL CABEC1        := "PEDIDO FORNEC LOJA     NOME                                        QUANT       UNITARIO          QUANT       UNITARIO NUMERO    SER DATA     DATA          QTD VLR PRO"
LOCAL CABEC2        := "       PRODUTO         DESCRICAO                                  PEDIDO         PEDIDO           NOTA           NOTA DOCUMENTO DOC PREVISTA RECEBIM. DIAS  OK  OK  OK"
//                             999999999999999 999999999999999999999999999999     999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999999999 999 99/99/99 99/99/99 9999   X   X   X
LOCAL IMPRIME       := .T.
LOCAL AORD          := {}
LOCAL AREGS         := {}

PRIVATE LEND        := .F.
PRIVATE LABORTPRINT := .F.
PRIVATE CBTXT       := ""
PRIVATE LIMITE      := 220
PRIVATE TAMANHO     := "G"
PRIVATE NOMEPROG    := "NOVCOM01"
PRIVATE NTIPO       := 18
PRIVATE ARETURN     := { "ZEBRADO", 1, "ADMINISTRACAO", 2, 2, 1, "", 1}
PRIVATE NLASTKEY    := 0
PRIVATE CPERG       := "NOVCOM01  "
PRIVATE CBTXT       := SPACE(10)
PRIVATE CBCONT      := 00
PRIVATE CONTFL      := 01
PRIVATE M_PAG       := 01
PRIVATE WNREL       := "NOVCOM01"
PRIVATE CSTRING     := "SC7"

AADD(AREGS,{CPERG,"01","Do Fornecedor      ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","S","","","",""})
AADD(AREGS,{CPERG,"02","Ate o Fornecedor   ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2","S","","","",""})
AADD(AREGS,{CPERG,"03","Do Produto         ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1","S","030","","",""})
AADD(AREGS,{CPERG,"04","Ate o Produto      ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","S","030","","",""})
AADD(AREGS,{CPERG,"05","Da Data de Emissao ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"06","Ate a Data Emissao ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"07","Quantidade Ok      ?","","","mv_ch7","C",01,0,0,"C","","mv_par07","Sim","","","","","Nao","","","","","Ambos","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"08","Valor Ok           ?","","","mv_ch8","C",01,0,0,"C","","mv_par08","Sim","","","","","Nao","","","","","Ambos","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"09","Produto Ok         ?","","","mv_ch9","C",01,0,0,"C","","mv_par09","Sim","","","","","Nao","","","","","Ambos","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"10","Certificado        ?","","","mv_cha","C",01,0,0,"C","","mv_par10","Sim","","","","","Nao","","","","","Ambos","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"11","Pedidos            ?","","","mv_cha","C",01,0,0,"C","","mv_par11","Abertos","","","","","Fechados","","","","","Ambos","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"12","Do Pedido          ?","","","mv_chb","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
AADD(AREGS,{CPERG,"13","Ate o Pedido       ?","","","mv_chc","C",06,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
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

PERGUNTE(CPERG,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA A INTERFACE PADRAO COM O USUARIO...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

WNREL := SETPRINT(CSTRING,NOMEPROG,CPERG,@TITULO,CDESC1,CDESC2,CDESC3,.F.,AORD,.F.,TAMANHO,,.F.)

IF NLASTKEY == 27
	RETURN
ENDIF

SETDEFAULT(ARETURN,CSTRING)

IF NLASTKEY == 27
	RETURN
ENDIF

NTIPO := IF(ARETURN[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ PROCESSAMENTO. RPTSTATUS MONTA JANELA COM A REGUA DE PROCESSAMENTO. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RPTSTATUS({|| RUNREPORT(CABEC1,CABEC2,TITULO,NLIN) },TITULO)
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFUNO    ณRUNREPORT บ AUTOR ณ AP6 IDE            บ DATA ณ  03/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDESCRIO ณ FUNCAO AUXILIAR CHAMADA PELA RPTSTATUS. A FUNCAO RPTSTATUS บฑฑ
ฑฑบ          ณ MONTA A JANELA COM A REGUA DE PROCESSAMENTO.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUSO       ณ PROGRAMA PRINCIPAL                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION RUNREPORT(CABEC1,CABEC2,TITULO,NLIN)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> INDICA QUANTOS REGISTROS SERAO PROCESSADOS PARA A REGUA ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DBSELECTAREA("SC7")
DBSETORDER(1)
DBSELECTAREA("SD1")
DBSETORDER(11)            

PERPOS = 0.00
PERNEG = 0.00                    
TOTITENS = 0

CQUERY := " SELECT DISTINCT C7_FILIAL,C7_NUM "
CQUERY += " FROM "
CQUERY += RETSQLNAME("SC7")+" SC7 "
CQUERY += " WHERE "
CQUERY += "     C7_FILIAL = '"+XFILIAL("SC7")+"' "
CQUERY += " AND C7_FORNECE >= '"+MV_PAR01+"' AND C7_FORNECE <= '"+MV_PAR02+"' "
CQUERY += " AND C7_PRODUTO >= '"+MV_PAR03+"' AND C7_PRODUTO <= '"+MV_PAR04+"' "
CQUERY += " AND C7_EMISSAO >= '"+DTOS(MV_PAR05)+"' AND C7_EMISSAO <= '"+DTOS(MV_PAR06)+"' "
IF MV_PAR07 == 1
	CQUERY += " AND C7_UQTDOK = 'S' "
ELSEIF MV_PAR07 == 2
	CQUERY += " AND C7_UQTDOK = 'N' "
ENDIF
IF MV_PAR08 == 1
	CQUERY += " AND C7_UVLROK = 'S' "
ELSEIF MV_PAR08 == 2
	CQUERY += " AND C7_UVLROK = 'N' "
ENDIF
IF MV_PAR09 == 1
	CQUERY += " AND C7_UPROOK = 'S' "
ELSEIF MV_PAR09 == 2
	CQUERY += " AND C7_UPROOK = 'N' "
ENDIF
CQUERY += " AND C7_NUM >= '"+MV_PAR12+"' AND C7_NUM <= '"+MV_PAR13+"' "
CQUERY += " AND SC7.D_E_L_E_T_ = ' ' "
IF MV_PAR11 == 1
	CQUERY := " AND NOT EXISTS (SELECT '*' FROM "+RETSQLNAME("SD1")+" WHERE D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND D1_COD = C7_PRODUTO AND D1_ITEM = C7_ITEM AND D_E_L_E_T_ = ' ' ) "
ELSEIF MV_PAR11 == 2
	CQUERY += " AND EXISTS (SELECT '*' FROM "+RETSQLNAME("SD1")
	CQUERY += " WHERE "
	CQUERY += " D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND D1_COD = C7_PRODUTO AND D1_ITEM = C7_ITEM AND D_E_L_E_T_ = ' ' "+IIF(MV_PAR10==1," AND D1_ULAUDO = 'S' ",IIF(MV_PAR10==2," AND D1_ULAUDO <> 'S' ",""))+" ) "
ENDIF
CQUERY += " ORDER BY C7_NUM "
TCQUERY CQUERY NEW ALIAS "WORK"
SETREGUA(RECCOUNT())
DBGOTOP()
WHILE !EOF()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ VERIFICA O CANCELAMENTO PELO USUARIO...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	IF LABORTPRINT
		@NLIN,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		EXIT
	ENDIF
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ IMPRESSAO DO CABECALHO DO RELATORIO. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	IF NLIN > 55
		CABEC(TITULO,CABEC1,CABEC2,NOMEPROG,TAMANHO,NTIPO)
		NLIN := 9
	ENDIF
	CCHAVE := WORK->C7_FILIAL+WORK->C7_NUM
	DBSELECTAREA("SC7")
	DBSEEK(CCHAVE)
	@ NLIN,000 PSAY SC7->C7_NUM
	@ NLIN,007 PSAY SC7->C7_FORNECE
	@ NLIN,014 PSAY SC7->C7_LOJA
	@ NLIN,023 PSAY LEFT(POSICIONE("SA2",1,XFILIAL("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME"),40)
	NLIN++
	WHILE !EOF() .AND. C7_FILIAL+C7_NUM == CCHAVE

		IF MV_PAR07 == 1
			IF C7_UQTDOK <> "S"
				DBSKIP()
				LOOP
			ENDIF
		ELSEIF MV_PAR07 == 2
			IF C7_UQTDOK <> "N"
				DBSKIP()
				LOOP
			ENDIF
		ENDIF
		IF MV_PAR07 == 1
			IF C7_UVLROK <> "S"
				DBSKIP()
				LOOP
			ENDIF
		ELSEIF MV_PAR07 == 2
			IF C7_UVLROK <> "N"
				DBSKIP()
				LOOP
			ENDIF
		ENDIF
		IF MV_PAR07 == 1
			IF C7_UPROOK <> "S"
				DBSKIP()
				LOOP
			ENDIF
		ELSEIF MV_PAR07 == 2
			IF C7_UPROOK <> "N"
				DBSKIP()
				LOOP
			ENDIF
		ENDIF
		IF MV_PAR10 == 1 .OR. MV_PAR10 == 2
			DBSELECTAREA("SD1")
			IF DBSEEK(SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM+SC7->C7_ITEM)
				IF MV_PAR10 == 1
					IF D1_ULAUDO <> "S"
						DBSKIP()
						LOOP
					ENDIF
				ELSEIF MV_PAR10 == 2
					IF C7_UPROOK <> "N"
						DBSKIP()
						LOOP
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ VERIFICA O CANCELAMENTO PELO USUARIO...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		IF LABORTPRINT
			@NLIN,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			EXIT
		ENDIF
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ IMPRESSAO DO CABECALHO DO RELATORIO. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		IF NLIN > 55
			CABEC(TITULO,CABEC1,CABEC2,NOMEPROG,TAMANHO,NTIPO)
			NLIN := 9
		ENDIF

		@ NLIN,007 PSAY SC7->C7_PRODUTO
		@ NLIN,023 PSAY LEFT(POSICIONE("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_DESC"),30)
		@ NLIN,058 PSAY SC7->C7_QUANT PICTURE "@E 999,999,999.99"
		@ NLIN,073 PSAY SC7->C7_PRECO PICTURE "@E 999,999,999.99"
		DDATEMIS := CTOD("")      
		DDATAEMIS:= CTOD("")
		DBSELECTAREA("SD1")
		IF DBSEEK(SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM+SC7->C7_ITEM)
			@ NLIN,088 PSAY SD1->D1_QUANT PICTURE "@E 999,999,999.99"
			@ NLIN,103 PSAY SD1->D1_VUNIT PICTURE "@E 999,999,999.99"
			@ NLIN,118 PSAY SD1->D1_DOC
			@ NLIN,128 PSAY SD1->D1_SERIE
			IF SC7->C7_TPFRETE == "C"
				DDATAEMIS := SD1->D1_DTDIGIT
			ELSE
				DDATAEMIS := SD1->D1_EMISSAO
			ENDIF
		ENDIF
		@ NLIN,132 PSAY SC7->C7_DATPRF
		@ NLIN,141 PSAY DDATAEMIS
		IF EMPTY(DDATAEMIS)
			@ NLIN,150 PSAY 0 PICTURE "9999"
		ELSE
			@ NLIN,150 PSAY DDATAEMIS-SC7->C7_DATPRF PICTURE "9999"
		ENDIF
		@ NLIN,157 PSAY SC7->C7_UQTDOK
		@ NLIN,161 PSAY SC7->C7_UVLROK
		@ NLIN,165 PSAY SC7->C7_UPROOK 
		NLIN++                
		
		MQTD = " "
		MVLR = " "
		MPROD = " " 
		MQTD = SC7->C7_UQTDOK           
		MVLR = SC7->C7_UVLROK                 
		MPRO = SC7->C7_UPROOK 
		
	 IF MQTD = "S" .AND. MVLR = "S" .AND. MPRO = "S"     
	   PERPOS = PERPOS + 1
	 ENDIF
	 
	 TOTITENS = TOTITENS + 1
			
		
		DBSELECTAREA("SC7")
		DBSKIP()
	ENDDO
	NLIN++
	DBSELECTAREA("WORK")
	DBSKIP()
ENDDO          
NLIN++   
@ NLIN,157 PSAY "% OK =>"
MPERPOS = (PERPOS / TOTITENS)*100
@ NLIN,168 PSAY MPERPOS 
NLIN++                 
       
PERPOS = 0.00                
TOTITENS = 0.00

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FINALIZA A EXECUCAO DO RELATORIO...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SE IMPRESSAO EM DISCO, CHAMA O GERENCIADOR DE IMPRESSAO...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

IF ARETURN[5]==1
	DBCOMMITALL()
	SET PRINTER TO
	OURSPOOL(WNREL)
ENDIF

MS_FLUSH()

DBSELECTAREA("WORK")
DBCLOSEAREA()

RETURN()