/* Includes e Defines */
#Include "Protheus.CH"

/*/{Protheus.doc} MT094END
O ponto de entrada MT094END tras as seguintes informacoes: 
Numero do Documento,Tipo do Documento,Operacao que esta sendo executada (Aprovacao,Transferencia e/ou Superior) e
filial do documento com controle de alcadas, para serem usadas conforme necessidade do usuario. O mesmo nao possui
retorno e tem por finalidade somente mostrar as informacoes 
Eventos: Este Ponto de Entrada e executado antes da conclu
sao do tipo de operacao que esta em andamento (Liberar o
Documento,Transf. do Documento, Transf. para Superior)
Parametros
	PARAMIXB[1] Caracter Numero do Documento
	PARAMIXB[2] Caracter Tipo do documento (PC, NF, SA, IP, AE)
	PARAMIXB[3] Numerico Operacao a ser executada
				(1-Aprovar,2-Estornar,3-Aprovar pelo Superior,4-Transferir,para Superior, 5-Rejeitar, 6-Bloquear)
	PARAMIXB[4] Caracter Filial do documento
@type function
@version 12.1.33  
@author celso.costa
@since 28/04/2022
@return variant, Nil
/*/
User Function MT094END()

/* Variaveis Locais */
Local _lEnvMail		:= .F.
Local _nX				:= 00
Local _nScanPC			:= 00
Local _nScanDoc			:= 00
Local _cNomeDoc			:= ""
Local _cComprador		:= ""
Local _cAprovador		:= ""
Local _cEmail			:= ""
Local _cTimePC			:= ""
Local _cAssunto			:= ""
Local _cAttach			:= ""
Local _cMsg				:= ""
Local _cMsgAprov		:= ""
Local _aOperacoes		:= {}
Local _aAprovador		:= {}
Local _aStatusPC		:= {}
Local _aNomenclatura	:= {}
Private 	cUSRSC		:= ""

/* Status pedidos de compras */
aAdd( _aStatusPC, { "01", "Bloqueado p/ sistema(aguardando outros niveis)"	} )
aAdd( _aStatusPC, { "02", "Aguardando Liberacao do usuario"					} )
aAdd( _aStatusPC, { "03", "Pedido Liberado pelo usuario"		 			} )
aAdd( _aStatusPC, { "04", "Pedido Bloqueado pelo usuario"					} )
aAdd( _aStatusPC, { "05", "Pedido Liberado por outro usuario"				} )
aAdd( _aStatusPC, { "06", "Pedido Rejeitado"								} )

/* Define array de Operacoes */
aAdd( _aOperacoes, "Aprovado pelo usuario"		)
aAdd( _aOperacoes, "Estornado pelo usuario"		)
aAdd( _aOperacoes, "Aprovado pelo Superior"		)
aAdd( _aOperacoes, "Transferido para Superior"	)
aAdd( _aOperacoes, "Rejeitado"					)
aAdd( _aOperacoes, "Bloqueado"					)

/* Define array de nomenclaturas */
aAdd( _aNomenclatura, { "IP", "Item de pedido"				} )
aAdd( _aNomenclatura, { "PC", "Pedido de compras"			} )
aAdd( _aNomenclatura, { "SC", "Solicitação de compras"		} )
aAdd( _aNomenclatura, { "NF", "Nota Fiscal"					} )
aAdd( _aNomenclatura, { "CP", "Contrato de parceria"		} )
aAdd( _aNomenclatura, { "AE", "Autorizacao de Entrega"		} )
aAdd( _aNomenclatura, { "SA", "Solicitação Armazem"			} )
aAdd( _aNomenclatura, { "IM", "Itens medicao de Contrato"	} )
aAdd( _aNomenclatura, { "IC", "Itens do contrato"			} )
aAdd( _aNomenclatura, { "IR", "Itens da revisao"			} )
aAdd( _aNomenclatura, { "MD", "Medicao"						} )
aAdd( _aNomenclatura, { "CT", "Contrato"					} )
aAdd( _aNomenclatura, { "RV", "Revisao"						} )

