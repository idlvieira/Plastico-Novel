#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYCFG02   º Autor ³ NEWTON ALVES      º Data ³ 15/11/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TELA DE TABELA DE PARAMETRIZACAO PERSONALIDADA - LOOP      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ USADO PARA BUSCAR OS PARAMETROS NA TABELA PERSONALIZADA    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MYCFG02(_cCondicao, _cItem, _cTipo, _cCampo, _cTPRetorno)

	local aAreaATU		:= getArea()

	ZZZ->(DBSetorder(1))
	If ZZZ->(DBSeek(xFilial("ZZZ") + LTRIM(RTRIM(_cCondicao)) + RTRIM(LTRIM(_cItem))))
		//Busca um unico registro em um grupo de codigo referente a condicao e retorna o campo ZZZ_RETORNO geralmente usado em gatilho 
		If RTRIM(LTRIM(_cTipo)) == "L" //LOOP
			_lFim := .T.
			do while ZZZ->(!eof()) .and. RTRIM(LTRIM(_cCondicao)) == RTRIM(LTRIM(ZZZ->ZZZ_COD)) .and. _lFim
				_cComparacao := Rtrim(Ltrim(ZZZ->ZZZ_CONDIC)) + Rtrim(Ltrim(ZZZ->ZZZ_CONDI2))
				If &(_cComparacao)
					_cRetorno := ZZZ->ZZZ_RETORN
					_lFim := .F.
				EndIf

				ZZZ->(DBSkip())
			EndDo

			If upper(_cTpRetorno) == "N"
				_cRetorno	:= Val(_cRetorno)
			Endif

			//Retorna o conteudo dos campos Condicoes referente a busca - semelhante a funcao Posicione mas retorna os dois campos juntos de condicoes
		ElseIf RTRIM(LTRIM(_cTipo)) == "V" //POSICIONE
			_cRetorno := Rtrim(Ltrim(ZZZ->ZZZ_CONDIC)) + Rtrim(Ltrim(ZZZ->ZZZ_CONDI2))

			//Retorna o conteudo do campo ZZZ_RETORN referente a busca - semelhante a funcao Posicione
		ElseIf RTRIM(LTRIM(_cTipo)) == "P" //POSICIONE
			_cRetorno := ZZZ->ZZZ_RETORN
			If _cTpRetorno == "N" .or. _cTpRetorno == "n"
			//If upper(_cTpRetorno) == "N"
				_cRetorno	:= Val(_cRetorno)
			Endif

			//Retorna o conteudo do campo ZZZ_RETORN referente a busca - semelhante a funcao Posicione
		ElseIf RTRIM(LTRIM(_cTipo)) == "H" //POSICIONE
			_cRetorno := ZZZ->ZZZ_HELP

			//Verifica se o conteudo informado em um campo pertence a tabela ZZZ - semelhante tabela SX5
		ElseIf RTRIM(LTRIM(_cTipo)) == "C" //CHECK
			_lFim		:= .T.
			_cRetorno	:= .F.
			do while ZZZ->(!eof()) .and. RTRIM(LTRIM(_cCondicao)) == RTRIM(LTRIM(ZZZ->ZZZ_COD)) .and. _lFim
				If Rtrim(Ltrim(ZZZ->ZZZ_DESCCO)) == Rtrim(Ltrim(&_cCampo))
					_cRetorno	:= .T.
					_lFim		:= .F.
				EndIf

				ZZZ->(DBSkip()) 
			EndDo

			If _cRetorno == .F.
				alert("Registro Invalido, favor incluir um conteudo valido !!")
			EndIf
		Else
			_cRetorno := ""
		EndIf
	Else
		_cRetorno := ""
	Endif

	restArea(aAreaATU)

return _cRetorno
