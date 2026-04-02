#include "rwmake.ch"
#include "topconn.ch"
#include "fivewin.ch"
#include "font.ch"
#include "print.ch"
#include "dll.ch"
#include "folder.ch"
#include "msobject.ch"
#include "odbc.ch"
#include "dde.ch"
#include "video.ch"
#include "vkey.ch"
#include "tree.ch"
#include "winapi.ch"
#include "fwmsgs.ch"
#include "fwmsgs.h"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MYTM01   บ Autor ณ Newton Reca Alves  บ Data ณ  27/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Orcamento de Venda em modo grafico                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function MYTM01()

If Type("oMainWnd") <> "U"
	ProcRel()
EndIf

Return

Static Function procRel()

Private	cPerg	:= "MYTM01"
CriarPerg()
Pergunte(cPerg,.T.)

//_cNumero	:= ""
//mv_par01	:= _cNumero

Public 	oFont, oFont1, oFont2, oFont3, oFont4, oBold
Public 	i 		:= 0
Public 	aCoords	:= { 700, 70, 800, 400 }
Public 	oBrush
Public 	oDlg
Public 	oPrint
Public 	nLin	:= 100
Public 	nPag	:= 1

oFont  := TFont():New("Arial",-10,10,,.F.,,,,.T.,.F.)
oFont1 := TFont():New("Arial",-10,08,,.T.,,,,,.F. )  //BOLD
oFont2 := TFont():New("Arial",-10,11,,.F.,,,,.T.,.F.)
oFont3 := TFont():New("Arial",-10,08,,.F.,,,,.T.,.F.) //BOLD
oFont4 := TFont():New("Arial",-10,08,,.F.,,,,,.F. )
oFont5 := TFont():New("Arial",-10,12,,.T.,,,,,.F. )  //BOLD
oFont6 := TFont():New("Arial",-10,08,,.T.,,,,,.F. )  //BOLD

oBrush := TBrush():New( , CLR_BLACK )
oPrint := TMSPrinter():New( "Orcamento de Venda" )


DEFINE MSDIALOG oDlg TITLE "Cotacao" FROM 0,0 TO 250,430 PIXEL

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 000, 000 BITMAP oBmp RESNAME "LOGIN" oF oDlg SIZE 30, 120 NOBORDER WHEN .F. PIXEL
@ 003, 040 SAY "Escolha uma op็ใo" FONT oBold PIXEL
@ 014, 030 TO 16 ,400 LABEL '' OF oDlg  PIXEL

@ 020, 040 BUTTON "Configurar" SIZE 40,13 PIXEL OF oDlg ACTION oPrint:Setup()
@ 020, 080 BUTTON "Perguntas"  SIZE 40,13 PIXEL OF oDlg ACTION Perguntar()
@ 020, 120 BUTTON "Visualiza"  SIZE 40,13 PIXEL OF oDlg ACTION ProcImp()
@ 020, 120 BUTTON "Imprimir"   SIZE 40,13 PIXEL OF oDlg ACTION ProcImp()


//@ 020, 160 BUTTON "Gen-JPEG"   SIZE 40,13 PIXEL OF oDlg ACTION MySaveJPEG( oPrint  )

ACTIVATE MSDIALOG oDlg CENTER



Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CxDLG    บAutor  ณ Newton Reca Alves  บ Data ณ  02/08/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Caixa de Dialogo.                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Perguntar()

Private	cPerg	:= "MYTM01"
CriarPerg()
Pergunte(cPerg,.T.)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ALCM06   บAutor  ณNewton Reca Alves   บ Data ณ  02/08/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PROCIMP()



_cStatus	:= Posicione("SUA",1,xFilial("SUA")+mv_par01,"UA_STATU2")

If _cStatus == "BLO"
	Alert("Pedido bloqueado, impressao indisponivel")
	Return
EndIf

oPrint 		:= TMSPrinter():New( "Orcamento de Venda" )

//MontaTela1()

RunPOL()



Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MontaTelaบAutor  ณ Newton Reca Alves  บ Data ณ  02/08/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o Relatorio.                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaTela1(_cFlag)


oPrint:StartPage() // Inicia uma nova pแgina
oPrint:SetPortrait()

