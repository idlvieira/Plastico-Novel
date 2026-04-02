#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³Mario F. Silveira   º Data ³  24/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para verificar se a TES movimenta financeiº±±
±±º          ³ro e nao movimenta estoque. Caso essa condicao seja verdadeiº±±
±±º          ³ra o Centro de Custo não pode ser em branco.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM - MATA100( Movimentos de Entrada )                 º±±
±±º          ³ Implantado e adaptado para Myers por Donizete em 05/09/06. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100LOK()

local aArea    := getArea()
local aAreaSD1 := SD1->(getArea())
local aAreaSF4 := SF4->(getArea())
local aAreaSB1 := SB1->(getArea())
local lRet     := .T.
local nPosTES  := gdFieldPos("D1_TES")
local nPosCC   := gdFieldPos("D1_CC")
local nPosRat  := gdFieldPos("D1_RATEIO")
local nPosITC  := gdFieldPos("D1_ITEMCTA")
local nPosProd := gdFieldPos("D1_COD")
local nPosOP   := gdFieldPos("D1_OP")
local nPosST   := gdFieldPos("D1_CLASFIS")
local lYesNo   := .F.
local nPedcom  := gdFieldGet("D1_PEDIDO")
local nTes     := gdFieldGet("D1_TES")
//local nVerif1  := getMV("MV_TESPCNF")
//local nVerif2  := getMV("MV_ZZTESPN")
//local nVerif3  := getMV("MV_ZZTESP2")
//local lVldcc   := getMV("ZZ_VLDCC")
local nPosCon   := gdFieldPos("D1_CONTA")
local nPosNFORI := gdFieldPos("D1_NFORI")
local oValid   := nil
local lValid   := nil
Local lExistSDE:= .F.

&& Adicionado o ponto para verificar se existe RATEIO CC
&& Claudio Iabuki - 20/01/2011

IF (nPosRat<>0) && Verifica se tem Rateio
	IF (aCols[n][nPosRat])='1'    && 1 tem Rateio e 2 Nao tem
		lExistSDE := .T.
	Endif
Endif
//if !(aCols[n][len(aCols[n])])

//	oValid := MyComX001():new(aCols[n][nPosProd],aCols[n][nPosCC],aCols[n][nPosTES])

	if (aCols[n][nPosProd])== ""
		lRet := .F.
	Endif
	
	if (aCols[n][nPosCC])== ""
		lRet := .F.
	Endif
	
	if (aCols[n][nPosTES])== ""
		lRet := .F.
	Endif
	
	if (aCols[n][nPosCon])== ""
		lRet := .F.
	Endif
	
/*
	If (lExistSde = .F.)	
		lRet := oValid:vldCCusto()
	eNDIF
	
	if lRet
		lRet := oValid:vldTes()
	endif
endif

&& verifica se a validacao pode ser executada.
if !(lVldcc) .or. !(lRet)
	return lRet
else

	if !(aCols[n][len(aCols[n])])
		lValid := oValid:getContem() && verifica se deve validar produto
	endif
endif
*/

if nPosCC != 0 .and. nPosTES != 0 .and. nPosRat != 0 .and. !(aCols[n][len(aCols[n])])
	
	cQuery := "SELECT F4_DUPLIC,F4_ESTOQUE, F4_ZZNFSPC "	//F4_ZZTM,F4_ZZCTB,F4_ZZCC "
	cQuery += "FROM "+ retSqlName("SF4") +" "
	cQuery += "WHERE F4_FILIAL ='"+ xFilial("SF4") +"' AND "
	cQuery += "F4_CODIGO ='"+ aCols[n][nPosTES] +"' AND D_E_L_E_T_ = ' '"
	
	TCQUERY cQuery ALIAS TSF4 NEW
	
	TSF4->(dbGoTop())
	
	cQuery := "SELECT B1_CONTA, B1_TIPO " //"B1_ZZCTAA,B1_ZZCTAC,B1_ZZCTAA,B1_ZZCTAD,B1_ZZCTAI,B1_TIPO "
	cQuery += "FROM "+ retSqlName("SB1") +" "
	cQuery += "WHERE B1_FILIAL ='"+ xFilial("SB1") +"' AND "
	cQuery += "B1_COD ='"+ aCols[n][nPosProd] +"' AND D_E_L_E_T_ = ' '"
	
	TCQUERY cQuery ALIAS TSB1 NEW
	
	TSB1->(dbGoTop())
	
/*	
	&& valida o centro de custo para produtos genericos e tes nao atualiza estoque.
	&& if TSF4->F4_ZZCC == "S" .and. empty(aCols[n][nPosCC]) .and. aCols[n][nPosRat] != "1" .and. TSF4->F4_ZZCTB == "S"
	if lValid .and. empty(aCols[n][nPosCC]) .and. aCols[n][nPosRat] != "1" .and. TSF4->F4_ZZCTB == "S"
		alert("Atenção!!! Preenchimento do Centro de Custo é obrigatório.")
		lRet := .F.
	endif
*/

	if empty(aCols[n][nPosCC]) .and. aCols[n][nPosRat] != "1" .and. Empty(aCols[n][nPosNFORI]) 
		alert("Atenção!!! Preenchimento do Centro de Custo é obrigatório.")
		lRet := .F.
	endif

	if empty(aCols[n][nPosCon]) .and. aCols[n][nPosRat] != "1" .and. Empty(aCols[n][nPosNFORI])
		alert("Atenção!!! Preenchimento da Conta Contabil é obrigatório.")
		lRet := .F.
	endif


