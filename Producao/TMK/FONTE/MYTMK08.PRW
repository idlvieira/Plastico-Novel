#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAnterior  ³TKANCRED  ºAutor  ³Fernando Amorim     º Data ³ 22/01/10    º±±
±±ºPrograma  ³MYTMK08   ºAutor  ³Sonia Silva         º Data ³ 23/11/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de analise de limite de credito e envio de email     º±±
±±ºDescricao ³Controla a liberacao e rejeicao do credito do orcamento     º±±
±±ºDescricao ³Filtra orcamentos que precisam de liberacao                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºContato   ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter e Financeiro    		                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MYTMK08() // User Function TKANCRED()

Local cFiltra 		:= ""
Local aIndexSUA		:= {}

Private aRotina 	:= {	{"Pesquisar",	"AxPesqui"	,0,1} ,;
							{"Liberar"	,	"U_LIBCRED",0,2} ,;
							{"Rejeitar",	"U_REJCRED",0,4},;
							{"Analisar",	"U_Tk271Sit",0,4},;
							{"Visualizar",	"U_TMKVISUORC",0,3},;
							{"Pos Cliente",	"U_TKCLIPOS",0,3},;
							{"Cad Cliente",	"U_TKMBSA1",0,3}}   
							
Private bFiltraBrw	:= { || NIL }

dbSelectArea("SUA")
dbSetOrder(1)

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicializa o filtro utilizando a funcao FilBrowse                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			cFiltra := ChkRh("MYTMK08","SUA","1")
		  	//cFiltra := ChkRh("TKANCRED","SUA","1")
		  	cFiltra += IF(!Empty(cFiltra),'.and. SUA->UA_ZZSTAT1 == "BLO"','SUA->UA_ZZSTAT1 == "BLO"')
			//cFiltra += IF(!Empty(cFiltra),'.and. SUA->UA_STATU1 == "BLO"','SUA->UA_STATU1 == "BLO"')
			bFiltraBrw := { || FilBrowse("SUA",@aIndexSUA,@cFiltra) }
			Eval( bFiltraBrw )
			
	  		dbGoTop()                                    
	   		mBrowse(6,1,22,75,"SUA")
			
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Deleta o filtro utilizando a funcao FilBrowse                     	 ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			EndFilBrw("SUA",aIndexSUA)

Return .T.    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³Tk271Sit    ³ Autor  ³ Fernando Amorim    ³ Data ³ 26/01/10 ³±±
±±³Função    ³Tk271Sit    ³ Revisao³ Sonia Silva        ³ Data ³ 24/11/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Rotina para consultar a Situacao Financeira do Cliente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Call Center                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Tk271Sit()

Local lTMKVSI  	:= FindFunction("U_TMKVSI")         //P.E. do Televendas

Local cCliente  := ""								//Codigo do Cliente 
Local cLoja     := ""                               //Loja do Cliente
Local cAtend    := ""								//Codigo do Atendimento		
Local cDesc     := ""								//Descricao do cliente
Local cCodCont  := ""								//Codigo do Contato
Local cOperador := "" 								//Operador
Local lRet		:= .F.								//Retorno da funcao

