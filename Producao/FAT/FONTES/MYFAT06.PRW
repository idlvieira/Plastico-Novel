#INCLUDE "RWMAKE.CH"            
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"     
#DEFINE X3_USADO_EMUSO "€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO "€€€€€€€€€€€€€€€"
#DEFINE X3_USADO_NAOALTERA "€€€€€€€€€€€€€€° "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³NOVFAT07 ³ AUTOR   ³ CASSIUS C MARTINS    ³ DATA ³12/11/13  ³±±
±±³PROGRAMA  ³MYFAT05  ³ REVISAO ³ SONIA SILVA          ³ DATA ³27/12/16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³FLUXO DE PEDIDOS - ANALISE 2	- LIBERACAO PCP     		  ³±±
±±³DESCRICAO ³ANALISAR O PEDIDO DE VENDA PARA PRODUCAO          		  ³±±
±±³UTILIZADO ³PCP                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/ 
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante      Motivo
// 29/08/2023  Leandro Ferreira          Totvs		   	  Migração para banco

USER FUNCTION MYFAT06()	//USER FUNCTION NOVFAT07()//BROWSE
**********************************************************

PRIVATE CTAB	 	:= "SC5"
PRIVATE AINDICE		:= {}
PRIVATE CWHERE	 	:= "C5_ZZUANA1='S' AND C5_ZZUANA2<>' ' AND RTRIM(C5_BLQ)='' AND RTRIM(C5_NOTA)<>'XXXXXXXXX' AND (RTRIM(C5_NOTA)='' OR C5_LIBEROK='E')"
//PRIVATE CWHERE	 	:= "C5_UANA1='S' AND C5_UANA2<>' ' AND RTRIM(C5_BLQ)='' AND RTRIM(C5_NOTA)<>'XXXXXXXXX' AND (RTRIM(C5_NOTA)='' OR C5_LIBEROK='E')"  
PRIVATE	CTIT    	:= "FLUXO PV - ANALISE 2 - VALIDACAO PCP" 
                                                                                                  
PRIVATE AROTINA := { {"PESQUISAR",	"AXPESQUI",0,1} ,;
					 {"LIBERAR",	"U_FAT06B()",0,2},;
					 {"PROGRAMAR",	"U_FAT06D()",0,2},;
					 {"REPROVAR",	"U_FAT06E()",0,2},;
					 {"LEGENDA",	"U_FAT06A()",0,3},;
				     {"PEDIDO",		"U_FAT06C()",0,4}}
					 
PRIVATE ACORES    := {	{  'C5_ZZUANA2=="N"'	 , 'BR_VERDE'},;
						{  'C5_ZZUANA2=="S"'	 , 'BR_VERMELHO'},;
						{  'C5_ZZUANA2=="C"'	 , 'BR_AMARELO'},;
						{  'C5_ZZUANA2=="P"'	 , 'BR_AZUL'},;
						{  'C5_ZZUANA2=="G"'	 , 'BR_CINZA'},;
						{  'C5_ZZUANA2=="R"'	 , 'BR_LARANJA'}}

/*                                                                                                   
PRIVATE AROTINA := { {"PESQUISAR","AXPESQUI",0,1} ,;
					 {"LIBERAR","U_FAT07B()",0,2},;
					 {"PROGRAMAR","U_FAT07D()",0,2},;
					 {"REPROVAR","U_FAT07E()",0,2},;
					 {"LEGENDA","U_FAT07A()",0,3},;
					 {"PEDIDO","U_FAT07C()",0,4}}
					 
PRIVATE ACORES    := {	{  'C5_UANA2=="N"'	 , 'BR_VERDE'},;
						{  'C5_UANA2=="S"'	 , 'BR_VERMELHO'},;
						{  'C5_UANA2=="C"'	 , 'BR_AMARELO'},;
						{  'C5_UANA2=="P"'	 , 'BR_AZUL'},;
						{  'C5_UANA2=="G"'	 , 'BR_CINZA'},;
						{  'C5_UANA2=="R"'	 , 'BR_LARANJA'}}
*/
					 
