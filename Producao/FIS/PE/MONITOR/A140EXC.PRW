#INCLUDE "Protheus.ch"   
   
/*
* Funcao		: A140Exc
* Autor			: DANIEL TORNISIELO
* Data			: 02/08/2016
* Descrição		: Localizado na função A140NFiscal - Interface do pre-documento de entrada, este Ponto de entrada tem por objetivo validar a exclusão de uma pre-nota.
* Observacoes	: n/a
*/
User Function A140Exc()
	Local ExpL1 := .T.

	If ExpL1
		U_MONGRVSP(SF1->F1_CHVNFE,"","","","",StoD(""))                          
	EndIf
Return ExpL1