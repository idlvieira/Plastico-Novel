#include "protheus.ch"
#include "ap5mail.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ConEmail บAutor  ณ Fabricio M Vieira  บ Data ณ  17/03/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classe para envio do email.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Originalmente desenvolvida por Mario F.Silveira [Microsiga]บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Class ConEmail
	Data cServer
	Data cCtConec
	Data cSenha
	Data lConect
	Data lAutenti
	Data cEmailUsr
	Data cCodUser
	Data cAnexo		//	Arquivos deve na pasta RootPath ou em suas subpastas. No envio de 2 ou mais arquivos, utilizar ponto-e-virgula
					//	como separador.
	Data cCodVend	as String
	Data cEmailVend	as String
  
	Method New(cServer, cCtConec , cSenha , lConect , lAutenti, cAnexo) Constructor
	Method Conectar()
	Method Enviar(cRemeten, cDestina, cCC, cCCO, cAssunto, cTexto, cAnexo)
	Method EnviarMail(cRemeten, cDestina, cCC, cCCO, cAssunto, cTexto, cAnexo)
	Method Desconec()     
	Method EmailUsr()
	Method EmailVend()
	Method UserID(cUsuario)

EndClass

Method New(cServer, cCtConec , cSenha , lConect , lAutenti, cAnexo) Class ConEmail
	Local aArea1 := GetArea()
	Default cServer  := ""
	Default cCtConec := ""
	Default cSenha   := ""
	Default lConect  := .F.
	Default lAutenti := GetMv("MV_RELAUTH",,.F.)   
	Default cAnexo   := ""
  
	::cEmailUsr	:=	""
	::cCodUser	:=	RetCodUsr()
	::cCodVend	:=	""
	::cEmailVend:=	""
	
	::cServer	:= cServer
	::cCtConec	:= cCtConec
	::cSenha	:= cSenha
	::lConect	:= lConect
	::lAutenti	:= lAutenti
	::cAnexo	:= cAnexo

	RestArea(aArea1)
Return

Method Conectar() Class ConEmail
	Local aArea2 := GetArea()
	Local lRet
  
	CONNECT SMTP SERVER ::cServer ACCOUNT ::cCtConec PASSWORD ::cSenha RESULT lRet
	If lRet
		::lConect := .T.
	Else
		::lConect := .F.
		Alert("Erro ao conectar do servidor de email.")
		ConOut("Erro ao conectar do servidor de email.")
	EndIf
	
	RestArea(aArea2)
	
Return lRet

Method EnviarMail(cRemeten , cDestina, cCC, cCCO, cAssunto , cTexto, cAnexo) Class ConEmail
	Local aArea3 := GetArea()
	Local lRet
	Local cErroEm := ""
	Local lAuten  := .T.
	
	Default cRemeten := ""
	Default cDestina := ""
	Default cAssunto := ""
	Default cTexto   := ""
	Default cCC      := ""
	Default cCCO	 := ""
	Default cAnexo   := ::cAnexo

	cDestina := allTrim(cDestina) + ";" + allTrim(getMv("MV_WFMAILT"))

	If ::lConect
		If ::lAutenti
			lAuten := MailAuth( ::cCtConec , ::cSenha )
		EndIf	
		If lAuten 
			SEND MAIL FROM cRemeten TO cDestina CC cCC BCC cCCO SUBJECT cAssunto BODY cTexto ATTACHMENT cAnexo RESULT lRet
			ConOut('ENVIO DE E-MAIL')
			ConOut('Assunto: '+cAssunto)
			ConOut('De: '+cRemeten)
			ConOut('Para: '+cDestina)
			ConOut('CC: '+cCC)
			ConOut('CCO: '+cCCO)
			If !(lRet)
				GET MAIL ERROR cErroEm
				Alert("Erro no envio do email. Erro "+ cErroEm )
				ConOut("Erro no envio do email. Erro "+ cErroEm)
			EndIf
		Else
			Alert("Erro na autentica็ao do email.")
			ConOut("Erro na autentica็ao do email.")
		EndIf
	Else
		Alert("Servidor nao contectado.")
		ConOut("Servidor nao contectado.")
		lRet := .F.
	EndIf
	
	RestArea(aArea3)
	
Return lRet

Method Enviar(cRemeten , cDestina, cCC, cCCO, cAssunto , cTexto, cAnexo) Class ConEmail
	Local lRet := .f.
	
	MSAguarde( {|| lRet := ::EnviarMail(cRemeten , cDestina, cCC, cCCO, cAssunto , cTexto, cAnexo) }, FunDesc(),"Enviando e-mail... Aguarde.",.f.)
	
Return lRet

Method Desconec() Class ConEmail
	Local aArea4 := GetArea()
	Local lRet
  
	If ::lConect
		DISCONNECT SMTP SERVER RESULT lRet
		If !(lRet)
			Alert("Erro ao desconectar do servidor de email.")
			ConOut("Erro ao desconectar do servidor de email.")
		EndIf
	Else
		Alert("Servidor nao contectado.")
		ConOut("Servidor nao contectado.")
		lRet := .F.
	EndIf
	
	RestArea(aArea4)
	
Return lRet                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ EmailUsr   บ Autor ณ Fabricio M Vieira บ Data ณ 17/03/2007 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Metodo utilizado para localizar o email do usuario do      บฑฑ
ฑฑบ          ณ Protheus, atraves do ID do usuario.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method EmailUsr() Class ConEmail
	Local aDadUser	:= {}

	PswOrder(1)
	If PswSeek(::cCodUser, .T.)

		aDadUser	:= PswRet(1)
		::cEmailUsr	:= aDadUser[1, 14]				// E-mail do Usuario Solicitado.
	EndIf
	
	If Empty(::cEmailUsr)
		::cEmailUsr	:=	GetMv("MV_RELFROM")
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ EmailVend  บ Autor ณ Fabricio M Vieira บ Data ณ 18/03/2007 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Metodo utilizado para localizar o email de um Vendedor     บฑฑ
ฑฑบ          ณ Protheus, atraves do codigo.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method EmailVend() Class ConEmail
	Local	aAlias		:=			GetArea()
	Local	aAliasSA3	:=	SA3->(	GetArea())

	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3")+::cCodVend))
	
	If SA3->(Found())
		::cEmailVend	:=	SA3->A3_EMAIL
	EndIf

	RestArea(aAliasSA3)
	RestArea(aAlias)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ UserID     บ Autor ณ Fabricio M Vieira บ Data ณ 18/03/2007 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Metodo para retornar o codigo do usuario com base em seu   บฑฑ
ฑฑบ          ณ nome.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method UserID(cUsuario) Class ConEmail
//	Local cUserID
	Local nOrder := 2 // pesquisar pelo nome do usuแrio
	
	PswOrder(nOrder)
	If PswSeek( cUsuario, .T. )
	    ::cCodUser := PswID()
	EndIf
	
Return