PRIVATE CDELFUNC := ".T." 

DBSELECTAREA(CTAB)
DBSETORDER(1)
DBGOTOP()
MBROWSE( 6,1,22,75,CTAB,,,,,,ACORES,,,,,.F.,,,CWHERE)
RETURN

      
USER FUNCTION FAT06A()	//LEGENDA
*************************************

LOCAL ALEG 		:= {}
AADD(ALEG,{"BR_VERDE"	  	, OEMTOANSI( "N - PENDENTE" )})
AADD(ALEG,{"BR_VERMELHO"	, OEMTOANSI( "S - LIBERADO TOTAL" )})
AADD(ALEG,{"BR_AMARELO"		, OEMTOANSI( "C - LIBERADO PARCIAL" )})
AADD(ALEG,{"BR_AZUL"  		, OEMTOANSI( "P - PROGRAMADO TOTAL" )})
AADD(ALEG,{"BR_CINZA"  		, OEMTOANSI( "G - PROGRAMADO PARCIAL" )})
AADD(ALEG,{"BR_LARANJA"  	, OEMTOANSI( "R - REPROVADO" )})
BRWLEGENDA( CTIT , "LEGENDAS",ALEG)
RETURN 
                                  

USER FUNCTION FAT06B()	//LIBERAR           
*************************************
LOCAL 	_I			:= 0
PRIVATE _AC		:= {}
PRIVATE _AH		:= {}  
PRIVATE _NOPCA  := 0                     

IF !SC5->C5_ZZUANA2$"PGC"
	MSGALERT("SOMENTE E POSSIVEL LIBERAR UM PEDIDO PROGRAMADO.")
	RETURN
ENDIF

AADD(_AH,FAT06F("C6_NUM","C6NUM","PEDIDO",.F.,0)) 	//FAT25B(PSEMELHANTE,PCAMPO,PDESCR,PLEDIT,PTAM) --> BUSCA CAMPO
AADD(_AH,FAT06F("C6_ITEM","C6ITEM","ITEM",.F.,0))
AADD(_AH,FAT06F("C6_PRODUTO","C6PRODUTO","PRODUTO",.F.,0))
AADD(_AH,FAT06F("C6_DESCRI","C6DESCRI","DESCR.",.F.,0))   
AADD(_AH,FAT06F("C6_ZZUDTPR","C6UDTPROD","DT.PRODUCAO",.F.,0))	//AADD(_AH,FAT06F("C6_UDTPROD","C6UDTPROD","DT.PRODUCAO",.F.,0)) 
AADD(_AH,FAT06F("C6_QTDVEN","C6QTDVEN","QT.PEDIDO",.F.,0)) 
AADD(_AH,FAT06F("C6_QTDVEN","C6QTSALDO","QT.SALDO",.F.,0)) 
AADD(_AH,FAT06F("C6_ZZUQTPR","C6UQTPROD","QT.PRODUCAO",.F.,0)) //AADD(_AH,FAT06F("C6_UQTPROD","C6UQTPROD","QT.PRODUCAO",.F.,0)) 

DBSELECTAREA("SC6")
DBSETORDER(1)
DBGOTOP()
DBSEEK(XFILIAL("SC6")+SC5->C5_NUM)
WHILE !EOF() .AND. SC6->C6_FILIAL+SC6->C6_NUM==SC5->C5_FILIAL+SC5->C5_NUM
	IF SC6->C6_QTDVEN-SC6->C6_QTDENT>0
		AADD(_AC,{SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_DESCRI, DTOC(SC6->C6_ZZUDTPR), SC6->C6_QTDVEN, SC6->C6_QTDVEN-SC6->C6_ZZUQTPR, 0, .F.})
	ENDIF
	DBSELECTAREA("SC6")
	DBSKIP()
ENDDO

