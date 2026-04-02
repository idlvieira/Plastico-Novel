//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Includes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#Include "Protheus.CH"
#Include "AP5Mail.ch"
#Include "TBIConn.CH"   
#Include "MSOLE.ch"
#Include "FILEIO.ch"

#Define _CRLF Chr( 13 ) + Chr( 10 )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fPNSendMail ³ Autor ³ Celso Costa - TI9   ³ Data ³24.02.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para o envio de emails                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Conta para conexao com servidor SMTP               ³±±
±±³          | ExpC2 : Password da conta para conexao com o servidor SMTP ³±±
±±³          ³ ExpC3 : Servidor de SMTP                                   ³±±
±±³          ³ ExpC4 : Conta de origem do e-mail. O padrao eh a mesma cont³±±
±±³          ³         de conexao com o servidor SMTP.                    ³±±
±±³          ³ ExpC5 : Conta de destino do e-mail.                        ³±±
±±³          ³ ExpC6 : Assunto do e-mail.                                 ³±±
±±³          ³ ExpC7 : Corpo da mensagem a ser enviada.               	  |±±
±±³          | ExpC8 : Patch com o arquivo que serah enviado              |±±
±±³          | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg    |±±
±±³          | ExpC10 : Parâmetro por referência, armazena o erro de envio|±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³04-04-2016³Celso Costa TI9³Desenvolvimento                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function fPNSendMail( _cAccount, _cPassword, _cServer, _cFrom, _cEmail, _cAssunto, _cMensagem, _cAttach, _lMsg, _cLog )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cEmailTo	:= ""
Local _cEmailCc	:= ""
Local _lResult		:= .F.
Local _cError		:= ""
Local _cUser
Local _nAt
//Local _cFromGe		:= GetNewPar( "MV_ACEMAIL", "" )
//Local _lRelauth	:= SuperGetMv( "MV_RELAUTH",, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Default                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Default _lMsg	:= .T.                                                                                      
Default _cLog	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se serao utilizados os valores padrao               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cAccount	:= Iif( _cAccount == Nil, GetMV( "MV_RELACNT" ), _cAccount  )
_cPassword	:= Iif( _cPassword == Nil, GetMV( "MV_RELAPSW" ), _cPassword )
_cServer		:= Iif( _cServer == Nil, GetMV( "MV_RELSERV" ), _cServer )
_cAttach		:= Iif( _cAttach == Nil, "", _cAttach )
_cFrom		:= Iif( _cFrom == Nil, Iif( Empty( GetMV( "MV_RELFROM" ) ), GetMV( "MV_RELACNT" ), GetMV( "MV_RELFROM" ) ), _cFrom )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cEmailTo	:= SubStr( _cEmail, 01, At( Chr( 59 ), _cEmail ) - 01 )
_cEmailCc	:= SubStr( _cEmail, At( Chr( 59 ), _cEmail ) + 01, Len( _cEmail ) )

CONNECT SMTP SERVER _cServer ACCOUNT _cAccount PASSWORD _cPassword RESULT _lResult

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Servidor de EMAIL necessita de Autenticacao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lResult .And. GetMv( "MV_RELAUTH" )
	
	//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	_lResult := MailAuth( _cAccount, _cPassword )
	
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	If !_lResult
		_nAt		:= At( "@", _cAccount )
		_cUser	:= If( _nAt > 00, SubStr( _cAccount, 01, _nAt - 01 ), _cAccount )
		_lResult	:= MailAuth( _cUser, _cPassword )
	EndIf
	
EndIf

If _lResult

	SEND MAIL FROM _cFrom	;
	TO      	_cEmailTo		;
	CC   		_cEmailCc		;
	SUBJECT 	_cAssunto		;
	BODY    	_cMensagem		;
	ATTACHMENT  _cAttach		;
	RESULT _lResult

	If !_lResult

		//Erro no envio do email
		GET MAIL ERROR _cError

		If _lMsg
			Help( " ", 01, "ATENCAO",, "Erro no envio do email " + _cEmailTo + " .", 04, 05 )
		EndIf

		_cLog := "Erro no envio do email " + _cEmailTo 	

	EndIf
	
	DISCONNECT SMTP SERVER
	
Else

	//Erro na conexao com o SMTP Server
	GET MAIL ERROR _cError

	If _lMsg		
		Help( " ", 01, "ATENCAO",, "Erro na conexao com SMTP Server " + _cError, 04, 05 )
	EndIf

	_cLog := "Erro na conexao com SMTP Server " + _cError	

EndIf

Return( _lResult )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fACTxt2Htm  ³ Autor ³ Celso Costa - TI9   ³ Data ³24.02.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Transforma texto acentuado em HTML                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Texto                                              ³±±
±±³          | ExpC2 : eMail                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³02-12-2019³Celso Costa TI9³Desenvolvimento                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fACTxt2Htm( _cText, _cEmail )

// ::: CRASE
// aA (acento crase)
_cText := StrTran( _cText, CHR( 224 ), "&agrave;" )
_cText := StrTran( _cText, CHR( 192 ), "&Agrave;" )

// ::: ACENTO CIRCUNFLEXO
// aA (acento circunflexo)
_cText := StrTran( _cText, CHR( 226 ), "&acirc;" )
_cText := StrTran( _cText, CHR( 194 ), "&Acirc;" )

// eE (acento circunflexo)
_cText := StrTran( _cText, CHR( 234 ), "&ecirc;" )
_cText := StrTran( _cText, CHR( 202 ), "&Ecirc;" )

// oO (acento circunflexo)
_cText := StrTran( _cText, CHR( 244 ), "&ocirc;" )
_cText := StrTran( _cText, CHR( 212 ), "&Ocirc;" )

// ::: TIL
// aA (til)
_cText := StrTran( _cText, CHR( 227 ), "&atilde;" )
_cText := StrTran( _cText, CHR( 195 ), "&Atilde;" )

// oO (til)
_cText := StrTran( _cText, CHR( 245 ), "&otilde;" )
_cText := StrTran( _cText, CHR( 213 ), "&Otilde;" )

// ::: CEDILHA
_cText := StrTran( _cText, CHR( 231 ), "&ccedil;" )
_cText := StrTran( _cText, CHR( 199 ), "&Ccedil;" )

// ::: ACENTO AGUDO
// aA (acento agudo)
_cText := StrTran( _cText, CHR( 225 ), "&aacute;" )
_cText := StrTran( _cText, CHR( 193 ), "&Aacute;" )

// eE (acento agudo)
_cText := StrTran( _cText, CHR( 233 ), "&eacute;" )
_cText := StrTran( _cText, CHR( 201 ), "&Eacute;" )

// iI (acento agudo)
_cText := StrTran( _cText, CHR( 237 ), "&iacute;" )
_cText := StrTran( _cText, CHR( 205 ), "&Iacute;" )

// oO (acento agudo)
_cText := StrTran( _cText, CHR( 243 ), "&oacute;" )
_cText := StrTran( _cText, CHR( 211 ), "&Oacute;" )

// uU (acento agudo)
_cText := StrTran( _cText, CHR( 250 ), "&uacute;" )
_cText := StrTran( _cText, CHR( 218 ), "&Uacute;" )

// ::: ENTER
_cText := StrTran( _cText, CHR( 13 ) + CHR( 10 ), "<br>" )
_cText := StrTran( _cText, CHR( 13 ), "<br>" )
_cText := StrTran( _cText, CHR( 10 ), "<br>" )

Return _cText

