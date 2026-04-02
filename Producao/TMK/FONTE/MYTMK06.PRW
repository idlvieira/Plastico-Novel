#include "rwmake.ch"
#include "TopConn.ch"
#include "Protheus.ch"
#include "TbiConn.ch" 
#INCLUDE "fivewin.ch"

/*                                                          
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Work     ºAutor  ³ Fernando Amorim    º Data ³  04/02/10   º±±
±±ºPrograma  ³ MYTMK06  ºRevisao³ Sonia Silva        º Data ³  22/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Workflow para envio de orcamentos bloqueado por desconto   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MYTMK06(cOrc,nApr) //User Function WORK(cOrc,nApr)

Local oHtml
Local cNum := "" // Cod do Pedido Atualmente analizado
Local nTotal	:= 0
Private nSource  := 0
Private aSource  := {}
Private nSource02  := 0
Private aSource02  := {}
Private nTarget  := 0
Private aTarget  := {}
Private nTarget02  := 0

SUA->(DbSetOrder(1)) 
If SUA->(DbSeek(xFilial("SUA")+cOrc))  

    // INICIA PROCESSO DE Workflow

	oProcess := TWFProcess():New(cNum,"Orcamento Bloqueado")
	oProcess:NewTask("OrcBloq","\WORKFLOW\HTML\Orcamento\OrcBloq.html")
	oProcess:cSubject := "Orcamento Bloqueado numero - " + SUA->UA_NUM 
	oProcess:bReturn  := "U_MYTMK07()" 	//oProcess:bReturn  := "U_RETORC()"
	oProcess:bTimeOut := {{"U_TIME()",mv_par02,0,0}}
	oHTML   := oProcess:oHTML

	oHtml:ValByName(U_MYCFG02("CFG000002","002","P"))
		//oHtml:ValByName("LOGO", "\\server2\p10_oficial\Protheus_Data\system\LGLR01.BMP" ) + Posicione ("ZZZ",1,xFilial("ZZZ")+"CFG000001"+"001",ZZZ_RETORN)+

	//Cabecalho
	oHtml:ValByName("cNum"		,Alltrim(SUA->UA_NUM))
	oHtml:ValByName("cCliente"	,Alltrim(SUA->UA_CLIENTE))
	oHtml:ValByName("cLoja"		,Alltrim(SUA->UA_LOJA))
	oHtml:ValByName("cDescCl"	,Alltrim(Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_NOME")))	
	oHtml:ValByName("cOperad"	,Alltrim(SUA->UA_OPERADO))
	oHtml:ValByName("cDescOp"	,Alltrim(Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_NOME")))  
	oHtml:ValByName("cVend" 	,Alltrim(SUA->UA_VEND))
	oHtml:ValByName("cDescVd"	,Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")))
	oHtml:ValByName("cCondPg"	,Alltrim(SUA->UA_CONDPG))	
	
   	SUB->(DbSetOrder(1)) 
	SUB->(DbSeek(xFilial("SUB")+cOrc)) 
	nTotal	:= 0
	While SUB->(!EOF() .and. UB_FILIAL + UB_NUM == xfilial("SUB") + cOrc )
					      
	   //	AAdd((oHtml:ValByName("TB.ITEM")),SUB->UB_ITEM)
		AAdd((oHtml:ValByName("TB.CODIGO")),SUB->UB_PRODUTO)		    
		AAdd((oHtml:ValByName("TB.DESCRICAO")),Alltrim(Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_DESC"))) 
		AAdd((oHtml:ValByName("TB.QUANT")),SUB->UB_QUANT)
		AAdd((oHtml:ValByName("TB.PRCUNI")),SUB->UB_VRUNIT)
		AAdd((oHtml:ValByName("TB.TOTITEM")),SUB->UB_VLRITEM)
		AAdd((oHtml:ValByName("TB.DESC")),SUB->UB_DESC)                                                 	
		AAdd((oHtml:ValByName("TB.VLDESC")),SUB->UB_VALDESC)
		
	    nTotal	+= SUB->UB_VLRITEM
		SUB->(DbSkip())
			
	End

	oHtml:ValByName("nTotal"		,nTotal) // valor total

 	oProcess:cTo	:= U_MYCFG02("TMK000005","001","P")//oProcess:cTo	:= alltrim(getmv("MV_MYEMPED")) 
    /*
	INICIO DA GRAVACAO DO WHHTTPRET.APL NO ARQUIVO GERADO DO WORKLOW		
	
	*/		
	//	Gravo os destinatarios definidos pelo programa original	e os troco para um endereco invalido
	cOldTo  := oProcess:cTo
	cOldCC  := oProcess:cCC
	cOldBCC := oProcess:cBCC
	
	//	Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
	oProcess:cTo  := NIL
	oProcess:cCC  := NIL
	oProcess:cBCC := NIL
	_cSubject     := 'WorkFlow de orçamento bloqueado por desconto '
	
	cMailId    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow				
	
	chtmlfile  := cmailid + ".htm"
	cmailto    := "mailto:" + U_MYCFG02("TMK000005","001","P") // cmailto    := "mailto:" + alltrim(getmv("MV_MYEMPED")) 
	chtmltexto := wfloadfile("\workflow\emp"+cEmpAnt+"\" +"temp\" + chtmlfile )
	chtmltexto := strtran( chtmltexto, cmailto, "WFHTTPRET.APL" )
	wfsavefile("\workflow\Callcenter\" +chtmlfile, chtmltexto)  // grava novamente com as alteracoes necessarias.				
	
	Enviar()
  			
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ENVIAR() º Autor   ³EDUARDO CSEH VASQUES º Data ³25.02.08  º±±
±±ºPrograma  ³ ENVIAR() º Revisao ³Sonia Silva          º Data ³23.11.16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Funcao responsavel por enviar o email.                      º±±
±±º          ³Da Aprovacao do desconto do orcamento de vendas             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
***********************
Static Function Enviar()
***********************
Local cServidor	:=	GetMv("MV_RELSERV")
Local cConta	:=	GetMv("MV_RELACNT")
Local cPassWord	:=	GetMv("MV_RELPSW")
Local cAutentic	:=	GetMv("MV_RELAUTH")
Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local lSend  := .T.
Local lConn  := .T.  
Local cAttach := ""  
Local cCorpo  := "" 
//Local cPara   := GetMv("MV_ANACRED")
Local cAssunto := " Aprovacao de Desconto do Orçamento: " + SUA->UA_NUM 		

cPara		:= ""
_cEmailS	:= ""

//Solicitante
_lAchou	:= .F.
aUsu	:= AllUsers(.T.)
For I := 1 To Len(aUsu) 
	If upper(alltrim(aUsu[I,1,2]))==upper(alltrim(SUA->UA_ZZAPROV))
		_cLoginS	:= aUsu[I,1,1] //Login do usuario
		_cNomeCS	:= aUsu[I,1,4] //Nome do usuario
		_cEmailS	:= Trim(aUsu[I,1,14]) //Email do usuario
		_lAchou		:= .T.
	EndIf
	If _lAchou
		Exit
	Endif
Next

cPara	:= _cEmailS

cCorpo:= '<html>' 
cCorpo+= '<head>' 
cCorpo+= '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' 
cCorpo+= '<title>Aprovação de Desconto para o Orçamento</title>' 
cCorpo+= '</head>' 

cCorpo+= '<body>'
cCorpo+= '<table width="90%" height="570" border="0" align="center" cellpadding="0" cellspacing="0">'
cCorpo+= '  <tr valign="top" bgcolor="#FFFFFF">'
cCorpo+= '    <td height="19" colspan="2" bgcolor="#FFFFFF"><div align="right">'
cCorpo+= '      <table width="100%" border="0" cellspacing="0" cellpadding="0">' 
cCorpo+= '        <tr>    '
cCorpo+= '          <td width="37%" bgcolor="#990000"><font color="#000066" size="2" face="Verdana, Arial, Helvetica, sans-serif"> <strong><font color="#FFFFFF">MYERS - JAGUARIUNA / Or&ccedil;amento: </font> </strong> </font> <font color="#FFFFFF"> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> <strong>Nr. '+SUA->UA_NUM+' </strong> </font> </font> <font color="#FFFFFF"> <font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif"> <strong></strong> </font> </font></td>'
cCorpo+= '          <td width="63%" bgcolor="#990000"><div align="right"> <font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif"> <strong>Emiss&atilde;o:  '+ALLTRIM(str(day(ddatabase)))+"/"+ALLTRIM(str(month(ddatabase)))+"/"+ALLTRIM(str(year(ddatabase)))+' &nbsp;&nbsp;</strong> </font> </div></td>'
cCorpo+= '        </tr>'
cCorpo+= '      </table> '
cCorpo+= '      <table width="100%" border="0" cellspacing="0" cellpadding="0"> '
cCorpo+= '        <tr>  '
cCorpo+= '          <td bgcolor="#990000" ><strong> <font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif"> <br />    '
cCorpo+= '            <br />'
cCorpo+= '            O operador solicitou a aprova&ccedil;&atilde;o de desconto para esse Or&ccedil;amento.</font></strong></td>'
cCorpo+= '        </tr>'
cCorpo+= '      </table>'
cCorpo+= '      <font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif"> <strong></strong> </font> </div></td>'
cCorpo+= '  </tr>' 

cCorpo += "<DIV class=s0>"
cCorpo += "&nbsp;</DIV>"
cCorpo += "<DIV class=s0>"     

IF !SUA->UA_PROSPEC
	cCorpo += "Cliente: "+SA1->A1_NOME+"&nbsp;</DIV>"
	cCorpo += "<DIV class=s0>"
	cCorpo += "CNPJ/CPF: "+TRANSFORM(SA1->A1_CGC,IIF(SA1->A1_PESSOA =="F","@R 999.999.999-99","@R 99.999.999/9999-99"))+"&nbsp;</DIV>"
	cCorpo += "<DIV class=s0>"
	cCorpo += "Limite de crédito: " + TRANSFORM(SA1->A1_LC,"999,999,999.99")
	cCorpo += "<DIV class=s0>"
	cCorpo += "Vencimento Limite de Credito: "+dtoc(SA1->A1_VENCLC)
	cCorpo += "<DIV class=s0>"
	cCorpo += "Risco: "+SA1->A1_RISCO+"&nbsp;</DIV>"
	cCorpo += "<DIV class=s0>"
ELSE
	cCorpo += "Prospect: "+POSICIONE("SUS",1,XFILIAL("SUS")+SUA->UA_CLIENTE,"US_NOME")+"&nbsp;</DIV>"
	cCorpo += "<DIV class=s0>"
ENDIF 

cCorpo += "Risco: "+SA1->A1_RISCO+"&nbsp;</DIV>"
cCorpo += "<DIV class=s0>"
cCorpo += "Segue abaixo informações sobre o Orcamento:"
cCorpo += "<DIV class=s0>"
cCorpo += "&nbsp;</DIV>"

cCorpo += "<DIV class=s0>"
cCorpo += "Numero do Orcamento................: "+(SUA->UA_NUM)
cCorpo += "<DIV class=s0>"
cCorpo += "Condiçoes de Pagamento.......: "+POSICIONE("SE4",1,XFILIAL("SE4")+SUA->UA_CONDPG,"E4_DESCRI")
cCorpo += "<DIV class=s0>"
cCorpo += "Tipo de Frete........................: "+IIF(SUA->UA_TPFRETE == "C","CIF","FOB")
cCorpo += "<DIV class=s0>"
cCorpo += "Valor do Orcamento......:" + TRANSFORM(SUA->UA_VLRLIQ,"@E 999,999,999.99")
cCorpo += "&nbsp;</DIV>"    

cCorpo += "Tabela de Preco......:" +(SUA->UA_TABELA)
cCorpo += "&nbsp;</DIV>"

cCorpo += "<DIV class=s0>"
cCorpo += "&nbsp;</DIV>"

cCorpo += "<DIV class=s0>"
cCorpo += "<TABLE WIDTH='93%' BORDER='1' CELLPADDING='2' CELLSPACING='2' bgcolor='#FFFFFF' >"
cCorpo += "<TR> "
cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Item</DIV></TD>"
cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Produto</DIV></TD>"
cCorpo += "<TD WIDTH=30% VALIGN=TOP ><DIV class=s1>Descricao</DIV></TD>"
cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Quantidade</DIV></TD>"
cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Unitario</DIV></TD>"
cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>Total Item</DIV></TD>"
cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>% Desconto</DIV></TD>"
cCorpo += "<TD WIDTH=20% VALIGN=TOP ><DIV class=s1>Valor Desconto</DIV></TD>"
cCorpo += "<TD WIDTH=20% VALIGN=TOP ><DIV class=s1>Margem</DIV></TD>"  
cCorpo += "<TD WIDTH=20% VALIGN=TOP ><DIV class=s1>Tabela</DIV></TD>"

cCorpo += "</TR>"

dbSelectArea("SUB")
dbSetORder(1)
dbSeek(xFilial()+SUA->UA_NUM)
Do While !Eof() .And. SUB->UB_NUM = SUA->UA_NUM
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+SUB->UB_PRODUTO)
	
	cCorpo += "<TR>"
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + SUB->UB_ITEM +"</DIV></TD>"
	cCorpo += "<DIV class=s0>"
	cCorpo += "&nbsp;</DIV>"
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + SUB->UB_PRODUTO +"</DIV></TD>"
	cCorpo += "<DIV class=s0>"
	cCorpo += "&nbsp;</DIV>"
	cCorpo += "<TD WIDTH=30% VALIGN=TOP ><DIV class=s1>" + POSICIONE("SB1",1,XFILIAL("SB1")+SUB->UB_PRODUTO,"B1_DESC") +"</DIV></TD>"
	cCorpo += "<DIV class=s0>"
	cCorpo += "&nbsp;</DIV>"
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TRANSFORM(SUB->UB_QUANT,"@E 999,999,999.99") +"</DIV></TD>"
	cCorpo += "<DIV class=s0>"
	cCorpo += "&nbsp;</DIV>"
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TRANSFORM(SUB->UB_VRUNIT,"@E 999,999,999.99") +"</DIV></TD>"
	cCorpo += "<DIV class=s0>"
	cCorpo += "&nbsp;</DIV>"
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TRANSFORM(SUB->UB_VLRITEM,"@E 999,999,999.99") +"</DIV></TD>"
	cCorpo += "<DIV class=s0>"
	cCorpo += "&nbsp;</DIV>"
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TRANSFORM(SUB->UB_DESC,"@E 99.99") +"</DIV></TD>"
	cCorpo += "&nbsp;</DIV>"
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TRANSFORM(SUB->UB_VALDESC,"@E 999,999,999.99") +"</DIV></TD>"
	cCorpo += "&nbsp;</DIV>"
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TRANSFORM(SUB->UB_ZZMARGE,"@E 999,999,999.99") +"</DIV></TD>"
	cCorpo += "&nbsp;</DIV>" 
	cCorpo += "<TD WIDTH=10% VALIGN=TOP ><DIV class=s1>" + TRANSFORM(SUB->UB_PRCTAB,"@E 999,999,999.99") +"</DIV></TD>"
	cCorpo += "&nbsp;</DIV>"
	
	cCorpo += "</TR>"
	
	dbSelectArea("SUB")
	dbSkip()
	
Enddo
cCorpo += "</DIV></TABLE>"

cCorpo += "<DIV class=s0>"
cCorpo += "&nbsp;</DIV>"

cCorpo += "<DIV class=s0>"

cCorpo+= '  <tr valign="top">'
cCorpo+= '    <td height="471" colspan="2" bgcolor="#FFFFFF"><br />'
cCorpo+= '      &nbsp;'
cCorpo+= '      <p><a href="http://' + Posicione("ZZZ", 1, xFilial("ZZZ") + "CFG000002" + "001", "ZZZ_RETORN") + '\u_mysp04.apl?empresa=' + substr(cnumEmp, 1, 4) + '&orcamento=' + SUA->UA_NUM + '" >clique aqui para Aprovação!</a></p>'
//cCorpo+= '      <p><a href="http://'+GetMV("MV_ALSERV")+'\u_mysp04.apl?empresa='+substr(cnumEmp,1,4)+'&orcamento='+SUA->UA_NUM+'" >clique aqui para Aprovação!</a></p>'
cCorpo+= '      <p><br />'   
cCorpo+= '      &nbsp;' 
cCorpo+= '      <p><a href="http://' + Posicione("ZZZ", 1, xFilial("ZZZ") + "CFG000002" + "001", "ZZZ_RETORN") + '\u_mysp06.apl?empresa=' + substr(cnumEmp, 1, 4) + '&orcamento=' + SUA->UA_NUM + '" >Ou Clique aqui para Reprovar!</a></p>'
//cCorpo+= '      <p><a href="http://'+GetMV("MV_ALSERV")+'\u_mysp06.apl?empresa='+substr(cnumEmp,1,4)+'&orcamento='+SUA->UA_NUM+'" >Ou Clique aqui para Reprovar!</a></p>'
cCorpo+= '      <p><br />'
cCorpo+= '        <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> <strong>'+Alltrim(Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_NOME"))+'</strong><br />'
cCorpo+= '          Depto de Vendas</font></p></td>'
cCorpo+= '  </tr>
cCorpo+= '</table>
cCorpo+= '</body>
cCorpo+= '</html>

cPara := allTrim(cPara) + ";" + Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000005"+"002","ZZZ_RETORN")

U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cPara + Chr( 59 ), cAssunto, cCorpo, cAttach, /*_lMsg*/, /*_cLog*/ )

/*
nCont := 0
While lConn .And. nCont < 10
	
	CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cPassWord RESULT lResulConn
	
	nCont++
	If lResulConn
		lConn := .F.
	Endif
	
End

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

If !lResulConn
	GET MAIL ERROR cError
	MsgAlert("Falha na conexão "+cError)
	Return(.F.)
Else

	nCont := 0
	
	While lSend == .T. .And. nCont < 100
		
		cPara := allTrim(cPara) + ";" + Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000005"+"002","ZZZ_RETORN")
		//cPara := allTrim(cPara) + ";" + allTrim(getMv("MV_WFMAILT"))
	
		SEND MAIL FROM cConta TO cPara SUBJECT cAssunto BODY cCorpo  ATTACHMENT  cAttach RESULT lResulSend
		
		//ATTACHMENT cAttach
		nCont++
		
		If lResulSend
			lSend := .F.
		EndIf
	End

	If !lResulSend
  		GET MAIL ERROR cError
  		MsgAlert("Falha no Envio do e-mail " + cError)
	Endif
Endif
DISCONNECT SMTP SERVER
*/

Return(.F.)