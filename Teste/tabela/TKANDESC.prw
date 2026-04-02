#INCLUDE "PROTHEUS.CH" 
#include "rwmake.ch"      
#include "Ap5Mail.ch" 
#include "tbiconn.ch" 
#INCLUDE "fivewin.ch"     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKANDESC  ºAutor  ³Fernando Amorim     º Data ³ 22/01/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de analise de lmite de desconto		              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºContato   ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TKANDESC() 


Local cFiltra 		:= ""
Local aIndexSUA		:= {}

Private aRotina 	:= {	{"Pesquisar",	"AxPesqui"	,0,1} ,;
							{"Liberar"	,	"U_LIBDESC",0,2} ,;
							{"Rejeitar",		"U_REJDESC",0,2},;
							{"Analisar",		"U_TMKVISUORC",0,2}} 
							
Private bFiltraBrw	:= { || NIL }


dbSelectArea("SUB")
dbSetOrder(1)

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicializa o filtro utilizando a funcao FilBrowse                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
		  	cFiltra := ChkRh("TKANCRED","SUA","1")
			cFiltra += IF(!Empty(cFiltra),'.and. SUA->UA_STATU2 == "BLO" .and. trim(cusername)==TRIM(SUA->UA_MYAPROV)','SUA->UA_STATU2 == "BLO" .and. trim(cusername)==TRIM(SUA->UA_MYAPROV)')
			
			
			bFiltraBrw := { || FilBrowse("SUA",@aIndexSUA,@cFiltra) }
			Eval( bFiltraBrw )
			
	  		dbGoTop()                                    
	   		mBrowse(6,1,22,75,"SUA")
			
					/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Deleta o filtro utilizando a funcao FilBrowse                     	 ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			EndFilBrw( "SUA" , aIndexSUA )


Return .T.    




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³LIBDESC     ³ Autor ³ Fernando Amorim     ³ Data ³ 26/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Rotina para liberar o orcamento.						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Call Center                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LIBDESC()     

RecLock("SUA", .f.)
SUA->UA_STATU2 := "LIB"
SUA->UA_MYUSLI2	:= CUSERNAME 
SUA->UA_MYDTDES	:= ddatabase
SUA->(MsUnLock())
MALIBORC("LIB")
//U_MAPRDESC()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³REJDESC     ³ Autor ³ Fernando Amorim     ³ Data ³ 26/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Rotina para liberar o orcamento.						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Call Center                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function REJDESC()     
 
Local cObserv	:= SUA->UA_OBS3 
Local aButtons	:= {}


DEFINE MSDIALOG oDlg TITLE "Descrição do motivo da Rejeição" FROM 000,000 TO 200,359 OF oMainWnd PIXEL

   	@ 015, 003 TO 100, 180 OF oDlg PIXEL
	@ C(012),C(003) Get cObserv MEMO             Size C(139),C(067) PIXEL OF oDlg
   	
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcao:=1,If(!Empty(cObserv),oDlg:End(),"")},{||(nOpcao:=2,"")},,aButtons) CENTERED

