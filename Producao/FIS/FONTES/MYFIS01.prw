#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYFIS01  º Autor ³Newton Reca Alves   º Data ³  19/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ALTERA O FLAG PARA BLOQUEADO DO CAMPO A2_MSBLQL QUANDO     º±±
±±º          ³ ALTERADO DADOS BANCARIOS NO CADASTRO DE FORNECEDOR         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CHAMADO PELO VALIDACAO DO CAMPO A2_CONTA                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 08/11/2023  Leandro Ferreira          				 Correção de fonte 

User Function MYFIS01()
       Local I 		:= ''
       Private _cLoginS := ''
       Private _cNomeCS := ''
       Private _cEmailS := ''
       Private _lAchou  := .F.
       Private aUsu		:= AllUsers(.T.)
       Private _cUsuario := RetCodUsr()
	
	M->A2_MSBLQL	:= "1"
	
	For I := 1 To Len(aUsu) 
		If upper(alltrim(aUsu[I,1,1]))==upper(alltrim(_cUsuario))
			_cLoginS 	:= aUsu[I,1,2] //Login do usuario
			_cNomeCS	:= aUsu[I,1,4] //Nome do usuario
			_cEmailS	:= Trim(aUsu[I,1,14]) //Email do usuario
			_lAchou		:= .T.
		EndIf
		If _lAchou
			Exit
		Endif
	Next

	M->A2_ZZSOLIC	:= upper(_cLoginS) //Substr(cusername,7,15)


Return .t.
