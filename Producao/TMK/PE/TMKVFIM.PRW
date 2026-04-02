//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Includes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#Include "Protheus.ch"
#Include "AP5Mail.ch"   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMKVFIM    ³ Autor ³ Myers Industries    ³ Data ³18.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada executado na confirmacao do Atendimento no³±±
±±³          ³ Televendas para gravacao de Campos nas Tabelas SC5 e SC6.  ³±±
±±³          ³ Uso do departamento Comercial.                             ³±±
±±³          ³ Controle da Alcada de Descontos e Geracao de PV            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³11.07.2018³ Leonardo B    ³ Chamado 29-G7D-1Z4-VAJJ - Bloco desativado ³±±
±±³          ³               ³ pois foi tratado validacao no PE TKEVALI   ³±±
±±³30.10.2018³ Leonardo B    ³ Correcao da sintaxe M->UA_OPER para        ³±±
±±³          ³               ³ SUA->UA_OPER                               ³±±
±±³08.08.2021³Celso Costa TI9³ Revisao                                    ³±±
±±³08.08.2021³Celso Costa TI9³ Insercao da tratativa do campo C5_ZZCIFOB  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TMKVFIM( _cNumAT, _cNumPV )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cQuery		:= GetNextAlias()
Local _aArea  		:= GetArea()
Local _aAreaSUA	:= SUA->( GetArea() )
Local _aAreaSUS	:= SUS->( GetArea() )
Local _aAreaSUB	:= SUB->( GetArea() )
Local _aAreaSC5	:= SC5->( GetArea() )
Local _aAreaSC6	:= SC6->( GetArea() )
Local _nDesconto	:= 00
Local _nNivel		:= 00
//Local _nItem		:= aScan( aHeader, { |x| AllTrim( x[ 02 ] ) == "UB_ITEM" } )
//Local _nProd		:= aScan( aHeader, { |x| AllTrim( x[ 02 ] ) == "UB_PRODUTO" } )
//Local _nDescr		:= aScan( aHeader, { |x| AllTrim( x[ 02 ] ) == "UB_DESCRI" } )
//Local _nQtd			:= aScan( aHeader, { |x| AllTrim( x[ 02 ] ) == "UB_QUANT" } )
//Local _nVrUnit		:= aScan( aHeader, { |x| AllTrim( x[ 02 ] ) == "UB_VRUNIT" } )
//Local _nVlrItm		:= aScan( aHeader, { |x| AllTrim( x[ 02 ] ) == "UB_VLRITEM" } )
//Local _nDsc			:= aScan( aHeader, { |x| AllTrim( x[ 02 ] ) == "UB_DESC" } )
//Local _nValDesc	:= aScan( aHeader, { |x| AllTrim( x[ 02 ] ) == "UB_VALDESC" } )
Local _nDscOrc1	:= U_MYCFG02( "TMK000001", "001", "P",, "N" )
Local _nDscOrc2	:= U_MYCFG02( "TMK000001", "002", "P",, "N" )
//Local _lProd		:= .F.
Local _cAprovador	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Includes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _nCom		:= 01
Private _nRevise	:= 00
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamentos                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If INCLUI .or. ALTERA

	If ALTERA
		GrvDtAltera()
	EndIf

	If AllTrim( SUA->UA_OPER ) == "1"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faturamento                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "SA1" )
		SA1->( dbSetOrder( 01 ) )
		
		dbSelectArea( "SC6" )
		SC6->( dbSetOrder( 01 ) )

		dbSelectArea( "SC5" )
		SC5->( dbSetOrder( 01 ) )

		If SC5->( dbSeek( xFilial( "SC5" ) + _cNumPV ) )

			If SA1->( dbSeek( xFilial( "SA1" ) + SUA->UA_CLIENTE + SUA->UA_LOJA ) )

				RecLock( "SC5", .F. )
				SC5->C5_CLIENT	:= SUA->UA_ZZCLENT
				SC5->C5_LOJAENT	:= SUA->UA_ZZLJENT
				SC5->C5_FRETE	:= SUA->UA_FRETE
				SC5->C5_MENNOTA	:= SUA->UA_ZZOBS1
				SC5->C5_ZZOBS2	:= SUA->UA_ZZOBS2
				SC5->C5_ZZREVIS	:= SUA->UA_ZZREVIS
				SC5->C5_ZZENTPA	:= SUA->UA_ZZENTPA
				SC5->C5_ZZTEMGR	:= SUA->UA_ZZTEMGR
				SC5->C5_MOEDA	:= SUA->UA_MOEDA
				SC5->C5_ZZCIFOB	:= SUA->UA_ZZCIFOB
				SC5->C5_ZHORA	:= SubStr( Time(), 01, 05 )
				SC5->C5_ZZUANA1	:= "N"
				SC5->C5_ZZUANA2	:= "N"
				SC5->C5_ZZUANA3	:= ""
				SC5->( MsUnLock() )
			
				BeginSQL Alias _cQuery
					Select 
						SUB.UB_NUMPV,
						SUB.UB_ITEMPV,
						SUB.UB_LOCAL,
						SUB.UB_NUMPCOM,
						SUB.UB_ITEMPC,
						SUB.UB_ZZDATEN,
						SUB.UB_ZZENTPA,
						SUB.UB_ZZTGRAV,
						SUB.UB_VRUNIT,
						SUB.UB_ZZDEFIS
					From
						%Table:SUB% SUB                        
					Where SUB.UB_NUM = %Exp:AllTrim( _cNumAT )%
						And SUB.UB_FILIAL = %xFilial:SUB%
						And SUB.%NotDel%
				EndSQL
				
				While ( _cQuery )->( !Eof() )

					If SC6->( dbSeek( xFilial( "SC6" ) + ( _cQuery )->UB_NUMPV + ( _cQuery )->UB_ITEMPV ) )

						RecLock( "SC6", .F. )
						SC6->C6_ZZDATEN	:= StoD( ( _cQuery )->UB_ZZDATEN )
						SC6->C6_LOCAL		:= ( _cQuery )->UB_LOCAL
						SC6->C6_ZZENTPA	:= ( _cQuery )->UB_ZZENTPA
						SC6->C6_ZZTGRAV	:= ( _cQuery )->UB_ZZTGRAV
						SC6->C6_NUMPCOM	:= ( _cQuery )->UB_NUMPCOM
						SC6->C6_ITEMPC		:= ( _cQuery )->UB_ITEMPC
						SC6->C6_ZZUQTPR	:= 00
						SC6->C6_ZZUANA2	:= ""

						// Verifica se o Desconto e Fiscal ou Comercial  /Validacao em Vigor a partir de abril/2016
						If AllTrim( ( _cQuery )->UB_ZZDEFIS ) != "1"			

							SC6->C6_DESCONT	:= 00
							SC6->C6_VALDESC	:= 00
							SC6->C6_PRUNIT		:= ( _cQuery )->UB_VRUNIT

						EndIf

						SC6->( MsUnLock() )

					EndIf

					( _cQuery )->( dbSkip() )

				EndDo

				( _cQuery )->( dbCloseArea() )
			
				MsgInfo( "Pedido de Vendas Numero " + AllTrim( _cNumPV ) + " gerado com sucesso.", "TMKFIM" )

				RecLock( "SUA", .F. )
				SUA->UA_ZZSTAT1 := "LIB"
				SUA->( MsUnLock() )

				U_MYTMK02()	// Imprime pedido de vendas em modo grafico

			EndIf

		EndIf

	ElseIf AllTrim( M->UA_OPER ) == "2"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Orcamento                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If INCLUI
			_nNivel	:= 00
			U_MYTMK21( "O", "B", "I", cUserName, _nNivel )	// Grava aprovador desconto no arquivo dde Log
		EndIf

		_nRevise	:= SUA->UA_ZZREVIS

		aDadCab	:= {}

		If lMudou

			MsgAlert( "Esse Orcamento nao gerou pedido e foi para analise de limite de credito", "TMKVFIM" )

			RecLock( "SUA", .F. )
			SUA->UA_ZZSTAT1 := "BLO"
			SUA->( MsUnLock() )

			U_MailPed()	// e-mail para informar o bloqueio do orcamento
			
			lMudou := .F.

		EndIf

		SA1->( dbSetOrder( 01 ) )
		If SA1->( !dbSeek( xFilial( "SA1" ) + SUA->UA_CLIENTE + SUA->UA_LOJA ) )

			SUS->( dbSetOrder( 01 ) )

			If SUS->( dbSeek( xFilial( "SUS" ) + SUA->UA_CLIENTE + SUA->UA_LOJA ) )

				If Empty( SUS->US_CODCLI )

					If MsgYesNo( "Deseja enviar email para o vendedor solicitando a documentacao para cadastrar o cliente? " )
						U_mailPro()	// e-mail para informar o vendedor sobre a documentacao
					EndIf

				EndIf

			EndIf

		EndIf

		// Validacao MicroEmpresa Bahia
		If AllTrim( SA1->A1_ZZME ) == "S" .And. AllTrim( SA1->A1_EST ) == "BA" .And. Empty( SUA->UA_ZZSTAT2 ) .AND. AllTrim( SA1->A1_ZGRPNV ) != '1'
			lBloq = .T.
			lMudou =.F.
		EndIf

		If lBloq .And. !lMudou

			SUB->( dbSetOrder( 01 ) )
			SUB->( dbSeek( xFilial( "SUB" ) + SUA->UA_NUM ) )

			_nDesconto := 00

			While SUB->( !Eof() ) .And. SUB->UB_FILIAL + SUB->UB_NUM == xFilial( "SUB" ) + SUA->UA_NUM

				// Validacao Microempresa Bahia - 18/10/2013 - analise de desconto
				If AllTrim( SA1->A1_ZZME ) == "S" .And. AllTrim( SA1->A1_EST ) == "BA"
					_nDesconto	:= SUB->UB_ZZDESCM
				Else
					
					If _nDscOrc1 < SUB->UB_DESC
						_nDesconto := SUB->UB_DESC
						Exit
					EndIf

				EndIf

				SUB->( dbSkip() )

			EndDo

			If _nDesconto > _nDscOrc1 .And. _nDesconto < _nDscOrc2
				
				_nNivel		:= 01
				_cAprovador	:= U_MYTMK05( SUA->UA_NUM, _nNivel )

				RecLock( "SUA", .F. )
				SUA->UA_ZZSTAT2	:= "BLO"
				SUA->UA_ZZAPROV	:= AllTrim( Upper( _cAprovador ) )
				SUA->UA_ZZNIVEL	:= 00
				SUA->( MsUnLock() )

				U_MYTMK04()	// Grava margem no Orcamento

				_nNivel	:= 00
				U_MYTMK21( "D", "B", "A", cUserName, _nNivel )	// Grava aprovador do desconto arquivo de LOG
			
				MsgAlert( "Esse Orcamento foi encaminhado para Analise de Desconto", "TMKVFIM" )
	
				U_fNotPrxAp( _cAprovador )

			Else

				// Validacao Microempresa Bahia
				If AllTrim( SA1->A1_ZZME ) == "S" .And. AllTrim( SA1->A1_EST ) == "BA" .And. _nDesconto < _nDscOrc1 .AND. AllTrim( SA1->A1_ZGRPNV ) != '1'  

					RecLock( "SUA", .F. )
					SUA->UA_ZZSTAT2	:= "LIB"
					SUA->UA_ZZSTAT1	:= "BLO"
					SUA->( MsUnLock() )

					MsgAlert( "Orcamento nao gerou Analise de Desconto, verificar.", "TMKVFIM" )

				Else
					_nNivel		:= 01
					_cAprovador	:= U_MYTMK05( SUA->UA_NUM, _nNivel )
		
					RecLock( "SUA", .F. )
					SUA->UA_ZZSTAT2	:= "BLO"
					SUA->UA_ZZAPROV	:= AllTrim( Upper( _cAprovador ) )
					SUA->UA_ZZNIVEL	:= 00
					SUA->( MsUnLock() )

					U_MYTMK04()	// Grava margem no Orcamento

					U_MYTMK05()	// Grava o aprovador no Orcamento

					_nNivel	:= 00
					U_MYTMK21( "D", "B", "A", cUserName, _nNivel )	// Grava aprovador desconto no arquivo LOG
		
					MsgAlert( "Esse Orcamento foi encaminhado para Analise de Desconto.", "TMKVFIM" )
	
					U_fNotPrxAp( _cAprovador )
	
				EndIf
				
			EndIf

		EndIf

	EndIf

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia e-mail para tesouraria quando utilizada condicao de    ³
//³ pagamento especifica                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim( SUA->UA_CONDPG ) $ Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "TMK000001" + "005", "ZZZ_RETORN" )
	MyCondPag()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura ponteiros                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea( _aAreaSC6 )
