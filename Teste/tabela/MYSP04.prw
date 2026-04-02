#include "rwmake.ch"
#include "Ap5Mail.ch"
#include "topconn.ch"
#include "msGraphi.ch"
#include "colors.ch"
#include "folder.ch"     
#include "fileio.ch"
#include "fivewin.ch" 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MYSP04   บ Autor ณKleverson Melo   บ Data ณ  04/09/14      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Liberacao de Desconto do orcamento de Vendas.              บฑฑ
ฑฑบ          ณ MYCM04.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CallCenter                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function MYSP04(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)



cHTML 				:= ""
_cEmpresa			:= __aProcParms[1,2]
_cOrcamento			:= __aProcParms[2,2]


RPCSetType( 3 )
RpcSetEnv ( Substr(_cEmpresa,1,2) , Substr(_cEmpresa,3,2) , "", "","","", {"SUA","SX6","SXE","SXF"} )



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
cHtml	+= '	{mso-style-link:"Texto de balใo Char"; '
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
cHtml	+= '	{mso-style-name:"Texto de balใo Char"; '
cHtml	+= '	mso-style-link:"Texto de balใo"; '
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

cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>&nbsp;</span></i></b></p> "

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '    
   


DBSelectArea("SUA")
DBSetOrder(1)
If DBSeek(xFilial("SUA")+_cOrcamento,.F.)    
   RecLock("SUA",.F.)
   SUA->UA_STATU2 := "LIB"
   SUA->UA_MYUSLI2	:= SUA->UA_MYAPROV
   SUA->UA_MYDTDES	:= ddatabase    
   MsUnLock()  
   U_MAILDESC()
   cHtml	+= '<p class=MsoNormal><b><i>O Orcamento '+SUA->UA_NUM+' foi Aprovado com sucesso!!!</i></b></p> '
else   
   cHtml	+= '<p class=MsoNormal><b><i>Orcamento nao encontrado!!!</i></b></p> '
endif          


cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>Sem mais,</p> '

cHtml	+= '<p class=MsoNormal><b><i>Grupo de Adm. de Vendas</i></b></p> '

cHtml	+= '</div> '

cHtml	+= '</body> '

cHtml	+= '</html> '


Return(cHtml)
             


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAILDESC   บAutor  ณKleverson Melo     บ Data ณ  04/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvio de e-mail para informar a Liberacao do orcamento.	  บฑฑ
ฑฑบ          ณpara o operador                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCallcenter						                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAILDESC()

	Local oHtml
	Local oEmail
	Local cServidor	:=	GetMv("MV_RELSERV")
	Local cConta	:=	GetMv("MV_RELACNT")
	Local cPassWord	:=	GetMv("MV_RELPSW")
	Local cAutentic	:=	GetMv("MV_RELAUTH")
	Local cAnexo    := '' 	
	Local cTitulo 	:= ""
	Local aCorpo  	:= {}
	Local aRodape 	:= {} 
	Local cAssunto  := " Or็amento de numero "+SUA->UA_NUM+" estแ liberado para incluir o pedido" 
	Local cPara 	:= Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_MAIL") //"fernando.amorim@qsdobrasil.com"
	Local cCC		:= ""
	Local cCCo		:= ""  
	Local cRemet 	:= GetMv("MV_RELACNT")

	
	aAdd(aCorpo, 'O Or็amento abaixo:')
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Numero '+SUA->UA_NUM )
	aAdd(aCorpo, '')
	aAdd(aCorpo, 'Foi liberado pela anแlise de desconto. ')
	aAdd(aRodape, '')
	aAdd(aRodape, 'Obrigado!')
			
	oHtml:= CorpoEmail():New(cTitulo, aCorpo, aRodape)	
	oHtml:GeraHtml()	
	&&Enviando E-mail		
	oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
	oEmail:EmailUsr()
	oEmail:Conectar()  
	If oEmail:Enviar(AllTrim(cRemet), AllTrim(cPara), AllTrim(cCC), AllTrim(cCCO), AllTrim(cAssunto), oHtml:cHtml, cAnexo)
		lRetorno	:=	.t.
	EndIf    
	oEmail:Desconec()    
	
Return()      


