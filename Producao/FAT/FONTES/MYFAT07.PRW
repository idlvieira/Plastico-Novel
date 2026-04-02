#INCLUDE "RWMAKE.CH"            
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"   

#DEFINE X3_USADO_EMUSO "€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO "€€€€€€€€€€€€€€€"
#DEFINE X3_USADO_NAOALTERA "€€€€€€€€€€€€€€° "
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³NOVFAT08 ³ AUTOR   ³ CASSIUS C MARTINS    ³ DATA ³12/11/13  ³±±
±±³PROGRAMA  ³MYFAT07  ³ REVISAO ³ SONIA SILVA          ³ DATA ³27/12/16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³FLUXO DE PEDIDOS - ANALISE 3	- LIBERACAO EXPEDICAO  		  ³±±
±±³DESCRICAO ³ANALISAR O PEDIDO DE VENDA PARA EXPEDICAO         		  ³±±
±±³UTILIZADO ³ESTOQUE                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante      Motivo
// 29/08/2023  Leandro Ferreira          Totvs		   	  Migração para banco

USER FUNCTION MYFAT07()	//USER FUNCTION NOVFAT08()//BROWSE
**********************************************************
PRIVATE CTAB	 	:= "SC5"
PRIVATE AINDICE		:= {}
PRIVATE CWHERE	 	:= "(C5_ZZUANA3='N'OR C5_ZZUANA3='C' OR C5_ZZUANA3='P') AND RTRIM(C5_BLQ)='' AND RTRIM(C5_NOTA)<>'XXXXXXXXX' AND (RTRIM(C5_NOTA)='' OR C5_LIBEROK='E')"  
//PRIVATE CWHERE	 	:= "(C5_UANA3='N'OR C5_UANA3='C' OR C5_UANA3='P') AND RTRIM(C5_BLQ)='' AND RTRIM(C5_NOTA)<>'XXXXXXXXX' AND (RTRIM(C5_NOTA)='' OR C5_LIBEROK='E')"  
PRIVATE	CTIT    	:= "FLUXO PV - ANALISE 3 - EXPEDICAO" 

PRIVATE AROTINA := { {"PESQUISAR",	"AXPESQUI",0,1} ,;
					 {"LIBERAR",	"U_FAT07B()",0,2},;
					 {"LEGENDA",	"U_FAT07A()",0,3},;
					 {"PEDIDO",		"U_FAT07E()",0,4},;
					 {"DEV.PCP",	"U_FAT07H()",0,2}}
					 
PRIVATE ACORES    := {	{  'C5_ZZUANA3=="N"'	 , 'BR_VERDE'},;
						{  'C5_ZZUANA3=="S"'	 , 'BR_VERMELHO'},;
						{  'C5_ZZUANA3=="C"'	 , 'BR_AMARELO'},;
						{  'C5_ZZUANA3=="P"'	 , 'BR_PRETO'}}  
                                                                                                   
/*PRIVATE AROTINA := { {"PESQUISAR","AXPESQUI",0,1} ,;
					 {"LIBERAR","U_FAT08B()",0,2},;
					 {"LEGENDA","U_FAT08A()",0,3},;
					 {"PEDIDO","U_FAT08E()",0,4},;
					 {"DEV.PCP","U_FAT08H()",0,2}}
					 
PRIVATE ACORES    := {	{  'C5_UANA3=="N"'	 , 'BR_VERDE'},;
						{  'C5_UANA3=="S"'	 , 'BR_VERMELHO'},;
						{  'C5_UANA3=="C"'	 , 'BR_AMARELO'},;
						{  'C5_UANA3=="P"'	 , 'BR_PRETO'}}   //TESTE
*/
					 
PRIVATE CDELFUNC := ".T." 

DBSELECTAREA(CTAB)
DBSETORDER(1)
DBGOTOP()
MBROWSE( 6,1,22,75,CTAB,,,,,,ACORES,,,,,.F.,,,CWHERE)
RETURN

      
USER FUNCTION FAT07A()	//LEGENDA
*************************************
LOCAL ALEG 		:= {}
AADD(ALEG,{"BR_VERDE"   	, OEMTOANSI( "N - PENDENTE" )})
AADD(ALEG,{"BR_VERMELHO"	, OEMTOANSI( "S - LIBERADO TOTAL" )})
AADD(ALEG,{"BR_AMARELO"		, OEMTOANSI( "C - LIBERADO PARCIAL" )})
AADD(ALEG,{"BR_PRETO"  		, OEMTOANSI( "P - PRODUCAO" )})
BRWLEGENDA( CTIT , "LEGENDAS",ALEG)
RETURN 
                                  
