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
local _cMyEmpFil:= SM0->M0_CODIGO + "/" + allTrim(SM0->M0_FILIAL)
Private _cEmail  := ""
Private _cBody	:= ""
Private cDe 	:= ""
Private cPara	:= ""
Private cAssunto:= ""


_cNum	:= Paramixb[1]

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
	
		_cAprov	:= Posicione('SAI',2,xFilial('SAI')+SC1->C1_USER,'AI_ZZAPROV') 
		//Posicione("CTT",1,xFilial("CTT")+SC1->C1_CC,"CTT_MBLOGI")
	
	/*	
		dbSelectArea("SAI")
		dbSetOrder(2) //Filial + User	
		If SAI->(dbSeek(xFilial("SAI")+SC1->C1_USER))
			PswOrder(1)
			If PswSeek(SAI->AI_ZZAPROV,.T.) //Pego as informacoes do Aprovador no cadastro de usuarios (Protheus)
			_cAprov    := SAI->AI_ZZAPROV
			EndIf	
		EndIf
		dbCloseArea("SAI")
				
	*/	
		// BUSCA O LOGIN DO USUARIO /////////////
		
		PswOrder(1)
		If PswSeek( _cAprov, .t. )   
			aUsu		:= PswRet()
		    _cEmail		:= aUsu[1][14]  //Login do usuario
			_cNomAprov	:= aUsu[1][4]  //Nome do usuario
  			_lAchou		:= .T.
		EndIf
		
	/*
		aUsu	:= AllUsers(.T.)
		For I := 1 To Len(aUsu)
			If alltrim(aUsu[I,1,1])==alltrim(_cAprov)
	  			_cEmail		:= aUsu[1][14]  //Login do usuario
				_cNomAprov	:= aUsu[I,1,4] //Nome do usuario
	  			_lAchou		:= .T.
				exit
			EndIf
		Next
    */

	dbSelectArea("SAI")
	dbSetOrder(2) //Filial + User	
	ElseIf SAI->(dbSeek(xFilial("SAI")+SC1->C1_USER)) .and. !_lAchou
		PswOrder(1)
		If PswSeek(SAI->AI_ZZAPROV,.T.) //Pego as informacoes do Aprovador no cadastro de usuarios (Protheus)
//			_aInfo     := PswRet(1)
//			_cNomAprov := Alltrim(_aInfo[1,04]) //Nome do Aprovador   
//			_cEmail    := Alltrim(_aInfo[1,14]) //E-mail do Aprovador
  			_cAprov    := SAI->AI_ZZAPROV
		EndIf	
	EndIf
	
EndIf


_cBody := ""
_cBody := "<HTML><HEAD>"
_cBody += "<TITLE>Solicitacao de Compra</TITLE>"
_cBody += "</HEAD>"
_cBody += "<BODY bgproperties='fixed' TEXT=#000000 LINK=#0000FF VLINK=#FF0000 >" 


_cBody += "<BASE TARGET='_top'>"
_cBody += "Segue abaixo informações sobre a Solicitacao Compra"
_cBody += "<DIV class=s0>"
_cBody += "&nbsp;</DIV>"


_cBody += "<DIV class=s0>"
_cBody += "Empresa..............................: "+(_cMyEmpFil)
_cBody += "<DIV class=s0>"
_cBody += "Numero da Solicitacao................: "+(SC1->C1_NUM)
_cBody += "<DIV class=s0>"
_cBody += "Data de Emissao......................: "+dtoc(SC1->C1_EMISSAO)
_cBody += "<DIV class=s0>"
_cBody += "Solicitante..........................: "+SC1->C1_SOLICIT
_cBody += "&nbsp;&nbsp;</DIV>"

