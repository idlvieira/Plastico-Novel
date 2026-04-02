#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"
#Include "TopConn.ch"

/*
Requisitos para funcionamento:
	- Configurar o serviço de Rest no Protheus:
		https://sempreju.com.br/webservice-rest-no-erp-protheus-part-1/
		https://tdn.totvs.com/pages/releaseview.action?pageId=519719292
	- appServer.ini ajustes
		- adicionar a chave [general]
				BuildKillUsers=1 ; derruba as conecções ao compilar [indicado para desenvolvimento apenas]
		- Ativar autenticação no REST: [HTTPREST]
				Security=1
		- Definir porta REST: [HTTPREST]
				Port=8084
Ex query:

" Select A1_COD as Code,A1_NOME from " + RetSqlName('SA1') + " where A1_COD= '000001' and D_E_L_E_T_ = '' "

*/


/*/{Protheus.doc} QUERYAPI
WS criado para receber uma query no post da requisição e devolver os dados da consulta em JSON
@description fonte criado para Equipe QUERYAPI, Para mais informações acesse: www.sempreju.com.br
@type function
@author Equipe QUERYAPI
@since Mar|2021
@version	12.1.27
/*/

WSRESTFUL QUERYAPI DESCRIPTION "API responsavel por receber query e devolver JSON com resultados" FORMAT APPLICATION_JSON
	WSDATA query AS STRING	OPTIONAL

	//Endereço para pegar os dados
	WSMETHOD POST queryExec DESCRIPTION 'Execução de Query' WSSYNTAX '/' PATH '/' PRODUCES APPLICATION_JSON  //-- Retorna SQL em json

	WSMETHOD POST approve DESCRIPTION 'Aprovação de Orçamento' WSSYNTAX '/approve/' PATH '/approve/' PRODUCES APPLICATION_JSON  //-- Retorna SQL em json
	WSMETHOD POST reject DESCRIPTION 'Reprovação de Orçamento' WSSYNTAX '/reject/' PATH '/reject/' PRODUCES APPLICATION_JSON  //-- Retorna SQL em json

END WSRESTFUL

WSMETHOD POST approve WSREST QUERYAPI
	Local lRet:= .T.
	local cBody := self:getContent()
	local jBody := JsonObject():new()
	local jResponse := JsonObject():new()

	jBody:fromJson(cBody)

	self:SetContentType("application/json")
	
	// posiciona no orçamento
	SUA->(dbSetOrder(01)) // UA_FILIAL + UA_NUM
	if (SUA->(dbSeek(FWxFilial('SUA') + jBody['id'])))
		u_LIBDESC()
		
		jResponse['success'] := .T.
		jResponse['message'] := "Orçamento " + jBody['id'] + " liberado com sucesso"
	else
		jResponse['success'] := .F.
		jResponse['message'] := "Orçamento " + jBody['id'] + " nao encontrado"
	endIf

	self:setResponse(jResponse:toJson())

return lRet

WSMETHOD POST reject WSREST QUERYAPI
Local lRet:= .T.
	local cBody := self:getContent()
	local jBody := JsonObject():new()

	jBody:fromJson(cBody)

	self:SetContentType("application/json")
	self:setResponse('{"api": "reject", "body": ' + jBody:toJson() + '}')

return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} POST / queryExec
Retorna execução da query
@param
@return cResponse, caracter, JSON contendo resultado da query

