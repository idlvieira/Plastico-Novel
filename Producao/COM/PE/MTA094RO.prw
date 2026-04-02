/* Includes e defines */
#Include 'Protheus.ch'

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MTA094RO.prw    | Autor : Leandro Ferreira      | Data : 27/11/2022|\
/|-------------------------------------------------------------------------------|\
/| Descricao: Incluir botão de conhecimento na liberação de documentos           |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 27/11/2022  Leandro Ferreira          Jaqueline Chen  Criação do PE   

User Function MTA094RO()
	Private aRotina:= PARAMIXB[1]

	Aadd(aRotina,{'Documentos',"U_MSdoc()", 0, 4,0,NIL})

//Validações do usuário

Return (aRotina)


User Function MSdoc()

	Local _aArea		:= GetArea()
	Private aRotina := FWloadmenudef('MATA094')
	PRIVATE _TIPO	:= CR_TIPO
	PRIVATE _NUM	:= CR_NUM
	IF _TIPO == 'PC'
		dbSelectArea('SC7')
		dbSetOrder(1)
		dbSeek(xFilial('SC7')+_NUM, .T.)
		MsDocument('SC7',SC7->(RecNo()), 4)
	ELSE 
		dbSelectArea('SC3')
		dbSetOrder(1)
		dbSeek(xFilial('SC3')+_NUM, .T.)
		MsDocument('SC3',SC3->(RecNo()), 4)
	ENDIF
	RestArea( _aArea )
return .t.