RestArea( _aAreaSC5 )
RestArea( _aAreaSUB )
RestArea( _aAreaSUS )
RestArea( _aAreaSUA )
RestArea( _aArea )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MailPro    ³ Autor ³ Myers Industries    ³ Data ³18.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envio de e-mail para informar o vendedor sobre a documen   ³±±
±±³          ³ tacao que deve ser enviada para o cadastro do cliente.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08.08.2021³Celso Costa TI9³ Revisao                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MailPro()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oHtml
Local oEmail
Local _cCC			:= ""
Local _cCCo			:= ""
Local _cBody		:= ""
Local _cAnexo		:= ""
Local _cTitulo		:= ""
Local _cAssunto	:= " Documentacao para cadastro do cliente"
Local _cPara		:= Posicione( "SA3", 01, xFilial( "SA3" ) + SUA->UA_VEND, "A3_EMAIL" )
Local _aCorpo		:= {}
Local _aRodape		:= {}
Local _cServidor	:=	GetMv( "MV_RELSERV" )
Local _cConta		:=	GetMv( "MV_RELACNT" )
Local _cPassWord	:=	GetMv( "MV_RELPSW" )
Local _cAutentic	:=	GetMv( "MV_RELAUTH" )
Local _cRemet		:= GetMv( "MV_RELACNT" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Emvia e-mail                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( _cPara )
	MsgAlert( "O campo de email no cadastro do vendedor esta em branco", "TMKVFIM" )
EndIf

dbSelectarea( "SF2" )

SUS->( dbSetOrder( 01 ) )
SUS->( dbSeek( xFilial( "SUS" ) + SUA->UA_CLIENTE + SUA->UA_LOJA ) )

aAdd( _aCorpo, "Senhor(a) Vendedor(a)" )
aAdd( _aCorpo, "" )
aAdd( _aCorpo, "Favor enviar a Documentacao do prospect " + SUS->US_NOME )
aAdd( _aCorpo, "" )
aAdd( _aCorpo, "para efetivar o prospect em cliente. " )

aAdd( _aRodape, "" )
aAdd( _aRodape, "Obrigado" )

oHtml := CorpoEmail():new( _cTitulo, _aCorpo, _aRodape )
oHtml:GeraHtml()

_cBody := oHtml:cHtml

U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, AllTrim( _cPara ) + Chr( 59 ), _cAssunto, _cBody, /*Attatch*/, /*lResultSend*/, /*_cLog*/ )

