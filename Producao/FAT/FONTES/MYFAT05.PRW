//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes e Includes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#Include "TOPCONN.CH"
#Include "AP5MAIL.CH"
#Include "TBICONN.CH"
#Include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MyFat05    ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Fluxo de pedidos                                           ³±±
±±³          ³ Analise 1 - Liberacao Comercial                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MyFat05()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cWhere	:= "C5_ZZUANA1<>' ' AND RTRIM(C5_BLQ)='' AND RTRIM(C5_NOTA)<>'XXXXXXXXX' AND (RTRIM(C5_NOTA)='' OR C5_LIBEROK='E')"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Private                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _cTit		:= "FLUXO PV - ANALISE 1 - VALIDACAO DEPTO. COMERCIAL"
Private _cDelFunc	:= ".T."

Private aRotina	:= {	{ "Pesquisar"	, "axPesqui"	, 00, 01 },;
								{ "Liberar"		, "U_Fat05B()"	, 00, 02 },;
								{ "Bloquear"	, "U_Fat05D()"	, 00, 02 },;
								{ "Reprovar"	, "U_Fat05E()"	, 00, 02 },;
								{ "Legenda"		, "U_Fat05A()"	, 00, 03 },;
								{ "Pedido"		, "U_Fat05C()"	, 00, 04 } }

Private aCores		:= {	{ 'C5_ZZUANA1=="N"', 'BR_VERDE'		},;
								{ 'C5_ZZUANA1=="S"', 'BR_VERMELHO'	},;
								{ 'C5_ZZUANA1=="B"', 'BR_CINZA'		},;
								{ 'C5_ZZUANA1=="R"', 'BR_LARANJA'	} }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca mBrowse                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SC5" )
SC5->( dbSetOrder( 01 ) )
SC5->( dbGoTop() )

mBrowse( 06, 01, 22, 75, "SC5",,,,,, aCores,,,,, .F.,,, _cWhere )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Fat05A     ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Legenda                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fat05A()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aLeg	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define legenda                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( _aLeg, { "BR_VERDE"		, OemToAnsi( "N - Pendente" ) }	)
aAdd( _aLeg, { "BR_VERMELHO"	, OemToAnsi( "S - Liberado" ) }	)
aAdd( _aLeg, { "BR_CINZA"		, OemToAnsi( "B - Bloqueado" ) }	)
aAdd( _aLeg, { "BR_LARANJA"	, OemToAnsi( "R - Reprovado" ) }	)

BrwLegenda( _cTit, "Legendas", _aLeg )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Fat05B     ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Liberacao                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fat05B()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua atualizacao de liberacao especifica                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !SC5->C5_ZZUANA1 $ "NB"
	MsgAlert( "Somente sera possivel liberar um pedido de vendas pendente ou bloqueado." )
	Return ( Nil )
EndIf

