//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo    := "Funil de Vendas"
Static cCamposChv := "ZTA_CODIGO;ZTA_FUNIL;ZTA_DESC;ZTA_TIPO;ZTA_PIPERU;ZTA_USER;"
Static cTabPai    := "ZTA"

/*/{Protheus.doc} User Function FPIPE
	Funil de Vendas
	@author Lucas Silva Vieira
	@since 13/05/2024
	@version 1.0
	@type function
/*/

User Function FPIPE()
	Local aArea   := FWGetArea()
	Local oBrowse
	Local nIgnore := 1
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()
	oBrowse:DisableReport()

	//Filtrando
	oBrowse:SetFilterDefault("ZTA_ORDER == '00'")

	//Ativa a Browse
	oBrowse:Activate()

	//Tratativa para ignorar warnings de ViewDef e ModelDef nunca chamados
	If nIgnore == 0
		ModelDef()
		ViewDef()
	EndIf

	FWRestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
	Menu de opcoes na funcao FPIPE
	@author Lucas Silva Vieira
	@since 13/05/2024
	@version 1.0
	@type function
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.FPIPERUN" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.FPIPERUN" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.FPIPERUN" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    		ACTION "VIEWDEF.FPIPERUN" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Enviar Piperun"   ACTION "U_Pipeline()" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Sincronizar Dados"ACTION "U_GetPipeline()" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Pegar Etapas"		ACTION "U_GetStages()" OPERATION 4 ACCESS 0
	//ADD OPTION aRotina TITLE "Enviar Etapas"	ACTION "U_PostStages()" OPERATION 4 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
	Modelo de dados na funcao FPIPE
	@author Lucas Silva Vieira
	@since 13/05/2024
	@version 1.0
	@type function
/*/

Static Function ModelDef()
	Local oStruPai   := FWFormStruct(1, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(1, cTabPai)
	Local aRelation := {}
	Local oModel
	Local bPre := Nil
	Local bCancel := Nil

	oStruFilho:setproperty("ZTA_CODIGO", MODEL_FIELD_OBRIGAT, .F.)
	oStruFilho:setproperty("ZTA_FUNIL", MODEL_FIELD_OBRIGAT, .F.)

	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("FPIPEM", bPre, /*bPos*/, /*bCommit*/, bCancel)
	oModel:AddFields("ZTAMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZTADETAIL","ZTAMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription(cTitulo)
	oModel:GetModel("ZTAMASTER"):SetDescription( "Funil")
	oModel:GetModel("ZTADETAIL"):SetDescription( "Etapas do Funil")
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZTA_FILIAL", "FWxFilial('ZTA')"} )
	aAdd(aRelation, {"ZTA_CODIGO", "ZTA_CODIGO"})
	aAdd(aRelation, {"ZTA_FUNIL", "ZTA_FUNIL"})
	oModel:SetRelation("ZTADETAIL", aRelation, ZTA->(IndexKey(1)))

	//Definindo campos unicos da linha
	oModel:GetModel("ZTADETAIL"):SetUniqueLine({'ZTA_CODIGO', 'ZTA_ITEM'})

Return oModel

/*/{Protheus.doc} ViewDef
	Visualizacao de dados na funcao FPIPE
	@author Lucas Silva Vieira
	@since 13/05/2024
	@version 1.0
	@type function
/*/

Static Function ViewDef()
	Local oModel     := FWLoadModel("FPIPERUN")
	Local oStruPai   := FWFormStruct(2, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(2, cTabPai, {|cCampo| ! Alltrim(cCampo) $ cCamposChv})
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZTA", oStruPai, "ZTAMASTER")
	oView:AddGrid("GRID_ZTA",  oStruFilho,  "ZTADETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 20)
	oView:CreateHorizontalBox("GRID", 80)
	oView:SetOwnerView("VIEW_ZTA", "CABEC")
	oView:SetOwnerView("GRID_ZTA", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_ZTA", "")
	oView:EnableTitleView("GRID_ZTA", "Etapas do Funil")

	//Adicionando campo incremental na grid
	oView:AddIncrementField("GRID_ZTA", "ZTA_ITEM")

Return oView

user function pipeline()
	local lSend 	:= .F.	as logical
	local aReturn 	:= {}	as array

	FWMsgRun(, {|oSay| aReturn := Piperun.Pipelines.U_PipelineIntegration()}, "Aguarde!", "Realizando a integração com PipeRun...")

	lSend := aReturn[1]
	cMsg  := aReturn[2]

	if lSend
		fwAlertSuccess("Integrado com sucesso!")
	else
		fwAlertInfo(cMsg , "Atenção!")
	endif

return

user function GetPipeline()
	local lSend 	:= .F.	as logical

	FwMsgRun(, {|oSay| lSend := Piperun.Pipelines.U_GetAllPipeline()}, "Aguarde!", "Realizando a integração com PipeRun...", )

	if lSend
		fwAlertSuccess("Integrado com sucesso!")
	else
		fwAlertWarning("Falha na integração!")
	endif

return

user function GetStages()
	local lSend 	:= .F.	as logical

	FwMsgRun(, {|oSay| lSend := Piperun.Pipelines.U_GetStages(ZTA->ZTA_PIPERU)}, "Aguarde!", "Realizando a integração com PipeRun...", )

	if lSend
		fwAlertSuccess("Integrado com sucesso!")
	else
		fwAlertWarning("Falha na integração!")
	endif

return

user function PostStages()
	local lSend 	:= .F.	as logical

	FwMsgRun(, {|oSay| lSend := Piperun.Pipelines.U_PostStages(ZTA->ZTA_PIPERU)}, "Aguarde!", "Realizando a integração com PipeRun...", )

	if lSend
		fwAlertSuccess("Integrado com sucesso!")
	else
		fwAlertWarning("Falha na integração!")
	endif

return
