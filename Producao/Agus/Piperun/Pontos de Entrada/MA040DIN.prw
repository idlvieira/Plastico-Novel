#include 'totvs.ch'

user Function MA040DIN()
	local cActive := M->A3_MSBLQL as character

	if  cActive== "2"
		PipeRun.Users.U_SendUsers(SA3->A3_COD)
	endif

Return
