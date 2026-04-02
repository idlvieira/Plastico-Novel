#include 'totvs.ch'
#include 'Protheus.ch'

/*/{Protheus.doc} User Function MA070TOK
    ponto de entrada no cadastro de contatos
    @type Function
    @author Lucas Silva Vieira | Agus Consultoria
    @since 06/05/2024
    @version 2210
    @seek https://tdn.totvs.com/pages/releaseview.action?pageId=6787820
/*/
function U_MA070TOK()
	local lRet      := .T.                      as logical
	local cPiperun  := Alltrim(M->U5_PIPERUN)   as character
	local aCampos   := {}                       as array
	local logger    := nil                      as object    // instância da classe ChangeLogger
	local oldValues                             as json      // valores antigos
	local newValues                             as json      // valores novos
	local struct    := {}                       as array     // estrutura de campos
	local nIndex    := 0                        as numeric   // controle de FOR

	/*if FunName() == "TMKA271"
		if inclui .or. altera
			if empty(cPiperun)
				if SU5->(dbSeek(FWxFilial("SU5") + M->U5_CODCONT ))
						if RecLock("SU5", .F.)
							SU5->U5_XINTEGR := "S"
							SU5->U5_XLOGINT := "Log de integração: " + CRLF + ;
								"Data : " + Dtoc(Date()) + CRLF +;
								"Hora: " + time()
							SU5->(msUnlock())
						endif
					endif
				//PipeRun.Persons.u_SendPerson()
			endIf
		endif
	endif*/

	if altera 
		if !empty(cPiperun)
			struct    := FWSX3Util():getAllFields('SU5', .F.)
			// cria JsonObject
			oldValues := JsonObject():new()
			newValues := JsonObject():new()

			for nIndex := 01 to len(struct)
				oldValues[struct[nIndex]] := SU5->&(struct[nIndex])
				newValues[struct[nIndex]] := M->&(struct[nIndex])
			next nIndex

			// cria instância da classe
			logger := load.change.logger.ChangeLogger():new('SU5', SU5->(recno()), '', '')
			logger:setOperation(04)
			logger:setOldValues(oldValues)
			logger:setNewValues(newValues)
			logger:compare()

			// recupera resultado
			aCampos := logger:getResult()

			PipeRun.Persons.U_PutPersons(cPipeRun, aCampos)
		endif
	else
		/*exclusão
		if !empty(cPiperun)
			PipeRun.Persons.U_DeletePersons(cPiperun)
		endif*/
	endif
	

return lRet
