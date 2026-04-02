/* Includes e defines */
#Include 'Protheus.ch'

/*/{Protheus.doc} MT120APV
O Ponto de Entrada MT120APV e responsavel pela gravacao do grupo de aprovacao do Pedido de Compras
e/ou Autorizacao de Entrega.

Sua execucao e efetuada em 2 pontos distintos:
	Pedido de Compras (Neste ponto, nenhum parametro e passado para o ponto de entrada)
		Funcao: A120Grava
	Analise de Cotacao (Neste ponto, serao passados os parametros)
		Funcao: MaAvalCot

Apos a gravacao dos itens do pedido de compras, dentro da condicao que gera o bloqueio do PC na tabela SCR
e pode ser utilizado para:
	Manipular o grupo de aprovacao que sera gravado na tabela SCR conforme as necessidades do usuario
	E/ou manipular o saldo do pedido, conforme as necessidades do usuario, na alteracao do pedido. 
	Atencao: Neste caso, deve-se restringir a execucao da rotina atraves da variavel 'ALTERA'.

PARAMIXB[01] Array Informação do vencedor
	01 - Fornecedor Vencedor
	02 - Loja Vencedor
	03 - Condição de Pagamento
	04 - Filial de Entrega
PARAMIXB[02] Array Acols com os campos e conteudo da SC8

@type function
@version 12.1.33  
@author celso.costa
@since 28/04/2022
@return variant, cGrupo, Caracter, Grupo de aprovacao
/*/

User Function MT120APV()

	Local ExpC1			:= Nil
	Local ExpC2			:= Nil
	Local _nI			:= 00
	Local _nPosCC		:= 00
	Local _nPosDel		:= 00
	Local _cCCusto		:= ""
	Local _cRet			:= ""
	Local _cRetOrig		:= SC7->C7_APROV
	Local _cAliasCTT	:= ""
	Local _lCotacao		:= IsInCallStack( "MaAvalCOT" ) .Or. IsInCallStack( "MAAVALCOT" ) .Or. IsInCallStack( "MATA160" )
	Local _aArea		:= GetArea()
	Local _aAreaSC7		:= SC7->( GetArea() )

	/* Efetua validacao do grupo de aprovadores */
	If _lCotacao

		_cCCusto		:=  SC7->C7_CC
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
			MsgInfo( "Grupo de aprovadores alterado para: " + _cRet, "MT120APV" )
		EndIf
		
	ElseIf Upper( AllTrim( FunName() ) ) $ "MATA121|MATA122|TMSA0014|FINA0004|MATA130|MATA150|MATA160"

		_cAliasCTT	:= GetNextAlias()
		_nPosDel		:= Len( aHeader ) + 01
		_nPosCC		:= aScan( aHeader, {|x| AllTrim( x[ 02 ] ) == "C7_CC" } )

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
			
			MsgAlert( "Nao existe amarracao do Centro de Custo com Grupo de Aprovadores, utilizado Grupo Padrao " + _cRet + ".", "MT120APV" )

		EndIf

		If AllTrim( _cRet ) != AllTrim( _cRetOrig )
			MsgInfo( "Grupo de aprovadores alterado para: " + _cRet, "MT120APV" )
   		EndIf
   	
	Else

		_cRet := _cRetOrig
		
		If Type( "PARAMIXB" ) == "A"
			ExpC1  :=  PARAMIXB[ 01 ]
			ExpC2  :=  PARAMIXB[ 02 ]
		EndIf

	EndIf

	RestArea( _aArea )
	RestArea( _aAreaSC7 )

Return ( _cRet )