RecLock("SUA", .f.)
SUA->UA_OBS3   := cObserv
SUA->UA_STATU2 := "REJ" 
SUA->UA_MYUSLI2	:= CUSERNAME 
SUA->UA_MYDTDES	:= ddatabase
SUA->(MsUnLock())
MALIBORC("REJ")
//U_MREJDESC()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MREJDESC  ºAutor  ³Fernando Amorim     º Data ³  22/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envio de e-mail para informar a rejeicao do orcamento.	  º±±
±±º          ³para o vendendor                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 */
User Function MREJDESC()

	Local oHtml
	Local oEmail
	Local cServidor	:=	GetMv("MV_RELSERV")
	Local cConta	:=	GetMv("MV_RELACNT")
	Local cPassWord	:=	GetMv("MV_RELPSW")
	Local cAutentic	:=	GetMv("MV_RELAUTH")
	Local cOrc    := ''
	Local oOrc 
	Local cAnexo    := '' 	
	Local cTitulo 	:= ""
	Local aCorpo  	:= {}
	Local aRodape 	:= {} 
	Local cAssunto  := " Orçamento de numero "+SUA->UA_NUM+" foi rejeitado." 
	Local cPara 	:=  Space(150)
	Local oPara,oCC	 
	Local cImagem 	:= ""
	Local oImagem
	Local cCC		:= ""
	Local cCCo		:= ""  
	Local cRemet 	:= GetMv("MV_RELACNT")
	Local cDrivers	:= cDrivers		:= "Selecione o orçamento (.PDF) | *.PDF |" + "Imagem Bitmap (.BMP) | *.BMP |" + "Imagem JPEG (.JPG) | *.JPG |"
	Local aButtons	:= {}	

    cPara := getSUMail()
	
	DEFINE MSDIALOG oDlg TITLE "Orçamento - E-mail" FROM 178,181 TO 580,631 PIXEL
	// Cria as Groups do Sistema
	@ 020,002 TO 180,223 LABEL "Informe os dados para o e-mail ser enviado." PIXEL OF oDlg 
	
	
	@ 041,006 MsGet oPara Var cPara F3 "SA3" Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg
	@ 031,006 Say "Para:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg
	@ 063,006 MsGet oCC Var cCC Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg
	@ 053,006 Say "Cc:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg
	@ 075,006 Say "Orçamento de Venda" Size 086,008 COLOR CLR_BLUE PIXEL OF oDlg
	@ 085,204 Button "..." Size 014,011 When .T. PIXEL OF oDlg Action {|| cOrc:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.t.,GETF_ONLYSERVER/*GETF_LOCALHARD+GETF_NETWORKDRIVE*/)}
	@ 085,006 MsGet oOrc Var cOrc Size 197,009 COLOR CLR_BLACK When .T. Picture "@!" PIXEL OF oDlg  
	
	
	@ 097,006 Say "Solicitação de Gravação" Size 070,008 COLOR CLR_BLUE PIXEL OF oDlg
	@ 107,204 Button "..." Size 014,011 When .T. PIXEL OF oDlg Action {|| cImagem:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.t.,GETF_ONLYSERVER/*GETF_LOCALHARD+GETF_NETWORKDRIVE*/)}
	@ 107,006 MsGet oImagem Var cImagem Size 197,009 COLOR CLR_BLACK When .T. Picture "@!" PIXEL OF oDlg
	
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcao:=1,If(!Empty(cOrc) .AND. !Empty(cPara),oDlg:End(),"")},{|| (nOpcao:=2,"")},,aButtons) CENTERED
	
	DbSelectarea("SF2")  

	cAnexo	:= ""
	cAnexo 	+= 	AllTrim(cOrc)+";"
	cAnexo 	+= 	AllTrim(cImagem)+";"
		
	aAdd(aCorpo, 'O Orçamento abaixo:')
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Número '+SUA->UA_NUM )
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Foi rejeitado pela análise de Desconto. ')  
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Verifique o motivo da rejeição no campo de observação de Desconto.')
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAPRDESC  ºAutor  ³Fernando Amorim     º Data ³  22/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envio de e-mail para informar o cliente sobre a confirmacao º±±
±±º          ³do pedido.											      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MAPRDESC()

Local oHtml
Local oEmail
Local cServidor	:=	GetMv("MV_RELSERV")
Local cConta	:=	GetMv("MV_RELACNT")
Local cPassWord	:=	GetMv("MV_RELPSW")
Local cAutentic	:=	GetMv("MV_RELAUTH")
Local cOrc    := ''
Local oOrc 
local cAnexo    := ""
Local cTitulo 	:= ""
Local aCorpo  	:= {}
Local aRodape 	:= {}
Local cAssunto  := " Orçamento de Numero: " + SUA->UA_NUM
Local cPara 	:= space(150) //"fernando.amorim@qsdobrasil.com" 
Local oPara,oCC	 
Local cImagem 	:= ""
Local oImagem
Local cCC		:= space(150)
Local cCCo		:= space(150)
Local cRemet 	:= GetMv("MV_RELACNT")
Local cDrivers	:= cDrivers		:= "Selecione o orçamento (.PDF) | *.PDF |" + "Imagem Bitmap (.BMP) | *.BMP |" + "Imagem JPEG (.JPG) | *.JPG |"
Local nOpcao	:= 0
Local aButtons	:= {}

cPara := getSUMail()

DEFINE MSDIALOG oDlg TITLE "Orçamento - E-mail" FROM 178,181 TO 580,631 PIXEL
// Cria as Groups do Sistema
@ 020,002 TO 180,223 LABEL "Informe os dados para o e-mail ser enviado." PIXEL OF oDlg 


@ 041,006 MsGet oPara Var cPara Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg
@ 031,006 Say "Para:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 063,006 MsGet oCC Var cCC Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg
@ 053,006 Say "Cc:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 075,006 Say "Orçamento de Venda" Size 086,008 COLOR CLR_BLUE PIXEL OF oDlg
@ 085,204 Button "..." Size 014,011 When .T. PIXEL OF oDlg Action {|| cOrc:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.t.,GETF_ONLYSERVER/*GETF_LOCALHARD+GETF_NETWORKDRIVE*/)}
@ 085,006 MsGet oOrc Var cOrc Size 197,009 COLOR CLR_BLACK When .T. Picture "@!" PIXEL OF oDlg  


