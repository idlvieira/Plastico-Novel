#include "rwmake.ch"
#include "topconn.ch" 
#Include 'Protheus.ch'         
#INCLUDE "ap5mail.ch"

User Function MT097END()   

xArea		:= GetArea()
xAreaSC7	:= SC7->(GetArea())
xAreaSCR	:= SCR->(GetArea())
xAreaSA2	:= SA2->(GetArea())
xAreaSY1	:= SY1->(GetArea())
xAreaSAL	:= SAL->(GetArea())
cFilName 	:= FWFilialName()    
cSubject 	:= ""   
cTo      	:= ""  
cAlias   	:= Alias()
cQuery     	:= ""  
cQuery1         := ""  
cUsrlog  	:= RetCodUsr()//Funcao que retorna o Cod do Usuario
cPedido	 	:= ""
cEmissao 	:= ""
cAprgrp  	:= ""
cCompra		:= ""
cDescForn	:= ""
cDescComp	:= ""
cLiberado	:= ""
cForn		:= ""
cLojaForn	:= ""
nTotal		:= 0
cCliente	:= ""
cLojaCli	:= ""
cDescCli	:= ""
cDescAprov	:= ""
cProxNivel	:= ""
cNivelscr	:= "" 
cStatus		:= ""
cAprsrc 	:= ""
cNivelsal	:= ""
cMensagem 	:= "" 
cGrpsal     := ""
	
  	if Paramixb[3] == 2
		cPedido := Alltrim(Paramixb[1])
		cSubject += "Liberado PEDIDO DE COMPRA "+cPedido
		                   
		DbSelectArea("SC7")   
	    	DbSetOrder(1)
   		(DbSeek(xFilial("SC7")+Trim(cPedido),.F.))
   			
		cEmissao  := (DTOS(SC7->C7_EMISSAO))   	//Data Emissao PC
		cAprgrp   := SC7->C7_APROV     			//Grupo Aprovacao PC
		cCompra   := SC7->C7_USER      			//Comprador
		cForn     := SC7->C7_FORNECE   			//Fornecedor
		cLojaForn := SC7->C7_LOJA      			//Loja
		
       		if SA2->(DbSeek(xFilial("SA2")+cForn+cLojaForn,.F.))
				cDescForn := SA2->A2_NOME
			else
				cDescForn := " "
			endif
			
			DbSelectArea("SY1")
			SY1->(DbSetOrder(3))
				
			if SY1->(DbSeek(xFilial("SY1")+cCompra,.F.))
				cDescComp := SY1->Y1_NOME
			else
				cDescComp := " "
			endif   
			
			cQuery	:=	"Select "
			cQuery	+=			"SCR.CR_NIVEL, SCR.CR_USER, SCR.CR_STATUS, SCR.CR_TOTAL "
			cQuery	+=	"From "+retSqlName("SCR")+" SCR "
			cQuery	+=	"Where "
			cQuery	+=			"SCR.CR_FILIAL  = '"+xFilial("SCR") +"' And "
			cQuery	+=			"SCR.CR_TIPO    = 'PC' And "
			cQuery	+=			"SCR.CR_NUM     = '"+cPedido +"' And "
			cQuery	+=			"SCR.CR_STATUS  = '02' 			    And "
			cQuery	+=			"SCR.CR_DATALIB = '"+DtoS(CtoD(""))	+"' And "
			cQuery	+=			"SCR.D_E_L_E_T_ = ' ' "
			cQuery	+=	"Order By "
			cQuery	+=			"SCR.CR_NIVEL, SCR.CR_USER "
			
			TcQuery cQuery New Alias TSCRA
		
			DbSelectArea("TSCRA")
			DbGoTop()
			cProxNivel	:= TSCRA->CR_NIVEL
			cStatus		:= TSCRA->CR_STATUS
			cAprscr	    := TSCRA->CR_USER
			nTotal		:= TSCRA->CR_TOTAL 
		
			cQuery1	:=	"Select "
			cQuery1	+=			"SAL.AL_COD, SAL.AL_DESC, SAL.AL_NIVEL, SAL.AL_USER, SAL.AL_NOME, SAL.AL_MYEMAIL "
			cQuery1	+=	"From "+retSqlName("SAL")+" SAL "
			cQuery1	+=	"Where "
			cQuery1	+=			"SAL.AL_FILIAL  = '"+xFilial("SAL") +"' And "  
			cQuery1	+=			"SAL.AL_COD     = '"+cAprgrp +"' And "
			cQuery1	+=			"SAL.AL_NIVEL   = '"+cProxNivel +"' And "
			cQuery1	+=			"SAL.AL_USER    = '"+cAprscr +"' And "
			cQuery1	+=			"SAL.D_E_L_E_T_ = ' ' "
			cQuery1	+=	"Order By "
			cQuery1	+=			"SAL.AL_COD, SAL.AL_NIVEL, SAL.AL_USER "
			
			TcQuery cQuery1 New Alias TSALA
		
			DbSelectArea("TSALA")
			DbGoTop()  
			cGrpsal 	:= TSALA->AL_COD
			cNivelsal	:= TSALA->AL_NIVEL
			cDescAprov	:= TSALA->AL_NOME
			cTo			:= TSALA->AL_MYEMAIL
		 
			MsgHtml()
	        
			DbSelectArea("TSCRA")
			DbClosearea()    
			DbSelectArea("TSALA")
			DBClosearea()		  			 	
	endif   
	
