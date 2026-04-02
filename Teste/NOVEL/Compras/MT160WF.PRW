#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch" 
#INCLUDE "TOPCONN.CH"    


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160WF() º Autor ³Eduardo Cseh Vasquesº Data ³  24.01.2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada para envio de E-mail para Nivel Aprovacao  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Compras                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT160WF()     

Public aArea	    := GetArea()    &&Salva Area    
Public aAliasSC8	:=	SC8->(GetArea())
Public aAliasSAK	:=	SAK->(GetArea())
Public cServidor	:=	GetMv("MV_RELSERV")
Public cConta	:=	GetMv("MV_RELACNT")
Public cPassWord	:=	GetMv("MV_RELPSW")
Public cAutentic	:=	GetMv("MV_RELAUTH")
Public lResulConn := .T.
Public lResulSend := .T.
Public cError := ""
Public lSend  := .T.
Public lConn  := .T.
Public cNumCot:= Paramixb[1]  &&SC8->C8_NUM  Numero da Cotacao Selecionada
Public nValTot := 0
Private _cEmail  := ""
Private _cBody	:= ""     
Private _cUser  := ""
Private cDe 	:= ""
Private cPara	:= ""
Private cAssunto:= ""
Public cNumPed := "" 
Public cNumCot:= Paramixb[1]  &&SC8->C8_NUM  Numero da Cotacao Selecionada  

//Busca o Numero do Pedido Gerado
dbSelectArea("SC8")
dbSetOrder(1) //Filial + Num  
DbSeek(xFILIAL("SC8")+cNumCot)
While !EOF() .and. SC8->C8_FILIAL = XFILIAL("SC8") .AND. SC8->C8_NUM = cNumCot
	If SC8->C8_NUMPED <> "XXXXXX"
		cNumPed := SC8->C8_NUMPED && Nro do Pedido Gerado
		nValTot := nValtot + SC8->C8_TOTAL
	Endif
	dbSkip()
End    

IF nValTot > 300001.00
   apmaster()
endif   


cQry := " SELECT SC8.C8_NUMPED, SC8.C8_ITEM, SC8.C8_PRODUTO, SC8.C8_QUANT, SC8.C8_PRECO, SC8.C8_TOTAL"
cQry := cQry + " FROM SC8010 AS SC8
cQry := cQry + " WHERE SC8.C8_NUMPED = '"+cNumPed+"'"
cQry := cQry + " AND SC8.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SC8.C8_PRODUTO, SC8.C8_ITEM ASC"

Tcquery cQry new alias "PEDID"

   
//Busca os Aprovadores Cadastrados
dbSelectArea("SAK")
DbgoTop()
While !EOF()
	If ((nValTot >= SAK->AK_LIMMIN) .and. (nVAlTot <= SAK->AK_LIMMAX))
		_cUser := SAK->AK_USER
		PswOrder(1)
		If PswSeek(_cUser,.T.) //Pego as informacoes do usuarios (Protheus)
			_aInfo   := PswRet(1)
			_cEmail  := _cEmail + "," + Alltrim(_aInfo[1,14]) //E-mail do Aprovador
		EndIf
	Endif
	DbSkip()
End
    
If (_cEmail = "")
	AVISO('Atencao','Não foi possível Publicizar e-mail do aprovador, favor verificar',{'OK'}) 
	RestArea(aAliasSAK)
	RestArea(aAliasSC8)
	RestArea(aArea)
	Return
Endif

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
_cBody	+= "        <p><font size='5' face='Georgia, Times New Roman, Times, serif'><strong>Pedido "
_cBody	+= "          de Compras para APROVAR.</strong></font></p>"
_cBody	+= "        </div></td>"
_cBody	+= "    <td width='16%'><img src='file:///\\PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
//_cBody	+= "    <td width='16%'><img src='file:///\\server2\p10_oficial/PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
_cBody	+= "  </tr>"
_cBody	+= "</table>"
_cBody	+= "<table width='100%' border='3'>"
_cBody	+= "  <tr>"
_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Cota&ccedil;&atilde;o "
_cBody	+= "      n&ordm;: <font color='#663300'>"+cNumCot+"</font></font></strong></td>"
_cBody	+= "  </tr>"
_cBody	+= "  <tr>"
_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Pedido de Compra : "
_cBody	+= "              <font color='#663300'>"+cNumPed+"</font></font></strong></td>"
_cBody	+= "  </tr>"

