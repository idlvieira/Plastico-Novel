#include 'totvs.ch'
#include 'protheus.ch'

user function MTA040MNU()
	aadd(aRotina,{'-> Enviar PipeRun ','u_chkSA3()' , 0 , 3,0,NIL})
	aadd(aRotina,{'-> Sincr ','u_chkSU5()' , 0 , 3,0,NIL})
Return

user function chkSA3()
	local cPipeRun := SA3->A3_PIPERUN

	if empty(cPiperun)
		FWMsgRun(, {|oSay| PipeRun.Users.u_SendUsers(SA3->A3_COD)}, "Aguarde!", "Realizando a integração com PipeRun...")
	else
		FwAlertInfo("Este cadastro ja integrado no PipeRun!" + CRLF +;
			"Codigo da integração: " + cPipeRun)
	endif
return


user function chkSU5()
	FWMsgRun(, {|oSay| PipeRun.Persons.u_GetAllPersons()}, "Aguarde!", "Sincronizando dados com PipeRun...")
return