Static Function MsgHtml() 

	cMensagem := "<html> "
	cMensagem += "	<body> "
	cMensagem += "		<font face='verdana' size='2'> "
	cMensagem += "			Existe um novo pedido de compra liberado no sistema.<br><br> "
	cMensagem += "			Segue abaixo dados para liberação:<br><br> "
	cMensagem += "			<table border='1'> "
	cMensagem += "				<tr> "
	cMensagem += "					<td height='30' colspan='4' align='center' bgcolor='3C79D5'><font face='verdana' size='3' color='FFFFFF'><b>PEDIDO A LIBERAR</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Número Pedido</font></td> "
	cMensagem += "					<td><font face='verdana' size='2'>&nbsp;<b>"+cPedido+"</b></font></td> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Data Emissão</font></td> "
	cMensagem += "					<td><font face='verdana' size='2'>&nbsp;<b>"+cEmissao+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "			
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Comprador</font></td> "
	cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>"+alltrim(cCompra)+" - "+alltrim(cDescComp)+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Fornecedor</font></td> "
	cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>"+alltrim(cForn)+"/"+alltrim(cLojaForn)+" - "+alltrim(cDescForn)+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td height='5' colspan='4' bgcolor='3C79D5'></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Valor Total</font></td> "
	cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>R$ "+transf(nTotal,"@E 999,999,999.99")+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td height='5' colspan='4' bgcolor='3C79D5'></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Aprovador</font></td> "
	cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>"+alltrim(cGrpsal)+" - "+alltrim(cNivelsal)+" - "+alltrim(cDescAprov)+"</b></font></td> "
	cMensagem += "				</tr> "
	cMensagem += "				<tr> "
	cMensagem += "					<td width='110'><font face='verdana' size='2'>Planta:</font></td> "
	cMensagem += "					<td colspan='3'><font face='verdana' size='2'>&nbsp;<b>"+cFilName+"</b></font></td> "
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
	
	//SEND MAIL FROM cConta TO cPara SUBJECT cAssunto BODY _cBody RESULT lResulSend  
	SEND MAIL FROM cConta TO cTo SUBJECT cSubject BODY cMensagem RESULT lResulSend
	
	If !lResulSend
		GET MAIL ERROR cError
		MsgAlert("Falha no Envio do e-mail: " + cError)
	Endif
Endif

DISCONNECT SMTP SERVER     

RestArea(xAreaSC7)
RestArea(xAreaSCR)
RestArea(xAreaSA2)
RestArea(xAreaSY1)
RestArea(xAreaSAL)
RestArea(xArea)

Return(.F.)