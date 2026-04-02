#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#include "fivewin.ch"
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

User Function MA030TOK()
       



If M->A1_EST<>'EX' .AND. EMPTY(M->A1_CGC)
	Alert("Campo Cnpj Obrigatorio!")
	Return .F.
EndIf


If MSGBOX("Envia email para liberação de Crédito","Liberacao de Crédito","YESNO")
	
	  
	
	cHTML 		:= ""

	cServer		:=	GetMv("MV_RELSERV")
	cAccount	:=	GetMv("MV_RELACNT")
	cPassword	:=	GetMv("MV_RELPSW")
	cAutentic	:=	GetMv("MV_RELAUTH")
	cPara		:= "nalves@myersind.com"
   	cEnvia		:= "microsiga@novel.com.br"
	
	_cUsuario	:= Getmv("MV_MYLIBCL")
	_cLogin		:= ""
	_cNome		:= ""
	_cEmail		:= ""
	

	_cNomeC	:= RetCodUsr()
	
	//Solicitante
	_lAchou	:= .F.
	aUsu	:= AllUsers(.T.)
	For I := 1 To Len(aUsu) 
		If upper(alltrim(aUsu[I,1,1]))==upper(alltrim(_cNomeC))
			_cLoginS 	:= aUsu[I,1,2] //Login do usuario
			_cNomeCS	:= aUsu[I,1,4] //Nome do usuario
			_cEmailS	:= Trim(aUsu[I,1,14]) //Email do usuario
			_lAchou		:= .T.
		EndIf
		If _lAchou
			Exit
		Endif
	Next
	
	_cNomeC	:= upper(_cLoginS) //Substr(cusername,7,15)
	
	
		
	//Aprovador
	_lAchou	:= .F.
	aUsu	:= AllUsers(.T.)
	For I := 1 To Len(aUsu)
		If upper(alltrim(aUsu[I,1,2]))==upper(alltrim(_cUsuario))
			_cLogin 	:= aUsu[I,1,2] //Login do usuario
			_cNome		:= aUsu[I,1,4] //Nome do usuario
			_cEmail		:= Trim(aUsu[I,1,14]) //Email do usuario
			_lAchou		:= .T.
		EndIf
		If _lAchou
			Exit
		Endif
	Next
	
	
	cHtml	+= '<html> '
	
	cHtml	+= '<head> '
	cHtml	+= '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"><meta name=Generator content="Microsoft Word 12 (filtered)"> '
	cHtml	+= '<style> '
	cHtml	+= '<!-- '
	cHtml	+= ' /* Font Definitions */ '
	cHtml	+= ' @font-face '
	cHtml	+= '	{font-family:"Cambria Math"; '
	cHtml	+= '	panose-1:2 4 5 3 5 4 6 3 2 4;} '
	cHtml	+= '@font-face '
	cHtml	+= '	{font-family:Calibri; '
	cHtml	+= '	panose-1:2 15 5 2 2 2 4 3 2 4;} '
	cHtml	+= '@font-face '
	cHtml	+= '	{font-family:Tahoma; '
	cHtml	+= '	panose-1:2 11 6 4 3 5 4 4 2 4;} '
	cHtml	+= ' /* Style Definitions */ '
	cHtml	+= ' p.MsoNormal, li.MsoNormal, div.MsoNormal '
	cHtml	+= '	{margin-top:0cm; '
	cHtml	+= '	margin-right:0cm; '
	cHtml	+= '	margin-bottom:10.0pt; '
	cHtml	+= '	margin-left:0cm; '
	cHtml	+= '	line-height:115%; '
	cHtml	+= '	font-size:11.0pt; '
	cHtml	+= '	font-family:"Calibri","sans-serif";} '
	cHtml	+= 'p.MsoAcetate, li.MsoAcetate, div.MsoAcetate '
	cHtml	+= '	{mso-style-link:"Texto de balão Char"; '
	cHtml	+= '	margin:0cm; '
	cHtml	+= '	margin-bottom:.0001pt; '
	cHtml	+= '	font-size:8.0pt; '
	cHtml	+= '	font-family:"Tahoma","sans-serif";} '
	cHtml	+= 'p.msopapdefault, li.msopapdefault, div.msopapdefault '
	cHtml	+= '	{mso-style-name:msopapdefault; '
	cHtml	+= '	margin-right:0cm; '
	cHtml	+= '	margin-bottom:10.0pt; '
	cHtml	+= '	margin-left:0cm; '
	cHtml	+= '	line-height:115%; '
	cHtml	+= '	font-size:12.0pt; '
	cHtml	+= '	font-family:"Times New Roman","serif";} '
	cHtml	+= 'p.msochpdefault, li.msochpdefault, div.msochpdefault '
	cHtml	+= '	{mso-style-name:msochpdefault; '
	cHtml	+= '	margin-right:0cm; '
	cHtml	+= '	margin-left:0cm; '
	cHtml	+= '	font-size:10.0pt; '
	cHtml	+= '	font-family:"Times New Roman","serif";} '
	cHtml	+= 'span.TextodebaloChar '
	cHtml	+= '	{mso-style-name:"Texto de balão Char"; '
	cHtml	+= '	mso-style-link:"Texto de balão"; '
	cHtml	+= '	font-family:"Tahoma","sans-serif";} '
	cHtml	+= '.MsoChpDefault '
	cHtml	+= '	{font-size:10.0pt;} '
	cHtml	+= '@page Section1 '
	cHtml	+= '	{size:595.3pt 841.9pt; '
	cHtml	+= '	margin:70.85pt 3.0cm 70.85pt 3.0cm;} '
	cHtml	+= 'div.Section1 '
	cHtml	+= '	{page:Section1;} '
	cHtml	+= '--> '
	cHtml	+= '</style> '
	
	cHtml	+= '</head> '
	
	cHtml	+= '<body lang=PT-BR> '
	
	cHtml	+= '<div class=Section1> '
	
	cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>Liberacao Cadastro Cliente</span></i></b></p> "
	
	cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>&nbsp;</span></i></b></p> "
	
	cHtml	+= "<p class=MsoNormal>Foi solicitado por <b><i><span style='font-size:12.0pt;line-height:115%'>"+M->A1_MYSOLIC+"</span></i></b> a liberação de Crédito do cliente <b><i><span "
	
	cHtml	+= "style='font-size:12.0pt;line-height:115%'>" + SA1->A1_COD + "/" + SA1->A1_LOJA + " " + SA1->A1_NOME + "</span></i></b><span "
	
   // cHtml	+= ' <p class=MsoNormal style="text-indent:35.4pt"><b><i><spanstyle="font-size:14.0pt;line-height:115%"><a href="http://'+GetMV("MV_ALSERV")+'\u_myfin02.apl?cliente='+SA1->A1_COD+'&loja='+SA1->A1_LOJA+'">Clique aqui para liberar</a></span></i></b></p> '

       	
	cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
	
	cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
	
	cHtml	+= '<p class=MsoNormal><b><i>Informações Complementares:</i></b></p> '
	
	cHtml	+= '<p class=MsoNormal>&nbsp;</p> '   
	
	cHtml	+= '<p class=MsoNormal>Planta: Lauro de Freitas - BA</p> '
	
   //	cHtml	+= '<p class=MsoNormal>Limite de crédito: ' + transform(M->A1_LC,"999,999,999.99") + '</p> '

	cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
	
	cHtml	+= '<p class=MsoNormal>Sem mais,</p> '
	
	cHtml	+= '<p class=MsoNormal><b><i>Controladoria</i></b></p> '
	
	cHtml	+= '</div> '
	
	cHtml	+= '</body> '
	
	cHtml	+= '</html> '
	
	
	
	//Manda e e-mail
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	//lResulConn := MailAuth(cAccount, cPassword)     
	
	If Getmv("MV_RELAUTH")
	  lResulConn := MailAuth(cAccount, cPassword)  
	Endif

	//email para o responsavel pela fase 1
	SEND MAIL FROM cAccount TO _cEmail SUBJECT 'Liberação de cadastro de Cliente' BODY cHtml //Attachment _cCaminho //RESULT lEnviado
	
	//RecLock("SA1",.F.)
	//SA1->A1_MSBLQL	:= "1"
	//MSUnLock()
	
EndIf

	
Return .t.