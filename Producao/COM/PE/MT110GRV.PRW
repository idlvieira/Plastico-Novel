/* Includes / Defines */
#Include "Protheus.CH"

/*/{Protheus.doc} MT110GRV
PE - Atualizacao do aprovador das solicitacoes de compras
@type function
@version  
@author celso.costa
@since 17/03/2022
@return variant, return_description
/*/
User Function MT110GRV()

/* Variaveis Locais */
Local _aArea		:= GetArea()
Local _cAliasQry	:= GetNextAlias()
Local _cAprovSAI	:= ""
Local _cQryUpd		:= ""

/* Seleciona registro user -> aprovador */
BeginSQL Alias _cAliasQry
	Select Distinct
		SAI.AI_ZZAPROV As Aprovador
	From
		%Table:SAI% SAI
	Where SAI.AI_USER = %Exp:AllTrim( SC1->C1_USER )%
		And SAI.AI_FILIAL = %xFilial:SAI%
		And SAI.%NotDel%
EndSQL

_cAprovSAI	:= AllTrim( ( _cAliasQry )->Aprovador )

( _cAliasQry )->( dbCloseArea() )

If !Empty( _cAprovSAI )

	/* Efetua atualizacao do codigo do aprovador da SC */
	_cQryUpd	:= "Update "
	_cQryUpd	+= RetSQLName( "SC1" ) + " "
	_cQryUpd	+= "Set C1_ZZCAPRO = '" + _cAprovSAI + "' "
	_cQryUpd	+= "Where C1_NUM = '" + SC1->C1_NUM + "' "
	_cQryUpd	+= "And C1_FILIAL = '" + xFilial( "SC1" ) + "' "
	_cQryUpd	+= "And D_E_L_E_T_ = ' ' "

	TCSqlExec( _cQryUpd )

EndIf

/* Restaura ponteiros */
RestArea( _aArea )

Return ( Nil )
