#include 'Totvs.ch'

Static __nTamStage := FWTamSX3("ZTA_ETAPAS")[01]

user function TK271ROTM()
	local aRotina := {}

	aAdd( aRotina, {'* Etapa do Funil de Vendas', 'U_funilPiperun', 0, 6})
	aAdd( aRotina, {'* Enviar Piperun', 'U_checkPiperun', 0, 6})
	//aAdd( aRotina, {'-> XX' ,'u_xPiperun', 0 , 4 })
	//aAdd( aRotina, { 'Prog. PCP' ,'U_MYFAT10', 0 , 6 })

return aRotina

user function funilPiperun()
	local cPiperun		:= SUA->UA_PIPERUN		as character
	local cStageId 		:= SUA->UA_XSTAGE 		as character
	local cPipelineId 	:= SUA->UA_XFUNIL 		as character
	local cNum			:= SUA->UA_NUM 		    as character
	local cStage		:= ""					as character
	local aDados		:= {}					as arary
	local cNamePipeline	:= ""					as character
	local lStatus		:= .F.					as logical

	if !empty(cPiperun)
		aDados  := UpdateStageID(cPiperun, cStageId, cPipelineId, cNum)
		if !empty(aDados)
			lStatus := PipeRun.Deals.U_UpdateStages(cPiperun, adados[1], cPipelineId, cNum, adados[2], adados[3])
			if lStatus
				cNamePipeline := alltrim(capital(Posicione("ZTA", 4, XFilial("ZTA")+ PadR(cStageId, __nTamStage), "ZTA_DESC")))
				fwAlertSuccess("A etapa do funil "+cNamePipeline + " foi atualizada para " + alltrim(capital(cStage)))
			endif
		endif
	else
		FwAlertInfo("O orçamento N° " +allTrim(cNum)+ " não foi integrado com PipeRun.")
	endIf

return

static function UpdateStageID(cPiperun, cStageId, cPipelineId, cNum) as array
	local cStage			:= "" as character
	local cName				:= "" as character
	local aStages			:= {} as array
	local aProbability		:= {} as array
	local aDados			:= {} as arary
	local dPrvFech				  as date
	local cDate 			:= "" as character
	local nSelect 			:= 1  as numeric
	local nProbability		:= 1  as numeric	
	local oButton1				  as object
	local oComboBo1				  as object
	local oComboBo2				  as object
	local oSay1					  as object
	local oSay2					  as object
	local oDtPrev				  as object
	static oDlg					  as object

	aStages 	:= GetAllStages(cPipelineId)
	nSelect 	:= aScan(aStages,{|x| alltrim(left(x,6)) == alltrim(cStageId)})
	cName   	:= Posicione("ZTA", 4, XFilial("ZTA")+ PadR(cStageId, __nTamStage), "ZTA_DESC")
	dPrvFech 	:= date()
	aProbability:= {"0","25","50","75","90"} 

	DEFINE MSDIALOG oDlg TITLE "Atualizar etapa do Funil de vendas." FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME

	@ 015, 015 SAY oSay1 PROMPT "Funil: " + Capital(cName) SIZE 165, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025, 015 MSCOMBOBOX oComboBo1 VAR aStages[nSelect] ITEMS aStages SIZE 165, 010 OF oDlg COLORS 0, 16777215 PIXEL
	
	@ 045, 015 SAY oSAy2 PROMPT "Probabilidade de fechamento" SIZE 165, 010 OF oDlg COLORS 0, 16777215 PIXEL 	
	@ 055, 015 MSCOMBOBOX oComboBo2 VAR nProbability ITEMS aProbability SIZE 165, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 070, 015 SAY oSAy2 PROMPT "Previsão de fechamento" SIZE 165, 010 OF oDlg COLORS 0, 16777215 PIXEL 	
	@ 080, 015 MsGet oDtPrev VAR dPrvFech Size 165,10 Of oDlg Pixel
	
	@ 105, 040 BUTTON oButton1 PROMPT "Salvar" SIZE 035, 015  ACTION {|| oDlg:End()  } OF oDlg PIXEL
	@ 105, 110 BUTTON oButton1 PROMPT "Cancelar" SIZE 035, 015  ACTION {|| nSelect := 0, oDlg:End()  } OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED

	if nSelect > 0
		cDate 	:= substr(cValTochar(dPrvFech),7,4)+"-"+substr(cValTochar(dPrvFech),4,2)+"-"+substr(cValTochar(dPrvFech),1,2)
		cStage  := left(aStages[nSelect],6)
		aDados  := {cStage, cDate, nProbability}
	endif
