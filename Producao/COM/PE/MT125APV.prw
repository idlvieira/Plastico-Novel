/* Includes e defines */
#Include 'Protheus.ch'

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MT125APV.prw    | Autor : Leandro Ferreira      | Data : 21/11/2022 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Alteração do grupo de aprovação do contrato de parceria            |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 21/11/2022  Leandro Ferreira          Jaqueline Chen  Criação do PE   

User Function MT125APV()

	Local _nI			:= 00
	Local _nPosCC		:= 00
	Local _nPosDel		:= 00
	Local _cCCusto		:= ""
	Local _cRet			:= ""
	Local _cRetOrig		:= SC3->C3_APROV
	Local _cAliasCTT	:= ""
	Local _lCotacao		:= IsInCallStack( "MaAvalCOT" ) .Or. IsInCallStack( "MAAVALCOT" ) .Or. IsInCallStack( "MATA160" )
	Local _aArea		:= GetArea()
	Local _aAreaSC3 	:= SC3->( GetArea() )

	/* Efetua validacao do grupo de aprovadores */
	
	If _lCotacao

		_cCCusto		:=  SC3->C3_CC
		_cAliasCTT	:=  GetNextAlias()

		BeginSQL Alias _cAliasCTT
			Select
				CTT.CTT_ZZAPRO As APROV
			From
				%Table:CTT% CTT
			Where CTT.CTT_CUSTO In ( %Exp:_cCCusto% )
				And CTT.CTT_FILIAL = %xFilial:CTT%
				And CTT.%NotDel% AND
			Group By
				CTT.CTT_ZZAPRO
		EndSQL

		If ( _cAliasCTT )->( !Eof() ) .And. ( _cAliasCTT )->( !Bof() )

			If Upper( Alltrim( _cRet ) ) != Upper( Alltrim( ( _cAliasCTT )->APROV ) )
				_cRet := ( _cAliasCTT )->APROV
			EndIf

		EndIf

		( _cAliasCTT )->( dbCloseArea() )

		If Empty( _cRet )
		
			_cRet := AllTrim( Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "COM000001" + "001", "ZZZ_RETORN" ) ) 
			
			MsgAlert( "Nao existe amarracao do Centro de Custo com Grupo de Aprovadores, utilizado Grupo Padrao " + _cRet + ".", "MT120APV" )
		
		EndIf

		If AllTrim( _cRet ) != AllTrim( _cRetOrig )
			MsgInfo( "Grupo de aprovadores alterado para: " + _cRet, "MT125APV" )
		EndIf
		
	ElseIf Upper( AllTrim( FunName() ) ) $ "MATA125"

		_cAliasCTT	:= GetNextAlias()
		_nPosDel		:= Len( aHeader ) + 01
		_nPosCC		:= aScan( aHeader, {|x| AllTrim( x[ 02 ] ) == "C3_CC" } )

		For _nI := 01 To Len( aCols )

			If !( aCols[ _nI ][ _nPosCC ] $ _cCCusto ) .And. !aCols[ _nI ][ _nPosDel ]
				_cCCusto += Iif( Empty( _cCCusto ), "", "," ) + "'" + AllTrim( aCols[ _nI ][ _nPosCC ] ) + "'"
			EndIf

		Next _nI

		_cCCusto := "%" + _cCCusto + "%"

		BeginSQL Alias _cAliasCTT
			Select
				CTT.CTT_ZZAPRO As APROV
			From
				%Table:CTT% CTT
			Where CTT.CTT_CUSTO In ( %Exp:_cCCusto% )
				And CTT.CTT_FILIAL = %xFilial:CTT%
				And CTT.%NotDel%
			Group By
				CTT.CTT_ZZAPRO
		EndSQL

		_cRet := ( _cAliasCTT )->APROV

		( _cAliasCTT )->( dbCloseArea() )

		If Empty( _cRet )

			_cRet := AllTrim( Posicione( "ZZZ", 01, xFilial( "ZZZ" ) + "COM000001" + "001", "ZZZ_RETORN" ) ) 
			
			MsgAlert( "Nao existe amarracao do Centro de Custo com Grupo de Aprovadores, utilizado Grupo Padrao " + _cRet + ".", "MT125APV" )

		EndIf

		If AllTrim( _cRet ) != AllTrim( _cRetOrig )
			MsgInfo( "Grupo de aprovadores alterado para: " + _cRet, "MT125APV" )
   		EndIf
   	
	Else

		_cRet := _cRetOrig
		


	EndIf

	RestArea( _aArea )
	RestArea( _aAreaSC3 )

Return ( _cRet )
