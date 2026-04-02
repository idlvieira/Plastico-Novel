#INCLUDE 'TOTVS.CH'

user function TK271BOK(nOpc)
	local lRet          := .T.                                   as logical
	local cNewCli       := alltrim(M->UA_CLIENTE+M->UA_LOJA)     as character
	local cNumOrc       := M->UA_NUM                             as character
	public cOldCli       := ""                                    as character

	if (nFolder == 2) .and. ALTERA
		cOldCli := GetCli(cNumOrc)
		if cOldCli <> cNewCli
			FwAlertInfo( "Cliente / Prospect foi alterado!" +CRLF+ "Sera necessario realizar a analise de limite de credito." , "Atenção!" )
		endif
	endIf
Return lRet

static function GetCli(cNumOrc) as character
	local cTemp			:= ""		as Character
	local cQuery 		:= ""		as Character
	local oStatement 	:= nil		as Object
	local cCli       := ""       as character

	cQuery := "SELECT UA_CLIENTE, UA_LOJA  " +;
		"FROM " + RetSqlName("SUA") + ;
		" WHERE UA_FILIAL = ? " +;
		" AND UA_NUM = ? " + ;
		" AND D_E_L_E_T_ = ' ' "

	oStatement := FWPreparedStatement():New()
	oStatement:SetQuery(cQuery)
	oStatement:SetString(1,FWxFilial("SUA"))
	oStatement:SetString(2,cNumOrc)

	cQuery  := oStatement:GetFixQuery()
	cTemp   := mpsysopenquery(cQuery)
	cCli := Alltrim((cTemp)->UA_CLIENTE+(cTemp)->UA_LOJA)

return cCli