/*
oEmail := ConEmail():New( _cServidor, _cConta, _cPassWord,, _cAutentic, )
oEmail:EmailUsr()
oEmail:Conectar()

If oEmail:Enviar( AllTrim( _cRemet ), AllTrim( _cPara ), AllTrim( _cCC ), AllTrim( _cCCO ), AllTrim( _cAssunto ), oHtml:cHtml, _cAnexo )
	lRetorno := .T.
	Aviso( FunDesc(), "E-mail enviado com SUCESSO.", { "OK" } )
EndIf

oEmail:Desconec()
*/

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MailPed    ³ Autor ³ Myers Industries    ³ Data ³18.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envio de e-mail para informar o bloqueio do orcamento      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08.08.2021³Celso Costa TI9³ Revisao                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MailPed()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oHtml
Local oEmail
Local _cAnexo		:= ""
Local _cTitulo		:= ""
Local _cCC			:= ""
Local _cCCo			:= ""
Local _cBody		:= ""
Local _cPara		:= Posicione ( "ZZZ", 01, xFilial( "ZZZ" ) + "TMK000001" + "006", "ZZZ_RETORN" )
Local _cAssunto	:= " Orcamento de numero " + AllTrim( SUA->UA_NUM ) + " impedido de gerar o PV para analise de limite de credito"
Local _aCorpo		:= {}
Local _aRodape		:= {}
Local _cServidor	:= GetMv( "MV_RELSERV" )
Local _cConta		:= GetMv( "MV_RELACNT" )
Local _cPassWord	:= GetMv( "MV_RELPSW" )
Local _cAutentic	:= GetMv( "MV_RELAUTH" )
Local _cRemet		:= GetMv( "MV_RELACNT" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Emvia e-mail                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectarea( "SF2" )

aAdd( _aCorpo, "O Orcamento abaixo:" )
aAdd( _aCorpo, "" )
aAdd( _aCorpo, "Numero " + AllTrim( SUA->UA_NUM ) )
aAdd( _aCorpo, "" )
aAdd( _aCorpo, "Precisa da liberacao da analise de limite de credito. " )

aAdd( _aRodape, "" )
aAdd( _aRodape, "Obrigado" )

oHtml := CorpoEmail():New( _cTitulo, _aCorpo, _aRodape )
oHtml:GeraHtml()

_cBody := oHtml:cHtml

U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, AllTrim( _cPara ) + Chr( 59 ), _cAssunto, _cBody, /*Attatch*/, /*lResultSend*/, /*_cLog*/ )