RecLock( "SC5", .F. )
SC5->C5_ZZUANA1	:= "S"
SC5->C5_ZZUANA2	:= "N"
SC5->C5_ZZULIBPV	:= Date()
SC5->( MsUnLock() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica condicao de pagamento/bloqueio cliente              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VerCond()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia email para Producao                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MailLibC()

If MsgYesNo( "Deseja enviar email com o Pedido de Venda para o Cliente?" )
	MailClie()
EndIf

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Fat05C     ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Visualiza pedido de vendas                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fat05C()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea	:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Private                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro
Private Inclui		:= .F.
Private Altera		:= .F.
Private lRefresh	:= .T.

dbSelectArea( "SC5" )

a410Visual( "SC5", SC5->( Recno() ), 02 )

RestArea( _aArea )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Fat05D     ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Bloquear                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fat05D()

If !SC5->C5_ZZUANA1 $ "N"
	MsgAlert( "Somente sera possivel Bloquear um pedido de vendas pendente." )
	Return ( Nil )
EndIf

RecLock( "SC5", .F. )
SC5->C5_ZZUANA1 := "B"
SC5->( MsUnLock() )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Fat05D     ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Reprovar                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fat05E()

If !SC5->C5_ZZUANA1 $ "NB"
	MsgAlert( "Somente sera possivel Reprovar um pedido de vendas pendente ou bloqueado." )
	Return ( Nil )
EndIf

RecLock( "SC5", .F. )
SC5->C5_ZZUANA1 := "R"
SC5->( MsUnLock() )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MailLibC   ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email para Producao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MAILLIBC()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lResult		:= .F.											// Se a conexao com o SMPT esta ok
Local _lRet			:= .F.											// Se tem autorizacao para o envio de e-mail
Local _cEmail		:= Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "FAT000007" + "001", "ZZZ_RETORN" )
Local _cEmailTo	:= ""												// E-mail de destino
Local _cEmailBcc	:= ""												// E-mail de copia
Local _cError		:= ""												// String de erro
Local _cMensagem	:= ""
Local _cAssunto	:= " O Pedido de Numero " + AllTrim( SC5->C5_NUM ) + " foi liberado para producao"
Local _lRelauth	:= SuperGetMv( "MV_RELAUTH",, .F. )	// Parametro que indica se existe autenticacao no e-mail
Local _cConta		:= Trim(GetMV( "MV_RELACNT" ) )			// Conta Autenticacao Ex.: fuladetal@fulano.com.br
Local _cPsw			:= Trim(GetMV( "MV_RELAPSW" ) )			// Senha de acesso Ex.: 123abc
Local _cServer		:= Trim(GetMV( "MV_RELSERV" ) )			// Ex.: smtp.ig.com.br ou 200.181.100.51
Local _cFrom		:= Trim(GetMV( "MV_RELFROM" ) )			// e-mail utilizado no campo From'MV_RELACNT' ou 'MV_RELFROM' e 'MV_RELPSW'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Default                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Default _cAttach	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define corpo do email                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cMensagem	:= "O Pedido abaixo:" + Chr( 13 ) + Chr( 10 )
_cMensagem	+= Chr( 13 ) + Chr( 10 )
_cMensagem	+= "Numero " + AllTrim( SC5->C5_NUM )
_cMensagem	+= Chr( 13 ) + Chr( 10 )
_cMensagem	+= "Foi liberado pelo comercial e esta pronto para producao."
_cMensagem	+= Chr( 13 ) + Chr( 10 )
_cMensagem	+= "Obrigado."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia email                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_fPNSendMail( /*cAccount*/, /*cPassword*/, /*cServer*/, /*cFrom*/, _cEmail + Chr( 59 ), _cAssunto, _cMensagem )

/*
_cEmailTo	:= _cEmail

If At( ";", _cEmail ) > 00
	_cEmailBcc := SubStr( _cEmail, At( ";", _cEmail ) + 01, Len( _cEmail ) )
Endif

CONNECT SMTP SERVER _cServer ACCOUNT _cConta PASSWORD _cPsw RESULT _lResult

If _lResult
	
	If _lRelauth
		_lRet := MailAuth( _cConta, _cPsw )
	Else
		_lRet := .T.
	EndIf

	If _lRet

		SEND MAIL;
		FROM			_cFrom		;
		TO				_cEmailTo	;
		BCC			_cEmailBcc	;
		SUBJECT		_cAssunto	;
		BODY			_cMensagem	;
		ATTACHMENT	_cAttach		;
		RESULT		_lResult
		
		If !_lResult

			//Erro no envio do email
			GET MAIL ERROR _cError

			If !IsBlind()
				Help( " ", 1, "01 - Atencao",, _cError + " " + _cEmailTo, 04, 05 )
			Else
				ApMsgInfo( "01 - Atencao " + _cError + " " + _cEmailTo )
			EndIf

		EndIf
		
	Else

		GET MAIL ERROR _cError

		If !IsBlind()
			Help( " ", 1, "02 - Autenticacao",, _cError, 04, 05 )
		Else
			ApMsgStop( "02 - Erro de autenticacao", "Verifique a conta e a senha para envio." )
		EndIf

	EndIf

	
	DISCONNECT SMTP SERVER

Else

	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError

	If !IsBlind()
		Help( " ", 1, "03 - Atencao",, _cError, 04, 05 )
	Else
		ApMsgInfo( "03 - Atencao " + _cError )
	EndIf

EndIf
*/

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VerCond    ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica condicao do cliente                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VerCond()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cValid		:= Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "FAT000007" + "002", "ZZZ_RETORN" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SA1" )
SA1->( dbsetorder( 01 ) )