DBSelectArea("PEDID")
While !eof()
     XCOD := PEDID->C8_PRODUTO
     DbSelectArea("SB1")
     DbSetOrder(1)
     DbSeek(xFilial()+xCOD)
     XDESC := SB1->B1_DESC
     DBSelectArea("PEDID")
	_cBody	+= "  <tr>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Produto : "
	_cBody	+= "    <font color='#663300'>"+PEDID->C8_PRODUTO + '-' + PEDID->C8_ITEM + '-' + XDESC + ' QTD: ' + alltrim(STR(PEDID->C8_QUANT,10,2)) + ' VLR UNIT R$ ' + alltrim(STR(PEDID->C8_PRECO,14,2))+ ' TOTAL R$ ' + alltrim(STR(PEDID->C8_TOTAL,14,2)) + "</font></font></strong></td>"
    _cBody	+= "  </tr>"
	DBSkip()
EndDo         
DBclosearea()

_cBody	+= "</table>"
_cBody	+= "<p>&nbsp;</p>"
_cBody	+= "</body>"
_cBody	+= "</html>"

cDe		:= "microsiga@novel.com.br"
cPara	:= Alltrim(_cEmail)
cAssunto:= "Pedido de Compra para Aprovação"


CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cPassWord RESULT lResulConn

If !lResulConn
	GET MAIL ERROR cError
	MsgAlert("Falha na conexão "+cError)
	Return
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
		MsgAlert("Falha no Envio do e-mail " + cError)
	Endif
Endif

DISCONNECT SMTP SERVER

RestArea(aAliasSAK)
RestArea(aAliasSC8)
RestArea(aArea)

Return
               
static Function apmaster

cQry := " SELECT SC8.C8_NUMPED, SC8.C8_ITEM, SC8.C8_PRODUTO, SC8.C8_QUANT, SC8.C8_PRECO, SC8.C8_TOTAL"
cQry := cQry + " FROM SC8010 AS SC8
cQry := cQry + " WHERE SC8.C8_NUMPED = '"+cNumPed+"'"
cQry := cQry + " AND SC8.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SC8.C8_PRODUTO, SC8.C8_ITEM ASC"

Tcquery cQry new alias "PEDID"

   
//Busca os Aprovadores Cadastrados (MASTER)

//_cEmail  := "luizoliveira@novel.com.br" + "," + "jpanosso@myersind.com" //E-mail do Aprovador  

_cmail := "jpanosso@myersind.com"


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
_cBody	+= "        <p><font size='5' face='Georgia, Times New Roman, Times, serif'><strong>Pedido "
_cBody	+= "          de Compras para APROVAR.</strong></font></p>"
_cBody	+= "        </div></td>"
_cBody	+= "    <td width='16%'><img src='file:///\\PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
//_cBody	+= "    <td width='16%'><img src='file:///\\server2\p10_oficial/PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
_cBody	+= "  </tr>"
_cBody	+= "</table>"
_cBody	+= "<table width='100%' border='3'>"
_cBody	+= "  <tr>"
_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Cota&ccedil;&atilde;o "
_cBody	+= "      n&ordm;: <font color='#663300'>"+cNumCot+"</font></font></strong></td>"
_cBody	+= "  </tr>"
_cBody	+= "  <tr>"
_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Pedido de Compra : "
_cBody	+= "              <font color='#663300'>"+cNumPed+"</font></font></strong></td>"
_cBody	+= "  </tr>"

DBSelectArea("PEDID")
While !eof()
     XCOD := PEDID->C8_PRODUTO
     DbSelectArea("SB1")
     DbSetOrder(1)
     DbSeek(xFilial()+xCOD)
     XDESC := SB1->B1_DESC
     DBSelectArea("PEDID")
	_cBody	+= "  <tr>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Produto : "
	_cBody	+= "    <font color='#663300'>"+PEDID->C8_PRODUTO + '-' + PEDID->C8_ITEM + '-' + XDESC + ' QTD: ' + alltrim(STR(PEDID->C8_QUANT,10,2)) + ' VLR UNIT R$ ' + alltrim(STR(PEDID->C8_PRECO,14,2))+ ' TOTAL R$ ' + alltrim(STR(PEDID->C8_TOTAL,14,2)) + "</font></font></strong></td>"
    _cBody	+= "  </tr>"
	DBSkip()
EndDo         
DBclosearea()

_cBody	+= "</table>"
_cBody	+= "<p>&nbsp;</p>"
_cBody	+= "</body>"
_cBody	+= "</html>"

cDe		:= "microsiga@novel.com.br"
cPara	:= Alltrim(_cEmail)
cAssunto:= "Pedido de Compra para Aprovação"


CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cPassWord RESULT lResulConn

If !lResulConn
	GET MAIL ERROR cError
	MsgAlert("Falha na conexão "+cError)
	Return
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
		MsgAlert("Falha no Envio do e-mail " + cError)
	Endif
Endif

DISCONNECT SMTP SERVER

RestArea(aAliasSAK)
RestArea(aAliasSC8)
RestArea(aArea)

Return



