/* Includes */
#Include 'Protheus.ch'

/*/{Protheus.doc} MT094CPC
PE para inclusao de campos na acols da aprovacao de pedidos de compras
A separaão dos campos deve ser efetuada com pipe ( | )
@type function
@version  1.00
@author celso.costa
@since 25/05/2022
@return variant, campos adicionados ao acols
/*/
User Function MT094CPC()
	
	Local _cCampos := "C7_QUJE|C7_ZVLNET|C7_OBS"

Return ( _cCampos )