OMAINWND:READCLIENTCOORDS()
ODLG := MSDIALOG():NEW(OMAINWND:NTOP+130,OMAINWND:NLEFT+80,OMAINWND:NBOTTOM-130,OMAINWND:NRIGHT-130,"ITENS PRODUZIDOS",,,.F.,,,,,OMAINWND,.T.,,,.F.)

OPNLCLIENT := TPANEL():NEW(1,1,,ODLG,,.T.,.F.,,,1,40,.T.,)
OPNLCLIENT:ALIGN := CONTROL_ALIGN_ALLCLIENT 
OGRD := MSNEWGETDADOS():NEW(1,1,200,200,GD_UPDATE,,,,{"C6UQTPROD"},,LEN(_AC),"U_FAT06G('OGRDB')",,,OPNLCLIENT,_AH,_AC)
OGRD:OBROWSE:ALIGN := 5

ACTIVATE MSDIALOG ODLG ON INIT ENCHOICEBAR(ODLG,{||_NOPCA:=1, _AC:=OGRD:ACOLS, ODLG:END()},{||_NOPCA:=2, ODLG:END()}) CENTERED 

IF _NOPCA==1        
	_LTOTAL  := .T.
	_QDTNULL := .T.

	_NPNUM	 := ASCAN(_AH,{|X|X[2]=="C6NUM"})
	_NPITEM	 := ASCAN(_AH,{|X|X[2]=="C6ITEM"})
	_NPPROD	 := ASCAN(_AH,{|X|X[2]=="C6PRODUTO"})
	_NPQTPRD := ASCAN(_AH,{|X|X[2]=="C6UQTPROD"})
	
  /*	FOR _I:=1 TO LEN(_AC)
		IF _AC[_I,_NPQTPRD]==0  
		
			MSGSTOP("QUANTIDADE PRODUZIDA NAO FOI INFORMADA")
			RETURN
		ENDIF
	NEXT _I      */        
	
	FOR _I:=1 TO LEN(_AC)
		IF _AC[_I,_NPQTPRD]<>0  
	     	_QDTNULL := .F.
		ENDIF
	NEXT _I      
    
    IF _QDTNULL
    	MSGSTOP("QUANTIDADE PRODUZIDA NAO FOI INFORMADA")
		RETURN
    ENDIF			                            //VERIFICAR SE OS ITENS TA SEM QTDE
	
	FOR _I:=1 TO LEN(_AC)
		DBSELECTAREA("SC6")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SC6")+_AC[_I,_NPNUM]+_AC[_I,_NPITEM]+_AC[_I,_NPPROD])
		RECLOCK("SC6",.F.)
		
		IF _AC[_I,_NPQTPRD] > 0
		   SC6->C6_ZZUDTEST := DATE()	//SC6->C6_UDTEST := DATE()
		ENDIF
		
		SC6->C6_ZZUQTPR := SC6->C6_ZZUQTPR+_AC[_I,_NPQTPRD]	//SC6->C6_UQTPROD := SC6->C6_UQTPROD+_AC[_I,_NPQTPRD]   
		     
		MSUNLOCK() 
		
		IF SC6->C6_QTDVEN>SC6->C6_ZZUQTPR	//IF SC6->C6_QTDVEN>SC6->C6_UQTPROD
			_LTOTAL := .F.
		ELSE      
	     	RECLOCK("SC6",.F.)
		  	SC6->C6_ZZUANA2 := "E"	//SC6->C6_UANA2 := "E" 
		  	MSUNLOCK()
		ENDIF
	NEXT _I
             
	IF _LTOTAL
		DBSELECTAREA("SC5")   
		RECLOCK("SC5",.F.)
		SC5->C5_ZZUANA2 := "S"	//SC5->C5_UANA2 := "S" 
		SC5->C5_ZZUANA3 := IIF(SC5->C5_ZZUANA3$"SP ","N",SC5->C5_ZZUANA3)	//SC5->C5_UANA3 := IIF(SC5->C5_UANA3$"SP ","N",SC5->C5_UANA3)
		MSUNLOCK()	
	ELSE
		DBSELECTAREA("SC5")   
		RECLOCK("SC5",.F.)
		SC5->C5_ZZUANA2 := "C"	//SC5->C5_UANA2 := "C" 
		SC5->C5_ZZUANA3 := IIF(SC5->C5_ZZUANA3$"SP ","N",SC5->C5_ZZUANA3)	//SC5->C5_UANA3 := IIF(SC5->C5_UANA3$"SP ","N",SC5->C5_UANA3)
		MSUNLOCK()	       
		
	   /*DBSELECTAREA("SC6")
		DBSETORDER(1)
		DBGOTOP()
		DBSEEK(XFILIAL("SC6")+SC5->C5_NUM)
		WHILE !EOF() .AND. SC6->C6_FILIAL+SC6->C6_NUM==SC5->C5_FILIAL+SC5->C5_NUM
			IF SC6->C6_QTDVEN>SC6->C6_UQTPROD
				RECLOCK("SC6",.F.)
				SC6->C6_UDTPROD := CTOD("")
				MSUNLOCK()
			ENDIF         
			DBSKIP()
	    ENDDO*/
	ENDIF
	DBSELECTAREA("SC5")