/* Processamento */
If Upper( AllTrim( FunName() ) ) $ "MATA097|MATA094"

	If ParamIXB[ 03 ] > 00 .And. ParamIXB[ 03 ] <= 06 .AND. ParamIXB[ 02 ] !=  "CP"

		/* Define destinatarios do email */
		SC7->( dbSeek( xFilial( "SC7" ) + SubStr( ParamIXB[ 01 ], 01, TamSX3( "C7_NUM" )[ 01 ] ) ) )
		
		fSelCpr( @_cComprador, SC7->C7_USER )

		fMailApr( @_aAprovador, ParamIXB[ 01 ], ParamIXB[ 02 ] )
		
		For _nX := 01 To Len( _aAprovador )

			_nScanPC	:= aScan( _aStatusPC, { |x| x[ 01 ] == _aAprovador[ _nX ][ 04 ] } )
			_cAprovador	+= Iif( _aAprovador[ _nX ][ 04 ] == "02", Iif( Empty( _cAprovador ), "", ";" ) + _aAprovador[ _nX ][ 03 ], "" )
			_cMsgAprov	+= _aAprovador[ _nX ][ 01 ] + " - " + Upper( _aAprovador[ _nX ][ 02 ] ) + Iif( PARAMIXB[ 03 ] > 00, " - " + _aOperacoes[ PARAMIXB[ 03 ] ], "" ) + Chr( 13 ) + Chr( 10 )

		Next _nX


		_cEmail		:= AllTrim( _cComprador ) + Iif( !Empty( _cAprovador ), ";", "" ) + AllTrim( _cAprovador )
		_cTimePC	:= Time()

		if SC7->C7_TIPO == 1 .and. !EMPTY(ALLTRIM(SC7->C7_NUMSC))
			cUSRSC := POSICIONE("SC1",1,xFilial("SC1")+SC7->C7_NUMSC,"C1_USER")
			_cEmail	 := _cEmail + ";" + UsrRetMail(cUSRSC)
		ENDIF
		/* Atualiza hora aprovacao */
		RecLock( "SCR", .F. )
		SCR->CR_ZHORA	:= SubStr( Time(), 01, 02 ) + ":" + SubStr( Time(), 04, 02 )
		SCR->( MsUnLock() )

		/* Define assunto e mensagem do email */
		_nScanDoc	:= aScan( _aNomenclatura, { |x| AllTrim( x[ 01 ] ) == AllTrim( SCR->CR_TIPO ) } )
		_cNomeDoc	:= Iif( _nScanDoc >= 01, AllTrim( _aNomenclatura[ _nScanDoc ][ 02 ] ), "Documento" )
		_cAttach		:= __RelDir + AllTrim( SCR->CR_NUM ) + StrTran( _cTimePC, ":", "" ) + ".TXT"
		_nScanPC		:= aScan( _aStatusPC, { |x| x[ 01 ] == SCR->CR_STATUS } )
		_cAssunto	:= "Processo de Aprovacao do(a) " + _cNomeDoc + " " + AllTrim( ParamIXB[ 01 ] )
		_cMsg			:= "O(a) " + _cNomeDoc + " numero " + AllTrim( ParamIXB[ 01 ] ) + " foi " + Iif( PARAMIXB[ 03 ] > 00, AllTrim( Upper( _aOperacoes[ PARAMIXB[ 03 ] ] ) ), "" ) + " " + AllTrim( SAK->AK_USER ) + " - " + Upper( AllTrim( SAK->AK_NOME ) ) + Iif( !Empty( _cAprovador ), " (" + AllTrim( _aOperacoes[ ParamIXB[ 03 ] ] ) + ") ", " " ) + "em " + AllTrim( DtoC( dDataBase ) ) + " as " + _cTimePC + "."
		_cMsg			+= Chr( 13 ) + Chr( 10 )
		_cMsg			+= Chr( 13 ) + Chr( 10 )

		If !Empty( SCR->CR_OBS )
			_cMsg	+= "Observacoes"
			_cMsg	+= Chr( 13 ) + Chr( 10 )
			_cMsg	+= AllTrim( SCR->CR_OBS )
			_cMsg	+= Chr( 13 ) + Chr( 10 )
			_cMsg	+= Chr( 13 ) + Chr( 10 )
		EndIf
		
		If !Empty( _cMsgAprov )
			_cMsg			+= "Lista de aprovadores"
			_cMsg			+= Chr( 13 ) + Chr( 10 )
			_cMsg			+= _cMsgAprov
			_cMsg			+= Chr( 13 ) + Chr( 10 )
   		Else
			_cMsg			+= Chr( 13 ) + Chr( 10 )
			_cMsg			+= Chr( 13 ) + Chr( 10 )
		EndIf

		_cMsg	+= "** Mensagem automatica, favor nao responder este e-mail."
		/*impPO(ParamIXB[ 01 ],_cAttach)
		MsgRun( "Aguarde, atualizando status do PC/AE ...",, { || U_( SCR->CR_NUM, _cAttach ) } )

		If File( _cAttach )

			//MsgRun( "Aguarde, enviando email ...",, { || _lEnvMail := U_fPNSendMail( ,,,, _cEmail + Chr( 59 ), _cAssunto, _cMsg, _cAttach ) } )

			If _lEnvMail
				fErase( _cAttach )
			EndIf
			
		Else*/
			MsgRun( "Aguarde, enviando email ...",, { || U_fPNSendMail( ,,,, _cEmail + Chr( 59 ), _cAssunto, _cMsg ) } )
  	 	//EndIf

	ELSEIF ParamIXB[ 02 ] ==  "CP"

		/* Define destinatarios do email */
		SC3->( dbSeek( xFilial( "SC3" ) + SubStr( ParamIXB[ 01 ], 01, TamSX3( "C3_NUM" )[ 01 ] ) ) )
		
		fSelCpr( @_cComprador, SC3->C3_USER )

		fMailApr( @_aAprovador, ParamIXB[ 01 ], ParamIXB[ 02 ] )

		For _nX := 01 To Len( _aAprovador )

			_nScanPC	:= aScan( _aStatusPC, { |x| x[ 01 ] == _aAprovador[ _nX ][ 04 ] } )
			_cAprovador	+= Iif( _aAprovador[ _nX ][ 04 ] == "02", Iif( Empty( _cAprovador ), "", ";" ) + _aAprovador[ _nX ][ 03 ], "" )
			_cMsgAprov	+= _aAprovador[ _nX ][ 01 ] + " - " + Upper( _aAprovador[ _nX ][ 02 ] ) + Iif( PARAMIXB[ 03 ] > 00, " - " + _aOperacoes[ PARAMIXB[ 03 ] ], "" ) + Chr( 13 ) + Chr( 10 )

		Next _nX

		_cEmail		:= AllTrim( _cComprador ) + Iif( !Empty( _cAprovador ), ";", "" ) + AllTrim( _cAprovador )
		_cTimePC	:= Time()

		/* Atualiza hora aprovacao */
		RecLock( "SCR", .F. )
		SCR->CR_ZHORA	:= SubStr( Time(), 01, 02 ) + ":" + SubStr( Time(), 04, 02 )
		SCR->( MsUnLock() )

		/* Define assunto e mensagem do email */
		_cNomeDoc		:= "Contrato"
		_cAttach		:= __RelDir + AllTrim( SCR->CR_NUM ) + StrTran( _cTimePC, ":", "" ) + ".TXT"
		_nScanPC		:= aScan( _aStatusPC, { |x| x[ 01 ] == SCR->CR_STATUS } )
		_cAssunto		:= "Processo de Aprovacao do(a) " + _cNomeDoc + " " + AllTrim( ParamIXB[ 01 ] )
		_cMsg			:= "O contrato " + _cNomeDoc + " numero " + AllTrim( ParamIXB[ 01 ] ) + " foi " + Iif( PARAMIXB[ 03 ] > 00, AllTrim( Upper( _aOperacoes[ PARAMIXB[ 03 ] ] ) ), "" ) + " " + AllTrim( SAK->AK_USER ) + " - " + Upper( AllTrim( SAK->AK_NOME ) ) + Iif( !Empty( _cAprovador ), " (" + AllTrim( _aOperacoes[ ParamIXB[ 03 ] ] ) + ") ", " " ) + "em " + AllTrim( DtoC( dDataBase ) ) + " as " + _cTimePC + "."
		_cMsg			+= Chr( 13 ) + Chr( 10 )
		_cMsg			+= Chr( 13 ) + Chr( 10 )

		If !Empty( SCR->CR_OBS )
			_cMsg	+= "Observacoes"
			_cMsg	+= Chr( 13 ) + Chr( 10 )
			_cMsg	+= AllTrim( SCR->CR_OBS )
			_cMsg	+= Chr( 13 ) + Chr( 10 )
			_cMsg	+= Chr( 13 ) + Chr( 10 )
		EndIf
		
		If !Empty( _cMsgAprov )
			_cMsg			+= "Lista de aprovadores"
			_cMsg			+= Chr( 13 ) + Chr( 10 )
			_cMsg			+= _cMsgAprov
			_cMsg			+= Chr( 13 ) + Chr( 10 )
   		Else
			_cMsg			+= Chr( 13 ) + Chr( 10 )
			_cMsg			+= Chr( 13 ) + Chr( 10 )
		EndIf

		_cMsg	+= "** Mensagem automatica, favor nao responder este e-mail."

		//MsgRun( "Aguarde, atualizando status do PC/AE ...",, { || U_( SCR->CR_NUM, _cAttach ) } )

		/*If File( _cAttach )

			MsgRun( "Aguarde, enviando email ...",, { || _lEnvMail := U_fPNSendMail( ,,,, _cEmail + Chr( 59 ), _cAssunto, _cMsg, _cAttach ) } )

			If _lEnvMail
				fErase( _cAttach )
			EndIf
			
		Else*/
			MsgRun( "Aguarde, enviando email ...",, { || U_fPNSendMail( ,,,, _cEmail + Chr( 59 ), _cAssunto, _cMsg ) } )
  	 	//EndIf

	EndIf
	
