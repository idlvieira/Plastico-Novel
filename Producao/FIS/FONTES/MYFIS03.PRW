#include "rwmake.ch"       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MYFIS03  ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o arquivo de Notas Fiscais para manutenção de dados  ³±±
±±³          ³ Adicionais e Mensagens Fiscais - NF SAIDA                  ³±±
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

User Function MYFIS03


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
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","u_ScInclui",0,3} ,;
{"Excluir","u_SCDeleta",0,5} ,;
{ "Legenda","u_F010Legend" ,0,9  }}

aCores  := { { "(!Empty(F2_ZZMARCA).and.!Empty(F2_ZZPLACA))"      ,"BR_VERMELHO"  },;
{ "(Empty(F2_ZZMARCA).and.Empty(F2_ZZPLACA))"        ,"BR_VERDE"    }}



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aAC        := { "Abandona","Confirma" }
PRIVATE aPos       := {    15,  1, 70, 315 }
PRIVATE cCadastro  := OemToAnsi("Notas Fiscais Saida")
Private nVar
dbSelectArea("SF2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mBrowse( 6, 1,22,75,"SF2",,,,,,aCores)
DbSetOrder(1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ SCINCLUI ³ Autor ³ Fabricio M Viei       ³ Data ³ 23/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SCINCLUI()

Private aCod [8]				// Inicializa array com 8 elementos para os codigos das mensagens.
Private aMsg [8]				// Inicializa array com 8 elementos para os textos das mensagens.
Private _cNome := ""

aFill (aCod, space (003))		// Inicializa cada um dos 8 elementos do array com o tamanho para os codigos das mensagens.
aFill (aMsg, space (500))		// Inicializa cada um dos 8 elementos do array com o tamanho para os textos das mensagens.
_lFecha := .f.

If Inclui .and. (!Empty(F2_ZZMARCA).and.!Empty(F2_ZZPLACA))
	Alert("Ja foram digitados os Dados Adicionais dessa NF! Utilize a rotina Manut. Mensagens Fiscias!!")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona SD2 - itens da nota fiscal                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cKey := xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE
dbSelectArea("SD2")
dbSetOrder(3)                 //filial,doc,serie,cliente,loja,cod
dbSeek(_cKey)
_nRecD2 := Recno()

dbSelectArea("SF4")
dbSeek(xFilial("SF4")+SD2->D2_TES)

dbSelectArea("SC5")
dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)

If SF2->F2_TIPO == "D" .OR. SF2->F2_TIPO == "B" //nf de devolucao/remessa->fornecedor
	dbSelectArea("SA2")
	dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cNome := SubStr(SA2->A2_NOME,1,30)
Else
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cNome := SubStr(SA1->A1_NOME,1,30)
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula Peso Liquido da Nota de Saida a partir do peso cadastrado no produto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nPLiqui := SC5->C5_PESOL
If _nPLiqui == 0
	dbSelectArea("SD2")
	While !Eof() .and. D2_FILIAL == SF2->F2_FILIAL .and. D2_DOC == SF2->F2_DOC .and.;
		D2_SERIE == SF2->F2_SERIE
		_nPLiqui := _nPLiqui + (D2_PESO*D2_QUANT)
		dbSelectArea("SD2")
		dbSkip()
	EndDo
EndIf

dbSelectArea("SD2")
Go _nRecD2


dbSelectArea("SF2")

_cDoc      := SF2->F2_DOC
_cSerie    := SF2->F2_SERIE
_nQtd      := SF2->F2_VOLUME1
_nPLiqui   := _nPLiqui
_nPBruto   := _nPLiqui
_cTransp   := SC5->C5_TRANSP
_cCodRed   := SC5->C5_REDESP
_cEspec    := SC5->C5_ESPECI1
_cVeic     := SC5->C5_VEICULO //SS 20170824

_cNomeRed  := space(30)
_cPlaca    := SF2->F2_ZZPLACA
//_cUFPla    := SF2->F2_ZZUFPLA
_cMarca    := SF2->F2_ZZMARCA
_cNumero   := SF2->F2_ZZNUMER
_cMens     := ""
_cMens1    := space(03)
_cMens2    := space(03)
_dDtSaida  := dDataBase
_cHrSaida  := Time()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se necessario alterar as informacoes abaixo                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 150,10 to 420,580 DIALOG JanelaNF TITLE "Digite as Informacaes Necessarias"

@ 012,010 SAY "NOTA FISCAL: "+SF2->F2_DOC	size 80,10
@ 012,100 SAY "CLIENTE: "+_cNome			size 120,10
@ 032,010 SAY "Cod. Transp.: "
@ 032,115 SAY "Redesp: "
@ 032,205 SAY "Placa: "
@ 052,010 SAY "Peso Liquido: "
@ 052,115 SAY "Peso Bruto: "
@ 052,205 SAY "Veiculo: "
@ 072,010 SAY "Qtd: "
@ 072,115 SAY "Especie: "
@ 072,205 SAY "Marca: "
@ 092,010 SAY "Numero: "
@ 092,115 SAY "Data Saida: "
@ 092,205 SAY "Hora: "
@ 032,050 GET _cTransp  PICTURE "@!" Valid .t. F3 "SA4"			size 40,10
@ 032,150 GET _cCodRed  PICTURE "@!" Valid .t. F3 "SA4"			size 40,10
@ 032,230 GET _cPlaca   PICTURE "@!"                    		size 40,10
@ 052,050 GET _nPLiqui  PICTURE "@E 99,999.99"          		size 40,10
@ 052,150 GET _nPBruto  PICTURE "@E 99,999.99"          		size 40,10
@ 052,230 GET _cVeic    PICTURE "@!" Valid .t. F3 "DA3"         size 40,10
@ 072,050 GET _nQtd     PICTURE PesqPict("SF2","F2_VOLUME1")	size 40,10
@ 072,150 GET _cEspec                                   		size 40,10
@ 072,230 GET _cMarca                                   		size 40,10
@ 092,050 GET _cNumero  PICTURE "@!"                    		size 40,10
@ 092,150 GET _dDtSaida PICTURE "99/99/99"              		size 40,10
@ 092,230 GET _cHrSaida PICTURE "99:99:99"              		size 40,10

@ 112,230 BMPBUTTON TYPE 1 ACTION Close(JanelaNF)
ACTIVATE DIALOG JanelaNF CENTERED

lSair := .T.

dbSelectArea("SC5")
If !Eof()
	RecLock("SC5",.f.)
	SC5->C5_TRANSP  := _cTransp
	SC5->C5_REDESP  := _cCodRed
	SC5->C5_ESPECI1 := _cEspec
	SC5->C5_VEICULO := _cVeic
	
	MsUnLock()
EndIf

dbSelectArea("SF2")
RecLock("SF2",.f.)
SF2->F2_TRANSP  := _cTransp
SF2->F2_REDESP  := _cCodRed
SF2->F2_PLIQUI  := _nPLiqui
SF2->F2_PBRUTO  := _nPBruto
SF2->F2_VOLUME1 := _nQtd
SF2->F2_ESPECI1 := _cEspec
SF2->F2_ZZMARCA := If(Empty(_cMarca), ".", _cMarca)
SF2->F2_ZZNUMER := _cNumero
SF2->F2_ZZPLACA := If(Empty(_cPlaca), ".", _cPlaca)
//SF2->F2_ZZUFPLA := If(Empty(_cUFPla), ".", _cUFPla)
SF2->F2_ZZDTSAI := _dDtSaida
SF2->F2_ZZHRSAI := _cHrSaida
MsUnLock()

CarregaMsg()					// Recupera as mensagens informadas no TES / Produto / Pedido.
CadMen()						// Informacao das Mensagens.

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo      ³ CADMEN   ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F. de          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ AP7                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CadMen ()

// Declaracao de variaveis:
_lFecha := .t.
@ 127, 015 To 182, 605 Dialog oDlg1 Title OemToAnsi ("Digitacao das mensagems da Nota Fiscal")
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
±±³Fun‡Æo      ³ MSG      ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
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
±±³Fun‡Æo      ³ CHKMSG   ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
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
±±³Fun‡Æo      ³ EDMEN    ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Editar as Mensagens N.F.               ³±±
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
±±³Fun‡Æo      ³ MONTAMSG ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
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
±±³Fun‡Æo      ³ LIMPAMSG ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
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
±±³Fun‡Æo      ³ GRAVMEN  ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo   ³ Funcao Utilizado p/ Grava‡Æo de Mensagens N.F.             ³±±
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
			dbSeek(xFilial("ZZX")+"S"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+aCod [nK])
			If !Found()
				RecLock ("ZZX", .T.)  //Inclui
				ZZX -> ZZX_FILIAL	:= xFilial("ZZX")
				ZZX -> ZZX_MYTDOC	:= "S"		// Nota Fiscal de Saida
				ZZX -> ZZX_MYDOC	:= SF2 -> F2_DOC
				ZZX -> ZZX_MYSERI	:= SF2 -> F2_SERIE
				ZZX -> ZZX_MYCLIF	:= SF2 -> F2_CLIENTE
				ZZX -> ZZX_MYLOJA	:= SF2 -> F2_LOJA
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
±±³Fun‡Æo      ³CARREGAMSG³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
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
Local _aNFOri := {}
Local _cResto := _cVlr := _cTotal := ""
Local _nReg := _nResto := 0
Local _cEmissao := ""
Local _cChave := space(11)

If Inclui
	SC5 -> (dbSetOrder (1))
	
	dbSelectArea("SD2")
	dbSetOrder (3)
	dbSeek (xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	While ! eof () .and. SD2->D2_FILIAL == SF2->F2_FILIAL .and.;
		SD2->D2_DOC    == SF2->F2_DOC .and.;
		SD2->D2_SERIE  == SF2->F2_SERIE .and.;
		SD2->D2_CLIENTE == SF2->F2_CLIENTE .and.;
		SD2->D2_LOJA   == SF2->F2_LOJA
		
		// Recupera Mensagem Padrao no Pedido de Venda.
		SC5 -> (dbSeek (xFilial ("SC5") + SD2 -> D2_PEDIDO))
		_nTem := aScan (aCod, SC5 -> C5_MENPAD)
		if _nTem == 0
			if _nCont <= 8
				aCod [_nCont] := SC5 -> C5_MENPAD
				_nCont := _nCont + 1
			endif
		endif
		
		// Recupera Mensagem Padrao no Produto.
		SB1 -> (dbSeek (xFilial ("SB1") + SD2 -> D2_COD))
		_nTem := aScan (aCod, SB1 -> B1_ZZMEN1)
		if _nTem == 0
			if _nCont <= 8
				aCod [_nCont] := SB1 -> B1_ZZMEN1
				_nCont := _nCont + 1
			endif
		endif
		
		// Recupera Mensagem Padrao no TES (3 mensagens).
		SF4 -> (dbSeek (xFilial ("SF4") + SD2 -> D2_TES))
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
		
		
		If !Empty(SD2->D2_NFORI)
			_cQtdLib := _cUnid := _cSCMen := ""
			
			//Posiciona no SC6 - Pedido Venda para buscar o conteudo do campo
			//C6_RKMEN (nome produto+num cliente PS), especifico do Cliente - RMK
			dbSelectArea("SC6")
			dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
			If Found()
				_cUnid   := SC6->C6_UM
				_cSCMen := ""  //espaco para mensagem do item ou complemento da descricao
			EndIf
			
			//Posiciona no SC9 - Pedido Liberados para verificar a Qtd liberada
			//do Produto, que devera ser informada na mensagem de retorno de benefic.
			
			dbSelectArea("SC9")
			dbSeek(xFilial("SC9")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
			If Found()
				While !eof() .and. SC9->C9_PEDIDO==SD2->D2_PEDIDO ;
					.and. SC9->C9_ITEM == SD2->D2_ITEMPV
					
					If SC9->C9_NFISCAL+SC9->C9_SERIENF == SD2->D2_DOC+SD2->D2_SERIE
						_cQtdLib := Transform(SC9->C9_QTDLIB,'@E 99,999.99')
					EndIf
					
					dbSkip()
				End
			EndIf
			
			//Posiciona no SF1/SD1 - NF - dados da nota fiscal original
			dbSelectArea("SF1")
			dbSeek(xFilial("SF1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA)
			
			_cTotal   := Transform(SD2->D2_TOTAL,"@E 999,999,999.99")
			_cEmissao := SubStr(DtoS(SF1->F1_EMISSAO),7,2)+'/'+;
			SubStr(DtoS(SF1->F1_EMISSAO),5,2)+'/'+;
			SubStr(DtoS(SF1->F1_EMISSAO),1,4)
			
			//Adiciona em Array dados referente a NF
			_cChave := SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_ITEMORI
			nP  := ASCAN(_aNFori,{|X|Substr(X[1],1,11)==_cChave} )
			
			If nP == 0
				AADD(_aNFOri,{ SD2->D2_NFORI   ,;            //1a. NF Original
				SD2->D2_SERIORI ,;            //2a. Serie NF Original
				SD2->D2_ITEMORI ,;            //3a. Item NF Original
				_cTotal         ,;            //4a. Total
				_cEmissao       ,;            //5a. Data Emissao NF Original
				_cSCMen        ,;             //6a. Mensagem - SC6
				_cQtdLib        ,;            //7a. Qtd Liberada - SC9
				_cUnid  } )                   //8a. Unidade Medida - SC6
			EndIf
			
			dbSelectArea("SD2")
			
		EndIf
		SD2 -> (dbSkip ())
	Enddo
	
	If Len(_aNFori) >= 1
		
		For _nI := 1 To LEn (_aNFori)
			_cMens := _cMens+If(!Empty(_aNFori[_nI,6]),_aNFori[_nI,6]+" - ","")+;
			"referente s/ NF "+_aNFori[_nI,1]+" de "+_aNFori[_nI,5]+;
			" no valor de R$"+_aNFori[_nI,4]+" ("+_aNFori[_nI,7]+;
			" "+_aNFori[_nI,8]+"), "
			
		Next
	EndIf
	
EndIf
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SCDELETA  ³ Autor ³ Fabricio M Viei       ³ Data ³23/12/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao opcao  exclusÆo de NF - Deleta Mensagens NF (ZZX)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Sigafat                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SCDELETA()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva areas abertas                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea := _aAreaZZX := {}

_aArea    := GetArea()
_aAreaZZX := ZZX -> (GetArea ())

dbSelectArea("ZZX")
dbSetOrder(1)
dbSeek (xFilial ("ZZX") + "S" + SF2 -> F2_DOC + SF2 -> F2_SERIE + SF2 -> F2_CLIENTE + SF2 -> F2_LOJA)
If Found()
	While !eof() .and. ZZX -> ZZX_FILIAL  == xFilial("ZZX");
		.and. ZZX -> ZZX_MYTDOC == "S";
		.and. ZZX -> ZZX_MYDOC == SF2 -> F2_DOC    ;
		.and. ZZX -> ZZX_MYSERI == SF2 -> F2_SERIE  ;
		.and. ZZX -> ZZX_MYCLIF == SF2 -> F2_CLIENTE ;
		.and. ZZX -> ZZX_MYLOJA == SF2 -> F2_LOJA
		RecLock("ZZX",.F.)
		dbDelete()
		MsUnlock()
		dbSkip()
	End
EndIf

RecLock("SF2",.F.)
SF2->F2_TRANSP  := space(06)
SF2->F2_REDESP  := space(06)
SF2->F2_PLIQUI  := 0
SF2->F2_PBRUTO  := 0
SF2->F2_VOLUME1 := 0
SF2->F2_ESPECI1 := space(10)
SF2->F2_ZZMARCA := space(20)
SF2->F2_ZZPLACA := space(10)
//SF2->F2_ZZUFPLA := space(02)
SF2->F2_ZZDTSAI := ctod("  /  /  ")
SF2->F2_ZZHRSAI := space(08)
MsUnlock()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Areas Abertas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea (_aAreaZZX)
RestArea (_aArea)

Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³F010Legend³Autor  ³ Fabricio M Viei       ³ Data ³23/12/05   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Demonstra a legenda das cores da mbrowse                     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina monta uma dialog com a descricao das cores da    ³±±
±±³          ³Mbrowse.                                                     ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAS                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function F010Legend()
BrwLegenda(cCadastro,"Legenda",{{"BR_VERMELHO","Dados Adicionais ja Informados" },;
{"BR_VERDE"  ,"Nao Inf. Dados Adic. e Mensagens"}})

Return(.T.)