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
ฑฑบPrograma  ณ MYCOM01  บ Autor ณ Newton Reca Alves  บ Data ณ  26/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Cotacao em formato grafico                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MYCOM01()
	
	If Type("oMainWnd") <> "U"
		ProcRel()	
	EndIf  
	
Return

Static Function procRel()

Private	cPerg	:= "MYCM01"
CriarPerg()
Pergunte(cPerg,.T.)

mv_par03 := dtos(mv_par03)
mv_par04 := dtos(mv_par04)

Public 	oFont, oFont1, oFont2, oFont3, oFont4, oBold
Public 	i 		:= 0
Public 	aCoords	:= { 700, 70, 800, 400 }
Public 	oBrush
Public 	oDlg
Public 	oPrint
Public 	nLin	:= 100

oFont  := TFont():New("Arial",-10,10,,.F.,,,,.T.,.F.)
oFont1 := TFont():New("Arial",-10,10,,.T.,,,,,.F. )  //BOLD
oFont2 := TFont():New("Arial",-10,11,,.F.,,,,.T.,.F.)
oFont3 := TFont():New("Arial",-10,11,,.T.,,,,.T.,.F.) //BOLD
oFont4 := TFont():New("Arial",-10,08,,.F.,,,,,.F. )  
oFont5 := TFont():New("Arial",-10,14,,.T.,,,,.T.,.F.)//BOLD
oFont6 := TFont():New("Arial",-10,08,,.T.,,,,,.F. )  //BOLD

oBrush := TBrush():New( , CLR_BLACK )
oPrint := TMSPrinter():New( "Relatorio trimestral de produtos controlados" )


DEFINE MSDIALOG oDlg TITLE "Cotacao" FROM 0,0 TO 250,430 PIXEL

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 000, 000 BITMAP oBmp RESNAME "LOGIN" oF oDlg SIZE 30, 120 NOBORDER WHEN .F. PIXEL
@ 003, 040 SAY "Escolha uma op็ใo" FONT oBold PIXEL
@ 014, 030 TO 16 ,400 LABEL '' OF oDlg  PIXEL

@ 020, 040 BUTTON "Configurar" SIZE 40,13 PIXEL OF oDlg ACTION oPrint:Setup()
@ 020, 080 BUTTON "Perguntas"  SIZE 40,13 PIXEL OF oDlg ACTION Perguntar()
@ 020, 120 BUTTON "Visualiza"  SIZE 40,13 PIXEL OF oDlg ACTION ProcImp()
@ 020, 160 BUTTON "Imprimir"   SIZE 40,13 PIXEL OF oDlg ACTION oPrint:Print()


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

Private	cPerg	:= "MYCM01"
CriarPerg()
Pergunte(cPerg,.T.)
mv_par03 := dtos(mv_par03)
mv_par04 := dtos(mv_par04)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ALCM06   บAutor  ณNewton Reca Alves   บ Data ณ  02/08/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio para a Policia sobre Produtos Controlados.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PROCIMP()



oPrint := TMSPrinter():New( "Cotacao" )

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

Static Function MontaTela1() 


oPrint:StartPage() // Inicia uma nova pแgina


//oPrint:Box(50,50,500,3300) //SUPERIOR TOTAL
//oPrint:Box(50,1150,500,2150) //SUPERIOR MEIO
//oPrint:Box(550,50,1900,3300) //MEIO TOTAL
//oPrint:Box(1950,50,2400,3300) //INFERIOR TOTAL


nLin := 60
oPrint:Say(nLin    ,1000,"COTACAO DE COMPRAS - MYERS DO BRASIL",oFont5)

_cAno	:= AllTrim(str(year(ddatabase)))

nLin += 100

oPrint:Say(nLin    ,60,"Cotacao:",oFont5)
oPrint:Say(nLin    ,300,_QUERY->C8_NUM,oFont5)

oPrint:sayBitmap(nlin+100, 030, "\system\logomyers.bmp", nlin+350, 300)

