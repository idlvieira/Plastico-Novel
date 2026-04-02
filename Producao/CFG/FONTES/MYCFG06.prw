#Include "protheus.ch"
#Include "fwmvcdef.ch"	// Necessita desse include quando usar MVC.

#Define ZZZCAMPOS "ZZZ_COD|"

/*/{Protheus.doc}	MYCFG06
Cadastro no padrão MVC para manutenção na tabela "ZZZ"

@type				function
@author				Waldir Baldin
@since				22/08/2017
/*/
user function MYCFG06()

	local oBrowse		:= nil

	private _cUsrLgd	:= allTrim(upper(CUSERNAME))

	oBrowse := FWMBrowse():New()														// Instanciamento da Classe de Browse
	oBrowse:SetAlias("ZZZ")																// Definição da tabela do Browse

	if !FwIsAdmin()
		oBrowse:SetFilterDefault("_cUsrLgd $ ZZZ_USER")	// Definição de filtro
	endIf

	oBrowse:SetDescription("Parâmetros Customizados")									// Título da Browse
	oBrowse:Activate()																	// Ativação do Browse

return

/*/{Protheus.doc}	MenuDef
Rotina responsável por montar as opções permitidas

@type				function
@author				Waldir Baldin
@since				22/08/2017
/*/
static function MenuDef()

	local aRotina	:= {}

	ADD		OPTION aRotina Title "Visualizar"	Action "VIEWDEF.MYCFG06" OPERATION 2 ACCESS 0
	if FwIsAdmin()
		ADD	OPTION aRotina Title "Incluir"		Action "VIEWDEF.MYCFG06" OPERATION 3 ACCESS 0
	endIf
	ADD		OPTION aRotina Title "Alterar"		Action "VIEWDEF.MYCFG06" OPERATION 4 ACCESS 0
	if FwIsAdmin()
		ADD	OPTION aRotina Title "Excluir"		Action "VIEWDEF.MYCFG06" OPERATION 5 ACCESS 0
	endIf

return aRotina

/*/{Protheus.doc}	ModelDef
Rotina onde é montada a Model da aplicação

@type				function
@author				Waldir Baldin
@since				22/08/2017
/*/
static function ModelDef()

	local oStruZZZPAI	:= FWFormStruct(1, "ZZZ", {|cCampo|  allTrim(cCampo) + "|" $ ZZZCAMPOS})	// Cria as estruturas a serem usadas no Modelo de Dados - Pai
	local oStruZZZFIL	:= FWFormStruct(1, "ZZZ", {|cCampo| !allTrim(cCampo) + "|" $ ZZZCAMPOS})	// Cria as estruturas a serem usadas no Modelo de Dados - Filho
	local oModel		:= nil																		// Modelo de dados construído

	oModel := MPFormModel():New("ModelMYCFG06")														// Cria o objeto do Modelo de Dados. Para user Functions, este ID não pode ser igual ao nome da User Function
	oModel:AddFields("ZZZPAI", /*cOwner*/, oStruZZZPAI)												// Adiciona ao modelo um componente de formulário
	oModel:AddGrid("ZZZFIL", "ZZZPAI", oStruZZZFIL)													// Adiciona ao modelo uma componente de grid
	
	// Faz relacionamento entre os componentes do model
	oModel:SetRelation(	"ZZZFIL"								,;
						{	{"ZZZ_FILIAL",	"xFilial('ZZZ')"}	,;
							{"ZZZ_COD",		"ZZZ_COD"}}			,;
						ZZZ->(IndexKey(1))						)
	
	// Adiciona a descrição do Modelo de Dados
	oModel:SetDescription("Parâmetros Customizados")
	
	// Adiciona a descrição dos Componentes do Modelo de Dados
	oModel:GetModel("ZZZPAI"):SetDescription("Cabeçalho dos Parâmetros Customizados")
	oModel:GetModel("ZZZFIL"):SetDescription("Itens dos Parâmetros Customizados"	)

	if !FwIsAdmin()
		oModel:GetModel("ZZZFIL"):SetNoInsertLine(.t.)
		oModel:GetModel("ZZZFIL"):SetNoDeleteLine(.t.)
	endIf

	oModel:SetPrimaryKey({})

return oModel

/*/{Protheus.doc}	ViewDef
Rotina onde é montada a Model da aplicação

@type				function
@author				Waldir Baldin
@since				22/08/2017
/*/
static function ViewDef()

	local oStruZZZPAI	:= FWFormStruct(2, "ZZZ", {|cCampo|  allTrim(cCampo) + "|" $ ZZZCAMPOS})	// Cria as estruturas a serem usadas na View - Pai
	local oStruZZZFIL	:= FWFormStruct(2, "ZZZ", {|cCampo| !allTrim(cCampo) + "|" $ ZZZCAMPOS})	// Cria as estruturas a serem usadas na View - Filho
	local oModel		:= FWLoadModel("MYCFG06")													// Cria um objeto de Modelo de dados baseado no ModelDef do fonte informado
	local oView			:= nil																		// Interface de visualização construída
	
	oView := FWFormView():New()																		// Cria o objeto de View
	oView:SetModel(oModel)																			// Define qual Modelo de dados será utilizado
	oView:AddField("VIEW_ZZZPAI",	oStruZZZPAI, "ZZZPAI")											// Adiciona no nosso View um controle do tipo formulário	(antiga Enchoice)
	oView:AddGrid("VIEW_ZZZFIL",	oStruZZZFIL, "ZZZFIL")											// Adiciona no nosso View um controle do tipo Grid			(antiga Getdados)

	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox("SUPERIOR", 15)
	oView:CreateHorizontalBox("INFERIOR", 85)

	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView("VIEW_ZZZPAI", "SUPERIOR")
	oView:SetOwnerView("VIEW_ZZZFIL", "INFERIOR")

	oView:AddIncrementField("VIEW_ZZZFIL", "ZZZ_ITEM")

	oView:EnableTitleView("VIEW_ZZZPAI")
	oView:EnableTitleView("VIEW_ZZZFIL")

return oView
