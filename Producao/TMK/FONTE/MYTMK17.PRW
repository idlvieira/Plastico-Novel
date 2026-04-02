#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³MYTMK17    º AUTOR ³ CASSIUS CARLOS MARTINS DATA ³  22/11/13 ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESCRICAO ³ RELATORIO DE PEDIDOS EM CARTEIRA NAO ENTREGUES - MOD 02    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ COMERCIAL                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION MYTMK17() 
*****************************************
LOCAL CDESC1         	:= "ESTE PROGRAMA TEM COMO OBJETIVO IMPRIMIR RELATORIO "
LOCAL CDESC2         	:= "DE ACORDO COM OS PARAMETROS INFORMADOS PELO USUARIO."
LOCAL CDESC3         	:= "PEDIDOS EM CARTEIRA NAO ENTREGUE - MOD.02 - COMERCIAL"
LOCAL CPICT          	:= ""
LOCAL TITULO       		:= "PEDIDOS EM CARTEIRA NAO ENTREGUE - MOD.02 - COMERCIAL"
LOCAL NLIN         		:= 80
LOCAL CABEC1       		:= " CLIENTE"
LOCAL CABEC2       		:= " PEDIDO  EMISSAO     PRODUTO         DESCRICAO                                     SITUACAO    FRETE    QT.ORIGINAL     QT.FATURADO    QT.PRODUZIDO    QT.A PRODUZIR      SALDO PEDIDO       QT.ESTOQUE  PREV.PCP "
LOCAL IMPRIME      		:= .T.
LOCAL AORD 				:= {}  
PRIVATE LEND         	:= .F.
PRIVATE LABORTPRINT  	:= .F.
PRIVATE CBTXT        	:= ""
PRIVATE LIMITE        	:= 80
PRIVATE TAMANHO      	:= "G"
PRIVATE NOMEPROG      	:= "NOVREL01" 
PRIVATE NTIPO         	:= 15
PRIVATE ARETURN      	:= { "ZEBRADO", 1, "ADMINISTRACAO", 1, 2, 1, "", 1}
PRIVATE NLASTKEY     	:= 0
PRIVATE CPERG       	:= "REL01A"
PRIVATE CBTXT      		:= SPACE(10)
PRIVATE CBCONT     		:= 00
PRIVATE CONTFL     		:= 01
PRIVATE M_PAG      		:= 01
PRIVATE WNREL      		:= "NOVREL01" 

PRIVATE CSTRING 		:= "SC5"  



VALIDPERG()
IF !PERGUNTE(CPERG)  
	RETURN
ENDIF

IF MV_PAR14==2
	RUNEXCEL()
	RETURN
ENDIF

WNREL := SETPRINT(CSTRING,NOMEPROG,CPERG,@TITULO,CDESC1,CDESC2,CDESC3,.F.,AORD,.T.,TAMANHO,,.F.)

IF NLASTKEY == 27
	RETURN
ENDIF

SETDEFAULT(ARETURN,CSTRING)

IF NLASTKEY == 27
   RETURN
ENDIF

NTIPO := IF(ARETURN[4]==1,15,18)

RPTSTATUS({|| RUNREPORT(CABEC1,CABEC2,TITULO,NLIN) },TITULO)
RETURN


STATIC FUNCTION RUNREPORT(CABEC1,CABEC2,TITULO,NLIN)
*****************************************************
LOCAL NORDEM
LOCAL CQUERY := ""                         
LOCAL CCLIENTES := ""

DBSELECTAREA("SA3")
DBSETORDER(7)
IF DBSEEK(XFILIAL("SA3")+__CUSERID) //NAO PERMITE VER PED DE OUTROS VENDEDORES
	MV_PAR09 := SA3->A3_COD
	MV_PAR10 := SA3->A3_COD
ENDIF

_LOK := REL01C() //BUSCA DADOS
IF !_LOK
	MSGALERT("NENHUMA INFORMACAO PARA SER APRESENTADA")
	RETURN
ENDIF
                       
CCLIENTES := REL01B()

_CCLIAUX    := " "  
_NQTORI  	:= 0
_NQTFAT	 	:= 0
_NQTPROD 	:= 0
_NQTPRDZ 	:= 0
_NQTSLD  	:= 0