nLin += 100
oPrint:Say(nLin    ,600,"RAZAO: ",oFont1)
oPrint:Say(nLin    ,900,SM0->M0_NOME,oFont)
oPrint:Say(nLin    ,2000,"RAZAO: ",oFont1)
oPrint:Say(nLin    ,2300,Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_NOME"),oFont)

nLin += 50
oPrint:Say(nLin    ,600,"ENDEREวO: ",oFont1)
oPrint:Say(nLin    ,900,RTRIM(LTRIM(SM0->M0_ENDENT)) + ' - ' + RTRIM(LTRIM(SM0->M0_BAIRCOB)) + ', ' ,oFont)
oPrint:Say(nLin    ,2000,"ENDEREวO: ",oFont1)
oPrint:Say(nLin    ,2300,TRIM (Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_END")) + " - " + TRIM(Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_BAIRRO")),oFont)

nLin += 50
oPrint:Say(nLin    ,900,RTRIM(LTRIM(SM0->M0_CIDCOB))+"-"+RTRIM(LTRIM(SM0->M0_ESTCOB)) + ', CEP: ' + "" + ', TEL: ' + RTRIM(LTRIM(SM0->M0_TEL)),oFont)
oPrint:Say(nLin    ,2300,TRIM(Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_MUN")) + "-" + Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_EST")+", CEP: " + Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_CEP") + ", TEL: " + Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_DDD") + " "+  Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_TEL"),oFont)

nLin += 50
oPrint:Say(nLin    ,600,"CNPJ: ",oFont1)
_cCGC	:= Substr(SM0->M0_CGC,1,2)+"."+Substr(SM0->M0_CGC,3,3)+"."+Substr(SM0->M0_CGC,6,3)+"/"+Substr(SM0->M0_CGC,9,4)+"-"+Substr(SM0->M0_CGC,13,2)
oPrint:Say(nLin    ,900,_cCGC,oFont)
oPrint:Say(nLin    ,2000,"CNPJ: ",oFont1)
_cCGC	:= Substr(Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_CGC"),1,2)+"."+Substr(Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_CGC"),3,3)+"."+Substr(Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_CGC"),6,3)+"/"+Substr(Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_CGC"),9,4)+"-"+Substr(Posicione("SA2",1,xFilial("SA2")+_QUERY->C8_FORNECE+_QUERY->C8_LOJA,"A2_CGC"),13,2)
oPrint:Say(nLin    ,2300,_cCGC,oFont)

nLin += 50
oPrint:Say(nLin    ,600,"CONTATO: ",oFont1)
oPrint:Say(nLin    ,900,MV_PAR07,oFont)
oPrint:Say(nLin    ,2000,"CONTATO: ",oFont1)
oPrint:Say(nLin    ,2300,_QUERY->C8_CONTATO,oFont)

nLin += 50
oPrint:Say(nLin    ,600,"EMAIL: ",oFont1)
oPrint:Say(nLin    ,900,MV_PAR08,oFont)
oPrint:Say(nLin    ,2000,"EMAIL: ",oFont1)
oPrint:Say(nLin    ,2300,"",oFont)

nLin += 50
oPrint:Say(nLin    ,600,"SITE: ",oFont1)
oPrint:Say(nLin    ,900,"www.myersdobrasil.com.br",oFont)


oPrint:Box(0690,0050,0750,3300) 

nLin  := 700

oPrint:Say(nLin,0100,"DESCRICAO",oFont)
oPrint:Say(nLin,1000,"NCM",oFont)
oPrint:Say(nLin,1300,"COD.MYERS",oFont)
oPrint:Say(nLin,1600,"COD.FORNEDOR",oFont)
oPrint:Say(nLin,2000,"QTD",oFont)
oPrint:Say(nLin,2200,"UM",oFont)
oPrint:Say(nLin,2400,"NECESSIDADE",oFont)

oPrint:Say(nLin,2700,"PRECO",oFont)
oPrint:Say(nLin,3000,"ENTREGA",oFont)
	                                                  
nLin += 50

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


nLin := 1600

