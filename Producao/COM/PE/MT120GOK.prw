#include "rwmake.ch"
#include "topconn.ch" 
#Include 'Protheus.ch'         
#INCLUDE "ap5mail.ch"
//.==============================================================.
//|                PLÁSTICOS NOVEL LTDA                          |
//|--------------------------------------------------------------|
//| Programa : MT120GOK.PRW     | Autor: Leaandro Ferreira       |
//|--------------------------------------------------------------|
//| Descricao: Ponto de Entrada no pedido de compras             |
//| Grava informacoes depois da gravacao do pedido de compra     |
//|--------------------------------------------------------------|
//| Data criacao  : 07/01/2020  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//| Uso especifico para Microsiga Advanced Protheus              |
//.==============================================================.
//	atualiza??es:
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante      Motivo
// 07/01/2020  Leandro Ferreira          Grasiela Guarizo Não envia email para o 1 aprovador
user function MT120GOK()
	Private	xAreaSC7	:= SC7->(GetArea())
	Private	xAreaSCR	:= SCR->(GetArea())
	Private	xAreaSA2	:= SA2->(GetArea())
	Private	xAreaSY1	:= SY1->(GetArea())
	Private	xAreaSAL	:= SAL->(GetArea())
	Private	xArea		:= GetArea()
	Private	cNumPed		:= PARAMIXB[1]
	Private 	aArea		:= GetArea()
	Private 	cTo 		:= ""
	Private 	cPedido		:= ""
	Private 	cEmissao 	:= ""
	Private 	cAprgrp 	:= ""
	Private 	cCompra 	:= ""
	Private 	cForn 		:= ""
	Private 	cLojaForn 	:= ""
	Private 	cObserv 	:= ""
	Private 	cDescForn 	:= ""
	Private		cSubject	:= "PENDÊNCIA DE PEDIDO DE COMPRA "+cNumPed
	Private		cTpped		:= ""
	PRIVATE 	cMailComp	:= UsrRetMail(SC7->C7_USER)
	Private  	_cNumSC 	:= SC7->C7_NUMSC
	Private 	cUSRSC		:= ""
	Private 	cAPRSC		:= ""

	DbSelectArea("SC7")   
	DbSetOrder(1)
	DbSeek(xFILIAL("SC7")+cNumPed)

	cEmissao  := DToC(SC7->C7_EMISSAO)   	//Data Emissao PC
	cAprgrp   := SC7->C7_APROV     			//Grupo Aprovacao PC
	cCompra   := SC7->C7_USER      			//Comprador
	cForn     := SC7->C7_FORNECE   			//Fornecedor
	cLojaForn := SC7->C7_LOJA      			//Loja
	cObserv	  := SC7->C7_OBS      			//Observacao

	if C7_TIPO == 1
		cTpped := "PC"
	Else
		cTpped := "AE"
	EndIf
	if SA2->(DbSeek(xFilial("SA2")+cForn+cLojaForn,.F.))
		cDescForn := SA2->A2_NOME
	else
		cDescForn := " "
	endif

	dbSelectArea("SCR")
	dbSetOrder(1)
	DbSeek(xFILIAL("SCR")+cTpped+cNumPed)
	cQuery	:=	"Select "
	cQuery	+=			"SCR.CR_NIVEL, SCR.CR_USER, SCR.CR_STATUS, SCR.CR_TOTAL,SCR.CR_EMISSAO "
	cQuery	+=	"From "+retSqlName("SCR")+" SCR "
	cQuery	+=	"Where "
	cQuery	+=			"SCR.CR_FILIAL  = '"+xFilial("SCR") +"' And "
	cQuery	+=			"SCR.CR_TIPO    = '" + cTpped + "' And "
	cQuery	+=			"SCR.CR_NUM     = '" + cNumPed + "' And "
	cQuery	+=			"SCR.CR_STATUS  = '02' 			    And "
	cQuery	+=			"SCR.CR_DATALIB = '" + DtoS(CtoD(""))	+"' And "
	cQuery	+=			"SCR.D_E_L_E_T_ = ' ' "
	cQuery	+=	"Order By "
	cQuery	+=			"SCR.CR_NIVEL, SCR.CR_USER "

	TcQuery cQuery New Alias TSCRA
	DbSelectArea("TSCRA")
	DbGoTop()

	nTotal		:= TSCRA->CR_TOTAL 

	While !EOF() 
		if cTo == ""
			cTo	 := UsrRetMail(TSCRA->CR_USER)
		else
			cTo	 := cTo + ";" + UsrRetMail(TSCRA->CR_USER)
		EndIf
		DbSkip()
	End

	cTo := cTo + ";" + cMailComp

	if cTpped == "PC" .and. !EMPTY(ALLTRIM(_cNumSC))
		cUSRSC := POSICIONE("SC1",1,xFilial("SC1")+_cNumSC,"C1_USER")
		cTo	 := cTo + ";" + UsrRetMail(cUSRSC)
		cAPRSC := POSICIONE("SC1",1,xFilial("SC1")+_cNumSC,"C1_ZZCAPRO")
		cTo	 := cTo + ";" + UsrRetMail(cAPRSC)
	ENDIF
	
	MsgHtml()
	DbSelectArea("TSCRA")
	DbClosearea()   