_NQTORIAC  	:= 0
_NQTFATAC	:= 0
_NQTPRODAC 	:= 0
_NQTPRDZAC 	:= 0
_NQTSLDAC  	:= 0    
_CSITUACAO := " "      //teste

DBSELECTAREA("TRB1")
DBGOTOP()
WHILE !EOF()

	IF LABORTPRINT
		@NLIN,00 PSAY "*** CANCELADO PELO OPERADOR ***"
  		EXIT
   	ENDIF

   	IF NLIN > 55 
   		CABEC(TITULO,CABEC1,CABEC2,NOMEPROG,TAMANHO,NTIPO)
    	NLIN := 9
   	ENDIF      
   
   	IF TRB1->A1_COD+TRB1->A1_LOJA!=_CCLIAUX
   		IF !EMPTY(_CCLIAUX)
   			_CCLIAUX := TRB1->A1_COD+TRB1->A1_LOJA 
   			
   			IF TRB1->A1_COD+TRB1->A1_LOJA$CCLIENTES
	   			@NLIN, 001 PSAY "TOTAL DO CLIENTE --> " 
	   			@NLIN, 101 PSAY _NQTORI  PICTURE "@E 999,999,999.99" 
	   			@NLIN, 117 PSAY _NQTFAT  PICTURE "@E 999,999,999.99"
	   			@NLIN, 133 PSAY _NQTPROD PICTURE "@E 999,999,999.99"
	   			@NLIN, 150 PSAY _NQTPRDZ PICTURE "@E 999,999,999.99"
	   			@NLIN, 168 PSAY _NQTSLD  PICTURE "@E 999,999,999.99"  
	   			
				_NQTORI  := 0
				_NQTFAT	 := 0
				_NQTPROD := 0
				_NQTPRDZ := 0
				_NQTSLD  := 0
				NLIN += 2
				
				@NLIN, 001 PSAY "CLIENTE : " 
				@NLIN, 012 PSAY TRB1->A1_COD+"-"+TRB1->A1_LOJA+" "+TRB1->A1_NOME
				NLIN++
			ENDIF 
			
		ELSE                                                   
			_CCLIAUX := TRB1->A1_COD+TRB1->A1_LOJA                          
			                                       
			IF TRB1->A1_COD+TRB1->A1_LOJA$CCLIENTES
				@NLIN, 001 PSAY "CLIENTE : " 
				@NLIN, 012 PSAY TRB1->A1_COD+"-"+TRB1->A1_LOJA+" "+TRB1->A1_NOME
				NLIN++
			ENDIF
		ENDIF
	ELSE                          
	   	_CSITUACAO := " "     
        DO CASE                          
        	CASE TRB1->C5_UANA3$"PS"
				CQUERY := "SELECT COUNT(1) QT "
				CQUERY += "  FROM "+RETSQLNAME("SC9")+" SC9 "
				CQUERY += " WHERE SC9.C9_FILIAL = '"+TRB1->C5_FILIAL+"' "
				CQUERY += "   AND SC9.C9_PEDIDO = '"+TRB1->C5_NUM+"' "  
				CQUERY += "   AND SC9.C9_PRODUTO = '"+TRB1->B1_COD+"' "     //TESTE
				CQUERY += "   AND SC9.C9_NFISCAL = '         ' "
				CQUERY += "   AND SC9.D_E_L_E_T_ = ' ' "			
				CQUERY := CHANGEQUERY(CQUERY)
				IF SELECT("TRB2")!=0
					TRB2->(DBCLOSEAREA())
				ENDIF
				TCQUERY CQUERY NEW ALIAS "TRB2"			
				IF TRB2->QT>0
					_CSITUACAO := "FATURAMENTO" 
				ELSE                                    //Teste
					_CSITUACAO := "PRODUCAO"     //Teste
				ENDIF
				TRB2->(DBCLOSEAREA())
        	CASE TRB1->C5_UANA1$"NBR"
        		_CSITUACAO := "COMERCIAL"
        	CASE TRB1->C5_UANA2$"NCPGR" //.AND. TRB1->C5_UANA3$"PC"  
        	   IF TRB1->C5_UANA2$"C" .AND. TRB1->C6_UANA2$"E" 
        	     _CSITUACAO := "EXPEDICAO" 
        	   ELSE
        	   	 _CSITUACAO := "PRODUCAO" 
        	   ENDIF	
        	CASE TRB1->C5_UANA3$"NC" .AND. TRB1->C5_UANA2$"S"
        		_CSITUACAO := "EXPEDICAO"  
        	CASE TRB1->C5_UANA1==" " .AND. TRB1->C5_UANA2==" " .AND. TRB1->C5_UANA3==" "  //teste
        		_CSITUACAO := "INDEFINIDO"
		ENDCASE
        	
		_LIMPRIME := .F.
		IF "C"$MV_PAR11 .AND. _CSITUACAO=="COMERCIAL"
			_LIMPRIME := .T.
		ELSEIF "P"$MV_PAR11 .AND. _CSITUACAO=="PRODUCAO"
			_LIMPRIME := .T.
		ELSEIF "E"$MV_PAR11 .AND. _CSITUACAO=="EXPEDICAO"
			_LIMPRIME := .T. 
		ELSEIF "F"$MV_PAR11 .AND. _CSITUACAO=="FATURAMENTO"
			_LIMPRIME := .T. 
		ELSEIF "I"$MV_PAR11 .AND. _CSITUACAO=="INDEFINIDO"
			_LIMPRIME := .T.
		ENDIF
		
		IF _LIMPRIME
			@NLIN, 001 PSAY TRB1->C5_NUM
			@NLIN, 009 PSAY DTOC(STOD(TRB1->C5_EMISSAO))
			@NLIN, 021 PSAY TRB1->B1_COD
			@NLIN, 037 PSAY TRB1->B1_DESC
			@NLIN, 083 PSAY _CSITUACAO
	   		@NLIN, 095 PSAY IIF(TRB1->C5_TPFRETE=="C","CIF","FOB")
			@NLIN, 101 PSAY TRB1->C6_QTDVEN  PICTURE "@E 999,999,999.99" 
			@NLIN, 117 PSAY TRB1->C6_QTDENT  PICTURE "@E 999,999,999.99"
			@NLIN, 133 PSAY TRB1->C6_UQTPROD PICTURE "@E 999,999,999.99"
			@NLIN, 150 PSAY TRB1->C6_QTDVEN-TRB1->C6_UQTPROD PICTURE "@E 999,999,999.99"
			@NLIN, 168 PSAY TRB1->C6_QTDVEN-TRB1->C6_QTDENT  PICTURE "@E 999,999,999.99"  
			@NLIN, 185 PSAY TRB1->B2_QATU    PICTURE "@E 999,999,999.99"  
			@NLIN, 201 PSAY DTOC(STOD(TRB1->C6_UDTPROD))	
	    			
			_NQTORI    += TRB1->C6_QTDVEN
			_NQTFAT	   += TRB1->C6_QTDENT
			_NQTPROD   += TRB1->C6_UQTPROD 
			_NQTPRDZ   += TRB1->C6_QTDVEN-TRB1->C6_UQTPROD
			_NQTSLD    += TRB1->C6_QTDVEN-TRB1->C6_QTDENT 	
	
			_NQTORIAC  += TRB1->C6_QTDVEN
			_NQTFATAC  += TRB1->C6_QTDENT
			_NQTPRODAC += TRB1->C6_UQTPROD 
			_NQTPRDZAC += TRB1->C6_QTDVEN-TRB1->C6_UQTPROD
			_NQTSLDAC  += TRB1->C6_QTDVEN-TRB1->C6_QTDENT 
	
			NLIN++	 
		ENDIF
		
		DBSELECTAREA("TRB1")
		DBSKIP()
    ENDIF