USER FUNCTION FAT07B()	//LIBERAR           
*************************************
Local _I		:= 0
PRIVATE _AC		:= {}
PRIVATE _AH		:= {}  
PRIVATE _NOPCA  := 0

IF !SC5->C5_ZZUANA3$"NCP"    //IF !SC5->C5_UANA3$"NCP"    //TESTE R
	MSGALERT("SOMENTE E POSSIVEL LIBERAR UM PEDIDO PENDENTE OU PARCIAL.")
	RETURN
ENDIF

AADD(_AH,FAT07F("C6_NUM","C6NUM","PEDIDO",.F.,0,"SC6")) //FAT25B(PSEMELHANTE,PCAMPO,PDESCR,PLEDIT,PTAM) --> BUSCA CAMPO
AADD(_AH,FAT07F("C6_ITEM","C6ITEM","ITEM",.F.,0,"SC6"))
AADD(_AH,FAT07F("C6_PRODUTO","C6PRODUTO","PRODUTO",.F.,0,"SC6"))                 
AADD(_AH,FAT07F("C6_ITEMGRD","C6ITEMGRD","GRADE",.F.,0,"SC6"))                 
AADD(_AH,FAT07F("C6_DESCRI","C6DESCRI","DESCR.",.F.,0,"SC6"))    
AADD(_AH,FAT07F("C6_LOCAL","C6LOCAL","LOCAL",.F.,0,"SC6"))    
AADD(_AH,FAT07F("C6_QTDVEN","C6QTDVEN","QT.PEDIDO",.F.,0,"SC6")) 
AADD(_AH,FAT07F("C6_QTDVEN","C6QTSALDO","QT.SALDO",.F.,0,"SC6")) 
AADD(_AH,FAT07F("B2_QATU","B2QATU","QT.ESTOQUE",.F.,0,"SB2")) 
AADD(_AH,FAT07F("C6_ZZUQTPR","C6UQTPROD","QT.LIBERADA",.F.,0,"SC6"))
//AADD(_AH,FAT08F("C6_UQTPROD","C6UQTPROD","QT.LIBERADA",.F.,0)) 
AADD(_AH,FAT07F("C6_QTDVEN","C6QTENTR","QT.ENTREGA",.F.,0,"SC6")) 

DBSELECTAREA("SC6")
DBSETORDER(1)
DBGOTOP()
DBSEEK(XFILIAL("SC6")+SC5->C5_NUM)
WHILE !EOF() .AND. SC6->C6_FILIAL+SC6->C6_NUM==SC5->C5_FILIAL+SC5->C5_NUM
	IF SC6->C6_QTDVEN-SC6->C6_QTDENT>0                                           
		DBSELECTAREA("SB2")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
		_NSALDO := SB2->B2_QATU //-(SB2->B2_RESERVA+SB2->B2_QTDLIB)
		AADD(_AC,{SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_ITEMGRD, SC6->C6_DESCRI, SC6->C6_LOCAL, SC6->C6_QTDVEN, SC6->C6_QTDVEN-SC6->C6_QTDENT, _NSALDO, SC6->C6_ZZUQTPR, 0, .F.})	                                 
		//AADD(_AC,{SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_ITEMGRD, SC6->C6_DESCRI, SC6->C6_LOCAL, SC6->C6_QTDVEN, SC6->C6_QTDVEN-SC6->C6_QTDENT, _NSALDO, SC6->C6_UQTPROD, 0, .F.})
	ENDIF
	DBSELECTAREA("SC6")
	DBSKIP()
ENDDO

OMAINWND:READCLIENTCOORDS()
ODLG := MSDIALOG():NEW(OMAINWND:NTOP+130,OMAINWND:NLEFT+80,OMAINWND:NBOTTOM-130,OMAINWND:NRIGHT-130,"ITENS EXPEDICAO",,,.F.,,,,,OMAINWND,.T.,,,.F.)