If SA1->( dbSeek( xFilial( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )

	If AllTrim( _cValid ) == "S"

		If AllTrim( SA1->A1_COND ) != AllTrim( SC5->C5_CONDPAG )

			Reclock( "SA1", .F. )
			SA1->A1_MSBLQL := "1"
			SA1->( MsUnlock() )

			MyEnvMail()           

		EndIf

	EndIf
	
	If ( SC5->C5_CONDPAG $ Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "FAT000007" + "003", "ZZZ_RETORN" ) )

		RecLock( "SA1", .F. )
		SA1->A1_MSBLQL := "1"
		SA1->( MsUnlock() )

		MyEnvMail()         

	EndIf
	
EndIf

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MailClie   ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email para cliente                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MailClie()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lResult			:= .F.											// Se a conexao com o SMPT esta ok
Local _lRet				:= .F.											// Se tem autorizacao para o envio de e-mail
Local _cEmail			:= ""
Local _cEmailTo		:= ""												// E-mail de destino
Local _cEmailBcc		:= ""												// E-mail de copia
Local _cError			:= ""												// String de erro
Local _cMensagem		:= ""
Local _cAssunto 		:= ""
Local _cMailContato	:= ""
Local _aArea			:= GetArea()
Local _cAliasMail		:= GetNextAlias()
Local _lRelauth		:= SuperGetMv( "MV_RELAUTH",, .F. )	// Parametro que indica se existe autenticacao no e-mail
Local _cConta			:= Trim(GetMV( "MV_RELACNT" ) )			// Conta Autenticacao Ex.: fuladetal@fulano.com.br
Local _cPsw				:= Trim(GetMV( "MV_RELAPSW" ) )			// Senha de acesso Ex.: 123abc
Local _cServer			:= Trim(GetMV( "MV_RELSERV" ) )			// Ex.: smtp.ig.com.br ou 200.181.100.51
Local _cFrom			:= Trim(GetMV( "MV_RELFROM" ) )			// e-mail utilizado no campo From'MV_RELACNT' ou 'MV_RELFROM' e 'MV_RELPSW'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Private                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _nPerc		:= 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Default                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Default _cAttach	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia email                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim( SC5->C5_ZZMAILC ) == "S"  

	MsgAlert( "Email ja enviado ao cliente." )
	
	Return ( Nil )
	
EndIf

dbSelectArea( "SE4" )
SE4->( dbSetOrder( 01 ) )
SE4->( dbSeek( xFilial( "SE4" ) + SC5->C5_CONDPAG ) )

dbSelectArea( "SA3" )
SA3->( dbSetOrder( 01 ) )
SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND1 ) )