ENDDO 

@NLIN, 001 PSAY "TOTAL DO CLIENTE --> " 
@NLIN, 101 PSAY _NQTORI  PICTURE "@E 999,999,999.99" 
@NLIN, 117 PSAY _NQTFAT  PICTURE "@E 999,999,999.99"
@NLIN, 133 PSAY _NQTPROD PICTURE "@E 999,999,999.99"
@NLIN, 150 PSAY _NQTPRDZ PICTURE "@E 999,999,999.99"
@NLIN, 168 PSAY _NQTSLD  PICTURE "@E 999,999,999.99" 
NLIN++                                                             

NLIN++
@NLIN, 001 PSAY "TOTAL GERAL --> " 
@NLIN, 101 PSAY _NQTORIAC  PICTURE "@E 999,999,999.99" 
@NLIN, 117 PSAY _NQTFATAC  PICTURE "@E 999,999,999.99"
@NLIN, 133 PSAY _NQTPRODAC PICTURE "@E 999,999,999.99"
@NLIN, 150 PSAY _NQTPRDZAC PICTURE "@E 999,999,999.99"
@NLIN, 168 PSAY _NQTSLDAC  PICTURE "@E 999,999,999.99"  

SET DEVICE TO SCREEN

IF ARETURN[5]==1
   DBCOMMITALL()
   SET PRINTER TO
   OURSPOOL(WNREL)