/*
oEmail := ConEmail():New( _cServidor, _cConta, _cPassWord,, _cAutentic, )
oEmail:EmailUsr()
oEmail:Conectar()

If oEmail:Enviar( AllTrim( _cRemet ), AllTrim( _cPara ), AllTrim( _cCC ), AllTrim( _cCCO ), AllTrim( _cAssunto ), oHtml:cHtml, _cAnexo )
	lRetorno := .T.
	Aviso( FunDesc(), "E-mail enviado com SUCESSO.", { "OK" } )
EndIf

oEmail:Desconec()
*/

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GrvCabItm  ³ Autor ³ Myers Industries    ³ Data ³18.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava historico dos orcamentos                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08.08.2021³Celso Costa TI9³ Revisao                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GrvCabItm( _nNum, _nItem, _nProd, _nDescr, _nQtd, _nVrUnit, _nVlrItm, _nDsc, _nValDesc, _lProd )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nL	:= 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transacao                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Begin Transaction

	If _nCom == 01

		_nRevise += 01

		RecLock( "SUA", .F. )
		SUA->UA_ZZREVIS	:= _nRevise
		SUA->( MsUnLock() )

		_nCom += 01

	EndIf

	For _nL := 01 To 02
		
		RecLock( "ZZY", .T. )
		ZZY->ZZY_MYFILI	:= xFilial( "ZZY" )
		ZZY->ZZY_MYREVI	:= AllTrim( Str( _nRevise ) )
		ZZY->ZZY_MYORCA	:= M->UA_NUM
		ZZY->ZZY_MYCODC	:= Iif( _nL == 01, _aDadCab[ 01][ 02 ], M->UA_CLIENTE )
		ZZY->ZZY_MYLOJA	:= Iif( _nL == 01, _aDadCab[ 01][ 03 ], M->UA_LOJA )
		ZZY->ZZY_MYDESC	:= Iif( _nL == 01, _aDadCab[ 01][ 04 ], M->UA_NOME )
		ZZY->ZZY_MYTPFR	:= Iif( _nL == 01, _aDadCab[ 01][ 05 ], M->UA_TPFRETE )
		ZZY->ZZY_MYTEMG	:= Iif( _nL == 01, _aDadCab[ 01][ 06 ], M->UA_ZZTEMGR )
		ZZY->ZZY_MYENTP	:= Iif( _nL == 01, _aDadCab[ 01][ 07 ], M->UA_ZZENTPA )
		ZZY->ZZY_MYITEM	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 01 ], aCols[ _nNum ][ _nItem ] )
		ZZY->ZZY_MYPROD	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 02 ], aCols[ _nNum ][  _nProd ] )
		ZZY->ZZY_MYDESP	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 03 ], aCols[ _nNum ][ _nDescr ] )
		ZZY->ZZY_MYQTD		:= Iif( _nL == 01, _aDadItem[ _nNum ][ 04 ], aCols[ _nNum ][ _nQtd ] )
		ZZY->ZZY_MYVRUN	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 05 ], aCols[ _nNum ][ _nVrUnit ] )
		ZZY->ZZY_MYVLIT	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 06 ], aCols[ _nNum ][ _nVlrItm ] )
		ZZY->ZZY_MYDSC		:= Iif( _nL == 01, _aDadItem[ _nNum ][ 07 ], aCols[ _nNum ][ _nDsc ] )
		ZZY->ZZY_MYVLDE	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 08 ], aCols[ _nNum ][ _nValDesc ] )
		ZZY->ZZY_MYDATA	:= _aDadCab[ 01 ][ 08 ]
		ZZY->ZZY_MYHORA	:= _aDadCab[ 01 ][ 09 ]
		ZZY->ZZY_MYUSER	:= _aDadCab[ 01 ][ 10 ]
		ZZY->ZZY_MYFLAG	:= Iif( _nL == 01, "A", "D" )
		ZZY->ZZY_MYUSNA	:= _aDadCab[ 01 ][ 11 ]
		ZZY->ZZY_MYNEWP	:= Iif( _aDadItem[ _nNum][ 09 ], "Novo Prod Incluido", "" )
		ZZY->ZZY_MYDELE	:= Iif( _aDadItem[ _nNum][ 10 ], "D", "" )
		ZZY->( MsUnlock() )
		
	Next _nL