/*	
	&& valida se a conta contabil foi preenchida corretamente.
	&& if TSF4->F4_ZZCC == "S" .and. !empty(aCols[n][nPosCC]) .and. aCols[n][nPosRat] != "1" .and. TSF4->F4_ZZCTB== "S"
	if lValid .and. !empty(aCols[n][nPosCC]) .and. aCols[n][nPosRat] != "1" .and. TSF4->F4_ZZCTB== "S"
		if empty(TSB1->B1_ZZCTAA) .Or. empty(TSB1->B1_ZZCTAC) .Or. empty(TSB1->B1_ZZCTAD) .Or. empty(TSB1->B1_ZZCTAI) .and. lRet
			alert("Atenção!!! Campo(s) 'Cta.Desp.Adm' ou 'Cta.Desp.Cml' ou 'Cta Custo D' ou 'Cta.Custo I' em branco " + ;
			"no cadastro do produto. Corrija para prosseguir. Produto: " + aCols[n][nPosProd] )
			lYesNo := msgBox("Deseja acessar o cadastro de produto?","Pergunta","YESNO")
			if lYesNo
				MATA010()
			endif
			lRet := .F.
		else
			if U_CC(aCols[n][nPosCC]) == "A"
				lRet := ctbAmarra(TSB1->B1_ZZCTAA,aCols[n][nPosCC],,,.T.)
			elseif U_CC(aCols[n][nPosCC]) == "C"
				lRet := ctbAmarra(TSB1->B1_ZZCTAC,aCols[n][nPosCC],,,.T.)
			elseif U_CC(aCols[n][nPosCC]) == "D"
				lRet := ctbAmarra(TSB1->B1_ZZCTAD,aCols[n][nPosCC],,,.T.)
			elseif U_CC(aCols[n][nPosCC]) == "I"
				lRet := ctbAmarra(TSB1->B1_ZZCTAI,aCols[n][nPosCC],,,.T.)
			endif
			if !lRet
				alert("Caso ocorra erro de amarracao,verifique a regra de amarracao contabil existe nas "+;
				"contas contabeis informadas no cadastro do produto com a regra de amarracao do centro de custo. "+;
				"Cadastros envolvidos: Produtos,Plano de contas(regra de amarracao) e Centro de custo(idem).")
			endif
		endif
	endif
*/
	
	&& valida se a conta contabil esta preenchida no cadastro no caso de compras de ativo.
	if TSB1->B1_TIPO == "AF" .and. empty(TSB1->B1_CONTA) .and. lRet
		alert("Atenção!!! Compra de ativo,o campo 'Cta Contabil' esta em branco no cadastro do produto. Produto: " + ;
		aCols[n][nPosProd])
		lYesNo := msgBox("Deseja acessar o cadastro de produto?","Pergunta","YESNO")
		if lYesNo
			MATA010()
		endif
		lRet := .F.
	endif
/*	
	&& valida se a conta contabil esta preenchida no cadastro no caso de compras de ativo.
	if TSB1->B1_TIPO $ "GG/MO/AF" .and. TSF4->F4_ESTOQUE == "S" .and. lRet
		alert("Atenção!!! Não e permitido tipo do produto GG/MO/AF com TES que atualiza estoques! " + ;
		aCols[n][nPosProd])
		lRet := .F.
	endif
*/
/*	
	&& valida o centro de custo para compras para estoques.
	if TSF4->F4_ESTOQUE == "S" .and. !empty(aCols[n][nPosCC]) .and. TSF4->F4_ZZCTB== "S" .and. lRet
		alert("Atenção!!! Centro de custo não deve ser informado em compras para estoque.")
		lRet := .F.
	endif
*/
/*	
	&& verifica se digitou ctr na especie de documento nas notas de frete.
	if allTrim(TSF4->F4_ZZTM) $ "E41/E9L/E9M" .and. lRet .and. allTrim(CESPECIE) != "CTE"
		alert("Atenção!!! Pra frete a Especie de Documento deve ser CTE.")
		lRet := .F.
	endif
*/
	&& verifica se o numero da nf possui 6 digitos.
	if !empty(CNFiscal)
		if  len(allTrim(CNFiscal)) < 9 .and. lRet
			alert("Atenção!!! Numero de Documento menor que 9 caracteres.")
			lRet := .F.
		endif
	endif
	/*
	&& verifica se a situacao tributaria foi montada corretamente.
	if  len(allTrim(aCols[n][nPosST])) < 3 .and. lRet
		alert("Atenção!!! Classificacao fiscal invalida,verifique os cadastro TES(Sit.Tribut) e PRODUTO(Origem).")
		lRet := .F.
	endif
	*/
	&& valida o numero do pedido de compra para as TES que necessitam de pedido de compra.
	&& exige pedido de compras para TES que nao estao nos parametros MV_TESPCNF e MV_ZZTESP.
	if empty(nPedcom) .and. lRet
		if TSF4->F4_ZZNFSPC == "1"	//TSF4->F4_ZZCC == "S" (nTES $ nVerif1) .or. (nTES $ nVerif2) .or. (nTES $ nVerif3)
			lRet := .T.
		else
			alert("Digite o Numero do Pedido de Compra ou verifique o campo (PERMITE NF S/ PC) no cadastro de TES")
			lRet := .F.
		endif
	endif

	TSB1->(dbCloseArea())
	TSF4->(dbCloseArea())

endif

/*
if !(aCols[n][len(aCols[n])])
	oValid := oValid:destroy()
endif
*/

restArea(aAreaSF4)
restArea(aAreaSB1)
restArea(aAreaSD1)
restArea(aArea)

return lRet