@ 097,006 Say "Imagem do Produto" Size 070,008 COLOR CLR_BLUE PIXEL OF oDlg
@ 107,204 Button "..." Size 014,011 When .T. PIXEL OF oDlg Action {|| cImagem:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.t.,GETF_ONLYSERVER/*GETF_LOCALHARD+GETF_NETWORKDRIVE*/)}
@ 107,006 MsGet oImagem Var cImagem Size 197,009 COLOR CLR_BLACK When .T. Picture "@!" PIXEL OF oDlg


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcao:=1,If(!Empty(cOrc) .AND. !Empty(cPara) ,oDlg:End(),"")},{|| (nOpcao:=2,oDlg:End())},,aButtons) CENTERED
If nOpcao == 1
	//cPara 	:= "eoliveira@myersind.com"
	DbSelectarea("SF2") 
	cAnexo	:= ""
	cAnexo 	+= 	AllTrim(cOrc)+";"
	cAnexo 	+= 	AllTrim(cImagem)+";"  
	
	aAdd(aCorpo, 'Senhor(a) Cliente,')
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Segue orçamento de número ' + SUA->UA_NUM + ' anexo para sua aprovação.' )
	aAdd(aCorpo, '')
	aAdd(aRodape, '')
	aAdd(aRodape, 'Contato:')
	aAdd(aRodape, '')
	aAdd(aRodape, '19-3847-9999')
	aAdd(aRodape, '')
	aAdd(aRodape, '')
	aAdd(aRodape, 'Obrigado,')   
	aAdd(aRodape, '')
	aAdd(aRodape, 'MYERS DO BRASIL')
	
	
	oHtml:= CorpoEmail():New(cTitulo, aCorpo, aRodape)
	oHtml:GeraHtml()
	&&Enviando E-mail
	oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
	oEmail:EmailUsr()
	oEmail:Conectar()
	If oEmail:Enviar(AllTrim(cRemet), AllTrim(cPara), AllTrim(cCC), AllTrim(cCCO), AllTrim(cAssunto), oHtml:cHtml, cAnexo)
		lRetorno	:=	.t.
		Aviso(FunDesc(),"E-mail enviado com SUCESSO.",{"OK"})
		RecLock("SUA",.F.)
		SUA->UA_ENVMAIL := "1"
		SUA->(MsUnLock())
	EndIf
	oEmail:Desconec()
	//fazer a gravacao do campo para controle do envio de email.
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKVISUORCºAutor  ³Leandro Marques     º Data ³  03/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para visualizacao do orcamento que espera retorno    º±±
±±º          ³da avaliacao de desconto                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Myers                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKVISUORC()
	
	SUA->(DbSetOrder(1))//SUA_FILIAL + SUA_NUM  
	SUA->(DbSeek(xFilial("SUA") + SUA->UA_NUM))
	TK271CallCenter("SUA",Recno(),2)
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |MALIBORC  ºAutor  ³Leandro Marques     º Data ³  03/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsal por mandar a notificacao(email) para o res-º±±
±±º          ³ponsavel pela aprovacao ou rejeicao da analise do desconto  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Myers                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MALIBORC(cPos)

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
Local cAssunto  := Iif(cPos == "LIB"," Orçamento de numero "+SUA->UA_NUM+" está liberado para incluir o pedido"," Orçamento de numero "+SUA->UA_NUM+" Foi rejeitado" )
Local cPara 	:= GetMv("MV_RESPORC") + ";" + Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_MAIL")
Local cCC		:= ""
Local cCCo		:= ""  
Local cRemet 	:= GetMv("MV_RELACNT")

//cRemet := EMAILUSR()

DbSelectarea("SF2")  

If cPos == "LIB"
	aAdd(aCorpo, 'O Orçamento abaixo:')
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Número '+SUA->UA_NUM )
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Foi liberado pela análise de desconto. ')
	aAdd(aRodape, '')
	aAdd(aRodape, 'Obrigado')
Else
	aAdd(aCorpo, 'O Orçamento abaixo:')
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Número '+SUA->UA_NUM )
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Foi Rejeitado pela análise de desconto. ')
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Favor verificar.')
	aAdd(aRodape, '')
	aAdd(aRodape, 'Obrigado')
EndIf

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

&& retorna e-mail
static function getSUMail()

	local cMail := SUA->UA_EMAIL

	if aviso("Informacao","Selecione o destinatario do e-mail.",{"Contato","Cliente"},2,funDesc()) == 1
		if !empty(SUA->UA_CODCONT)
			SU5->(dbSetOrder(1))
			SU5->(dbSeek(xFilial("SU5")+SUA->UA_CODCONT))
			cMail := SU5->U5_EMAIL
		endif
	endif

return cMail