OPNLCLIENT := TPANEL():NEW(1,1,,ODLG,,.T.,.F.,,,1,40,.T.,)
OPNLCLIENT:ALIGN := CONTROL_ALIGN_ALLCLIENT 
OGRD := MSNEWGETDADOS():NEW(1,1,200,200,GD_UPDATE,,,,{"C6QTENTR"},,LEN(_AC),"U_FAT07G('OGRDB')",,,OPNLCLIENT,_AH,_AC)
OGRD:OBROWSE:ALIGN := 5

ACTIVATE MSDIALOG ODLG ON INIT ENCHOICEBAR(ODLG,{||_NOPCA:=1, _AC:=OGRD:ACOLS, ODLG:END()},{||_NOPCA:=2, ODLG:END()}) CENTERED 

IF _NOPCA==1

	_NPQTENT := ASCAN(_AH,{|X|X[2]=="C6QTENTR"})
	_NQTD    := 0	
	FOR _I:=1 TO LEN(_AC)
		_NQTD += _AC[_I,_NPQTENT]
	NEXT _I
	
	IF _NQTD==0
		MSGSTOP("QUANTIDADE PARA EXPEDICAO NAO FOI INFORMADA")
		RETURN
	ENDIF
	
	DBSELECTAREA("SC5")
	_CQUERY := "SELECT COUNT(1) QT "
	_CQUERY += "  FROM "+RETSQLNAME("SC9")+" SC9 "
	_CQUERY += " WHERE SC9.C9_FILIAL = '"+SC5->C5_FILIAL+"' "
	_CQUERY += "   AND SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' "
	_CQUERY += "   AND SC9.C9_NFISCAL = '         ' "
	_CQUERY += "   AND SC9.D_E_L_E_T_ = ' ' "			
	_CQUERY := CHANGEQUERY(_CQUERY)
	IF SELECT("TRB1")!=0
		TRB1->(DBCLOSEAREA())
	ENDIF
	TCQUERY _CQUERY NEW ALIAS "TRB1"			
	IF TRB1->QT>0
		IF !FAT07C()
			MSGSTOP("ERRO AO ESTORNAR LIBERACOES DO PEDIDO, OPERACAO CANCELADA!")
			RETURN
		ENDIF
	ENDIF
	TRB1->(DBCLOSEAREA())
	
	FAT07D()

ENDIF
RETURN                                  


STATIC FUNCTION FAT07C()		 //LIBERA PV QDO EXISTIR SC9
************************************************************
LOCAL _LRET := .T.
  
_ACAB1   := {{"C5_NUM",SC5->C5_NUM,NIL}}
_AITEPED := {}
DBSELECTAREA("SC6")
DBSETORDER(1)
DBSEEK(SC5->C5_FILIAL+SC5->C5_NUM)
WHILE !EOF() .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
	AADD(_AITEPED,{ {"C6_NUM" ,SC6->C6_NUM,NIL},;
					{"C6_ITEM" ,SC6->C6_ITEM,NIL},;
					{"C6_PRODUTO" ,SC6->C6_PRODUTO,NIL},;
					{"C6_QTDVEN" ,SC6->C6_QTDVEN,NIL},;
					{"C6_PRCVEN" ,SC6->C6_PRCVEN,NIL},;
					{"C6_VALOR" ,SC6->C6_VALOR,NIL},;
					{"C6_TES" ,SC6->C6_TES,NIL},;
					{"C6_ZZUQTPR",SC6->C6_ZZUQTPR,NIL}})
					//{"C6_UQTPROD",SC6->C6_UQTPROD,NIL}})
	DBSKIP()
ENDDO 
LMSERROAUTO := .F.
LMSHELPAUTO := .T. 
_nModulo := nModulo
nModulo := 5
MSEXECAUTO({|X,Y,Z| MATA410(X,Y,Z)},_ACAB1,_AITEPED,4)
IF LMSERROAUTO
	MOSTRAERRO()   
	nModulo := _nModulo
	RETURN(.F.)
ENDIF
nModulo := _nModulo
RETURN(_LRET)
    

