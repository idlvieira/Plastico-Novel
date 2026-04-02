/* Includes */
#Include 'Protheus.ch'

/*/{Protheus.doc} MYCOM06
Retorna nome do fornecedor ao campo CR_ZNOME
@type function
@version  1.00
@author celso.costa
@since 25/05/2022
@param _cPedido, character, numero do pedido de compras
@return variant, nome do fornecedor
/*/
User Function MYCOM06( _cSCRNum )

    /* Variaveis Locais */
    Local _cNomeFor     := ""
    Local _aArea        := GetArea()
    Local _cAliasFor    := GetNextAlias()

    /* Efetua filtro */
    BeginSQL Alias _cAliasFor
        Select Top 01
        	SA2.A2_NOME As NomeFor
        From
        	%Table:SC7% SC7,
        	%Table:SA2% SA2
        Where SC7.C7_NUM = %Exp:AllTrim( _cSCRNum )%
        	And SC7.C7_FILIAL = %xFilial:SC7%
        	And SC7.%NotDel%
        	And SA2.A2_COD = SC7.C7_FORNECE
        	And SA2.A2_LOJA = SC7.C7_LOJA
        	And SA2.A2_FILIAL = %xFilial:SA2%
	        And SA2.%NotDel%
    EndSQL

    _cNomeFor   := ( _cAliasFor )->NomeFor
    _cNomeFor   := Iif( Empty( _cNomeFor ), Space( TamSX3( "CR_ZNOME" )[ 01 ] ), SubStr( _cNomeFor, 01, TamSX3( "CR_ZNOME" )[ 01 ] ) )

    /* Restaura ponteiros */
    ( _cAliasFor )->( dbCloseArea() )

    RestArea( _aArea )
	
Return( _cNomeFor )
