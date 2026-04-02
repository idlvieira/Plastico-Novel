//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function PE_TMKA260
	Prospects
	@author Lucas Silva Vieira
	@since 06/05/2024
	@version 1.0
	@type function
/*/

User Function TMKA260()
	Local aArea 	:= FWGetArea()
	Local aParam 	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= Nil
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
	Local cPipeRun := ""
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

		//Na validacao total do modelo
		If cIdPonto == "MODELPOS"
			if (FWIsInCallStack('EXECUTEMODELPOSVLD'))
				nOper := oObj:nOperation
				cPipeRun := oObj:getValue('SUSMASTER', 'US_PIPERUN')

				If nOper == 4
					If !Empty(cPipeRun)
						// recupera estrutura de campos
						struct    := FWSX3Util():getAllFields('SUS', .F.)

						aFields := oObj:getMOdel('SUSMASTER'):getStruct():getFields()

						// cria JsonObject
						oldValues := JsonObject():new()
						newValues := JsonObject():new()

						for index := 01 to len(struct)
							// verificar se existe no modelo
							if (aScan(aFields, {|x| AllTrim(x[03]) == AllTrim(struct[index])}) > 0)
								oldValues[struct[index]] := SUS->&(struct[index])
								newValues[struct[index]] := oObj:getValue('SUSMASTER', struct[index])
							endif
						next index

						// cria instância da classe
						logger := load.change.logger.ChangeLogger():new('SUS', SUS->(recno()), '', '')
						logger:setOperation(nOper)
						logger:setOldValues(oldValues)
						logger:setNewValues(newValues)
						logger:compare()

						// recupera resultado
						aCampos := logger:getResult()

						PipeRun.Prospects.u_PutProspects(cPipeRun, aCampos)
					Endif
				ElseIf nOper == 5
					If !Empty(cPipeRun)
						PipeRun.Prospects.u_DeleteProspects(cPipeRun)
					endif
				Endif
			Endif
		elseif cIdPonto == "MODELCOMMITNTTS"
			if M->US_MSBLQL == "2"
				PipeRun.Prospects.U_SendProspects()
			endIf
		elseIf cIdPonto == "BUTTONBAR" 
            xRet := {{' -> Enviar Piperun','Piperun',{|| PipeRun.Prospects.u_SendProspects()}}}      
		endif

	EndIf

	FWRestArea(aArea)
Return xRet
