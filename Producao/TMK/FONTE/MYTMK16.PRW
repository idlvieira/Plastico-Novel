#INCLUDE "msobject.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบClasse    ณMYTMK16   บAutor  ณWinston D. de Castroบ Data ณ  26/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodos de uso da Myers                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบProjeto   ณ       - Myers  -                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 8.11 Db2                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
&& Dios libre al Usuario/Analista de cambiar una sola linea de este fichero!
*/
Class MYTMK16

	Data cArq
	Data cEOL
	Method New() Constructor
	Method ImpCabec()
	Method ImpTit()
	Method ImpDet()
	Method ImpT1()
	Method ImpT2()
	Method ImpTG()
EndClass

&& Metodo construtor
Method New() Class MYTMK16
	::cArq := ""
	::cEOL := CHR(13)+CHR(10)
Return

&& Monta o cabecalho da Palnilha
Method ImpCabec() Class MYTMK16

	&& Cabecalho da Planilha
	::cArq += '<html xmlns:o="urn:schemas-microsoft-com:office:office"'  + ::cEOL
	::cArq += 'xmlns:x="urn:schemas-microsoft-com:office:excel"'  + ::cEOL
	::cArq += 'xmlns="http://www.w3.org/TR/REC-html40">'  + ::cEOL
	::cArq += '<head>'  + ::cEOL
	::cArq += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252">'  + ::cEOL
	::cArq += '<meta name=ProgId content=Excel.Sheet>'  + ::cEOL
	::cArq += '<meta name=Generator content="Microsoft Excel 11">'  + ::cEOL
	::cArq += '<link rel=File-List href="Myers001_arquivos/filelist.xml">'  + ::cEOL
	::cArq += '<style id="Myers001_29801_Styles">'  + ::cEOL
	
	&& Inicio dos Estilos
	::cArq += '<head>'  + ::cEOL
	::cArq += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252">'  + ::cEOL
	::cArq += '<meta name=ProgId content=Excel.Sheet>'  + ::cEOL
	::cArq += '<meta name=Generator content="Microsoft Excel 11">'  + ::cEOL
	::cArq += '<link rel=File-List href="Myers001_arquivos/filelist.xml">'  + ::cEOL
	::cArq += '<style id="Myers001_29801_Styles">'  + ::cEOL
	::cArq += '<!--table'  + ::cEOL
	::cArq += '	{mso-displayed-decimal-separator:"\,";'  + ::cEOL
	::cArq += '	mso-displayed-thousand-separator:"\.";}'  + ::cEOL
	::cArq += '.xl1529801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl2229801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl2329801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl2429801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl2529801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:none;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl2629801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:"Short Date";'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:none;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl2729801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:none;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl2829801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:"\@";'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:none;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl2929801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:"\#\,\#\#0\.00_\)\;\\\(\#\,\#\#0\.00\\\)";'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:none;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl3029801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:none;'  + ::cEOL
	::cArq += '	border-right:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl3129801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl3229801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:"Short Date";'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl3329801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl3429801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:"\@";'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL	
	::cArq += '.xl3529801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:"\#\,\#\#0\.00_\)\;\\\(\#\,\#\#0\.00\\\)";'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:none;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:none;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL	
	::cArq += '.xl3629801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl3729801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:none;'  + ::cEOL
	::cArq += '	border-left:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl3829801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:none;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl3929801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:Fixed;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:none;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4029801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:Fixed;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:none;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4129801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4229801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4329801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4429801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:none;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4529801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:none;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4629801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4729801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:Fixed;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4829801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl4929801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl5029801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:Fixed;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl5129801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:400;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial;'  + ::cEOL
	::cArq += '	mso-generic-font-family:auto;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:general;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	border-top:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	border-right:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-bottom:1.0pt solid windowtext;'  + ::cEOL
	::cArq += '	border-left:.5pt solid windowtext;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '.xl5229801'  + ::cEOL
	::cArq += '	{padding-top:1px;'  + ::cEOL
	::cArq += '	padding-right:1px;'  + ::cEOL
	::cArq += '	padding-left:1px;'  + ::cEOL
	::cArq += '	mso-ignore:padding;'  + ::cEOL
	::cArq += '	color:windowtext;'  + ::cEOL
	::cArq += '	font-size:10.0pt;'  + ::cEOL
	::cArq += '	font-weight:700;'  + ::cEOL
	::cArq += '	font-style:normal;'  + ::cEOL
	::cArq += '	text-decoration:none;'  + ::cEOL
	::cArq += '	font-family:Arial, sans-serif;'  + ::cEOL
	::cArq += '	mso-font-charset:0;'  + ::cEOL
	::cArq += '	mso-number-format:General;'  + ::cEOL
	::cArq += '	text-align:center;'  + ::cEOL
	::cArq += '	vertical-align:bottom;'  + ::cEOL
	::cArq += '	mso-background-source:auto;'  + ::cEOL
	::cArq += '	mso-pattern:auto;'  + ::cEOL
	::cArq += '	white-space:nowrap;}'  + ::cEOL
	::cArq += '-->'  + ::cEOL
	::cArq += '</style>'  + ::cEOL
	::cArq += '</head>'  + ::cEOL
	&& Fim dos Estilos
	
	&& Inicio da Planilha
	::cArq += '<body>'  + ::cEOL
	::cArq += '<!--[if !excel]>&nbsp;&nbsp;<![endif]-->'  + ::cEOL
	::cArq += '<!--As seguintes informa็๕es foram geradas pelo Assistente para Publica็ใo como'  + ::cEOL
	::cArq += 'Pแgina da Web do Microsoft Office Excel.-->'  + ::cEOL
	::cArq += '<!--Se o mesmo item for republicado a partir do Excel, todas as informa็๕es'  + ::cEOL
	::cArq += 'entre as marcas DIV serใo substituํdas.-->'  + ::cEOL
	::cArq += '<!----------------------------->'  + ::cEOL
	::cArq += "<!--INอCIO DA SAอDA DO 'ASSISTENTE PARA PUBLICAวรO COMO PมGINA DA WEB' DO EXCEL"  + ::cEOL
	::cArq += '-->'  + ::cEOL
	::cArq += '<!----------------------------->'  + ::cEOL

	::cArq += '<div id="Myers001_29801" align=center x:publishsource="Excel">'  + ::cEOL

	::cArq += "<table x:str border=0 cellpadding=0 cellspacing=0 width=930 style='border-collapse:collapse;table-layout:fixed;width:698pt'>"  + ::cEOL
	::cArq += " <col width=78 style='mso-width-source:userset;mso-width-alt:2852;width:59pt'>"  + ::cEOL
	::cArq += " <col width=71 style='mso-width-source:userset;mso-width-alt:2596;width:53pt'>"  + ::cEOL
	::cArq += " <col width=78 style='mso-width-source:userset;mso-width-alt:2852;width:59pt'>"  + ::cEOL
	::cArq += " <col width=49 style='mso-width-source:userset;mso-width-alt:1792;width:37pt'>"  + ::cEOL
	::cArq += " <col width=39 style='mso-width-source:userset;mso-width-alt:1426;width:29pt'>"  + ::cEOL
	::cArq += " <col width=53 style='mso-width-source:userset;mso-width-alt:1938;width:40pt'>"  + ::cEOL
	::cArq += " <col width=56 style='mso-width-source:userset;mso-width-alt:2048;width:42pt'>"  + ::cEOL
	::cArq += " <col width=32 style='mso-width-source:userset;mso-width-alt:1170;width:24pt'>"  + ::cEOL
	::cArq += " <col width=40 style='mso-width-source:userset;mso-width-alt:1462;width:30pt'>"  + ::cEOL
	::cArq += " <col width=72 style='mso-width-source:userset;mso-width-alt:2633;width:54pt'>"  + ::cEOL
	::cArq += " <col width=60 style='mso-width-source:userset;mso-width-alt:2194;width:45pt'>"  + ::cEOL
	::cArq += " <col width=112 style='mso-width-source:userset;mso-width-alt:4096;width:84pt'>"  + ::cEOL
	::cArq += " <col width=52 style='mso-width-source:userset;mso-width-alt:1901;width:39pt'>"  + ::cEOL
	::cArq += " <col width=79 style='mso-width-source:userset;mso-width-alt:2889;width:59pt'>"  + ::cEOL
	::cArq += " <col width=59 style='mso-width-source:userset;mso-width-alt:2157;width:44pt'>"  + ::cEOL
	::cArq += " <col width=59 style='mso-width-source:userset;mso-width-alt:2157;width:44pt'>"  + ::cEOL
	::cArq += " <col width=59 style='mso-width-source:userset;mso-width-alt:2157;width:44pt'>"  + ::cEOL
	::cArq += " <col width=59 style='mso-width-source:userset;mso-width-alt:2157;width:44pt'>"  + ::cEOL