EndIf

Return ( Nil )

/*/{Protheus.doc} fSelCpr
Retorna endereco email do comprador
@type function
@version  12.1.33
@author celso.costa
@since 28/04/2022
@param _cComprador, variant, codigo do comprador
@param _cUsuario, variant, codigo de usuario do comprador
@return variant, nulo
/*/
Static Function fSelCpr( _cComprador, _cUsuario )

/* Variaveis Locais */
Local _aArea		:= GetArea()
Local _cMailAdm	:= AllTrim( GetMV( "MV_PNAPRAD" ) )

/* Define endereco de email */
_cComprador := ""

PswOrder( 01 )

If PswSeek( AllTrim( _cUsuario ), .T. )
	_cComprador := AllTrim( Iif( Empty( PswRet( 01 )[ 01 ][ 14 ] ), _cMailAdm, AllTrim( PswRet( 01 )[ 01 ][ 14 ] ) ) )
EndIf

/* Restaura ponteiros */
RestArea( _aArea )

Return ( Nil )

/*/{Protheus.doc} fMailApr
Retorna endereco de email do aprovador do PC/AE
@type function
@version  12.1.33
@author celso.costa
@since 28/04/2022
@param _aAprovador, variant, array contendo aprovadores
@param _cPedido, variant, numero do documento
@param _cTipo, variant, tipo do documento
@return variant, nulo
/*/
Static Function fMailApr( _aAprovador, _cPedido, _cTipo )

