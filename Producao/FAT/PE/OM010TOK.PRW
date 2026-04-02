#Include 'Protheus.ch'
#Include "rwmake.ch"
#include 'parmtype.ch'
#Include "topconn.ch"

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : OM010TOK.prw    | Autor : Leandro Ferreira      | Data : 22/04/2020|\
/|-------------------------------------------------------------------------------|\
/| Descricao: PE validação tabela de preço			                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 22/04/2020  Leandro Ferreira          Camila Chaves   Validar a duplicidade de itens.                                 


User Function OM010TOK()

	Local nLin := 0
	Local lRet := .T.
	Local oModel := PARAMIXB[1]
	Local oGridTab := oModel:GetModel("DA1DETAIL")
	
	getArea()
	For nLin := 1 To Len(oGridTab:ADATAMODEL) 
		oGridTab:GoLine(nLin)
		_codProd := AllTrim(oGridTab:GetValue("DA1_CODPRO"))
		_ITEM	 := AllTrim(oGridTab:GetValue("DA1_ITEM"))
		
		For xLin := 1 To Len(oGridTab:ADATAMODEL)
			oGridTab:GoLine(xLin)
			If !oGridTab:IsDeleted() .And. AllTrim(oGridTab:GetValue("DA1_CODPRO")) == _codProd	.And. AllTrim(oGridTab:GetValue("DA1_ITEM")) != _ITEM
				Help(" ",1,"Produto duplicado",,"O Produto: " + AllTrim(oGridTab:GetValue("DA1_CODPRO")) +  " já consta na tabela de preço, nos ítens: " + _ITEM + " e " + AllTrim(oGridTab:GetValue("DA1_ITEM")), 3, 0,NIL, NIL, NIL, NIL, NIL, {"Altere o código do produto ou exclua as linhas duplicadas."})   
				Return .F.  
			EndIf
		Next xLin
		
	Next nLin
	
	For nLin := 1 To Len(oGridTab:ADATAMODEL) 

		oGridTab:GoLine(nLin)

			If !oGridTab:IsDeleted() .And. oGridTab:GetValue("DA1_PRCVEN") == 0
				Help(" ",1,"Produto sem preço",,"O Produto: " + AllTrim(oGridTab:GetValue("DA1_CODPRO")) + " está com preço zerado.", 3, 0,NIL, NIL, NIL, NIL, NIL, {"Favor incluir o preço do produto."})   
				Return .F.  
			EndIf

	Next nLin

Return lRet