Local cCadastro	:= 	"Consulta Posicao Clientes"
Local aRotina	:= {	{ "Pesquisar",  "AxPesqui" , 0 , 1},;  //"Pesquisar"
						{ "Visualizar", "AxVisual", 0 , 2},;   //"Visualizar"
						{ "Consultar" , "FC010CON" , 0 , 2},;  //"Consultar"
						{ "Impressao" , "FC010IMP" , 0 , 4}}   //"Impressao"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona o SF2 porque nao esta o MNU        			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SF2")
	    
	    SA1->(DbSetOrder(1))                 // cliente
  		if SA1->(dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))   
  			
			cCliente   := SUA->UA_CLIENTE
			cLoja      := SUA->UA_LOJA
			cAtend     := SUA->UA_NUM
			cDesc      := Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE,"A1_NOME")
			cCodCont   := SUA->UA_CODCONT
			cOperador  := SUA->UA_OPERADO   
		Else
			SUS->(DbSetOrder(1))   //prospect
  			If SUS->(dbSeek(xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA))
		    	cCliente   := SUS->US_CODCLI
				cLoja      := SUA->UA_LOJA
				cAtend     := SUA->UA_NUM
				cDesc      := Posicione("SA1",1,xFilial("SA1")+SUS->US_CODCLI,"A1_NOME")
				cCodCont   := SUA->UA_CODCONT
				cOperador  := SUA->UA_OPERADO 
		
		    Endif
		Endif
		If lTMKVSI
			U_TMKVSI(cAtend,cCliente,cLoja,cDesc,cCodCont,cOperador)
			Return(.T.)
		Endif
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um cliente selecionado            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cCliente)
	Help(" ",1,"SEM CLIENT")
	Return(lRet)
Endif

DbSelectArea("SA1")
DbSetorder(1)
If DbSeek(xFilial("SA1") + cCliente + cLoja)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso o Pergunte seja confirmado executa a consulta financeira.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Pergunte("FIC010",.T.)

		Fc010Con("SA1",SA1->(Recno()),2)
		lRet := .T.
	Endif	
Endif
	
Return(lRet)     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³LIBCRED     ³ Autor   ³ Fernando Amorim   ³ Data ³ 26/01/10 ³±±
±±³Função    ³LIBCRED     ³ Revisao ³ Sonia Silva       ³ Data ³ 24/11/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Rotina para liberar o orcamento bloqueado no credito		  ³±±
±±³Descrição ³Grava a data e o usuario que fez a liberacao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Call Center                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LIBCRED()     

RecLock("SUA", .f.)
SUA->UA_ZZSTAT1 := "LIB"// SUA->UA_STATU1 := "LIB" 
SUA->UA_ZZUSLIB	:= CUSERNAME 
SUA->UA_ZZDTCRE	:= ddatabase
SUA->(MsUnLock())
U_MAILVEN()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³REJCRED     ³ Autor ³ Fernando Amorim     ³ Data ³ 26/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Rotina para liberar o orcamento.						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Call Center                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function REJCRED()     

Local cObserv	:= SUA->UA_ZZOBS3  //Local cObserv	:= SUA->UA_OBS2 
Local aButtons	:= {}
Local nOpcao	:= 1

DEFINE MSDIALOG oDlg TITLE "Descrição do Motivo da Rejeição do Orcamento" FROM 000,000 TO 200,359 OF oMainWnd PIXEL

   	@ 015, 003 TO 100, 180 OF oDlg PIXEL
//	@ C(012),C(003) Get cObserv MEMO             Size C(139),C(067) PIXEL OF oDlg

	@ C(021),C(003) Get cObserv MEMO             Size C(139),C(067) PIXEL OF oDlg
 	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcao:=1,If(!Empty(cObserv),oDlg:End(),"")},{|| (nOpcao:=2,oDlg:End())},,aButtons) CENTERED

//MSMM("UA_OBS",TamSx3("UA_OBS")[1],,cObserv,1,,,"SUA","UA_OBS")

if nOpcao == 1
	RecLock("SUA", .f.)
	SUA->UA_ZZOBS3  := cObserv	//SUA->UA_OBS2   := cObserv
	SUA->UA_ZZSTAT1 := "REJ" 	//SUA->UA_STATU1 := "REJ" 
	SUA->UA_ZZUSLIB	:= CUSERNAME 
	SUA->UA_ZZDTCRE	:= ddatabase
	
	SUA->(MsUnLock())
	
	U_MAILREJ(cObserv)
endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAILVEN   ºAutor  ³Fernando Amorim     º Data ³  22/01/10   º±±
±±ºPrograma  ³MAILVEN   ºRevisao³Sonia Silva		 º Data ³  24/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envio de e-mail para informar a liberacao do orcamento.	  º±±
±±º          ³para o operador                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MAILVEN(cObserv)

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
	Local cAssunto  := " Orçamento de numero "+SUA->UA_NUM+" está liberado para incluir o pedido" 
	//Local cPara 	:= Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_ZZEMAIL") 
	Local cPara 	:= trim(Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000006"+"001","ZZZ_RETORN")) + ";" + Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_ZZEMAIL") + ";" + Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL")
	Local cCC		:= ""
	Local cCCo		:= ""  
	Local cRemet 	:= GetMv("MV_RELACNT")

	DbSelectarea("SF2")  
		
	aAdd(aCorpo, 'O Orçamento abaixo:')
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Numero '+SUA->UA_NUM )
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Foi liberado pela análise de limite de crédito. ')
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
	EndIf
	oEmail:Desconec()    
	
Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAILREJ   ºAutor  ³Fernando Amorim     º Data ³  22/01/10   º±±
±±ºPrograma  ³MAILREJ   ºRevisao³Sonia Silva	     º Data ³  24/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envio de e-mail para informar a rejeicao do orcamento.	  º±±
±±º          ³para o operador                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MAILREJ(cObserv)

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
	Local cAssunto  := " Orçamento de numero "+SUA->UA_NUM+" foi rejeitado." 
	//Local cPara 	:=  Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_ZZEMAIL") 
	Local cPara 	:= trim(Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000006"+"001","ZZZ_RETORN")) + ";" + Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_ZZEMAIL") + ";" + Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL")
	Local cCC		:= ""
	Local cCCo		:= ""  
	Local cRemet 	:= GetMv("MV_RELACNT")
	Default cObserv := ""
   	
	DbSelectarea("SF2")  
		
	aAdd(aCorpo, 'O Orçamento abaixo:')
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Número '+SUA->UA_NUM )
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Foi rejeitado pela análise de limite de crédito. ')  
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Motivo: '+ cObserv +'')
	aAdd(aRodape, '')
	aAdd(aRodape, 'Obrigado')
	
	oHtml:= CorpoEmail():New(cTitulo, aCorpo, aRodape)	
	oHtml:GeraHtml()	
	&&Enviando E-mail	
		
	oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
	oEmail:EmailUsr()
	oEmail:Conectar()     
	
	/*oEmail:MYCLA01():New(cServidor, cConta, cPassWord, ,cAutentic, )
	oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
	oEmail:U_EmailUsr()// oEmail:EmailUsr()
	oEmail:Conectar()    
	*/
	
	If oEmail:Enviar(AllTrim(cRemet), AllTrim(cPara), AllTrim(cCC), AllTrim(cCCO), AllTrim(cAssunto), oHtml:cHtml, cAnexo)
		lRetorno	:=	.t.
		Aviso(FunDesc(),"E-mail enviado com SUCESSO.",{"OK"})
	EndIf
	oEmail:Desconec()    
Return    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMAILUSR  ºAutor  ³Fernando Amorim     º Data ³  22/01/10   º±±
±±ºPrograma  ³EMAILUSR  ºRevisao³Sonia Silva	     º Data ³  24/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Email do usuario logado na analise de credito do orcamento  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EMAILUSR()	 //Static Function EMAILUSR()
  Local aArea    := GetArea()
  Local cRet     := ""
  Local aInfUser := {}

  pswOrder(1)
  pswSeek(__cUserID,.T.)
  aInfUser := pswRet(1)
  cRet := aInfUser[ 1 , 14 ]
  RestArea(aArea)
Return cRet  

User Function TKMBSA1()
	Private cCadastro  := "Clientes" 
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))
		A030Visual("SA1", Recno(),2)
	Endif
	SA1->(dbCloseArea())	
Return

User Function TKCLIPOS()
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))
		FC010CON(1)
	Endif
	SA1->(dbCloseArea())	
Return