//oPrint:Box(50,50,500,3300) //SUPERIOR TOTAL
//oPrint:Box(50,1150,500,2150) //SUPERIOR MEIO
//oPrint:Box(550,50,1900,3300) //MEIO TOTAL
//oPrint:Box(1950,50,2400,3300) //INFERIOR TOTAL


_cAno	:= AllTrim(str(year(ddatabase)))

nLin 	:= 50


oPrint:sayBitmap(nlin+100, 100, "\system\logomyers2.jpg", nlin+700,)

nLin += 100
oPrint:Say(nLin    ,1000,"RAZรO: ",oFont1)
oPrint:Say(nLin    ,1300,SM0->M0_NOMECOM,oFont)
nLin += 50
oPrint:Say(nLin    ,1000,"CNPJ: ",oFont1)
_cCGC	:= Substr(SM0->M0_CGC,1,2)+"."+Substr(SM0->M0_CGC,3,3)+"."+Substr(SM0->M0_CGC,6,3)+"/"+Substr(SM0->M0_CGC,9,4)+"-"+Substr(SM0->M0_CGC,13,2)
oPrint:Say(nLin    ,1300,_cCGC + " -  I.E.: " + SM0->M0_INSC ,oFont)
nLin += 50
oPrint:Say(nLin    ,1000,"ENDEREวO: ",oFont1)
oPrint:Say(nLin    ,1300,RTRIM(LTRIM(SM0->M0_ENDENT)) + ' - ' + RTRIM(LTRIM(SM0->M0_BAIRCOB)) + ', ' ,oFont)
nLin += 50
oPrint:Say(nLin    ,1300,"CEP: 13820-000  -  "+RTRIM(LTRIM(SM0->M0_CIDCOB))+"-"+RTRIM(LTRIM(SM0->M0_ESTCOB)),oFont)
nLin += 50
oPrint:Say(nLin    ,1000,"FONE: ",oFont1)
oPrint:Say(nLin    ,1300,RTRIM(LTRIM(SM0->M0_TEL)),oFont)
nLin += 50
oPrint:Say(nLin    ,1000,"FAX: ",oFont1)
oPrint:Say(nLin    ,1300,RTRIM(LTRIM(SM0->M0_FAX)),oFont)
nLin += 50
oPrint:Say(nLin    ,1000,"SITE: ",oFont1)
oPrint:Say(nLin    ,1300,"www.novel.com.br",oFont)


nLin += 200
oPrint:Say(nLin    ,0900,"PROPOSTA COMERCIAL",oFont5)
oPrint:Say(nLin    ,1700,"Nr.:",oFont5)
oPrint:Say(nLin    ,2000,_QUERY->UB_NUM,oFont5)
nLin += 50
oPrint:Say(nLin    ,1700,"Emissใo:",oFont5)
oPrint:Say(nLin    ,2000,DtoC(Stod(_QUERY->UA_EMISSAO)),oFont5)
nLin += 50
oPrint:Say(nLin    ,1700,"Revisใo",oFont5)
oPrint:Say(nLin    ,2000,DtoC(Stod(_QUERY->UA_ZZDTALT)),oFont5)
nLin += 100


//Prospect
//If Substr(_QUERY->UA_CLIENTE,1,1)=="A" .OR. Substr(_QUERY->UA_CLIENTE,1,1)=="B" .OR. Substr(_QUERY->UA_CLIENTE,1,1)=="I" .OR. Substr(_QUERY->UA_CLIENTE,1,1)=="F"
If Substr(_QUERY->UA_CLIENTE,1,1)<>"P"
	
	nLin += 100
	oPrint:Say(nLin    ,0100,"CLIENTE: ",oFont1)
	oPrint:Say(nLin    ,0300,TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_NOME")),oFont)
	oPrint:Say(nLin    ,1200,"CONTATO ADM: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_NOME")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"CIDADE: ",oFont1)
	oPrint:Say(nLin    ,0300,TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_MUN")) + " - " + TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_EST")),oFont)
	oPrint:Say(nLin    ,1200,"FONE ADM: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM(Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_TEL")),oFont)
	
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"CONTATO: ",oFont1)
	oPrint:Say(nLin    ,0300,TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CONTATO")),oFont)
	oPrint:Say(nLin    ,1200,"EMAIL ADM: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_MAIL")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"FONE: ",oFont1)
	oPrint:Say(nLin    ,0300,""+TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_TEL")),oFont)
	oPrint:Say(nLin    ,1200,"CONTATO VEND: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_NOME")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"CNPJ: ",oFont1)
	_cCGC	:= Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),1,2)+"."+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),3,3)+"."+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),6,3)+"/"+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),9,4)+"-"+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),13,2)
	oPrint:Say(nLin    ,0300,_cCGC,oFont)
	oPrint:Say(nLin    ,1200,"FONE VEND: ",oFont1)
	oPrint:Say(nLin    ,1500, TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_TEL")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"EMAIL: ",oFont1)
	oPrint:Say(nLin    ,0300,TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_EMAIL2")),oFont)
	oPrint:Say(nLin    ,1200,"EMAIL VEND: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_EMAIL")),oFont)
	
	
	
