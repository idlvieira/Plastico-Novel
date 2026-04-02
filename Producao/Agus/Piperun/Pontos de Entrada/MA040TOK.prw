#include 'totvs.ch'

user function MA040TOK()
	local lOK := .T. as logical

	Local cPipeRun := ""
	Local aCampos := {}
	local logger    as object    // instância da classe ChangeLogger
	local oldValues as json      // valores antigos
	local newValues as json      // valores novos
	local struct    as array     // estrutura de campos
	local index     as numeric   // controle de FOR

	If ALTERA
		cPipeRun := M->A3_PIPERUN

		If !Empty(cPipeRun)
			// recupera estrutura de campos
			struct    := FWSX3Util():getAllFields('SA3', .F.)

			// cria JsonObject
			oldValues := JsonObject():new()
			newValues := JsonObject():new()

			for index := 01 to len(struct)
				oldValues[struct[index]] := SA3->&(struct[index])
				newValues[struct[index]] := M->&(struct[index])
			next index

			// cria instância da classe
			logger := load.change.logger.ChangeLogger():new('SA3', SA3->(recno()), '', '')
			logger:setOperation(04)
			logger:setOldValues(oldValues)
			logger:setNewValues(newValues)
			logger:compare()

			// recupera resultado
			aCampos := logger:getResult()

			PipeRun.Users.u_PutUsers(cPipeRun, aCampos)
		EndIf
	endIf
return lOK
