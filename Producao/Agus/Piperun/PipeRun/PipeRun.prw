#Include "Totvs.ch"
#include 'tbiconn.ch'

/*/{Protheus.doc} PipeRun
    Processa fila de inclusão de registro no CRM PipeRun
    @type  Function
    @author TOTVS
    @since 04/03/2024
    @version 1.0
/*/
User function PipeRun(aParams as array)
	// verifica se recebeu os parâmetros de conexão
	if (valType(aParams) == 'A')
		cLock := 'PipeRun'
		if (conecta(aParams, cLock))
			conOut('>>PipeRun Inicio - Prospects<<')
			PipeRun.Prospects.U_ProspectsIntegration()
			conOut('>>PipeRun Fim - Prospects<<')

			conOut('>>PipeRun Inicio - Persons<<')
			PipeRun.Persons.U_PersonsIntegration()
			conOut('>>PipeRun Fim - Persons<<')

			conOut('>>PipeRun Inicio - Companies<<')
			PipeRun.Companies.U_CompaniesIntegration()
			conOut('>>PipeRun Fim - Companies<<')

			desconecta(cLock)
		endIf
	endIf
return

/*/{Protheus.doc} conecta
    Responsável pela conexão na empresa e filial para
    rotinas via JOB
    @type  Function
    @author Lucas Vieira - Agus Consultoria
    @since 04/03/2024
    @version 1.0
    @param aParams    , array    , parâmetros de conexão
    @param cLock      , character, ID do lock
    @return lConectado, logical, conectado com sucesso?
/*/
static function conecta(aParams as array, cLock as character) as logical
	local lConectado as logical // conectado com sucesso?
	local cCodEmp    as character // código da empresa
	local cCodFil    as character // código da filial
	local cCodUsu    as character // código do usuário
	local cCodAgen   as character // código do agendamento

	// recupera os valores
	cCodEmp  := aParams[01]
	cCodFil  := aParams[02]
	cCodUsu  := aParams[03]
	cCodAgen := aParams[04]

	// conecta
	RpcSetType ( 3 )
	PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil MODULO "FAT"

	// verifica se a rotina já está em uso
	if (lockByName(cLock, .T., .T.))
		lConectado := .T.
		conOut('Conectado com Sucesso empresa/filial "' +;
			cCodEmp + '/' + cCodFil + '"')
	else
		lConectado := .F.
		conOut('Rotina "' + cLock + '" ja esta em uso para empresa/filial "' +;
			cCodEmp + '/' + cCodFil + '"')
	endIf
return lConectado

/*/{Protheus.doc} desconecta
    Responsável pela desconexão na empresa e filial para
    rotinas via JOB
    @type  Function
    @author Lucas Vieira - Agus Consultoria
    @since 04/03/2024
    @version 1.0
    @param cLock         , character, ID do lock
    @return lDesconectado, logical  , desconectado com sucesso?
/*/
static function desconecta(cLock as character) as logical
	local lDesconectado as logical // desconectado com sucesso?

	lDesconectado := .T.

	// desbloqueia o lock da função
	unlockByName(cLock, .T., .T.)

	// desconecta
	RESET ENVIRONMENT
	RpcClearEnv()
return lDesconectado