/* Variaveis Locais */
Local _aArea		:= GetArea()
Local _aAreaSCR	:= SCR->( GetArea() )
Local _aAreaSAK	:= SAK->( GetArea() )
Local _cMailAdm	:= AllTrim( GetMV( "MV_PNAPRAD" ) )

/* Verifica email do usuario Aprovador */
dbSelectArea( "SAK" )
SAK->( dbSetOrder( 01 ) )

dbSelectArea( "SCR" )
SCR->( dbSetOrder( 01 ) )

SCR->( dbSeek( xFilial( "SCR" ) + _cTipo + SubStr( _cPedido, 01, TamSX3( "CR_NUM" )[ 01 ] ) ) )

While SCR->( !Eof() ) .And. AllTrim( SCR->CR_NUM ) == AllTrim( _cPedido ) .And. AllTrim( SCR->CR_TIPO ) == AllTrim( _cTipo )

	If SAK->( dbSeek( xFilial( "SAK" ) + SCR->CR_APROV ) )

		PswOrder( 01 )

		If PswSeek( AllTrim( SAK->AK_USER ), .T. )
			aAdd( _aAprovador, { AllTrim( SAK->AK_USER ), AllTrim( SAK->AK_NOME ), Iif( Empty( PswRet( 01 )[ 01 ][ 14 ] ), _cMailAdm, AllTrim( PswRet( 01 )[ 01 ][ 14 ] ) ), SCR->CR_STATUS } )
		EndIf
		
	EndIf
	
	SCR->( dbSkip() )
	
