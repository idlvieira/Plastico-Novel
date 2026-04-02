#Include 'Protheus.ch'

/*/{Protheus.doc} MT094CPC

Exibe informações de outros campos do pedido de compra/autorização de entrega no momento da liberação do documento.
O Ponto de Entrada MT094CPC tem como funcionalidade exibir informações de outros campos reais do pedido de compra/autorização de entrega no momento da liberação do documento. Campos do tipo MEMO não são exibidos na grid.

@type function
@author Júlio César Dias de Oliveira
@since 27/06/2022
@version P11,P12
@database MSSQL,Oracle

@see https://tdn.totvs.com/pages/releaseview.action?pageId=286224513

/*/


User Function MT094CPC()
	Local cCampos := ""
	//A separação dos campos devem ser feitos com uma barra vertical ( | ).
	IF M->CR_TIPO == "CP"
		cCampos := "C3_OBS"
		M->CR_OBS :=  M->C3_OBS
	ELSE
		cCampos := GetNewPar("7V_MT094FI","C7_QUJE|C7_ZVLNET|C7_OBS")
	ENDIF
Return cCampos
