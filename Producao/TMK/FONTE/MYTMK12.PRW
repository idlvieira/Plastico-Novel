#include "rwmake.ch"
#include "topconn.ch"
#include "fivewin.ch"
#include "font.ch"
#include "print.ch"
#include "folder.ch"
#include "msobject.ch"
#include "vkey.ch"
#include "winapi.ch"

/*/{Protheus.doc} MYTMK12

Imprime Orcamento de Venda em modo grafico

@type function
@author Newton Reca Alves
@since 27/03/2013
@version P12
@database MSSQL

@history 10/07/2018, Leonardo Bergamasco Chamado 28 - 9HH-5YX-GBU4 - Removido mensagem do Orçamento
@history 09/08/2022, Júlio César Dias de Oliveira - FSW Seven Consultoria RP, Alteração na linha 1 das observações do relatório buscando do parâmetro 7V_TMK12O1
@history 09/08/2022, Júlio César Dias de Oliveira - FSW Seven Consultoria RP, Alteração na linha 2 das observações do relatório buscando do parâmetro 7V_TMK12O2
@history 09/08/2022, Júlio César Dias de Oliveira - FSW Seven Consultoria RP, Alteração na linha 3 das observações do relatório buscando do parâmetro 7V_TMK12O3
@history 09/08/2022, Júlio César Dias de Oliveira - FSW Seven Consultoria RP, Alteração na linha 4 das observações do relatório buscando do parâmetro 7V_TMK12O4
@history 09/08/2022, Júlio César Dias de Oliveira - FSW Seven Consultoria RP, Revisão ProtheusDoc

/*/
User Function MYTMK12()

	If Type("oMainWnd") <> "U"
		ProcRel()	
	EndIf  

Return

