//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function MYTMK01
	Importacao Tabela de Precos em formato CSV
	@author Lucas Vieira | Agus Consultoria
	@since 08/10/2024
	@version 1.0
	@type function
/*/

static __nTamFile		:= 100
static __nTamUF			:= 2
static __nTamTabela     := FWTamSX3("DA1_CODTAB")[1]
static __nTamProd		:= FWTamSX3("DA1_CODPRO")[1]
static __nTamTpOper		:= FWTamSX3("DA1_TPOPER")[1]

user function MYTMK01()
	local aArea 		:= FWGetArea() 										as array
	local cUserAccess 	:= SuperGetMV("ES_IMPORT", .F., "000577, 000604, 000468")			as character

	if __cUserID $ cUserAccess
		ShowParam()
	else
		fwAlertInfo("Usuario sem acesso a rotina!")
	endif

	FWRestArea(aArea)
Return

/*/{Protheus.doc} fImporta
	Função que processa o arquivo e realiza a importação para o sistema
	@author Lucas Vieira | Agus Consultoria
	@since 08/10/2024
	@version 1.0
	@type function
/*/

static function fImporta()
	local nTotLinhas := 0					as numeric
	local cLinAtu    := ''					as character
	local nLinhaAtu  := 0					as numeric
	local aLinha     := {}					as array
	local aDados	 := {}					as array
	local oArquivo	 := nil					as object
	local cArqSel    := alltrim(MV_PAR03) 	as character

	private cAliasImp  := 'DA1'
	private cSeparador := ';'

	DbSelectArea(cAliasImp)
	(cAliasImp)->(DbSetOrder(1))
	(cAliasImp)->(DbGoTop())

	oArquivo := FWFileReader():New(cArqSel)

	if (oArquivo:Open())
		if ! (oArquivo:EoF())
			aLinhas := oArquivo:GetAllLines()
			nTotLinhas := Len(aLinhas)
			ProcRegua(nTotLinhas)

			oArquivo:Close()
			oArquivo := FWFileReader():New(cArqSel)
			oArquivo:Open()

			while (oArquivo:HasLine())

				nLinhaAtu++
				IncProc('Analisando linha ' + cValToChar(nLinhaAtu) + ' de ' + cValToChar(nTotLinhas) + '...')

				cLinAtu := oArquivo:GetLine()
				aLinha  := Separa(cLinAtu, cSeparador)

				if Len(aLinha) > 0
					aLinha[2] := StrTran(aLinha[2], '.', '')
					aLinha[2] := StrTran(aLinha[2], ',', '.')
					aLinha[2] := Val(aLinha[2])

					aLinha[4] := StrTran(aLinha[4], '.', '')
					aLinha[4] := StrTran(aLinha[4], ',', '.')
					aLinha[4] := Val(aLinha[4])

					aLinha[1] := AvKey(aLinha[1], 'DA1_CODPRO')
					aLinha[3] := AvKey(aLinha[3], 'DA1_TPOPER')

					aAdd(aDados, aClone(aLinha))
				endIf
			endDo

			if !empty(aDados)
				Process(aDados)
			endif

		else
			FWAlertError('Arquivo não tem conteúdo!', 'Atenção')
		endIf
		oArquivo:Close()
	else
		FWAlertError('Arquivo não pode ser aberto!', 'Atenção')
	endIf
return

static function Process(aDados)
	local nIndex  	:= 0 	as numeric
	local cItem		:= "" 	as character
	local lProd		:= .F.	as logical
	local nCount 	:= 0	as numeric
	local lSuccess	:= .F.	as logical

	if len(aDados) > 0
		ProcRegua(len(aDados))

		DbSelectArea("DA0")
		DbSelectArea("DA1")

		for nIndex := 1 to len(aDados)
			DA0->(DbSetOrder(01))//	DA0_FILIAL+DA0_CODTAB
			if DA0->(dbSeek(FwxFilial("DA0")+padR(MV_PAR01, __nTamTabela)))
				DA1->(DbOrderNickName("MYDA100001"))//	Cod. Tabela+Cod.Produto+Tipo Operac.)
				if !DA1->(dbSeek(FwxFilial("DA1")+padR(MV_PAR01, __nTamTabela)+padR(aDados[nIndex][1],__nTamProd)+padR(aDados[nIndex][3], __nTamTpOper)))
					cItem := NumDA1()
					lProd := !empty(Posicione("SB1",1,FwxFilial("SB1")+padR(aDados[nIndex][1],__nTamProd),"B1_DESC"))

					if lProd
						IncProc('Gravando registro' + cValToChar(nIndex) + ' de ' + cValToChar(len(aDados)) + '...')
						if DA1->(reclock("DA1", .T.))
							DA1->DA1_FILIAL		:= FwxFilial("DA1")
							DA1->DA1_CODTAB		:= MV_PAR01
							DA1->DA1_ITEM		:= cItem
							DA1->DA1_CODPRO		:= aDados[nIndex][1]
							DA1->DA1_PRCVEN		:= aDados[nIndex][2]
							DA1->DA1_DATVIG		:= dDataBase
							DA1->DA1_QTDLOT		:= 999999.99
							DA1->DA1_MOEDA		:= aDados[nIndex][4]
							DA1->DA1_TPOPER		:= aDados[nIndex][3]
							DA1->DA1_ATIVO		:= '1'
							DA1->DA1_ESTADO		:= MV_PAR02
							DA1->DA1_ZZUSER		:= UsrFullName(__cUserID)
							DA1->(MsUnlock())
							nCount++
							lSuccess := .T.
						endif
					endif
				endif
			else
				fwAlertInfo("Não foi possivel posicionar na tabela "+MV_PAR01, "Atenção")
				exit
			endif
		next nIndex

		if lSuccess .and. nCount > 0
			FWAlertSuccess("Foram importados " + cValToChar(nCount) + " registros, para tabela de preço "+ MV_PAR01 + ".", "Sucesso!")
		endIf
	endIf
return

static function NumDA1()
	local cItem 		:= "" 		as character
	Local cTemp			:= ""		as Character
	Local cQuery 		:= ""		as Character
	Local oStatement 	:= nil		as Object

	cQuery := "SELECT MAX(DA1_ITEM) AS MAX  " +;
		"FROM " + RetSqlName("DA1") + ;
		" WHERE DA1_FILIAL = ? " +;
		" AND DA1_CODTAB = ? " + ;
		" AND D_E_L_E_T_ = ' ' "

	oStatement := FWPreparedStatement():New()
	oStatement:SetQuery(cQuery)
	oStatement:SetString(1,FWxFilial("DA1"))
	oStatement:SetString(2,MV_PAR01)

	cQuery := oStatement:GetFixQuery()
	cTemp  := mpsysopenquery(cQuery)
	cItem   := Alltrim((cTemp)->MAX)
	cItem := Soma1(cItem)

	(cTemp)->(dbCloseArea())

return cItem
static function ShowParam()
	Local aPergs    := {}     As Array
	Local aResps    := {}     As Array
	Local cPerg     := ""     As Character
	Local xValue    := ""     As Variant

	cPerg     := "MYTMK01_"+__cUserID

	//MV_PAR01 -> Cod. Tabela
	xValue := paramLoad(cPerg, aPergs, 01, "")
	aAdd(aPergs, {;
		01,; //[01] - Type --> 02 --> Combobox
	"Cod. Tabela: ",; //[02] - Descrição
	space(__nTamTabela),; //[03] - Inicializador Padrão
	"@!",; //[04] - Picture
	"AllwaysTrue()",; //[05] - Validação
	"DA0",; //[06] - Consulta F3
	"AllwaysTrue()",; //[07] - Validação WHEN
	80,; //[08] - Tamanho
	.T.; //[09] - Obrigatório?
	};
		)
	aAdd(aResps, xValue)

	//MV_PAR02 -> Estado
	xValue := paramLoad(cPerg, aPergs, 02, "")
	aAdd(aPergs, {;
		01,; //[01] - Type --> 02 --> Combobox
	"UF: ",; //[02] - Descrição
	Space(__nTamUF),; //[03] - Inicializador Padrão
	"@!",; //[04] - Picture
	"AllwaysTrue()",; //[05] - Validação
	"JUR12",; //[06] - Consulta F3
	"AllwaysTrue()",; //[07] - Validação WHEN
	80,; //[08] - Tamanho
	.T.; //[09] - Obrigatório?
	};
		)
	aAdd(aResps, xValue)

	//MV_PAR03 -> Arquivo
	xValue := paramLoad(cPerg, aPergs, 03, "")
	aAdd(aPergs, {;
		06,; //[01] - Type --> 06 --> file
	"Arquivo: ",; //[02] - Descrição
	Space(__nTamFile),; //[03] - Inicializador Padrão
	"",; //[4]-String contendo a Picture do campo
	"",; //[5]-String contendo a validacao
	"",; //[6]-String contendo a validacao When
	80,; //[7]-Tamanho do MsGet
	.T.,;//[8]Flag .T./.F. Parametro Obrigatorio ?
	"Arquivos .CSV |*.CSV",; //[9]Texto contendo os tipos de arquivo
	"c:\temp\",; //[10]-Diretorio inicial do cGetFile
	})

	aAdd(aResps, xValue)

	if (paramBox(aPergs, "Parâmetros", @aResps, , , , , , , cPerg, .T.))
		paramSave(cPerg, aResps, "1")
		fImporta()
	endIf
return
