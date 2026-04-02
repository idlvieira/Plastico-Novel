/* Includes e Defines */
#Include "protheus.ch"
#Include "rwmake.ch"
#Include "ap5mail.ch"

/*/{Protheus.doc} MT110BLO
Detalha motivo do bloqueio e envia email
@type function
@version 12.1.33 
@author celso.costa
@since 28/04/2022
@return variant, nulo
/*/
User Function MT110BLO()

	/* Variaveis Locais */
	Local _aArea	:= GetArea()
	Local _cNumSC	:= SC1->C1_NUM
	Local _cItemSC	:= SC1->C1_ITEM
	Local _cObserv	:= Space( 200 ) 
	Local _aButtons	:= {}
	Local _nOpca	:= PARAMIXB[ 01 ]

	/* Validacoces do usuario */

	If _nOpca == 02 .Or. _nOpca == 03
	
		Define MSDIALOG oDlg TITLE "Descrição do Motivo da Rejeição/Bloqueio" From 07, 10 To 35, 80 Of oMainWnd

		@ 35, 05 Get _cObserv MEMO Size 270, 170 Of oDlg Pixel HSCROLL

		Activate MSDIALOG oDlg Centered On Init EnchoiceBar( oDlg, {||_nOpcao := 01, oDlg:End() }, {|| ( _nOpcao:= 02, oDlg:End() ) },, _aButtons )

		/* Bloqueio de todas as SC */
	
		dbSelectArea( "SC1" )
		SC1->( dbSetOrder( 01 ) )
	
		If mv_par02 == 01

			If SC1->( dbSeek( xFilial( "SC1" ) + _cNumSc + _cItemSC ) )
				RecLock( "SC1", .F. )
				SC1->C1_ZZMOTBL	:= _cObserv
				SC1->C1_ZZDTAPR	:= CtoD( "  /  /  " )
				SC1->( MsUnlock() )
			EndIf

		Else
		
			SC1->( dbSeek( xFilial( "SC1" ) + _cNumSc ) )
		
			While SC1->( !Eof() ) .And. SC1->C1_FILIAL == xFilial( "SC1" ) .And. SC1->C1_NUM == _cNumSc
				
				RecLock( "SC1", .F. )
				SC1->C1_ZZMOTBL	:= _cObserv
				SC1->C1_ZZDTAPR	:= CtoD( "  /  /  " )
				SC1->( MsUnlock() )
				
				SC1->( dbSkip() )
			
			EndDo
		
		EndIf

		PrepEma( _cNumSc, 01 )
	
	EndIf

	If _nOpca == 01
	
		dbSelectArea( "SC1" )
		SC1->( dbSetOrder( 01 ) )

		If mv_par02 == 01

			If SC1->( dbSeek( xFilial( "SC1" ) + _cNumSc + _cItemSC ) )
				RecLock( "SC1", .F. )
				SC1->C1_ZZMOTBL	:= "Item Aprovado"
				SC1->C1_ZZDTAPR	:= Date()
				SC1->( MsUnlock() )
			EndIf

		Else

			SC1->( dbSeek( xFilial( "SC1" ) + _cNumSc ) )
		
			While SC1->( !Eof() ) .And. SC1->C1_FILIAL == xFilial( "SC1" ) .And. SC1->C1_NUM == _cNumSc
			
				RecLock( "SC1", .F. )
				SC1->C1_ZZMOTBL	:= "Aprovada"
				SC1->C1_ZZDTAPR	:= Date()
				SC1->( MsUnlock() )

				SC1->( dbSkip() )

			EndDo
		
		EndIf
	
		PrepEma( _cNumSc, 02 )
	
	EndIf

	RestArea( _aArea )

Return ( Nil )

