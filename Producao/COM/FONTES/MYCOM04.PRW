#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYCOM04  º Autor ³Newton Reca Alves   º Data ³  07/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia email para o responsavel da fase atual para o        º±±
±±º          ³ cadastro de produto                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MYCOM04(_cFase,_cUsuario)

  Local I			:= 00
  Local cHTML 		:= ""
  Local _cEmail		:= ""
  Local _cNomeCS	:= ""
  Local _cLoginS	:= ""
  Local _cEmailS	:= ""
  Local _cUsuAtual	:= _cUsuario
  Local _cLogin		:= ""
  Local _cNomeC		:= ""

If _cFase=="1"
	_cUsuario	:= TRIM(U_MYCFG02("COM000003","001","P"))
ElseIf _cFase=="2"
	_cUsuario	:= TRIM(U_MYCFG02("COM000003","002","P"))
ElseIf _cFase=="3"
	_cUsuario	:= TRIM(U_MYCFG02("COM000003","003","P"))
ElseIf _cFase=="F"
	_cUsuario	:= TRIM(U_MYCFG02("COM000003","011","P"))	//M->B1_MYSOLIC
EndIf



//ALERT(_cFase)
//ALERT(_cUsuario)


//Solicitante
_lAchou	:= .F.
aUsu	:= AllUsers(.T.)
For I := 1 To Len(aUsu) 
	If upper(alltrim(aUsu[I,1,2]))==upper(alltrim(M->B1_ZZSOLIC))
		_cLoginS	:= aUsu[I,1,1] //Login do usuario
		_cNomeCS	:= aUsu[I,1,4] //Nome do usuario
		_cEmailS	:= Trim(aUsu[I,1,14]) //Email do usuario
		_lAchou		:= .T.
	EndIf
	If _lAchou
		Exit
	Endif
Next



_lAchou	:= .F.
aUsu	:= AllUsers(.T.)
For I := 1 To Len(aUsu) 
	If upper(alltrim(aUsu[I,1,2]))==upper(alltrim(_cUsuario))
		_cLogin := aUsu[I,1,1] //Login do usuario
		_cNomeC	:= aUsu[I,1,4] //Nome do usuario
		_cEmail	:= Trim(aUsu[I,1,14]) //Email do usuario
		_lAchou	:= .T.
	EndIf
	If _lAchou
		Exit
	Endif
Next



cServer		:=	GetMv("MV_RELSERV")
cAccount	:=	GetMv("MV_RELACNT")
cPassword	:=	GetMv("MV_RELPSW")
cAutentic	:=	GetMv("MV_RELAUTH")
cPara		:= _cEmail
cEnvia		:= "myersistema@myersdobrasil.com.br"


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

cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>Solicitação de produto.</span></i></b></p> "

cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>&nbsp;</span></i></b></p> "

If M->B1_ZZVOLTA<>"1" .AND. _cFase=="F"
	cHtml	+= '<p class=MsoNormal>Fase do processo: <b> CONCLUIDO </b></p> '
ElseIf M->B1_ZZVOLTA=="1"
	cHtml	+= '<p class=MsoNormal>Fase do processo:  <b> REJEICAO DE MATERIAL  -  Responsavel: '+_cUsuario+' - '+_cNomeC+ '</b></p> '
Else
	cHtml	+= '<p class=MsoNormal>Fase do processo:  <b>'+_cFase+'  -  Responsavel: '+_cUsuario+' - '+_cNomeC+ '</b></p> '
Endif

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= "<p class=MsoNormal>Foi solicitado por <b><i><span style='font-size:12.0pt;line-height:115%'>"+_cNomeCS+"</span></i></b> o cadastramento do produto <b><i><span "


cHtml	+= "style='font-size:12.0pt;line-height:115%'>"+M->B1_COD + " " +M->B1_DESC+"</span></i></b><span "                                       
cHtml	+= "style='font-size:12.0pt;line-height:115%'> </span>com a unidade de medida: <b><i><span "
cHtml	+= "style='font-size:12.0pt;line-height:115%'>"+M->B1_UM+"</span></i></b> na empresa <b><i><span "
cHtml	+= "style='font-size:12.0pt;line-height:115%'>Myers Industries</span></i></b></p> "

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal><b><i>Informações Complementares:</i></b></p> '

