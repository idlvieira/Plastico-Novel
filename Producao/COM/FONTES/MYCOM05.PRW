#include "protheus.ch"
#include "colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  | MYCOM05                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MYCOM05()

Local lReg			:= .F. 	// Verifica a exist๊ncia de Registros
Local nLastKey			:= 0
Local titulo   			:= "Pedido de Compra"
Local cMens 			:= "Nใo hแ registros para os parametros informados !!"
Local nCount			:= 0
Local cPerg		   		:= "MYCOM05"
Private cNPc 	   		:= ""
Private cEmail 	   		:= ""
Private cNomeCp                 := ""
Private cEmissao		:= ""
Private nQtdPag			:= 0
Private oFont1 			:= TFont():New("Arial",09,14,		,.T.,,,,,.F.) //Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
Private oFont2  		:= TFont():New("Arial",07,08,		,.F.,,,,,.F.) // Normal
Private oFont2B  		:= TFont():New("Arial",07,08,.T.	,.T.,,,,,.F.) // Negrito
Private oFont3  		:= TFont():New("Arial",09,10,.T.	,.T.,,,,,.F.) // Negrito
Private oFont4  		:= TFont():New("Arial",09,14,.T.	,.T.,,,,,.T.) // Negrito - Sublinhado
Private oFont5  		:= TFont():New("Arial",09,10,   	,.F.,,,,,.F.) // Negrito
Private oFont6  		:= TFont():New("Arial",06,08,.T.	,.T.,,,,,.F.) // Negrito

Private oPrint
Private cLogo		:= "lgrl01.bmp"              //GETMV("MV_ZZLOGO"      //"LGRL01.PNG"
Private cEmaiEmp	:= "Myers Industries"      	 //GETMV("MV_ZZEMEMP")    //E-mail da Empresa

// Instโncia็ใo do Objeto OPrint
oPrint := TMSPrinter():New()

&& Faz a chamada do grupo de perguntas, caso a chamada seja feita a partir do menu
ValidPerg(cPerg)
If !(Pergunte(cPerg,.T.))
	Return
Endif

If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	return
Endif

&& Query que retorna os dados do pedido de compra e os dados dos itens.
cQuery := "SELECT "
cQuery += 	 "C7_EMISSAO,C7_NUM,C7_DATPRF,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_UM,C7_QUANT,C7_IPI,C7_PRECO,C7_TOTAL, "
cQuery += 	 "C7_VALIPI,C7_VALFRE,C7_SEGURO,C7_VALICM,C7_DESPESA,C7_VLDESC,C7_TPFRETE,C7_CC,C7_OBS,C7_CONAPRO,C7_USER, "
cQuery += 	 "C7_MSG,C7_DESC1,C7_DESC2,C7_DESC3,C7_COND,C7_VALFRE, C7_TES, "
cQuery += 	 "A2_COD, A2_HPAGE, A2_NOME,A2_END,A2_CEP,A2_DDD,A2_TEL,A2_FAX,A2_EMAIL,A2_CGC,A2_INSCR,A2_MUN, A2_EST,A2_CONTATO, A2_BAIRRO, "
cQuery +=    	 "E4_DESCRI "
cQuery += "FROM "
cQuery +=    RetSqlName("SC7") + " AS SC7 "
cQuery += "INNER JOIN "
cQuery +=    RetSqlName("SA2") + " AS SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
cQuery += "LEFT JOIN "
cQuery +=    RetSqlName("SE4") + " AS SE4 ON E4_FILIAL = '" + xFilial("SE4") + "' AND C7_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
cQuery += "WHERE "
cQuery +=    "C7_FILIAL = '" + xFilial("SC7") + "' "
//If !lAuto
cQuery +=    "AND C7_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
If !Empty(mv_par03) .AND. !Empty(mv_par04)
	cQuery +=    "AND C7_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