Return

&& Imprime Titulos
Method ImpTit(cXtitu) Class MYTMK16

	&& Indentifica a Divisao e a Data de Emissao
	::cArq += " <tr height=17 style='height:12.75pt'>"  + ::cEOL
	::cArq += "  <td colspan=15 height=17 class=xl5229801 width=930 style='height:12.75pt;"  + ::cEOL
	::cArq += "  width:698pt' x:str='FATURAMENTO MENSAL MYERS '>FATURAMENTO MENSAL MYERS<span"  + ::cEOL
	::cArq += "  style='mso-spacerun:yes'> </span></td>"  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += " <tr height=17 style='height:12.75pt'>"  + ::cEOL
	::cArq += "  <td colspan=15 height=17 class=xl5229801 style='height:12.75pt'>Perํodo de"  + ::cEOL
	::cArq += "  Emissใo das Notas Fiscais - De: "+Dtoc(mv_par01)+" - At้ "+Dtoc(mv_par02)+"</td>"  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += " <tr height=17 style='height:12.75pt'>"  + ::cEOL
	::cArq += "  <td height=17 class=xl1529801 style='height:12.75pt'></td>"  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += '  <td class=xl1529801></td>'  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += " <tr height=18 style='mso-height-source:userset;height:13.5pt'>"  + ::cEOL
	::cArq += "  <td colspan=15 height=18 class=xl5229801 style='height:13.5pt'>"+cXtitu+"</td>"  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	
	&& Nome das Colunas
	::cArq += " <tr height=18 style='mso-height-source:userset;height:13.5pt'>"  + ::cEOL
	::cArq += "  <td height=18 class=xl2229801 style='height:13.5pt'>N.F. / Serie</td>"  + ::cEOL
	::cArq += "  <td class=xl2329801 style='border-left:none'>Data</td>"  + ::cEOL
	::cArq += "  <td class=xl2329801 style='border-left:none'>Cod.Cliente</td>"  + ::cEOL				//26	- CODIGO CLIENTE
	::cArq += "  <td class=xl2329801 style='border-left:none'>Loja</td>"  + ::cEOL						//27	- LOJA
   	::cArq += "  <td class=xl2329801 style='border-left:none'>Cliente</td>"  + ::cEOL					//03	- CLIENTE
	::cArq += "  <td class=xl2329801 style='border-left:none'>P/N</td>"  + ::cEOL						//04	- CODIGO DO PRODUTO  
	::cArq += "  <td class=xl2329801 style='border-left:none'>Descricao</td>"  + ::cEOL					//24	- DESCRICAO
	::cArq += "  <td class=xl2329801 style='border-left:none'>Qtd.</td>"  + ::cEOL						//06	- QUANTIDADE
	::cArq += "  <td class=xl2329801 style='border-left:none'>Vl.Unit.</td>"  + ::cEOL					//07	- PRECO UNITARIO
	::cArq += "  <td class=xl2329801 style='border-left:none'>Vl.Total</td>"  + ::cEOL					//08	- VALOR TOTAL
	::cArq += "  <td class=xl2329801 style='border-left:none'>IPI</td>"  + ::cEOL						//09	- IPI
	::cArq += "  <td class=xl2329801 style='border-left:none'>ICMS</td>"  + ::cEOL						//10	- ICMS
	::cArq += "  <td class=xl2329801 style='border-left:none'>PIS/Cofins</td>"  + ::cEOL				//11	- PIS
	::cArq += "  <td class=xl2329801 style='border-left:none'>Total NF</td>"  + ::cEOL					//12	- TOTAL
	::cArq += "  <td class=xl2329801 style='border-left:none'>Total Liquido R$</td>"  + ::cEOL			//13	- TOTAL LIQUIDO
	::cArq += "  <td class=xl2329801 style='border-left:none'>Frete/NF</td>"  + ::cEOL					//21	- FRETE    
	::cArq += "  <td class=xl2329801 style='border-left:none'>Unit.Liq.S/Frete R$</td>"  + ::cEOL		//28	- VALOR UNITARIO LIQUIDO SEM FRETE
	::cArq += "  <td class=xl2329801 style='border-left:none'>Unit.Liq.C/Frete R$</td>"  + ::cEOL		//29	- VALOR UNITARIO LIQUIDO COM FRETE
	::cArq += "  <td class=xl2329801 style='border-left:none'>Custo</td>"  + ::cEOL						//14	- CUSTO
	::cArq += "  <td class=xl2329801 style='border-left:none'>% Margem</td>"  + ::cEOL					//15	- MARGEM
	::cArq += "  <td class=xl2329801 style='border-left:none'>Grupo</td>"  + ::cEOL						//16	- DESCR. GRUPO
	::cArq += "  <td class=xl2329801 style='border-left:none'>Vendedor</td>"  + ::cEOL					//19	- VENDENDOR
	::cArq += "  <td class=xl2329801 style='border-left:none'>CFOP</td>"  + ::cEOL						//20	- CFOP
	::cArq += "  <td class=xl2329801 style='border-left:none'>Segmento</td>"  + ::cEOL					//22	- SEGMENTO					
	::cArq += "  <td class=xl2329801 style='border-left:none'>Pedido</td>"  + ::cEOL					//23	- PEDIDO  
	::cArq += "  <td class=xl2329801 style='border-left:none'>TP Frete</td>"  + ::cEOL					//25	- TP FRETE 
	::cArq += "  <td class=xl2329801 style='border-left:none'>Descr.Segmento</td>"  + ::cEOL			//30	- DESCR.SEGMENTO
	::cArq += "  <td class=xl2329801 style='border-left:none'>Num.Ped.Com</td>"  + ::cEOL				//31	- NUM.PED.COM
	::cArq += "  <td class=xl2329801 style='border-left:none'>Item.Ped.Com</td>"  + ::cEOL				//32	- ITEM PED COM
    ::cArq += "  <td class=xl2329801 style='border-left:none'>E-mail</td>"  + ::cEOL					//32	- e-mail
	::cArq += " </tr>"  + ::cEOL