If M->B1_ZZVOLTA<>"1" .and. _cFase>"1"

	/*
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Código: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_COD+"</span></i></b></p> "
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Desc.Ingles: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_ZZDESCI+"</span></i></b></p> "
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Grupo: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_GRUPO+"</span></i></b></p> "
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>UM: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_UM+"</span></i></b></p> "
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Tipo: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_TIPO+"</span></i></b></p> "
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Solicitante: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_MYSOLIC+"</span></i></b></p> "
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Local Padrao: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_LOCPAD+"</span></i></b></p> "
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Origem: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_ORIGEM+"</span></i></b></p> "
//	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Origem: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+_cArquivo+"</span></i></b></p> "
	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>obs: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_MYOBS+"</span></i></b></p> "
	
	If M->B1_MYVOLTA<>"1" .and. _cFase>"2"
		cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Controla Endereço: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_LOCALIZ+"</span></i></b></p> "
		cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Custeio OP: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_AGREGCU+"</span></i></b></p> "

		If M->B1_MYVOLTA<>"1" .and. _cFase>"3"
			cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Custo em Partes: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_ZZCPART+"</span></i></b></p> "
			
			If M->B1_MYVOLTA<>"1" .and. _cFase>"4"
				cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>C.Custo: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_CCCUSTO+"</span></i></b></p> "

				If M->B1_MYVOLTA<>"1" .and. _cFase>="5"
					cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>NCM: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_POSIPI+"</span></i></b></p> "
					
					If M->B1_MYVOLTA<>"1" .and. _cFase=="F"
						cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Status: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>PRODUTO LIBERADO PARA USO</span></i></b></p> "
					EndIf
					
				EndIf

			EndIf

		EndIf
		
	EndIf
	*/
	If M->B1_ZZVOLTA<>"1" .and. _cFase=="F"
		cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Status: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>PRODUTO CADASTRADO, NECESSITA DE APROVACAO FINAL!</span></i></b></p> "
	EndIf

	If M->B1_ZZVOLTA<>"1" .and. _cFase=="L"
		cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Status: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>PRODUTO CADASTRADO, PRONTO PARA USO!</span></i></b></p> "
	EndIf

ElseIf M->B1_ZZVOLTA=="1" 

	cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Rejeição: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+M->B1_ZZMOTRJ+"</span></i></b></p> "

EndIf

//cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Controla Estoque: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+_cEstoque+"</span></i></b></p> "

//cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Produto Importado: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+_cImportado+"</span></i></b></p> "

//cHtml	+= "<p class=MsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Obs: <b><i><span style='font-size:14.0pt;line-height:115%'>"+_cDetalhes+"</span></i></b></p> "

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>Sem mais,</p> '

cHtml	+= '<p class=MsoNormal><b><i>Grupo de Materiais</i></b></p> '

cHtml	+= '</div> '

cHtml	+= '</body> '

cHtml	+= '</html> '



//alert(cPara)

_cArquivo	:= ""	//RTRIM(ZZJ->ZZJ_ANEXO)
_cCaminho	:= ""	//SYSTEM\A_FICHAS\"+_cArquivo

//Manda e e-mail

//CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
//If Getmv("MV_RELAUTH")
//	lResulConn := MailAuth(cAccount, cPassword)
//EndIf

//SEND MAIL FROM cAccount TO cPara SUBJECT 'Solicitacao de Produto - FASE '+_cFase BODY cHtml Attachment _cCaminho //RESULT lEnviado
U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cPara + Chr( 59 ), "Solicitacao de Produto - FASE " + _cFase, cHtml, _cCaminho, /*lEnviado*/, /*_cLog*/ )

//Manda Copia para Newton
//cPara		:= "ti@myersdobrasil.com.br"
//SEND MAIL FROM cAccount TO cPara SUBJECT 'Solicitacao de Produto - FASE '+_cFase BODY cHtml Attachment _cCaminho //RESULT lEnviado

//Manda email na fase final para o Solicitante
If M->B1_ZZVOLTA=="1"
	cPara	:= _cEmailS
//	SEND MAIL FROM cAccount TO cPara SUBJECT 'Solicitacao de Produto - FASE '+_cFase BODY cHtml Attachment _cCaminho //RESULT lEnviado
	U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cPara + Chr( 59 ), "Solicitacao de Produto - FASE " + _cFase, cHtml, _cCaminho, /*lEnviado*/, /*_cLog*/ )
Endif

//Manda email na fase 1 para o Solicitante tambem
If _cFase=="L"
	cPara	:= _cEmailS
//	SEND MAIL FROM cAccount TO cPara SUBJECT 'Solicitacao de Produto - FASE '+_cFase BODY cHtml Attachment _cCaminho //RESULT lEnviado
	U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cPara + Chr( 59 ), "Solicitacao de Produto - FASE " + _cFase, cHtml, _cCaminho, /*lEnviado*/, /*_cLog*/ )
Endif

//DISCONNECT SMTP SERVER Result lDisConectou

Return(cHtml)