Static Function procRel()

	Private	cPerg	:=  "MYTM01"
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
	@ 003, 040 SAY "Escolha uma opção" FONT oBold PIXEL
	@ 014, 030 TO 16 ,400 LABEL '' OF oDlg  PIXEL

	@ 020, 040 BUTTON "Configurar"  SIZE 40,13 PIXEL OF oDlg ACTION oPrint:Setup()
	@ 020, 080 BUTTON "Perguntas"   SIZE 40,13 PIXEL OF oDlg ACTION Perguntar()
	@ 020, 120 BUTTON "Imprimir"    SIZE 40,13 PIXEL OF oDlg ACTION ProcImp()
	@ 020, 160 BUTTON "F.Min/Valid" SIZE 40,13 PIXEL OF oDlg ACTION fFMinValid()


	//@ 020, 160 BUTTON "Gen-JPEG"   SIZE 40,13 PIXEL OF oDlg ACTION MySaveJPEG( oPrint  )

	ACTIVATE MSDIALOG oDlg CENTER



Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CxDLG    ºAutor  ³ Newton Reca Alves  º Data ³ 02/08/04    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Caixa de Dialogo.                                          º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Perguntar()

	Private	cPerg	:= "MYTM01"
	CriarPerg()
	Pergunte(cPerg,.T.)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ALCM06   ºAutor  ³  Newton Reca Alves º Data ³ 02/08/04    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PROCIMP()

	Local _cStatus1	:= Posicione( "SUA", 01, xFilial( "SUA" ) + mv_par01, "UA_ZZSTAT1" ) 
	Local _cStatus2 := Posicione( "SUA", 01, xFilial( "SUA" ) + mv_par01, "UA_ZZSTAT2" )

	If AllTrim( _cStatus1 ) == "BLO" .Or. AllTrim( _cStatus2 ) == "BLO" .Or. AllTrim( _cStatus1 ) == "REJ" .Or. AllTrim( _cStatus2 ) == "REJ"
		Alert( "Pedido bloqueado, impressao indisponivel" )
		Return
	EndIf

	oPrint 		:= TMSPrinter():New( "Orcamento de Venda" )

	//MontaTela1()

	RunPOL()



Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MontaTelaºAutor  ³ Newton Reca Alves  º Data ³             º±±   
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta o Relatorio.                                         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaTela1(_cFlag) 


	oPrint:StartPage() // Inicia uma nova página
	oPrint:SetPortrait() 

	//oPrint:Box(50,50,500,3300) //SUPERIOR TOTAL
	//oPrint:Box(50,1150,500,2150) //SUPERIOR MEIO
	//oPrint:Box(550,50,1900,3300) //MEIO TOTAL
	//oPrint:Box(1950,50,2400,3300) //INFERIOR TOTAL


	_cAno	:= AllTrim(str(year(ddatabase)))

	nLin 	:= 50


	oPrint:sayBitmap(nlin+100, 100, "\system\logomyers2.jpg", nlin+700,)

	nLin += 100
	oPrint:Say(nLin    ,1000,"RAZÃO: ",oFont1)
	oPrint:Say(nLin    ,1300,SM0->M0_NOMECOM,oFont)
	nLin += 50
	oPrint:Say(nLin    ,1000,"CNPJ: ",oFont1)
	_cCGC	:= Substr(SM0->M0_CGC,1,2)+"."+Substr(SM0->M0_CGC,3,3)+"."+Substr(SM0->M0_CGC,6,3)+"/"+Substr(SM0->M0_CGC,9,4)+"-"+Substr(SM0->M0_CGC,13,2)
	oPrint:Say(nLin    ,1300,_cCGC + " -  I.E.: " + SM0->M0_INSC ,oFont)
	nLin += 50
	oPrint:Say(nLin    ,1000,"ENDEREÇO: ",oFont1)
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
	oPrint:Say(nLin    ,1700,"Emissão:",oFont5)
	oPrint:Say(nLin    ,2000,DtoC(Stod(_QUERY->UA_EMISSAO)),oFont5)
	nLin += 50
	oPrint:Say(nLin    ,1700,"Revisão",oFont5)
	oPrint:Say(nLin    ,2000,DtoC(Stod(_QUERY->UA_ZZDTALT)),oFont5) //DtoC(Stod(_QUERY->UA_ZZDTALT)),oFont5)
	nLin += 100


	//Prospect
	If Substr(_QUERY->UA_CLIENTE,1,1) != "P"


		nLin += 100
		oPrint:Say(nLin    ,0100,"CLIENTE: ",oFont1)
		oPrint:Say(nLin    ,0300,TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_NOME")),oFont)
		oPrint:Say(nLin    ,1200,"CONTATO ADM: ",oFont1)
		oPrint:Say(nLin    ,1500,TRIM (Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_NOME")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"CIDADE: ",oFont1)
		oPrint:Say(nLin    ,0300,TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_MUN")) + " - " + TRIM (Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_EST")),oFont)
		oPrint:Say(nLin    ,1200,"FONE ADM: ",oFont1)
		oPrint:Say(nLin    ,1500,TRIM (Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_TEL")),oFont)
		//oPrint:Say(nLin    ,1500,"("+TRIM(Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_DDD"))+") "+TRIM(Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_TEL")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"CONTATO: ",oFont1)
		oPrint:Say(nLin    ,0300,TRIM (Posicione("SU5",1,xFilial("SU5")+_QUERY->UA_CODCONT,"U5_CONTAT")),oFont)
		oPrint:Say(nLin    ,1200,"EMAIL ADM: ",oFont1)
		oPrint:Say(nLin    ,1500,TRIM (Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_ZZEMAIL")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"FONE: ",oFont1)
		oPrint:Say(nLin    ,0300,"("+TRIM (Posicione("SU5",1,xFilial("SU5")+_QUERY->UA_CODCONT,"U5_DDD"))+") "+TRIM (Posicione("SU5",1,xFilial("SU5")+_QUERY->UA_CODCONT,"U5_FCOM1")),oFont)
		oPrint:Say(nLin    ,1200,"CONTATO VEND: ",oFont1)
		oPrint:Say(nLin    ,1500,TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_NOME")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"CNPJ: ",oFont1)
		_cCGC	:= Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),1,2)+"."+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),3,3)+"."+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),6,3)+"/"+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),9,4)+"-"+Substr(Posicione("SA1",1,xFilial("SA1")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"A1_CGC"),13,2)
		oPrint:Say(nLin    ,0300,_cCGC,oFont)
		oPrint:Say(nLin    ,1200,"FONE VEND: ",oFont1)
		//oPrint:Say(nLin    ,1500,"("+TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_ZZDDD")) + ") "+ TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_TEL")),oFont)
		oPrint:Say(nLin    ,1500,"("+TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_ZZDDD")) + ") "+ TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_TEL")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"EMAIL: ",oFont1)
		oPrint:Say(nLin    ,0300,TRIM (Posicione("SU5",1,xFilial("SU5")+_QUERY->UA_CODCONT,"U5_EMAIL")),oFont)
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
		oPrint:Say(nLin    ,1500,"("+TRIM(Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_TEL")),oFont)
		//oPrint:Say(nLin    ,1500,"("+TRIM(Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_DDD"))+") "+TRIM(Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_TEL")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"CONTATO: ",oFont1)
		oPrint:Say(nLin    ,0300,TRIM (Posicione("SU5",1,xFilial("SU5")+_QUERY->UA_CODCONT,"U5_CONTAT")),oFont)
		oPrint:Say(nLin    ,1200,"EMAIL ADM: ",oFont1)
		oPrint:Say(nLin    ,1500,TRIM (Posicione("SU7",1,xFilial("SU7")+_QUERY->UA_OPERADO,"U7_ZZEMAIL")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"FONE: ",oFont1)
		oPrint:Say(nLin    ,0300,"("+TRIM (Posicione("SU5",1,xFilial("SU5")+_QUERY->UA_CODCONT,"U5_DDD"))+") "+TRIM (Posicione("SU5",1,xFilial("SU5")+_QUERY->UA_CODCONT,"U5_FCOM1")),oFont)
		oPrint:Say(nLin    ,1200,"CONTATO VEND: ",oFont1)
		oPrint:Say(nLin    ,1500,TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_NOME")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"CNPJ: ",oFont1)
		_cCGC	:= Substr(Posicione("SUS",1,xFilial("SUS")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"US_CGC"),1,2)+"."+Substr(Posicione("SUS",1,xFilial("SUS")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"US_CGC"),3,3)+"."+Substr(Posicione("SUS",1,xFilial("SUS")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"US_CGC"),6,3)+"/"+Substr(Posicione("SUS",1,xFilial("SUS")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"US_CGC"),9,4)+"-"+Substr(Posicione("SUS",1,xFilial("SUS")+_QUERY->UA_CLIENTE+_QUERY->UA_LOJA,"US_CGC"),13,2)

		oPrint:Say(nLin    ,0300,_cCGC,oFont)
		oPrint:Say(nLin    ,1200,"FONE VEND: ",oFont1)
		//oPrint:Say(nLin    ,1500,"("+TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_ZZDDD")) + ") "+ TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_TEL")),oFont)
		oPrint:Say(nLin    ,1500,"("+TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_ZZDDD")) + ") "+ TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_TEL")),oFont)

		nLin += 50
		oPrint:Say(nLin    ,0100,"EMAIL: ",oFont1)
		oPrint:Say(nLin    ,0300,TRIM (Posicione("SU5",1,xFilial("SU5")+_QUERY->UA_CODCONT,"U5_EMAIL")),oFont)
		oPrint:Say(nLin    ,1200,"EMAIL VEND: ",oFont1)
		oPrint:Say(nLin    ,1500,TRIM (Posicione("SA3",1,xFilial("SA3")+_QUERY->UA_VEND,"A3_EMAIL")),oFont)

	EndIf	


	If _cFlag <> "2"
		nLin += 100
		oPrint:Box(nLin,0050,nLin,2300) 
		nLin += 50
		oPrint:Say(nLin,0100,"ENTREGA PARCIAL:",oFont)
		oPrint:Say(nLin,1200,"GRAVAÇÃO:",oFont)
		If TRIM(_QUERY->UA_ZZENTPA) == "1"
			oPrint:Say(nLin,0500,"SIM",oFont)
		Else
			oPrint:Say(nLin,0500,"NAO",oFont)
		EndIf
		If TRIM(_QUERY->UA_ZZTEMGR) == "1"
			oPrint:Say(nLin,1600,"SIM",oFont)
		Else
			oPrint:Say(nLin,1600,"NAO",oFont)
		EndIf	
		nLin += 150
		//oPrint:Box(nLin,0050,nLin,2000)
		//nLin += 50
		oPrint:Say(nLin,0100,"Atendendo sua solicitação, apresentamos a cotação para os itens abaixo relacionados: ",oFont5)
		nLin += 50
		oPrint:Box(nLin,0050,nLin,2300)
		nLin += 50


		oPrint:Say(nLin,0100,"ITEM",oFont)
		oPrint:Say(nLin,0200,"CODIGO",oFont)
		oPrint:Say(nLin,0460,"DESCRICAO",oFont)
		oPrint:Say(nLin,1210,"NCM",oFont)
		oPrint:Say(nLin,1360,"QTD",oFont)
		oPrint:Say(nLin,1460,"VLR.UNIT",oFont)
		oPrint:Say(nLin,1640,"ICM",oFont)
		oPrint:Say(nLin,1740,"VLR.TOTAL",oFont)
		oPrint:Say(nLin,1960,"IPI",oFont)
		oPrint:Say(nLin,2100,"PRAZO",oFont)

		nLin += 50
		oPrint:Say(nLin,1500,"R$",oFont)
		oPrint:Say(nLin,1790,"R$",oFont)
		oPrint:Say(nLin,1640,"%",oFont) 
		oPrint:Say(nLin,1960,"%",oFont)
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

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MontaTela ºAutor  ³ Newton Reca Alves º Data ³  02/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta o Relatorio. RODAPE                                  º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaTela2(_cStatusRel)


	_cFlag	:= _cStatusRel

	//If _cFlag =="C"

	//oPrint:StartPage() // Inicia uma nova página
	//EndIf


	//oPrint:Box(50,50,500,3300) //SUPERIOR TOTAL
	//oPrint:Box(50,1150,500,2150) //SUPERIOR MEIO
	//oPrint:Box(550,50,1900,3300) //MEIO TOTAL
	//oPrint:Box(1950,50,2400,3300) //INFERIOR TOTAL




	nLin := 2700

	oPrint:Box(nLin,0050,nLin,2300) //MEIO CABECALHO TOTAL
	nLin += 020
	oPrint:Say(nLin,0100,"OBSERVAÇÕES:",oFont1)
	oPrint:Say(nLin,0400,Substr(_cPV,1,100),oFont4)
	nLin += 020
	oPrint:Say(nLin,0400,Substr(_cPV,101,100),oFont4)
	nLin += 020
	oPrint:Say(nLin,0400,Substr(_cNF,1,100),oFont4)
	nLin += 020
	oPrint:Say(nLin,0400,Substr(_cNF,101,100),oFont4)
	nLin += 020
	oPrint:Box(nLin,0050,nLin,2300) //MEIO CABECALHO TOTAL
	nLin += 020

    //10/07/2018 Leonardo Bergamasco Chamado 28 - 9HH-5YX-GBU4 - Removido mensagem do Orçamento
    /*//---------------------------------------------------------------------------------------\\
	oPrint:Say(nLin,0100,"PRAZO DE ENTREGA:",oFont1)
	oPrint:Say(nLin,0700,"Nosso prazo de entrega é de até 25 dias para produtos nacionais e até 120 dias para produtos importados a contar da ",oFont4)
	nLin += 050
	oPrint:Say(nLin,0700,"data de aprovação do seu pedido pela Novel.",oFont4)
	*///---------------------------------------------------------------------------------------\\

	nLin += 050
	oPrint:Say(nLin,0100,"CONDIÇÃO DE PAGAMENTO:",oFont1)
	oPrint:Say(nLin,0700, AllTrim( Posicione( "SE4", 01, xFilial( "SE4" ) + _cCond, "E4_DESCRI" ) ) + " - sujeito a análise de crédito",oFont4)

	nLin += 050
	oPrint:Say(nLin,0100,"FRETE:",oFont1)
	If TRIM(_cFrete) == "C"
		oPrint:Say(nLin,0700,"CIF",oFont4)
	ElseIf TRIM(_cFrete) == "F"
		oPrint:Say(nLin,0700,"FOB",oFont4)
	Endif

	nLin += 050
	oPrint:Say(nLin,0100,"IMPOSTOS:",oFont1)
	oPrint:Say(nLin,0700,"Os valores cotados incluem o ICMS/PIS/Cofins calculados de acordo com a alíquota vigente nesta data.",oFont4)

	nLin += 050
	oPrint:Say(nLin,0700,"Havendo variações positivas ou negativas nas alíquotas dos impostos e taxas, as mesmas serão repassadas aos preços.",oFont4)

	nLin += 050
	oPrint:Say(nLin,0100,"FATURAMENTO MÍNIMO:",oFont1)
	oPrint:Say(nLin,0700,AllTrim(GetMv("ZZ_TMK12_V")),oFont4)

	nLin += 050
	oPrint:Say(nLin,0100,"VALIDADE DESTA OFERTA:",oFont1)
	oPrint:Say(nLin,0700,AllTrim(GetMv("ZZ_TMK12_D"))+" a contar da data de revisão.",oFont4)

	nLin += 050
	//Linha 1 do campo Observação
	oPrint:Say(nLin,0100,GetNewPar("7V_TMK12O1",""), oFont4)

	nLin += 050
	//Linha 2 do campo Observação
	oPrint:Say(nLin,0100,GetNewPar("7V_TMK12O2",""),oFont4)

	nLin += 050
	//Linha 3 do campo Observação
	oPrint:Say(nLin,0100, GetNewPar("7V_TMK12O3",""),oFont4)

	nLin += 050
	//Linha 4 do campo Observação
	oPrint:Say(nLin,0100, GetNewPar("7V_TMK12O4",""),oFont4)

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RunPOL   º Autor  ³ Newton Reca Alves º Data ³  02/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de Processamento                                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunPOL()

	local nItem		:= 0
	local cQuery	:= ""

	cQuery	+=	"SELECT "
	cQuery	+=	"	* "
	cQuery	+=	"FROM "
	cQuery	+=	"	" + retSqlName("SUB") + " SUB "
	cQuery	+=	"	INNER JOIN " + retSqlName("SUA") + " SUA ON "
	cQuery	+=	"		UA_FILIAL = '" + xFilial("SUA") + "' AND UA_NUM = UB_NUM AND SUA.D_E_L_E_T_ = ' ' "
	cQuery	+=	"WHERE "
	cQuery	+=	"	UB_FILIAL = '"	+ xFilial("SUB")	+ "' AND "
	cQuery	+=	"	UB_NUM = '"		+ mv_par01			+ "' AND "
	cQuery	+=	"	SUB.D_E_L_E_T_ = ' ' "

	TCQUERY cQuery NEW ALIAS "_query"
	Tcsqlexec(cQuery)

	DBSelectArea("_query")
	DBGoTop()

	_cFrete		:= _QUERY->UA_TPFRETE
	_cCond		:= _QUERY->UA_CONDPG
	_nValMerc	:= _QUERY->UA_VALMERC
	_nValTotal	:= _QUERY->UA_VLRLIQ
	_cNF		:= _QUERY->UA_ZZOBS1  //_QUERY->UA_ZZNOTES
	_cPV		:= _QUERY->UA_ZZOBS2  //_QUERY->UA_ZZNOTES1
	_nTFRETE    := _QUERY->UA_FRETE  //Frete

	MontaTela1()

	//nLin += 50

	_nIPI		:= 0
	_nTIPI		:= 0
	_nTUnit		:= 0
	_nTTotal	:= 0
	//_nFrete		:= 0

	MaFisEnd()	      

	//If Substr(_QUERY->UA_CLIENTE,1,1)=="A" .OR. Substr(_QUERY->UA_CLIENTE,1,1)=="B" .OR. Substr(_QUERY->UA_CLIENTE,1,1)=="I" .OR. Substr(_QUERY->UA_CLIENTE,1,1)=="F" .OR. Substr(_QUERY->UA_CLIENTE,1,1)=="R"

	If Substr(_QUERY->UA_CLIENTE,1,1)!= "P" 

		SA1->( dbSeek( xFilial('SA1') + _QUERY->UA_CLIENTE + _QUERY->UA_LOJA ) ) 


		MaFisIni(	_QUERY->UA_CLIENTE,;// 1-Codigo Cliente/Fornecedor
		_QUERY->UA_LOJA,;	// 2-Loja do Cliente/Fornecedor
		"C",;				// 3-C:Cliente , F:Fornecedor
		"N",;				// 4-Tipo da NF
		SA1->A1_TIPO,;		// 5-Tipo do Cliente/Fornecedor
		Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461" )

	Else

		SUS->(dbSeek(xFilial('SUS') + _QUERY->UA_CLIENTE + _QUERY->UA_LOJA))


		MaFisIni(	_QUERY->UA_CLIENTE,;// 1-Codigo Cliente/Fornecedor
		_QUERY->UA_LOJA,;	// 2-Loja do Cliente/Fornecedor
		"C",;				// 3-C:Cliente , F:Fornecedor
		"N",;				// 4-Tipo da NF  
		"F",;	        	// 5-Tipo do Cliente/Fornecedor  
		MaFisRelImp("MTR700",{"SUA","SUB"}),;     // 6-Relacao de Impostos que suportados no arquivo
		Nil,;   //7
		Nil,;   //8
		"SB1",; //9
		"TMKA271",;   //10    
		Nil,;        //11
		Nil,;            //12
		_QUERY->UA_CLIENTE,; //13 Codigo e Loja do Prospect
		SUS->US_GRPTRIB,)    //14 Grupo Cliente
	Endif

	nItem := 0

	While !eof()    


		nLin += 70
		_cCotacao	:= _QUERY->UB_NUM
		_nIPI		:= 0
		_nTUnit		:= 0

		MaFisAdd(	_QUERY->UB_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
		_QUERY->UB_TES,;	  		// 2-Codigo do TES ( Opcional )
		_QUERY->UB_QUANT,;	   	// 3-Quantidade ( Obrigatorio )
		_QUERY->UB_VRUNIT,;   	// 4-Preco Unitario ( Obrigatorio )
		_QUERY->UB_VALDESC,;  	// 5-Valor do Desconto ( Opcional )
		"",;	 			  	// 6-Numero da NF Original ( Devolucao/Benef )
		"",;					// 7-Serie da NF Original ( Devolucao/Benef )
		0,;	 					// 8-RecNo da NF Original no arq SD1/SD2
		0,;						// 9-Valor do Frete do Item ( Opcional )
		0,;						// 10-Valor da Despesa do item ( Opcional )
		0,;						// 11-Valor do Seguro do item ( Opcional )
		0,;						// 12-Valor do Frete Autonomo ( Opcional )
		_QUERY->UB_VLRITEM,;	// 13-Valor da Mercadoria ( Obrigatorio )
		0	)					// 14-Valor da Embalagem ( Opiconal )

		nItem++

		oPrint:Say(nLin,0100,_QUERY->UB_ITEM,oFont4)
		oPrint:Say(nLin,0190,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_COD"),1,50),oFont3)
		oPrint:Say(nLin,0450,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_DESC"),1,45),oFont3)
		oPrint:Say(nLin,1210,SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_POSIPI"),1,50),oFont3)
		oPrint:Say(nLin,1330,transform(_QUERY->UB_QUANT,"@E 999,999.99"),oFont3)
		oPrint:Say(nLin,1440,transform(_QUERY->UB_VRUNIT,"@E 999,999.99"),oFont3)
		oPrint:Say(nLin,1580,transform(MaFisRet(nItem,"IT_ALIQICM"),"@E 9,999,999.99"),oFont3)
		oPrint:Say(nLin,1740,transform(_QUERY->UB_VLRITEM,"@E 9,999,999.99"),oFont3)
		If TRIM(POSICIONE("SF4",1,xFilial("SF4")+_QUERY->UB_TES,"F4_IPI")) == "S"
			oPrint:Say(nLin,1950,transform(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_IPI"),"@E 999.99"),oFont3)
		Else
			oPrint:Say(nLin,1950,transform(_nIPI,"@E 999,999.99"),oFont3)
		EndIf
		//oPrint:Say(nLin,2100,DTOC(STOD(_QUERY->UB_ZZDATEN)),oFont3)
		//If TRIM(POSICIONE("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_ORIGEM")) == "0"
		//_cDTENT	:= "ATÉ 25 DIAS"
		//Else
		//_cDTENT	:= "ATÉ 120 DIAS"
		//EndIf

		//_cDTENT	:= DTOC(STOD(_QUERY->UB_ZZDATEN))
		_cDTENT	:= DTOC(STOD(_QUERY->UB_ZZDATEN))

		oPrint:Say(nLin,2100,_cDTENT,oFont3)

		If TRIM(POSICIONE("SF4",1,xFilial("SF4")+_QUERY->UB_TES,"F4_IPI")) == "S"
			_nIPI		:= _QUERY->UB_VLRITEM * (Posicione("SB1",1,xFilial("SB1")+_QUERY->UB_PRODUTO,"B1_IPI")) / 100
			_nTIPI		+= _nIPI
		Else
			_nIPI		:= 0
			_nTIPI		+= _nIPI
		EndIf

		_nTUnit		+= _QUERY->UB_VLRITEM
		_nTTotal	+= _nTUnit

		DBSkip()

		If nLin>=2200 .and. !EOF()

			nLin += 80
			oPrint:Say(nLin,3000,"CONTINUA ----->",oFont4)
			//oPrint:EndPage()
			MontaTela2()  //SSILVA 20180112
			nPag++
			MontaTela1()
			//nLin := 800
		EndIf 


	EndDo

	MaFisEnd()

	nLin := 2400
	oPrint:Say(nLin,1400,"TOTAL SEM IPI:",oFont5)
	oPrint:Say(nLin,2000,"R$   " + transform(_nTTotal,"@E 99,999,999.99"),oFont5)
	nLin += 60
	oPrint:Say(nLin,1400,"IPI:",oFont5)
	oPrint:Say(nLin,2000,"R$   " + transform(_nTIPI,"@E 99,999,999.99"),oFont5)
	nLin += 60
	//Frete
	oPrint:Say(nLin,1400,"FRETE:",oFont5)
	oPrint:Say(nLin,2000,"R$   " + transform(_nTFRETE,"@E 99,999,999.99"),oFont2)
	nLin += 60
	// Fim Frete
	oPrint:Say(nLin,1400,"TOTAL PROPOSTA:",oFont5)
	oPrint:Say(nLin,2000,"R$   " + transform(_nTTotal+_nTIPI+_nTFRETE,"@E 99,999,999.99"),oFont5)
	nLin += 60


	MontaTela2("F") //SSILVA 20180112


	//fotos dos produtos
	DBCloseArea()
	TCQUERY cQuery NEW ALIAS "_query"
	Tcsqlexec(cQuery)

	DBSelectArea("_query")
	DBGoTop()
	MontaTela1("2") //SSILVA 20180112


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
			MontaTela2() 	//SSILVA 20180112
			MontaTela1("2") //SSILVA 20180112
			//nLin := 800
		EndIf 


	EndDo


	nPag++
	MontaTela2("F") 	//SSILVA 20180112


	DBCloseArea()

	oPrint:EndPage()
	//oPrint:Preview() 
	oPrint:Print()
	MS_FLUSH()

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³ CriaPerg ºAutor  ³ Newton Reca Alves  º Data ³  10/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ Criar Pergunta no SX1.                                     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriarPerg()


	aRegs	:={}
	cPerg	:= PADR(cPerg,6)

	_aMV_PAR01 := {}


	Aadd(_aMV_PAR01, "Informar o numedo da Cotacao             ")

	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01","Cotacao                       ","Cotacao                       ","Cotacao                       ","mv_ch1","C",06,0,0,"G","","SUA","","","mv_par01","","","","","","","","","","","","","","","","",_aMV_PAR01)


Return()

*Funcao**********************************************************************************************************

Static Function fFMinValid()

  Local nOfv := 0, cMsg := "", cAtual := "", cNew := "", IDmv, oGNew, lSave
  Local bOk := {|| lSave:=.T., oDlgCX:End() }
  Local bCancel:= {|| lSave:=.F., oDlgCX:End() }   
  
//  Local oFont12 := TFont():New('Arial',,-12,,.T.)
  Local oFont14 := TFont():New('Arial',,-14,,.T.)
  
  Local _cUsuario := Upper(AllTrim(U_MYCFG02("TMK000017","001","P")))
  
  If ! Upper(AllTrim(CUSERNAME)) $ _cUsuario
    APMsgStop("Usuario sem permissao para essa operacao","MYTMK12 - TMK000017/001P")
    Return  
  EndIf
  
  nOfv := Aviso("PROPOSTA COMERCIAL","Ajuste de parametros informativo para a PROPOSTA COMERCIAL: 1-Faturamento minimo a ser impresso; 2-Validade desta oferta a ser impressa",{"1.FMinimo","2.Validade","Cancelar"},3,"Novel")
  
  If nOfv > 0 .and. nOfv < 2
    cMsg := "Informativo sobre o FATURAMENTO MINIMO para a PROPOSTA COMERCIAL"
    Eval({|| IDmv := "ZZ_TMK12_V" , cAtual := AllTrim(GetMv(IDmv)), cNew   := space(100) })
  ElseIf nOfv > 1 .and. nOfv < 3
    cMsg := "Informativo sobre a VALIDADE DA OFERTA para a PROPOSTA COMERCIAL"
    Eval({|| IDmv := "ZZ_TMK12_D" , cAtual := AllTrim(GetMv(IDmv)), cNew   := space(100) })
  EndIf
  
  If ! Empty(cMsg)
    While Empty(cNew)
      Define MsDialog oDlgCX Title cMsg From 0,0 To 200, 500 Of oMainWnd Pixel
        TSay():New(54,05,{|| "Conteudo atual.:"  },oDlgCX,, oFont14 ,,,,.T.,CLR_BLACK,CLR_WHITE,500,10)
        TGet():New(50,70,{|u| if(PCount()>0,cAtual:=u,cAtual)},oDlgCX,160,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cAtual")
        TSay():New(74,05,{|| "Novo conteudo.:"  },oDlgCX,, oFont14 ,,,,.T.,CLR_BLACK,CLR_WHITE,500,10)
        oGNew := TGet():New(70,70,{|u| if(PCount()>0,cNew:=u,cNew)},oDlgCX,160,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cNew")
      Activate MsDialog oDlgCX On Init EnchoiceBar(oDlgCX, bOk , bCancel) Centered
    
      If lSave .and. (!Empty(cNew))
        PUTMV(IDmv, AllTrim(cNew))
      Else
        cNew := "FECHAR"
      EndIf
    EndDo
  EndIf

Return