EndDo

/* Restaura ponteiros */
RestArea( _aAreaSCR )
RestArea( _aAreaSAK )
RestArea( _aArea )

Return ( Nil )

/*/{Protheus.doc} ImpPO
Imprime pedido de compras ou autorizacao de entrega para envio por email
@type function
@version  12.1.33
@author administrator
@since 28/04/2022
@param _cPO, variant, numero do documento
@param _cAttach, variant, nome do arquivo
@return variant, nulo
/*/
Static Function impPO( _cPO, _cAttach )

/* Variaveis Locais */
Local _aArea	:= GetArea()

/* Variaveis Publicas */
Public lPedido	:= .T.
Private cFilSC7	:= xFilial( "SC7" )
Private cFilSA2	:= xFilial("SA2")
Private cFilSA5	:= xFilial("SA5")
Private cFilSAJ	:= xFilial("SAJ")
Private cFilSB1	:= xFilial("SB1")
Private cFilSB5	:= xFilial("SB5")
Private cFilSCR	:= xFilial("SCR")
Private cFilSE4	:= xFilial("SE4")
Private cFilSM4	:= xFilial("SM4")

/* Posiciona e imprime Pedido de Compras */
dbSelectArea( "SC7" )
SC7->( dbSetOrder( 01 ) )
SC7->( dbSeek( xFilial( "SC7" ) + AllTrim( _cPO ) ) )

lPedido := .T.

MSExecAuto( { |x,y,w| MATR110R3( x, y, w ) }, "SC7", SC7->( Recno() ), "1" )
//MSExecAuto( { |x,y,w| MATR110X( x, y, w ) }, "SC7", SC7->( Recno() ), 1 )

If File( __RelDir + "MATR110.##R" ) 

	fRename( __RelDir + "MATR110.##R", _cAttach )

Else

	MsgRun( "Aguarde, atualizando status do PC/AE ...",, { || Inkey( 10 ) } )

	If File( __RelDir + "MATR110.##R" )
	
		fRename( __RelDir + "MATR110.##R", _cAttach )

	EndIf
					
EndIf
 
/* Restaura ponteiro */
RestArea( _aArea )

Return ( Nil )
