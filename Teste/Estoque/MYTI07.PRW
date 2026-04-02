#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYTI07   º Autor ³ Newton Reca Alves  º Data ³  25/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importa de arquivo texto                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MYTI07()

Local nCont   := 0
LOCAL nHdl:= nHdlA := 0
Local nX
Local nTamFile, nTamLin, cBuffer, nBtLidos
Local lExiste := .T.
Local lHabil  := .F.
Private nHdl  := 0
Private cEOL  := "CHR(8)"
//RPCSetType( 3 )
//RpcSetEnv ( "01", "01","", "","","", {"SB7"} ) 


/*
If Empty(cEOL)
cEOL := CHR(8)
Else
cEOL := Trim(cEOL)
cEOL := &cEOL
Endif
*/

//+---------------------------------------------------------------------+
//| Abertura do arquivo texto                                           |
//+---------------------------------------------------------------------+
cArquivo:= "c:\temp\invent.csv"
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
	
	_cCodigo	:=	Substr(cLinha,1,15)
	_cLocal		:=	Substr(cLinha,17,2)
	_cDoc		:=	Substr(cLinha,20,9)
	_cData		:=	STOD(Substr(cLinha,30,8))
	_cTipo		:=	Substr(cLinha,39,2)
	_cQuant		:=	val(Substr(cLinha,42,12))
		
	//_cBanco		:=	Substr(cLinha,15,3)
	//_cAgencia	:=	Substr(cLinha,18,5)
	//_cConta		:=	Substr(cLinha,23,10)
    
    //alert(_cCodigo)
	
	DBSelectArea("SB7")
	DBSetOrder(1)
	RecLock("SB7",.T.)
	SB7->B7_FILIAL	:= "01"
	SB7->B7_COD		:= _cCodigo
	SB7->B7_LOCAL	:= _cLocal
	SB7->B7_DOC		:= _cDoc
	SB7->B7_QUANT	:= _cQuant
	SB7->B7_DATA	:= _cData
	SB7->B7_TIPO	:= _cTipo
	//SB7->B7_DESC	:= Posicione("SB1",1,xFilial("SB1")+_cCodigo,"B1_DESC")
	MsUnLock()    
    
	FT_FSKIP()
	nCont++
EndDo

FT_FUSE()
fClose(nHdl )

Return
