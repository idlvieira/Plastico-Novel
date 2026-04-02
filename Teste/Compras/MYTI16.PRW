#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYTI16   º Autor ³ Newton Reca Alves  º Data ³  25/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ BLOQUEIA FORNECEDOR INFORMADO NO TXT DO USUARIO            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MYTI16()

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
cArquivo:= "c:\temp\BLDLFORNECEDOR.TXT"
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
	
	_cCodigo	:=	Substr(cLinha,1,6) 
	_cLoja      :=  Substr(cLinha,8,2)
	_cBloq		:=	Substr(cLinha,11,1)

	DBSelectArea("SA2")
	DBSetOrder(1)
	If DBSeek(xFilial("SA2")+_cCodigo+_cLoja)
		RecLock("SA2",.F.)
		SA2->A2_MSBLQL	:= _cBloq
		MsUnLock()
	EndIf    

	FT_FSKIP()
	nCont++
EndDo

FT_FUSE()
fClose(nHdl )

ALERT("Atualizado com sucesso")

Return
