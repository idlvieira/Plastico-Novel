/* Includes/Defines */
#Include "Protheus.CH"

/*/{Protheus.doc} TK271FIL
Ponto de entrada utilizado para filtrar o browse de acordo com o perfil dos operadores
@type function
@version  12.1.33
@author celso.costa
@since 11/05/2022
@param cAlias, character, alias
@return variant, filtro
/*/
User Function TK271FIL( cAlias )

	Local oCmbTip
	Local oBtnOk 
	Local oBtnCa
	Local _nOpcao		:= 00
	Local _cCmbTip		:= ""	 
	Local _cFiltro		:= ""
	Local _aRetFilter	:= {}
	Local _aComboBx1	:= {	"1-Todos"						,;
								"2-Bloquedos pelo Credito"		,;
								"3-Bloqueados por Descontos"	,;
								"4-Faturamento"					,;
								"5-Orçamentos"					,;
								"6-Rejeitado pelo Credito"		,;
								"7-Rejeitado Desconto"			,;
								"8-Orçamentos Prospects"		,;
								"9-Gerente/Supervisor"			}

	/* FrontEnd */
	Define MsDialog oDlg From 000, 000 To 150, 250 Pixel Title "Filtro - Status de Atendimentos"

		oCmbTip	:= tComboBox():New( 18, 18,{ |u|If( PCount() > 00, _cCmbTip := u, _cCmbTip ) }, _aComboBx1, 90, 20, oDlg,,/*{||bloc}*/,,,,.T.,,,,,,,,, '_cCmbTip' )

		oBtnOk	:=tButton():New( 55, 55, OemToAnsi( "Confirmar" ), oDlg, {|| ( _cCmbTip := _cCmbTip, _nOpcao := 01, oDlg:End() ) } , 30, 12,,,, .T. )
		oBtnCa	:=tButton():New( 55, 90, OemToAnsi( "Cancelar" ), oDlg, {||( _cCmbTip := "", _nOpcao := 00, oDlg:End() ) }, 30, 12,,,,.T. )

	Activate MsDialog oDlg Centered

	/* Montagem filtro */
	If _nOpcao == 01

		Do Case
			Case SubStr( _cCmbTip, 01, 01 ) == "1"
				_cFiltro	:= ''
			Case SubStr( _cCmbTip, 01, 01 ) == "2" 
				_cFiltro	:= 'SUA->UA_ZZSTAT1 == "BLO"' 
			Case SubStr( _cCmbTip, 01, 01 ) == "3" 
				_cFiltro	:= 'SUA->UA_ZZSTAT2 == "BLO"'
			Case SubStr( _cCmbTip, 01, 01 ) == "4" 
				_cFiltro	:= '( Empty( SUA->UA_CODCANC ) .And. Val( SUA->UA_OPER ) == 01 .And. SUA->UA_ZZSTAT1 != "BLO" )'
			Case SubStr( _cCmbTip, 01, 01 ) == "5" 
				_cFiltro	:= '( Empty( SUA->UA_CODCANC ) .And. Val( SUA->UA_OPER ) == 02 .And. SUA->UA_ZZSTAT1 != "BLO" .And. SUA->UA_ZZSTAT2 != "BLO" .And. SUA->UA_PROSPEC == .F. )'
			Case SubStr( _cCmbTip, 01, 01 ) == "6" 
				_cFiltro	:= 'SUA->UA_ZZSTAT1 == "REJ"'
			Case SubStr( _cCmbTip, 01, 01 ) == "7" 
				_cFiltro	:= 'SUA->UA_ZZSTAT2 == "REJ"'
			Case SubStr( _cCmbTip, 01, 01 ) == "9" 
				/* Utiliza a funcao fVerOperador para retornar o filtro desejado */
			OtherWise
				_cFiltro	:= '( Empty( SUA->UA_CODCANC ) .And. Val( SUA->UA_OPER ) == 02 .And. SUA->UA_ZZSTAT1 != "BLO" .And. SUA->UA_PROSPEC == .T. )'
		EndCase

		_aRetFilter	:= fVerOperador( _cCmbTip )

		If !_aRetFilter[ 01 ]
			MsgAlert( _aRetFilter[ 03 ],"TK271FIL" )
			/* Inutiliza o filtro */
			_cFiltro := '01 == 02'
		Else
			_cFiltro += Iif( !Empty( _cFiltro ), ' .And. ', '' ) + _aRetFilter[ 02 ]
		EndIf

	EndIf

Return ( _cFiltro )