End Transaction

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GrvDtAltera ³ Autor ³ Myers Industries    ³ Data ³18.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava a data de alteracao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08.08.2021³Celso Costa TI9³ Revisao                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrvDtAltera()

RecLock( "SUA", .F. )
SUA->UA_ZZDTALT	:= dDataBase
SUA->( MsUnLock() )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MyCondPag  ³ Autor ³ Myers Industries    ³ Data ³18.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email para a tesouraria informando a utilizacao de   ³±±
±±³          ³ uma condicao de paramento especifica (Parametro)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08.08.2021³Celso Costa TI9³ Revisao                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MyCondPag()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cHTML		:= ""
//Local _cLogin		:= ""
Local _cServer		:=	GetMv( "MV_RELSERV" )
Local _cAccount	:=	GetMv( "MV_RELACNT" )
Local _cPassword	:=	GetMv( "MV_RELPSW" )
//Local _cAutentic	:=	GetMv( "MV_RELAUTH" )
Local _cEmail		:= Posicione ( "ZZZ", 01, xFilial( "ZZZ" ) + "TMK000001" + "007", "ZZZ_RETORN" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Formata HTML                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cHtml	+= '<html> '
_cHtml	+= '<head> '
_cHtml	+= '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"><meta name=Generator content="Microsoft Word 12 (filtered)"> '
_cHtml	+= '<style> '
_cHtml	+= '<!-- '
_cHtml	+= ' /* Font Definitions */ '
_cHtml	+= ' @font-face '
_cHtml	+= '	{font-family:"Cambria Math"; '
_cHtml	+= '	panose-1:2 4 5 3 5 4 6 3 2 4;} '
_cHtml	+= '@font-face '
_cHtml	+= '	{font-family:Calibri; '
_cHtml	+= '	panose-1:2 15 5 2 2 2 4 3 2 4;} '
_cHtml	+= '@font-face '
_cHtml	+= '	{font-family:Tahoma; '
_cHtml	+= '	panose-1:2 11 6 4 3 5 4 4 2 4;} '
_cHtml	+= ' /* Style Definitions */ '
_cHtml	+= ' p.MsoNormal, li.MsoNormal, div.MsoNormal '
_cHtml	+= '	{margin-top:0cm; '
_cHtml	+= '	margin-right:0cm; '
_cHtml	+= '	margin-bottom:10.0pt; '
_cHtml	+= '	margin-left:0cm; '
_cHtml	+= '	line-height:115%; '
_cHtml	+= '	font-size:11.0pt; '
_cHtml	+= '	font-family:"Calibri","sans-serif";} '
_cHtml	+= 'p.MsoAcetate, li.MsoAcetate, div.MsoAcetate '
_cHtml	+= '	{mso-style-link:"Texto de balão Char"; '
_cHtml	+= '	margin:0cm; '
_cHtml	+= '	margin-bottom:.0001pt; '
_cHtml	+= '	font-size:8.0pt; '
_cHtml	+= '	font-family:"Tahoma","sans-serif";} '
_cHtml	+= 'p.msopapdefault, li.msopapdefault, div.msopapdefault '
_cHtml	+= '	{mso-style-name:msopapdefault; '
_cHtml	+= '	margin-right:0cm; '
_cHtml	+= '	margin-bottom:10.0pt; '
_cHtml	+= '	margin-left:0cm; '
_cHtml	+= '	line-height:115%; '
_cHtml	+= '	font-size:12.0pt; '
_cHtml	+= '	font-family:"Times New Roman","serif";} '
_cHtml	+= 'p.msochpdefault, li.msochpdefault, div.msochpdefault '
_cHtml	+= '	{mso-style-name:msochpdefault; '
_cHtml	+= '	margin-right:0cm; '
_cHtml	+= '	margin-left:0cm; '
_cHtml	+= '	font-size:10.0pt; '
_cHtml	+= '	font-family:"Times New Roman","serif";} '
_cHtml	+= 'span.TextodebaloChar '
_cHtml	+= '	{mso-style-name:"Texto de balão Char"; '
_cHtml	+= '	mso-style-link:"Texto de balão"; '
_cHtml	+= '	font-family:"Tahoma","sans-serif";} '
_cHtml	+= '.MsoChpDefault '
_cHtml	+= '	{font-size:10.0pt;} '
_cHtml	+= '@page Section1 '
_cHtml	+= '	{size:595.3pt 841.9pt; '
_cHtml	+= '	margin:70.85pt 3.0cm 70.85pt 3.0cm;} '
_cHtml	+= 'div.Section1 '
_cHtml	+= '	{page:Section1;} '
_cHtml	+= '--> '
_cHtml	+= '</style> '
_cHtml	+= '</head> '
_cHtml	+= '<body lang=PT-BR> '
_cHtml	+= '<div class=Section1> '
_cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>Orcamento com condicao de Pagamento especifica</span></i></b></p> "
_cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>&nbsp;</span></i></b></p> "
_cHtml	+= "<p class=MsoNormal>Foi incluido um Orcamento de vendas do cliente:  <b><i><span "
_cHtml	+= "style='font-size:12.0pt;line-height:115%'>" + AllTrim( SUA->UA_CLIENTE ) + "/" + AllTrim( SUA->UA_LOJA ) + " do Orçamento: " + AllTrim( SUA->UA_NUM ) + " </span></i></b><span "
_cHtml	+= ' <p class=MsoNormal style="text-indent:35.4pt"><b><i><spanstyle="font-size:14.0pt;line-height:115%"></span></i></b></p> '
_cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
_cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
_cHtml	+= '<p class=MsoNormal><b><i>Informações Complementares:</i></b></p> '
_cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
_cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
_cHtml	+= '<p class=MsoNormal>Sem mais,</p> '
_cHtml	+= '<p class=MsoNormal><b><i>' + AllTrim( Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "TMK000001" + "008", "ZZZ_RETORN" ) ) + '</i></b></p> '
_cHtml	+= '</div> '
_cHtml	+= '</body> '
_cHtml	+= '</html> '

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia email                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, _cEmail + Chr( 59 ), 'Orcamento com Condicao de Pagamento Especifica', _cHtml, /*_cAttach*/, /*_lMsg*/, /*_cLog*/ )

