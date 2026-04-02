#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110BLO()º Autor ³Eduardo Cseh Vasquesº Data ³  24.01.2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada para detalhar Motivo do Bloqueio           º±±
±±º          ³solicitacao de compras. Envia e-mail Solicitante/Comprador. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Compras                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT110BLO()

Local aArea	   := GetArea()    &&Salva Area
Local nNumSC   := SC1->C1_NUM      // Numero da Solicitação de compras
Local nItemSC  := SC1->C1_ITEM
Local cObserv  := SPACE(200)
Local aButtons := {}
Local nOpca    := PARAMIXB[1]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear


// Validações do Usuario

IF (nOpca == 2) .or. (nOpca == 3)
	
	DEFINE MSDIALOG oDlg TITLE "Descrição do Motivo da Rejeição/Bloqueio" FROM 000,000 TO 200,359 OF oMainWnd PIXEL
	
	@ 015, 003 TO 100, 180 OF oDlg PIXEL
	@ C(012),C(003) Get cObserv MEMO             Size C(139),C(067) PIXEL OF oDlg
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcao:=1,oDlg:End()},{|| (nOpcao:=2,oDlg:End())},,aButtons) CENTERED
	
	/* Faz o Bloqueio de todas as SC */
	
	dbSelectArea("SC1")
	dbSetOrder(1)
	IF mv_par02 == 1  && por item
		DbSeek(xFILIAL("SC1")+nNumSc+nItemSC)
		If !EOF()
			RecLock("SC1",.f.)
			SC1->C1_M_MOTBL := cObserv
			MsUnlock()
			DbSkip()
		Endif
	Else   && Por SC
		DbSeek(xFILIAL("SC1")+nNumSc)
		While !EOF() .and. SC1->C1_NUM == nNumSc
			RecLock("SC1",.f.)
			SC1->C1_M_MOTBL := cObserv
			MsUnlock()
			DbSkip()
		End
		
	Endif
	dbCloseArea("SC1")
	
	PrepEma(nNumSc,1)
	
Endif

IF (nOpca == 1)   && Opcao de APROVACAO
	
	dbSelectArea("SC1")
	dbSetOrder(1)
	IF mv_par02 == 1  && por item
		DbSeek(xFILIAL("SC1")+nNumSc+nItemSC)
		If !EOF()
			RecLock("SC1",.f.)
			SC1->C1_M_MOTBL := "Item Aprovado"
			MsUnlock()
			DbSkip()
		Endif
	Else   && Por SC
		DbSeek(xFILIAL("SC1")+nNumSc)
		While !EOF() .and. SC1->C1_NUM == nNumSc
			RecLock("SC1",.f.)
			SC1->C1_M_MOTBL := "Aprovada"
			MsUnlock()
			DbSkip()
		End
		
	Endif
	dbCloseArea("SC1")
	
	PrepEma(nNumSc,2)
	
Endif

RestArea(aArea)

Return '

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrepEma   º Autor ³					 º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Apos a gravacao da SC, envia e-mail solicitando aprovacao.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Compras                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

************************
Static Function PrepEma(_cNumSc, cTipo)
************************

Local _cEmissao	:= ""
Local _cNomSol	:= ""
Local _aInfo	:= {}
Local _cAprov	:= ""
Private _cMotivo  := SPACE(200)
Private _cEmail  := ""
Private _cBody	:= ""
Private cDe 	:= ""
Private cPara	:= ""
Private cAssunto:= ""   
Private _cEmailCP  := ""
Private _cNomSolCP := "" 

dbSelectArea("SC1")
dbSetOrder(1) //Filial + Num + Item

If SC1->(dbSeek(xFilial("SC1")+_cNumSC))
	
	_cEmissao := Dtoc(SC1->C1_EMISSAO)
	_cMotivo := SC1->C1_M_MOTBL
	PswOrder(1)
	If PswSeek(SC1->C1_USER,.T.) //Pego as informacoes do usuarios (Protheus)
		_aInfo   := PswRet(1)
		_cEmail  := Alltrim(_aInfo[1,14]) //E-mail do Solicitante
		_cNomSol := Alltrim(_aInfo[1,04]) //Nome do Solicitante
	EndIf

    //Busca E-mail do Comprador no SC1->C1_CODCOMP
    DbSelectarea("SY1")
    DbSetOrder(1)
	IF	DbSeek(xFILIAL("SY1")+SC1->C1_CODCOMP)
		_cEmailCP  := Alltrim(SY1->Y1_EMAIL) //E-mail do Comprador
		_cNomSolCP := Alltrim(SY1->Y1_NOME) //Nome do Comprador
	EndIf
	DbCloseArea("SY1")
	
EndIf

If (cTipo == 1) && E-mail de bloqueio ou Rejeicao
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
	_cBody	+= "          de Compras Rejeitada/Bloqueada</strong></font></p>"
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
	_cBody	+= "  <tr> "
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Verifique a sua Solicitação "
	_cBody	+= "      <font color='#663300'>"+_cNomSol+", pois foi Rejeitada ou Bloqueada."+"</font> </font></strong></td>"
	_cBody	+= "  </tr>"
	_cBody	+= "  <tr> "
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Motivo: "
	_cBody	+= "      <font color='#663300'>"+_cMotivo+"."+"</font> </font></strong></td>"
	_cBody	+= "  </tr>"
	_cBody	+= "</table>"
	_cBody	+= "<p>&nbsp;</p>"
	_cBody	+= "</body>"
	_cBody	+= "</html>"
	
	cDe		:= "protheus@myersind.com"
	cPara	:= Alltrim(_cEmail)
	cAssunto:= "Resposta: Solicitação de Compras para Aprovação"
Endif
If (cTipo == 2)   && E-mail de Aprovacao - Vai pro Solicitante e Comprador
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
	_cBody	+= "        <p><font size='5' face='Georgia, Times New Roman, Times, serif'><strong>Sr. Comprador a"
	_cBody	+= "          solicitacao foi APROVADA.</strong></font></p>"
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
	cAssunto:= "Resposta: Solicitação de Compras para Aprovação"
	
Endif

//Chamada da funcao que envia o email

Enviar(cTipo)

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Enviar(nTipoEnv)

Local cServidor	:=	GetMv("MV_RELSERV")
Local cConta	:=	GetMv("MV_RELACNT")
Local cPassWord	:=	GetMv("MV_RELPSW")
Local cAutentic	:=	GetMv("MV_RELAUTH")
Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local lSend  := .T.
Local lConn  := .T.
Local _cAssCP := "Solicitação Aprovada pelo Gerente de Area"

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
    
    If (nTipoEnv==2) && So enviar - Aprovacao para Comprador
	  SEND MAIL FROM cConta TO _cEmailCP SUBJECT _cAssCP BODY _cBody RESULT lResulSend   
	Endif
	
	If !lResulSend
		GET MAIL ERROR cError
		MsgAlert("Falha no Envio do e-mail " + cError)
	Endif
Endif

DISCONNECT SMTP SERVER

Return
