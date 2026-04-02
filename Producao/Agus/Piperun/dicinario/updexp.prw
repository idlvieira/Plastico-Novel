#INCLUDE "protheus.ch"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDEXP

Função de update de dicionários para compatibilização

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDEXP( cEmpAmb, cFilAmb )
Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc3    := "usuários  ou  jobs utilizando  o sistema.  É EXTREMAMENTE recomendavél  que  se  faça"
Local   cDesc4    := "um BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para"
Local   cDesc5    := "que caso ocorram eventuais falhas, esse backup possa ser restaurado."
Local   cDesc6    := ""
Local   cDesc7    := ""
Local   cMsg      := ""
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
//aAdd( aSay, cDesc6 )
//aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

If lAuto
	lOk := .T.
Else
	FormBatch(  cTitulo,  aSay,  aButton )
EndIf

If lOk

	If GetVersao(.F.) < "12" .OR. ( FindFunction( "MPDicInDB" ) .AND. !MPDicInDB() )
		cMsg := "Este update NÃO PODE ser executado neste Ambiente." + CRLF + CRLF + ;
				"Os arquivos de dicionários se encontram em formato ISAM" + " (" + GetDbExtension() + ") " + "Os arquivos de dicionários se encontram em formato ISAM" + " " + ;
				"para atualizar apenas ambientes com dicionários no Banco de Dados."

		If lAuto
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( cMsg )
			ConOut( DToC(Date()) + "|" + Time() + cMsg )
		Else
			MsgInfo( cMsg )
		EndIf

		Return NIL
	EndIf

	If lAuto
		aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
	Else
		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgInfo( "Atualização realizada.", "UPDEXP" )
				Else
					MsgStop( "Atualização não realizada.", "UPDEXP" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização realizada." )
				Else
					Final( "Atualização não realizada." )
				EndIf
			EndIf

		Else
			Final( "Atualização não realizada." )

		EndIf

	Else
		Final( "Atualização não realizada." )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc

Função de processamento da gravação dos arquivos

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )

	dbSelectArea( "SM0" )
	dbGoTop()

	While !SM0->( EOF() )
		// Só adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End

	SM0->( dbCloseArea() )

	If lOpen

		For nI := 1 To Len( aRecnoSM0 )

			If !( lOpen := MyOpenSm0(.F.) )
				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Versão.............: " + GetVersao(.T.) )
			AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usuário da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Estação............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf

			oProcess:SetRegua1( 8 )

			//------------------------------------
			// Atualiza o dicionário SX2
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2()

			//------------------------------------
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3()

			//------------------------------------
			// Atualiza o dicionário SIX
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX()

			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/índices" )

			// Alteração física dos arquivos
			__SetX31Mode( .F. )

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For nX := 1 To Len( aArqUpd )

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
						!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf

				If Select( aArqUpd[nX] ) > 0
					dbSelectArea( aArqUpd[nX] )
					dbCloseArea()
				EndIf

				X31UpdTable( aArqUpd[nX] )

				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] )
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//------------------------------------
			// Atualiza o dicionário SX6
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6()

			//------------------------------------
			// Atualiza o dicionário SX7
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7()

			//------------------------------------
			// Atualiza o dicionário SXA
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de pastas" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXA()

			//------------------------------------
			// Atualiza o dicionário SXB
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB()

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel

			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont

			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

			Activate MsDialog oDlg Center

		EndIf

	EndIf

Else

	lRet := .F.

EndIf

Return lRet


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX2

Função de processamento da gravação do SX2 - Arquivos

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX2()
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cCpoUpd   := "X2_ROTINA /X2_UNICO  /X2_DISPLAY/X2_SYSOBJ /X2_USROBJ /X2_POSLGT /"
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Ínicio da Atualização" + " SX2" + CRLF )

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
             "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
             "X2_POSLGT" , "X2_CLOB"   , "X2_AUTREC" , "X2_MODOEMP", "X2_MODOUN" , "X2_STAMP"  , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela ZTA