/*/{Protheus.doc} fVerOperador
Atualiza filtro conforme perfil do operador
@type function
@version  1.00
@author celso.costa
@since 18/05/2022
@param _cCmbTip, variant, tipo de filtro selecionado
@return variant, filtro para adicao
/*/
Static Function fVerOperador( _cCmbTip )

	/* Variaveis Locais */
	Local _lRet			:= .T.
	Local _lOperMaster	:= .F.
	Local _aArea		:= GetArea()
	Local _cAliasOper	:= GetNextAlias()
	Local _cAliasSup	:= GetNextAlias()
	Local _nSup			:= 00
	Local _cFiltroAdd	:= ""
	Local _cMensErr		:= ""
	Local _cOperadores	:= ""
	Local _cNomeOper	:= ""
	Local _aSupervisor	:= {}
	Local _cOperMaster	:= GetMV( "MV_TMKOPMS" )

	/* Verifica perfil do operador */
	BeginSQL Alias _cAliasOper
		Select
			SU7.U7_COD As Operador,
			SU7.U7_NOME As NomeOper,
			Case
				When SU7.U7_TIPO = '1' Then 'Operador'
				When SU7.U7_TIPO = '2' Then 'Supervidor'
				When SU7.U7_TIPO = ' ' Then 'Sem definicao'
			End	As Tipo,
			Case
				When SU7.U7_VALIDO = '1' Then 'Sim'
				When SU7.U7_VALIDO = '2' Then 'Nao'
				When SU7.U7_VALIDO = ' ' Then 'Sem definicao'
			End As Valido,
			Case
				When SU7.U7_MSBLQL = '1' Then 'Nao'
				When SU7.U7_MSBLQL = '2' Then 'Sim'
				When SU7.U7_MSBLQL = ' ' Then 'Sem definicao'
			End As Ativo
		From 
			%Table:SU7% SU7
		Where SU7.U7_CODUSU = %Exp:Alltrim( __CUSERID )%
			And SU7.U7_FILIAL = %xFilial:SU7%
			And SU7.%NotDel%
	EndSQL

	/* Efetua validacoes */
	_cNomeOper	:= ( _cAliasOper )->NomeOper

	If AllTrim( ( _cAliasOper )->Valido ) != "Sim"
		_lRet		:= .F.
		_cMensErr	+= Iif( !Empty( _cMensErr ), Chr( 13 ) + Chr( 10 ), "" ) + "Verifique seu cadastro de operador, campo [Válido] igual a " + AllTrim( ( _cAliasOper )->Valido )
	EndIf

	If AllTrim( ( _cAliasOper )->Ativo ) != "Sim"
		_lRet		:= .F.
		_cMensErr	+= Iif( !Empty( _cMensErr ), Chr( 13 ) + Chr( 10 ), "" ) + "Verifique seu cadastro de operador, campo [Ativo] igual a " + AllTrim( ( _cAliasOper )->Ativo )
	EndIf

	If SubStr( _cCmbTip, 01, 01 ) == "9"	// Supervisor e gerencia
	
		If AllTrim( ( _cAliasOper )->Tipo ) != "Supervidor"
			_lRet		:= .F.
			_cMensErr	+= Iif( !Empty( _cMensErr ), Chr( 13 ) + Chr( 10 ), "" ) + "Opção de filtro inválida, seu cadastro está definido como : " + AllTrim( ( _cAliasOper )->Tipo )
		Else
		
			_lOperMaster := AllTrim( ( _cAliasOper )->Operador ) $ _cOperMaster
			
			/* Seleciona Gerente/Supervisor */
			BeginSQL Alias _cAliasSup
				Select Distinct
					SU7.U7_TIPO As Tipo,
					SU7.U7_COD As Operador
				From
					%Table:SU7% SU7 
				Where SU7.U7_SUPER = %Exp:AllTrim( ( _cAliasOper )->Operador )%
					And SU7.U7_FILIAL = %xFilial:SU7%
					And SU7.%NotDel%
			EndSQL

			While ( _cAliasSup )->( !Eof() ) .And. !_lOperMaster
			
				If AllTrim( ( _cAliasSup )->Tipo ) == "2"
					aAdd( _aSupervisor, ( _cAliasSup )->Operador )
				EndIf

				_cOperadores += Iif( !Empty( ( _cAliasSup )->Operador ), "#", "" ) + ( _cAliasSup )->Operador

				( _cAliasSup )->( dbSkip() )

			EndDo

			( _cAliasSup )->( dbCloseArea() )

			/* Seleciona Operadores */
			For _nSup := 01 To Len( _aSupervisor )
			
				BeginSQL Alias _cAliasSup
					Select Distinct
						SU7.U7_COD As Operador
					From
						%Table:SU7% SU7 
					Where SU7.U7_SUPER = %Exp:AllTrim( _aSupervisor[ _nSup ] )%
						And SU7.U7_FILIAL = %xFilial:SU7%
						And SU7.%NotDel%
				EndSQL
			
				While ( _cAliasSup )->( !Eof() )
			
					_cOperadores += Iif( !Empty( ( _cAliasSup )->Operador ), "#", "" ) + ( _cAliasSup )->Operador

					( _cAliasSup )->( dbSkip() )

				EndDo

				( _cAliasSup )->( dbCloseArea() )

			Next _nSup

			If Empty( _cOperadores ) .And. !_lOperMaster
				_lRet		:= .F.
				_cMensErr	+= Iif( !Empty( _cMensErr ), Chr( 13 ) + Chr( 10 ), "" ) + "Não existem operadores selecionados para o Gerente/Supervisor : " + AllTrim( _cNomeOper )
			EndIf

			_cOperadores	+= Iif( !Empty( _cOperadores ), "#", "" ) + ( _cAliasOper )->Operador

		EndIf
		
	Else 
		_cOperadores	:= ( _cAliasOper )->Operador
	EndIf

	/* Restaura ponteiros */
	( _cAliasOper )->( dbCloseArea() )

	RestArea( _aArea )

	/* Monta filtro retorno */
	If _lRet
		_cFiltroAdd	:= Iif( _lOperMaster, "", "( SUA->UA_OPERADO $ '" + _cOperadores + "' )" ) 
	EndIf 

Return ( { _lRet, _cFiltroAdd, _cMensErr } )
