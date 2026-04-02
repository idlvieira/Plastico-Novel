#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 01/08/03

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MYFIS02  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o arquivo de Notas Fiscais para manutenção de dados  ³±±
±±³          ³ Adicionais e Mensagens Fiscais - NF - ENTRADA               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MYFIS02


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
						{"Visualizar","AxVisual",0,2} ,;
						{"Incluir","u_ScEntInc",0,3} ,;
						{"Excluir","u_SCEntDel",0,5} ,;
						{ "Legenda","u_F010Legend" ,0,9  }}

aCores  := { { "(!Empty(F1_ZZMARCA).and.!Empty(F1_ZZPLACA))"      ,"BR_VERMELHO"  },;
{ "(Empty(F1_ZZMARCA).and.Empty(F1_ZZPLACA))"        ,"BR_VERDE"    }}



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aAC        := { "Abandona","Confirma" }
PRIVATE aPos       := {    15,  1, 70, 315 }
PRIVATE cCadastro  := OemToAnsi("Dados Adicionais Notas Fiscais Entrada")
Private nVar
dbSelectArea("SF1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mBrowse( 6, 1,22,75,"SF1",,,,,,aCores)
DbSetOrder(1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ SCENTINC ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F. de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SCENTINC()

Private aCod [8]				// Inicializa array com 8 elementos para os codigos das mensagens.
Private aMsg [8]				// Inicializa array com 8 elementos para os textos das mensagens.

aFill (aCod, space (003))		// Inicializa cada um dos 8 elementos do array com o tamanho para os codigos das mensagens.
aFill (aMsg, space (500))		// Inicializa cada um dos 8 elementos do array com o tamanho para os textos das mensagens.
_lFecha := .f.

If Inclui .and. (!Empty(F1_ZZMARCA).and.!Empty(F1_ZZPLACA))
	Alert("Ja foram digitados os Dados Adicionais dessa NF! Utilize a rotina Manut. Mensagens Fiscias!!")
	Return
Endif

If SF1->F1_FORMUL == "S"
	
	
	If SF1->F1_TIPO == "D" .OR. SF1->F1_TIPO == "B" //nf de devolucao/remessa->fornecedor
		dbSelectArea("SA1")
		dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
		_cNome := SubStr(SA1->A1_NOME,1,30)
	Else
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
		_cNome := SubStr(SA2->A2_NOME,1,30)
	EndIF
	
	_cDoc    := SF1->F1_DOC
	_cSerie  := SF1->F1_SERIE
	_cMarca  := space(10)
	_cNumero := space(15)
	_cPlaca  := space(08)
	_cEspecie:= space(10)
	_cTransp := space(6)
	_nVolume := _nPBruto := _nPLiqui := 0
//	_cUFPla	 := space(2)
//	_dDtSaida  := dDataBase
//	_cHrSaida  := Time()
	
	dbSelectArea("SF1")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se necessario alterar as informacoes abaixo                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 150,10 to 420,580 DIALOG JanelaNF TITLE OemToAnsi("Complemetacao de Dados da Nota Fiscal de Entrada")
	
	@ 012,010 SAY "NOTA FISCAL: "+SF1->F1_DOC	size 80,10
	@ 012,100 SAY "CLIENTE: "+_cNome            size 120,10
	@ 032,010 SAY "Cod. Transp.: "
	@ 032,205 SAY "Placa: "
	@ 052,010 SAY "Peso Liquido: "
	@ 052,115 SAY "Peso Bruto: "
//	@ 052,205 SAY "UFPlaca: "
	@ 072,010 SAY "Qtd: "
	@ 072,115 SAY "Especie: "
	@ 072,205 SAY "Marca: "
	@ 092,010 SAY "Numero: "
//	@ 092,010 SAY "Data Saida: "
//	@ 092,115 SAY "Hora: "
	@ 032,050 GET _cTransp  PICTURE "@!" Valid .t. F3 "SA4" size 40,10
	@ 032,230 GET _cPlaca   PICTURE "@!"                    size 40,10
	@ 052,050 GET _nPLiqui  PICTURE "@E 99,999.99"          size 40,10
	@ 052,150 GET _nPBruto  PICTURE "@E 99,999.99"          size 40,10
//	@ 052,230 GET _cUFPla   PICTURE "@!"                    size 40,10
	@ 072,050 GET _nVolume  PICTURE "@E 999"                size 40,10
	@ 072,150 GET _cEspecie                                 size 40,10
	@ 072,230 GET _cMarca                                   size 40,10
	@ 092,050 GET _cNumero	PICTURE "@!"					size 40,10
//	@ 092,050 GET _dDtSaida PICTURE "99/99/99"              size 40,10
//	@ 092,150 GET _cHrSaida PICTURE "99:99:99"              size 40,10
	
	@ 112,230 BMPBUTTON TYPE 1 ACTION Close(JanelaNF)
	ACTIVATE DIALOG JanelaNF CENTERED
	
	lSair := .T.
	
	
	RecLock("SF1",.F.)
	SF1->F1_ZZESPEC  := _cEspecie	//SF1->F1_ZZESPEC  := _cEspecie
	SF1->F1_PESOL    := _nPBruto
	SF1->F1_ZZMARCA  := If(Empty(_cMarca), ".", _cMarca)	//SF1->F1_ZZMARCA  := If(Empty(_cMarca), ".", _cMarca)
	SF1->F1_ZZNUMER  := _cNumero	//SF1->F1_ZZNUMER  := _cNumero
	SF1->F1_ZZVOLUM  := _nVolume	//SF1->F1_ZZVOLUM  := _nVolume
	SF1->F1_ZZTRANS  := _cTransp	//SF1->F1_ZZTRANS  := _cTransp
	//SF1->F1_MYPBRUT  := _nPLiqui	//SF1->F1_ZZPBRUT  := _nPLiqui
	SF1->F1_ZZPLACA  := If(Empty(_cPlaca), ".", _cPlaca)	//SF1->F1_ZZPLACA  := If(Empty(_cPlaca), ".", _cPlaca)
	SF1->F1_PLIQUI   := _nPLiqui
	SF1->F1_PBRUTO   := _nPBruto
//	SF1->F1_ZZUFPLA  := If(Empty(_cUFPla), ".", _cUFPla)
	SF1->F1_ESPECI1  := _cEspecie
	SF1->F1_VOLUME1  := _nVolume
	MsUnlock()
	
EndIf

CarregaMsg()					// Recupera as mensagens informadas no TES / Produto / Pedido.
CadMen()						// Informacao das Mensagens.

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ CADMEN   ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F. de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CadMen ()

// Declaracao de variaveis:
_lFecha := .t.
@ 127, 015 To 182, 605 Dialog oDlg1 Title OemToAnsi ("Digitacao das mensagems da Nota Fiscal de Entrada")
@ 005, 010 Get aCod [1] Picture "@!"  F3 "SM4" Valid ValidMsg ("1")
@ 005, 040 Get aCod [2] Picture "@!"  F3 "SM4" Valid ValidMsg ("2")
@ 005, 070 Get aCod [3] Picture "@!"  F3 "SM4" Valid ValidMsg ("3")
@ 005, 100 Get aCod [4] Picture "@!"  F3 "SM4" Valid ValidMsg ("4")
@ 005, 130 Get aCod [5] Picture "@!"  F3 "SM4" Valid ValidMsg ("5")
@ 005, 160 Get aCod [6] Picture "@!"  F3 "SM4" Valid ValidMsg ("6")
@ 005, 190 Get aCod [7] Picture "@!"  F3 "SM4" Valid ValidMsg ("7")
@ 005, 220 Get aCod [8] Picture "@!"  F3 "SM4" Valid ValidMsg ("8")

@ 01,260 BMPBUTTON TYPE 11 ACTION Edmen (nVar)
@ 15,260 BMPBUTTON TYPE  1 ACTION GravMen ()
Activate Dialog oDlg1

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ MSG      ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Direcionar / Edi‡Æo de Mensagens       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Alteracao feita pelo Motivo ( Descricao abaixo)            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidMsg (cVar)

nVar := Val (cVar)
lMsg := .T.
ChkMsg (nVar)

Return (lMsg)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ CHKMSG   ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Verifica‡Æo se existe a mensagem       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ChkMsg (nVar)

If !Empty (aCod [nVar])
	If Empty (Formula (aCod [nVar]))
		MsgBox ("Mensagem nao cadastrada, ou com conteudo vazio." + chr (13) + "Verifique o Cadastro de Mensagens.", "Atencao !!!", "STOP")
		lMsg := .F.
	EndIf
EndIf
Return (.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ EDMEN    ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Editar as Mensagens N.F. de Entrada    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Edmen (nVar)

If ! empty (aCod [nVar])
	
	if empty (aMsg [nVar])
		cCod  := aCod [nVar]
		cMsg  := Formula (cCod) + Space (500 - Len (Formula (cCod)))
		
		cLin1 := Substr (cMsg, 001, 250)
		cLin2 := Substr (cMsg, 251, 250)
	else
		cLin1 := PadR (Substr (aMsg [nVar], 001, 250), 250, " ")
		cLin2 := PadR (Substr (aMsg [nVar], 251, 250), 250, " ")
	endif
	
	@ 200, 010 To 295,580 Dialog oDlg2 Title OemToAnsi ("Edicao de Mensagens")
	@ 010, 002 Say OemToAnsi ("Lin1")
	@ 024, 002 Say OemToAnsi ("Lin2")
	@ 010, 015 Get cLin1 Valid .T. SIZE 210, 040
	@ 024, 015 Get cLin2 Valid .T. SIZE 210, 040
	@ 010, 235 BMPBUTTON TYPE 01 ACTION MontaMsg ()
	@ 024, 235 BMPBUTTON TYPE 02 ACTION LimpaMsg ()
	Activate Dialog oDlg2
	
Else
	
	MsgStop ("Codigo da mensagem esta em branco.")
	
Endif

Return (Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ MONTAMSG ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Concatenar Mensagens.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaMsg ()

aMsg [nVar] := alltrim (cLin1) + " " + alltrim (cLin2)	//
Close (oDlg2)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ LIMPAMSG ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Limpar Mensagens.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LimpaMsg ()

aMsg [nVar] := space (500)
Close (oDlg2)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ GRAVMEN  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F. de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GravMen ()

Local _nLinGrv :=  nK := _nX := _nSeq := 0
Local _cTexto := space (500)

For nK := 1 To 8
	
	if ! empty (aCod [nK])
		_cTexto	:= Alltrim (Formula (aCod [nK]))
		
		if ! Empty (aMsg [nK])
			_cTexto	:= Alltrim (aMsg [nK])
		Endif
		
		_nLinGrv := MlCount (_cTexto, 250)
		
		dbSelectArea ("ZZX")
		
		for _nX := 1 to _nLinGrv
			_nSeq := _nSeq + 1
			dbSeek(xFilial("ZZX")+"E"+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aCod [nK])
			If !Found()
				RecLock ("ZZX", .T.)  //Inclui
				//ZZX -> ZZX_MYFILI	:= xFilial("ZZX")
				ZZX -> ZZX_FILIAL	:= xFilial("ZZX")
				ZZX -> ZZX_MYTDOC	:= "E"		// Nota Fiscal de Entrada
				ZZX -> ZZX_MYDOC	:= SF1 -> F1_DOC
				ZZX -> ZZX_MYSERI	:= SF1 -> F1_SERIE
				ZZX -> ZZX_MYCLIF	:= SF1 -> F1_FORNECE
				ZZX -> ZZX_MYLOJA	:= SF1 -> F1_LOJA
			Else
				RecLock ("ZZX", .F.) //alterar
			EndIf
			
			ZZX -> ZZX_MYSEQ	:= StrZero (_nSeq, 2)
			ZZX -> ZZX_CODMEN	:= aCod [nK]
			ZZX -> ZZX_MYTEXT	:= MemoLine (_cTexto, 250, _nX)
			
			MsUnlock ()
		Next
	Endif
Next
if _lFecha
	Close (oDlg1)
endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³CARREGAMSG³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Recuperar as mensagens informados no   ³±±
±±³            ³ TES, nos Produtos e nos Pedidos de Venda.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CarregaMsg ()

Local _nCont := 1		// Variavel para controlar o limite de mensagens a ser exibida na tela de selecao.

SD1 -> (dbSetOrder (1))                  
SD1 -> (dbSeek (xFilial ("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))

While ! eof () .and. SD1 -> D1_FILIAL  == SF1 -> F1_FILIAL ;
			   .and. SD1 -> D1_DOC     == SF1 -> F1_DOC;
			   .and. SD1 -> D1_SERIE   == SF1 -> F1_SERIE;
			   .and. SD1 -> D1_FORNECE == SF1 -> F1_FORNECE;				
			   .and. SD1 -> D1_LOJA    == SF1 -> F1_LOJA
				
	SB1 -> (dbSeek (xFilial ("SB1") + SD1 -> D1_COD))
	_nTem := aScan (aCod, SB1 -> B1_ZZMEN1)	//_nTem := aScan (aCod, SB1 -> B1_ZZMEN1)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SB1 -> B1_ZZMEN1
			_nCont := _nCont + 1
		endif
	endif

	SF4 -> (dbSeek (xFilial ("SF4") + SD1 -> D1_TES))
	_nTem := aScan (aCod, SF4 -> F4_ZZMEN1)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4 -> F4_ZZMEN1
			_nCont := _nCont + 1
		endif
	endif

	_nTem := aScan (aCod, SF4 -> F4_ZZMEN2)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4 -> F4_ZZMEN2
			_nCont := _nCont + 1
		endif
	endif

	_nTem := aScan (aCod, SF4 -> F4_ZZMEN3)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4 -> F4_ZZMEN3
			_nCont := _nCont + 1
		endif
	endif

	SD1 -> (dbSkip ())
Enddo

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SCENTDEL  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao opcao  exclusÆo de NF - Deleta Mensagens NF (ZZX)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Sigafat                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SCENTDEL()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva areas abertas                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea := _aAreaZZX := {}

_aArea    := GetArea()
_aAreaZZX := ZZX -> (GetArea ())

dbSelectArea("ZZX")
dbSetOrder(1)
dbSeek (xFilial ("ZZX") + "E" + SF1 -> F1_DOC + SF1 -> F1_SERIE + SF1 -> F1_FORNECE + SF1 -> F1_LOJA)
If Found()
	//While !eof() .and. ZZX -> ZZX_MYFILI  == xFilial("ZZX");
	While !eof() .and. ZZX -> ZZX_FILIAL  == xFilial("ZZX");
		.and. ZZX -> ZZX_MYTDOC == "E";
		.and. ZZX -> ZZX_MYDOC == SF1 -> F1_DOC    ;
		.and. ZZX -> ZZX_MYSERI == SF1 -> F1_SERIE  ;
		.and. ZZX -> ZZX_MYCLIF == SF1 -> F1_FORNECE ;
		.and. ZZX -> ZZX_MYLOJA == SF1 -> F1_LOJA
		RecLock("ZZX",.F.)
		dbDelete()
		MsUnlock()
		dbSkip()
	End
EndIf

RecLock("SF1",.F.)
SF1->F1_ZZTRANS := space(06)
SF1->F1_PESOL  := 0
SF1->F1_PBRUTO := 0
SF1->F1_ZZVOLUM := 0
SF1->F1_ZZESPEC := space(10)
SF1->F1_ZZMARCA := space(20)
SF1->F1_ZZPLACA := space(10)
SF1->F1_PLIQUI  := 0
SF1->F1_ZZUFPLA := space(02)
//SF1->F1_PBRUTO  := 0
SF1->F1_ESPECI1 := space(10)
SF1->F1_VOLUME1 := 0
//SF1->F1_ZZDTSAI := ctod("  /  /  ")
//SF1->F1_ZZHRSAI := space(08)
MsUnlock()    

//Mostra mensagem de conclusao da Exclusao somente Informativa!
MsgStop("Dados Adicionais/Mensagens Foram Excluidas com Sucesso!!","Informacao","INFO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Areas Abertas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea (_aAreaZZX)
RestArea (_aArea)

Return