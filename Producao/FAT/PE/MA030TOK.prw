#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"
//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "Ap5Mail.ch"
//#include "fivewin.ch"
#include "font.ch"
#include "print.ch"
#include "dll.ch"
#include "folder.ch"
#include "msobject.ch"
#include "odbc.ch"
#include "dde.ch"
#include "video.ch"
#include "vkey.ch"
#include "tree.ch"
#include "winapi.ch"
#include "fwmsgs.ch"
#include "fwmsgs.h"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA030TOK º Autor ³Newton Reca Alves   º Data ³  02/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIA EMAIL PARA O RESPONSAVEL PELA LIBERACAO DE CADASTRO  º±±
±±º          ³ DE CLIENTE PARA LIBERAR O MESMO                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PONTO DE ENTRADA - CADASTRO DE CLIENTE                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//16/01/2019 Leonardo Bergamasco - Chamado Z6T-9EZ-EVS6 (108) - Inserido o envio do e-mail quando o cadastro é liberado pelo financeiro
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante      Motivo
// 29/08/2023  Leandro Ferreira          Totvs		   	  Migração para banco


User Function MA030TOK()

	local xArea			:= GETAREA()
	local xAreaSA1 		:= SA1->(GetArea())
	Local cBloq    		:= M->A1_MSBLQL
	local cEst			:= M->A1_EST
	local cCNPJ			:= M->A1_CGC
	local cLimite		:= M->A1_LC
	local oHtml			
	local oEmail
	local cServidor		:=	GetMv("MV_RELSERV")
	local cConta		:=	GetMv("MV_RELACNT")
	local cPassWord		:=	GetMv("MV_RELPSW")
	local cAutentic		:=	GetMv("MV_RELAUTH")
	local cAnexo		:= '' 	
	local cTitulo 		:= ""
	local aCorpo	  	:= {}
	local aRodape 		:= {} 
	local cAssunt1  	:= ""
	local cPara 		:= ""
	local cCC			:= ""
	local cCCo			:= ""  
	local cRemet 		:= GetMv("MV_RELACNT")
	local cDtHrEmiss	:= strZero(day(dDataBase), 02) + "/" + strZero(month(dDataBase), 02) + "/" + cValToChar(year(dDataBase)) + " - " + time()
	local cMyEmpFil		:= SM0->M0_CODIGO + "/" + allTrim(SM0->M0_FILIAL)
	Local _cUsuario     := ""

	If cEst<>'EX' .AND. EMPTY(cCNPJ)
		Alert("Campo Cnpj Obrigatorio!")
		Return .F.
	EndIf

	If M->A1_MSBLQL =='1' .and. Altera

        cPara    := (Posicione("ZZZ",1,xFilial("ZZZ")+"FIN000009"+"001","ZZZ_RETORN"))	
        cAssunt1 := "O Cliente "+SA1->A1_COD+ "/"+SA1->A1_lOJA+" está bloqueado para validacao credito."	
        
		aAdd(aCorpo, "<h2>Cadastro bloqueado em: " + cDtHrEmiss + " pela validacao de credito.</h2>")
		aAdd(aCorpo, "</p>")
		aAdd(aCorpo, "</p>")
		aAdd(aCorpo, "<h3>Dados do cliente</h3>")
		aAdd(aCorpo, "<b>Código/Loja: </b>"+AllTrim(M->A1_COD)+"/"+AllTrim(M->A1_LOJA))
		aAdd(aCorpo, "<b>Razão Social: </b>"+AllTrim(M->A1_NOME))
		aAdd(aCorpo, "</p>")
		aAdd(aCorpo, "<h3>Dados financeiro</h3>")
		aAdd(aCorpo, "<b>Risco: </b>"+M->A1_RISCO)
		aAdd(aCorpo, "<b>Vencimento: </b>"+DtoC(M->A1_VENCLC))
		aAdd(aCorpo, "<b>Limite: </b>"+Transform(M->A1_LC,"999,999,999.99"))
		aAdd(aCorpo, "<b>Observação: </b>"+Alltrim(M->A1_observ))
		aAdd(aCorpo, "</p>")
		aAdd(aRodape, "Obrigado(a)!")
		aAdd(aRodape, "Equipe Financeira")
		
		oHtml:= CorpoEmail():New(cTitulo, aCorpo, aRodape)
		oHtml:GeraHtml()	
		oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
		oEmail:EmailUsr()
		oEmail:Conectar()    
		If oEmail:Enviar(allTrim(cRemet), allTrim(cPara), allTrim(cCC), allTrim(cCCO), allTrim(cAssunt1), oHtml:cHtml, cAnexo)
			lRetorno	:=	.t.
			Aviso(FunDesc(),"E-mail enviado com SUCESSO.",{"OK"})
		EndIf
		oEmail:Desconec()    
	
	EndIf
	
	If M->A1_MSBLQL =='2' .and. Altera
	
      _cUsuario := Upper(AllTrim(U_MYCFG02("FIN000005","001","P")))
      If Upper(AllTrim(CUSERNAME)) $ _cUsuario

        cPara    := AllTrim(Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_EMAIL"))
        cCC      := AllTrim(U_MYCFG02("FAT000011","001","P"))
        cCCO     := AllTrim(U_MYCFG02("FIN000009","001","P"))
        
        cAssunt1 := "FINANCEIRO - Liberação de Cliente ("+SA1->A1_COD+ "/"+SA1->A1_lOJA+")"	
        
		aAdd(aCorpo, "<h2>Realizado o procedimento de analise de credito, segue a liberação do cadastro do cliente com as seguintes instruções</h2>")
		aAdd(aCorpo, "</p>")
		aAdd(aCorpo, "</p>")
		aAdd(aCorpo, "<h3>Dados do cliente</h3>")
		aAdd(aCorpo, "<b>Código/Loja: </b>"+AllTrim(M->A1_COD)+"/"+AllTrim(M->A1_LOJA))
		aAdd(aCorpo, "<b>Razão Social: </b>"+AllTrim(M->A1_NOME))
		aAdd(aCorpo, "</p>")
		aAdd(aCorpo, "<h3>Dados financeiro</h3>")
		aAdd(aCorpo, "<b>Risco: </b>"+M->A1_RISCO)
		aAdd(aCorpo, "<b>Vencimento: </b>"+DtoC(M->A1_VENCLC))
		aAdd(aCorpo, "<b>Limite: </b>"+Transform(M->A1_LC,"999,999,999.99"))
		aAdd(aCorpo, "<b>Observação: </b>"+Alltrim(M->A1_observ))
		aAdd(aCorpo, "</p>")
		aAdd(aRodape, "Obrigado(a)!")
		aAdd(aRodape, "Equipe Financeira")
		
		oHtml:= CorpoEmail():New(cTitulo, aCorpo, aRodape)
		oHtml:GeraHtml()	
		oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
		oEmail:EmailUsr()
		oEmail:Conectar()    
		If oEmail:Enviar(allTrim(cRemet), allTrim(cPara), allTrim(cCC), allTrim(cCCO), allTrim(cAssunt1), oHtml:cHtml, cAnexo)
			lRetorno	:=	.t.
			Aviso(FunDesc(),"E-mail enviado com SUCESSO.",{"OK"})
		EndIf
		oEmail:Desconec()    
	  EndIf
	EndIf	
	
RESTAREA(xAreaSA1)
RESTAREA(xArea)

Return .T.