Else
	
	nLin += 100
	oPrint:Say(nLin    ,0100,"CLIENTE: ",oFont1)
	oPrint:Say(nLin    ,0300,TRIM (Posicione("SUS",1,xFilial("SUS")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"US_NOME")),oFont)
	oPrint:Say(nLin    ,1200,"CONTATO ADM: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_NOME")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"CIDADE: ",oFont1)
	oPrint:Say(nLin    ,0300,TRIM (Posicione("SUS",1,xFilial("SUS")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"US_MUN")) + " - " + TRIM (Posicione("SUS",1,xFilial("SUS")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"US_EST")),oFont)
	oPrint:Say(nLin    ,1200,"FONE ADM: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM(Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_TEL")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"CONTATO: ",oFont1)
	oPrint:Say(nLin    ,0300,TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CONTATO")),oFont)
	oPrint:Say(nLin    ,1200,"EMAIL ADM: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_MAIL")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"FONE: ",oFont1)
	oPrint:Say(nLin    ,0300,""+TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_TEL")),oFont)
	oPrint:Say(nLin    ,1200,"CONTATO VEND: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_NOME")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"CNPJ: ",oFont1)
	_cCGC	:= Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),1,2)+"."+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),3,3)+"."+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),6,3)+"/"+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),9,4)+"-"+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),13,2)
	oPrint:Say(nLin    ,0300,_cCGC,oFont)
	oPrint:Say(nLin    ,1200,"FONE VEND: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_TEL")),oFont)
	
	nLin += 50
	oPrint:Say(nLin    ,0100,"EMAIL: ",oFont1)
	oPrint:Say(nLin    ,0300,TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_EMAIL2")),oFont)
	oPrint:Say(nLin    ,1200,"EMAIL VEND: ",oFont1)
	oPrint:Say(nLin    ,1500,TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_EMAIL")),oFont)
	
EndIf


If _cFlag <> "2"
	nLin += 100
	oPrint:Box(nLin,0050,nLin,2300)
	nLin += 50
	//	oPrint:Say(nLin,0100,"ENTREGA PARCIAL:",oFont)
	oPrint:Say(nLin,1200,"GRAVAวรO:",oFont)
	//	If TRIM(_QUERY->UA_ENTPARC) == "2"
	//		oPrint:Say(nLin,0500,"SIM",oFont)
	//	Else
	//		oPrint:Say(nLin,0500,"NAO",oFont)
	//	EndIf
	If TRIM(_QUERY->UA_GRAVA) == "S"
		oPrint:Say(nLin,1600,"SIM",oFont)
	Else
		oPrint:Say(nLin,1600,"NAO",oFont)
	EndIf
	nLin += 150
	//oPrint:Box(nLin,0050,nLin,2000)
	//nLin += 50
	oPrint:Say(nLin,0100,"Atendendo sua solicita็ใo, apresentamos a cota็ใo para os itens abaixo relacionados: ",oFont5)
	nLin += 50
	oPrint:Box(nLin,0050,nLin,2300)
	nLin += 50
	
	
	oPrint:Say(nLin,0100,"ITEM",oFont)
	oPrint:Say(nLin,0200,"CODIGO",oFont)
	oPrint:Say(nLin,0460,"DESCRICAO",oFont)
	oPrint:Say(nLin,1250,"NCM",oFont)
	oPrint:Say(nLin,1400,"QTD",oFont)
	oPrint:Say(nLin,1500,"VLR.UNIT",oFont)
	oPrint:Say(nLin,1700,"VLR.TOTAL",oFont)
	oPrint:Say(nLin,1950,"IPI %",oFont)
	oPrint:Say(nLin,2100,"PRAZO",oFont)
	
	nLin += 50
	oPrint:Say(nLin,1550,"R$",oFont)
	oPrint:Say(nLin,1750,"R$",oFont)
	oPrint:Say(nLin,2100,"ENTREGA",oFont)
	nLin += 50
	
	
Else
	
	nLin += 150
	oPrint:Box(nLin,0050,nLin,2300)
	nLin += 50
	//oPrint:Box(nLin,0050,nLin,2000)
	//nLin += 50
	oPrint:Say(nLin,0100,"FOTO DOS PRODUTOS",oFont1)
	
EndIf


//oPrint:EndPage()
//oPrint:Preview()






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MontaTelaบAutor  ณ Newton Reca Alves  บ Data ณ  02/08/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o Relatorio. RODAPE                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaTela2(_cStatusRel)


_cFlag	:= _cStatusRel

//If _cFlag =="C"

//oPrint:StartPage() // Inicia uma nova pแgina
//EndIf


//oPrint:Box(50,50,500,3300) //SUPERIOR TOTAL
//oPrint:Box(50,1150,500,2150) //SUPERIOR MEIO
//oPrint:Box(550,50,1900,3300) //MEIO TOTAL
//oPrint:Box(1950,50,2400,3300) //INFERIOR TOTAL




nLin := 2700

oPrint:Box(nLin,0050,nLin,2300) //MEIO CABECALHO TOTAL
nLin += 50
oPrint:Say(nLin,0100,"OBSERVAวีES:",oFont1)
oPrint:Say(nLin,0400,Substr(_cNotes,1,100),oFont4)
nLin += 050
oPrint:Say(nLin,0400,Substr(_cNotes,101,100),oFont4)
nLin += 050
oPrint:Box(nLin,0050,nLin,2300) //MEIO CABECALHO TOTAL
nLin += 050

oPrint:Say(nLin,0100,"PRAZO DE ENTREGA:",oFont1)
oPrint:Say(nLin,0700,"Nosso prazo de entrega ้ de at้ 30 dias.",oFont4)
nLin += 050
oPrint:Say(nLin,0700,".",oFont4)

nLin += 050
oPrint:Say(nLin,0100,"CONDIวรO DE PAGAMENTO:",oFont1)
oPrint:Say(nLin,0700,Posicione("SE4",1,xFilial("SE4")+_cCond,"E4_DESCRI"),oFont4)

nLin += 050
oPrint:Say(nLin,0100,"FRETE:",oFont1)
If TRIM(_cFrete) == "C"
	oPrint:Say(nLin,0700,"CIF",oFont4)
ElseIf TRIM(_cFrete) == "F"
	oPrint:Say(nLin,0700,"FOB",oFont4)
Endif

nLin += 050
oPrint:Say(nLin,0100,"IMPOSTOS:",oFont1)
oPrint:Say(nLin,0700,"Os valores cotados incluem o ICMS/PIS/Cofins calculados de acordo com a alํquota vigente nesta data.",oFont4)
nLin += 050
oPrint:Say(nLin,0700,"Havendo varia็๕es positivas ou negativas nas alํquotas dos impostos e taxas, as mesmas serใo repassadas aos pre็os.",oFont4)
nLin += 050
oPrint:Say(nLin,0700,"Impostos calculados como material de uso e consumo e/ou ativo imobilizado.",oFont4)
nLin += 050
oPrint:Say(nLin,0100,"FATURAMENTO MอNIMO:",oFont1)
oPrint:Say(nLin,0700,"R$ 1.500,00 (Quinhentos Reais)",oFont4)

nLin += 050
oPrint:Say(nLin,0100,"VALIDADE DESTA PROPOSTA:",oFont1)
oPrint:Say(nLin,0700,"07 dias.",oFont4)


nLin += 050
oPrint:Say(nLin,2100,Transform(nPag,"@!"),oFont4)

oPrint:EndPage()

//If _cFlag =="C"
//	MontaTela1()
//EndIf

//oPrint:EndPage()
//oPrint:Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RunPOL   บAutor  ณ Newton Reca Alves  บ Data ณ  02/08/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Processamento                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunPOL()


_cEmp1	:= "SUA" + substr(CNUMEMP,1,2) + "0"
_cEmp2	:= "SUB" + substr(CNUMEMP,1,2) + "0"
//cQuery	:= " SELECT * FROM "+_cEmp1+" WHERE D_E_L_E_T_<>'*' AND C8_EMISSAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND C8_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND C8_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' ORDER BY C8_NUM, C8_ITEM "
cQuery	:= " SELECT * FROM "+_cEmp1+","+_cEmp2+" WHERE "+_cEmp1+".D_E_L_E_T_<>'*' AND "+_cEmp2+".D_E_L_E_T_<>'*' AND UA_NUM=UB_NUM AND UA_NUM='"+mv_par01+"' "
TCQUERY cQuery NEW ALIAS "_query"
Tcsqlexec(cQuery)

DBSelectArea("_query")
DBGoTop()

_cFrete		:= _QUERY->UA_TPFRETE
_cCond		:= _QUERY->UA_CONDPG
_nValMerc	:= _QUERY->UA_VALMERC
_nValTotal	:= _QUERY->UA_VLRLIQ
_nFrete     := _QUERY->UA_FRETE
_cNotes		:= _QUERY->UA_OBS1+ " "+_QUERY->UA_OBS2 +" "+_QUERY->UA_OBS3

MontaTela1()

//nLin += 50

_nIPI		:= 0
_nTIPI		:= 0
_nTUnit		:= 0
_nTTotal	:= 0
M_VRDESME   := 0

M_VRITEM 	:= 0.00
M_DESC   	:= 0.00
M_VRITEMTOT := 0.00
_nBIPI		:= 0.00
_nBTotalIPI	:= 0.00

DBSelectArea("_query")
While !eof() .and. _QUERY->UB_NUM==mv_par01
	
	
	nLin 		+= 70
	_cCotacao	:= _QUERY->UB_NUM
	_nTUnit		:= 0
	_nValorIPI	:= 0
	_nBIPI		:= 0
	
	oPrint:Say(nLin,0100,_QUERY->UB_ITEM,oFont4)
	oPrint:Say(nLin,0200,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_COD"),1,50),oFont3)
	oPrint:Say(nLin,0460,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_DESC"),1,50),oFont3)
	oPrint:Say(nLin,1250,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_POSIPI"),1,50),oFont3)
	oPrint:Say(nLin,1370,transform(_QUERY->UB_QUANT,"@E 999,999.99"),oFont3)
	oPrint:Say(nLin,1500,transform(_QUERY->UB_VRUNIT,"@E 999,999.99"),oFont3)
	oPrint:Say(nLin,1700,transform(_QUERY->UB_VLRITEM,"@E 9,999,999.99"),oFont3)
	
	WTIPO:=Posicione("SA1",1,xFilial()+_QUERY->UA_CLIENTE,"SA1->A1_ME")
	
	DBSelectArea("_query")
	
	//Verifica se tem IPI //////////////////////////////////////////////
	If POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_IPI") <> 0 .and. TRIM(POSICIONE("SF4",1,xFilial("SF4")+_QUERY->UB_TES,"F4_IPI")) == "S"
		
		M_VRITEMTOT := M_VRITEMTOT +_QUERY->UB_VLRITEM
		
		//Verificar se eh Micro empresa /////////////////////////////////
		If WTIPO == "S"
			_nBIPI		:= (_QUERY->UB_VLRITEM + _QUERY->UB_VALDESC)
		Else
			_nBIPI		:= _QUERY->UB_VLRITEM
		EndIf

		_nValorIPI	:= (_nBIPI * POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_IPI") /100)
		
	Else
		M_VRITEM 	:= M_VRITEM + 0
		M_DESC   	:= M_DESC   + 0
		M_VRITEMTOT := M_VRITEMTOT + _QUERY->UB_VLRITEM
		_nValorIPI	:= 0
	EndIf


	//Total do IPI e Base do IPI
	_nTIPI		+= _nValorIPI
	_nBTotalIPI	+= _nBIPI
	
	DBSelectArea("_query")
	

	//Imprime percentual do IPI /////////////////////////////////////////////////////////////////////////////////
	If POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_IPI") <> 0 .and. TRIM(POSICIONE("SF4",1,xFilial("SF4")+_QUERY->UB_TES,"F4_IPI")) == "S"
		oPrint:Say(nLin,1950,transform(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_IPI"),"@E 999,999.99"),oFont3)
	Else
		_nIPI := 0
		oPrint:Say(nLin,1950,transform(_nIPI,"@E 999,999.99"),oFont3)
	EndIf
	
	//oPrint:Say(nLin,2100,DTOC(STOD(_QUERY->UB_ZZDATEN)),oFont3)
	If TRIM(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_ORIGEM")) == "0"
		_cDTENT	:= "ATษ 30 DIAS"
	Else
		_cDTENT	:= "ATษ 120 DIAS"
	EndIf
	
	oPrint:Say(nLin,2100,_cDTENT,oFont3)
	
	DBSkip()
	
	If nLin>=2200 .and. !EOF()
		nLin += 80
		oPrint:Say(nLin,3000,"CONTINUA ----->",oFont4)
		//oPrint:EndPage()
		MontaTela2()
		nPag++
		MontaTela1()
		//nLin := 800
	EndIf
	
EndDo

nLin := 2400

oPrint:Say(nLin,1400,"FRETE:",oFont5)
oPrint:Say(nLin,2000,"R$   " + transform(_nFrete,"@E 99,999,999.99"),oFont5)
nLin += 100
oPrint:Say(nLin,1400,"BASE IPI:",oFont5)
oPrint:Say(nLin,2000,"R$   " + transform(_nBTotalIPI,"@E 99,999,999.99"),oFont5)
nLin += 100
oPrint:Say(nLin,1400,"IPI:",oFont5)
oPrint:Say(nLin,2000,"R$   " + transform(_nTIPI,"@E 99,999,999.99"),oFont5)
nLin += 100

oPrint:Say(nLin,1400,"TOTAL PROPOSTA:",oFont5)
oPrint:Say(nLin,2000,"R$   " + transform(M_VRITEMTOT+_nTIPI+_nFrete,"@E 99,999,999.99"),oFont5)
nLin += 100


MontaTela2("F")


//fotos dos produtos
DBCloseArea()
TCQUERY cQuery NEW ALIAS "_query"
Tcsqlexec(cQuery)

DBSelectArea("_query")
DBGoTop()
MontaTela1("2")


While !eof()
	
	nLin += 70
	
	oPrint:Say(nLin,0100,_QUERY->UB_ITEM,oFont4)
	oPrint:Say(nLin,0200,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_COD"),1,50)+"  -  "+SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_DESC"),1,50),oFont4)
	_cCaminho := "\A_COMERCIAL\Fotos\"+trim(SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_COD"),1,50))+".jpg"
	oPrint:sayBitmap(nlin+050, 100, _cCaminho, nlin+400,)
	nLin += 600
	
	DBSkip()
	
	If nLin>=2200 .and. !EOF()
		
		nLin += 80
		oPrint:Say(nLin,3000,"CONTINUA ----->",oFont4)
		//oPrint:EndPage()
		nPag++
		MontaTela2()
		MontaTela1("2")
		//nLin := 800
	EndIf
	
	
EndDo


nPag++
MontaTela2("F")


DBCloseArea()

oPrint:EndPage()
//oPrint:Preview()
oPrint:Print()
MS_FLUSH()

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ CriaPerg บAutor  ณ Newton Reca Alves  บ Data ณ  10/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Criar Pergunta no SX1.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriarPerg()


aRegs	:={}
cPerg	:= PADR(cPerg,6)

_aMV_PAR01 := {}


Aadd(_aMV_PAR01, "Informar o numedo da Cotacao             ")

//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(cPerg,"01","Cotacao                       ","Cotacao                       ","Cotacao                       ","mv_ch1","C",06,0,0,"G","","SUA","","","mv_par01","","","","","","","","","","","","","","","","",_aMV_PAR01)


Return()