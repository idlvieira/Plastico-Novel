#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYTI21   º Autor ³ Daniel Coelho  º Data ³  26/10/16       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ALTERA DATA INICIO E FIM DE BLOQUEIO PLANO DE CONTAS DE    º±±
±±º          ³ ACORDO COM O LAYOUT DEFINIDO PELO DEPTO CONTABIL           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MYTI21()

Local nCont   := 0
LOCAL nHdl:= nHdlA := 0
Local nX
Local nTamFile, nTamLin, cBuffer, nBtLidos
Local lExiste := .T.
Local lHabil  := .F.
Private nHdl  := 0
Private cEOL  := "CHR(8)"

//+---------------------------------------------------------------------+
//| Abertura do arquivo texto                                           |
//+---------------------------------------------------------------------+
cArquivo:= "c:\temp\PLANOCONTA_DATAS.TXT"
cArqTxt := cArquivo

nHdl := fOpen(cArqTxt,0 )                                       
IF nHdl == -1
	IF FERROR()== 516
		ALERT("Feche o programa que gerou o arquivo.")
	EndIF
EndIf

//+---------------------------------------------------------------------+
//| Verifica se foi possível abrir o arquivo                            |
//+---------------------------------------------------------------------+
If nHdl == -1
	MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser aberto! Verifique os parametros.","Atencao!" )
	Return
Endif


FSEEK(nHdl,0,0 )
nTamArq:=FSEEK(nHdl,0,2 )
FSEEK(nHdl,0,0 )
fClose(nHdl)

FT_FUse(cArquivo )  //abre o arquivo
FT_FGoTop()         //posiciona na primeira linha do arquivo
//nTamLinha := AT(cEOL,cBuffer )
nTamLinha := Len(FT_FREADLN() ) //Ve o tamanho da linha
FT_FGOTOP()

//+---------------------------------------------------------------------+
//| Verifica quantas linhas tem o arquivo                               |
//+---------------------------------------------------------------------+
nLinhas := FT_FLastRec()

ProcRegua(nLinhas)

While !FT_FEOF()
	IF nCont > nLinhas
		exit
	endif
	IncProc("Lendo arquivo texto...Linha "+Alltrim(str(nCont)))
	cLinha := Alltrim(FT_FReadLn())
	nRecno := FT_FRecno() // Retorna a linha corrente
	
	_cConta		:=Substr(cLinha,1,20) 
  	_dDtInicio	:=Substr(cLinha,22,8)
	_dDtFim		:=Substr(cLinha,32,8) 
	
	DBSelectArea("CT1")
	DBSetOrder(1)
	If DBSeek(xFilial("CT1")+_cConta)
		RecLock("CT1",.F.)
	   	CT1->CT1_DTBLIN:=CTOD(_dDtInicio)
		CT1->CT1_DTBLFI:=CTOD(_dDtFim)
	    MsUnLock()
	EndIf    

	FT_FSKIP()
	nCont++
EndDo

FT_FUSE()
fClose(nHdl )

ALERT("Atualizado com sucesso")

Return