@author Equipe QUERYAPI
@since		Mar|2021
@version	12.1.27
/*/
//-------------------------------------------------------------------
WSMETHOD POST queryExec WSRECEIVE searchKey, page, pageSize, branch WSREST QUERYAPI
Local lRet:= .T.
Local cBody
// recupera o body da requisição
cBody := ::GetContent() //query

// Validação do pacote
//if date() <= '20210420'
//	::SetResponse("Pacote desatualizado")
//else
::SetResponse(RunQuery( cBody  , self))
//Endif


Return( lRet )





//-------------------------------------------------------------------
/*/{Protheus.doc} RunQuery
Retorna JSON com o resultado da Query
@param cQuery, self
@return
@author Equipe QUERYAPI
@since		Mar|2021
@version	12.1.27
/*/
//-------------------------------------------------------------------
Static Function RunQuery( cQuery  , oSelf)
	Local oJsonCli	:= JsonObject():New()
	Local cAlias	:= GetNextAlias()
	Local nAux		:= 0
	local nSize     := 0
	Local bOldError  := Nil //code-block Error
	Private cErrSQL  := "" //Savar mensagem de erro
	Private cSQLOld  := ''

	Begin Transaction
		//code-block error
		bOldError := ErrorBlock( {|x| VerifyError(x)} )
		//Query Sequence
		Begin Sequence
			// Realiza a query para selecionar clientes
			//conout(cQuery)
			cSQLOld := &cQuery

			cFinalQuery := ChangeQuery( cSQLOld )
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cFinalQuery), cAlias, .T., .T. )

			//Gera a estrutura do resultado em array para exportar com JSON
			aEstrut := (cAlias)->(DbStruct())

			//Creating Json File
			nLin := 0
			aListCli := {}
			While ( cAlias )->( ! Eof() )

				nLin ++
				aAdd( aListCli , JsonObject():New() )

				//Loop Columns
				For nAux := 1 To Len(aEstrut)

					if (FWSX3Util():getFieldType(aEstrut[nAux][1]) == 'D')
						aListCli[nLin][aEstrut[nAux][1]]	:= Alltrim( EncodeUTF8(( cAlias )->&(aEstrut[nAux][1])))
						aListCli[nLin][aEstrut[nAux][1]]    := left(aListCli[nLin][aEstrut[nAux][1]], 04) + '-' + subStr(aListCli[nLin][aEstrut[nAux][1]], 05, 02) + '-' + right(aListCli[nLin][aEstrut[nAux][1]], 02)
					ElseIf valType(( cAlias )->&(aEstrut[nAux][1])) == 'C' //remove encode
						aListCli[nLin][aEstrut[nAux][1]]	:= Alltrim( EncodeUTF8(( cAlias )->&(aEstrut[nAux][1])))
					else
						aListCli[nLin][aEstrut[nAux][1]]	:= ( cAlias )->&(aEstrut[nAux][1])
					Endif
				Next

				( cAlias )->( DBSkip() )
			End
			( cAlias )->( DBCloseArea() )
			oJsonCli['result'] := aListCli
			oJsonCli['struct'] := {}

			for nAux := 01 to len(aEstrut)
				if (getSX3Cache(aEstrut[nAux, 01], 'X3_BROWSE') == 'S')
					aAdd(oJsonCli['struct'], JsonObject():new())
					nSize := len(oJsonCli['struct'])

					oJsonCli['struct'][nSize]['id'] := aEstrut[nAux, 01]
					oJsonCli['struct'][nSize]['type'] := aEstrut[nAux, 02]
					oJsonCli['struct'][nSize]['size'] := aEstrut[nAux, 03]
					oJsonCli['struct'][nSize]['decimals'] := aEstrut[nAux, 04]
					oJsonCli['struct'][nSize]['title'] := FWNoAccent(getSX3Cache(aEstrut[nAux, 01], 'X3_TITULO'))
					oJsonCli['struct'][nSize]['title'] := iIf(empty(oJsonCli['struct'][nSize]['title']), aEstrut[nAux, 01], oJsonCli['struct'][nSize]['title'])
				endIf
			next nAux

			oJsonCli['success'] := .T.
			Recover
			//Restore Transaction
			DisarmTransaction()
		End Sequence
		//Restore old error
		ErrorBlock( bOldError )
	End Transaction
	If !(Empty(cErrSQL))
		//conout(cErrSQL)
		oJsonCli['result'] := AllTrim(cErrSQL) //return erro to REST
		oJsonCli['success'] := .F.
	EndIf

Return oJsonCli






/*/{Protheus.doc} VerifyError
Returns Fatal Error in Process
@author Equipe QUERYAPI
@since		Mar|2021
@version	12.1.27
/*/
Static Function VerifyError(e)
	Local lRet 		 := .F.
	Local cErrorText := ''

	If e:GenCode > 0
		cErrorText := EncodeUTF8("Descrição" + e:Description) + CRLF + CRLF
		cErrorText += "ERRORSTACK: " + CRLF
		cErrorText += e:ErrorStack

		//Adicionando Erro
		cErrSQL += 'SQL Query: ' + CRLF + cSQLOld + CRLF + CRLF +"  ####  "+ cErrorText + CRLF //'SQL Query: '

		lRet := .T.

		Break
	EndIf
Return lRet