oPrint:Box(nLin,0050,nLin,3300) //MEIO CABECALHO TOTAL
nLin += 050

oPrint:Say(nLin,0100,"POLITICA DE PAGAMENTO DA MYERS DO BRASIL",oFont1)
nLin += 070
oPrint:Say(nLin,0100,"DATA EMISSAO NOTA FISCAL",oFont4)
oPrint:Say(nLin,0700,"DATA DO PAGAMENTO",oFont4)
oPrint:Say(nLin,1900,"FRETE",oFont4)
oPrint:Say(nLin,2600,"FISCAL",oFont4)
//oPrint:Say(nLin,2400,"OBSERVAวีES",oFont4)

nLin += 070
oPrint:Say(nLin,0200,"01 ATษ O DIA 15  ------------------>",oFont4)
oPrint:Say(nLin,0700,"DIA 15 DO MสS SUBSEQUENTE",oFont4)
oPrint:Box(nLin,1700,nLin+30,1730)
oPrint:Say(nLin,1750,"CIF - __________________",oFont4)
oPrint:Box(nLin,2400,nLin+30,2430)
oPrint:Say(nLin,2450,"OPTANTE PELO SIMPLES",oFont4)
//oPrint:Say(nLin,2400,"_________________________________________",oFont4)

nLin += 070
oPrint:Say(nLin,0200,"16 ATษ O DIA 31  ------------------>",oFont4)
oPrint:Say(nLin,0700,"DIA 30 DO MสS SUBSEQUENTE",oFont4)
oPrint:Box(nLin,1700,nLin+30,1730)
oPrint:Say(nLin,1750,"FOB - JAGUARIUNA",oFont4)
oPrint:Box(nLin,2400,nLin+30,2430)
oPrint:Say(nLin,2450,"OUTRO - ________________",oFont4)
//oPrint:Say(nLin,2400,"_________________________________________",oFont4)

nLin += 150
	                                                  
oPrint:Say(nLin-50,0050,"OBSERVAวรO:",oFont1)
oPrint:Say(nLin-50,0400,TRIM(mv_par09) + " " + TRIM(mv_par10),oFont1)
oPrint:Box(nLin,0050,nLin,3300)
nLin += 70
oPrint:Box(nLin,0050,nLin,3300)
nLin += 70
oPrint:Box(nLin,0050,nLin,3300)
nLin += 70

oPrint:Say(nLin,0400,"__________________________________________",oFont1)
oPrint:Say(nLin,1500,"________/________/________",oFont1)
oPrint:Say(nLin,2500,"________/________/________",oFont1)
nLin += 070
oPrint:Say(nLin,0600,"PREENCHIDO POR",oFont1)
oPrint:Say(nLin,1700,"DATA",oFont1)
oPrint:Say(nLin,2600,"VALIDADE COTAวรO",oFont1)


oPrint:EndPage()

If _cFlag =="C"
	MontaTela1()
EndIf

//oPrint:EndPage()
//oPrint:Preview()



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


_cEmp1	:= "SC8" + substr(CNUMEMP,1,2) + "0"
cQuery	:= " SELECT * FROM "+_cEmp1+" WHERE D_E_L_E_T_<>'*' AND C8_EMISSAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND C8_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND C8_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' ORDER BY C8_NUM, C8_ITEM "
TCQUERY cQuery NEW ALIAS "_query"
Tcsqlexec(cQuery)

DBSelectArea("_query")
DBGoTop()

MontaTela1()

//nLin += 50
	
