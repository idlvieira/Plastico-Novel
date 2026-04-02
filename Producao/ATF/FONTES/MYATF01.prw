//#include "Protheus.ch"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MYATF01 ³ Autor ³                       ³ Data ³ 12/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Este programa gera backup dos arquivos do Ativo.           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Adaptado para MYERS em 10/07/06 por Donizete/Microsiga Cps.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MYATF01()

// Declaração de variáveis.
Public _cNomArq		:= ""
Public _cArqDest1	:= ""
Public _cData		:= DTOS(ddatabase) + "-"
Public _aEmpresa	:= {}
Public _cPathDest	:= "\BkpAtivo\"
Public _lYesNo		:= .F.
Public _lExistArq	:= .F.  
Public _lOk			:= .F.
Public _cEmpFil		:= SM0->M0_CODIGO+"/"+SM0->M0_NOME

_lYesNo := MsgBox("Confirma backup do ativo da empresa "+_cEmpFil+"?","Backup","YESNO")
If _lYesNo	== .F.
	Return
EndIf

// Executa o processo principal.
Processa( {|| RunBkp() },"Aguarde. Gerando backup dos arquivos..." )

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL                                                    ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function RunBkp()

// Variaveis Locais
Local i	:= 00

// Inicializa empresas a serem processadas.
aadd(_aEmpresa,SM0->M0_CODIGO)

// Define o número de arquivos a serem processados.
ProcRegua(15)

// Processa o backup.
For i=1 to len(_aEmpresa)
	
	//.. Backup das tabelas do Ativo Fixo ..//
	Backup("SN1")
	If _lOk
		Backup("SN2")
		Backup("SN3")
		Backup("SN4")
		Backup("SN5")
		Backup("SN6")
		Backup("SN7")
		Backup("SN8")
		Backup("SN9")
		Backup("SNA")
		Backup("SNB")
		Backup("SNC")
		Backup("SND")
		Backup("SNE")
		Backup("SNG")

		MsgBox("Backup concluido. Arquivos gravados na raiz do server em "+_cPathDest+".")

	EndIf
	
Next

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE BACKUP                                                    ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function Backup(_cTabela)

// Incrementa a régua.
IncProc("Processando tabela " + _cTabela)

// Verifica se o diretório de backup existe.
_cPathDest := Alltrim(_cPathDest)
If !File(Left(_cPathDest,Len(_cPathDest)-1))
	Alert("A Pasta [ " + _cPathDest + " ] não existe no servidor. Procure o administrador e peça para criá-la.")
	Return
EndIf

// Carrega o alias. Necessário para que o SIGA crie a tabela caso não exista.
dbSelectArea(_cTabela)

// Faz o backup.
_cNomArq	:=_cTabela-_aEmpresa[i]-"0"
_cArqDest1	:=_cPathDest+_cData+_cNomArq+".dbf"

// Verifica se já existe arquivo.
If File(_cArqDest1)
	_lExistArq := .T.
EndIf

_lYesNo := .T.
If _lExistArq .And. !_lOk
	_lYesNo := MsgBox("Backup efetuado anteriormente. Sobrepor?","Sobrescrever?","YESNO")
EndIf

If !_lYesNo 
	_lOk := .F.
Else
	_lOk := .T.
EndIf

If !_lExistArq .Or. _lOk
	Use &_cNomArq Alias _cNomArq SHARED NEW VIA "TOPCONN"
	copy to &_cArqDest1
	( _cNomArq )->( dbCloseArea() )
Else
	Alert("Backup não efetuado!")
EndIf

Return