Return

&& Imprime Detalhe
Method ImpDet() Class MYTMK16 //Myex001

	::cArq += " <tr height=17 style='height:12.75pt'>"  + ::cEOL
	::cArq += "  <td height=17 class=xl2529801 style='height:12.75pt'>"+AllTrim(&cArray[nPos,01]+'/'+&cArray[nPos,18])+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2629801 align=right style='border-left:none' x:num='"+;
	AllTrim(Transform(&cArray[nPos,02]-cTod('00/00/1900'),"@E 99999"))+"'>"+DtoC(&cArray[nPos,02])+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2729801 style='border-left:none'>"+Alltrim(&cArray[nPos,26])+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2729801 style='border-left:none'>"+Alltrim(&cArray[nPos,27])+"</td>"  + ::cEOL   
	::cArq += "  <td class=xl2729801 style='border-left:none'>"+Alltrim(&cArray[nPos,03])+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2829801 style='border-left:none'>"+AllTrim(&cArray[nPos,04])+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2829801 style='border-left:none'>"+Alltrim(&cArray[nPos,24])+"</td>"  + ::cEOL  
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,06],"@E 9999999.99"))		,",","."))+"'>"+AllTrim(Transform(&cArray[nPos,06],"@E 9,999,999.99"))	+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,07],"@E 9999999.99"))		,",","."))+"'>"+AllTrim(Transform(&cArray[nPos,07],"@E 9,999,999.99"))  +"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,08],"@E 999999999.99")),",","."))+"'>"+AllTrim(Transform(&cArray[nPos,08],"@E 999,999,999.99"))	+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,09],"@E 9999999.99"))	,",","."))+"'>"+AllTrim(Transform(&cArray[nPos,09],"@E 9,999,999.99"))		+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,10],"@E 9999999.99"))	,",","."))+"'>"+AllTrim(Transform(&cArray[nPos,10],"@E 9,999,999.99"))		+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,11],"@E 9999999.99"))	,",","."))+"'>"+AllTrim(Transform(&cArray[nPos,11],"@E 9,999,999.99"))		+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,12],"@E 999999999.99")),",","."))+"'>"+AllTrim(Transform(&cArray[nPos,12],"@E 999,999,999.99"))	+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,13],"@E 999999999.99")),",","."))+"'>"+AllTrim(Transform(&cArray[nPos,13],"@E 999,999,999.99"))	+"</td>"  + ::cEOL 
   ::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,21],"@E 9999999.99"))	,",","."))+"'>"+AllTrim(Transform(&cArray[nPos,21],"@E 9,999,999.99"))		+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,28],"@E 999999999.99")),",","."))+"'>"+AllTrim(Transform(&cArray[nPos,28],"@E 999,999,999.99"))	+"</td>"  + ::cEOL  
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(&cArray[nPos,29],"@E 999999999.99")),",","."))+"'>"+AllTrim(Transform(&cArray[nPos,29],"@E 999,999,999.99"))	+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(00,"@E 999999999.99")),",","."))+"'>"+AllTrim(Transform(00,"@E 999,999,999.99"))	+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 align=right style='border-left:none' x:num='"+AllTrim(StrTran(AllTrim(Transform(00,"@E 9999.99")),",","."))+"'>"+AllTrim(Transform(00,"@E 9999.99"))	+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 style='border-left:none'>"+Substr(&cArray[nPos,16],01,12)+"</td>"  + ::cEOL
   ::cArq += "  <td class=xl2929801 style='border-left:none'>"+Substr(&cArray[nPos,19],01,12)+"</td>"  + ::cEOL
	::cArq += "  <td class=xl2929801 style='border-left:none'>"+Alltrim(&cArray[nPos,20])+"</td>"  + ::cEOL
    ::cArq += "  <td class=xl2929801 style='border-left:none'>"+Alltrim(&cArray[nPos,22])+"</td>"  + ::cEOL
    ::cArq += "  <td class=xl2929801 style='border-left:none'>"+Alltrim(&cArray[nPos,23])+"</td>"  + ::cEOL        
    ::cArq += "  <td class=xl2929801 style='border-left:none'>"+Alltrim(&cArray[nPos,25])+"</td>"  + ::cEOL
    ::cArq += "  <td class=xl2929801 style='border-left:none'>"+Alltrim(&cArray[nPos,30])+"</td>"  + ::cEOL
    ::cArq += "  <td class=xl2929801 style='border-left:none'>"+Alltrim(&cArray[nPos,31])+"</td>"  + ::cEOL
    ::cArq += "  <td class=xl2929801 style='border-left:none'>"+Alltrim(&cArray[nPos,32])+"</td>"  + ::cEOL
    ::cArq += "  <td class=xl2929801 style='border-left:none'>"+Alltrim(&cArray[nPos,33])+"</td>"  + ::cEOL
	::cArq += " </tr>"  + ::cEOL

