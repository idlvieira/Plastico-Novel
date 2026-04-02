#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³MTA110OK  ºAutor  ³Claudio Iabuki      º Data ³  13/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Bloqueia a SC de Compra e Envia e-mail.     				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 10 Ms-Sql Server                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
&& MATA110 - solicitacoes de compra
User Function M110STTS()

Local aArea	   := GetArea()    &&Salva Area
local lRet     := .T.
local cNumSc   := Paramixb[1]  &&SC1->C1_NUM

/* Faz o Bloqueio de todas as SC */

dbSelectArea("SC1")
dbSetOrder(1)
DbSeek(xFILIAL("SC1")+cNumSc)
While !EOF() .and. SC1->C1_NUM == cNumSc
	RecLock("SC1",.f.)
	SC1->C1_APROV := "B"
	MsUnlock()
	DbSkip()
Enddo
dbCloseArea("SC1")

&&  Enviar e-mail
PrepEmail(cNumSc)

RestArea(aArea)

Return lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrepEmail º Autor ³					 º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Apos a gravacao da SC, envia e-mail solicitando aprovacao.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Compras                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

************************
Static Function PrepEmail(_cNumSc)
************************

Local _cEmissao	:= ""
Local _cNomSol	:= ""
Local _aInfo	:= {}
Local _cAprov	:= ""    
Local _cNomAprov:= ""
Private _cEmail  := ""
Private _cBody	:= ""
Private cDe 	:= ""
Private cPara	:= ""
Private cAssunto:= ""

dbSelectArea("SC1")
dbSetOrder(1) //Filial + Num + Item

If SC1->(dbSeek(xFilial("SC1")+_cNumSC))
	
	_cEmissao := Dtoc(SC1->C1_EMISSAO) 
	_cProduto := SC1->C1_PRODUTO
	PswOrder(1)
	If PswSeek(SC1->C1_USER,.T.) //Pego as informacoes do Solicitante no cadastro de usuarios (Protheus)
		_aInfo   := PswRet(1)
		_cNomSol := Alltrim(_aInfo[1,04]) //Nome Solicitante
	EndIf
	

    _lAchou	:= .F.
	If !Empty(SC1->C1_CC) 
		_cAprov	:= Posicione("CTT",1,xFilial("CTT")+SC1->C1_CC,"CTT_MBLOGI")
		
		
		// BUSCA O LOGIN DO USUARIO /////////////
		aUsu	:= AllUsers(.T.)
		For I := 1 To Len(aUsu)
			If alltrim(aUsu[I,1,2])==alltrim(_cAprov)
	  			_cEmail		:= aUsu[I,1,14] //Login do usuario
				_cNomAprov	:= aUsu[I,1,4] //Nome do usuario
	  			_lAchou		:= .T.
				exit
			EndIf
		Next
    

	dbSelectArea("SAI")
	dbSetOrder(2) //Filial + User	
	ElseIf SAI->(dbSeek(xFilial("SAI")+SC1->C1_USER)) .and. !_lAchou
		PswOrder(1)
		If PswSeek(SAI->AI_M_APROV,.T.) //Pego as informacoes do Aprovador no cadastro de usuarios (Protheus)
//			_aInfo     := PswRet(1)
//			_cNomAprov := Alltrim(_aInfo[1,04]) //Nome do Aprovador   
//			_cEmail    := Alltrim(_aInfo[1,14]) //E-mail do Aprovador
  			_cAprov    := SAI->AI_M_APROV
		EndIf	
	EndIf
	
EndIf

_cBody	:= "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
_cBody	+= "<html>"
_cBody	+= "<head>"
_cBody	+= "<title>Documento sem t&iacute;tulo</title>"
_cBody	+= "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
_cBody	+= "</head>"

_cBody	+= "<body>"
_cBody	+= "<table width='100%' border='3'>"
_cBody	+= "  <tr>"
_cBody	+= "    <td width='84%'><div align='center'>"
_cBody	+= "        <p><font size='5' face='Georgia, Times New Roman, Times, serif'><strong>Solicita&ccedil;&atilde;o "
_cBody	+= "          de Compras inclu&iacute;da</strong></font></p>"
_cBody	+= "        </div></td>"
_cBody	+= "    <td width='16%'><img src='file:///\\server2\p10_oficial/PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
_cBody	+= "  </tr>"
_cBody	+= "</table>"
_cBody	+= "<table width='100%' border='3'>"
_cBody	+= "  <tr>"
_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Solicita&ccedil;&atilde;o "
_cBody	+= "      n&ordm;: <font color='#663300'>"+_cNumSC+"</font></font></strong></td>"
_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data "
_cBody	+= "      emiss&atilde;o: <font color='#663300'>"+_cEmissao+"</font></font></strong></td>"
_cBody	+= "  </tr>"
_cBody	+= "  <tr> "
_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Solicitante: "
_cBody	+= "      <font color='#663300'>"+_cNomSol+"</font> </font></strong></td>"
_cBody	+= "  </tr>"
_cBody	+= "</table>"
_cBody	+= "<p>&nbsp;</p>"
_cBody	+= "</body>"
_cBody	+= "</html>"

cDe		:= "protheus@myersind.com"
cPara	:= Alltrim(_cEmail)
cAssunto:= "Solicitação de Compras para Aprovação"

//Chamada da funcao que envia o email
Enviar()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ENVIAR() º Autor ³                     º Data ³  25.02.08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Funcao responsavel por enviar o email.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±.±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Enviar()

Local cServidor	:=	GetMv("MV_RELSERV")
Local cConta	:=	GetMv("MV_RELACNT")
Local cPassWord	:=	GetMv("MV_RELPSW")
Local cAutentic	:=	GetMv("MV_RELAUTH")
Local lResulConn := .T.
Local cAttach := ""
Local lResulSend := .T.
Local cError := ""
Local lSend  := .T.
Local lConn  := .T.

CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cPassWord RESULT lResulConn

If !lResulConn
	GET MAIL ERROR cError
	MsgAlert("Falha na conexão "+cError)
	Return(.F.)
Else
	
	if lResulConn .and. GetMv("MV_RELAUTH")
		//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
		lResulConn := MailAuth(cConta, cPassWord)
		//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
		if !lResulConn
			nAt 	:= At("@",cPassWord)
			cUser 	:= If(nAt>0,Subs(cConta,1,nAt-1),cConta)
			lResulConn := MailAuth(cUser, cPassWord)
		endif
	endif
	
	SEND MAIL FROM cConta TO cPara SUBJECT cAssunto BODY _cBody RESULT lResulSend
	
	If !lResulSend
		GET MAIL ERROR cError
		MsgAlert("Falha no Envio do e-mail: " + cError)
	Endif
ENDIF

DISCONNECT SMTP SERVER

Return(.F.)




