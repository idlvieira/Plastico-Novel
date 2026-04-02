#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'     


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SF1100I ³ Autor ³ Jefferson Moreira     ³ Data ³ 06/07/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³P.E. Para inclusao de informacoes da NF-e de Importacao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SF1100I

Local cMenNota := ""
Local cNome := ""

If SA2->A2_EST == "EX"
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	
	
	Private cDI        := Space(20)
	Private dDtDI      := CtoD(" ")
	Private cDMI	   := Space(20)
	Private cLocDesemb := Space(80)
	Private cUF 	   := SPACE(2)
	Private dDtDesemb  := CtoD(" ")
	Private cFornece   := Space(20)
	Private cFabric    := Space(20)
	Private cConteiner := Space(20)
	Private cUF 	   := Space(2)
	Private nVALII 	   := 0
	Private nVLPIS 	   := 0
	Private nValCOF    := 0
	Private nDespAC	   := 0
	Private nValCap    := 0
	Private nSeguro	   := 0
	Private nOutros	   := 0
	Private nBPIS	   := 0
	Private nBCOF	   := 0
    Private nTBVBCII   := 0  //NOVEL - TEMPORARIO PARA PERMITIR IMPORTACAO DEVE SER REMOVIDO NA ATUALIZACAO

	//
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg1","oPanel1","oSay5","oSay3","oSay1","oSay2","oSay4","oSay7","oSay6","oSay8","oSay9","oSay10")
//NOVEL - TEMPORARIO PARA PERMITIR IMPORTACAO DEVE SER REMOVIDO NA ATUALIZACAO - ORIGINAL COMENTADO ABAIXO
//	SetPrvt("oGet3","oCBox1","oGet4","oGet5","oGet6","oSBtn1","oSBtn2","oGet2","oGet7","oGet8","oGet9","oGet10","oGet11","oGet12","oGet13","oGet14","oGet15","oGet16","oGet17","oGet18")
	SetPrvt("oGet3","oCBox1","oGet4","oGet5","oGet6","oSBtn1","oSBtn2","oGet2","oGet7","oGet8","oGet9","oGet10","oGet11","oGet12","oGet13","oGet14","oGet15","oGet16","oGet17","oGet18","oGet19")
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 088,232,420,925,"Dados de Importação",,,.F.,,,,,,.T.,,,.T. )
	oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,344,155,.T.,.F. )
	
	// Label da oDlg1
	oSay5      := TSay():New( 042,010,{||"Dt. Desemb.:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay3      := TSay():New( 025,010,{||"Local Desemb.:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay1      := TSay():New( 011,012,{||"D.I.:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
	oSay2      := TSay():New( 011,089,{||"Data D.I.:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
	oSay4      := TSay():New( 025,287,{||"UF:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
	//oSay7      := TSay():New( 042,212,{||"Fabricante:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	oSay6      := TSay():New( 042,116,{||"Exportador:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	oSay8      := TSay():New( 057,010,{||"Armazenagem:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay9      := TSay():New( 057,120,{||"Conteiner:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	//oSay10     := TSay():New( 011,188,{||"DMI:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
	oSay11     := TSay():New( 070,181,{||"Impostos de Importação"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,127,008)
	oSay12     := TSay():New( 084,010,{||"Valor do II:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay13     := TSay():New( 101,010,{||"Valor do Pis/Pasep:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay14     := TSay():New( 118,010,{||"Valor do Cofins:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)//084,139
	oSay15     := TSay():New( 135,010,{||"SISCOMEX:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)	//101,139
	oSay16     := TSay():New( 084,139,{||"AFRM:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008) //118,010
	oSay19     := TSay():New( 101,139,{||"Base PIS:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
	oSay18     := TSay():New( 118,139,{||"B. Cofins:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008) // Base Cofins
	oSay17     := TSay():New( 135,139,{||"Outros:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008) //118,139
	oSay20     := TSay():New( 151,010,{||"Base II:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008) //118,139	
	// PIs/COFINS
	
	//oSay16     := TSay():New( 118,010,{||"Base PIS:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
	//oSay17     := TSay():New( 118,139,{||"Base Cofins:"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
	
	// Gets da oDlg1
	
	@ 009,025 MSGET oGET1 VAR cDi OF oPanel1  PIXEL SIZE 060,008 VALID !EMPTY(cDi)// Num. da D.I.
	@ 009,124 MSGET oGET2 VAR dDTDI OF oPanel1  PIXEL SIZE 060,008 VALID !EMPTY(dDTDI)// Data da D.I.
	//@ 09,204 MSGET oGET3 VAR cDMI OF oPanel1  PIXEL SIZE 060,008
	@ 024,052 MSGET oGET4 VAR cLocDesemb OF oPanel1  PIXEL SIZE 232,008 VALID !EMPTY(cLocDesemb)// Local de Desembarque
    @ 024,301 MSGET oGET5 VAR cUF OF oPanel1 PIXEL SIZE 030,002 VALID !EMPTY(cUF)
//	oGet5 := TComboBox():New( 024,301,{|u| If(PCount()>0,cUF:=u,cUF)},aUF,024,010,oPanel1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cUF ) // UF de Desembarque
	@ 040,052 MSGET oGET6 VAR dDtDesemb OF oPanel1  PIXEL SIZE 060,008 // Data de Desembarque
	@ 040,149 MSGET oGET7 VAR cFornece F3 "SA2" OF oPanel1  PIXEL SIZE 060,008 VALID !EMPTY(cFornece)// Fornecedor
	//@ 40,244 MSGET oGET8 VAR cFabric F3 "SA2" OF oPanel1  PIXEL SIZE 060,008
	@ 055,052 MSGET oGET9 VAR nValcap OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Capatazia
	@ 055,150 MSGET oGET10 VAR cConteiner OF oPanel1  PIXEL SIZE 060,008 // Conteiner
	@ 082,061 MSGET oGET11 VAR nValII OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Valor do Imposto de Importacao
	@ 099,061 MSGET oGET12 VAR nVLPIS OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Valor do Pis
	@ 118,061 MSGET oGET13 VAR nValCOF OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Valor do Cofins @ 82,184
	@ 134,061 MSGET oGET14 VAR nDespAC OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Valor Siscomex
	@ 083,184 MSGET oGET15 VAR nSeguro OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Valor AFRM @ 118,061
	@ 100,184 MSGET oGET16 VAR nBPIS OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Base PIS @ 118,061
	@ 118,184 MSGET oGET17 VAR nBCOF OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Base Cofins @ 118,061
	@ 134,184 MSGET oGET18 VAR nOutros OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Outras Despesas
//NOVEL - TEMPORARIO DEVE SER REMOVIDO APOS ATUALIZACAO
	@ 150,061 MSGET oGET19 VAR nTBVbcII OF oPanel1  PIXEL SIZE 060,008 PICTURE "@E 99,999,999.99" // Base II	
	// Botoes da oDlg1
	
	oSBtn1     := SButton():New( 067,268,1,{||TECIMP()},oPanel1,,"", )
	oSBtn2     := SButton():New( 067,308,2,{||oDlg1:End()},oPanel1,,"", )
	
	oDlg1:Activate(,,,.T.)
Else        
// Adicionado por Jefferson Moreira em 20/07/2011.
// Apresentar tela de insercao de mensagem para nota fiscal de entrada.
If SF1->F1_FORMUL = "S"
		DbSelectArea("SA2")
		SA2->( DbSetOrder(1) )
		SA2->( DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA) )
		cNome	:= SA2->A2_NOME
		
	Else
		DbSelectArea("SA1")
		SA1->( DbSetOrder(1) )
		SA1->( DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA) )
		cNome	:= SA1->A1_NOME
	Endif
	
	//--Se Necessario Alterar as Informacoes Abaixo
	@ 150,10 To 420,500 Dialog JanelaNF Title "Digite as Informacoes Necessarias"
	@ 005,005 Say "Nota Fiscal: "		 + SF1->F1_DOC		Size 80,10 PIXEL OF JanelaNF
	@ 005,70 Say "Cliente/Fornecedor: " + cNome         	Size 120,10 PIXEL OF JanelaNF
	@ 020,005 Say "Mensagem Nota: " SIZE 40,10 PIXEL OF JanelaNF
	@ 030,005 GET oMemo VAR cMenNota MEMO SIZE 150,100 PIXEL OF JanelaNF
	@ 090,180 BmpButton Type 1 Action Close(JanelaNF)
	Activate Dialog JanelaNF Centered
	
	
	DbSelectArea("SF1")
	If !Eof()
		RecLock("SF1",.F.)
		
		// JEFFERSON - ADICIONADA GRAVACAO DO MENSAGEM NO CAMPO CUSTOMIZADO
		
		SF1->F1_NVIMPOB	:=	cMenNota
		
		MsUnLock()
	EndIf
	
ENDIF
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TECIMP()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TECIMP()
cString := "*"+ALLTRIM(Cdi) + "*" + DTOS(dDtDi) + "*" //+ ALLTRIM(cDMI) + "*"
cString += ALLTRIM(cLocDesemb) + "*" + DTOS(dDtDesemb) + "*" + ALLTRIM(cFornece) + "*"
cString += /*ALLTRIM(cFabric) + "*"  +*/ ALLTRIM(STR(nValcap,14,2)) + "*" + IIF(!EMPTY(cConteiner),ALLTRIM(cConteiner),"CONTEINER") + "*"
cString += Alltrim(cUF)+"*"+Alltrim(STR(nVALII,14,2))+"*"+Alltrim(STR(nVLPIS,14,2))+"*"
cString += Alltrim(STR(nVALCOF,14,2))+"*"+Alltrim(STR(nDespAC,14,2))+"*"+Alltrim(STR(nSeguro,14,2))+"*"
cString += Alltrim(STR(nOutros,14,2))+"*"

RECLOCK("SF1",.F.)
Replace SF1->F1_NVIMPOB With cString
REPLACE SF1->F1_BASIMP5 WITH nBCOF
REPLACE SF1->F1_BASIMP6 WITH nBPIS
REPLACE SF1->F1_VALIMP5 WITH nVALCOF
REPLACE SF1->F1_VALIMP6 WITH nVLPIS
//NOVEL - TEMPORARIO PARA PERMITIR IMPORTACAO DEVE SER REMOVIDO NA ATUALIZACAO 
REPLACE SF1->F1_II WITH nVALII
REPLACE SF1->F1_TBVBCII WITH nTBVBCII
MSUNLOCK()

GRAVSD1()
GRAVSF3()
GRAVSFT()
GRAVCD5()


Fecha()

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ fecha()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function fecha()

Close(oDlg1)

Return

STATIC FUNCTION GRAVSD1()
DBSELECTAREA("SD1")
DBSETORDER(1)
DBGOTOP()
DBSEEK(XFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
IF FOUND()
	WHILE !EOF() .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE;
		.AND. SD1->D1_FORNECE == SF1->F1_FORNECE .AND. SD1->D1_LOJA == SF1->F1_LOJA
		RECLOCK("SD1",.F.)
		REPLACE SD1->D1_BASIMP5 WITH nBCOF
		REPLACE SD1->D1_BASIMP6 WITH nBPIS
		REPLACE SD1->D1_VALIMP5 WITH nVALCOF
		REPLACE SD1->D1_VALIMP6 WITH nVLPIS
		MSUNLOCK()
		DBSKIP()
	END
ENDIF
RETURN()

STATIC FUNCTION GRAVSF3()
DBSELECTAREA("SF3")
DBSETORDER(5)
DBGOTOP()
DBSEEK(XFILIAL("SF3")+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)
IF FOUND()
	WHILE !EOF() .AND. SF3->F3_NFISCAL == SF1->F1_DOC .AND. SF3->F3_SERIE == SF1->F1_SERIE;
		.AND. SF3->F3_CLIEFOR == SF1->F1_FORNECE .AND. SF3->F3_LOJA == SF1->F1_LOJA;
		.AND. SF3->F3_FORMUL == "S" .AND. SUBSTR(SF3->F3_CFO,1,1) <= "3" .AND. SF3->F3_ESTADO == "EX"
		RECLOCK("SD1",.F.)
		REPLACE SF3->F3_BASIMP5 WITH nBCOF
		REPLACE SF3->F3_BASIMP6 WITH nBPIS
		REPLACE SF3->F3_VALIMP5 WITH nVALCOF
		REPLACE SF3->F3_VALIMP6 WITH nVLPIS
		REPLACE SF3->F3_ALIQIMP5 WITH 1.65
		REPLACE SF3->F3_ALIQIMP6 WITH 7.6
		MSUNLOCK()
		DBSKIP()
	END
ENDIF
RETURN()           

STATIC FUNCTION GRAVSFT()
DBSELECTAREA("SFT")
DBSETORDER(5)
DBGOTOP()
DBSEEK(XFILIAL("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)
IF FOUND()
	WHILE !EOF() .AND. SFT->FT_NFISCAL == SF1->F1_DOC .AND. SFT->FT_SERIE == SF1->F1_SERIE;
		.AND. SFT->FT_CLIEFOR == SF1->F1_FORNECE .AND. SFT->FT_LOJA == SF1->F1_LOJA;
		.AND. SFT->FT_TPMOV == "E" .AND. SFT->FT_ESTADO == "EX"
		RECLOCK("SD1",.T.)
		REPLACE SFT->FT_BASECOF WITH nBCOF
		REPLACE SF3->F3_BASEPIS WITH nBPIS
		REPLACE SF3->F3_VALCOF WITH nVALCOF
		REPLACE SF3->F3_VALPIS WITH nVLPIS
		REPLACE SF3->F3_ALIQCOF WITH 1.65
		REPLACE SF3->F3_ALIQPIS WITH 7.6
		MSUNLOCK()
		DBSKIP()
	END
ENDIF
RETURN()

STATIC FUNCTION GRAVCD5()
DBSELECTAREA("CD5")
DBSETORDER(1)
DBGOTOP()     
DBSEEK(XFILIAL("CD5")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
If ! Found()
		RECLOCK("CD5",.T.)
		REPLACE CD5->CD5_FILIAL WITH XFILIAL("CD5")
		REPLACE CD5->CD5_DOC    WITH SF1->F1_DOC
		REPLACE CD5->CD5_SERIE  WITH SF1->F1_SERIE
		REPLACE CD5->CD5_ESPEC  WITH "SPED"
		REPLACE CD5->CD5_FORNEC WITH SF1->F1_FORNECE
		REPLACE CD5->CD5_LOJA   WITH SF1->F1_LOJA
		REPLACE CD5->CD5_TPIMP  WITH "0"
		REPLACE CD5->CD5_DOCIMP WITH ALLTRIM(Cdi)
		REPLACE CD5->CD5_BSPIS  WITH nBPIS 
		REPLACE CD5->CD5_ALPIS  WITH 1.65
		REPLACE CD5->CD5_VLPIS  WITH nVLPIS
		REPLACE CD5->CD5_BSCOF  WITH nBCOF
		REPLACE CD5->CD5_ALCOF  WITH 7.6
		REPLACE CD5->CD5_VLCOF  WITH nVALCOF
		REPLACE CD5->CD5_LOCAL WITH "0"
		REPLACE CD5->CD5_NDI   WITH ALLTRIM(Cdi)
		REPLACE CD5->CD5_DTDI  WITH dDtDI
		REPLACE CD5->CD5_LOCDES WITH cLocDesemb
		REPLACE CD5->CD5_UFDES  WITH cUF
		REPLACE CD5->CD5_DTDES  WITH dDtDesemb
		REPLACE CD5->CD5_CODEXP WITH cFornece
		REPLACE CD5->CD5_NADIC  WITH "1"
		REPLACE CD5->CD5_SQADIC WITH "1"
		REPLACE CD5->CD5_CODFAB WITH cFornece
		MSUNLOCK()   
ELSE
		RECLOCK("CD5",.F.)
		REPLACE CD5->CD5_FILIAL WITH XFILIAL("CD5")
		REPLACE CD5->CD5_DOC    WITH SF1->F1_DOC
		REPLACE CD5->CD5_SERIE  WITH SF1->F1_SERIE
		REPLACE CD5->CD5_ESPEC  WITH "SPED"
		REPLACE CD5->CD5_FORNEC WITH SF1->F1_FORNECE
		REPLACE CD5->CD5_LOJA   WITH SF1->F1_LOJA
		REPLACE CD5->CD5_TPIMP  WITH "0"
		REPLACE CD5->CD5_DOCIMP WITH ALLTRIM(Cdi)
		REPLACE CD5->CD5_BSPIS  WITH nBPIS 
		REPLACE CD5->CD5_ALPIS  WITH 1.65
		REPLACE CD5->CD5_VLPIS  WITH nVLPIS
		REPLACE CD5->CD5_BSCOF  WITH nBCOF
		REPLACE CD5->CD5_ALCOF  WITH 7.6
		REPLACE CD5->CD5_VLCOF  WITH nVALCOF
		REPLACE CD5->CD5_LOCAL WITH "0"
		REPLACE CD5->CD5_NDI   WITH ALLTRIM(Cdi)
		REPLACE CD5->CD5_DTDI  WITH dDtDI
		REPLACE CD5->CD5_LOCDES WITH cLocDesemb
		REPLACE CD5->CD5_UFDES  WITH cUF
		REPLACE CD5->CD5_DTDES  WITH dDtDesemb
		REPLACE CD5->CD5_CODEXP WITH cFornece
		REPLACE CD5->CD5_NADIC  WITH "1"
		REPLACE CD5->CD5_SQADIC WITH "1"
		REPLACE CD5->CD5_CODFAB WITH cFornece
		MSUNLOCK()
		
		
ENDIF
RETURN()
