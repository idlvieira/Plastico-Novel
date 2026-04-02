#include 'totvs.ch'

User Function TK070INC()
	local lRet      := .T.                      as logical
	local cPiperun  := Alltrim(M->U5_PIPERUN)   as character

	if FunName() == "TMKA271"
		if inclui .or. altera
			if empty(cPiperun)
				PipeRun.Persons.u_SendPerson()
			endIf
		endif
	endif
	
Return lRet
