#Include "protheus.ch"

/*/{Protheus.doc}	MYTMK21
Grava o log de Orcamento de Vendas

@type				function
@author				NEWTON RECA ALVES
@since				04/01/2017
@obs				Callcenter e Faturamento
/*/
user function MYTMK21(cTipo, cStatus, cTPoperacao, cAprovador, nNivel) //User Function MYFAT02()

	local aAreaATU		:= getArea()
	local nOrcamento	:= SUA->UA_NUM

	ZZW->(dbSetOrder(1))

	if cTPoperacao	== "I"
		recLock("ZZW", .t.)
			ZZW->ZZW_FILIAL			:= xFilial("ZZW")
			ZZW->ZZW_MYORC			:= nOrcamento
			ZZW->ZZW_MYDAT			:= ddatabase
			ZZW->ZZW_MYHOR			:= time()
			ZZW->ZZW_MYSTA			:= cStatus
			ZZW->ZZW_MYNIV			:= nNivel
			ZZW->ZZW_MYBLO			:= ""
			ZZW->ZZW_MYLOG			:= cAprovador
			ZZW->ZZW_MYTIP			:= cTipo
		ZZW->(msUnLock())
	elseIf cTPoperacao	== "A"		// Bloquear antigos
		ZZW->(dbSeek(xFilial("ZZW") + nOrcamento))
		do while ZZW->(!eof()) .and. allTrim(ZZW->ZZW_MYORC) == allTrim(nOrcamento)
			recLock("ZZW", .f.)
				ZZW->ZZW_MYBLO		:= "B"
				//ZZW->ZZW_MYTIP	:= cTipo
			ZZW->(msUnLock())

			ZZW->(dbSkip())
		endDo

		// Registro novo com o bloqueio
		recLock("ZZW", .t.)
			ZZW->ZZW_FILIAL			:= xFilial("ZZW")
			ZZW->ZZW_MYORC			:= nOrcamento
			ZZW->ZZW_MYDAT			:= dDataBase
			ZZW->ZZW_MYHOR			:= time()
			ZZW->ZZW_MYSTA			:= cStatus
			ZZW->ZZW_MYNIV			:= nNivel
			ZZW->ZZW_MYBLO			:= ""
			ZZW->ZZW_MYLOG			:= cAprovador
			ZZW->ZZW_MYTIP			:= cTipo
		ZZW->(msUnLock())
	elseIf cTPoperacao	== "L"		// Registro novo com a liberacao
		recLock("ZZW", .t.)
			ZZW->ZZW_FILIAL			:= xFilial("ZZW")
			ZZW->ZZW_MYORC			:= nOrcamento
			ZZW->ZZW_MYDAT			:= dDataBase
			ZZW->ZZW_MYHOR			:= time()
			ZZW->ZZW_MYSTA			:= cStatus
			ZZW->ZZW_MYNIV			:= nNivel
			ZZW->ZZW_MYBLO			:= ""
			ZZW->ZZW_MYLOG			:= cAprovador
			ZZW->ZZW_MYTIP			:= cTipo
		ZZW->(msUnLock())
	endIf

	restArea(aAreaATU)

return