Return

&& Imprime Total 1
Method ImpT1() Class MYTMK16 //Myex001

	::cArq += " <tr height=17 style='mso-height-source:userset;height:12.75pt'>"  + ::cEOL
	::cArq += "  <td height=17 class=xl2729801 style='height:12.75pt'>&nbsp;</td>"  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL  
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL   
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += " <tr height=18 style='mso-height-source:userset;height:13.5pt'>"  + ::cEOL
	::cArq += "  <td height=18 class=xl3329801 style='height:13.5pt;border-top:none'>Sub-Total</td>"  + ::cEOL
	::cArq += '  <td class=xl3429801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3429801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3429801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3529801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3529801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3529801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3529801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3529801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nVltotal1,"@E 999999999.99")),",","."))						+'">'+AllTrim(Transform(nVltotal1,"@E 999,999,999.99"))+'</td>'  						+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nIPI1,"@E 9999999.99")),",","."))								+'">'+AllTrim(Transform(nIPI1,"@E 9,999,999.99"))+'</td>'  								+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nICMS1,"@E 9999999.99")),",","."))								+'">'+AllTrim(Transform(nICMS1,"@E 9,999,999.99"))+'</td>'  							+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nPisCof1,"@E 9999999.99")),",","."))							+'">'+AllTrim(Transform(nPisCof1,"@E 9,999,999.99"))+'</td>'  							+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nTotNF1,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(nTotNF1,"@E 999,999,999.99"))+'</td>'  						+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nTotLiq1,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(nTotLiq1,"@E 999,999,999.99"))+'</td>'  						+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(00,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(nCusto1,"@E 999,999,999.99"))+'</td>'  						+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(00,"@E 9999.99")),",","."))	+'">'+AllTrim(Transform(00,"@E 9999.99"))+'</td>'	+ ::cEOL
	::cArq += '  <td class=xl3529801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3629801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3629801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3629801>&nbsp;</td>'  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL

	&& Zera acumuladores do grupo
	nQtd1:=nVlTotal1:=nIPI1:=nICMS1:=nPisCof1:=nTotNF1:=nTotLiq1:=nCusto1:=nMargem1:=nCont1:=0.00