While !eof()

	nLin += 70
	_cCotacao	:= _QUERY->C8_NUM
	oPrint:Say(nLin,0100,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->C8_PRODUTO,"B1_DESC"),1,50),oFont4)
	oPrint:Say(nLin,1000,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->C8_PRODUTO,"B1_POSIPI"),1,50),oFont4)
	oPrint:Say(nLin,1300,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->C8_PRODUTO,"B1_COD"),1,50),oFont4)
	oPrint:Say(nLin,1600,"_____________________",oFont4)
	oPrint:Say(nLin,2000,transform(_QUERY->C8_QUANT,"999,999.99"),oFont4)
	oPrint:Say(nLin,2200,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->C8_PRODUTO,"B1_UM"),1,50),oFont4)
	oPrint:Say(nLin,2400,DTOC(STOD(_QUERY->C8_DATPRF)),oFont4)
	
	oPrint:Say(nLin,2700,"_______________",oFont4)
	oPrint:Say(nLin,3000,"_______________",oFont4)

	DBSkip()

	If _cCotacao<>_QUERY->C8_NUM .and. !eof()

		MontaTela2("C")
	    
		//oPrint:EndPage()
		//nLin := 800
	ElseIf _cCotacao==_QUERY->C8_NUM .AND. nLin>=1500

		nLin += 80
		oPrint:Say(nLin,3000,"CONTINUA ----->",oFont4)
		//oPrint:EndPage()
		MontaTela2("C")
		//nLin := 800
	EndIf 


EndDo

MontaTela2("F")

	
DBCloseArea()

oPrint:EndPage()
oPrint:Preview()
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
_aMV_PAR02 := {}
_aMV_PAR03 := {}
_aMV_PAR04 := {}
_aMV_PAR05 := {}
_aMV_PAR06 := {}
_aMV_PAR07 := {}
_aMV_PAR08 := {}
_aMV_PAR09 := {}
_aMV_PAR10 := {}


Aadd(_aMV_PAR01, "Produto inicial do filtro                ")
Aadd(_aMV_PAR02, "Produto final do filtro                  ")
Aadd(_aMV_PAR03, "Escolha a data inicial do filtro         ")
Aadd(_aMV_PAR04, "Escolha a data final do filtro           ")
Aadd(_aMV_PAR05, "Preencha o numero Inicial do filtro      ")
Aadd(_aMV_PAR06, "Preencha o numero Final do filtro        ")
Aadd(_aMV_PAR07, "Preencha o nome do contato da Myers      ")
Aadd(_aMV_PAR08, "Preencha o email do contato da Myers     ")
Aadd(_aMV_PAR09, "Campo livre para observacao              ")
Aadd(_aMV_PAR10, "Campo livre para observacao              ")

//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(cPerg,"01","Produto De?                   ","Produto De?                   ","Produto De?                   ","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","",_aMV_PAR01)
PutSx1(cPerg,"02","Produto Ate?                  ","Produto Ate?                  ","Produto Ate?                  ","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","",_aMV_PAR02)
PutSx1(cPerg,"03","Data De?                      ","Data De?                      ","Data De?                      ","mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",_aMV_PAR03)
PutSx1(cPerg,"04","Data Ate?                     ","Data Ate?                     ","Data Ate?                     ","mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",_aMV_PAR04)
PutSx1(cPerg,"05","Cotacao De?                   ","Cotacao De?                   ","Cotacao De?                   ","mv_ch5","C",06,0,0,"G","","SC8","","","mv_par05","","","","","","","","","","","","","","","","",_aMV_PAR05)
PutSx1(cPerg,"06","Cotacao Ate?                  ","Cotacao Ate?                  ","Cotacao Ate?                  ","mv_ch6","C",06,0,0,"G","","SC8","","","mv_par06","","","","","","","","","","","","","","","","",_aMV_PAR06)
PutSx1(cPerg,"07","Contato Myers                 ","Contato Myers                 ","Contato Myers                 ","mv_ch7","C",20,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",_aMV_PAR07)
PutSx1(cPerg,"08","Email do Contato Myers        ","Email do Contato Myers        ","Email do Contato Myers        ","mv_ch8","C",50,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",_aMV_PAR08)
PutSx1(cPerg,"09","Observacao                    ","Observacao                    ","Observacao                    ","mv_ch9","C",99,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",_aMV_PAR09)
PutSx1(cPerg,"10","Observacao ..Continuacao      ","Observacao ..Continuacao      ","Observacao ..Continuacao      ","mv_cha","C",99,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",_aMV_PAR010)


Return()