dbSelectArea( "SA1" )
SA1->( dbSetOrder( 01 ) )
SA1->( dbSeek( xFilial( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona destinatarios do email                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSQL Alias _cAliasMail
	Select 
		SU5.U5_EMAIL As Contato,
		SA3.A3_EMAIL As Vendedor,
		SA32.A3_EMAIL AS Super
	From
		%Table:SC5% SC5,
		%Table:SUA% SUA,
		%Table:SU5% SU5,
		%Table:SA3% SA3,
		%Table:SA3% SA32
	Where SC5.C5_NUM = %Exp:AllTrim( SC5->C5_NUM )%
		And SC5.C5_FILIAL = %xFilial:SC5%
		And SC5.%NotDel%
		And SUA.UA_NUMSC5 = SC5.C5_NUM
		And SUA.UA_CLIENTE = SC5.C5_CLIENTE
		And SUA.UA_LOJA = SC5.C5_LOJACLI
		And SUA.UA_FILIAL = %xFilial:SUA%
		And SUA.%NotDel%
		And SU5.U5_CODCONT = SUA.UA_CODCONT
		And SU5.U5_FILIAL = %xFilial:SU5%
		And SU5.%NotDel%
		And SA3.A3_COD = SC5.C5_VEND1
		And SA3.A3_FILIAL = %xFilial:SA3%
		And SA3.%NotDel%
		And SA32.A3_COD = SA3.A3_SUPER
		And SA32.A3_FILIAL = %xFilial:SA3%
		And SA32.%NotDel%
EndSQL

_cMailContato	:= AllTrim( Lower( ( _cAliasMail )->Contato ) )
_cEmail			:= AllTrim( Lower( ( _cAliasMail )->Contato ) )
_cEmail			+= Iif( !Empty( _cEmail ), ";", "" ) + AllTrim( Lower( ( _cAliasMail )->Vendedor ) )
_cEmail			+= Iif( !Empty( _cEmail ), ";", "" ) + AllTrim( Lower( ( _cAliasMail )->Super ) )

( _cAliasMail )->( dbCloseArea() )

_cEmail += Iif( !Empty( _cEmail ), ";", "" ) + AllTrim( Lower( Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "FAT000011" + "001", "ZZZ_RETORN" ) ) )
/**email operador**/
iif(!Empty(alltrim(UsrRetMail(RetCodUsr()) )) ,_cEmail += ";" + alltrim(UsrRetMail(RetCodUsr()) ),'')

If !Empty( _cMailContato )
	_nPerc	:= 100 - SA1->A1_DESC
Else
	MsgAlert( "Favor cadastrar o e-mail do cliente para que a confirmacao possa ser enviada." )
	Return ( Nil )
EndIf

_cEmailTo	:= _cEmail
_cAssunto	+= "Pedido de Venda Novel " + AllTrim( SC5->C5_NUM )
_cMensagem	:= MontaCorpo() 

U_fPNSendMail( /*cAccount*/, /*cPassword*/, /*cServer*/, /*cFrom*/, _cEmail + Chr( 59 ), _cAssunto, _cMensagem )

/*
If At( ";", _cEmail ) > 00
	_cEmailBcc := SubStr( _cEmail, At( ";", _cEmail ) + 01, Len( _cEmail ) )
EndIf

CONNECT SMTP SERVER _cServer ACCOUNT _cConta PASSWORD _cPsw RESULT _lResult

If _lResult
	
	If _lRelauth
		_lRet := MailAuth( _cConta, _cPsw )
	Else
		_lRet := .T.
	EndIf

	If _lRet

		SEND MAIL;
		FROM			_cFrom		;
		TO				_cEmailTo	;
		BCC			_cEmailBcc	;
		SUBJECT		_cAssunto	;
		BODY			_cMensagem	;
		ATTACHMENT	_cAttach		;
		RESULT		_lResult
		
		If !_lResult

			//Erro no envio do email
			GET MAIL ERROR _cError

			If !IsBlind()
				Help( " ", 1, "01 - Atencao",, _cError + " " + _cEmailTo, 04, 05 )
			Else
				ApMsgInfo( "01 - Atencao " + _cError + " " + _cEmailTo )
			EndIf

		Else
		
			// Atualiza status de email enviado
			RecLock( "SC5",.F. )
			SC5->C5_ZZMAILC := "S"
			SC5->( MsUnLock() )

		EndIf
		
	Else

		GET MAIL ERROR _cError

		If !IsBlind()
			Help( " ", 1, "02 - Autenticacao",, _cError, 04, 05 )
		Else
			ApMsgStop( "02 - Erro de autenticacao", "Verifique a conta e a senha para envio." )
		EndIf

	EndIf

	
	DISCONNECT SMTP SERVER

Else

	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError

	If !IsBlind()
		Help( " ", 1, "03 - Atencao",, _cError, 04, 05 )
	Else
		ApMsgInfo( "03 - Atencao " + _cError )
	EndIf

EndIf
*/

RestArea( _aArea )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GeraSenha  ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera senha                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSenha( _cCodCli )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cData	:= AllTrim( StrTran( DtoS( Date() ), "/", "" ) )
Local _cHora	:= SubStr( Time(), 01, 02 ) + SubStr( Time(), 04, 02 ) + SubStr( Time(), 06, 02 )
Local _cSenhaG	:= "" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Formata senha                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cSenhaG	:= SomaStr( _cCodCli, _cData )
_cSenhaG	:= SomaStr( _cSenhaG, _cHora )

Return( _cSenhaG )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontaCorpo ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Formata corpo do email                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaCorpo()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lIpiBruto	:= Iif( GetMV( "MV_IPIBRUT" ) == "S", .T., .F. )
Local _nVIPI		:= 00
Local _nBaseIPI	:= 00
Local _nValBase	:= 00
Local _cHTML		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Formata corpo do email                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cHTML := "<HTML><HEAD>"
_cHTML += "<TITLE>Titulos a vencer</TITLE>"
_cHTML += "</HEAD>"
_cHTML += "<BODY bgproperties='fixed' TEXT=#000000 LINK=#0000FF VLINK=#FF0000 BGCOLOR=#F0F0F0 >"
_cHTML += "<BASE TARGET='_top'>"
_cHTML += "<DIV class=s0>" 
_cHTML += "Cliente: " + AllTrim( SA1->A1_NOME ) + "&nbsp;</DIV>"
_cHTML += "<DIV class=s0>" 

_cHTML += "CNPJ/CPF: "+ TransForm( SA1->A1_CGC, Iif( SA1->A1_PESSOA == "F", "@R 999.999.999-99", "@R 99.999.999/9999-99" ) ) + "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>" 
_cHTML += "Prezados Senhores:"	
_cHTML += "<DIV class=s0>" 
_cHTML += "Segue abaixo informações sobre seu Pedido de Venda:"
_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>" 
_cHTML += "Numero do Pedido Venda................: " + AllTrim( SC5->C5_NUM )
_cHTML += "<DIV class=s0>" 
_cHTML += "<DIV class=s0>" 
_cHTML += "<DIV class=s0>"
_cHTML += "<DIV class=s0>"
_cHTML += "Condiçoes de Pagamento.......: " + AllTrim( SE4->E4_DESCRI )
_cHTML += "<DIV class=s0>"
_cHTML += "Tipo de Frete........................: " + Iif( SC5->C5_TPFRETE == "C", "CIF", "FOB" )
		
_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>" 
_cHTML += "Endereço.: " + AllTrim( SA1->A1_END )
_cHTML += "<DIV class=s0>"
_cHTML += "Município: " + AllTrim( SA1->A1_MUN )
_cHTML += "<DIV class=s0>"
_cHTML += "UF.......: " + AllTrim( SA1->A1_EST )
_cHTML += "<DIV class=s0>"
_cHTML += "Bairro...: " + AllTrim( SA1->A1_BAIRRO )
_cHTML += "<DIV class=s0>"
_cHTML += "CEP......: " + AllTrim( SA1->A1_CEP )
_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>" 		
_cHTML += "Endereço de Cobrança:"
_cHTML += "<DIV class=s0>"

_cHTML += "Endereço.: " + AllTrim( SA1->A1_ENDCOB )
_cHTML += "<DIV class=s0>"
_cHTML += "Município: " + AllTrim( SA1->A1_MUNC )
_cHTML += "<DIV class=s0>"
_cHTML += "UF.......: " + AllTrim( SA1->A1_ESTC )
_cHTML += "<DIV class=s0>"
_cHTML += "Bairro...: " + AllTrim( SA1->A1_BAIRROC )
_cHTML += "<DIV class=s0>"
_cHTML += "CEP......: " + AllTrim( SA1->A1_CEPC )
_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>" 
_cHTML += "Endereço de Entrega:"
_cHTML += "<DIV class=s0>"

_cHTML += "Endereço.: " + AllTrim( SA1->A1_ENDENT )
_cHTML += "<DIV class=s0>"
_cHTML += "Município: " + AllTrim( SA1->A1_MUNE )
_cHTML += "<DIV class=s0>"
_cHTML += "UF.......: " + AllTrim( SA1->A1_ESTE )
_cHTML += "<DIV class=s0>"
_cHTML += "Bairro...: " + AllTrim( SA1->A1_BAIRROE )
_cHTML += "<DIV class=s0>"
_cHTML += "CEP......: " + AllTrim( SA1->A1_CEPE )
_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>"
_cHTML += "<TABLE WIDTH='93%' BORDER='1' CELLPADDING='2' CELLSPACING='2' >"
_cHTML += "<TR> "
_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Item</DIV></TD>"
_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Produto</DIV></TD>"
_cHTML += "<TD WIDTH=30% VALIGN=TOP ><DIV class=s1>Descricao</DIV></TD>"
_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Quantidade</DIV></TD>"
_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Unitario</DIV></TD>"
_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Total s/IPI</DIV></TD>"
_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Total c/IPI</DIV></TD>"
_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Data Entrega</DIV></TD>" 
_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Pedido Cliente</DIV></TD>" 

_cHTML += "</TR>"                                                                           
		
dbSelectArea( "SC6" )
SC6->( dbSetOrder( 01 ) )
SC6->( dbSeek( xFilial( "SC6" ) + SC5->C5_NUM ) )

While SC6->( !Eof() ) .And. SC6->C6_NUM == SC5->C5_NUM

	dbSelectArea( "SF4" )
	SF4->( dbSetOrder( 01 ) )
	SF4->( dbSeek( xFilial( "SF4" ) + SC6->C6_TES ) )

	dbSelectArea( "SB1" )
	SB1->( dbSetOrder( 01 ) )
	SB1->( dbSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )

	_cHTML += "<TR>"
	_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + AllTrim( SC6->C6_ITEM ) + "</DIV></TD>"
	_cHTML += "<DIV class=s0>"
	_cHTML += "&nbsp;</DIV>"
	_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + AllTrim( SC6->C6_PRODUTO ) + "</DIV></TD>"
	_cHTML += "<DIV class=s0>"
	_cHTML += "&nbsp;</DIV>"	
	_cHTML += "<TD WIDTH=30% VALIGN=TOP ><DIV class=s1>" + AllTrim( SB1->B1_DESC ) + "</DIV></TD>"
	_cHTML += "<DIV class=s0>"
	_cHTML += "&nbsp;</DIV>"
	_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TransForm( SC6->C6_QTDVEN, "@E 999,999,999.99" ) + "</DIV></TD>"
	_cHTML += "<DIV class=s0>"
	_cHTML += "&nbsp;</DIV>"	
	_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TransForm( SC6->C6_PRCVEN, "@E 999,999,999.99" ) + "</DIV></TD>"
	_cHTML += "<DIV class=s0>"
	_cHTML += "&nbsp;</DIV>"	                                                                                           
	_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TransForm( SC6->C6_VALOR, "@E 999,999,999.99" ) + "</DIV></TD>"

	If SF4->F4_IPI == "S"
		_nBaseIPI	:= Iif( SF4->F4_BASEIPI > 00, SF4->F4_BASEIPI, 100 )
		_nValBase	:= Iif( _lIPIBruto .And. ( ( SC6->C6_PRCVEN * 100 ) / _nPerc ) > 00, ( ( SC6->C6_PRCVEN * 100 ) / _nPerc ),( ( SC6->C6_VALOR * 100 ) / _nPerc ) ) * SC6->C6_QTDVEN
		_nVIPI		:= _nValBase * ( SB1->B1_IPI / 100 ) * ( _nBaseIPI / 100 )
	EndIf

	_cHTML += "<DIV class=s0>"
	_cHTML += "&nbsp;</DIV>"			
	_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TransForm( SC6->C6_VALOR + _nVIPI, "@E 999,999,999.99" ) + "</DIV></TD>"
	_cHTML += "&nbsp;</DIV>"
	_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + DtoC( SC6->C6_ZZDATEN ) + "</DIV></TD>" 
	_cHTML += "&nbsp;</DIV>"
	_cHTML += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + AllTrim( SC6->C6_NUMPCOM ) + "</DIV></TD>"
	_cHTML += "&nbsp;</DIV>"
	
	_cHTML += "</TR>"

	SC6->( dbSkip() )
	
EndDo

_cHTML += "</DIV></TABLE>"

_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>"
_cHTML += "Quando fabricado com material reciclado podem apresentar variação de cores"
_cHTML += "<DIV class=s0>"
_cHTML += "<DIV class=s0>"
_cHTML += "Conforme especificação técnica o produto pode sofrer variação de peso"
_cHTML += "<DIV class=s0>"
_cHTML += "<DIV class=s0>"
_cHTML += "Quando pedido na condição FOB-RETIRA, caso cliente nao retirar a mercadoria após 7(sete) dias(corridos) do aviso de disponibilidade para retirar, a Novel esta autorizada a efetuar o embarque por transportadora de sua preferencia."
_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"
_cHTML += "<DIV class=s0>"
_cHTML += "PREZADO CLIENTE"
_cHTML += "<DIV class=s0>"
_cHTML += "FAVOR CONFERIR OS DADOS. CASO NÃO HAJA INSTRUÇÕES EM CONTRARIO, EM 1 DIA UTIL OS DADOS SERÃO CONSIDERADOS CORRETOS."
_cHTML += "<DIV class=s0>"
_cHTML += "O valor com impostos considera ICMS / PIS / COFINS."                                                                                                 
_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>"
_cHTML += "Qualquer duvida estamos a disposicao,"

_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>"
_cHTML += AllTrim( SM0->M0_NOMECOM )

_cHTML += "<DIV class=s0>"
_cHTML += "&nbsp;</DIV>"

_cHTML += "<DIV class=s0>"
_cHTML += ""

_cHTML += "</DIV></BODY></HTML>"

Return( _cHTML )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MyEnvMail  ³ Autor ³ Celso Costa - TI9   ³ Data ³26.01.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email para responsavel da liberacao do cliente       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MyEnvMail()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lResult		:= .F.											// Se a conexao com o SMPT esta ok
Local _lRet			:= .F.											// Se tem autorizacao para o envio de e-mail
Local _cEmailTo	:= ""												// E-mail de destino
Local _cEmailBcc	:= ""												// E-mail de copia
Local _cError		:= ""												// String de erro
Local _cMensagem	:= ""
Local _cHTML		:= ""
Local _lRelauth	:= SuperGetMv( "MV_RELAUTH",, .F. )	// Parametro que indica se existe autenticacao no e-mail
Local _cEmail		:= Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "FAT000007" + "004", "ZZZ_RETORN" )
Local _cConta		:= Trim(GetMV( "MV_RELACNT" ) )			// Conta Autenticacao Ex.: fuladetal@fulano.com.br
Local _cPsw			:= Trim(GetMV( "MV_RELAPSW" ) )			// Senha de acesso Ex.: 123abc
Local _cServer		:= Trim(GetMV( "MV_RELSERV" ) )			// Ex.: smtp.ig.com.br ou 200.181.100.51
Local _cFrom		:= Trim(GetMV( "MV_RELFROM" ) )			// e-mail utilizado no campo From'MV_RELACNT' ou 'MV_RELFROM' e 'MV_RELPSW'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Default                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Default _cAttach	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Formata corpo do email                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cHTML	+= '<html> '

_cHTML	+= '<head> '
_cHTML	+= '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"><meta name=Generator content="Microsoft Word 12 (filtered)"> '
_cHTML	+= '<style> '
_cHTML	+= '<!-- '
_cHTML	+= ' /* Font Definitions */ '
_cHTML	+= ' @font-face '
_cHTML	+= '	{font-family:"Cambria Math"; '
_cHTML	+= '	panose-1:2 4 5 3 5 4 6 3 2 4;} '
_cHTML	+= '@font-face '
_cHTML	+= '	{font-family:Calibri; '
_cHTML	+= '	panose-1:2 15 5 2 2 2 4 3 2 4;} '
_cHTML	+= '@font-face '
_cHTML	+= '	{font-family:Tahoma; '
_cHTML	+= '	panose-1:2 11 6 4 3 5 4 4 2 4;} '
_cHTML	+= ' /* Style Definitions */ '
_cHTML	+= ' p.MsoNormal, li.MsoNormal, div.MsoNormal '
_cHTML	+= '	{margin-top:0cm; '
_cHTML	+= '	margin-right:0cm; '
_cHTML	+= '	margin-bottom:10.0pt; '
_cHTML	+= '	margin-left:0cm; '
_cHTML	+= '	line-height:115%; '
_cHTML	+= '	font-size:11.0pt; '
_cHTML	+= '	font-family:"Calibri","sans-serIf";} '
_cHTML	+= 'p.MsoAcetate, li.MsoAcetate, div.MsoAcetate '
_cHTML	+= '	{mso-style-link:"Texto de balão Char"; '
_cHTML	+= '	margin:0cm; '
_cHTML	+= '	margin-bottom:.0001pt; '
_cHTML	+= '	font-size:8.0pt; '
_cHTML	+= '	font-family:"Tahoma","sans-serIf";} '
_cHTML	+= 'p.msopapdefault, li.msopapdefault, div.msopapdefault '
_cHTML	+= '	{mso-style-name:msopapdefault; '
_cHTML	+= '	margin-right:0cm; '
_cHTML	+= '	margin-bottom:10.0pt; '
_cHTML	+= '	margin-left:0cm; '
_cHTML	+= '	line-height:115%; '
_cHTML	+= '	font-size:12.0pt; '
_cHTML	+= '	font-family:"Times New Roman","serIf";} '
_cHTML	+= 'p.msochpdefault, li.msochpdefault, div.msochpdefault '
_cHTML	+= '	{mso-style-name:msochpdefault; '
_cHTML	+= '	margin-right:0cm; '
_cHTML	+= '	margin-left:0cm; '
_cHTML	+= '	font-size:10.0pt; '
_cHTML	+= '	font-family:"Times New Roman","serIf";} '
_cHTML	+= 'span.TextodebaloChar '
_cHTML	+= '	{mso-style-name:"Texto de balão Char"; '
_cHTML	+= '	mso-style-link:"Texto de balão"; '
_cHTML	+= '	font-family:"Tahoma","sans-serIf";} '
_cHTML	+= '.MsoChpDefault '
_cHTML	+= '	{font-size:10.0pt;} '
_cHTML	+= '@page Section1 '
_cHTML	+= '	{size:595.3pt 841.9pt; '
_cHTML	+= '	margin:70.85pt 3.0cm 70.85pt 3.0cm;} '
_cHTML	+= 'div.Section1 '
_cHTML	+= '	{page:Section1;} '
_cHTML	+= '--> '
_cHTML	+= '</style> '

_cHTML	+= '</head> '

_cHTML	+= '<body lang=PT-BR> '

_cHTML	+= '<div class=Section1> '

_cHTML	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>Cliente Bloqueado por Regra de Negocio - Condicao a Vista Especial</span></i></b></p> "

_cHTML	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>&nbsp;</span></i></b></p> "

_cHTML	+= '<p class=MsoNormal>&nbsp;</p> '

_cHTML	+= '<p class=MsoNormal><b><i>Informações Complementares:</i></b></p> '

_cHTML	+= "<p class=MsoNormal style='text-indent:35.4pt'>Numero: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>" + AllTrim( SC5->C5_NUM ) + "</span></i></b></p> "

_cHTML	+= "<p class=MsoNormal style='text-indent:35.4pt'>Emissao: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>" + DtoC( SC5->C5_EMISSAO ) + "</span></i></b></p> "

_cHTML	+= "<p class=MsoNormal style='text-indent:35.4pt'>Cliente: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>" + AllTrim( SC5->C5_CLIENTE ) + "/" + AllTrim( SC5->C5_LOJACLI ) + "</span></i></b></p> "

_cHTML	+= "<p class=MsoNormal style='text-indent:35.4pt'>Descricao: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>" + AllTrim( SA1->A1_NOME ) + "</span></i></b></p> "

_cHTML	+= '<p class=MsoNormal>&nbsp;</p> '

_cHTML	+= "<p class=MsoNormal> Planta: " + AllTrim( FWFilialName() ) + "</p>"

_cHTML	+= '<p class=MsoNormal>&nbsp;</p> '

_cHTML	+= '<p class=MsoNormal>Sem mais,</p> '

_cHTML	+= '<p class=MsoNormal><b><i>Controladoria</i></b></p> '

_cHTML	+= '</div> '

_cHTML	+= '</body> '

_cHTML	+= '</html> '

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia email                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cEmailTo	:= _cEmail
_cAssunto	:= "Cliente bloqueado por regra de negocio"
_cMensagem	:= _cHTML

U_fPNSendMail( /*cAccount*/, /*cPassword*/, /*cServer*/, /*cFrom*/, _cEmail + Chr( 59 ), _cAssunto, _cMensagem )

/*
If At( ";", _cEmail ) > 00
	_cEmailBcc := SubStr( _cEmail, At( ";", _cEmail ) + 01, Len( _cEmail ) )
Endif

CONNECT SMTP SERVER _cServer ACCOUNT _cConta PASSWORD _cPsw RESULT _lResult

If _lResult
	
	If _lRelauth
		_lRet := MailAuth( _cConta, _cPsw )
	Else
		_lRet := .T.
	EndIf

	If _lRet

		SEND MAIL;
		FROM			_cFrom		;
		TO				_cEmailTo	;
		BCC			_cEmailBcc	;
		SUBJECT		_cAssunto	;
		BODY			_cMensagem	;
		ATTACHMENT	_cAttach		;
		RESULT		_lResult
		
		If !_lResult

			//Erro no envio do email
			GET MAIL ERROR _cError

			If !IsBlind()
				Help( " ", 1, "01 - Atencao",, _cError + " " + _cEmailTo, 04, 05 )
			Else
				ApMsgInfo( "01 - Atencao " + _cError + " " + _cEmailTo )
			EndIf

		EndIf
		
	Else

		GET MAIL ERROR _cError

		If !IsBlind()
			Help( " ", 1, "02 - Autenticacao",, _cError, 04, 05 )
		Else
			ApMsgStop( "02 - Erro de autenticacao", "Verifique a conta e a senha para envio." )
		EndIf

	EndIf

	
	DISCONNECT SMTP SERVER

Else

	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError

	If !IsBlind()
		Help( " ", 1, "03 - Atencao",, _cError, 04, 05 )
	Else
		ApMsgInfo( "03 - Atencao " + _cError )
	EndIf

EndIf
*/

Return( Nil )
