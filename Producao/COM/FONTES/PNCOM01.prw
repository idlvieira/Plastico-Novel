/* Defines/Includes */
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"
#Include "Protheus.CH"
 
/*/{Protheus.doc} PNCOM01
Atualizacao das datas de previsao de entreg para controle e emissao
da provisao financeira
@type user function
@version  1.0
@author celso.costa
@since 11/03/2022
@return variant, return_description
/*/
User Function PNCOM01()

/* Variaveis Locais */
Local oDlg
Local oPanel
Local _btnEnviar
Local _nCont
//Local _cPerg		:= FunName()
Local _aSize		:= MsAdvSize( .F. )
Local _nMSEsq		:= _aSize[ 07 ]
Local _nMIEsq		:= 00
Local _nMIDir		:= _aSize[ 06 ]
Local _nMSDir		:= _aSize[ 05 ]
Local _nWidth		:= 00
Local _bConfirma	:= {|| MsAguarde( { || fPNCM01g() } ) } 
//Local _bAct001
//Local _bAct002

/* Variaveis Private */
Private _cPedido	:= Space( TamSx3( "C7_NUM" )[ 01 ] )
Private _cFornece	:= Space( TamSx3( "A2_COD" )[ 01 ] )
Private _aCampos	:= {}, _aColunas := {}, _aFields := {}, _aSeek := {}, _aFiltro := {}
Private _aDados	:= {}
Private _lEditar	:= .T.
Private _lDtPrFin	:= 00
Private oDtPrFin	:= Nil
Private oBrowse	:= FWBrowse():New()
Private oPedido, oFornece, btnConfirma, btnCancela
    
/* Ajusta/cria pergunte */
// AjustaSX1( _cPerg )
// Pergunte( _cPerg, .F. )

/* Campos para exibicao */
_aCampos	:= {	"C7_NUM"			,;
					"C7_FORNECE"	,;
					"C7_LOJA"		,;
					"C7_ITEM"		,;
					"C7_PRODUTO"	,;
					"C7_UM"			,;
					"C7_DESCRI"		,;
					"C7_QUANT"		,;
					"C7_PRECO"		,;
					"C7_TOTAL"		,;
					"C7_QUJE"		,;
					"C7_NUMSC"		,;
					"C7_ITEMSC"		,;
					"C7_DATPRF"		,;
					"C7_ZZDATPR"	}

/* FrontEnd */
Define MsDialog oDlg Title "Previsao de entrega para provisao financeira" From _nMSEsq, _nMIEsq To _nMIDir, _nMSDir Of oMainWnd Pixel STYLE nOR( WS_VISIBLE, WS_POPUP )

oDlg:lMaximized := .T.
 
// SetKey( VK_F5, fFunctionKEY() )

/* Superior tela */
dbSelectArea( "SX3" )
SX3->( dbSetOrder( 02 ) )

For _nCont := 01 To Len( _aCampos )

	SX3->( dbSeek( _aCampos[ _nCont ] ) )
        
	aAdd( _aColunas, MontaColunas( "{|| _aDados[oBrowse:nAt," + cValToChar( _nCont ) + "] }", _aDados ) )
        
	If SX3->X3_CONTEXT == "V"

		aAdd( _aFields, {	SX3->X3_CAMPO											,;
								X3Titulo()												,;
								SX3->X3_TIPO											,;
								SX3->X3_TAMANHO										,;
								SX3->X3_DECIMAL										,;
								PesqPict( SX3->X3_ARQUIVO, SX3->X3_CAMPO, )	,;
								AllTrim( X3CBox() )									,;
								SX3->X3_F3												,;
								{|| .T. }												,;
								Nil														} )
		/* Filtro de pesquisa de determinados campos */
		If Alltrim( SX3->X3_CAMPO ) $ "C7_NUM|C7_FORNECE|C7_PRODUTO|C7_NUMSC"

			aAdd( _aFiltro, { SX3->X3_CAMPO, X3Titulo(), SX3->X3_TIPO, SX3->X3_TAMANHO, 05, PesqPict( SX3->X3_ARQUIVO, SX3->X3_CAMPO, ) } )
			aAdd( _aSeek, { X3Titulo(), { { "", SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_TAMANHO, 05, SX3->X3_CAMPO } } } )
		
		EndIf

	EndIf
        
Next _nCont
    
/* Endereca Browse */
oBrowse:SetOwner( oDlg )
oBrowse:SetDescription( "Previsao de entrega para provisao financeira" )
oBrowse:SetDataArray()
oBrowse:SetColumns( _aColunas )
oBrowse:SetArray( _aDados )
oBrowse:lHeaderClick :=.F.
oBrowse:SetLocate()
oBrowse:SetSeek( Nil, _aSeek )
oBrowse:SetFieldFilter( _aFiltro )
oBrowse:SetEditCell( .T. )
oBrowse:acolumns[ 15 ]:ledit		:= _lEditar
oBrowse:acolumns[ 15 ]:cReadVar	:= '_aDados[ oBrowse:nat ][ 15 ]'
oBrowse:bValidEdit					:= {|| fPNCM01e( _aCampos, _cPedido, _cFornece ) }
oBrowse:Activate()
    
