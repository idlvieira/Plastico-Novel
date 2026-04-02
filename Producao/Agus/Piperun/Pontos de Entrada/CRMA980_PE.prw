//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function CRMA980
    Cadastro de Clientes
    @author Lucas SIlva Vieira
    @since 01/02/2023
/*/

User Function CRMA980()
	Local aArea := FWGetArea()
	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := Nil
	Local cIdPonto := ""
	Local cIdModel := ""
	Local cPipeRun := ""
	LocaL cloja	:= ""
	Local cCod := ""
	Local aCampos := {}
	local logger    as object    // instância da classe ChangeLogger
	local oldValues as json      // valores antigos
	local newValues as json      // valores novos
	local struct    as array     // estrutura de campos
	local index     as numeric   // controle de FOR
	local aFields   as array

	//Se tiver parametros
	If aParam != Nil

		//Pega informacoes dos parametros
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]

		// Na validação total do modelo.l7
		If cIdPonto == "MODELPOS"
			if (FWIsInCallStack('EXECUTEMODELPOSVLD'))
				nOper := oObj:nOperation
				cPipeRun := oObj:getValue('SA1MASTER', 'A1_PIPERUN')

				If nOper == 3 //Ponto de Entrada chamado após a inclusão do cliente

				ElseIf nOper == 4//Ponto de Entrada após a alteração do cliente -- u_M030ALT()
					If !Empty(cPipeRun)
						// recupera estrutura de campos
						struct    := FWSX3Util():getAllFields('SA1', .F.)

						aFields := oObj:getMOdel('SA1MASTER'):getStruct():getFields()

						// cria JsonObject
						oldValues := JsonObject():new()
						newValues := JsonObject():new()

						for index := 01 to len(struct)
							// verificar se existe no modelo
							if (aScan(aFields, {|x| AllTrim(x[03]) == AllTrim(struct[index])}) > 0)
								oldValues[struct[index]] := SA1->&(struct[index])
								newValues[struct[index]] := oObj:getValue('SA1MASTER', struct[index])
							endif
						next index

						// cria instância da classe
						logger := load.change.logger.ChangeLogger():new('SA1', SA1->(recno()), '', '')
						logger:setOperation(nOper)
						logger:setOldValues(oldValues)
						logger:setNewValues(newValues)
						logger:compare()

						// recupera resultado
						aCampos := logger:getResult()

						PipeRun.Companies.u_PutCompanies(cPipeRun, aCampos)
					EndIf
				ElseIf nOper == 5 //Ponto de Entrada executado após a exclusão do cliente, e dentro da transação --u_M030EXC()
					If !Empty(cPipeRun)
						PipeRun.Companies.u_DeleteCompanies(cPipeRun)
					endif
				EndIf
			EndIf
		elseIf cIdPonto == "MODELCOMMITNTTS"
			if oObj:getValue('SA1MASTER', 'A1_MSBLQL') == "2"
				cCod  := oObj:getValue('SA1MASTER', 'A1_COD')
				cloja := oObj:getValue('SA1MASTER', 'A1_LOJA')
				PipeRun.Companies.U_SendCompanies(SA1->A1_COD, SA1->A1_LOJA)
			endIf
		EndIf
	EndIf

	FWRestArea(aArea)
Return xRet

	#INCLUDE "PROTHEUS.CH"
	#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} User Function CRM980MDEF
Novo ponto de entrada para adicionar rotinas no novo cadastro de clientes (CRMA980)
@type  Function
@author lucas Silva Vieira
@since 15/05/2024
@see https://tdn.totvs.com/pages/releaseview.action?pageId=604230458

/*/

User Function CRM980MDEF()
	Local aArea := FWGetArea()
	Private aRotina := {}

	aAdd(aRotina,{"-> Piperun", "u_chkSA1()", 4, 6})

	FWRestArea(aArea)
Return aRotina

user function chkSA1()
	local cPiperun	:= SA1->A1_PIPERUN
	if empty(cPiperun)
		FWMsgRun(, {|oSay| PipeRun.Companies.U_SendCompanies(SA1->A1_COD, SA1->A1_LOJA)}, "Aguarde!", "Realizando a integração com PipeRun...")
	else
		FwAlertInfo("Este cadastro ja integrado no PipeRun!" + CRLF +;
			"Codigo da integração: " + cPipeRun)
	endif
return
