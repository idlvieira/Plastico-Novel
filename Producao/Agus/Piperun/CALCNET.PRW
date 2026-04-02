#include "rwmake.ch"
#include "protheus.ch"
#include "totvs.ch"
#include "topconn.ch"
#include 'FWMVCDef.ch'

function U_CALCNET(cTipo)
	local nValUNI 		:= 0          				as numeric
	local nQtdVEN 		:= 0          				as numeric
	local nValICM 		:= 0          				as numeric
	local nBasICM 		:= 0          				as numeric
	local nValPIS 		:= 0          				as numeric
	local nBasPIS 		:= 0          				as numeric
	local nValCOF 		:= 0          				as numeric
	local nBasCOF 		:= 0          				as numeric
	local nValFRT 		:= 0          				as numeric
	local nFRTUNI 		:= 0          				as numeric
	local nRetorn 		:= 0          				as numeric
	local cIPIBAS 		:= ""         				as character

	cIPIBAS:= POSICIONE("SF4",1,xFilial("SF4")+aCols[n,gdFieldPos("C6_TES")],"F4_INCIDE")

	// salva backup da MATXFIS
	MaFisSave()
	// limpa itens
	MaFisClear()

	MaFisIni(;
	SC5->C5_CLIENTE,;                       // 01 - Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI,;                       // 02 - LOJACLI do Cliente/Fornecedor
	"C",;                                   // 03 - C:Cliente , F:Fornecedor
	"N",;                          			// 04 - Tipo da NF
	SC5->C5_TIPOCLI,;                       // 05 - Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100", {"SD2"}),;         // 06 - Relacao de Impostos que suportados no arquivo
	NIL,;                                   // 07 - Tipo de complemento
	NIL,;                                   // 08 - Permite Incluir Impostos no Rodape .T./.F.
	NIL,;//"SB1",;                          // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front LOJACLI)
	"MATA461")                              // 10 - Nome da rotina que esta utilizando a funcao

	MaFisAdd(aCols[n,gdFieldPos("C6_PRODUTO")],;   	// 1-Codigo do Produto ( Obrigatorio )
	aCols[n,gdFieldPos("C6_TES")],;	  	 	// 2-Codigo do TES ( Opcional )
	aCols[n,gdFieldPos("C6_QTDVEN")],;	   	    // 3-Quantidade ( Obrigatorio )
	aCols[n,gdFieldPos("C6_PRCVEN")],;   		// 4-Preco Unitario ( Obrigatorio )
	aCols[n,gdFieldPos("C6_VALDESC")],;  		// 5-Valor do Desconto ( Opcional )
	0,;	   		            // 6-Numero da NF Original ( Devolucao/Benef )
	0,;		                // 7-Serie da NF Original ( Devolucao/Benef )
	0,;	 					// 8-RecNo da NF Original no arq SD1/SD2
	0,;						// 9-Valor do Frete do Item ( Opcional )
	0,;						// 10-Valor da Despesa do item ( Opcional )
	0,;						// 11-Valor do Seguro do item ( Opcional )
	0,;						// 12-Valor do Frete Autonomo ( Opcional )
	aCols[n,gdFieldPos("C6_PRCVEN")],;		// 13-Valor da Mercadoria ( Obrigatorio )
	0	)					// 14-Valor da Embalagem ( Opiconal )

	nValFRT := SC5->C5_FRETE

    /*ICMS*/
	nBasICM := aCols[n,gdFieldPos("C6_PRCVEN")] + (nFRTUNI * aCols[n,gdFieldPos("C6_QTDVEN")]) + IIF(cIPIBAS=="S",MaFisRet(1,"IT_VALIPI"),0)
	nValICM := nBasICM * (MaFisRet(1,"IT_ALIQICM")/100)
            /*PIS*/
	nBasPIS := aCols[n,gdFieldPos("C6_PRCVEN")] + (nFRTUNI * aCols[n,gdFieldPos("C6_QTDVEN")]) - nValICM
	nValPIS := nBasPIS * (MaFisRet(1,"IT_ALIQPIS")/100)
            /*COFINS*/
	nBasCOF := aCols[n,gdFieldPos("C6_PRCVEN")] + (nFRTUNI * aCols[n,gdFieldPos("C6_QTDVEN")]) - nValICM
	nValCOF := nBasCOF * (MaFisRet(1,"IT_ALIQCOF")/100)

	nValUNI := aCols[n,gdFieldPos("C6_PRCVEN")]
	nQtdVEN := aCols[n,gdFieldPos("C6_QTDVEN")]
	nValFRT := SC5->C5_FRETE
	nRetorn := nValUNI - (nValICM/nQtdVEN) - (nValPIS/nQtdVEN) - (nValCOF/nQtdVEN)

	if cTipo == 'F' .and. nValFRT > 0
		nRetorn := nRetorn + nFRTUNI
	endIf

	// restaura backup da MATXFIS
	MaFisEnd()
	MaFisClear()
	MaFisRestore()

	nRetorn := round(nRetorn,4)

Return nRetorn
