/* Includes */

/*/{Protheus.doc} MT120FIM
LOCALIZAÇÃO: O ponto se encontra no final da função A120PEDIDO
EM QUE PONTO: Após a restauração do filtro da FilBrowse depois de fechar a operação realizada
no pedido de compras, é a ultima instrução da função A120Pedido.
@type function
@version 1.00 
@author celso.costa
@since 02/06/2022
@return variant, nulo
/*/
User Function MT120FIM()

	/* Variaveis Locais */
	Local _cQuery	:= ""
	Local _aArea	:= GetArea()

	/* Efetua atualizacao do campo especifico nome do fornecedor */
	If Upper( AllTrim( FunName() ) ) $ "MATA120|MATA121|MATA122" .And. ( ParamIXB[ 01 ] == 03 .Or. ParamIXB[ 01 ] == 04  ) .And. ParamIXB[ 03 ] != 00

		dbSelectArea( "SA2" )
		SA2->( dbSetOrder( 01 ) )
		
		If SA2->( dbSeek( xFilial( "SA2" ) + SC7->C7_FORNECE + SC7->C7_LOJA ) )
		
			_cQuery	:= "Update "
			_cQuery	+=	RetSqlName( "SC7" ) + " "
			_cQuery	+= "Set C7_ZNOME = '" + AllTrim( SA2->A2_NOME ) + "' "
			_cQuery	+= "Where C7_NUM = '" + AllTrim( ParamIXB[ 02 ] ) + "' "
			_cQuery	+= "And C7_FILIAL = '" + xFilial( "SC7" ) + "' "
			_cQuery	+= "And D_E_L_E_T_ = ' ' "

			TcSqlExec( _cQuery )

		EndIf

	EndIf

	/* Restaura ponteiros */
	RestArea( _aArea )

Return ( Nil )
