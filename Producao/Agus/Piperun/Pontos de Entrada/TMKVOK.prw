#include "Totvs.ch"
#include "Protheus.ch"

user function TMKVOK()
	local cPipeRun := SUA->UA_PIPERUN

	if nFolder == 2
		if inclui .or. altera
			u_VldValNet()
		endif

		if inclui
			If FWAlertYesNo( 'Envia orçamento para Piperun?', 'Atenção!' )
				PipeRun.Deals.U_DealsIntegration()
			endIf
			//PipeRun.Proposals.U_SendProposals()
		elseif altera .and. !empty(cPipeRun)
			PipeRun.Deals.U_DealsPut(cPiperun)
		endif
	endif
Return

user function VldValNet()
	local nPosTES 	:= GdFieldPos("UB_TES")			as numeric
	local nPosPro 	:= GdFieldPos("UB_DESCRI")		as numeric
	local nPosVlNet := GdFieldPos("UB_ZVLNET")		as numeric
	local nPosCodPro:= GdFieldPos("UB_PRODUTO")		as numeric
	local nPosItem  := GdFieldPos("UB_ITEM")		as numeric
	local nValorNet := 0							as numeric
	local cProduto  := ""							as character
	local nIndex	:= 0							as numeric

	if nFolder == 2
		dbSelectArea("SF4")
		SF4->(dbSetOrder(01)) //F4_FILIAL+F4_CODIGO
		dbSelectArea("SUB")
		SUB->(dbSetOrder(01)) //UB_FILIAL+UB_NUM+UB_ITEM+UB_PRODUTO
		SUB->(dbGoTop())

		for nIndex := 01 to len(aCols)
			lTes := Posicione("SF4",1,FwXFilial("SF4") + alltrim(aCols[nIndex][nPosTES]),"F4_PIPERUN")
			if lTes
				cProduto := capital(alltrim(aCols[nIndex][nPosPro]))
				n:= nIndex
				nValorNet :=  U_VALNET("P")
				nValorNet := round(nValorNet,4)
				if aCols[nIndex][nPosVlNet] <> nValorNet
					FwAlertInfo("Recalculado o valor net item: "+cValToChar(nIndex)+ CRLF + "Produto " + cProduto + CRLF +" Valor informado = " + cValToChar(aCols[nIndex][nPosVlNet]) + CRLF + "Valor correto = "+ cValToChar(nValorNet), "Atenção!")
					if SUB->(dbSeek(FwXFilial("SUB") + SUA->UA_NUM + aCols[nIndex][nPosItem] + aCols[nIndex][nPosCodPro]))
						if reclock("SUB",.F.)
							SUB->UB_ZVLNET := nValorNet
							SUB->(msUnlock())
						endif
					endif
				endif
			endif
		next nIndex
	endIf
return