//
aAdd( aSX2, { ;
	'ZTA'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZTA'+cEmpr																, ; //X2_ARQUIVO
	'Funil de Vendas'														, ; //X2_NOME
	'Funil de Vendas'														, ; //X2_NOMESPA
	'Funil de Vendas'														, ; //X2_NOMEENG
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	''																		, ; //X2_STAMP
	0																		} ) //X2_MODULO

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2) ..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			AutoGrLog( "Foi incluída a tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .T. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If AllTrim( aEstrut[nJ] ) == "X2_ARQUIVO"
					FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  "0" )
				Else
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf
			EndIf
		Next nJ
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			RecLock( "SX2", .F. )
			SX2->X2_UNICO := aSX2[nI][12]
			MsUnlock()

			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
			EndIf

			AutoGrLog( "Foi alterada a chave única da tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .F. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If PadR( aEstrut[nJ], 10 ) $ cCpoUpd
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf

			EndIf
		Next nJ
		MsUnLock()

	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3

Função de processamento da gravação do SX3 - Campos

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
Local cX3Campo  := ""
Local cX3Dado   := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


//
// Campos Tabela SA1
//
aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'E8'																	, ; //X3_ORDEM
	'A1_PIPERUN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Piperun'															, ; //X3_TITULO
	'Cod. Piperun'															, ; //X3_TITSPA
	'Cod. Piperun'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'E9'																	, ; //X3_ORDEM
	'A1_XLOGINT'															, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Log. Integra'															, ; //X3_TITULO
	'Log. Integra'															, ; //X3_TITSPA
	'Log. Integra'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EA'																	, ; //X3_ORDEM
	'A1_PROSPEC'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Prospec'															, ; //X3_TITULO
	'Cod. Prospec'															, ; //X3_TITSPA
	'Cod. Prospec'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SUS'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EC'																	, ; //X3_ORDEM
	'A1_XTEMP'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Temp. Lead'															, ; //X3_TITULO
	'Temp. Lead'															, ; //X3_TITSPA
	'Temp. Lead'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'#PIPERUN.UTILS.U_COMPSIT()'											, ; //X3_CBOX
	'#PIPERUN.UTILS.U_COMPSIT()'											, ; //X3_CBOXSPA
	'#PIPERUN.UTILS.U_COMPSIT()'											, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'ED'																	, ; //X3_ORDEM
	'A1_XCONTAC'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Contato'																, ; //X3_TITULO
	'Contato'																, ; //X3_TITSPA
	'Contato'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EE'																	, ; //X3_ORDEM
	'A1_XNCONTA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N. Contato'															, ; //X3_TITULO
	'N. Contato'															, ; //X3_TITSPA
	'N. Contato'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EF'																	, ; //X3_ORDEM
	'A1_XECONTA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'C. Email'																, ; //X3_TITULO
	'C. Email'																, ; //X3_TITSPA
	'C. Email'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EG'																	, ; //X3_ORDEM
	'A1_XCONT1'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Contato 1'																, ; //X3_TITULO
	'Contato 1'																, ; //X3_TITSPA
	'Contato 1'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EH'																	, ; //X3_ORDEM
	'A1_XNCONT1'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N. Contato 1'															, ; //X3_TITULO
	'N. Contato 1'															, ; //X3_TITSPA
	'N. Contato 1'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EI'																	, ; //X3_ORDEM
	'A1_ECONT1'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'C. Email 1'															, ; //X3_TITULO
	'C. Email 1'															, ; //X3_TITSPA
	'C. Email 1'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EJ'																	, ; //X3_ORDEM
	'A1_XCONT2'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Contato 2'																, ; //X3_TITULO
	'Contato 2'																, ; //X3_TITSPA
	'Contato 2'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EK'																	, ; //X3_ORDEM
	'A1_XNCONT2'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'N. Contato 2'															, ; //X3_TITULO
	'N. Contato 2'															, ; //X3_TITSPA
	'N. Contato 2'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA1'																	, ; //X3_ARQUIVO
	'EL'																	, ; //X3_ORDEM
	'A1_ECONT2'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'C. Email 2'															, ; //X3_TITULO
	'C. Email 2'															, ; //X3_TITSPA
	'C. Email 2'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'7'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SA3
//
aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'98'																	, ; //X3_ORDEM
	'A3_XINTEGR'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Integrado?'															, ; //X3_TITULO
	'Integrado?'															, ; //X3_TITSPA
	'Integrado?'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"N"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'99'																	, ; //X3_ORDEM
	'A3_PIPERUN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Piperun'															, ; //X3_TITULO
	'Cod. Piperun'															, ; //X3_TITSPA
	'Cod. Piperun'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9A'																	, ; //X3_ORDEM
	'A3_XLOGINT'															, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Log. Integra'															, ; //X3_TITULO
	'Log. Integra'															, ; //X3_TITSPA
	'Log. Integra'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9B'																	, ; //X3_ORDEM
	'A3_XFUNIL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Funil Obrig'															, ; //X3_TITULO
	'Funil Obrig'															, ; //X3_TITSPA
	'Funil Obrig'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9C'																	, ; //X3_ORDEM
	'A3_XDFUNIL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc. Funil'															, ; //X3_TITULO
	'Desc. Funil'															, ; //X3_TITSPA
	'Desc. Funil'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9D'																	, ; //X3_ORDEM
	'A3_XFUNIL1'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Funil 1'																, ; //X3_TITULO
	'Funil 1'																, ; //X3_TITSPA
	'Funil 1'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9E'																	, ; //X3_ORDEM
	'A3_XDFUNI1'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc Funil 1'															, ; //X3_TITULO
	'Desc Funil 1'															, ; //X3_TITSPA
	'Desc Funil 1'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9F'																	, ; //X3_ORDEM
	'A3_XFUNIL2'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Funil 2'																, ; //X3_TITULO
	'Funil 2'																, ; //X3_TITSPA
	'Funil 2'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9G'																	, ; //X3_ORDEM
	'A3_XDFUNI2'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc Funil 2'															, ; //X3_TITULO
	'Desc Funil 2'															, ; //X3_TITSPA
	'Desc Funil 2'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9H'																	, ; //X3_ORDEM
	'A3_XFUNIL3'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Funil 3'																, ; //X3_TITULO
	'Funil 3'																, ; //X3_TITSPA
	'Funil 3'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9I'																	, ; //X3_ORDEM
	'A3_XDFUNI3'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc Funil 3'															, ; //X3_TITULO
	'Desc Funil 3'															, ; //X3_TITSPA
	'Desc Funil 3'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9J'																	, ; //X3_ORDEM
	'A3_XFUNIL4'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Funil 4'																, ; //X3_TITULO
	'Funil 4'																, ; //X3_TITSPA
	'Funil 4'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SA3'																	, ; //X3_ARQUIVO
	'9K'																	, ; //X3_ORDEM
	'A3_XDFUNI4'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc Funil 4'															, ; //X3_TITULO
	'Desc Funil 4'															, ; //X3_TITSPA
	'Desc Funil 4'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'6'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SB1
//
aAdd( aSX3, { ;
	'SB1'																	, ; //X3_ARQUIVO
	'EW'																	, ; //X3_ORDEM
	'B1_PIPERUN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Piperun'																, ; //X3_TITULO
	'Piperun'																, ; //X3_TITSPA
	'Piperun'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SC5
//
aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'BF'																	, ; //X3_ORDEM
	'C5_PIPERUN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Piperun'																, ; //X3_TITULO
	'Piperun'																, ; //X3_TITSPA
	'Piperun'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SF4
//
aAdd( aSX3, { ;
	'SF4'																	, ; //X3_ARQUIVO
	'EQ'																	, ; //X3_ORDEM
	'F4_PIPERUN'															, ; //X3_CAMPO
	'L'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Int. Piperun'															, ; //X3_TITULO
	'Int. Piperun'															, ; //X3_TITSPA
	'Int. Piperun'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'.F.'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'1'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SU5
//
aAdd( aSX3, { ;
	'SU5'																	, ; //X3_ARQUIVO
	'81'																	, ; //X3_ORDEM
	'U5_XINTEGR'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Integrado?'															, ; //X3_TITULO
	'Integrado?'															, ; //X3_TITSPA
	'Integrado?'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"N"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'4'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SU5'																	, ; //X3_ARQUIVO
	'82'																	, ; //X3_ORDEM
	'U5_PIPERUN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Piperun'															, ; //X3_TITULO
	'Cod. Piperun'															, ; //X3_TITSPA
	'Cod. Piperun'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'4'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SU5'																	, ; //X3_ARQUIVO
	'83'																	, ; //X3_ORDEM
	'U5_XLOGINT'															, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Log. Integra'															, ; //X3_TITULO
	'Log. Integra'															, ; //X3_TITSPA
	'Log. Integra'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'4'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SU5'																	, ; //X3_ARQUIVO
	'84'																	, ; //X3_ORDEM
	'U5_XCLIENT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cliente'																, ; //X3_TITULO
	'Cliente'																, ; //X3_TITSPA
	'Cliente'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'CLT'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'5'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SU5'																	, ; //X3_ARQUIVO
	'85'																	, ; //X3_ORDEM
	'U5_XLOJA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Loja'																	, ; //X3_TITULO
	'Loja'																	, ; //X3_TITSPA
	'Loja'																	, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'5'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SU5'																	, ; //X3_ARQUIVO
	'86'																	, ; //X3_ORDEM
	'U5_XNEMP'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	60																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome'																	, ; //X3_TITULO
	'Nome'																	, ; //X3_TITSPA
	'Nome'																	, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'V'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	'5'																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SUA
//
aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A1'																	, ; //X3_ORDEM
	'UA_XORIGEM'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Orig. Oportu'															, ; //X3_TITULO
	'Orig. Oportu'															, ; //X3_TITSPA
	'Orig. Oportu'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'#PipeRun.utils.u_returnOrigins()'										, ; //X3_CBOX
	'#PipeRun.utils.u_returnOrigins()'										, ; //X3_CBOXSPA
	'#PipeRun.utils.u_returnOrigins()'										, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'A00'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A2'																	, ; //X3_ORDEM
	'UA_XFUNIL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Funil Vendas'															, ; //X3_TITULO
	'Funil Vendas'															, ; //X3_TITSPA
	'Funil Vendas'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA_F'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A3'																	, ; //X3_ORDEM
	'UA_XSTAGE'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Epata Funil'															, ; //X3_TITULO
	'Epata Funil'															, ; //X3_TITSPA
	'Epata Funil'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'ZTA_E'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'A00'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A4'																	, ; //X3_ORDEM
	'UA_XTEMP'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Temperatura'															, ; //X3_TITULO
	'Temperatura'															, ; //X3_TITSPA
	'Temperatura'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'1=Muito Quente;2=Quente;3=Morna;4=Fria'								, ; //X3_CBOX
	'1=Muito Quente;2=Quente;3=Morna;4=Fria'								, ; //X3_CBOXSPA
	'1=Muito Quente;2=Quente;3=Morna;4=Fria'								, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'A00'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A5'																	, ; //X3_ORDEM
	'UA_PIPERUN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'PipeRun'																, ; //X3_TITULO
	'PipeRun'																, ; //X3_TITSPA
	'PipeRun'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'A00'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A6'																	, ; //X3_ORDEM
	'UA_XLOGINT'															, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Log Integra'															, ; //X3_TITULO
	'Log Integra'															, ; //X3_TITSPA
	'Log Integra'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'A00'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A7'																	, ; //X3_ORDEM
	'UA_XINTREG'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Integrado'																, ; //X3_TITULO
	'Integrado'																, ; //X3_TITSPA
	'Integrado'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"N"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'A00'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A8'																	, ; //X3_ORDEM
	'UA_TIMESTA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'TimeStamp'																, ; //X3_TITULO
	'TimeStamp'																, ; //X3_TITSPA
	'TimeStamp'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'STRTRAN(FWTIMESTAMP(3,DATE(),TIME()),"T", " ")'						, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUA'																	, ; //X3_ARQUIVO
	'A9'																	, ; //X3_ORDEM
	'UA_XSTATUS'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Status Oport'															, ; //X3_TITULO
	'Status Oport'															, ; //X3_TITSPA
	'Status Oport'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"X"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'0=Aberta;1=Ganha;3=Perdida;X=Aguardando integração;'					, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SUB
//
aAdd( aSX3, { ;
	'SUB'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'UB_ZVLNET'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	16																		, ; //X3_TAMANHO
	4																		, ; //X3_DECIMAL
	'VL NET'																, ; //X3_TITULO
	'VL NET'																, ; //X3_TITSPA
	'VL NET'																, ; //X3_TITENG
	'Valor NET sem frete'													, ; //X3_DESCRIC
	'Valor NET sem frete'													, ; //X3_DESCSPA
	'Valor NET sem frete'													, ; //X3_DESCENG
	'@E 99,999,999,999.9999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUB'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'UB_ZVLNETF'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	16																		, ; //X3_TAMANHO
	4																		, ; //X3_DECIMAL
	'NET C FRETE'															, ; //X3_TITULO
	'NET C FRETE'															, ; //X3_TITSPA
	'NET C FRETE'															, ; //X3_TITENG
	'NET com frete'															, ; //X3_DESCRIC
	'NET com frete'															, ; //X3_DESCSPA
	'NET com frete'															, ; //X3_DESCENG
	'@E 99,999,999,999.9999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUB'																	, ; //X3_ARQUIVO
	'56'																	, ; //X3_ORDEM
	'UB_PIPERUN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Piperun'															, ; //X3_TITULO
	'Cod. Piperun'															, ; //X3_TITSPA
	'Cod. Piperun'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SUS
//
aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9D'																	, ; //X3_ORDEM
	'US_XINTEGR'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Integrado?'															, ; //X3_TITULO
	'Integrado?'															, ; //X3_TITSPA
	'Integrado?'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"N"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'PIP'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9E'																	, ; //X3_ORDEM
	'US_PIPERUN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Piperun'															, ; //X3_TITULO
	'Cod. Piperun'															, ; //X3_TITSPA
	'Cod. Piperun'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'PIP'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9F'																	, ; //X3_ORDEM
	'US_XLOGINT'															, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Log. integra'															, ; //X3_TITULO
	'Log. integra'															, ; //X3_TITSPA
	'Log. integra'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'PIP'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9G'																	, ; //X3_ORDEM
	'US_XTEMP'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Temp. Lead'															, ; //X3_TITULO
	'Temp. Lead'															, ; //X3_TITSPA
	'Temp. Lead'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'#PIPERUN.UTILS.U_COMPSIT()'											, ; //X3_CBOX
	'#PIPERUN.UTILS.U_COMPSIT()'											, ; //X3_CBOXSPA
	'#PIPERUN.UTILS.U_COMPSIT()'											, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'PIP'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9H'																	, ; //X3_ORDEM
	'US_XCONTAC'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Contato'															, ; //X3_TITULO
	'Cod. Contato'															, ; //X3_TITSPA
	'Cod. Contato'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SU5'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9I'																	, ; //X3_ORDEM
	'US_XNCONTA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome Contato'															, ; //X3_TITULO
	'Nome Contato'															, ; //X3_TITSPA
	'Nome Contato'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9J'																	, ; //X3_ORDEM
	'US_XECONTA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Email Contat'															, ; //X3_TITULO
	'Email Contat'															, ; //X3_TITSPA
	'Email Contat'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9K'																	, ; //X3_ORDEM
	'US_XCONT1'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Contato 1'																, ; //X3_TITULO
	'Contato 1'																, ; //X3_TITSPA
	'Contato 1'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SU5'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9L'																	, ; //X3_ORDEM
	'US_XNCONT1'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome Contato'															, ; //X3_TITULO
	'Nome Contato'															, ; //X3_TITSPA
	'Nome Contato'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9M'																	, ; //X3_ORDEM
	'US_XECONT1'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Email Contat'															, ; //X3_TITULO
	'Email Contat'															, ; //X3_TITSPA
	'Email Contat'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9N'																	, ; //X3_ORDEM
	'US_XCONT2'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Contato 2'																, ; //X3_TITULO
	'Contato 2'																, ; //X3_TITSPA
	'Contato 2'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SU5'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9O'																	, ; //X3_ORDEM
	'US_XNCONT2'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome Contato'															, ; //X3_TITULO
	'Nome Contato'															, ; //X3_TITSPA
	'Nome Contato'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SUS'																	, ; //X3_ARQUIVO
	'9P'																	, ; //X3_ORDEM
	'US_XECONT2'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Email Contat'															, ; //X3_TITULO
	'Email Contat'															, ; //X3_TITSPA
	'Email Contat'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	'CON'																	, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZTA
//
aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZTA_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	4																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'XXXXXX X'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZTA_CODIGO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Codigo'																, ; //X3_TITULO
	'Codigo'																, ; //X3_TITSPA
	'Codigo'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'GETSXENUM("ZTA"," ZTA_CODIGO")'										, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZTA_FUNIL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Funil'																	, ; //X3_TITULO
	'Funil'																	, ; //X3_TITSPA
	'Funil'																	, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'x'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZTA_DESC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Descrição'																, ; //X3_TITULO
	'Descrição'																, ; //X3_TITSPA
	'Descrição'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZTA_TIPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo'																	, ; //X3_TITULO
	'Tipo'																	, ; //X3_TITSPA
	'Tipo'																	, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'"0"'																	, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'0=Vendas;1=Pré vendas;2=Pós vendas;3:=Customer Sucess;4=Marketing;5=Contratos;6=Projetos;7=Administrativo;', ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZTA_PIPERU'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	12																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. integra'															, ; //X3_TITULO
	'Cod. integra'															, ; //X3_TITSPA
	'Cod. integra'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZTA_ITEM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'item'																	, ; //X3_TITULO
	'item'																	, ; //X3_TITSPA
	'item'																	, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZTA_ETAPAS'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Etapa'															, ; //X3_TITULO
	'Cod. Etapa'															, ; //X3_TITSPA
	'Cod. Etapa'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZTA_DESCET'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome Etapa'															, ; //X3_TITULO
	'Nome Etapa'															, ; //X3_TITSPA
	'Nome Etapa'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZTA_DESC1'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc. Etapa'															, ; //X3_TITULO
	'Desc. Etapa'															, ; //X3_TITSPA
	'Desc. Etapa'															, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZTA_ORDER'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Order'																	, ; //X3_TITULO
	'Order'																	, ; //X3_TITSPA
	'Order'																	, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'ZTA_USER'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Usuario'																, ; //X3_TITULO
	'Usuario'																, ; //X3_TITSPA
	'Usuario'																, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZTA'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'ZTA_CABEC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cabec'																	, ; //X3_TITULO
	'Cabec'																	, ; //X3_TITSPA
	'Cabec'																	, ; //X3_TITENG
	''																		, ; //X3_DESCRIC
	''																		, ; //X3_DESCSPA
	''																		, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME


//
// Atualizando dicionário
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo] + " NÃO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq] $ cAlias )
		cAlias += aSX3[nI][nPosArq] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If     nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

			ElseIf aEstrut[nJ][2] > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo] )

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3) ..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX

Função de processamento da gravação do SIX - Indices

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSIX()
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Ínicio da Atualização" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela SA1
//
aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'E'																		, ; //ORDEM
	'A1_FILIAL+A1_PIPERUN'													, ; //CHAVE
	'Cod. Piperun'															, ; //DESCRICAO
	'Cod. Piperun'															, ; //DESCSPA
	'Cod. Piperun'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SA3
//
aAdd( aSIX, { ;
	'SA3'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'A3_FILIAL+A3_PIPERUN'													, ; //CHAVE
	'Cod. Piperun'															, ; //DESCRICAO
	'Cod. Piperun'															, ; //DESCSPA
	'Cod. Piperun'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SC5
//
aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'C5_FILIAL+C5_TIPO+C5_EMISSAO+C5_NUM'									, ; //CHAVE
	'Tipo Pedido+DT Emissao+Numero'											, ; //DESCRICAO
	'Tipo pedido+Fch Emision+Numero'										, ; //DESCSPA
	'Order Type+Fch Emision+Numero'											, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'ZZ00000001'															, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'C'																		, ; //ORDEM
	'C5_FILIAL+C5_TIPO+C5_NUM+C5_EMISSAO+C5_CLIENTE+C5_LOJACLI'				, ; //CHAVE
	'Tipo Pedido+Numero+DT Emissao+Cliente+Loja'							, ; //DESCRICAO
	'Tipo pedido+Numero+Fch Emision+Cliente+Tienda'							, ; //DESCSPA
	'Order Type+Numero+Fch Emision+Cliente+Tienda'							, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'ZZ00000000'															, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SU5
//
aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'U5_FILIAL+U5_PIPERUN'													, ; //CHAVE
	'Cod. Piperun'															, ; //DESCRICAO
	'Cod. Piperun'															, ; //DESCSPA
	'Cod. Piperun'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SUA
//
aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'UA_FILIAL+UA_PIPERUN'													, ; //CHAVE
	'PipeRun'																, ; //DESCRICAO
	'PipeRun'																, ; //DESCSPA
	'PipeRun'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SUS
//
aAdd( aSIX, { ;
	'SUS'																	, ; //INDICE
	'8'																		, ; //ORDEM
	'US_FILIAL+US_PIPERUN'													, ; //CHAVE
	'Cod. Piperun'															, ; //DESCRICAO
	'Cod. Piperun'															, ; //DESCSPA
	'Cod. Piperun'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela ZTA
//
aAdd( aSIX, { ;
	'ZTA'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZTA_FILIAL+ZTA_CODIGO+ZTA_ITEM'										, ; //CHAVE
	'Codigo+item'															, ; //DESCRICAO
	'Codigo+item'															, ; //DESCSPA
	'Codigo+item'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZTA'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZTA_FILIAL+ZTA_PIPERU+ZTA_ITEM'										, ; //CHAVE
	'Cod. integra+item'														, ; //DESCRICAO
	'Cod. integra+item'														, ; //DESCSPA
	'Cod. integra+item'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZTA'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'ZTA_FILIAL+ZTA_CODIGO+ZTA_ETAPAS'										, ; //CHAVE
	'Codigo+Cod. Etapa'														, ; //DESCRICAO
	'Codigo+Cod. Etapa'														, ; //DESCSPA
	'Codigo+Cod. Etapa'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZTA'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'ZTA_FILIAL+ZTA_ETAPAS'													, ; //CHAVE
	'Cod. Etapa'															, ; //DESCRICAO
	'Cod. Etapa'															, ; //DESCSPA
	'Cod. Etapa'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZTA'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'ZTA_FILIAL+ZTA_PIPERU+ZTA_ORDER'										, ; //CHAVE
	'Cod. integra+Order'													, ; //DESCRICAO
	'Cod. integra+Order'													, ; //DESCSPA
	'Cod. integra+Order'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		AutoGrLog( "Índice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do índice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
			lDelInd := .T. // Se for alteração precisa apagar o indice do banco
		EndIf
	EndIf

	RecLock( "SIX", !lAlt )
	For nJ := 1 To Len( aSIX[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
		EndIf
	Next nJ
	MsUnLock()

	dbCommit()

	If lDelInd
		TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
	EndIf

	oProcess:IncRegua2( "Atualizando índices ..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX6

Função de processamento da gravação do SX6 - Parâmetros

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX6()
Local aEstrut   := {}
Local aSX6      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )

AutoGrLog( "Ínicio da Atualização" + " SX6" + CRLF )

aEstrut := { "X6_FIL"    , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , ;
             "X6_DSCSPA1", "X6_DSCENG1", "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", ;
             "X6_CONTENG", "X6_PROPRI" , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG" , ;
             "X6_PYME"   }

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'7V_AVOOOP'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Ativa Visualização de orçamento de outros operador'					, ; //X6_DESCRIC
	'Ativa Visualização de orçamento de outros operador'					, ; //X6_DSCSPA
	'Ativa Visualização de orçamento de outros operador'					, ; //X6_DSCENG
	'es'																	, ; //X6_DESC1
	'es'																	, ; //X6_DSCSPA1
	'es'																	, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'7V_TMK12O1'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Linha 1 do campo observação do relatório Proposta'						, ; //X6_DESCRIC
	'Linha 1 do campo observação do relatório Proposta'						, ; //X6_DSCSPA
	'Linha 1 do campo observação do relatório Proposta'						, ; //X6_DSCENG
	'comercial'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'O prazo de entrega informado na proposta/pedido é uma previsão, podendo ser alterada por motivo de força maior ou em função da programação e disponibilidade de máquina.', ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'7V_TMK12O2'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Linha 2 do campo observação do relatório Proposta'						, ; //X6_DESCRIC
	'Linha 2 do campo observação do relatório Proposta'						, ; //X6_DSCSPA
	'Linha 2 do campo observação do relatório Proposta'						, ; //X6_DSCENG
	'comercial'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'As condições desta cotação/pedido, como preço e quantidade, também podem sofrer alterações, conforme variação do custo da resina no mercado (inflação).', ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'7V_TMK12O3'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Linha 3 do campo observação do relatório Proposta'						, ; //X6_DESCRIC
	'Linha 3 do campo observação do relatório Proposta'						, ; //X6_DSCSPA
	'Linha 3 do campo observação do relatório Proposta'						, ; //X6_DSCENG
	'comercial'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'Nesses casos, qualquer alteração será informada.'						, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_SEQBDN'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ultimo Sequencial do Arquivo BDN referente'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'ao recibo de pagamento eletronico.'									, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000000000'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'FS_GCTCOT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo Contrato para cotacao'											, ; //X6_DESCRIC
	'Tipo Contrato para cotizacion'											, ; //X6_DSCSPA
	'Contract type for quotation'											, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'001'																	, ; //X6_CONTEUD
	'001'																	, ; //X6_CONTSPA
	'001'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'001'																	, ; //X6_DEFPOR
	'001'																	, ; //X6_DEFSPA
	'001'																	, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_131SEP'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'contabiliza roteiro de primeira parcela com 13 o'						, ; //X6_DESCRIC
	'contabiliza Procedim primera cuota con aguinaldo'						, ; //X6_DSCSPA
	'Posts script of first installment with Yr-End'							, ; //X6_DSCENG
	'u FL. O roteiro deve estar marcado na SRY para con'					, ; //X6_DESC1
	'u FL. El Proced debe estar marcado en SRY para con'					, ; //X6_DSCSPA1
	'Bonus or FL. Script must be selected in SRY to be'						, ; //X6_DSCENG1
	'tabilizar.'															, ; //X6_DESC2
	'tabilizar.'															, ; //X6_DSCSPA2
	'posted to ledger.'														, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ALSERV'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Endereco do SERVIDOR para ADVPL ASP'									, ; //X6_DESCRIC
	'Endereco do SERVIDOR para ADVPL ASP'									, ; //X6_DSCSPA
	'Endereco do SERVIDOR para ADVPL ASP'									, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'10.8.3.5:7777'															, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CENT6'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Numero de casas decimais utilizadas para impressao'					, ; //X6_DESCRIC
	'Numero de digitos decimales usados para imprimir'						, ; //X6_DSCSPA
	'Number of decimal spaces used to print'								, ; //X6_DSCENG
	'Valores de moeda 6.'													, ; //X6_DESC1
	'Valores de moeda 6.'													, ; //X6_DSCSPA1
	'Valores de moeda 6.'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'2'																		, ; //X6_DEFPOR
	'2'																		, ; //X6_DEFSPA
	'2'																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CFOEXC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'desconsiderar  determinados  CFOPs  no cálculo'						, ; //X6_DESCRIC
	'desconsiderar  determinados  CFOPs  no cálculo  da'					, ; //X6_DSCSPA
	'desconsiderar  determinados  CFOPs  no cálculo  da'					, ; //X6_DSCENG
	'das exportações'														, ; //X6_DESC1
	'das exportações'														, ; //X6_DSCSPA1
	'das exportações'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CTBCLSC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'configuração para a limpeza das variáveis cacheada'					, ; //X6_DESCRIC
	'configuración para la limpieza de variables con ca'					, ; //X6_DSCSPA
	'configuration for cleaning cached variables'							, ; //X6_DSCENG
	'na contabilização. .T. ou .F.'											, ; //X6_DESC1
	'en la contabilidad. .T. o .F.'											, ; //X6_DSCSPA1
	'in accounting. .T. or .F.'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CTBSER'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita/Desabilita controle de serialização por p'					, ; //X6_DESCRIC
	'Habilita/Deshabilita control de serie por p'							, ; //X6_DSCSPA
	'Enable/Disable serialization tracking by process'						, ; //X6_DSCENG
	'rocesso OFF/ON CTB.. 1- Ligado, 2- Desligado.'							, ; //X6_DESC1
	'roceso OFF/ON CTB.. 1- Conectado, 2- Desconectado.'					, ; //X6_DSCSPA1
	'OFF/ON CTB.. 1- On, 2- Off'											, ; //X6_DSCENG1
	'3- modo  teste'														, ; //X6_DESC2
	'3- modo prueba'														, ; //X6_DSCSPA2
	'3- test mode'															, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CTBSERD'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Controle de exclusão do arquivo de semáforo.'							, ; //X6_DESCRIC
	'Control de borrado del archivo de semáforo.'							, ; //X6_DSCSPA
	'Deletion tracking for semaphore file.'									, ; //X6_DSCENG
	'.T. (true/verdadeiro)  .F. (false/ falso)'								, ; //X6_DESC1
	'.T. (true/verdadero) .F. (false/ falso)'								, ; //X6_DSCSPA1
	'.T. (true) .F. (false)'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_EIPIOUT'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Para nota de entrada de devolução'										, ; //X6_DESCRIC
	'Para nota de entrada de devolución'									, ; //X6_DSCSPA
	'For incoming return invoice'											, ; //X6_DSCENG
	'.T.-valor do IPI na tag vOutro caso MV_EIPIDEV=.T.'					, ; //X6_DESC1
	'.T.-Val IPI en tag ver otro caso MV_EIPIDEV=.T.'						, ; //X6_DSCSPA1
	'.T.-amt of IPI in tag vOutro if MV_EIPIDEV=.T.'						, ; //X6_DSCENG1
	'.F-valor do IPI na tag vIPI caso MV_EIPIDEV=.T.'						, ; //X6_DESC2
	'.F-Valor IPI en tag ver IPI caso MV_EIPIDEV=.T.'						, ; //X6_DSCSPA2
	'.F.-amt of IPI in tag vIPI if MV_EIPIDEV=.T.'							, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_INTFEPR'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'	Indica se deve integrar o evento S-2230'								, ; //X6_DESCRIC
	'Indica si debe integrar el evento S-2230'								, ; //X6_DSCSPA
	'Indicate whether to integrate event S-2230 when'						, ; //X6_DSCENG
	'ao calcular férias programadas'										, ; //X6_DESC1
	'al calcular vacaciones programadas'									, ; //X6_DSCSPA1
	'calculating scheduled vacations'										, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

/*aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MUNDMA'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Array com os campos das tabelas SA1 e SA2 que cont'					, ; //X6_DESCRIC
	'Array con los campos de tablas SA1 y SA2 que con'						, ; //X6_DSCSPA
	'Array with the fields from tables SA1 and SA2 cont'					, ; //X6_DSCENG
	'ém o código do município do cliente / fornecedor.'						, ; //X6_DESC1
	'tiene el código del municipio del Cliente / Provee'					, ; //X6_DSCSPA1
	'ing the customer/supplier city code.'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'{'SA1->A1_COD_MUN','SA2->A2_COD_MUN'}'									, ; //X6_CONTEUD
	'{'SA1->A1_COD_MUN','SA2->A2_COD_MUN'}'									, ; //X6_CONTSPA
	'{'SA1->A1_COD_MUN','SA2->A2_COD_MUN'}'									, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME
*/
aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NFEDVG'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Controla a ativação ou desativação do uso da'							, ; //X6_DESCRIC
	'Controla activación o desactivación de uso de la'						, ; //X6_DSCSPA
	'Control the activation or deactivation of the usag'					, ; //X6_DSCENG
	'funcionalidade "Naturezas de Divergencias da Nota'						, ; //X6_DESC1
	'funcionalidad "Modalidad de divergencias de'							, ; //X6_DSCSPA1
	'the feature “Divergent Natures of'										, ; //X6_DSCENG1
	'Fiscal de Entrada"'													, ; //X6_DESC2
	'Factura de entrada"'													, ; //X6_DSCSPA2
	'Incoming Invoice”'														, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NIMP2UM'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'.T. Imprime a 2ª unidade de medida p/ opera. dentr'					, ; //X6_DESCRIC
	'.T. Imprime 2ª unidad de medida p/ opera. dentr'						, ; //X6_DSCSPA
	'.T. prints the 2nd unit of measure for oper in the'					, ; //X6_DSCENG
	'o do país exeto p/ CFOP de opera. vincul. a export'					, ; //X6_DESC1
	'o del país excepto p/ CFOP de opera. vincul. a Exp'					, ; //X6_DSCSPA1
	'country but CFOP of oper bound to export'								, ; //X6_DSCENG1
	'1501,2501,5501,5502,5504,5505,6501,6502,6504,6505'						, ; //X6_DESC2
	'1501,2501,5501,5502,5504,5505,6501,6502,6504,6505'						, ; //X6_DSCSPA2
	'1501,2501,5501,5502,5504,5505,6501,6502,6504,6505'						, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NVLBKO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Usuários que podem utilizar o backorder'								, ; //X6_DESCRIC
	'Usuários que podem utilizar o backorder'								, ; //X6_DSCSPA
	'Usuários que podem utilizar o backorder'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000050#000000'															, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_PLRDEM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DESCRIC
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DSCSPA
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DSCENG
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DESC1
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DSCSPA1
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DSCENG1
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DESC2
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DSCSPA2
	'Cálcula PLR para demitidos no ano posterior a refe'					, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_PNAPRAD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Conta email adm sistema para recebimento status'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'compras/autorizacao de entregas'										, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'ti@nivel.com.br'														, ; //X6_CONTEUD
	'ti@nivel.com.br'														, ; //X6_CONTSPA
	'ti@nivel.com.br'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TMKAVDS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define os codigos de operadores que fazem parte'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'do grupo de adm de vendas no Call Center'								, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000008/000024/000017/000030/000007/000004/000036/000042/000047'		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TMKOPMS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define operador(es) master para filtro e visualiz.'					, ; //X6_DESCRIC
	'Define operador(es) master para filtro e visualiz.'					, ; //X6_DSCSPA
	'Define operador(es) master para filtro e visualiz.'					, ; //X6_DSCENG
	'tela Call Center TMKA271 (utlizado no PE TK271FIL)'					, ; //X6_DESC1
	'tela Call Center TMKA271 (utlizado no PE TK271FIL)'					, ; //X6_DSCSPA1
	'tela Call Center TMKA271 (utlizado no PE TK271FIL)'					, ; //X6_DSCENG1
	'separados por #'														, ; //X6_DESC2
	'separados por #'														, ; //X6_DSCSPA2
	'separados por #'														, ; //X6_DSCENG2
	'000047#000008#000025#000050#000027#000355#000052#000049#000057#000000#'	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ZZPVLIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Usuario que sera bloqueado para alteracao de algun'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	's campos no Pedido de Venda'											, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'JMOLIVEIRA'															, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MYTMK22C'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Unidade de rede no Cliente no qual aponta para'						, ; //X6_DESCRIC
	'A rotina automaticamente vai gravar no servidor a'						, ; //X6_DSCSPA
	'na maquina que esta executando o SmartCleint'							, ; //X6_DSCENG
	'mapeamento que contem as pastas:'										, ; //X6_DESC1
	'foto e tbm gera o backup na pasta da rede'								, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'\Protheus (fotos temporarias) e \Fotos (backup)'						, ; //X6_DESC2
	'Obs. (1) Deve criar o mapeamento como unidade'							, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'W:\'																	, ; //X6_CONTEUD
	'W:\'																	, ; //X6_CONTSPA
	'W:\'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MYTMK22S'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Pasta no servidor Protheus no qual é o repositorio'					, ; //X6_DESCRIC
	'Pasta no servidor Protheus no qual é o repositorio'					, ; //X6_DSCSPA
	'Pasta no servidor Protheus no qual é o repositorio'					, ; //X6_DSCENG
	'das fotos usada no Orcamento de Venda'									, ; //X6_DESC1
	'das fotos usada no Orcamento de Venda'									, ; //X6_DSCSPA1
	'das fotos usada no Orcamento de Venda'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'\A_COMERCIAL\Fotos'													, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_ALIAPAR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Alias da tabela de Parametros do Monitor NF'							, ; //X6_DESCRIC
	'Alias da tabela de Parametros do Monitor NF'							, ; //X6_DSCSPA
	'Alias da tabela de Parametros do Monitor NF'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'MON'																	, ; //X6_CONTEUD
	'MON'																	, ; //X6_CONTSPA
	'MON'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_EST01O'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'galonso'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_FIS08A'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de Entrada que sera filtrado na amarracao'						, ; //X6_DESCRIC
	'Tipo de Entrada que sera filtrado na amarracao'						, ; //X6_DSCSPA
	'Tipo de Entrada que sera filtrado na amarracao'						, ; //X6_DSCENG
	'entre compra de FRETE e Nota Fiscal SAIDA'								, ; //X6_DESC1
	'entre compra de FRETE e Nota Fiscal SAIDA'								, ; //X6_DSCSPA1
	'entre compra de FRETE e Nota Fiscal SAIDA'								, ; //X6_DSCENG1
	'Fonte: MYFIS08'														, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'CTE'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_FIS08C'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Numeros de dias a retroagir data de atualização'						, ; //X6_DESCRIC
	'Numeros de dias a retroagir data de atualização'						, ; //X6_DSCSPA
	'Numeros de dias a retroagir data de atualização'						, ; //X6_DSCENG
	'do vinculo de compra de frete x Nota Saida - SF1'						, ; //X6_DESC1
	'do vinculo de compra de frete x Nota Saida - SF1'						, ; //X6_DSCSPA1
	'do vinculo de compra de frete x Nota Saida - SF1'						, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'30'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_FIS08D'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Numeros de dias a retroagir data de atualização'						, ; //X6_DESCRIC
	'Numeros de dias a retroagir data de atualização'						, ; //X6_DSCSPA
	'Numeros de dias a retroagir data de atualização'						, ; //X6_DSCENG
	'do vinculo de compra de frete x Nota Saida - SF2'						, ; //X6_DESC1
	'do vinculo de compra de frete x Nota Saida - SF2'						, ; //X6_DSCSPA1
	'do vinculo de compra de frete x Nota Saida - SF2'						, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'60'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_FIS08E'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES utilizado nas operações entrada de frete sobre'					, ; //X6_DESCRIC
	'TES utilizado nas operações entrada de frete sobre'					, ; //X6_DSCSPA
	'TES utilizado nas operações entrada de frete sobre'					, ; //X6_DSCENG
	'venda, informação sera utilizada no filtro do SQL'						, ; //X6_DESC1
	'venda, informação sera utilizada no filtro do SQL'						, ; //X6_DSCSPA1
	'venda, informação sera utilizada no filtro do SQL'						, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'042,043'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_FIS08F'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Lote Contabil a ser filtrado no relatorio de'							, ; //X6_DESCRIC
	'Lote Contabil a ser filtrado no relatorio de'							, ; //X6_DSCSPA
	'Lote Contabil a ser filtrado no relatorio de'							, ; //X6_DSCENG
	'compra de frete x venda'												, ; //X6_DESC1
	'compra de frete x venda'												, ; //X6_DSCSPA1
	'compra de frete x venda'												, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'008810'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_FIS08G'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Conta Contabil a ser filtrada no relatorio de'							, ; //X6_DESCRIC
	'Conta Contabil a ser filtrada no relatorio de'							, ; //X6_DSCSPA
	'Conta Contabil a ser filtrada no relatorio de'							, ; //X6_DSCENG
	'compra de frete x venda'												, ; //X6_DESC1
	'compra de frete x venda'												, ; //X6_DSCSPA1
	'compra de frete x venda'												, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'34030201,42021108'														, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_MT103_A'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de titulos do conta a pagar a ser considerado'					, ; //X6_DESCRIC
	'Tipo de titulos do conta a pagar a ser considerado'					, ; //X6_DSCSPA
	'Tipo de titulos do conta a pagar a ser considerado'					, ; //X6_DSCENG
	'no envio e-mail de aviso para financeiro'								, ; //X6_DESC1
	'no envio e-mail de aviso para financeiro'								, ; //X6_DSCSPA1
	'no envio e-mail de aviso para financeiro'								, ; //X6_DSCENG1
	'Fonte: MT103FIM.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'PA,NDF'																, ; //X6_CONTEUD
	'PA,NDF'																, ; //X6_CONTSPA
	'PA,NDF'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_MYFIS08'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Versão do layout do CT-e usando no vinculo FRETE X'					, ; //X6_DESCRIC
	'Versão do layout do CT-e usando no vinculo FRETE X'					, ; //X6_DSCSPA
	'Versão do layout do CT-e usando no vinculo FRETE X'					, ; //X6_DSCENG
	'NOTA SAIDA.'															, ; //X6_DESC1
	'NOTA SAIDA.'															, ; //X6_DSCSPA1
	'NOTA SAIDA.'															, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3.00#'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_MYPCP02'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Flag de ativacao da rotina de trava de abertura de'					, ; //X6_DESCRIC
	'Flag de ativacao da rotina de trava de abertura de'					, ; //X6_DSCSPA
	'Flag de ativacao da rotina de trava de abertura de'					, ; //X6_DSCENG
	'Ordem de Produção sem estrutura'										, ; //X6_DESC1
	'Ordem de Produção sem estrutura'										, ; //X6_DSCSPA1
	'Ordem de Produção sem estrutura'										, ; //X6_DSCENG1
	'Fonte MYPCP02'															, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_TMK12_D'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informação do tempo de Validade da Proposta Comerc'					, ; //X6_DESCRIC
	'Informação do tempo de Validade da Proposta Comerc'					, ; //X6_DSCSPA
	'Informação do tempo de Validade da Proposta Comerc'					, ; //X6_DSCENG
	'Fonte: MYTMK12.prw'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'03 DIAS'																, ; //X6_CONTEUD
	'03 DIAS'																, ; //X6_CONTSPA
	'03 DIAS'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_TMK12_V'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Valor e Descricao por extenso do Faturamento'							, ; //X6_DESCRIC
	'Valor e Descricao por extenso do Faturamento'							, ; //X6_DSCSPA
	'Valor e Descricao por extenso do Faturamento'							, ; //X6_DSCENG
	'Minimo a ser apresentado na Proposta Comercial'						, ; //X6_DESC1
	'Minimo a ser apresentado na Proposta Comercial'						, ; //X6_DSCSPA1
	'Minimo a ser apresentado na Proposta Comercial'						, ; //X6_DSCENG1
	'Fonte: MYTMK12.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'R$ 1.200,00 (MIL E DUZENTOS REAIS) PARA CONSUMIDOR FINAL E R$ 700,00 (SETECENTOS REAIS) PARA REVENDA', ; //X6_CONTEUD
	'R$ 1.000,00 (MIL REAIS) PARA CONSUMIDOR FINAL E R$ 500,00 (QUINHENTOS REAIS) PARA REVENDA', ; //X6_CONTSPA
	'R$ 1.000,00 (MIL REAIS) PARA CONSUMIDOR FINAL E R$ 500,00 (QUINHENTOS REAIS) PARA REVENDA', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_TP_MOD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipos produto classificado como MAO DE OBRA'							, ; //X6_DESCRIC
	'Tipos produto classificado como MAO DE OBRA'							, ; //X6_DSCSPA
	'Tipos produto classificado como MAO DE OBRA'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'MO'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ZZ_TP_MPS'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipos produtos classificado como MATERIA PRIMA'						, ; //X6_DESCRIC
	'Tipos produtos classificado como MATERIA PRIMA'						, ; //X6_DSCSPA
	'Tipos produtos classificado como MATERIA PRIMA'						, ; //X6_DSCENG
	'(usado pelo custo)'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'MP,PI,PA,BV'															, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'19970101'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'MV_MUNIC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Utilizado para identificar o codigo dado a  secre-'					, ; //X6_DESCRIC
	'Usado para identificar el codigo dado a la Secre-'						, ; //X6_DSCSPA
	'Used to identify the code given from the'								, ; //X6_DSCENG
	'taria das financas do municipio para recolher o'						, ; //X6_DESC1
	'taria de Finanzas del municipio para recaudar'							, ; //X6_DSCSPA1
	'department of finances of the city for collecting'						, ; //X6_DSCENG1
	'ISS.'																	, ; //X6_DESC2
	'ISS.'																	, ; //X6_DSCSPA2
	'ISS tax.'																, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'JAGUARIUNA'															, ; //X6_CONTEUD
	'JAGUARIUNA'															, ; //X6_CONTSPA
	'JAGUARIUNA'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'19970101'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20'																	, ; //X6_CONTEUD
	'20'																	, ; //X6_CONTSPA
	'20'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'SP'																	, ; //X6_CONTEUD
	'SP'																	, ; //X6_CONTSPA
	'SP'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SP395094117111'														, ; //X6_CONTEUD
	'SP395094117111'														, ; //X6_CONTSPA
	'SP395094117111'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'29/03/24'																, ; //X6_CONTEUD
	'29/03/24'																, ; //X6_CONTSPA
	'29/03/24'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'ZZ_MYPCP05'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DESCRIC
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCSPA
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20210318'																, ; //X6_CONTEUD
	'20210318'																, ; //X6_CONTSPA
	'20210318'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_CHVNFE'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Informa se haverá consulta da'											, ; //X6_DESCRIC
	'Informa si habra consulta de'											, ; //X6_DSCSPA
	'Indicate if there is query of'											, ; //X6_DSCENG
	'NFE/CTE no portal da SEFAZ'											, ; //X6_DESC1
	'NFE/CTE en el portal de SEFAZ'											, ; //X6_DSCSPA1
	'NFE/CTE in SEFAZ portal'												, ; //X6_DSCENG1
	'.T. = Sim; .F. = Não.'													, ; //X6_DESC2
	'.T. = Si; .F. = No.'													, ; //X6_DSCSPA2
	'.T. = Yes; .F. = No.'													, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'ESCADA'																, ; //X6_CONTEUD
	'ESCADA'																, ; //X6_CONTSPA
	'ESCADA'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'19970101'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'15'																	, ; //X6_CONTEUD
	'15'																	, ; //X6_CONTSPA
	'15'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'PE'																	, ; //X6_CONTEUD
	'PE'																	, ; //X6_CONTSPA
	'PE'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'PE080566090'															, ; //X6_CONTEUD
	'PE080566090'															, ; //X6_CONTSPA
	'PE080566090'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'01/04/24'																, ; //X6_CONTEUD
	'01/04/24'																, ; //X6_CONTSPA
	'01/04/24'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'EXTREMA'																, ; //X6_CONTEUD
	'JAGUARIUNA'															, ; //X6_CONTSPA
	'JAGUARIUNA'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'20211231'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20'																	, ; //X6_CONTEUD
	'20'																	, ; //X6_CONTSPA
	'20'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'MG'																	, ; //X6_CONTEUD
	'SP'																	, ; //X6_CONTSPA
	'SP,RJ'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'MG0040463350022'														, ; //X6_CONTEUD
	'SP395094117111'														, ; //X6_CONTSPA
	'SP395094117111'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'29/03/24'																, ; //X6_CONTEUD
	'29/03/24'																, ; //X6_CONTSPA
	'29/03/24'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'ZZ_MYPCP05'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DESCRIC
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCSPA
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20210318'																, ; //X6_CONTEUD
	'20210318'																, ; //X6_CONTSPA
	'20210318'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'QUATRO BARRAS'															, ; //X6_CONTEUD
	'QUATRO BARRAS'															, ; //X6_CONTSPA
	'QUATRO BARRAS'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'19970101'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20'																	, ; //X6_CONTEUD
	'20'																	, ; //X6_CONTSPA
	'20'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'PR'																	, ; //X6_CONTEUD
	'PR'																	, ; //X6_CONTSPA
	'PR'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'PR9104898448'															, ; //X6_CONTEUD
	'PR9104898448'															, ; //X6_CONTSPA
	'PR9104898448'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'02/02/24'																, ; //X6_CONTEUD
	'02/02/24'																, ; //X6_CONTSPA
	'02/02/24'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'ZZ_MYPCP05'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DESCRIC
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCSPA
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20210318'																, ; //X6_CONTEUD
	'20210318'																, ; //X6_CONTSPA
	'20210318'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'MV_BASDANT'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Define se aplica cálculo da base do ICMS'								, ; //X6_DESCRIC
	'Define si aplica cálculo de la base del ICMS'							, ; //X6_DSCSPA
	'Defines if ICMS base calculation is applicable'						, ; //X6_DSCENG
	'Do destino em operações de entrada para'								, ; //X6_DESC1
	'Del destino en operaciones de entrada para'							, ; //X6_DSCSPA1
	'From target in entry operations to'									, ; //X6_DSCENG1
	'Contribuinte nas operações de Antecipação'								, ; //X6_DESC2
	'Contribyeinte en operaciones de Anticipación'							, ; //X6_DSCSPA2
	'Taxpayer in advance in operatios'										, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'LAURO DE FREITAS'														, ; //X6_CONTEUD
	'LAURO DE FREITAS'														, ; //X6_CONTSPA
	'LAURO DE FREITAS'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'19970101'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'10'																	, ; //X6_CONTEUD
	'05'																	, ; //X6_CONTSPA
	'05'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'BA'																	, ; //X6_CONTEUD
	'BA'																	, ; //X6_CONTSPA
	'BA'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'BA01224632'															, ; //X6_CONTEUD
	'BA01224632'															, ; //X6_CONTSPA
	'BA01224632'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'02/03/24'																, ; //X6_CONTEUD
	'02/03/24'																, ; //X6_CONTSPA
	'02/03/24'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0301'																	, ; //X6_FIL
	'ZZ_MYPCP05'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'LAU - ID da ultima previsao de venda (SC4)'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'MV_BASDANT'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Define se aplica cálculo da base do ICMS'								, ; //X6_DESCRIC
	'Define si aplica cálculo de la base del ICMS'							, ; //X6_DSCSPA
	'Defines if ICMS base calculation is applicable'						, ; //X6_DSCENG
	'Do destino em operações de entrada para'								, ; //X6_DESC1
	'Del destino en operaciones de entrada para'							, ; //X6_DSCSPA1
	'From target in entry operations to'									, ; //X6_DSCENG1
	'Contribuinte nas operações de Antecipação'								, ; //X6_DESC2
	'Contribyeinte en operaciones de Anticipación'							, ; //X6_DSCSPA2
	'Taxpayer in advance in operatios'										, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'IBIPORA'																, ; //X6_CONTEUD
	'IBIPORA'																, ; //X6_CONTSPA
	'IBIPORA'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20'																	, ; //X6_CONTEUD
	'20'																	, ; //X6_CONTSPA
	'20'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'PR'																	, ; //X6_CONTEUD
	'PR'																	, ; //X6_CONTSPA
	'PR'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'MV_RESPTEC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Indica se deverá enviar o grupo do resp. técnico'						, ; //X6_DESCRIC
	'Indica si debe enviar el grupo del Resp. Técnico.'						, ; //X6_DSCSPA
	'Indicate whether to send technical resp. group'						, ; //X6_DSCENG
	'por documento, onde 0-todos,1-NFE,2-MDe.'								, ; //X6_DESC1
	'por documento, donde 0-todos,1-E-FACT,2-e-MD.'							, ; //X6_DSCSPA1
	'per document, where 0-All,1-E-Invoice,2-MDe'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'PR6050047170'															, ; //X6_CONTEUD
	'PR6050047170'															, ; //X6_CONTSPA
	'PR6050047170'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'29/03/24'																, ; //X6_CONTEUD
	'29/03/24'																, ; //X6_CONTSPA
	'29/03/24'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0401'																	, ; //X6_FIL
	'ZZ_MYPCP05'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'IBI - ID da ultima previsao de venda (SC4)'							, ; //X6_DESCRIC
	'IBI - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCSPA
	'IBI - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'JAGUARIUNA'															, ; //X6_CONTEUD
	'JAGUARIUNA'															, ; //X6_CONTSPA
	'JAGUARIUNA'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'19970101'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20'																	, ; //X6_CONTEUD
	'20'																	, ; //X6_CONTSPA
	'20'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'SP'																	, ; //X6_CONTEUD
	'SP'																	, ; //X6_CONTSPA
	'SP'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SP395094117111'														, ; //X6_CONTEUD
	'SP395094117111'														, ; //X6_CONTSPA
	'SP395094117111'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'27/04/22'																, ; //X6_CONTEUD
	'27/04/22'																, ; //X6_CONTSPA
	'27/04/22'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0501'																	, ; //X6_FIL
	'ZZ_MYPCP05'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DESCRIC
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCSPA
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20210318'																, ; //X6_CONTEUD
	'20210318'																, ; //X6_CONTSPA
	'20210318'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'INDAIATUBA'															, ; //X6_CONTEUD
	'INDAIATUBA'															, ; //X6_CONTSPA
	'INDAIATUBA'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'19970101'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20'																	, ; //X6_CONTEUD
	'20'																	, ; //X6_CONTSPA
	'20'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'SP'																	, ; //X6_CONTEUD
	'SP'																	, ; //X6_CONTSPA
	'SP'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'MV_TAFSURL'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'URL de comunicacao com o TSS no produto TAF'							, ; //X6_DESCRIC
	'URL de comunicacion con el TSS en el producto TAF'						, ; //X6_DSCSPA
	'URL of communication with TSS in TAF product'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'10.8.3.5:9194'															, ; //X6_CONTEUD
	'10.8.3.5:9194'															, ; //X6_CONTSPA
	'10.8.3.5:9194'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'02/02/24'																, ; //X6_CONTEUD
	'02/02/24'																, ; //X6_CONTSPA
	'02/02/24'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0601'																	, ; //X6_FIL
	'ZZ_MYPCP05'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DESCRIC
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCSPA
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20210318'																, ; //X6_CONTEUD
	'20210318'																, ; //X6_CONTSPA
	'20210318'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'MV_CIDADE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe o nome do município em que o contribuinte'						, ; //X6_DESCRIC
	'Informar en este parametro el nombre del municipio'					, ; //X6_DSCSPA
	'Enter the name of the city referring to the Tax'						, ; //X6_DSCENG
	'esta estabelecido.'													, ; //X6_DESC1
	'donde el Contribuyente esta establecido'								, ; //X6_DSCSPA1
	'Payer in this parameter'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'INDAIATUBA'															, ; //X6_CONTEUD
	'INDAIATUBA'															, ; //X6_CONTSPA
	'INDAIATUBA'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'MV_DBLQMOV'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data para bloqueio de movimentos. Não podem ser'						, ; //X6_DESCRIC
	'Fecha para bloquear movimientos. No se podran'							, ; //X6_DSCSPA
	'Date for blockage of movements. Movements with'						, ; //X6_DSCENG
	'alterados / criados / excluidos movimentos com'						, ; //X6_DESC1
	'alterar / crear / excluir movimientos con fecha'						, ; //X6_DSCSPA1
	'date lower or equal to the date entered in the'						, ; //X6_DSCENG1
	'data menor ou igual a data informada no parametro.'					, ; //X6_DESC2
	'menor o igual a la informada en el parametro.'							, ; //X6_DSCSPA2
	'parameter cannot be altered / created / deleted.'						, ; //X6_DSCENG2
	'19970101'																, ; //X6_CONTEUD
	'19970101'																, ; //X6_CONTSPA
	'19970101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'MV_DIAISS'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Dia padrao para gerar os titulos de  ISS.'								, ; //X6_DESCRIC
	'Dia estandar para emitir los titulos del ISS.'							, ; //X6_DSCSPA
	'Standard day for generating ISS bills.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20'																	, ; //X6_CONTEUD
	'20'																	, ; //X6_CONTSPA
	'20'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'MV_ESTADO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sigla do estado da empresa usuaria do Sistema, pa-'					, ; //X6_DESCRIC
	'Abreviatura de la estado de la empresa usuaria'						, ; //X6_DSCSPA
	'State abbreviation referring to the system user'						, ; //X6_DSCENG
	'ra efeito de calculo de ICMS (7, 12 ou 18%).'							, ; //X6_DESC1
	'del sistema a efectos de calculo del ICMS'								, ; //X6_DSCSPA1
	'code, for the purpose of calculating the'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	'(7, 12 o 18%).'														, ; //X6_DSCSPA2
	'ICMS (7,12 OR 18%).'													, ; //X6_DSCENG2
	'SP'																	, ; //X6_CONTEUD
	'SP'																	, ; //X6_CONTSPA
	'SP'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'MV_ESTICM'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Aliquota de ICMS de cada estado. Informar a sigla'						, ; //X6_DESCRIC
	'Alicuota del ICMS de cada estado. Informe la'							, ; //X6_DSCSPA
	'Value added tax rate of each state. Enter the'							, ; //X6_DSCENG
	'e em seguida a aliquota, para calculo de ICMS com-'					, ; //X6_DESC1
	'abreviatura y tambien la alicuota para el calculo'						, ; //X6_DSCSPA1
	'initials followed by the rate, to the calculation'						, ; //X6_DSCENG1
	'plementar.'															, ; //X6_DESC2
	'del ICMS complementario.'												, ; //X6_DSCSPA2
	'of the complementary value added tax.'									, ; //X6_DSCENG2
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTEUD
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTSPA
	'AC019AL019AM18AP018BA20.50CE7DF20ES017GO19MA020MG18MS17MT17PA19PB20PE20PI21PR19.50RJ20RN18RO19.50RR17RS17.5SC17SE22SP18TO20EX18', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'MV_SUBTRIB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Numero da Inscricao Estadual do contribuinte'							, ; //X6_DESCRIC
	'Numero de Inscripcion Provincial del contribuyente'					, ; //X6_DSCSPA
	'Taxpayer State Insc.number in another state when'						, ; //X6_DSCENG
	'em outro estado quando houver Substituicao'							, ; //X6_DESC1
	'en otro estado cuando hubiera Sustitucion'								, ; //X6_DSCSPA1
	'there is Tax Override.'												, ; //X6_DSCENG1
	'Tributaria'															, ; //X6_DESC2
	'Tributaria'															, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SP353600352115'														, ; //X6_CONTEUD
	'SP353600352115'														, ; //X6_CONTSPA
	'SP353600352115'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'MV_ZZBLTES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES que obrigam a digitacao da OP no ducmento de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Entrada'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'091;095;09G;099;09F;295'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'ZZ_FIS08B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Data da ultimo atualização de informação do'							, ; //X6_DESCRIC
	'Data da ultimo atualização de informação do'							, ; //X6_DSCSPA
	'Data da ultimo atualização de informação do'							, ; //X6_DSCENG
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DESC1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCSPA1
	'vinculo entre compra de FRETE e nota SAIDA'							, ; //X6_DSCENG1
	'Fonte: MYFIS08.prw'													, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'02/02/24'																, ; //X6_CONTEUD
	'02/02/24'																, ; //X6_CONTSPA
	'02/02/24'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0701'																	, ; //X6_FIL
	'ZZ_MYPCP05'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DESCRIC
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCSPA
	'JAG - ID da ultima previsao de venda (SC4)'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20210318'																, ; //X6_CONTEUD
	'20210318'																, ; //X6_CONTSPA
	'20210318'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( "SX6" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX6 )
	lContinua := .F.
	lReclock  := .F.

	If !SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
		lContinua := .T.
		lReclock  := .T.
		AutoGrLog( "Foi incluído o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]" )
	EndIf

	If lContinua
		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + "/"
		EndIf

		RecLock( "SX6", lReclock )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
	EndIf

	oProcess:IncRegua2( "Atualizando Arquivos (SX6) ..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX7

Função de processamento da gravação do SX7 - Gatilhos

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX7()
Local aEstrut   := {}
Local aAreaSX3  := SX3->( GetArea() )
Local aSX7      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

AutoGrLog( "Ínicio da Atualização" + " SX7" + CRLF )

aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
             "X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }

//
// Campo A1_XCONT1
//
aAdd( aSX7, { ;
	'A1_XCONT1'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SU5->U5_CONTAT'														, ; //X7_REGRA
	'A1_XNCONT1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->A1_XCONT1'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_XCONT1'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SU5->U5_EMAIL'															, ; //X7_REGRA
	'A1_ECONT1'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->A1_XCONT1'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A1_XCONT2
//
aAdd( aSX7, { ;
	'A1_XCONT2'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SU5->U5_CONTAT'														, ; //X7_REGRA
	'A1_XNCONT2'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->A1_XCONT2'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_XCONT2'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SU5->U5_EMAIL'															, ; //X7_REGRA
	'A1_ECONT2'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->A1_XCONT2'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A1_XCONTAC
//
aAdd( aSX7, { ;
	'A1_XCONTAC'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SU5->U5_CONTAT'														, ; //X7_REGRA
	'A1_XNCONTA'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->A1_XCONTAC'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_XCONTAC'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SU5->U5_EMAIL'															, ; //X7_REGRA
	'A1_XECONTA'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->A1_XCONTAC'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A3_XFUNIL
//
aAdd( aSX7, { ;
	'A3_XFUNIL'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'ZTA->ZTA_FUNIL'														, ; //X7_REGRA
	'A3_XDFUNIL'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'ZTA'																	, ; //X7_ALIAS
	2																		, ; //X7_ORDEM
	'FWXFILIAL("ZTA")+M->A3_XFUNIL'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A3_XFUNIL1
//
aAdd( aSX7, { ;
	'A3_XFUNIL1'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'ZTA->ZTA_FUNIL'														, ; //X7_REGRA
	'A3_XDFUNI1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'ZTA'																	, ; //X7_ALIAS
	2																		, ; //X7_ORDEM
	'FWXFILIAL("ZTA")+M->A3_XFUNIL1'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A3_XFUNIL2
//
aAdd( aSX7, { ;
	'A3_XFUNIL2'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'ZTA->ZTA_FUNIL'														, ; //X7_REGRA
	'A3_XDFUNI2'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'ZTA'																	, ; //X7_ALIAS
	2																		, ; //X7_ORDEM
	'FWXFILIAL("ZTA")+M->A3_FUNIL2'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A3_XFUNIL3
//
aAdd( aSX7, { ;
	'A3_XFUNIL3'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'ZTA->ZTA_FUNIL'														, ; //X7_REGRA
	'A3_XDFUNI3'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'ZTA'																	, ; //X7_ALIAS
	2																		, ; //X7_ORDEM
	'FWXFILIAL("ZTA")+M->A3_XFUNIL3'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A3_XFUNIL4
//
aAdd( aSX7, { ;
	'A3_XFUNIL4'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'ZTA->ZTA_FUNIL'														, ; //X7_REGRA
	'A3_XDFUNI4'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'ZTA'																	, ; //X7_ALIAS
	2																		, ; //X7_ORDEM
	'FWXFILIAL("ZTA")+M->A3_XFUNIL4'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo U5_XCLIENT
//
aAdd( aSX7, { ;
	'U5_XCLIENT'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SA1->A1_NOME'															, ; //X7_REGRA
	'U5_XNEMP'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SA1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SA1")+M->U5_XCLIENT+M->U5_XLOJA'							, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo US_XCONT1
//
aAdd( aSX7, { ;
	'US_XCONT1'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SU5->U5_CONTAT'														, ; //X7_REGRA
	'US_XNCONT1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->US_XCONT1'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'US_XCONT1'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SU5->U5_EMAIL'															, ; //X7_REGRA
	'US_XECONT1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->US_XCONT1'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo US_XCONT2
//
aAdd( aSX7, { ;
	'US_XCONT2'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SU5->U5_CONTAT'														, ; //X7_REGRA
	'US_XNCONT2'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->US_XCONT2'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'US_XCONT2'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SU5->U5_EMAIL'															, ; //X7_REGRA
	'US_XECONT2'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->US_XCONT2'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo US_XCONTAC
//
aAdd( aSX7, { ;
	'US_XCONTAC'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SU5->U5_CONTAT'														, ; //X7_REGRA
	'US_XNCONTA'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->US_XCONTAC'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'US_XCONTAC'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SU5->U5_EMAIL'															, ; //X7_REGRA
	'US_XECONTA'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'FWXFILIAL("SU5")+M->US_XCONTAC'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

		AutoGrLog( "Foi incluído o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )

		RecLock( "SX7", .T. )
		For nJ := 1 To Len( aSX7[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		If SX3->( dbSeek( SX7->X7_CAMPO ) )
			RecLock( "SX3", .F. )
			SX3->X3_TRIGGER := "S"
			MsUnLock()
		EndIf

	EndIf
	oProcess:IncRegua2( "Atualizando Arquivos (SX7) ..." )

Next nI

RestArea( aAreaSX3 )

AutoGrLog( CRLF + "Final da Atualização" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXA

Função de processamento da gravação do SXA - Pastas

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSXA()
Local aEstrut   := {}
Local aSXA      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nPosAgr   := 0
Local lAlterou  := .F.

AutoGrLog( "Ínicio da Atualização" + " SXA" + CRLF )

aEstrut := { "XA_ALIAS"  , "XA_ORDEM"  , "XA_DESCRIC", "XA_DESCSPA", "XA_DESCENG", "XA_AGRUP"  , "XA_TIPO"   , ;
             "XA_PROPRI" }


//
// Tabela SA1
//
aAdd( aSXA, { ;
	'SA1'																	, ; //XA_ALIAS
	'5'																		, ; //XA_ORDEM
	'Definicoes'															, ; //XA_DESCRIC
	'Definicoes'															, ; //XA_DESCSPA
	'Definicoes'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SA1'																	, ; //XA_ALIAS
	'5'																		, ; //XA_ORDEM
	'Definicoes'															, ; //XA_DESCRIC
	'Definicoes'															, ; //XA_DESCSPA
	'Definicoes'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SA1'																	, ; //XA_ALIAS
	'6'																		, ; //XA_ORDEM
	'Int. Piperun'															, ; //XA_DESCRIC
	'Int. Piperun'															, ; //XA_DESCSPA
	'Int. Piperun'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SA1'																	, ; //XA_ALIAS
	'7'																		, ; //XA_ORDEM
	'Contatos'																, ; //XA_DESCRIC
	'Contatos'																, ; //XA_DESCSPA
	'Contatos'																, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

//
// Tabela SA3
//
aAdd( aSXA, { ;
	'SA3'																	, ; //XA_ALIAS
	'6'																		, ; //XA_ORDEM
	'Int. Piperun'															, ; //XA_DESCRIC
	'Int. Piperun'															, ; //XA_DESCSPA
	'Int. Piperun'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

//
// Tabela SB1
//
aAdd( aSXA, { ;
	'SB1'																	, ; //XA_ALIAS
	'9'																		, ; //XA_ORDEM
	'Definicoes'															, ; //XA_DESCRIC
	'Definicoes'															, ; //XA_DESCSPA
	'Definicoes'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SB1'																	, ; //XA_ALIAS
	'9'																		, ; //XA_ORDEM
	'Definicoes'															, ; //XA_DESCRIC
	'Definicoes'															, ; //XA_DESCSPA
	'Definicoes'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

//
// Tabela SC5
//
aAdd( aSXA, { ;
	'SC5'																	, ; //XA_ALIAS
	'1'																		, ; //XA_ORDEM
	'PADRAO'																, ; //XA_DESCRIC
	'PADRAO'																, ; //XA_DESCSPA
	'PADRAO'																, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SC5'																	, ; //XA_ALIAS
	'1'																		, ; //XA_ORDEM
	'PADRAO'																, ; //XA_DESCRIC
	'PADRAO'																, ; //XA_DESCSPA
	'PADRAO'																, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SC5'																	, ; //XA_ALIAS
	'2'																		, ; //XA_ORDEM
	'DEFINICOES'															, ; //XA_DESCRIC
	'DEFINICOES'															, ; //XA_DESCSPA
	'DEFINICOES'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SC5'																	, ; //XA_ALIAS
	'2'																		, ; //XA_ORDEM
	'DEFINICOES'															, ; //XA_DESCRIC
	'DEFINICOES'															, ; //XA_DESCSPA
	'DEFINICOES'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

//
// Tabela SF4
//
aAdd( aSXA, { ;
	'SF4'																	, ; //XA_ALIAS
	'4'																		, ; //XA_ORDEM
	'Definicoes'															, ; //XA_DESCRIC
	'Definicoes'															, ; //XA_DESCSPA
	'Definicoes'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SF4'																	, ; //XA_ALIAS
	'4'																		, ; //XA_ORDEM
	'Definicoes'															, ; //XA_DESCRIC
	'Definicoes'															, ; //XA_DESCSPA
	'Definicoes'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

//
// Tabela SU5
//
aAdd( aSXA, { ;
	'SU5'																	, ; //XA_ALIAS
	'4'																		, ; //XA_ORDEM
	'Int. Piperun'															, ; //XA_DESCRIC
	'Int. Piperun'															, ; //XA_DESCSPA
	'Int. Piperun'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SU5'																	, ; //XA_ALIAS
	'5'																		, ; //XA_ORDEM
	'Empresa'																, ; //XA_DESCRIC
	'Empresa'																, ; //XA_DESCSPA
	'Empresa'																, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

//
// Tabela SUA
//
aAdd( aSXA, { ;
	'SUA'																	, ; //XA_ALIAS
	'1'																		, ; //XA_ORDEM
	'PADRAO'																, ; //XA_DESCRIC
	'PADRAO'																, ; //XA_DESCSPA
	'PADRAO'																, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SUA'																	, ; //XA_ALIAS
	'1'																		, ; //XA_ORDEM
	'PADRAO'																, ; //XA_DESCRIC
	'PADRAO'																, ; //XA_DESCSPA
	'PADRAO'																, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SUA'																	, ; //XA_ALIAS
	'1'																		, ; //XA_ORDEM
	'PipeRun'																, ; //XA_DESCRIC
	'PipeRun'																, ; //XA_DESCSPA
	'PipeRun'																, ; //XA_DESCENG
	'A00'																	, ; //XA_AGRUP
	'1'																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SUA'																	, ; //XA_ALIAS
	'2'																		, ; //XA_ORDEM
	'DEFINICOES'															, ; //XA_DESCRIC
	'DEFINICOES'															, ; //XA_DESCSPA
	'DEFINICOES'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SUA'																	, ; //XA_ALIAS
	'2'																		, ; //XA_ORDEM
	'DEFINICOES'															, ; //XA_DESCRIC
	'DEFINICOES'															, ; //XA_DESCSPA
	'DEFINICOES'															, ; //XA_DESCENG
	''																		, ; //XA_AGRUP
	''																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

//
// Tabela SUS
//
aAdd( aSXA, { ;
	'SUS'																	, ; //XA_ALIAS
	'B'																		, ; //XA_ORDEM
	'Piperun'																, ; //XA_DESCRIC
	'Piperun'																, ; //XA_DESCSPA
	'Piperun'																, ; //XA_DESCENG
	'PIP'																	, ; //XA_AGRUP
	'1'																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

aAdd( aSXA, { ;
	'SUS'																	, ; //XA_ALIAS
	'C'																		, ; //XA_ORDEM
	'Contato'																, ; //XA_DESCRIC
	'Contato'																, ; //XA_DESCSPA
	'Contato'																, ; //XA_DESCENG
	'CON'																	, ; //XA_AGRUP
	'1'																		, ; //XA_TIPO
	'U'																		} ) //XA_PROPRI

nPosAgr := aScan( aEstrut, { |x| AllTrim( x ) == "XA_AGRUP" } )

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSXA ) )

dbSelectArea( "SXA" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXA )

	If SXA->( dbSeek( aSXA[nI][1] + aSXA[nI][2] ) )

		lAlterou := .F.

		While !SXA->( EOF() ).AND.  SXA->( XA_ALIAS + XA_ORDEM ) == aSXA[nI][1] + aSXA[nI][2]

			If SXA->XA_AGRUP == aSXA[nI][nPosAgr]
				RecLock( "SXA", .F. )
				For nJ := 1 To Len( aSXA[nI] )
					If FieldPos( aEstrut[nJ] ) > 0 .AND. Alltrim(AllToChar(SXA->( FieldGet( nJ ) ))) <> Alltrim(AllToChar(aSXA[nI][nJ]))
						FieldPut( FieldPos( aEstrut[nJ] ), aSXA[nI][nJ] )
						lAlterou := .T.
					EndIf
				Next nJ
				dbCommit()
				MsUnLock()
			EndIf

			SXA->( dbSkip() )

		End

		If lAlterou
			AutoGrLog( "Foi alterada a pasta " + aSXA[nI][1] + "/" + aSXA[nI][2] + "  " + aSXA[nI][3] )
		EndIf

	Else

		RecLock( "SXA", .T. )
		For nJ := 1 To Len( aSXA[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSXA[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()

		AutoGrLog( "Foi incluída a pasta " + aSXA[nI][1] + "/" + aSXA[nI][2] + "  " + aSXA[nI][3] )

	EndIf

oProcess:IncRegua2( "Atualizando Arquivos (SXA) ..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SXA" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXB

Função de processamento da gravação do SXB - Consultas Padrao

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSXB()
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0

AutoGrLog( "Ínicio da Atualização" + " SXB" + CRLF )

aEstrut := { "XB_ALIAS"  , "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , "XB_DESCRI" , "XB_DESCSPA", "XB_DESCENG", ;
             "XB_WCONTEM", "XB_CONTEM" }


//
// Consulta ZTA
//
aAdd( aSXB, { ;
	'ZTA'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Funil de vendas'														, ; //XB_DESCRI
	'Funil de vendas'														, ; //XB_DESCSPA
	'Funil de vendas'														, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo+item'															, ; //XB_DESCRI
	'Codigo+item'															, ; //XB_DESCSPA
	'Codigo+item'															, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA'																	, ; //XB_ALIAS
	'3'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cadastra Novo'															, ; //XB_DESCRI
	'Incluye Nuevo'															, ; //XB_DESCSPA
	'Add New'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'01'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Funil'																	, ; //XB_DESCRI
	'Funil'																	, ; //XB_DESCSPA
	'Funil'																	, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_FUNIL'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Descrição'																, ; //XB_DESCRI
	'Descrição'																, ; //XB_DESCSPA
	'Descrição'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_DESC'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Cod. integra'															, ; //XB_DESCRI
	'Cod. integra'															, ; //XB_DESCSPA
	'Cod. integra'															, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_PIPERU'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA->ZTA_PIPERU'														} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA'																	, ; //XB_ALIAS
	'6'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	"ZTA->ZTA_ITEM == '001'"												} ) //XB_CONTEM

//
// Consulta ZTA_E
//
aAdd( aSXB, { ;
	'ZTA_E'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Etapas do Funil'														, ; //XB_DESCRI
	'Etapas do Funil'														, ; //XB_DESCSPA
	'Etapas do Funil'														, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_E'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Codigo+cod. Etapa'														, ; //XB_DESCRI
	'Codigo+cod. Etapa'														, ; //XB_DESCSPA
	'Codigo+cod. Etapa'														, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_E'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Order'																	, ; //XB_DESCRI
	'Order'																	, ; //XB_DESCSPA
	'Order'																	, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_ORDER'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_E'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Cod. Etapa'															, ; //XB_DESCRI
	'Cod. Etapa'															, ; //XB_DESCSPA
	'Cod. Etapa'															, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_ETAPAS'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_E'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Nome Etapa'															, ; //XB_DESCRI
	'Nome Etapa'															, ; //XB_DESCSPA
	'Nome Etapa'															, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_DESCET'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_E'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA->ZTA_ETAPAS'														} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_E'																	, ; //XB_ALIAS
	'6'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	"ZTA->ZTA_FILIAL ==  FWxFilial('SA3') .AND. ZTA->ZTA_PIPERU == M->UA_XFUNIL"} ) //XB_CONTEM

//
// Consulta ZTA_F
//
aAdd( aSXB, { ;
	'ZTA_F'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Funil de vendas'														, ; //XB_DESCRI
	'Funil de vendas'														, ; //XB_DESCSPA
	'Funil de vendas'														, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_F'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo+item'															, ; //XB_DESCRI
	'Codigo+item'															, ; //XB_DESCSPA
	'Codigo+item'															, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_F'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Codigo'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_CODIGO'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_F'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Funil'																	, ; //XB_DESCRI
	'Funil'																	, ; //XB_DESCSPA
	'Funil'																	, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_FUNIL'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_F'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Descrição'																, ; //XB_DESCRI
	'Descrição'																, ; //XB_DESCSPA
	'Descrição'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA_DESC'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_F'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZTA->ZTA_PIPERU'														} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZTA_F'																	, ; //XB_ALIAS
	'6'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	"ZTA->ZTA_ITEM == '001' .and. PipeRun.Pipelines.u_filtraFunil()"		} ) //XB_CONTEM

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

	If !Empty( aSXB[nI][1] )

		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				AutoGrLog( "Foi incluída a consulta padrão " + aSXB[nI][1] )
			EndIf

			RecLock( "SXB", .T. )

			For nJ := 1 To Len( aSXB[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
				EndIf
			Next nJ

			dbCommit()
			MsUnLock()

		Else

			//
			// Verifica todos os campos
			//
			For nJ := 1 To Len( aSXB[nI] )

				//
				// Se o campo estiver diferente da estrutura
				//
				If !StrTran( AllToChar( SXB->( FieldGet( FieldPos( aEstrut[nJ] ) ) ) ), " ", "" ) == ;
					StrTran( AllToChar( aSXB[nI][nJ] ), " ", "" )

					cMsg := "A consulta padrão " + aSXB[nI][1] + " está com o " + SXB->( FieldName( FieldPos( aEstrut[nJ] ) ) ) + ;
					" com o conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( SXB->( FieldGet( FieldPos( aEstrut[nJ] ) ) ) ) ) + "]" + CRLF + ;
					", e este é diferente do conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SXB" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SXB e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SXB que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						RecLock( "SXB", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
						dbCommit()
						MsUnLock()

						If !( aSXB[nI][1] $ cAlias )
							cAlias += aSXB[nI][1] + "/"
							AutoGrLog( "Foi alterada a consulta padrão " + aSXB[nI][1] )
						EndIf

					EndIf

				EndIf

			Next

		EndIf

	EndIf

	oProcess:IncRegua2( "Atualizando Consultas Padrões (SXB) ..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
             Se não for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Parâmetro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta só com Empresas
// 3 - Monta só com Filiais de uma Empresa
//
// Parâmetro  aMarcadas
// Vetor com Empresas/Filiais pré marcadas
//
// Parâmetro  cEmpSel
// Empresa que será usada para montar seleção
//---------------------------------------------
Local   aRet      := {}
Local   aSalvAmb  := GetArea()
Local   aSalvSM0  := {}
Local   aVetor    := {}
Local   cMascEmp  := "??"
Local   cVar      := ""
Local   lChk      := .F.
Local   lOk       := .F.
Local   lTeveMarc := .F.
Local   oNo       := LoadBitmap( GetResources(), "LBNO" )
Local   oOk       := LoadBitmap( GetResources(), "LBOK" )
Local   oDlg, oChkMar, oLbx, oMascEmp, oSay
Local   oButDMar, oButInv, oButMarc, oButOk, oButCanc

Local   aMarcadas := {}


If !MyOpenSm0(.F.)
	Return aRet
EndIf


dbSelectArea( "SM0" )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf

	dbSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos" Message "Marca / Desmarca"+ CRLF + "Todos" Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
@ 113, 51 Say   oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Máscara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "máscara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "máscara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDEXP" ) ) ) ;
Message "Confirma a seleção e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplicação" Of oDlg
oButCanc:SetCss( CSSBOTAO )

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Função auxiliar para marcar/desmarcar todos os ítens do ListBox ativo

@param lMarca  Contéudo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao
Função auxiliar para inverter a seleção do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao
Função auxiliar que monta o retorno com as seleções

@param aRet    Array que terá o retorno das seleções (é alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas
Função para marcar/desmarcar usando máscaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a máscara (???)
@param lMarDes  Marca a ser atribuída .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] := lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos
Função auxiliar para verificar se estão todos marcados ou não

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0

Função de processamento abertura do SM0 modo exclusivo

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0( lShared )
Local lOpen := .F.
Local nLoop := 0

If FindFunction( "OpenSM0Excl" )
	For nLoop := 1 To 20
		If OpenSM0Excl(,.F.)
			lOpen := .T.
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop
Else
	For nLoop := 1 To 20
		dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop
EndIf

If !lOpen
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog

Função de leitura do LOG gerado com limitacao de string

@author UPDATE gerado automaticamente
@since  04/08/2024
@obs    Gerado por EXPORDIC - V.7.6.3.4 EFS / Upd. V.6.4.1 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function LeLog()
Local cRet  := ""
Local cFile := NomeAutoLog()
Local cAux  := ""

FT_FUSE( cFile )
FT_FGOTOP()

While !FT_FEOF()

	cAux := FT_FREADLN()

	If Len( cRet ) + Len( cAux ) < 1048000
		cRet += cAux + CRLF
	Else
		cRet += CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		cRet += "Tamanho de exibição maxima do LOG alcançado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf

	FT_FSKIP()
End

FT_FUSE()

Return cRet


/////////////////////////////////////////////////////////////////////////////
