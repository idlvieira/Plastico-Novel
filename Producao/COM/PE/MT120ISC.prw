#Include 'Protheus.ch'

/*/{Protheus.doc} MT103TXPC
Ponto de entrada para gravar campo
customizado na importação do pedido de compras
@type function
@version  
@author ruenss
@since 29/06/2022
@return variant, return_description
/*/



User Function MT120ISC
Local nX
Local nDtEnt    := aScan(aHeader,{|x| AllTrim(x[2]) =="C7_DATPRF"    })
Local nDtZZ 	:= aScan(aHeader,{|x| AllTrim(x[2]) =="C7_ZZDATPR" })




For nX := 1 To Len(aCols)
	
		aCols[n][nDtZZ] := aCols[n][nDtEnt] 
	
Next nX




Return