STATIC FUNCTION FAT07D() 		//LIBERA PV 
*******************************************                    
LOCAL _NPNUM  := ASCAN(_AH,{|X|X[2]=="C6NUM"})
LOCAL _NPITEM := ASCAN(_AH,{|X|X[2]=="C6ITEM"})
LOCAL _NPPROD := ASCAN(_AH,{|X|X[2]=="C6PRODUTO"})
LOCAL _NPIGRD := ASCAN(_AH,{|X|X[2]=="C6ITEMGRD"})                          
LOCAL _NPQTEN := ASCAN(_AH,{|X|X[2]=="C6QTENTR"})
LOCAL _NPQTPR := ASCAN(_AH,{|X|X[2]=="C6UQTPROD"})
LOCAL _NPQSLD := ASCAN(_AH,{|X|X[2]=="C6QTSALDO"})
LOCAL _NQTD	  := 0
LOCAL _NQTPV  := 0
LOCAL _NQTPR  := 0
Local _I		:= 0
PRIVATE LBLQCRD := .T.
PRIVATE LBLQEST := .T.

FOR _I:=1 TO LEN(_AC)
	DBSELECTAREA("SC6")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC6")+_AC[_I,_NPNUM]+_AC[_I,_NPITEM]+_AC[_I,_NPPROD]+_AC[_I,_NPIGRD])		
		
		_NQTPV += _AC[_I,_NPQSLD]
		_NQTPR += _AC[_I,_NPQTPR]
		                            
		IF _AC[_I,_NPQTEN] > 0	
			//---------------------------------------------------------------------------
			//     ROTINA MALIBDOFAT: LIBERA OS ITENS DE PEDIDO DE VENDAS
			//---------------------------------------------------------------------------                     
			//     PARAMETROS
			//---------------------------------------------------------------------------
			//          ³EXPN1: REGISTRO DO SC6                                      
			//          ³EXPN2: QUANTIDADE A LIBERAR                                 
			//          ³EXPL3: BLOQUEIO DE CREDITO                                  
			//          ³EXPL4: BLOQUEIO DE ESTOQUE                                  
			//          ³EXPL5: AVALIACAO DE CREDITO                                 
			//          ³EXPL6: AVALIACAO DE ESTOQUE                                 
			//          ³EXPL7: PERMITE LIBERACAO PARCIAL                            
			//          ³EXPL8: TRANFERE LOCAIS AUTOMATICAMENTE                      
			//          ³EXPA9: EMPENHOS ( CASO SEJA INFORMADO NAO EFETUA A GRAVACAO 
			//          ³       APENAS AVALIA ).                                    
			//          ³EXPBA: CODEBLOCK A SER AVALIADO NA GRAVACAO DO SC9           
			//          ³EXPAB: ARRAY COM EMPENHOS PREVIAMENTE ESCOLHIDOS            
			//          ³       (IMPEDE SELECAO DOS EMPENHOS PELAS ROTINAS)          
			//          ³EXPLC: INDICA SE APENAS ESTA TROCANDO LOTES DO SC9          
			//          ³EXPND: VALOR A SER ADICIONADO AO LIMITE DE CREDITO          
			//          ³EXPNE: QUANTIDADE A LIBERAR - SEGUNDA UM  
			
			//ABRE O CABECALHO DOS PEDIDOS
			DBSELECTAREA("SC5")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SC5")+SC5->C5_NUM)
			
			//ABRE OS ITENS DOS PEDIDOS
			DBSELECTAREA("SC6")
			DBSETORDER(1)
			DBGOTOP()
			DBSEEK(XFILIAL("SC6")+_AC[_I,_NPNUM]+_AC[_I,_NPITEM]+_AC[_I,_NPPROD]+_AC[_I,_NPIGRD])
			
			DBSELECTAREA("SE4")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SE4")+SC5->C5_CONDPAG)//FILIAL+CONDICAO PAGTO
			
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SB1")+SC6->C6_PRODUTO)//FILIAL+PRODUTO
			
			DBSELECTAREA("SB2")
			DBSETORDER(1)
			IF !DBSEEK(XFILIAL("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
				RECLOCK("SB2",.T.)
				SB2->B2_FILIAL := XFILIAL("SB2")
				SB2->B2_COD    := SC6->C6_PRODUTO
				SB2->B2_LOCAL  := SC6->C6_LOCAL         
				MSUNLOCK()
			ENDIF

			DBSELECTAREA("SF4")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SF4")+SC6->C6_TES)//FILIAL+TES
			DBSELECTAREA('SC6')
		
			_NQTD += MALIBDOFAT(SC6->(RECNO()), _AC[_I,_NPQTEN], @LBLQCRD, @LBLQEST, .F., .F. ) 
						     
		ENDIF
	ENDIF	
NEXT _I        

IF _NQTD > 0	
	//VERIFICA SE EXISTE BLOQUEIO DE CRéDITO OU ESTOQUE, SE EXISTIR DESBLOQUEIA
	MALIBEROK( { SC5->C5_NUM }, .F. )  
ENDIF
                   
IF _NQTD==_NQTPV
	DBSELECTAREA("SC5")
	RECLOCK("SC5",.F.)
	SC5->C5_ZZUANA3 := "S"		//SC5->C5_UANA3 := "S"
	MSUNLOCK()
ELSE
	DBSELECTAREA("SC5")
	IF _NQTPR>_NQTD
		RECLOCK("SC5",.F.)
		SC5->C5_ZZUANA3 := "C"	//SC5->C5_UANA3 := "C"   //teste N
		MSUNLOCK()
	ELSE 
	    RECLOCK("SC5",.F.)
        SC5->C5_ZZUANA3 := "P" //SC5->C5_UANA3 := "P"
	    MSUNLOCK()
	ENDIF
ENDIF

MAILFAT()

RETURN

/*
//Este trecho permite alterar pedido de venda atraves do botao pedido /// não pode//

USER FUNCTION FAT07E()            
**********************************
LOCAL CAREA := GETAREA()
PRIVATE CCADASTRO
PRIVATE L410AUTO
DBSELECTAREA("SC5")
A410ALTERA("SC5",SC5->(RECNO()),4)
RESTAREA(CAREA)
RETURN    
*/

User Function FAT07E()	//VISUALIZAR PEDIDO DE VENDA
**********************************
Local 	CAREA := GETAREA()
Private CCADASTRO
private Inclui   := .F.
private Altera   := .F.
private lRefresh := .T.
dbSelectArea("SC5")
A410VISUAL("SC5",SC5->(RECNO()),2)
RESTAREA(CAREA)
Return

STATIC FUNCTION FAT07F(PSEMELHANTE,PCAMPO,PDESCR,PLEDIT,PTAM,PALIAS) //BUSCA CAMPO
***************************************************************************
LOCAL ACMP 	:= {}
/*DBSELECTAREA("SX3")
DBSETORDER(2)
IF DBSEEK(PSEMELHANTE)                                                                                                                                  
	ACMP := { TRIM(PDESCR), PCAMPO, X3_PICTURE, IIF(PTAM>0,PTAM,X3_TAMANHO), X3_DECIMAL, ,IIF(PLEDIT,X3_USADO_EMUSO,X3_USADO_NAOALTERA), X3_TIPO}
ENDIF*/
LOCAL _aCpoSX3 	:= FwSX3Util():GetAllFields(PALIAS)
Local i 		:= 0

For i := 1 To Len(_aCpoSX3)

	If( AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')) $ PSEMELHANTE )

        ACMP	:= {AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_TITULO')),;
                        AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_PICTURE'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_TAMANHO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_DECIMAL'),;
                         ,;
                        GetSx3Cache(_aCpoSX3[i], 'X3_USADO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_TIPO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_F3'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_CONTEXT'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_CBOX'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_RELACAO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_WHEN'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_VISUAL'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_VLDUSER'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_PICTVAR'),;
                        If(GetSx3Cache(_aCpoSX3[i], 'X3_OBRIGAT') == "€", .T., .F.)} 

    Endif

Next i
RETURN(ACMP)                
           

USER FUNCTION FAT07G(_POGRD)
***********************************  
IF _POGRD=="OGRDB"
	IF "C6QTENTR"$READVAR()         
		_NPQTSLD := ASCAN(_AH,{|X|X[2]=="C6QTSALDO"})
		_NPQATU  := ASCAN(_AH,{|X|X[2]=="B2QATU"})
		IF M->C6QTENTR>OGRD:ACOLS[N,_NPQTSLD] .OR. M->C6QTENTR>OGRD:ACOLS[N,_NPQATU]
			MSGALERT("QUANTIDADE DEVE SER MENOR OU IGUAL AO SALDO A ENTREGAR DO PEDIDO E MENOR OU IGUAL AO SALDO EM ESTOQUE.")
			RETURN(.F.)
		ENDIF			                               
	ENDIF                                              
ENDIF
RETURN(.T.)                              



USER FUNCTION FAT07H() 		//DEV.PCP
*****************************************  
LOCAL _AREA := GETAREA()

IF !SC5->C5_ZZUANA3$"NC" 	//IF !SC5->C5_UANA3$"NC" 
	MSGALERT("SOMENTE E POSSIVEL DEVOLVER AO PCP UM PEDIDO PENDENTE OU PARCIAL.")
	RETURN
ENDIF  

IF !MSGYESNO("DESEJA REALMENTE DEVOLVER ESTE PEDIDO PARA O PCP ?")
	RETURN
ENDIF

_NQTENT := 0
DBSELECTAREA("SC6")
DBSETORDER(1)
DBGOTOP()
DBSEEK(SC5->C5_FILIAL+SC5->C5_NUM)
WHILE !EOF() .AND. SC5->C5_FILIAL+SC5->C5_NUM==SC6->C6_FILIAL+SC6->C6_NUM
	IF SC6->C6_QTDENT<SC6->C6_QTDVEN
		RECLOCK("SC6",.F.)
		SC6->C6_ZZUQTPR := SC6->C6_QTDENT	//SC6->C6_UQTPROD := SC6->C6_QTDENT
		SC6->C6_ZZUANA2	:= " "				//SC6->C6_UANA2   := " "
		SC6->C6_ZZUDTPR	:= CTOD("")			//SC6->C6_UDTPROD := CTOD("")		
		MSUNLOCK() 
	ENDIF   
	_NQTENT += SC6->C6_QTDENT
	DBSELECTAREA("SC6")
	DBSKIP()           
ENDDO
                               
DBSELECTAREA("SC5")
RECLOCK("SC5",.F.)
SC5->C5_ZZUANA3 := "P"		//SC5->C5_UANA3 := "P"
IF _NQTENT>0
	SC5->C5_ZZUANA2 := "C"	//SC5->C5_UANA2 := "C"
ELSE
	SC5->C5_ZZUANA2 := "N"	//SC5->C5_UANA2 := "N"
ENDIF
MSUNLOCK()

RESTAREA(_AREA)
RETURN

// SSILVA 20170103 - FUNCAO QUE ENVIA EMAIL PARA A FATURAMENTO AVISANDO DA LIBERACAO DO PEDIDO PELA EXPEDICAO

Static Function MAILFAT()
Local oHtml
Local oEmail
Local cServidor	:=	GetMv("MV_RELSERV")
Local cConta	:=	GetMv("MV_RELACNT")
Local cPassWord	:=	GetMv("MV_RELPSW")
Local cAutentic	:=	GetMv("MV_RELAUTH")
Local cAnexo    := ''
Local cTitulo 	:= ""
Local aCorpo  	:= {}
Local aRodape 	:= {}
Local cAssunto  := " O Pedido de Numero "+SC5->C5_NUM+" Foi liberado para faturamento!"
Local cPara 	:= Posicione ("ZZZ",1,xFilial("ZZZ")+"FAT000009"+"001","ZZZ_RETORN")	
Local cCC		:= ""
Local cCCo		:= ""
Local cRemet 	:= GetMv("MV_RELACNT")

aAdd(aCorpo, 'O Pedido abaixo:')
aAdd(aCorpo, '')
aAdd(aCorpo, 'Numero '+SC5->C5_NUM )
aAdd(aCorpo, '')
aAdd(aCorpo, 'Foi liberado pelo Expedicao e esta pronto para Faturamento! ')
aAdd(aRodape, '')
aAdd(aRodape, 'Obrigado')

oHtml:= CorpoEmail():New(cTitulo, aCorpo, aRodape)
oHtml:GeraHtml()
&&Enviando E-mail
oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
oEmail:EmailUsr()
oEmail:Conectar()
If oEmail:Enviar(AllTrim(cRemet), AllTrim(cPara), AllTrim(cCC), AllTrim(cCCO), AllTrim(cAssunto), oHtml:cHtml, cAnexo)
	lRetorno	:=	.t.
	Aviso(FunDesc(),"E-mail enviado com SUCESSO.",{"OK"})
Endif
oEmail:Desconec()

Return