return .t.	

Static Function MsgHtml() 

	cMensagem := "<html> "
	cMensagem += "	<body> "
	cMensagem += "		<font face='verdana' size='2'> "
	cMensagem += "			Existe um novo pedido de compra liberado no sistema.<br><br> "  
	cMensagem += "			Observ. "+cObserv+"<br><br> "
	cMensagem += "			Segue abaixo dados para liberação:<br><br> "
	cMensagem += "			<table border='1'> "
	cMensagem += "				<tr> "
	cMensagem += "					<td height='30' colspan='4' align='center' bgcolor='3C79D5'><font face='verdana' size='3' color='FFFFFF'><b>PEDIDO A LIBERAR</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Número Pedido</font></td> "
	cMensagem += "					<td><font face='verdana' size='2'>&nbsp;<b>"+cNumPed+"</b></font></td> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Data Emissão</font></td> "
	cMensagem += "					<td><font face='verdana' size='2'>&nbsp;<b>"+cEmissao+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "			
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Comprador</font></td> "
	cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>"+alltrim(cCompra)+" - "+alltrim(UsrFullName(cCompra))+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Fornecedor</font></td> "
	cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>"+alltrim(cForn)+"/"+alltrim(cLojaForn)+" - "+alltrim(cDescForn)+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td height='5' colspan='4' bgcolor='3C79D5'></td> "
	cMensagem += "				</tr> "
	//cMensagem += "				<tr> "
	//cMensagem += "					<td width='110'><font face='verdana' size='2'>Valor Total</font></td> "
	//cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>R$ "+transf(nTotal,"@E 999,999,999.99")+"</b></font></td> "
	//cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td height='5' colspan='4' bgcolor='3C79D5'></td> "
	cMensagem += "				</tr> "
	//cMensagem += "				<tr> "
	//cMensagem += "					<td width='110'><font face='verdana' size='2'>Aprovador</font></td> "
	//cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>"+alltrim(cGrpsal)+" - "+alltrim(cNivelsal)+" - "+alltrim(cDescAprov)+"</b></font></td> "
	//cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Planta:</font></td> "
	cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>"+FWFilialName()+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td height='5' colspan='4' bgcolor='3C79D5'></td> "
	cMensagem += "				</tr> "
	cMensagem += "			</table> "
	cMensagem += "		</font> "
	cMensagem += "	</body> "
	cMensagem += "</html> "

	Enviar()

Return    

Static Function Enviar()

	Local cServidor	:= GetMv("MV_RELSERV")
	Local cConta	:= GetMv("MV_RELACNT")
	Local cPassWord	:= GetMv("MV_RELPSW")
	Local cAutentic	:= GetMv("MV_RELAUTH")
	Local lResulConn:= .T.
	Local cAttach 	:= ""
	Local lResulSend:= .T.
	Local cError 	:= ""
	Local lSend  	:= .T.
	Local lConn  	:= .T.
   
	U_fPNSendMail( /*cAccount*/, /*cPassword*/, /*cServer*/, /*cFrom*/, cTo + Chr( 59 ), cSubject, cMensagem )	
	
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

		//SEND MAIL FROM cConta TO cPara SUBJECT cAssunto BODY _cBody RESULT lResulSend  
		SEND MAIL FROM cConta TO cTo SUBJECT cSubject BODY cMensagem RESULT lResulSend

		If !lResulSend
			GET MAIL ERROR cError
			MsgAlert("Falha no Envio do e-mail: " + cError)
		Endif
	Endif

	DISCONNECT SMTP SERVER     

	*/
	
	RestArea(xAreaSC7)
	RestArea(xAreaSCR)
	RestArea(xAreaSA2)
	RestArea(xAreaSY1)
	RestArea(xAreaSAL)
	RestArea(xArea)

Return(.F.)