/* Inferior tela */
oPanel	:= tPanel():New( 00, 00, "", oDlg,,,,, 16777215, 100, 26 )

oPedido	:= TGet():New( 003, 005, {|u| If( PCount() > 00, _cPedido := u, _cPedido ) }	, oPanel, 080, 010, PesqPict( "SC7", "C7_NUM" ), { || },,,,,, .T.,,, {|| .T. },,, {||  }, .F., /*lPassword*/, "SC7", "_cPedido",,,, .T.,,, "Pedido: ", 01,,, "Num. PC" )
oFornece	:= TGet():New( 003, 095, {|u| If( PCount() > 00, _cFornece := u, _cFornece ) }	, oPanel, 080, 010, PesqPict( "SA2", "A2_COD" ), { || }, 00,,, .F.,, .T.,, .F.,, .F., .F.,, .F., .F., "SA2", "_cFornece",,,, .T.,,, "Fornecedor: ", 01,,, "Fornecedor" )

_btnEnviar:= TButton():New( 010, 185, "Procurar", oPanel, Nil, 060, 012,,, .F., .T., .F.,, .F.,,, .F. )
_btnEnviar:bAction := {|| MsgRun( "Efetuando consulta ...", "Processando", {|| fPNCM01c( _aCampos, _cPedido, _cFornece ) } ), /*fSalvaSX1( _cPerg, _cFornece )*/ }

oDtPrFin	:= TCheckBox():New( 012, 255, "Confirmar alteracao apos informar Dt. Prev. Entrega p/provisao financeira", { |l| If( PCount() > 00, _lDtPrFin := l, _lDtPrFin ) }, oPanel, 200, 008,, {||  },, {|| }, CLR_RED, CLR_WHITE,, .T., "",, {|| } )
    
_nWidth	:= ( _nMSDir / 02 )

btnCancela	:= TButton():New( 005, _nWidth - 060, "Cancela", oPanel, Nil, 060, 017,,, .F., .T., .F.,, .F.,,, .F. )
btnCancela:bAction := {|| oDlg:End() }
//btnCancela:Disable()

btnConfirma	:= TButton():New( 005, _nWidth - 125, "Confirmar", oPanel, Nil, 060, 017,,, .F., .T., .F.,, .F.,,, .F. )
btnConfirma:bAction := _bConfirma
//btnConfirma:Disable()
    
oBrowse:oBrowse:Align	:= CONTROL_ALIGN_ALLCLIENT
oPanel:Align				:= CONTROL_ALIGN_BOTTOM
    
Activate MsDialog oDlg CENTERED
    
// SetKey( VK_F5,{||} )

Return ( Nil )

/*/{Protheus.doc} fPNCM01e
Validacao dos campos editaveis
@type static function
@version 1.0  
@author celso.costa
@since 11/03/2022
@param _aCampos, array, campos browse
@param _cPedido, char, pedido de compras
@param _cFornece, char, codigo do fornecedor
@return _lRet, logical
/*/
Static Function fPNCM01e( _aCampos, _cPedido, _cFornece )

/* Variaveis Locais */
Local _lRet			:= .T.
//Local _dDTPrEntr	:= Iif( !Empty( _aDados[ oBrowse:nAt ][ 15 ] ), _aDados[ oBrowse:nAt ][ 15 ], CtoD( "" ) )

/* Refresh grid */
oBrowse:setArray( _aDados )
oBrowse:Refresh()

Return ( _lRet )

/*/{Protheus.doc} fPNCM01c
Processamento filtro
@type static function
@version 1.0  
@author celso.costa
@since 11/03/2022
@param _aCampos, array, campos browse
@param _cPedido, char, pedido de compras
@param _cFornece, char, codigo do fornecedor
@return variant, return_description
/*/
Static Function fPNCM01c( _aCampos, _cPedido, _cFornece )

/* Variaveis Locais */
Local _nCont	:= 00
Local _cQuery	:= ""
    
/* Processamento */
If Len( _aCampos ) == 00

	Aviso( "Atencao", "Nao existem campos configurados para exibicao de grade!" +CRLF + CRLF + "Entre em contato com o Administrador.", { "Fechar" }, 01 )

	Return ( Nil )

EndIf
    
If Empty( _cPedido ) .And. Empty( _cFornece )

	Alert( "Para iniciar a pesquisa e necessario informar o Pedido ou o Fornecedor!" )

	oPedido:SetFocus()

	Return ( Nil )