EndIf
cQuery +=    "AND C7_PRODUTO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
cQuery +=    "AND C7_FORNECE BETWEEN '" + mv_par07 + "' AND '" + mv_par09 + "' "
cQuery +=    "AND C7_LOJA 	 BETWEEN '" + mv_par08 + "' AND '" + mv_par10 + "' "
//Else
//	cQuery +=    "AND C7_NUM = '" + cPedNum + "' "
//Endif
cQuery +=    "AND SC7.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY C7_NUM, C7_ITEM "

MEMOWRITE("PCOMPRAS.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "cAlias"

TCSETFIELD("cAlias","C7_EMISSAO","D",08,00)
TCSETFIELD("cAlias","C7_DATPRF","D",08,00)

Count to nCount

cAlias->(dbgotop())

While cAlias->(!Eof())
	
	cNPc    := cAlias->C7_NUM
	cNomeCP := ALLTRIM(MV_PAR11)
	cEmail  := ALLTRIM(MV_PAR12)
	
	TCSETFIELD("cAlias","C7_EMISSAO","D")
	cEmissao := cAlias->C7_EMISSAO
	lReg := .T.
	
	// Query que retorna a Quantidade Total de itens do Pedido de Compra
	cQuery := "SELECT COUNT(C7_ITEM) AS Total "
	cQuery += " FROM " + RetSqlName("SC7")
	cQuery += " WHERE C7_NUM = '" + cAlias->C7_NUM + "' AND D_E_L_E_T_ = ' '"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "cCount", .T., .T. )
	
	// Atribui a Quantidade Total de itens na Variavel nCount
	nCount := cCount->Total
	
	// Controla a Quantidade de Paginas no Relatorio
	nQtdPag := STR((cCount->Total / 30)+ 1)
	nQtdPag := LEFT(nQtdPag, AT(".",nQtdPag)-1)
	
	cCount->(dbCloseArea())
	
	//Inicia uma Nova Pagina para Impressao
	oPrint:StartPage()
	
	//Define o modo de Impressao como Retrato
	oPrint:SetLandscape()       //SetPortrait()  //SetLandscape -> Para definir como modo Paisagem
	
	IMPCAB(cNPc, cEMISSAO)	//Funcao para impressao do Cabecalho
	IMPCLI()	//Funcao para impressao dos dados do Cliente
	IMPPRO(cNPc,nCount,nQtdPag)	//Funcao para impressao dos Detalhes do Produto
	
	//cAlias->(dbSkip())
	
End

cAlias->(dbCloseArea())

If lReg = .F.
	MsgSTOP(cMens)
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ MsDialog oDlg: exibi as opcoes para tratativa do relatorio.      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Define MsDialog oDlg Title "Pedido de Compra" From 0, 0 To 090, 500 Pixel
	Define Font oBold Name "Arial" Size 0, -13 Bold
	@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .F. Pixel
	@ 003, 040 Say Titulo Font oBold Pixel
	@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
	@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
	@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
	@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Preview()
	//	@ 020, 166 Button "Env. Email" 	Size 40, 13 Pixel Of oDlg Action U_MSRCOMHT(.F.,cPedNum)
	//	@ 020, 208 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
	@ 020, 166 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
	Activate MsDialog oDlg Centered
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPCAB   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do cabecalho do relatorio.	  						บฑฑ
ฑฑบ          ณ Informacao: Cabecalho - Dados da Empresa;					บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IMPCAB(cNPc, cEMISSAO)

Local nTopo		:= 0000  // Controle de Linhas
Local nInicio		:= 0000  // Indica a posi็ใo da primeira coluna


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRetorna o tamanho Horizontal e Vertical da pagina.                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nVertSize := oPrint:nVertSize()
nHorzSize := oPrint:nHorzSize()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImpressao do cabe็alho do Relatorio.															ณ
//ณObs.: O Logo pode ser colocado na pasta System do Protheus, no caso s๓ referencia o nome.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura)
oPrint:SayBitmap(nTopo + 0050, nInicio + 0040,cLogo, 514, 235)

dbSelectArea("SM0")
SM0->(dbseek(cEmPant + cFilant))

// oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
oPrint:Say(nTopo + 0050, nInicio + 2660,RTrim(SM0->M0_NOMECOM)												   		,oFont1,100,,,1)
oPrint:Say(nTopo + 0100, nInicio + 2660, AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + "/" + AllTrim(SM0->M0_ESTENT) + " " + LEFT(AllTrim(SM0->M0_CEPENT),5) + "-" + RIGHT(AllTrim(SM0->M0_CEPENT),3)		,oFont5,100,,,1)
oPrint:Say(nTopo + 0150, nInicio + 2660, "E-mail: " + ALLTRIM(cEmaiEmp) 	,oFont3,100,,,1)//							   			,oFont3,100,,,1)
oPrint:Say(nTopo + 0200, nInicio + 2660, "Tel: " + AllTrim(SM0->M0_TEL) + " FAX: " + AllTrim(SM0->M0_FAX)	   		,oFont5,100,,,1)
//oPrint:Say(nTopo + 0250, nInicio + 2660, "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + " - IE: " +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))	,oFont5,100,,,1)

// oPrint:Line(Coluna, Linha, Coluna, Linha)
oPrint:Line(nTopo + 0310, nInicio + 0040,nTopo + 0310, nInicio + 2660)
oPrint:Line(nTopo + 0313, nInicio + 0040,nTopo + 0313, nInicio + 2660)
oPrint:Line(nTopo + 0410, nInicio + 0040,nTopo + 0410, nInicio + 2660)
oPrint:Line(nTopo + 0413, nInicio + 0040,nTopo + 0413, nInicio + 2660)

oPrint:Say(nTopo + 0335	, nInicio + 0040, "Quote Nฐ " + cNPc		,oFont1,100,,,0)
oPrint:Say(nTopo + 0335	, nInicio + 2660,"Delivery: " + DTOC(cEMISSAO)			,oFont1,100,,,1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPCLI   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados do Cliente.								บฑฑ
ฑฑบ          ณ Informacoes: Nome, E-mail, Endereco, Cidade, CEP, Tel, FAX,	บฑฑ
ฑฑบ			 ณ				Contato e Bairro.								บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPCLI()
Local nTopo			:= 0000  // Controle de Linhas
Local nInicio		:= 0000  // Indica a posicao da primeira coluna

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressใo da Estrutura dos Dados do Cliente.                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


// Texto a Esquerda
oPrint:Say(nTopo + 0430	, nInicio + 0040, "Fornecedor" 	,oFont3,100,,,0)
oPrint:Say(nTopo + 0480	, nInicio + 0040, "E-mail"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0530	, nInicio + 0040, "Endere็o"	,oFont3,100,,,0)
oPrint:Say(nTopo + 0580	, nInicio + 0040, "Cidade"	  	,oFont3,100,,,0)
oPrint:Say(nTopo + 0630	, nInicio + 0040, "TEL"  		,oFont3,100,,,0)
If LEN(ALLTRIM(cAlias->A2_CGC)) > 11
	oPrint:Say(nTopo + 0680	, nInicio + 0040, "CNPJ"  		,oFont3,100,,,0)
Else
	oPrint:Say(nTopo + 0680	, nInicio + 0040, "CPF"  		,oFont3,100,,,0)
EndIF
oPrint:Say(nTopo + 0730	, nInicio + 0040, "Site"  		,oFont3,100,,,0)

//Texto Centralizado
oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" 			,oFont3,100,,,0)
oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro" 			,oFont3,100,,,0)
oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP" 				,oFont3,100,,,0)
oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"				,oFont3,100,,,0)
oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"IE"				,oFont3,100,,,0)