return aDados

static function UpdateStatus()
	local nStatus 	:= 0 	as numeric
	local oDlg				as object
	local nRadio	:= 0	as numeric
	local aOptions  := {}	as array
	local oRadio			as object
	local oButton			as object
	local oButton1			as object

	aOptions:={'Ganha','Perdida'}

	DEFINE MSDIALOG oDlg FROM 0,0 TO 120, 240 PIXEL TITLE "Status da Oportunidade" STYLE DS_MODALFRAME

	oRadio:= tRadMenu():New(10,15,aOptions,{|u|if(PCount()>0,nRadio:=u,nRadio)},oDlg,,,,,,,,100,20,,,,.T.)
	@ 40,40 BUTTON oButton PROMPT "Salvar" OF oDlg PIXEL SIZE 035, 015 ACTION oDlg:End()
	@ 40,80 BUTTON oButton1 PROMPT "Cancelar" OF oDlg PIXEL SIZE 035, 015 ACTION (nStatus := 0, oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED

	if nRadio == 1
		nStatus := 1
	elseif nRadio == 2
		nStatus := 3
	endif

return nStatus

static function GetAllStages(cPipelineId) as array
	local aStages 	:= {} 		as array
	local cStages 	:= ""		as character
	local cQuery 	:= ""		as character
	local cAlias	:= ""   	as character
	local oQuery 	:= nil 		as object

	cQuery :=  "SELECT  ZTA_ETAPAS, ZTA_DESCET "
	cQuery +=  " FROM " + RetSqlName("ZTA") + " ZTA "
	cQuery +=  " WHERE ZTA_PIPERU = ? "
	cQuery +=  " AND D_E_L_E_T_ = '' "

	oQuery := FWPreparedStatement():New(cQuery)
	oQuery:SetString(1,cPipelineId)
	cQuery := oQuery:GetFixQuery()
	cAlias := MPSysOpenQuery(cQuery)

	if !empty(cAlias)
		(cAlias)->(DbGotop())
		While (cAlias)->(!Eof())
			cStages := alltrim((cAlias)->ZTA_ETAPAS) +' - '+ alltrim((cAlias)->ZTA_DESCET)
			aAdd(aStages, alltrim(cStages))
			(cAlias)->(dbSkip())
		endDo
	endif

	(cAlias)->(dbCloseArea())

return aStages

User Function Backorder()

	iF MsgNoYes("Deseja transformar o atendimento em BackOrder","BackOrder")
		RecLock("SUA", .F.)
		//UA_ZBACKO S=SIM;N=NAO
		SUA->UA_ZBACKO := "S"
		MsUnlock()
	else
		RecLock("SUA", .F.)
		//UA_ZBACKO S=SIM;N=NAO
		SUA->UA_ZBACKO := "N"
		MsUnlock()
	ENDIF

Return

user function checkPiperun() as  logical 
	local cPiperun := SUA->UA_PIPERUN	as character
	local lSuccess := .F. 				as logical 
	if empty(cPipeRun)
		lSuccess := FWMsgRun(, {|oSay| PipeRun.Deals.u_SendPost(SUA->UA_NUM)}, "Aguarde!", "Realizando a integração com PipeRun...")
		if lSuccess
			fwAlertSuccess("Integrado com Sucesso!")
		endif
	else
		FwAlertInfo("Este orçamento ja foi integrado!")
		lSuccess := .T.
	endif
return lSuccess

user function xPiperun()
	PipeRun.Deals.u_DealsPut(SUA->UA_PIPERUN)
return
