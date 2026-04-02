/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYPON01   บAutor Rui Ronaldo Scandiuzziบ Data ณ  04/01/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para realizar backup dos arquivos do ponto        บฑฑ
ฑฑบ          ณ eletronico                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

USER FUNCTION MYPON01()

LOCAL MSG := "BACKUP DOS ARQUIVOS DO PONTO ELETRONICO"+CHR(13)
      MSG += " "+CHR(13)
      MSG += "O BACKUP SERม FEITO NA PASTA \BACKUP\"+CHR(13)
      MSG += "COM A DATA E HORA DA EXECUวรO NO NOME"+CHR(13)
      MSG += "DA PASTA CRIADA.                     "+CHR(13)
      MSG += "CONFIRMA A EXECUCAO DO BACKUP ?"+CHR(10)+CHR(13)

IF MSGBOX(MSG,"ATENCAO","YESNO")
   PROCESSA({|| BKPONTO()})
ENDIF

RETURN(.T.)

STATIC FUNCTION BKPONTO()

ARQUIVOS := {"RFA","RFB","RFE","RFF","RFG","RFH","RFK","SP0","SP5","SP8","SP9","SPA","SPB","SPC","SPF","SPG","SPH","SPI","SPJ","SPK","SPL","SPN","SPO","SR6"}

PROCREGUA(LEN(ARQUIVOS))

SUFIXO := "BK"
SUFIXO += DTOS(DDATABASE)
MHORA := TIME()
FOR I := 1 TO LEN(MHORA)
	IF SUBSTR(MHORA,I,1) <> ":"
		SUFIXO += SUBSTR(MHORA,I,1)
	ENDIF	
NEXT
CPASTA := "\BACKUP\"+SUFIXO
IF MakeDir(CPASTA) == 0
	PROCREGUA(LEN(ARQUIVOS))
	FOR I := 1 TO LEN(ARQUIVOS)
		DBSELECTAREA(ARQUIVOS[I])
	    INCPROC(ARQUIVOS[I])
	    CCAMINHO := CPASTA+"\"+RETSQLNAME(ARQUIVOS[I])
	    COPY TO &(CCAMINHO)
	NEXT             
ELSE
	ALERT("Erro na criacao do diretorio !")
ENDIF

RETURN(.T.)