ENDIF

//SSILVA 20170103 - FUNCAO QUE ENVIA EMAIL PARA EXPEDICAO ALERTANDO SOBRE A LIBERACAO DO PEDIDO DE VENDA PELA PRODUCAO
   
  MAILPCP()
  
RETURN

/*
//Este trecho permite alterar pedido de venda atraves do botao pedido /// não pode//
                                                                                 
USER FUNCTION FAT06C()	//CHAMA PEDIDO            
******************************************
LOCAL CAREA := GETAREA()
PRIVATE CCADASTRO
PRIVATE L410AUTO
DBSELECTAREA("SC5")
A410ALTERA("SC5",SC5->(RECNO()),4)
RESTAREA(CAREA)
RETURN    
*/

User Function FAT06C()	//VISUALIZAR PEDIDO DE VENDA
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

USER FUNCTION FAT06D()	//PROGRAMAR            
***************************************
LOCAL 	_I			:= 0
PRIVATE _AC		:= {}
PRIVATE _AH		:= {}  
PRIVATE _NOPCA  := 0

IF !SC5->C5_ZZUANA2$"NPGC"	//IF !SC5->C5_UANA2$"NPGC"
	MSGALERT("SOMENTE E POSSIVEL PROGRAMAR UM PEDIDO PENDENTE OU JA PROGRAMADO.")
	RETURN
ENDIF

AADD(_AH,FAT06F("C6_NUM","C6NUM","PEDIDO",.F.,0)) //S/FAT25B(PSEMELHANTE,PCAMPO,PDESCR,PLEDIT,PTAM) --> BUSCA CAMPO
AADD(_AH,FAT06F("C6_ITEM","C6ITEM","ITEM",.F.,0))
AADD(_AH,FAT06F("C6_PRODUTO","C6PRODUTO","PRODUTO",.F.,0))
AADD(_AH,FAT06F("C6_DESCRI","C6DESCRI","DESCR.",.F.,0))    
AADD(_AH,FAT06F("C6_ZZUDTPR","C6UDTPROD","DT.PRODUCAO",.F.,0))	//AADD(_AH,FAT06F("C6_UDTPROD","C6UDTPROD","DT.PRODUCAO",.F.,0)) 
AADD(_AH,FAT06F("C6_QTDVEN","C6QTDVEN","QT.PEDIDO",.F.,0)) 
AADD(_AH,FAT06F("C6_QTDVEN","C6QTSALDO","QT.SALDO",.F.,0)) 
AADD(_AH,FAT06F("C6_ZZUQTPR","C6UQTPROD","QT.PRODUCAO",.F.,0)) 	//AADD(_AH,FAT06F("C6_UQTPROD","C6UQTPROD","QT.PRODUCAO",.F.,0)) 