/*/{Protheus.doc} PrepEma
Apos atualizacao da SC, envia email solicitando aprovacao
@type function
@version 12.1.33  
@author celso.costa
@since 28/04/2022
@param _cNumSc, variant, numero da SC
@param cTipo, character, tipo da SC
@return variant, nulo
return_description
/*/
Static Function PrepEma( _cNumSc, cTipo ) 

	/* Variaveis Locais */
	Local _cEmissao		:= ""
	Local _cNomSol		:= ""
	Local _cAprovacao	:= ""
	Local _aInfo		:= {}
	
	/* Variaveis Private */
	Private _cMotivo	:= Space( 200 )
	Private _cEmail		:= ""
	Private _cBody		:= ""
	Private cDe			:= ""
	Private cPara		:= ""
	Private cAssunto	:= ""   
	Private _cEmailCP	:= ""
	Private _cNomSolCP	:= "" 

	/* Processo */
	dbSelectArea( "SC1" )
	SC1->( dbSetOrder( 01 ) )

	If SC1->( dbSeek( xFilial( "SC1" ) + _cNumSC ) )
	
		_cEmissao	:= DtoC( SC1->C1_EMISSAO )
		_cAprovacao	:= DtoC( SC1->C1_ZZDTAPR )
		_cMotivo	:= SC1->C1_ZZMOTBL
	
		PswOrder( 01 )
	
		If PswSeek( SC1->C1_USER, .T. )
			_aInfo		:= PswRet(1)
			_cEmail		:= Alltrim(_aInfo[1,14]) //E-mail do Solicitante
			_cNomSol	:= Alltrim(_aInfo[1,04]) //Nome do Solicitante
		EndIf

	    dbSelectarea( "SY1" )
		SY1->( dbSetOrder( 01 ) )
	
		If SY1->( dbSeek( xFilial( "SY1" ) + SC1->C1_CODCOMP ) )
			_cEmailCP	:= Alltrim( SY1->Y1_EMAIL )
			_cNomSolCP	:= Alltrim( SY1->Y1_NOME )
		EndIf

	EndIf

	If cTipo == 01 // E-mail de bloqueio ou Rejeicao

		_cBody	:= "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
		_cBody	+= "<html>"
		_cBody	+= "<head>"
		_cBody	+= "<title>Documento sem t&iacute;tulo</title>"
		_cBody	+= "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
		_cBody	+= "</head>"

		_cBody	+= "<body>"
		_cBody	+= "<table width='100%' border='3'>"
		_cBody	+= "  <tr>"
		_cBody	+= "    <td width='84%'><div align='center'>"
		_cBody	+= "        <p><font size='5' face='Georgia, Times New Roman, Times, serif'><strong>Solicita&ccedil;&atilde;o "
		_cBody	+= "          de Compras Rejeitada/Bloqueada</strong></font></p>"
		_cBody	+= "        </div></td>"
		_cBody	+= "    <td width='16%'><img src='file:///\\server2\p10_oficial/PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "</table>"
		_cBody	+= "<table width='100%' border='3'>"
		_cBody	+= "  <tr>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Solicita&ccedil;&atilde;o "
		_cBody	+= "      n&ordm;: <font color='#663300'>"+_cNumSC+"</font></font></strong></td>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data "
		_cBody	+= "      emiss&atilde;o: <font color='#663300'>"+_cEmissao+"</font></font></strong></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "  <tr> "
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Solicitante: "
		_cBody	+= "      <font color='#663300'>"+_cNomSol+"</font> </font></strong></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "  <tr> "
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Verifique a sua Solicitação "
		_cBody	+= "      <font color='#663300'>"+_cNomSol+", pois foi Rejeitada ou Bloqueada."+"</font> </font></strong></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "  <tr> "
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Motivo: "
		_cBody	+= "      <font color='#663300'>"+_cMotivo+"."+"</font> </font></strong></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "</table>"
		_cBody	+= "<p>&nbsp;</p>"
		_cBody	+= "</body>"
		_cBody	+= "</html>"
	
		cPara		:= Alltrim (_cEmail )
		cAssunto	:= "Resposta: Solicitação de Compras para Aprovação"

	ElseIf cTipo == 02 // E-mail de Aprovacao - Vai pro Solicitante e Comprador

		_cBody	:= "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
		_cBody	+= "<html>"
		_cBody	+= "<head>"
		_cBody	+= "<title>Documento sem t&iacute;tulo</title>"
		_cBody	+= "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
		_cBody	+= "</head>"

		_cBody	+= "<body>"
		_cBody	+= "<table width='100%' border='3'>"
		_cBody	+= "  <tr>"
		_cBody	+= "    <td width='84%'><div align='center'>"
		_cBody	+= "        <p><font size='5' face='Georgia, Times New Roman, Times, serif'><strong>Sr. Comprador a"
		_cBody	+= "          solicitacao foi APROVADA.</strong></font></p>"
		_cBody	+= "        </div></td>"
		_cBody	+= "    <td width='16%'><img src='file:///\\server2\p10_oficial/PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "</table>"
		_cBody	+= "<table width='100%' border='3'>"
		_cBody	+= "  <tr>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Solicita&ccedil;&atilde;o "
		_cBody	+= "      n&ordm;: <font color='#663300'>"+_cNumSC+"</font></font></strong></td>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data "
		_cBody	+= "      emiss&atilde;o: <font color='#663300'>"+_cEmissao+"</font></font></strong></td>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data "
		_cBody	+= "      aprovacao: <font color='#663300'>"+_cAprovacao+"</font></font></strong></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "  <tr> "
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Solicitante: "
		_cBody	+= "      <font color='#663300'>"+_cNomSol+"</font> </font></strong></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "</table>"
		_cBody	+= "<p>&nbsp;</p>"
		_cBody	+= "</body>"
		_cBody	+= "</html>"
	
		cPara		:= Alltrim( _cEmail )
		cAssunto	:= "Resposta: Solicitação de Compras para Aprovação"
	
	Endif

	/* Envia email */
	fEnviar( cTipo )

Return ( Nil )

/*/{Protheus.doc} fEnviar
Envia email
@type function
@version  12.1.33
@author celso.costa
@since 28/04/2022
@param nTipoEnv, numeric, param_description
@return variant, return_description
/*/
Static Function fEnviar( nTipoEnv )

	/* Variaveis Locais */
	Local _cAssCP	:= "Solicitação Aprovada pelo Gerente de Area"

	/* Envia emails */
	If !Empty( cPara ) 
		U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cPara + Chr( 59 ), cAssunto, _cBody, /*_cAttach*/, /*lResultSend*/, /*_cLog*/ )
	EndIf

	If nTipoEnv == 02

		If !Empty( _cEmailCP )
			U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, _cEmailCP + Chr( 59 ), _cAssCP, _cBody, /*_cAttach*/, /*lResultSend*/, /*_cLog*/ )
		EndIf

	EndIf
	
Return ( Nil )
