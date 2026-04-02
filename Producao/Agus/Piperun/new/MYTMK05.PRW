#Include "protheus.ch"

static __cTMK   := "TMK000004"
static __cNivel := "AP1"

/*/{Protheus.doc} MYTMK05
Retorna o aprovador atual do orcamento de venda e Limites de Aprovacao
/*/

user function MYTMK05(nOrcamento, nNivel)
	local aAreaATU		    := getArea()                    as array
	local cAprovador	    := ""                           as character
	local cTemp			    := ""	                        as character
	local cQuery 		    := ""	                        as character
	local cSeguiment        := ""                           as character
	local cCliente          := SUA->(UA_CLIENTE+UA_LOJA)    as character
	local oStatement 	    := nil	                        as object
	local lProspect         := SUA->UA_PROSPEC              as logical

	if lProspect
		cSeguiment := "%"+ alltrim(Posicione("SUA",1,FWxFilial("SUA")+cCliente,"US_XSEGUIM")) + "%"
	else
		cSeguiment := "%"+ alltrim(Posicione("SA1",1,FWxFilial("SA1")+cCliente,"A1_ZZSEG")) + "%"
	endif

	cQuery := "SELECT ZZ.ZZZ_RETORN"
	cQuery += " FROM " + RetSqlName('ZZZ') + " ZZ"
	cQuery += " WHERE ZZ.D_E_L_E_T_ = '' "
	cQuery += " AND ZZZ_FILIAL = ? "
    cQuery += " AND ZZZ_ITEM = ? "
    cQuery += " AND ZZZ_COD = ?"
	cQuery += " AND ZZZ_SEGUIM LIKE ? "

	oStatement := FWPreparedStatement():New()
	oStatement:SetQuery(cQuery)
	oStatement:SetString(1, FWxFilial("ZZZ"))
	oStatement:SetString(2, __cNivel)
	oStatement:SetString(3, __cTMK)
	oStatement:SetString(4, cSeguiment)

	cQuery := oStatement:GetFixQuery()
	cTemp := mpsysopenquery(cQuery)

	if !empty((cTemp)->ZZZ_RETORN)
        cAprovador := alltrim(upper((cTemp)->ZZZ_RETORN))
	else
		FWAlertError('Não foi possivel identificar o segmento do cliente!')
	endIf

	(cTemp)->(dbCloseArea())

	restArea(aAreaATU)

return cAprovador