DBSELECTAREA("SC6")
DBSETORDER(1)
DBGOTOP()
DBSEEK(XFILIAL("SC6")+SC5->C5_NUM)
WHILE !EOF() .AND. SC6->C6_FILIAL+SC6->C6_NUM==SC5->C5_FILIAL+SC5->C5_NUM
	IF SC6->C6_QTDVEN-SC6->C6_QTDENT>0                                   
		DBSELECTAREA("SA1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SA1")+SC6->C6_CLI+SC6->C6_LOJA)
		AADD(_AC,{SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_DESCRI, SC6->C6_ZZUDTPR, SC6->C6_QTDVEN, SC6->C6_QTDVEN-SC6->C6_ZZUQTPR, 0, .F.})
		//AADD(_AC,{SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_DESCRI, SC6->C6_UDTPROD, SC6->C6_QTDVEN, SC6->C6_QTDVEN-SC6->C6_UQTPROD, 0, .F.})
	ENDIF
	DBSELECTAREA("SC6")
	DBSKIP()
ENDDO

OMAINWND:READCLIENTCOORDS()
ODLG := MSDIALOG():NEW(OMAINWND:NTOP+130,OMAINWND:NLEFT+80,OMAINWND:NBOTTOM-130,OMAINWND:NRIGHT-130,"PROGRAMAR PRODUCAO",,,.F.,,,,,OMAINWND,.T.,,,.F.)

OPNLCLIENT := TPANEL():NEW(1,1,,ODLG,,.T.,.F.,,,1,40,.T.,)
OPNLCLIENT:ALIGN := CONTROL_ALIGN_ALLCLIENT 
OGRD := MSNEWGETDADOS():NEW(1,1,200,200,GD_UPDATE,,,,{"C6UDTPROD"},,LEN(_AC),"U_FAT06G('OGRDD')",,,OPNLCLIENT,_AH,_AC)
OGRD:OBROWSE:ALIGN := 5

ACTIVATE MSDIALOG ODLG ON INIT ENCHOICEBAR(ODLG,{||_NOPCA:=1, _AC:=OGRD:ACOLS, ODLG:END()},{||_NOPCA:=2, ODLG:END()}) CENTERED 

IF _NOPCA==1  

	_NPNUM	 := ASCAN(_AH,{|X|X[2]=="C6NUM"})
	_NPITEM	 := ASCAN(_AH,{|X|X[2]=="C6ITEM"})
	_NPPROD	 := ASCAN(_AH,{|X|X[2]=="C6PRODUTO"})
	_NPDTPRD := ASCAN(_AH,{|X|X[2]=="C6UDTPROD"})
	_NPQTPRD := ASCAN(_AH,{|X|X[2]=="C6UQTPROD"})
	
	_LDTPROG := .F. 
	_LDTEMPTY:= .F.
	FOR _I:=1 TO LEN(_AC)
		IF !EMPTY(_AC[_I,_NPDTPRD])
			_LDTPROG := .T.
		ELSE
			_LDTEMPTY:= .T.
		ENDIF
	NEXT _I
	IF !_LDTPROG
		MSGSTOP("NENHUMA DATA PRODUCAO NAO FOI INFORMADA")
		RETURN
	ENDIF
	
	FOR _I:=1 TO LEN(_AC)
		DBSELECTAREA("SC6")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SC6")+_AC[_I,_NPNUM]+_AC[_I,_NPITEM]+_AC[_I,_NPPROD])
		RECLOCK("SC6",.F.)
		SC6->C6_ZZUDTPR := _AC[_I,_NPDTPRD]	//SC6->C6_UDTPROD := _AC[_I,_NPDTPRD]
		MSUNLOCK()
	NEXT _I

	DBSELECTAREA("SC5")   
	RECLOCK("SC5",.F.)  
	IF SC5->C5_ZZUANA2<>"C"   		//IF SC5->C5_UANA2<>"C"   
   		IF _LDTPROG .AND. _LDTEMPTY
			SC5->C5_ZZUANA2 := "G" 	//SC5->C5_UANA2 := "G" 
  		ELSE 
  		    SC5->C5_ZZUANA2 := "P"	//SC5->C5_UANA2 := "P"
 		ENDIF     
 	ENDIF	
	
	MSUNLOCK()	
