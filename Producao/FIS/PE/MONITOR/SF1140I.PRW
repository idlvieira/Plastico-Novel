#Include "Protheus.ch"

/*
* Funcao		: SF1140I
* Autor			: DANIEL TORNISIELO
* Data			: 02/08/2016
* Descrição		: LOCALIZAÇÃO: Function Ma140Grava() - Responsável por atualizar um Pré-Documento de Entrada e seus anexos. EM QUE PONTO: Ponto de Entrada utilizado na atualização do cabeçalho do Pré-Documento de Entrada.
* Observacoes	: n/a
*/
User Function SF1140I()
   
	U_MONGRVSP(SF1->F1_CHVNFE,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DTDIGIT)

Return()