// Texto a Esquerda
oPrint:Say(nTopo + 0430	, nInicio + 0240, ": " + cAlias->A2_COD + " - " + cAlias->A2_NOME		,oFont5,100,,,0)
oPrint:Say(nTopo + 0480	, nInicio + 0240, ": " + cAlias->A2_EMAIL		,oFont5,100,,,0)
oPrint:Say(nTopo + 0530	, nInicio + 0240, ": " + cAlias->A2_END			,oFont5,100,,,0)
oPrint:Say(nTopo + 0580	, nInicio + 0240, ": " + AllTrim(cAlias->A2_MUN)+"/"+cAlias->A2_EST	   		,oFont5,100,,,0)
oPrint:Say(nTopo + 0630	, nInicio + 0240, ": (" + cAlias->A2_DDD + ") " + LEFT(cAlias->A2_TEL,4) + "-" + SUBSTR(cAlias->A2_TEL,5,8)	 	,oFont5,100,,,0)
If LEN(ALLTRIM(cAlias->A2_CGC)) > 11
	oPrint:Say(nTopo + 0680	, nInicio + 0240, ": " + AllTrim(Transform(cAlias->A2_CGC,"@R 99.999.999/9999-99")) ,oFont5,100,,,0)
Else
	oPrint:Say(nTopo + 0680	, nInicio + 0240, ": " + AllTrim(Transform(cAlias->A2_CGC,"@R 999.999.999-99")) ,oFont5,100,,,0)
EndIf
oPrint:Say(nTopo + 0730	, nInicio + 0240, ": " + cAlias->A2_HPAGE ,oFont5,100,,,0)

//Texto Centralizado
oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A2_CONTATO										,oFont5,100,,,0)
oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A2_BAIRRO										,oFont5,100,,,0)
oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + LEFT(cAlias->A2_CEP,5) + "-" + RIGHT(cAlias->A2_CEP,3)	,oFont5,100,,,0)
oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": (" + cAlias->A2_DDD + ") " + LEFT(cAlias->A2_FAX,4) + "-" + SUBSTR(cAlias->A2_FAX,5,8)	,oFont5,100,,,0)
If LEN(ALLTRIM(cAlias->A2_INSCR)) > 6
	oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150, ": " + AllTrim(Transform(cAlias->A2_INSCR,"@R 999.999.999.999")) ,oFont5,100,,,0)
Else
	oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150, ": " + AllTrim(cAlias->A2_INSCR) ,oFont5,100,,,0)
EndiF
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPPRO   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados de Detalhes dos Produtos.		  		บฑฑ
ฑฑบ		     ณ Parametros: cNPc - Numero do Pedido de Compra Corrente.		บฑฑ
ฑฑบ          ณ 			   nCount - Quantidade Total de Itens. 		  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPPRO(cNPc, nCount, nQtdPag)
Local nTopo		 := 0800  // Controle de Linhas
Local nInicio	 := 0000  // Indica a posi็ใo da primeira coluna
Local nTotal	 := 0000  // Controle do Valor Total do Pedido
Local nValIpi	 := 0000  // Controle do Valor Total do Pedido com IPI
Local nPag		 := 1
Local nCont		 := 0
Local nContP	 := 0
Local nTotal2	 := 0
Local nDespesa   := 0
Local nFrete     := 0
Local nTamDes	 := 0
Local nTamStr	:=0

Private nTpag		 := 0


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Box
oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2660)

//Linhas Verticais
oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
oPrint:Line(nTopo,nInicio + 1580,nTopo + 0050,nInicio + 1580)
oPrint:Line(nTopo,nInicio + 1680,nTopo + 0050,nInicio + 1680)
oPrint:Line(nTopo,nInicio + 1820,nTopo + 0050,nInicio + 1820)
oPrint:Line(nTopo,nInicio + 2020,nTopo + 0050,nInicio + 2020)
oPrint:Line(nTopo,nInicio + 2320,nTopo + 0050,nInicio + 2320)
oPrint:Line(nTopo,nInicio + 2450,nTopo + 0050,nInicio + 2450)