ENDIF

RETURN


USER FUNCTION FAT06E()	//REPROVAR           
**************************************
IF !SC5->C5_ZZUANA2$"NPG"	//IF !SC5->C5_UANA2$"NPG"
	MSGALERT("SOMENTE E POSSIVEL REPROVAR UM PEDIDO PENDENTE OU PROGRAMADO.")
	RETURN
ENDIF

DBSELECTAREA("SC5")   
RECLOCK("SC5",.F.)
SC5->C5_ZZUANA2 := "R"	//SC5->C5_UANA2 := "R"
MSUNLOCK()
RETURN       


STATIC FUNCTION FAT06F(PSEMELHANTE,PCAMPO,PDESCR,PLEDIT,PTAM)	//BUSCA CAMPO
*****************************************************************************
LOCAL ACMP 		:= {}
/*DBSELECTAREA("SX3")
DBSETORDER(2)
IF DBSEEK(PSEMELHANTE)                                                                                                                                  
	ACMP := { TRIM(PDESCR), PCAMPO, X3_PICTURE, IIF(PTAM>0,PTAM,X3_TAMANHO), X3_DECIMAL, ,IIF(PLEDIT,X3_USADO_EMUSO,X3_USADO_NAOALTERA), X3_TIPO}
ENDIF*/
LOCAL _aCpoSX3 	:= FwSX3Util():GetAllFields("SC6")
Local i 		:= 0

For i := 1 To Len(_aCpoSX3)

    //If(X3Uso(GetSx3Cache(_aCpoSX3[i], 'X3_USADO')) .And. AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')) $ PSEMELHANTE .OR. )
	If( AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')) $ PSEMELHANTE )
        //nUsado++

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


USER FUNCTION FAT06G(_POGRD)
***********************************  
IF _POGRD=="OGRDB"
	IF "C6UQTPROD"$READVAR()         
		_NPQTSLD := ASCAN(_AH,{|X|X[2]=="C6QTSALDO"})
		IF M->C6UQTPROD>OGRD:ACOLS[N,_NPQTSLD]
			MSGALERT("QUANTIDADE PRODUZIDA SUPERIOR AO SALDO DO PEDIDO")
			RETURN(.F.)
		ENDIF
		
		_NPDTPROD := ASCAN(_AH,{|X|X[2]=="C6UDTPROD"})
		IF M->C6UQTPROD>0 .AND.	EMPTY(OGRD:ACOLS[N,_NPDTPROD])
			MSGALERT("PRODUTO NAO FOI PROGRAMADO, FAVOR PROGRAMA-LO ANTES DE SUA PRODUCAO")
			RETURN(.F.)
		ENDIF
	ENDIF                                              
ELSEIF _POGRD=="OGRDD"
	IF "C6UDTPROD"$READVAR()
		IF M->C6UDTPROD<DATE()
			MSGALERT("DATA INVALIDA")
			RETURN(.F.)
		ENDIF                                         
	ENDIF
ENDIF
RETURN(.T.)

// SSILVA 20170103 - FUNCAO QUE ENVIA EMAIL PARA A EXPEDICAO AVISANDO DA LIBERACAO DO PEDIDO PELO PCP

Static Function MAILPCP()
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
Local cAssunto  := " O Pedido de Numero "+SC5->C5_NUM+" Foi liberado para expedicao!"
Local cPara 	:= Posicione ("ZZZ",1,xFilial("ZZZ")+"FAT000008"+"001","ZZZ_RETORN")	
Local cCC		:= ""
Local cCCo		:= ""
Local cRemet 	:= GetMv("MV_RELACNT")

aAdd(aCorpo, 'O Pedido abaixo:')
aAdd(aCorpo, '')
aAdd(aCorpo, 'Numero '+SC5->C5_NUM )
aAdd(aCorpo, '')
aAdd(aCorpo, 'Foi liberado pelo PCP e esta pronto para Expedicao! ')
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