Return

Method ImpT2() Class MYTMK16 //Myex001

	::cArq += " <tr height=17 style='mso-height-source:userset;height:12.75pt'>"  + ::cEOL
	::cArq += "  <td height=17 class=xl3729801 style='height:12.75pt'>&nbsp;</td>"  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL                                                                                                        "
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3829801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3929801>&nbsp;</td>'  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += " <tr height=17 style='mso-height-source:userset;height:12.75pt'>"  + ::cEOL
	::cArq += "  <td height=17 class=xl2729801 style='height:12.75pt'>&nbsp;</td>"  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += " <tr height=17 style='mso-height-source:userset;height:12.75pt'>"  + ::cEOL
	::cArq += "  <td height=17 class=xl4229801 style='height:12.75pt'>Total</td>"  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL  
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nVltotal2,"@E 999999999.99")),",","."))						+'">'+AllTrim(Transform(nVltotal2,"@E 999,999,999.99"))+'</td>'  						+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nIPI2,"@E 9999999.99")),",","."))								+'">'+AllTrim(Transform(nIPI2,"@E 9,999,999.99"))+'</td>'  								+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nICMS2,"@E 9999999.99")),",","."))								+'">'+AllTrim(Transform(nICMS2,"@E 9,999,999.99"))+'</td>'  							+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nPisCof2,"@E 9999999.99")),",","."))							+'">'+AllTrim(Transform(nPisCof2,"@E 9,999,999.99"))+'</td>'  							+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nTotNF2,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(nTotNF2,"@E 999,999,999.99"))+'</td>'  						+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nTotLiq2,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(nTotLiq2,"@E 999,999,999.99"))+'</td>'  						+ ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(00,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(00,"@E 999,999,999.99"))+'</td>'  						+ ::cEOL
	::cArq += '  <td class=xl2929801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(00,"@E 9999.99")),",","."))	+'">'+AllTrim(Transform(00,"@E 9999.99"))+'</td>'	+ ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL 
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL 
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL

	&& Zera acumuladores do grupo
	nQtd2:=nVlTotal2:=nIPI2:=nICMS2:=nPisCof2:=nTotNF2:=nTotLiq2:=nCusto2:=nMargem2:=nCont2:=0.00

