#include 'totvs.ch'

user function MT040DEL()
	local cPipeRun := SA3->A3_PIPERUN

	If !Empty(cPipeRun)
		PipeRun.Users.u_DeleteUsers(cPipeRun)
	endif
return