/*
CONNECT SMTP SERVER _cServer ACCOUNT _cAccount PASSWORD _cPassword Result lConectou

If GetMV( "MV_RELAUTH" )
	lResulConn := MailAuth( _cAccount, _cPassword )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ email para responsavel pela fase 1                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SEND MAIL FROM _cAccount TO _cEmail SUBJECT 'Orcamento com Condicao de Pagamento Especifica' BODY _cHtml
*/

Return ( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fNotPrxAp  ³ Autor ³ Myers Industries    ³ Data ³18.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email para a aprovador desconto do Orcamento         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08.08.2021³Celso Costa TI9³ Revisao                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function fNotPrxAp( _cAprovador )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oHtml			:= Nil
Local oEmail		:= Nil
Local _cAnexo		:= "" 	
Local _cTitulo		:= ""
Local _cCC			:= ""
Local _cCCo			:= ""
Local _cBody		:= ""  
Local _cAssunto	:= " Aprovação de Desconto do Orçamento: " + AllTrim( SUA->UA_NUM ) + " [ pendente ] "
Local _cDtHrEmiss	:= StrZero( Day( dDataBase ), 02 ) + "/" + StrZero( Month( dDataBase ), 02 ) + "/" + cValToChar( Year( dDataBase ) ) + " - " + Time()
Local _cMyEmpFil	:= SM0->M0_CODIGO + "/" + AllTrim( SM0->M0_FILIAL )
Local _cPara		:= fGetEmail( _cAprovador )
Local _aCorpo		:= {}
Local _aRodape		:= {} 
Local _cServidor	:= GetMv( "MV_RELSERV" )
Local _cConta		:= GetMv( "MV_RELACNT" )
Local _cPassWord	:= GetMv( "MV_RELPSW" )
Local _cAutentic	:= GetMv( "MV_RELAUTH" )
Local _cRemet		:= GetMv( "MV_RELACNT" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia email                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( _aCorpo, "O Orçamento abaixo: " )
aAdd( _aCorpo, " " )
aAdd( _aCorpo, "Enviado em: " + _cDtHrEmiss + ", de Número: " + AllTrim( SUA->UA_NUM ) )
aAdd( _aCorpo, " " )
aAdd( _aCorpo, "da empresa " + _cMyEmpFil + ",")
aAdd( _aCorpo, " ")
aAdd( _aCorpo, "de sua alçada, encontra-se pendente de aprovação. " )

aAdd( _aRodape, " " )
aAdd( _aRodape, " " + AllTrim( Posicione( "SU7", 01, xFilial( "SU7" ) + SUA->UA_OPERADO, "U7_NOME" ) ) + " " )
aAdd( _aRodape, "Depto de Vendas" )

oHtml := CorpoEmail():New( _cTitulo, _aCorpo, _aRodape )
oHtml:GeraHtml()	

_cBody := oHtml:cHtml

U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, AllTrim( _cPara ) + Chr( 59 ), _cAssunto, _cBody, /*Attatch*/, /*lResultSend*/, /*_cLog*/ )

/*
oEmail := ConEmail():New( _cServidor, _cConta, _cPassWord,, _cAutentic )

oEmail:EmailUsr()
oEmail:Conectar()    

If oEmail:Enviar( AllTrim( _cRemet), AllTrim( _cPara ), AllTrim( _cCC ), AllTrim( _cCCO ), AllTrim( _cAssunto ), oHtml:cHtml, _cAnexo )
	lRetorno	:=	.T.
	Aviso( FunDesc(), "E-mail enviado com SUCESSO.", { "OK" } )
EndIf

oEmail:Desconec()    
*/

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fGetMail   ³ Autor ³ Myers Industries    ³ Data ³18.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna conta de email do aprovador                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08.08.2021³Celso Costa TI9³ Revisao                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fGetEmail( _cAprovador )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nI	:= 00
Local _cRet	:= ""
Local _aUsu	:= AllUsers()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Formata retorno                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For _nI := 01 To len( _aUsu )

	If Upper( AllTrim( _aUsu[ _nI, 01, 02 ] ) ) == Upper( AllTrim( _cAprovador ) )
		_cRet	:= AllTrim( _aUsu[ _nI, 01, 14 ] )
		Exit
	EndIf

Next _nI

Return ( _cRet )