// Texto
oPrint:Say(nTopo + 0007,nInicio + 0060,"It"			,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 0200,"Products"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 0500,"Services"	,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 1600,"Un"			,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 1700,"Quant."			,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 1840,"Unit. Price"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 2040,"Total"		,oFont3,100,,,0)
//oPrint:Say(nTopo + 0007,nInicio + 2340,"IPI"	  		,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 2480,"Delivery"		,oFont6,100,,,0)

While cAlias->(!Eof()) .AND. cAlias->C7_NUM == cNPc
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
	//ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (nTopo + 0130) >= 1500
		
		//LInhas Horizontais  -  FIM PEDIDO
		oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2660) //2358
		
		//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2660,"Pแgina: " + STR(nPag) + " / " + AllTrim(nQtdPag)		,oFont3,100,,,1)
		
		IMPROD(NPag, nTotal, nTopo)
		
		//Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()
		
		//Define o modo de Impressใo como Retrato
		oPrint:SetLandscape()    //SetPortrait()   //SetLandscape -> Para definir como modo Paisagem
		
		//Funcao para impressao do Cabecalho
		IMPCAB(cNPc, cEMISSAO)
		
		// Incrementa o contador de Paginas
		nPag := nPag + 1
		
		nTopo := 0450
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		// Box
		oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2660)
		
		//Linhas Verticais
		oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
		oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
		oPrint:Line(nTopo,nInicio + 1580,nTopo + 0050,nInicio + 1580)
		oPrint:Line(nTopo,nInicio + 1680,nTopo + 0050,nInicio + 1680)
		oPrint:Line(nTopo,nInicio + 1820,nTopo + 0050,nInicio + 1820)
		oPrint:Line(nTopo,nInicio + 2020,nTopo + 0050,nInicio + 2020)
		oPrint:Line(nTopo,nInicio + 2320,nTopo + 0050,nInicio + 2320)
		oPrint:Line(nTopo,nInicio + 2450,nTopo + 0050,nInicio + 2450)
		
		// Texto
		oPrint:Say(nTopo + 0007,nInicio + 0060,"It"				   		,oFont3,100,,,0)
		oPrint:Say(nTopo + 0007,nInicio + 0200,"Products"					,oFont3,100,,,0)
		oPrint:Say(nTopo + 0007,nInicio + 0500,"Services"		,oFont3,100,,,0)
		oPrint:Say(nTopo + 0007,nInicio + 1600,"Un"							,oFont3,100,,,0)
		oPrint:Say(nTopo + 0007,nInicio + 1700,"Quant."						,oFont3,100,,,0)
		oPrint:Say(nTopo + 0007,nInicio + 1840,"Unit. Price"					,oFont3,100,,,0)
		oPrint:Say(nTopo + 0007,nInicio + 2040,"Total"					,oFont3,100,,,0)
		//		oPrint:Say(nTopo + 0007,nInicio + 2340,"IPI"	  					,oFont3,100,,,0)
		oPrint:Say(nTopo + 0007,nInicio + 2480,"Delivery"			   	,oFont6,100,,,0)
		
	EndIF
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Box, Linhas Verticais, Linhas Horizontais e Dados do Pedido.                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	nTamDes := LEN(ALLTRIM(cAlias->C7_DESCRI)) / 30
	
	If nTamDes > 2
		
		//Linhas Verticais - Divisao Colunas
		oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
		oPrint:Line(nTopo + 0030,nInicio + 2660,nTopo + 0090,nInicio + 2660) //2358
		
		oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
		oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
		oPrint:Line(nTopo + 0030,nInicio + 1580,nTopo + 0090,nInicio + 1580)
		oPrint:Line(nTopo + 0030,nInicio + 1680,nTopo + 0090,nInicio + 1680)
		oPrint:Line(nTopo + 0030,nInicio + 1820,nTopo + 0090,nInicio + 1820)
		oPrint:Line(nTopo + 0030,nInicio + 2020,nTopo + 0090,nInicio + 2020)
		oPrint:Line(nTopo + 0030,nInicio + 2320,nTopo + 0090,nInicio + 2320)
		oPrint:Line(nTopo + 0030,nInicio + 2450,nTopo + 0090,nInicio + 2450)
		
		TCSETFIELD("cAlias","C7_DATPRF","D")
		
		// Impressao dos Campos dos Detalhes dos Produtos
		oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C7_ITEM)							,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 0200, Ltrim(cAlias->C7_PRODUTO)						,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 0500, SubStr(Ltrim(cAlias->C7_DESCRI),1,80)					,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 1600, LTrim(cAlias->C7_UM)							,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 1800, Alltrim(STR(cAlias->C7_QUANT))  					,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 2000, Alltrim(Transform(cAlias->C7_PRECO, PesqPict('SC7', 'C7_PRECO')))	,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 2300, Alltrim(Transform(cAlias->C7_TOTAL, PesqPict('SC7', 'C7_TOTAL')))	,oFont2,100,,,1)
		//		oPrint:Say(nTopo + 0057, nInicio + 2430, Alltrim(STR(cAlias->C7_IPI,4,1))				,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 2640, DTOC(cAlias->C7_DATPRF)		,oFont2,100,,,1)
		
		nTamStr := 31
		
		For nCon := 2 to Int(nTamDes) + 1
			
			nTopo := nTopo + 0050
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
			//ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If (nTopo + 0130) >= 1500
				
				//LInhas Horizontais  -  FIM PEDIDO
				oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2660) //2358
				
				//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2660,"Pแgina: " + STR(nPag) + " / " + AllTrim(nQtdPag)		,oFont3,100,,,1)
				
				IMPROD(NPag, nTotal, nTopo)
				
				//Inicia uma Nova Pagina para Impressao
				oPrint:StartPage()
				
				//Define o modo de Impressใo como Retrato
				oPrint:SetLandscape()       //SetPortrait()   //SetLandscape -> Para definir como modo Paisagem
				
				//Funcao para impressao do Cabecalho
				IMPCAB(cNPc, cEMISSAO)
				
				// Incrementa o contador de Paginas
				nPag := nPag + 1
				
				nTopo := 0450
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				// Box
				oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2660)
				
				//Linhas Verticais
				oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
				oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
				oPrint:Line(nTopo,nInicio + 1580,nTopo + 0050,nInicio + 1580)
				oPrint:Line(nTopo,nInicio + 1680,nTopo + 0050,nInicio + 1680)
				oPrint:Line(nTopo,nInicio + 1820,nTopo + 0050,nInicio + 1820)
				oPrint:Line(nTopo,nInicio + 2020,nTopo + 0050,nInicio + 2020)
				oPrint:Line(nTopo,nInicio + 2320,nTopo + 0050,nInicio + 2320)
				oPrint:Line(nTopo,nInicio + 2450,nTopo + 0050,nInicio + 2450)
				
				// Texto
				oPrint:Say(nTopo + 0007,nInicio + 0060,"It"				   		,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 0200,"Products"					,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 0500,"Services"		,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1600,"Un"							,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1700,"Quant."						,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1840,"Unit. Price"					,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2040,"Total"					,oFont3,100,,,0)
				//				oPrint:Say(nTopo + 0007,nInicio + 2340,"IPI"	  					,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2480,"Delivery"			   	,oFont6,100,,,0)
				
			EndIF
			
			
			//Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2660,nTopo + 0090,nInicio + 2660) //2358
			
			oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
			oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
			oPrint:Line(nTopo + 0030,nInicio + 1580,nTopo + 0090,nInicio + 1580)
			oPrint:Line(nTopo + 0030,nInicio + 1680,nTopo + 0090,nInicio + 1680)
			oPrint:Line(nTopo + 0030,nInicio + 1820,nTopo + 0090,nInicio + 1820)
			oPrint:Line(nTopo + 0030,nInicio + 2020,nTopo + 0090,nInicio + 2020)
			oPrint:Line(nTopo + 0030,nInicio + 2320,nTopo + 0090,nInicio + 2320)
			oPrint:Line(nTopo + 0030,nInicio + 2450,nTopo + 0090,nInicio + 2450)
			
			oPrint:Say(nTopo + 0057, nInicio + 0500, Substr(Ltrim(cAlias->C7_DESCRI),nTamStr,80)		,oFont2,100,,,0)
			
			nTamStr := nTamStr + 30
		Next
		
	Else
		
		//Linhas Verticais - Divisao Colunas
		oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
		oPrint:Line(nTopo + 0030,nInicio + 2660,nTopo + 0090,nInicio + 2660) //2358
		
		oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
		oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
		oPrint:Line(nTopo + 0030,nInicio + 1580,nTopo + 0090,nInicio + 1580)
		oPrint:Line(nTopo + 0030,nInicio + 1680,nTopo + 0090,nInicio + 1680)
		oPrint:Line(nTopo + 0030,nInicio + 1820,nTopo + 0090,nInicio + 1820)
		oPrint:Line(nTopo + 0030,nInicio + 2020,nTopo + 0090,nInicio + 2020)
		oPrint:Line(nTopo + 0030,nInicio + 2320,nTopo + 0090,nInicio + 2320)
		oPrint:Line(nTopo + 0030,nInicio + 2450,nTopo + 0090,nInicio + 2450)
		
		TCSETFIELD("cAlias","C7_DATPRF","D")
		
		// Impressao dos Campos dos Detalhes dos Produtos
		oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C7_ITEM)		,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 0200, Ltrim(cAlias->C7_PRODUTO)		,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 0500, Ltrim(cAlias->C7_DESCRI)		,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 1600, LTrim(cAlias->C7_UM)							,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 1800, Alltrim(STR(cAlias->C7_QUANT))  					,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 2000, Alltrim(Transform(cAlias->C7_PRECO, PesqPict('SC7', 'C7_PRECO')))	,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 2300, Alltrim(Transform(cAlias->C7_TOTAL, PesqPict('SC7', 'C7_TOTAL')))	,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 2430, Alltrim(STR(cAlias->C7_IPI,4,1))				,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 2640, DTOC(cAlias->C7_DATPRF)		,oFont2,100,,,1)
		
	endif
	// Calculo do Valor Total do Pedido de Compra
	nTotal += cAlias->C7_TOTAL
	nFrete += cAlias->C7_VALFRE
	nDespesa += cAlias->C7_DESPESA
	nValIpi  += cAlias->C7_VALIPI
	
	nTopo := nTopo + 0050
	
	//Incrementa Contador da Quantidade de Itens no Pedido de Compra
	++nCont
	
	//Se o arquivo chegou ao fim, imprime rodape.
	If nCont >= nCount
		
		nTotal2 := nTotal + nFrete + nDespesa + nValIpi
		
		oPrint:Box(nTopo + 0060, nInicio + 0480, nTopo + 0110, nInicio + 1300)
		oPrint:Line(nTopo + 0060, nInicio + 0970,nTopo + 0110,nInicio + 0970)
		
		oPrint:Say(nTopo + 0067, nInicio + 0500, "Frete"		,oFont3,100,,,0)
		oPrint:Say(nTopo + 0067, nInicio + 1280, " " + Alltrim(Transform(nFrete,PesqPict('SC7', 'C7_VALFRE')))	,oFont3,100,,,1)
		
		oPrint:Box(nTopo + 0110, nInicio + 0480, nTopo + 0160, nInicio + 1300)
		oPrint:Line(nTopo + 0110, nInicio + 0970,nTopo + 0160,nInicio + 0970)
		
		oPrint:Say(nTopo + 0117, nInicio + 0500, "Outras Despesas"		,oFont3,100,,,0)
		oPrint:Say(nTopo + 0117, nInicio + 1280, " " + Alltrim(Transform(nDespesa,PesqPict('SC7', 'C7_DESPESA')))	,oFont3,100,,,1)
		
		
		//Box e Dados - Valor Total
		oPrint:Box(nTopo + 0060, nInicio + 1320, nTopo + 0110, nInicio + 1920)
		oPrint:Line(nTopo + 0060, nInicio + 1620,nTopo + 0110,nInicio + 1620)
		
		oPrint:Say(nTopo + 0067, nInicio + 1340, "Valor Total S/IPI"		,oFont3,100,,,0)
		oPrint:Say(nTopo + 0067, nInicio + 1900, " " + Alltrim(Transform(nTotal,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)
		
		oPrint:Box(nTopo + 0110, nInicio + 1320, nTopo + 0160, nInicio + 1920)
		oPrint:Line(nTopo + 0110, nInicio + 1620,nTopo + 0160,nInicio + 1620)
		
		oPrint:Say(nTopo + 0117, nInicio + 1340, "Valor Total C/IPI"		,oFont3,100,,,0)
		oPrint:Say(nTopo + 0117, nInicio + 1900, " " + Alltrim(Transform(nTotal2,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)
		
		//LInhas Horizontais  -  FIM PEDIDO
		oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2660) //2358
		
		
		//Imprime o Numero de Paginas
		//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2660,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)  ,oFont3,100,,,1)
		
		// Funcao de Impressao do Rodape. Parametro: Numero da linha atual
		IMPROD(NPag, nTotal, nTopo)
	EndIf
	
	cAlias->(dbskip())
	
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPROD	บ Autor ณ Hermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para impressao do Rodape.								บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPROD(nPag, nTotal, nTopo)

Local nInicio		:= 0000  // Indica a posicao da primeira coluna

If nTopo <= (Mm2Pix(oPrint, oPrint:nVertSize()) - 0540)
	
	// Box Condicoes Gerais
	
	oPrint:EndPage()
	
	
Else
	
	//Encerra a Pagina Atual
	oPrint:EndPage()
	
	//Inicia uma Nova Pagina para Impressao
	oPrint:StartPage()
	
	//Define o modo de Impressใo como Retrato
	oPrint:SetLandscape()         //SetPortrait()  //SetLandscape -> Para definir como modo Paisagem
	
	//Funcao para impressao do Cabecalho
	IMPCAB(cNPc, cEMISSAO)
	nTopo := 0420
	
	NPag += 1
	
	oPrint:EndPage()
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ Mm2Pix   บ Autor ณWaldir Baldin		   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a Largura da Pagina em Pixel.						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mm2Pix(oPrint, nMm)
/*Retirado metodo oPrint:nLogPixelX(), pois estava ocorrendo casos em clientes
em que a linha impressa que utliza a funcao MM2PIX saia desconfigurada*/
//Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
Local nValor := (nMm * 300) / 25.4
Return nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณHermes Vieira Jr.   บ Data ณ  15/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se existe um grupo de perguntas caso contrario o    บฑฑ
ฑฑบ          ณ o grupo de perguntas e criado.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 - DB2                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/	Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
aAdd(aRegs, {cPerg, "02", "Pedido at้ "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "04", "Data at้ "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 30, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
aAdd(aRegs, {cPerg, "06", "Produto at้ "     			,"" ,"" ,"mv_ch6", "C", 30, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
aAdd(aRegs, {cPerg, "07", "Fornecedor de "     			,"" ,"" ,"mv_ch7", "C", 06, 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
aAdd(aRegs, {cPerg, "08", "Loja de "     				,"" ,"" ,"mv_ch8", "C", 02, 0, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "09", "Fornecedor at้ "     		,"" ,"" ,"mv_ch9", "C", 06, 0, 0, "G", "", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
aAdd(aRegs, {cPerg, "10", "Loja at้ "     				,"" ,"" ,"mv_chA", "C", 02, 0, 0, "G", "", "mv_par10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "11", "Nome Comprador   "     		,"" ,"" ,"mv_chB", "C", 40, 0, 0, "G", "", "mv_par11", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "12", "E-mail Comprador "			,"" ,"" ,"mv_chC",  "C", 60, 0, 0, "G", "", "mv_par12", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return .T.