EndIf
    
Begin Sequence
        
	_cQuery := "Select "
        
	For _nCont := 01 To Len( _aCampos )

		_cQuery	+= Iif( _nCont != 01, ", ", "" )
		_cQuery	+= _aCampos[ _nCont ]

	Next _nCont
   
   _cQuery	+= ", SC7.R_E_C_N_O_ "     
	_cQuery	+= " From "
	_cQuery	+= RetSqlName( "SC7" ) + " SC7 "
	_cQuery	+= "Where D_E_L_E_T_= ' ' "
	_cQuery	+= "And C7_FILIAL = '" + xFilial( "SC7" ) + "' "

	If !Empty( _cPedido )
		_cQuery	+= "And C7_NUM = '" + Alltrim( _cPedido ) + "' "
	EndIf

	If !EMpty( _cFornece )
		_cQuery	+= "And C7_FORNECE = '" + Alltrim( _cFornece ) + "' "
	EndIf
	
	_cQuery	+= "And C7_QUANT > C7_QUJE "
	_cQuery	+= "And C7_RESIDUO = '' "
	_cQuery	+= "Order By C7_NUM, C7_ITEM, C7_PRODUTO"
        
	If Select( "TRB" ) != 00
		dbSelectArea( "TRB" )
		TRB->( dbCloseArea() )
	EndIf
        
	TcQuery _cQuery Alias "TRB" New
       
	TRB->( dbGoTop() )

	_aDados	:= {}

	While TRB->( !Eof() )
	
		aAdd( _aDados, {	TRB->C7_NUM					,;
								TRB->C7_FORNECE			,;
								TRB->C7_LOJA				,;
								TRB->C7_ITEM				,;
								TRB->C7_PRODUTO			,;
								TRB->C7_UM					,;
								TRB->C7_DESCRI				,;
								TRB->C7_QUANT				,;
								TRB->C7_PRECO				,;
								TRB->C7_TOTAL				,;
								TRB->C7_QUJE				,;
								TRB->C7_NUMSC				,;
								TRB->C7_ITEMSC				,;
								StoD( TRB->C7_DATPRF )	,;
								Iif( Empty( TRB->C7_ZZDATPR ), StoD( TRB->C7_DATPRF ), StoD( TRB->C7_ZZDATPR ) ),;
								TRB->R_E_C_N_O_ } )

		TRB->( dbSkip() )

	EndDo
        
	oBrowse:SetArray( _aDados )
	btnConfirma:Enable()
	oBrowse:Refresh()
	oBrowse:SetFocus()
        
	TRB->( dbCloseArea() )
        
End Sequence
    
Return ( Nil )

/*/{Protheus.doc} MontaColunas
Define/monta colunas browse
@type static function
@version 1.0 
@author celso.costa
@since 11/03/2022
@param _cDados, char, dados para montagem da coluna
@param aBrowse, array, browse
@return variant, return_description
/*/
Static Function MontaColunas( _cDados, aBrowse )

/* Variaveis Locais */
Local oCol
    
/* Define colunas */
oCol := FWBrwColumn():New()

oCol:SetTitle( AllTrim( X3Titulo()) )
oCol:SetData( &( _cDados ) )
oCol:SetType( SX3->X3_TIPO )
oCol:SetPicture( SX3->X3_PICTURE )
oCol:SetAlign( Iif( SX3->X3_TIPO == "N", CONTROL_ALIGN_RIGHT, CONTROL_ALIGN_LEFT ) )
oCol:SetSize( SX3->X3_TAMANHO + SX3->X3_DECIMAL )
oCol:SetEdit( .F. )

Return ( oCol )

/*/{Protheus.doc} fPNCM01g
Atualiza datas de previsoes de entregas para provisao financeira
@type static function
@version  
@author celso
@since 11/03/2022
@return variant, return_description
/*/
Static Function fPNCM01g()

/* Variaveis Locais */
Local _aArea	:= GetArea()
Local _nFor		:= 00
 
/* Processamento */
If _lDtPrFin .And. Len( _aDados ) > 00

	dbSelectArea( "SC7" )
	SC7->( dbSetOrder( 01 ) )
	
	For _nFor := 01 To Len( _aDados )
	
		SC7->( dbGoTo( _aDados[ _nFor ][ 16 ] ) )
		
		If SC7->( RecNo() ) == _aDados[ _nFor ][ 16 ]
		
			RecLock( "SC7", .F. )
			SC7->C7_ZZDATPR	:= _aDados[ _nFor ][ 15 ]
			SC7->( MsUnLock() )
			
		EndIf
		
	Next _nFor
	
EndIf

RestArea( _aArea )

Return ( Nil )