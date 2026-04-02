#Include "Protheus.ch"

/*
* Funcao		: SF1100E
* Autor			: DANIEL TORNISIELO
* Data			: 02/08/2016
* Descrição		: LOCALIZAÇÃO : Function A100Deleta() - Responsável pela exclusão de notas fiscai de entrada.EM QUE PONTO : Executado antes de deletar o registro no SF1, na exclusao da Nota de Entrada. O registro ja se encontra travado (Lock).
* Observacoes	: n/a
*/
User Function SF1100E()
	Local aArea := GetArea()        
	Local _cAreaSD1 := SD1->(GetArea())
	Local _cAreaSF1 := SF1->(GetArea())
	       
	U_MONGRVSP(SF1->F1_CHVNFE,"","","","",StoD(""))  
	
	RestArea(aArea)      
	RestArea(_cAreaSD1)
	RestArea(_cAreaSF1)
Return()                                                                    