_cBody += "<DIV class=s0>"
_cBody += "<TABLE WIDTH='100%' BORDER='0' CELLPADDING='2' CELLSPACING='2' >"
_cBody += "<TR> "
_cBody += "<TD WIDTH=05% VALIGN=TOP ><DIV class=s1>Item</DIV></TD>"
_cBody += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Produto</DIV></TD>"
_cBody += "<TD WIDTH=40% VALIGN=TOP ><DIV class=s1>Descricao</DIV></TD>"
_cBody += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Quantidade</DIV></TD>"
_cBody += "<TD WIDTH=05% VALIGN=TOP ><DIV class=s1>C.Custo</DIV></TD>"
_cBody += "<TD WIDTH=05% VALIGN=TOP ><DIV class=s1>Capex</DIV></TD>"
_cBody += "<TD WIDTH=25% VALIGN=TOP ><DIV class=s1>Obs</DIV></TD>"
_cBody += "</TR>"



dbSelectArea("SC1")
dbSetORder(1)
dbSeek(xFilial()+_cNum)
Do While !Eof() .And. SC1->C1_NUM = _cNum
	_cBody += "<TR>"
	_cBody += "<TD WIDTH=05% VALIGN=TOP ><DIV class=s1>" + SC1->C1_ITEM +"</DIV></TD>"
	_cBody += "<DIV class=s0>"
	_cBody += "&nbsp;</DIV>"
	_cBody += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + SC1->C1_PRODUTO +"</DIV></TD>"
	_cBody += "<DIV class=s0>"
	_cBody += "&nbsp;</DIV>"
	_cBody += "<TD WIDTH=40% VALIGN=TOP ><DIV class=s1>" + POSICIONE("SB1",1,XFILIAL("SB1")+SC1->C1_PRODUTO,"B1_DESC") +"</DIV></TD>"
	_cBody += "<DIV class=s0>"
	_cBody += "&nbsp;</DIV>"
	_cBody += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TRANSFORM(SC1->C1_QUANT,"@E 999,999,999.99") +"</DIV></TD>"
	_cBody += "<DIV class=s0>"
	_cBody += "&nbsp;</DIV>"
	_cBody += "<TD WIDTH=05% VALIGN=TOP ><DIV class=s1>" + SC1->C1_CC +"</DIV></TD>"
	_cBody += "<DIV class=s0>"
	_cBody += "&nbsp;</DIV>"
	_cBody += "<TD WIDTH=05% VALIGN=TOP ><DIV class=s1>" + SC1->C1_ZZCAPEX +"</DIV></TD>"
	_cBody += "<DIV class=s0>"
	_cBody += "&nbsp;</DIV>"
	_cBody += "<TD WIDTH=25% VALIGN=TOP ><DIV class=s1>" + SC1->C1_OBS +"</DIV></TD>"
	_cBody += "&nbsp;</DIV>"
	dbSkip()
	
Enddo                                                                            
_cBody += "</TABLE></DIV>"

/*
_cEmp_Par:= Substr(_cNum,2,3)+"Az76"+Substr(_cNum,1,1)+"a98"+Substr(_cNum,5,2)



_cBody+= "      &nbsp;"
_cBody+= '      <p><a href="http://'+TRIM(U_MYCFG02("CFG000002","001","P"))+'\u_mycom01.apl?empresa='+substr(cnumEmp,1,4)+'&numero='+Trim(_cEmp_Par)+'&acao=A ">Clique aqui para Aprovar!</a></p>'
_cBody+= "      <p><br />"
_cBody+= "      &nbsp;" 
_cBody+= '      <p><a href="http://'+TRIM(U_MYCFG02("CFG000002","001","P"))+'\u_mycom01.apl?empresa='+substr(cnumEmp,1,4)+'&numero='+Trim(_cEmp_Par)+'&acao=R ">ou Clique aqui para Reprovar!</a></p>'


_cBody += "</BODY></HTML>"

*/

cDe		:= GetMV("MV_RELFROM")
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

U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cPara + Chr( 59 ), cAssunto, _cBody, /*Attatch*/, /*lResultSend*/, /*_cLog*/ )

/*                                                                                                                                                            

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
*/

Return(.F.)