ENDIF

MS_FLUSH()            

TRB1->(DBCLOSEAREA())

RETURN  




STATIC FUNCTION RUNEXCEL() //GERAR EXCEL
*****************************************************
LOCAL CQUERY := ""                         
LOCAL CCLIENTES := ""

DBSELECTAREA("SA3")
DBSETORDER(7)
IF DBSEEK(XFILIAL("SA3")+__CUSERID) //NAO PERMITE VER PED DE OUTROS VENDEDORES
	MV_PAR09 := SA3->A3_COD
	MV_PAR10 := SA3->A3_COD
ENDIF                

_LOK := REL01C() //BUSCA DADOS
IF !_LOK
	MSGALERT("NENHUMA INFORMACAO PARA SER APRESENTADA")
	RETURN
ENDIF

CCLIENTES := REL01B()

_CSITUACAO  := " "      //teste  

OEXCEL 		:= FWMSEXCEL():NEW()

OEXCEL:ADDWORKSHEET("REL01")
OEXCEL:ADDTABLE ("REL01","TBREL01")
OEXCEL:ADDCOLUMN("REL01","TBREL01","CLIENTE",1,1,.F.)                                                                                                                                                                                                         
OEXCEL:ADDCOLUMN("REL01","TBREL01","LOJA",1,1,.F.) 
OEXCEL:ADDCOLUMN("REL01","TBREL01","NOME",1,1,.F.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","PEDIDO",1,1,.F.)                                                                                                                                                                                                         
OEXCEL:ADDCOLUMN("REL01","TBREL01","EMISSAO",1,4,.F.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","PRODUTO",1,1,.F.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","DESCRICAO",1,1,.F.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","SITUACAO",1,1,.F.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","FRETE",1,1,.F.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","QT.ORIGINAL",3,2,.T.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","QT.FATURADO",3,2,.T.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","QT.PRODUZIDO",3,2,.T.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","QT.A PRODUZIR",3,2,.T.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","SALDO PEDIDO",3,2,.T.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","QT.ESTOQUE",3,2,.F.)
OEXCEL:ADDCOLUMN("REL01","TBREL01","PREV.PCP",1,4,.F.)   
OEXCEL:ADDCOLUMN("REL01","TBREL01","COD.VEND",1,1,.F.)  // vendedor    
OEXCEL:ADDCOLUMN("REL01","TBREL01","NOME.VEND",1,1,.F.)

DBSELECTAREA("TRB1")
DBGOTOP()
WHILE !EOF()   
   	_CSITUACAO := " "     
   	DO CASE                          
       	CASE TRB1->C5_UANA3$"PS"
			CQUERY := "SELECT COUNT(1) QT "
			CQUERY += "  FROM "+RETSQLNAME("SC9")+" SC9 "
			CQUERY += " WHERE SC9.C9_FILIAL = '"+TRB1->C5_FILIAL+"' "
			CQUERY += "   AND SC9.C9_PEDIDO = '"+TRB1->C5_NUM+"' "  
			CQUERY += "   AND SC9.C9_PRODUTO = '"+TRB1->B1_COD+"' "     //TESTE
			CQUERY += "   AND SC9.C9_NFISCAL = '         ' "
			CQUERY += "   AND SC9.D_E_L_E_T_ = ' ' "			
			CQUERY := CHANGEQUERY(CQUERY)
			IF SELECT("TRB2")!=0
				TRB2->(DBCLOSEAREA())
			ENDIF
			TCQUERY CQUERY NEW ALIAS "TRB2"			
			IF TRB2->QT>0
				_CSITUACAO := "FATURAMENTO" 
			ELSE                                    //Teste
				_CSITUACAO := "PRODUCAO"     //Teste
			ENDIF
			TRB2->(DBCLOSEAREA())
   		CASE TRB1->C5_UANA1$"NBR"
        	_CSITUACAO := "COMERCIAL"
        CASE TRB1->C5_UANA2$"NCPGR" //.AND. TRB1->C5_UANA3$"PC"  
           IF TRB1->C5_UANA2$"C" .AND. TRB1->C6_UANA2$"E" 
             _CSITUACAO := "EXPEDICAO" 
           ELSE
           	 _CSITUACAO := "PRODUCAO" 
           ENDIF	
        CASE TRB1->C5_UANA3$"NC" .AND. TRB1->C5_UANA2$"S"
        	_CSITUACAO := "EXPEDICAO"  
        CASE TRB1->C5_UANA1==" " .AND. TRB1->C5_UANA2==" " .AND. TRB1->C5_UANA3==" "  //teste
        	_CSITUACAO := "INDEFINIDO"
	ENDCASE
	        	
	_LIMPRIME := .F.
	IF "C"$MV_PAR11 .AND. _CSITUACAO=="COMERCIAL"
		_LIMPRIME := .T.
	ELSEIF "P"$MV_PAR11 .AND. _CSITUACAO=="PRODUCAO"
		_LIMPRIME := .T.
	ELSEIF "E"$MV_PAR11 .AND. _CSITUACAO=="EXPEDICAO"
		_LIMPRIME := .T. 
	ELSEIF "F"$MV_PAR11 .AND. _CSITUACAO=="FATURAMENTO"
		_LIMPRIME := .T. 
	ELSEIF "I"$MV_PAR11 .AND. _CSITUACAO=="INDEFINIDO"
		_LIMPRIME := .T.
	ENDIF
	                                                  
	IF _LIMPRIME                                      
		_ALINHA := {}
		AADD(_ALINHA, TRB1->A1_COD)
		AADD(_ALINHA, TRB1->A1_LOJA)
		AADD(_ALINHA, TRB1->A1_NOME)
		AADD(_ALINHA, TRB1->C5_NUM)
		AADD(_ALINHA, DTOC(STOD(TRB1->C5_EMISSAO)))
		AADD(_ALINHA, TRB1->B1_COD)
		AADD(_ALINHA, TRB1->B1_DESC)
		AADD(_ALINHA, _CSITUACAO)
		AADD(_ALINHA, IIF(TRB1->C5_TPFRETE=="C","CIF","FOB"))
		AADD(_ALINHA, TRB1->C6_QTDVEN)
		AADD(_ALINHA, TRB1->C6_QTDENT) 
		AADD(_ALINHA, TRB1->C6_UQTPROD)
		AADD(_ALINHA, TRB1->C6_QTDVEN-TRB1->C6_UQTPROD)
		AADD(_ALINHA, TRB1->C6_QTDVEN-TRB1->C6_QTDENT) 
		AADD(_ALINHA, TRB1->B2_QATU)
		AADD(_ALINHA, DTOC(STOD(TRB1->C6_UDTPROD)))	 
		AADD(_ALINHA, TRB1->C5_VEND1)//vendedor     
		AADD(_ALINHA, 	Posicione("SA3",1,xFilial("SA3")+TRB1->C5_VEND1,"A3_NOME") )
	
		
		OEXCEL:ADDROW("REL01","TBREL01",_ALINHA)	
	ENDIF
	
	DBSELECTAREA("TRB1")
	DBSKIP()
ENDDO 
TRB1->(DBCLOSEAREA())

OEXCEL:ACTIVATE()    

_CDIR := CGETFILE("*.*","LOCAL",,,.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_RETDIRECTORY,.F.)

IF EMPTY(_CDIR)
	RETURN
ENDIF

_CARQ := _CDIR+"NOVREL01.XML"
OEXCEL:GETXMLFILE(_CARQ)
                            
IF !APOLECLIENT("MSEXCEL")
	MSGALERT( "MSEXCEL NAO INSTALADO" )
ELSE
	OEXCELAPP := MSEXCEL():NEW()
	OEXCELAPP:WORKBOOKS:OPEN(_CARQ)
	OEXCELAPP:SETVISIBLE(.T.)
ENDIF

RETURN  

                                                                         
USER FUNCTION REL01A() //ESCOLHA SITUACOES
***********************************
LOCAL CTITULO:="SITUACOES"
LOCAL MVPAR
LOCAL MVPARDEF:="CPEFI"
LOCAL L1ELEM 
LOCAL LTIPORET
PRIVATE ASIT:={}

L1ELEM := IF (L1ELEM = NIL , .F. , .T.)
LTIPORET := .T.
CALIAS := ALIAS() 					 

IF LTIPORET
	MVPAR:=&(ALLTRIM(READVAR()))		 // CARREGA NOME DA VARIAVEL DO GET EM QUESTAO
	MVRET:=ALLTRIM(READVAR())			 // IGUALA NOME DA VARIAVEL AO NOME VARIAVEL DE RETORNO
ENDIF

AADD(ASIT,"C - COMERCIAL")
AADD(ASIT,"P - PRODUCAO")
AADD(ASIT,"E - EXPEDICAO")
AADD(ASIT,"F - FATURAMENTO") 
AADD(ASIT,"I - INDEFINIDO") //teste

IF LTIPORET
	IF F_OPCOES(@MVPAR,CTITULO,ASIT,MVPARDEF,12,49,L1ELEM)  // CHAMA FUNCAO F_OPCOES
		&MVRET := MVPAR
	ENDIF	
ENDIF
RETURN(.T.)          


STATIC FUNCTION REL01B()//VERIF SE CLIENTE TEM PV PARA IMPRIMIR NA SIT DO PARAMETRO
*************************************
LOCAL _CRET := ""
DBSELECTAREA("TRB1")
DBGOTOP()
WHILE !EOF()
	DO CASE
	  	CASE TRB1->C5_UANA1$"NBR"
			_CSITUACAO := "COMERCIAL"
	    CASE TRB1->C5_UANA2$"NCPGR" //.AND. !TRB1->C5_UANA3$"N"  
	           IF TRB1->C5_UANA2$"C" .AND. TRB1->C6_UANA2$"E" 
        	     _CSITUACAO := "EXPEDICAO" 
        	   ELSE
        	   	 _CSITUACAO := "PRODUCAO" 
        	   ENDIF	
		CASE TRB1->C5_UANA3$"NC".AND. TRB1->C5_UANA2$"S"
			_CSITUACAO := "EXPEDICAO"
		CASE TRB1->C5_UANA3$"PS"
			CQUERY := "SELECT COUNT(1) QT "
			CQUERY += "  FROM "+RETSQLNAME("SC9")+" SC9 "
			CQUERY += " WHERE SC9.C9_FILIAL = '"+TRB1->C5_FILIAL+"' "
			CQUERY += "   AND SC9.C9_PEDIDO = '"+TRB1->C5_NUM+"' "   
			CQUERY += "   AND SC9.C9_PRODUTO = '"+TRB1->B1_COD+"' "   //TESTE
			CQUERY += "   AND SC9.C9_NFISCAL = '         ' "
			CQUERY += "   AND SC9.D_E_L_E_T_ = ' ' "			
			CQUERY := CHANGEQUERY(CQUERY)
			IF SELECT("TRB2")!=0
				TRB2->(DBCLOSEAREA())
			ENDIF
			TCQUERY CQUERY NEW ALIAS "TRB2"			
			IF TRB2->QT>0
				_CSITUACAO := "FATURAMENTO" 
			ELSE                                     //teste
			  _CSITUACAO := "PRODUCAO"		  //teste		
			ENDIF
			TRB2->(DBCLOSEAREA())   
		 CASE TRB1->C5_UANA1==" " .AND. TRB1->C5_UANA2==" " .AND. TRB1->C5_UANA3==" "   //teste
		    _CSITUACAO := "INDEFINIDO"                                          //teste
	ENDCASE
	        	
	IF "C"$MV_PAR11 .AND. _CSITUACAO =="COMERCIAL"
		_CRET += TRB1->A1_COD+TRB1->A1_LOJA+"/"
	ELSEIF "P"$MV_PAR11 .AND. _CSITUACAO=="PRODUCAO"
		_CRET += TRB1->A1_COD+TRB1->A1_LOJA+"/"
	ELSEIF "E"$MV_PAR11 .AND. _CSITUACAO=="EXPEDICAO"
		_CRET += TRB1->A1_COD+TRB1->A1_LOJA+"/"
	ELSEIF "F"$MV_PAR11 .AND. _CSITUACAO=="FATURAMENTO"
		_CRET += TRB1->A1_COD+TRB1->A1_LOJA+"/"  
	ELSEIF "I"$MV_PAR11 .AND. _CSITUACAO=="INDEFINIDO"    //teste
		_CRET += TRB1->A1_COD+TRB1->A1_LOJA+"/"                   //teste
	ENDIF       
	
	DBSELECTAREA("TRB1")
	DBSKIP()
ENDDO
RETURN(_CRET) 


STATIC FUNCTION REL01C() //BUSCA DADOS
************************************* 
LOCAL CQUERY := " "

CQUERY := " SELECT A1.A1_COD, A1.A1_LOJA, A1.A1_NOME, "
CQUERY += "	       B1.B1_COD, SUBSTRING(B1_DESC,1,40) B1_DESC, "
CQUERY += "        C5.C5_FILIAL, C5.C5_NUM, C5.C5_EMISSAO, C5.C5_UANA1, C5.C5_UANA2, C5.C5_UANA3, C5.C5_TPFRETE,  " 
CQUERY += "        C6.C6_QTDVEN, C6.C6_QTDENT, C6.C6_UQTPROD, C6.C6_UDTPROD, " 
CQUERY += "        B2.B2_QATU, C6.C6_UANA2, C5.C5_VEND1 " 
CQUERY += " FROM "+RETSQLNAME("SC5")+" C5, "+RETSQLNAME("SC6")+" C6, "+RETSQLNAME("SA1")+" A1, "+RETSQLNAME("SB1")+" B1, "+RETSQLNAME("SB2")+" B2 "
CQUERY += " WHERE C5.C5_FILIAL = '"+XFILIAL("SC5")+"' "
CQUERY += " AND C5.C5_FILIAL = C6.C6_FILIAL "
CQUERY += " AND C5.C5_NUM = C6.C6_NUM "
CQUERY += " AND C5.C5_CLIENTE = A1.A1_COD "
CQUERY += " AND C5.C5_LOJACLI = A1.A1_LOJA "
CQUERY += " AND C6.C6_PRODUTO = B1.B1_COD "
CQUERY += " AND C6.C6_FILIAL = B2.B2_FILIAL "
CQUERY += " AND C6.C6_PRODUTO = B2.B2_COD "
CQUERY += " AND C6.C6_LOCAL = B2.B2_LOCAL "
CQUERY += " AND (C6.C6_QTDVEN-C6.C6_QTDENT)>0 "
//CQUERY += " AND (C5.C5_UANA1<>' ' OR C5.C5_UANA2<>' ') "
CQUERY += " AND C5.C5_EMISSAO >= '"+DTOS(MV_PAR01)+"' "
CQUERY += " AND C5.C5_EMISSAO <= '"+DTOS(MV_PAR02)+"' "
CQUERY += " AND C5.C5_NUM >= '"+MV_PAR03+"' "
CQUERY += " AND C5.C5_NUM <= '"+MV_PAR04+"' "
CQUERY += " AND C5.C5_CLIENTE >= '"+MV_PAR05+"' "
CQUERY += " AND C5.C5_CLIENTE <= '"+MV_PAR06+"' "
CQUERY += " AND C6.C6_UDTPROD >= '"+DTOS(MV_PAR07)+"' "
CQUERY += " AND C6.C6_UDTPROD <= '"+DTOS(MV_PAR08)+"' "  
CQUERY += " AND C6.C6_ENTREG >= '"+DTOS(MV_PAR12)+"' "  //TESTE
CQUERY += " AND C6.C6_ENTREG <= '"+DTOS(MV_PAR13)+"' "  //TESTE
CQUERY += " AND C5.C5_VEND1 >= '"+MV_PAR09+"' "
CQUERY += " AND C5.C5_VEND1 <= '"+MV_PAR10+"' "  
CQUERY += " AND C5.C5_TIPO = 'N' "     //TESTE    
CQUERY += " AND C6.C6_BLQ <> 'R' "      //Teste
CQUERY += " AND C5.D_E_L_E_T_ = ' ' "
CQUERY += " AND C6.D_E_L_E_T_ = ' ' "
CQUERY += " AND A1.D_E_L_E_T_ = ' ' "
CQUERY += " AND B1.D_E_L_E_T_ = ' ' "
CQUERY += " AND B2.D_E_L_E_T_ = ' ' "
CQUERY += " ORDER BY A1.A1_COD, A1.A1_LOJA "
CQUERY := CHANGEQUERY(CQUERY)
IF SELECT("TRB1")!=0
	TRB1->(DBCLOSEAREA())
ENDIF
TCQUERY CQUERY NEW ALIAS "TRB1"
DBSELECTAREA("TRB1")
DBGOTOP()
IF EOF()
	RETURN(.F.)
ELSE
	RETURN(.T.)
ENDIF

RETURN(.T.)


STATIC FUNCTION VALIDPERG()
*************************************
LOCAL _AREA  := GETAREA()
LOCAL AREGS  := {}
LOCAL I,J

I:=0
J:=0
DBSELECTAREA("SX1")
DBSETORDER(1)
CPERG := PADR(CPERG,10)

// GRUPO/ORDEM/PERGUNTA/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/CNT01/VAR02/DEF02/CNT02/VAR03/DEF03/CNT03/VAR04/DEF04/CNT04/VAR05/DEF05/CNT05
AADD(AREGS,{CPERG,"01","EMISSAO DE   ?","?","?","MV_CHA","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})
AADD(AREGS,{CPERG,"02","EMISSAO ATE  ?","?","?","MV_CHB","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})
AADD(AREGS,{CPERG,"03","PEDIDO DE    ?","?","?","MV_CHC","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SC5" ,"","","","",""})
AADD(AREGS,{CPERG,"04","PEDIDO ATE   ?","?","?","MV_CHD","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SC5" ,"","","","",""})
AADD(AREGS,{CPERG,"05","CLIENTE DE   ?","?","?","MV_CHE","C",09,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA1" ,"","","","",""})
AADD(AREGS,{CPERG,"06","CLIENTE ATE  ?","?","?","MV_CHF","C",09,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA1" ,"","","","",""})
AADD(AREGS,{CPERG,"07","PRODUCAO DE   ?","?","?","MV_CHG","D",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})
AADD(AREGS,{CPERG,"08","PRODUCAO ATE  ?","?","?","MV_CHH","D",08,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})
AADD(AREGS,{CPERG,"09","VENDEDOR DE  ?","?","?","MV_CHI","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA3" ,"","","","",""})
AADD(AREGS,{CPERG,"10","VENDEDOR ATE ?","?","?","MV_CHJ","C",06,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SA3" ,"","","","",""})
AADD(AREGS,{CPERG,"11","SITUACAO     ?","?","?","MV_CHK","C",05,0,0,"G","U_REL01A()","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})  
AADD(AREGS,{CPERG,"12","ENTREGA DE   ?","?","?","MV_CHL","D",08,0,0,"G","","MV_PAR012","","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})     //TESTE
AADD(AREGS,{CPERG,"13","ENTREGA ATE  ?","?","?","MV_CHM","D",08,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})      //TESTE 
AADD(AREGS,{CPERG,"14","TIPO SAIDA   ?","?","?","MV_CHN","N",01,0,0,"C","","MV_PAR14","RELATORIO","","","","","EXCEL","","","","","","","","","","","","","","","","","","","" ,"","","","",""}) 

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
RESTAREA(_AREA)
RETURN 