Return

&& Imprime o total geral
Method ImpTG() Class MYTMK16 //Myex001      

	::cArq += " <tr height=17 style='mso-height-source:userset;height:12.75pt'>"  + ::cEOL
	::cArq += "  <td height=17 class=xl2729801 style='height:12.75pt'>&nbsp;</td>"  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += " <tr height=17 style='mso-height-source:userset;height:12.75pt'>"  + ::cEOL
	::cArq += "  <td height=17 class=xl2729801 style='height:12.75pt'>&nbsp;</td>"  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl3229801>&nbsp;</td>'  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += " <tr height=18 style='mso-height-source:userset;height:13.5pt'>"  + ::cEOL
	::cArq += "  <td height=18 class=xl4429801 style='height:13.5pt'>Total Geral</td>"  + ::cEOL 
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL  
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL
	::cArq += '  <td class=xl2929801>&nbsp;</td>'  + ::cEOL 
	::cArq += '  <td class=xl4629801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nVltotalT,"@E 999999999.99")),",","."))						+'">'+AllTrim(Transform(nVltotalT,"@E 999,999,999.99"))+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nIPIT,"@E 9999999.99")),",","."))								+'">'+AllTrim(Transform(nIPIT,"@E 9,999,999.99"))+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nICMST,"@E 9999999.99")),",","."))								+'">'+AllTrim(Transform(nICMST,"@E 9,999,999.99"))+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nPisCofT,"@E 9999999.99")),",","."))							+'">'+AllTrim(Transform(nPisCofT,"@E 9,999,999.99"))+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nTotNFT,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(nTotNFT,"@E 999,999,999.99"))+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(nTotLiqT,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(nTotLiqT,"@E 999,999,999.99"))+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL  
	::cArq += '  <td class=xl4629801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(00,"@E 999999999.99")),",","."))							+'">'+AllTrim(Transform(nCustoT,"@E 999,999,999.99"))+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+AllTrim(StrTran(AllTrim(Transform(00,"@E 9999.99")),",","."))	+'">'+AllTrim(Transform(00,"@E 9999.99"))+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL 
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL 
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL 
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += '  <td class=xl4629801 align=right x:num="'+""							+'">'+""+'</td>'  + ::cEOL
	::cArq += " <tr height=17 style='height:12.75pt'>"  + ::cEOL
	::cArq += "  <td colspan=25 height=17 class=xl5000000 style='height:12.75pt'>Legenda Segmento"  + ::cEOL
	::cArq += "  (000001-AUTOMOTIVE), (000002-FOOD/AGRIBUSINESS), (000003-PHARMA/PERSONAL CARE), (000004-INTERCOMPANY), (000005-HANDLING/MANUFACTURING/RETAIL), (000006-BEVERAGE), (000007-SAFETY/SIGNAGE), (000008-OTHERS)</td>"  + ::cEOL
   	::cArq += ' </tr>'  + ::cEOL
   	::cArq += " <tr height=17 style='height:12.75pt'>"  + ::cEOL
	::cArq += "  "+FWFilRazSocial()+"</td>"  + ::cEOL  
	::cArq += ' </tr>'  + ::cEOL
	::cArq += "  <td class=xl4729801>&nbsp;<!-----------------------------><!--FIM DA SAอDA DO 'ASSISTENTE PARA PUBLICAวรO COMO PมGINA DA WEB' DO EXCEL--><!-----------------------------></td>"  + ::cEOL
	
	
	&& Finaliza a planilha
	::cArq += ' <![if supportMisalignedColumns]>'  + ::cEOL
	::cArq += " <tr height=0 style='display:none'>"  + ::cEOL
	::cArq += "  <td width=78 style='width:59pt'></td>"  + ::cEOL
	::cArq += "  <td width=71 style='width:53pt'></td>"  + ::cEOL
	::cArq += "  <td width=78 style='width:59pt'></td>"  + ::cEOL
	::cArq += "  <td width=49 style='width:37pt'></td>"  + ::cEOL
	::cArq += "  <td width=39 style='width:29pt'></td>"  + ::cEOL
	::cArq += "  <td width=53 style='width:40pt'></td>"  + ::cEOL
	::cArq += "  <td width=56 style='width:42pt'></td>"  + ::cEOL
	::cArq += "  <td width=32 style='width:24pt'></td>"  + ::cEOL
	::cArq += "  <td width=40 style='width:30pt'></td>"  + ::cEOL
	::cArq += "  <td width=72 style='width:54pt'></td>"  + ::cEOL
	::cArq += "  <td width=60 style='width:45pt'></td>"  + ::cEOL
	::cArq += "  <td width=112 style='width:84pt'></td>"  + ::cEOL
	::cArq += "  <td width=52 style='width:39pt'></td>" + ::cEOL
	::cArq += "  <td width=79 style='width:59pt'></td>"  + ::cEOL
	::cArq += "  <td width=59 style='width:44pt'></td>"  + ::cEOL
	::cArq += "  <td width=59 style='width:44pt'></td>"  + ::cEOL
	::cArq += "  <td width=59 style='width:44pt'></td>"  + ::cEOL
	::cArq += "  <td width=59 style='width:44pt'></td>"  + ::cEOL
	::cArq += ' </tr>'  + ::cEOL
	::cArq += ' <![endif]>'  + ::cEOL
	::cArq += '</table>'  + ::cEOL

	::cArq += '</body>'  + ::cEOL

	::cArq += '</html>'  + ::cEOL
	
Return
