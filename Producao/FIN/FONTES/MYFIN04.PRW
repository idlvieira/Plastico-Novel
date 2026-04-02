#INCLUDE "MYFIN04.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE CRLF CHR(13)+CHR(10)
#DEFINE PREFIXO		1
#DEFINE TITULO			2
#DEFINE PARCELA		3                   
#DEFINE COD_CLI		4
#DEFINE LOJA			5
#DEFINE NOME_CLI		6                 
#DEFINE DT_EMIS		7
#DEFINE DT_VENC		8
#DEFINE VAL_TIT		9
#DEFINE COM_EMISS		10
#DEFINE COM_BAIXA		11
#DEFINE VAL_BASE		12
#DEFINE PERC			13
#DEFINE VAL_COMIS		14
#DEFINE PARC			15

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MYFIN04	³ Autor ³ Daniel Tadashi Batori ³ Data ³ 29.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Previs„o de Comiss”es										        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR610(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MYFIN04()

Local oReport

AtuSX1()
If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return FINR610R3() // Executa versão anterior do fonte
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Daniel Batori         ³ Data ³ 28.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do layout do Relatorio									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport  
Local oSection1
Local cPictVal

oReport := TReport():New("FINR610N",STR0003,"FIN610N", {|oReport| ReportPrint(oReport)},STR0001+STR0002)

pergunte("FIN610",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para parametros                         ³
//³ mv_par01         // Do Vendedor                              ³
//³ mv_par02         // At‚ o Vendedor                           ³
//³ mv_par03         // Vencto de                                ³
//³ mv_par04         // Vencto At‚                               ³
//³ mv_par05         // Qual Moeda                               ³
//³ mv_par06         // Da emiss„o                               ³
//³ mv_par07         // At‚ a emiss„o                            ³
//³ mv_par08         // Comiss„o Zero                            ³
//³ mv_par09         // Considera P.Venda                        ³
//³ mv_par10         // Abate IR Comiss                          ³
//³ mv_par11         // Outras Moedas                            ³
//³ mv_par12         // Salta Pagina por Vendedor                ³
//³ mv_par13         // Nome cliente									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPictVal	:= PesqPict("SE1","E1_VLCRUZ")

oSection1 := TRSection():New(oReport,STR0024,{},) //"Registros"
TRCell():New(oSection1,"E1_PREFIXO","SE1",STR0025,,,.F.,) //"PRF"
TRCell():New(oSection1,"E1_NUM","SE1",	STR0026+CRLF+STR0027,,,.F.,)//"TITULO" "PEDIDO"
TRCell():New(oSection1,"E1_PARCELA","SE1",STR0028,,3,.F.,)//"PRC"
TRCell():New(oSection1,"E1_CLIENTE"	,"SE1",STR0029+CRLF+STR0030,,,.F.,)//"CODIGO" "CLIENTE"
TRCell():New(oSection1,"E1_LOJA","SE1",STR0031,,,.F.,) //"LJ"
TRCell():New(oSection1,"A1_NOME","SA1",STR0032,,,.F.,) //"NOME"
TRCell():New(oSection1,"E1_EMISSAO","SE1",STR0033+CRLF+STR0034,,,.F.,) //"DATA DE""EMISSAO"
TRCell():New(oSection1,"E1_VENCREA","SE1",STR0035+CRLF+STR0036,,,.F.,) //"DATA""VENCTO"
TRCell():New(oSection1,"E1_VLCRUZ","SE1",STR0037+CRLF+STR0038,,,.F.,) //"VALOR""TITULO"
TRCell():New(oSection1,"VL_EMISS",,STR0039+CRLF+STR0040,cPictVal,13,.F.,) //"COMISSAO""P/EMISSAO"
TRCell():New(oSection1,"VL_BAIXA",,STR0039+CRLF+STR0041,cPictVal,13,.F.,) //"COMISSAO""P/BAIXA"
TRCell():New(oSection1,"VL_BASE",,STR0042+CRLF+STR0041,cPictVal,13,.F.,) //"VALOR BASE""P/BAIXA"
TRCell():New(oSection1,"PERC_COMI",,STR0043+CRLF+STR0044,"999.99",5,.F.,)//"%COMIS""TOTAL"
TRCell():New(oSection1,"VL_COMIS",,STR0045+CRLF+STR0046,cPictVal,13,.F.,) //"VALOR TOTAL""DA COMISSAO"
TRCell():New(oSection1,"PARC",,STR0047,,1,.F.,) //"P/T"

oSection1:Cell("E1_VLCRUZ"):SetHeaderAlign("RIGHT")
oSection1:Cell("VL_EMISS"):SetHeaderAlign("RIGHT")
oSection1:Cell("VL_BAIXA"):SetHeaderAlign("RIGHT")
oSection1:Cell("VL_BASE"):SetHeaderAlign("RIGHT")
oSection1:Cell("PERC_COMI"):SetHeaderAlign("RIGHT")
oSection1:Cell("VL_COMIS"):SetHeaderAlign("RIGHT")

oSection1:SetHeaderSection(.F.)

oReport:SetLandScape()

Return oReport                                                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Daniel Batori          ³ Data ³22.08.06	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local aDados[15]

Local cTitulo

LOCAL aCampos :={}
LOCAL cVendAnt:=Space(6)
LOCAL nComissao:=0.00
LOCAL nValTit :=0.00
LOCAL nComEnt :=0.00
LOCAL nComVen :=0.00
LOCAL nValBas :=0.00
LOCAL nPorc   :=0.00
LOCAL nVendComis :=0.00
LOCAL nTotTit :=0.00
LOCAL nTotEnt :=0.00
LOCAL nTotVen :=0.00
LOCAL nTotBas :=0.00
LOCAL nTotComis :=0.00
LOCAL lFirst:=.T.
LOCAL lPVen := .F.		// Flag diferenciador de pedido de venda
LOCAL aParcelas := {}	// Array das comissoes (geral)
LOCAL aParcItem := {}	// Array das comissoes (item)	
LOCAL nVendSC5 := 0		// Codigo do vendedor no pedido
LOCAL nComiSC5 := 0		// Percentual Comissao no pedido
LOCAL nComiSC6 := 0		// Percentual comissao no item do pedido
LOCAL nPerComE := 0		// Percentual comissao na emissao vendedor
LOCAL nPerComB	:= 0		// Percentual comissao na Baixa vendedor
LOCAL nRegSC6	:= 0		// Registro do item de pedido
LOCAL nQtdItem := 0		// Quantidade de produtos nao entregues
LOCAL nPercItem:= 0		// Percentual a ser usado (pedido ou item)
LOCAL nVlTotPed:= 0		// Valor total do pedido nao entregue
LOCAL nIrEnt	:= 0		// Ir na Emissao
LOCAL nIrVen	:= 0		// Ir na Baixa
LOCAL nVendIr	:= 0		// total de Ir do vendedor
LOCAL nTotIrE	:= 0		// Total geral de IR na emissao
LOCAL nTotIrB	:= 0		// Total geral de IR na Baixa
LOCAL nTotIrVen:= 0		// Total geral de IR do relatorio
LOCAL nTotPorc := 0		// Percentual medio de comissoes do relatorio
LOCAL nTotCount:= 0
LOCAL nCount	:= 0
LOCAL nTotAbat := 0
LOCAL aTam		:= {}
LOCAL aColu		:= {}
LOCAL nValMinRet := 0   // Valor minimo para retencao do IR
Local nMoedaBco :=1, dDataConv
Local cTipo
Local cParcela
Local cPrefixo
Local cNum
Local cTipoFat
Local nBaseCom
Local nValorFat
Local nCond
Local JX
Local nIrrItem := 0
Local	nInsItem := 0
Local	nPisItem := 0
Local nCofItem := 0
Local nCslItem := 0
Local nIcmItem := 0
Local nIssItem := 0
Local nSolItem := 0
Local nRecOri	:= 0
Local nItem		:= 0
Local nTotImp	:= 0
Local nVendTit
Local nRecPrinc, nx1, ny1
Local cChaveSE5, cIndexSE5  

// Se a comissão será definida na liquidação ou na baixa (1 = Liq, 2 = Baixa)
Local lComiLiq 	:= SuperGetMv("MV_COMILIQ",,"1") == "2" 

Private nDecs   := MsDecimais(mv_par05)
Private nIndexSE5
Private aVendedor  

// criação do indice temporario pra busca do numero da fatura
//***************************************
cChaveSE5  := "E5_FILIAL + E5_FATURA"
dbSelectArea("SE5")
cIndexSE5 := CriaTrab(nil,.f.)	
IndRegua("SE5",cIndexSE5,cChaveSE5,,,OemToAnsi(STR0006))  //"Selecionando Registros..."
nIndexSE5 := RetIndex("SE5")
dbSelectArea("SE5")
#IFNDEF TOP
	dbSetIndex(cIndexSE5+OrdBagExt())
#ENDIF
dbSetOrder(nIndexSE5+1)
dbGoTop()
//***************************************


oSection1:Cell("E1_PREFIXO"):SetBlock( { || aDados[PREFIXO] })
oSection1:Cell("E1_NUM"):SetBlock( { || aDados[TITULO] })
oSection1:Cell("E1_PARCELA"):SetBlock( { || aDados[PARCELA] })
oSection1:Cell("E1_CLIENTE"):SetBlock( { || aDados[COD_CLI] })
oSection1:Cell("E1_LOJA"):SetBlock( { || aDados[LOJA] })
oSection1:Cell("A1_NOME"):SetBlock( { || aDados[NOME_CLI] })
oSection1:Cell("E1_EMISSAO"):SetBlock( { || aDados[DT_EMIS] })
oSection1:Cell("E1_VENCREA"):SetBlock( { || aDados[DT_VENC] })
oSection1:Cell("E1_VLCRUZ"):SetBlock( { || aDados[VAL_TIT] })
oSection1:Cell("VL_EMISS"):SetBlock( { || aDados[COM_EMISS] })
oSection1:Cell("VL_BAIXA"):SetBlock( { || aDados[COM_BAIXA] })
oSection1:Cell("VL_BASE"):SetBlock( { || aDados[VAL_BASE] })
oSection1:Cell("PERC_COMI"):SetBlock( { || aDados[PERC] })
oSection1:Cell("VL_COMIS"):SetBlock( { || aDados[VAL_COMIS] })
oSection1:Cell("PARC"):SetBlock( { || aDados[PARC] })

oReport:OnPageBreak({ ||	oSection1:SetHeaderSection(.T.), ;
									aDados[TITULO] := " " , ;
									oSection1:PrintLine(), ;
									oSection1:SetHeaderSection(.F.) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("E1_VEND1")
AADD(aCampos,{ "CODIGO" ,"C",aTam[1],aTam[2] } )
AADD(aCampos,{ "CHAVE"  ,"C",10,0 } )
AADD(aCampos,{ "NVEND"  ,"N",01,0 } )
AADD(aCampos,{ "PVEND"  ,"C",01,0 } )
AADD(aCampos,{ "CHVFAT" ,"N",10,0 } )
AADD(aCampos,{ "RECPRINC","N",10,0 } )

aTam := TamSX3("E1_CLIENTE")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq,"CODIGO+CHAVE",,,OemToAnsi(STR0023))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo := oReport:Title() + STR0022 + GetMV("MV_MOEDA"+Str(mv_par05,1))
oReport:SetTitle(cTitulo)

dbSelectarea("TRB")
dbSetOrder(1)
dbGoTop()

dbSelectarea("SE1")
dbsetOrder(7)

oReport:SetMeter(SE1->(Reccount()))

If MV_PAR14 == 1
	Fr610ProcP(@oReport)
Else
	Fr610ProcF(@oReport)
Endif

dbSelectarea("TRB")
dbGotop()

oReport:SetMeter(TRB->(Reccount()))

oSection1:Init()
aFill(aDados,nil)

While !Eof()
	
	lFirst  := .T.
	cVendAnt:= CODIGO
	nCount	:= 0
	While !Eof() .and. cVendAnt == CODIGO

		oReport:IncMeter()
		
		nComissao := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a previsao sera calculada por titulo ja gerado   ³
		//³ ou pedido de vendas.                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->PVEND == "N"		
			dbSelectArea("SE1")
			dbSetOrder(1)
			If TRB->CHVFAT > 0
				dbGOTO(TRB->CHVFAT)
			Else              
				dbGoTo(Val(TRB->CHAVE))
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo Bases, valores e percentuais de comissao.            ³
			//³ Constituicao de aBases{} retornada por FA440COMIS()          ³
			//³ Coluna 01    Vendedor        	       		                 ³
			//³ Coluna 02    Valor do Titulo    		                       ³
			//³ Coluna 03    Base Comissao Emissao			                    ³
			//³ Coluna 04    Base Comissao Baixa	                          ³
			//³ Coluna 05    Comissao Emissao										  ³
			//³ Coluna 06    Comissao Baixa                                  ³
			//³ Coluna 07    % Total da comissao                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
			aBases   := Fa440Comis(SE1->(Recno()),.F.,.T.,,,TRB->RECPRINC)
			nBases 	:= aScan(aBases,{|x| x[1] == TRB->CODIGO })

			SE3->( dbSetOrder(3) )			

			If 	TRB->CHVFAT > 0 .And. aBases[nBases][7] == 0 .And.;	// Existe mais de um percentual de comissao (comissao por produto)
				!SE3->( MsSeek( xFilial("SE3") + aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) ) ) // Nao eh comissao realizada
				// Recalcula bases pelo total da nota de saida, sem considerar parcelas geradas.
				aBases := Fa440Comis(SE1->(Recno()),.F.,.T.,,.F./*Nao calcula por parcelas*/)
			EndIf	

			If TRB->CHVFAT > 0
				dbGoTo(Val(TRB->CHAVE))
			Endif
			If nBases = 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso vendedor n„o seja encontrado...           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("TRB")
				dbSkip()
				LOOP
			Endif
			aBases[nBases][2]	:=	SE1->E1_VLCRUZ
			If TRB->CHVFAT > 0
				aBases[nBases][4] := SE1->E1_VALOR
				If aBases[nBases][7] > 0
					aBases[nBases][6] := SE1->E1_VALOR * (aBases[nBases][7]/100)
				EndIf	
			Endif
			cChaveSE3 := aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
			cTipo 	 := SE1->E1_TIPO
			cParcela	 := SE1->E1_PARCELA
			
			dbSelectArea("SE1")
			aAreaSE1 := GetArea()
			dbGoto(TRB->RECPRINC)			
			nBaseCom	 := SE1->&("E1_BASCOM"+Str(TRB->NVEND,1)) // Utilizado para estornar a base de comissao do titulo
			nComissao := (SE1->&("E1_COMIS"+Str(TRB->NVEND,1))/100)*nBaseCom // Utilizado para estornar o valor da comissao do titulo
			RestArea(aAreaSE1)
			
			If !Empty(SE1->E1_FATURA) .And. AllTrim(SE1->E1_FATURA) != "NOTFAT"
		        cTipoFat	:= SE1->E1_TIPOFAT
  				// Localiza o titulo de fatura, pois no SE3 eh gerado o titulo de fatura
				// para verificar as comissoes que ja foram pagas.
	    	    SE1->(MsSeek(xFilial("SE1")+E1_FATPREF+E1_FATURA)) // Localiza o titulo de fatura
	            cPrefixo := SE1->E1_PREFIXO
		        cNum	   := SE1->E1_NUM
        	    // Processar todas as parcelas da fatura gerada e verificar se a comissao
            	// para a parcela nao foi paga.
		        While xFilial("SE1")+SE1->(E1_PREFIXO+E1_NUM) == xFilial("SE1")+cPrefixo+cNum .And.;
    	        		SE1->(!Eof())
					If SE1->E1_TIPO == cTipoFat
	   	       			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			            //³ Verificar comissoes ja pagas                                 ³
		            	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    	        	cChaveSE3 := aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
	        	    	cTipo 	 := SE1->E1_TIPO
						cParcela	 := SE1->E1_PARCELA
						nValorFat := SE1->E1_VLCRUZ
	            		FA610ComPg(@aBases,cChaveSE3,nBases,cTipo,cParcela,nValorFat,nBaseCom,nComissao)
		            Endif	
    	        	SE1->(DbSkip())
        	    End
            	dbSelectArea("SE1")
				dbSetOrder(1)
				dbGOTO(Val(TRB->CHAVE))
			Else
				FA610ComPg(@aBases,cChaveSE3,nBases,cTipo,cParcela,SE1->E1_VLCRUZ,nBaseCom,nComissao)
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso percentual de comissao seja retornado == a zero, devo   ³
			//³ calcular a media (Faturamento com comissao no item <> percen-³
			//³ tual do vendedor)                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aBases[nBases,7] == 0
				aBases[nBases,7] := (((aBases[nBases,5]+aBases[nBases,6])*100)/aBases[nBases,2])
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime o Vendedor caso possa imprimir Comiss„o Zero ou      ³
			//³ exista alguma comiss„o para o Vendedor                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par08 == 1 .or. aBases[nBases,6] != 0 .Or. aBases[nBases,5] != 0 
				If lFirst
					dbSelectArea("SA3")
					dbSeek(cFilial+TRB->CODIGO)

					oReport:PrintText( PadR(STR0009 + TRB->CODIGO,16) + STR0010 + SA3->A3_NOME ) //"CODIGO : ""NOME : "
					oReport:SkipLine()

					dbSelectArea("TRB")
					lFirst := .F.
				Endif
				dbSelectArea("SE1")
				dbSetOrder(1)
				dbGOTO(Val(TRB->CHAVE))
				
				If cPaisLoc == "BRA"
				   nMoedaBco := 1
				   dDataConv := dDataBase
				Else
				   dDataConv := SE1->E1_EMISSAO
				EndIf

    			nComissao := xMoeda(aBases[nBases,5] + aBases[nBases,6],nMoedaBco,mv_par05,dDataConv,nDecs+1)
    			aBases[nBases,2] := xMoeda(aBases[nBases,2],nMoedaBco,mv_par05,dDataConv,nDecs+1)
    			aBases[nBases,4] := xMoeda(aBases[nBases,4],nMoedaBco,mv_par05,dDataConv,nDecs+1)
    			aBases[nBases,5] := xMoeda(aBases[nBases,5],nMoedaBco,mv_par05,dDataConv,nDecs+1)
    			aBases[nBases,6] := xMoeda(aBases[nBases,6],nMoedaBco,mv_par05,dDataConv,nDecs+1)

				aDados[PREFIXO]	:= E1_PREFIXO
				aDados[TITULO]		:= E1_NUM
				aDados[PARCELA]	:= E1_PARCELA
				aDados[COD_CLI]	:= E1_CLIENTE
				aDados[LOJA]		:= E1_LOJA

				dbSelectArea("SA1")
				dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
				aDados[NOME_CLI]	:= IF(mv_par13 == 1,SA1->A1_NREDUZ,SA1->A1_NOME)
				dbSelectArea("SE1")

				aDados[DT_EMIS]	:= E1_EMISSAO
				aDados[DT_VENC]	:= E1_VENCREA
				aDados[VAL_TIT]	:= aBases[nBases,2]
				aDados[COM_EMISS]	:= aBases[nBases,5]
				aDados[COM_BAIXA]	:= aBases[nBases,6]
				aDados[VAL_BASE]	:= aBases[nBases,4]
				aDados[PERC]		:= aBases[nBases,7]
				aDados[VAL_COMIS]	:= nComissao
				aDados[PARC]		:= "T"     // identificador de Titulo ou Pedido
				
				oSection1:PrintLine()
				aFill(aDados,nil)

            nValMinRet	:= GetMv( "MV_VLRETIR" )
				nValTit		+= aBases[nBases,2]
				nComEnt		+= aBases[nBases,5]
				nIrEnt		+= If(aBases[nBases,2] > nValMinRet,aBases[nBases,5] * (mv_par10/100),0)
				nComVen		+= aBases[nBases,6]
				nIrVen		+= If(aBases[nBases,2] > nValMinRet, aBases[nBases,6] * (mv_par10/100),0)
				nValBas		+= aBases[nBases,4]
				nPorc			+= aBases[nBases,7]
				nVendComis	+= nComissao
				nVendIr		+= If(aBases[nBases,2] > nValMinRet,(aBases[nBases,5]+aBases[nBases,6])* (mv_par10/100),0)
				nCount++
			EndIf
		Else
			// calculo das comissoes p/ pedido venda
			dbSelectArea("SC5")
			dbSetOrder(1)
			DbGoto(Val(TRB->CHAVE))
			//Fecho os dados fiscais de um pedido antes de carregar um novo pedido
			MaFisEnd()
			//Inicializo a funcao fiscal
			MaFisIni(C5_CLIENTE,;// 1-Codigo Cliente/Fornecedor
						C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
						IIf(C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
						C5_TIPO,;				// 4-Tipo da NF
						C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						"MATA461")

			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SC5->C5_NUM)
				While !Eof() .and. SC6->C6_NUM == SC5->C5_NUM
					nRecOri := 0
					If !Empty(SC6->C6_NFORI) .And. !Empty(SC6->C6_ITEMORI)
						SD1->(dbSetOrder(1))
						If SD1->(MSSeek(xFilial("SD1")+SC6->C6_NFORI+SC6->C6_SERIORI+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC6->C6_PRODUTO+SC6->C6_ITEMORI))
							nRecOri := SD1->(Recno())
						Endif	
					Endif

					MaFisAdd(C6_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
						C6_TES,;	   	// 2-Codigo do TES ( Opcional )
						C6_QTDVEN,;  	// 3-Quantidade ( Obrigatorio )
						C6_PRCVEN,;		  	// 4-Preco Unitario ( Obrigatorio )
						a410Arred(C6_QTDVEN*C6_PRCVEN,"D2_DESCON")-C6_VALOR,; 	// 5-Valor do Desconto ( Opcional )
						"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
						"",;				// 7-Serie da NF Original ( Devolucao/Benef )
						nRecOri,;					// 8-RecNo da NF Original no arq SD1/SD2
						0,;					// 9-Valor do Frete do Item ( Opcional )
						0,;					// 10-Valor da Despesa do item ( Opcional )
						0,;					// 11-Valor do Seguro do item ( Opcional )
						0,;					// 12-Valor do Frete Autonomo ( Opcional )
						C6_VALOR ,;			// 13-Valor da Mercadoria ( Obrigatorio )
						0)					// 14-Valor da Embalagem ( Opiconal )
						
					SC6->(DBSkip())
				Enddo
			Endif
			nComissao	:= 0
			nVlTotPed	:= 0
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SC5->C5_NUM)
				aParcelas	:= {}
				nVendSC5		:= SC5->(FieldPos("C5_VEND"+STR(TRB->NVEND,1)))
				nComiSC5		:= SC5->(FieldPos("C5_COMIS"+STR(TRB->NVEND,1)))
				nComiSC6		:= SC6->(FieldPos("C6_COMIS"+STR(TRB->NVEND,1)))
				dbSelectArea("SA3")
				dbSeek(xFilial("SA3")+SC5->(FieldGet(nVendsc5)))
				nPerComE		:= (SA3->A3_ALEMISS/100)
				nPerComB		:= (SA3->A3_ALBAIXA/100)
				dbSelectArea("SC6")
				nRegSC6 := Recno()
				// valor de nao entregues total no pedido
				bAcao:= {|| nVlTotPed += SC6->(C6_PRCVEN * (C6_QTDVEN - C6_QTDENT))}
				dbEval(bAcao,,{||!Eof() .and. SC6->C6_NUM == SC5->C5_NUM},,,.T.)
				dbGoto(nRegSC6)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Constituicao de aParcelas{}				                       ³
				//³ Coluna 01    Data Vencto da Parcela			                 ³
				//³ Coluna 02    Valor da Parcela			                       ³
				//³ Coluna 03    Valor Comissao Emissao		                    ³
				//³ Coluna 04    Valor Comissao Baixa                            ³
				//³ Coluna 05    Base da Baixa                                   ³
				//³ Coluna 06    % Total da comissao                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aParcelas := Condicao (nVlTotPed,SC5->C5_CONDPAG,,SC5->C5_EMISSAO)
				aEval(aParcelas,{|elem| aadd(elem,0),aadd(elem,0),aadd(elem,0),aadd(elem,0),aadd(elem,0)})
				dbSelectArea("SC6")
				nItem		:= 0
				nTotImp	:= 0
				While !Eof() .and. SC6->C6_NUM == SC5->C5_NUM
					nItem++
					If SC6->C6_QTDENT >= SC6->C6_QTDVEN .Or.;
						!Empty(SC6->C6_BLOQUEI)          .Or.;
						Left(SC6->C6_BLQ,1) $ "RS"
						dbskip()
						Loop
					Endif
					nQtdItem := SC6->(C6_QTDVEN - C6_QTDENT)  // Qtde nao entregue
					nBasItem := SC6->(C6_PRCVEN * nQtdItem) 	// Valor ref. nao entregue

					nIrrItem := 0
					nInsItem := 0
					nPisItem := 0
					nCofItem := 0
					nCslItem := 0
					nIcmItem := 0
					nIssItem := 0 
					nSolItem := 0

					If SuperGetMv("MV_COMISIR") == "N"
						nIrrItem := MafisRet(nItem, "IT_VALIRR") 
						nBasItem -= nIrrItem
					Endif
					If GetNewPar("MV_COMIINS","N") == "N"
						nInsItem := MafisRet(nItem, "IT_VALINS") 
						nBasItem -= nInsItem
					EndIf
					If GetNewPar("MV_COMIPIS","N") == "N"
						nPisItem := MafisRet(nItem, "IT_VALPIS") 
						nBasItem -= nPisItem
					EndIf
					If GetNewPar("MV_COMICOF","N") == "N"
						nCofItem := MafisRet(nItem, "IT_VALCOF") 
						nBasItem -= nCofItem
					EndIf
					If GetNewPar("MV_COMICSL","N") == "N"
						nCslItem := MafisRet(nItem, "IT_VALCSL") 
						nBasItem -= nCslItem
					EndIf
                                          
					// Calcula abatimento de ISS e ICMS da base da comissao do vendedor
					SF4->(dbSetOrder(1))
					SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
					If !(SF4->F4_ISS == "S")
						If ( SA3->A3_ICM == "N" )
							nIcmItem := MaFisRet(nItem, "IT_VALICM")
							nBasItem -= nIcmItem
						EndIf
					Else
						If ( SA3->A3_ISS == "N" )
							nIssItem := MaFisRet(nItem, "IT_VALISS")
							nBasItem -= nIssItem
						EndIf
					EndIf				
					If ( SA3->A3_ICMSRET == "N" )
						nSolItem := MaFisRet(nItem, "IT_VALSOL")
						nBasItem -= nSolItem
					EndIf

					nPercItem:= IIF(SC6->(FieldGet(nComiSC6))== 0,;
										 SC5->(FieldGet(nComiSC5)),	 ;	// Percentual no Pedido
										 SC6->(FieldGet(nComiSC6)))		// Percentual no Item
					aParcItem:= Condicao(nBasItem,SC5->C5_CONDPAG,,SC5->C5_EMISSAO)

					//valor dos impostos do pedido
					nTotImp := nIrrItem + nInsItem + nPisItem + nCofItem + nCslItem + nIcmItem + nIssItem + nSolItem

					dbSelectArea("SC6")
					For nCond := 1 to Len(aParcItem)
						aParcelas[nCond,3] += ((aParcItem[nCond,2] * (nPercItem/100)) * nPerComE)
						aParcelas[nCond,4] += ((aParcItem[nCond,2] * (nPercItem/100)) * nPerComB)
						aParcelas[nCond,5] += (aParcItem[nCond,2] * nPerComB)
						aParcelas[nCond,7] += (nTotImp / Len(aParcItem))
					Next
					dbskip()
				Enddo
				For nCond := 1 to	Len(aParcelas)
					aParcelas[nCond,6] += (((aParcelas[nCond,3]+aParcelas[nCond,4]) * 100) / (aParcelas[nCond,2] - aParcelas[nCond,7]))
					nComissao += (aParcelas[nCond,3]+aParcelas[nCond,4])
				Next

				// impressao das previsoes de comiss do ped venda
				If ( nComissao != 0 )
					If lFirst
						oReport:PrintText( PadR(STR0009 + TRB->CODIGO,16) + STR0010 + SA3->A3_NOME )
						oReport:SkipLine()
						dbSelectArea("TRB")
						lFirst := .F.
					Endif

					dbSelectArea("SC5")
					dbSetOrder(1)
					dbGOTO(Val(TRB->CHAVE))
					
					If cPaisLoc == "BRA"
					   nMoedaBco := 1
					   dDataConv := dDataBase
					Else
					   nMoedaBco := SC5->C5_MOEDA
					   dDataConv := SC5->C5_EMISSAO
					Endif
					
					For nCond := 1 to Len(aParcelas)
						If aParcelas[nCond,1] > mv_par03 .and.  ;
							aParcelas[nCond,1] < mv_par04

							aParcelas[nCond,2] := xMoeda(aParcelas[nCond,2],nMoedaBco,mv_par05,dDataConv,nDecs+1)
							aParcelas[nCond,3] := xMoeda(aParcelas[nCond,3],nMoedaBco,mv_par05,dDataConv,nDecs+1)
							aParcelas[nCond,4] := xMoeda(aParcelas[nCond,4],nMoedaBco,mv_par05,dDataConv,nDecs+1)
							aParcelas[nCond,5] := xMoeda(aParcelas[nCond,5],nMoedaBco,mv_par05,dDataConv,nDecs+1)

							aDados[TITULO]		:= C5_NUM
							aDados[PARCELA]	:= Str(nCond,3)
							aDados[COD_CLI]	:= C5_CLIENTE
							aDados[LOJA]		:= C5_LOJACLI
			
							dbSelectArea("SA1")
							dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
							aDados[NOME_CLI]	:= IF(mv_par13 == 1,SA1->A1_NREDUZ,SA1->A1_NOME)
							dbSelectArea("SC5")
							
							aDados[DT_EMIS]	:= C5_EMISSAO
							aDados[DT_VENC]	:= aParcelas[nCond,1]   //Vencto
							aDados[VAL_TIT]	:= aParcelas[nCond,2]
							aDados[COM_EMISS]	:= aParcelas[nCond,3]
							aDados[COM_BAIXA]	:= aParcelas[nCond,4]
							aDados[VAL_BASE]	:= aParcelas[nCond,5]
							aDados[PERC]		:= aParcelas[nCond,6]
							aDados[VAL_COMIS]	:= aParcelas[nCond,3]+aParcelas[nCond,4] //Total Comissao (Emissao+Baixa)
							aDados[PARC]		:= "P"     // identificador de Titulo ou Pedido
							
							oSection1:PrintLine()
							aFill(aDados,nil)
							
							nValMinRet	:= GetMv( "MV_VLRETIR" )
							nValTit		+= aParcelas[nCond,2]
							nComEnt		+= aParcelas[nCond,3]
							nIrEnt		+= If(aParcelas[nCond,2] > nValMinRet, aParcelas[nCond,3] * (mv_par10/100),0)
							nComVen		+= aParcelas[nCond,4]
							nIrVen		+= If(aParcelas[nCond,2] > nValMinRet, aParcelas[nCond,4] * (mv_par10/100),0)
							nValBas		+= aParcelas[nCond,5]
							nPorc			+= aParcelas[nCond,6]
							nVendComis	+= aParcelas[nCond,3]+aParcelas[nCond,4]
							nVendIr		+= If(aParcelas[nCond,2] > nValMinRet, aParcelas[nCond,3]+aParcelas[nCond,4] * (mv_par10/100),0)
							nCount++
						Endif
					Next
				Endif
			Endif
		EndIf
		dbSelectArea("TRB")
		dbSkip()
	End
	nTotTit  +=nValTit
	nTotEnt  +=nComEnt
	nTotIrE  +=nIrEnt
	nTotVen  +=nComVen
	nTotIrB  +=nIrVen
	nTotBas  +=nValBas
	nTotComis+=nVendComis
	nTotIrVen+=nVendIr
	nTotPorc += nPorc	
	nTotCount+= nCount
	
	If (nVendComis <> 0 .or. nTotCount > 0) .or. mv_par08 == 1
		SubR4(nValTit,nComEnt,nComVen,nValBas,nPorc,nVendComis,nIrEnt,nIrVen,nVendIr,nCount,oReport,aDados)
	Endif
	
	nValTit		:= 0.00
	nComEnt		:= 0.00
	nIrEnt		:= 0.00
	nComVen		:= 0.00
	nIrVen		:= 0.00
	nValBas		:= 0.00
	nPorc 		:= 0
	nVendComis 	:= 0.00
	nVendIr		:= 0.00
	
	If mv_par12 == 1 // Salta Pagina por Vendedor? SIM/NAO
		oReport:EndPage()
	Endif
Enddo

If nTotComis <> 0 .And. mv_par12 == 2 // Salta Pagina por Vendedor? SIM/NAO
	TotR4(nTotTit,nTotEnt,nTotVen,nTotBas,nTotComis,nTotIrE,nTotIrB,nTotIrVen,nTotPorc,nTotCount,oReport,aDados)
Endif

//Fecho os dados fiscais de um pedido
MaFisEnd()

oSection1:Finish()

dbSelectarea("Trb")
dbCloseArea( )
Ferase(cNomArq+GetDBExtension())         //arquivo de trabalho
Ferase(cNomArq+OrdBagExt())    //indice gerado

dbSelectArea("SE3")
dbSetOrder(1)
DbSelectarea("SE1")
DbsetOrder(1)
dbClearFilter()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SubR4		³ Autor ³  Daniel Tadashi Batori³ Data ³ 30.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Sub-Total                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SubR4(void)		                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function SubR4(nValTit,nComEnt,nComVen,nValBas,nPorc,nVendComis,nIrEnt,nIrVen,nVendIr,nCount,oReport,aDados)
Local oSection1 := oReport:Section(1)

oReport:SkipLine()

If mv_par10 > 0  // Aliquota IRRF
	aDados[NOME_CLI]	:= STR0013  //"SUBTOTAL DO VENDEDOR --->"
	aDados[VAL_TIT]	    := nValTit
	aDados[COM_EMISS]	:= nComEnt
	aDados[COM_BAIXA]	:= nComVen
	aDados[VAL_BASE]	:= nValBas
	aDados[PERC]		:= nPorc/nCount
	aDados[VAL_COMIS]	:= nVendComis
	
	oSection1:PrintLine()
	aFill(aDados,nil)
	
	aDados[NOME_CLI]	:= STR0014  //"TOTAL IR VENDEDOR    --->"
	aDados[COM_EMISS]	:= nIrEnt
	aDados[COM_BAIXA]	:= nIrVen
	aDados[PERC]		:= mv_par10
	aDados[VAL_COMIS]	:= nVendIr
	
	oSection1:PrintLine()
	aFill(aDados,nil)

Endif

aDados[NOME_CLI]	:= STR0011 // "TOTAL DO VENDEDOR    --->"
aDados[VAL_TIT]	:= nValTit
aDados[COM_EMISS]	:= nComEnt
aDados[COM_BAIXA]	:= nComVen
aDados[VAL_BASE]	:= nValBas
aDados[PERC]		:= nPorc/nCount
aDados[VAL_COMIS]	:= nVendComis

oSection1:PrintLine()
aFill(aDados,nil)

oReport:SkipLine()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TOTR4		³ Autor ³  Paulo Boschetti      ³ Data ³ 30.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Total De Comiss”es                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TotR4(void)		                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function TotR4(nTotTit,nTotEnt,nTotVen,nTotBas,nTotComis,nTotIrE,nTotIrB,nTotIrVen,nTotPorc,nTotCount,oReport,aDados)
Local oSection1 := oReport:Section(1)

oReport:SkipLine()

If mv_par10 > 0  // Aliquota IRRF

	aDados[NOME_CLI]	:= STR0015   //"SUBTOTAL GERAL    --->"
	aDados[VAL_TIT]	:= nTotTit
	aDados[COM_EMISS]	:= nTotEnt
	aDados[COM_BAIXA]	:= nTotVen
	aDados[VAL_BASE]	:= nTotBas
	aDados[PERC]		:= nTotPorc/nTotCount
	aDados[VAL_COMIS]	:= nTotComis
	
	oSection1:PrintLine()
	aFill(aDados,nil)
	
	aDados[NOME_CLI]	:= STR0016  //"TOTAL GERAL IR    --->"
	aDados[COM_EMISS]	:= nTotIrE
	aDados[COM_BAIXA]	:= nTotIrB
	aDados[PERC]		:= mv_par10
	aDados[VAL_COMIS]	:= nTotIrVen
	
	oSection1:PrintLine()
	aFill(aDados,nil)

Endif
aDados[NOME_CLI]	:= STR0012  //"TOTAL  GERAL         --->"
aDados[VAL_TIT]	:= nTotTit
aDados[COM_EMISS]	:= nTotEnt
aDados[COM_BAIXA]	:= nTotVen
aDados[VAL_BASE]	:= nTotBas
aDados[PERC]		:= nTotPorc/nTotCount
aDados[VAL_COMIS]	:= nTotComis

oSection1:PrintLine()
aFill(aDados,nil)

oReport:SkipLine()

Return .T.















/*
---------------------------------------------------------- RELEASE 3 ---------------------------------------------
*/

















/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FINR610R3³ Autor ³ Paulo Boschetti       ³ Data ³ 13.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Previs„o de Comiss”es                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR610R3(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinR610R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel

LOCAL cString :="SE1"
LOCAL cDesc1  :=OemToAnsi( STR0001 ) // "Este relatorio ir  emitir a Previs„o das"
LOCAL cDesc2  :=OemToAnsi( STR0002 ) // "Comiss”es a Serem pagas."
LOCAL cDesc3  :=""

PRIVATE titulo  := STR0003 //"Previsao de Comissoes"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := {	OemToAnsi(STR0004),1,OemToAnsi(STR0005),2,2,1,"",1}	//"Zebrado"### //"Administracao"
PRIVATE nomeprog:= "FINR610N"
PRIVATE tamanho := "G"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="FIN610"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN610",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para parametros                         ³
//³ mv_par01         // Do Vendedor                              ³
//³ mv_par02         // At‚ o Vendedor                           ³
//³ mv_par03         // Vencto de                                ³
//³ mv_par04         // Vencto At‚                               ³
//³ mv_par05         // Qual Moeda                               ³
//³ mv_par06         // Da emiss„o                               ³
//³ mv_par07         // At‚ a emiss„o                            ³
//³ mv_par08         // Comiss„o Zero                            ³
//³ mv_par09         // Considera P.Venda                        ³
//³ mv_par10         // Abate IR Comiss                          ³
//³ mv_par11         // Outras Moedas                            ³
//³ mv_par12         // Salta Pagina por Vendedor                ³
//³ mv_par13         // Nome cliente									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR610N"
wnrel:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,"",.F.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
RptStatus({|lEnd| Fa610Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA610Imp ³ Autor ³ Paulo Boschetti       ³ Data ³ 13.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Previs„o de Comiss”es                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FA610Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA610Imp(lEnd,wnRel,cString)

LOCAL CbTxt,CbCont
LOCAL tamanho :="G"
LOCAL aCampos :={}
LOCAL cVendAnt:=Space(6)
LOCAL nComissao:=0.00
LOCAL nValTit :=0.00
LOCAL nComEnt :=0.00
LOCAL nComVen :=0.00
LOCAL nValBas :=0.00
LOCAL nPorc   :=0.00
LOCAL nVendComis :=0.00
LOCAL nTotTit :=0.00
LOCAL nTotEnt :=0.00
LOCAL nTotVen :=0.00
LOCAL nTotBas :=0.00
LOCAL nTotComis :=0.00
LOCAL lFirst:=.T.
LOCAL lPVen := .F.		// Flag diferenciador de pedido de venda
LOCAL aParcelas := {}	// Array das comissoes (geral)
LOCAL aParcItem := {}	// Array das comissoes (item)	
LOCAL nVendSC5 := 0		// Codigo do vendedor no pedido
LOCAL nComiSC5 := 0		// Percentual Comissao no pedido
LOCAL nComiSC6 := 0		// Percentual comissao no item do pedido
LOCAL nPerComE := 0		// Percentual comissao na emissao vendedor
LOCAL nPerComB	:= 0		// Percentual comissao na Baixa vendedor
LOCAL nRegSC6	:= 0		// Registro do item de pedido
LOCAL nQtdItem := 0		// Quantidade de produtos nao entregues
LOCAL nPercItem:= 0		// Percentual a ser usado (pedido ou item)
LOCAL nVlTotPed:= 0		// Valor total do pedido nao entregue
LOCAL nIrEnt	:= 0		// Ir na Emissao
LOCAL nIrVen	:= 0		// Ir na Baixa
LOCAL nVendIr	:= 0		// total de Ir do vendedor
LOCAL nTotIrE	:= 0		// Total geral de IR na emissao
LOCAL nTotIrB	:= 0		// Total geral de IR na Baixa
LOCAL nTotIrVen:= 0		// Total geral de IR do relatorio
LOCAL nTotPorc := 0		// Percentual medio de comissoes do relatorio
LOCAL nTotCount:= 0
LOCAL nCount	:= 0
LOCAL nTotAbat := 0
LOCAL aTam		:= {}
LOCAL aColu		:= {}
LOCAL nValMinRet := 0   // Valor minimo para retencao do IR
Local nMoedaBco :=1, dDataConv
Local cTipo
Local cParcela
Local cPrefixo
Local cNum
Local cTipoFat
Local nBaseCom
Local nValorFat
Local nCond
Local JX
Local nIrrItem := 0
Local nInsItem := 0
Local nPisItem := 0
Local nCofItem := 0
Local nCslItem := 0
Local nIcmItem := 0
Local nIssItem := 0
Local nSolItem := 0
Local nRecOri	:= 0
Local nItem		:= 0
Local nTotImp	:= 0
Local nVendTit
Local aVendedor
Local nRecPrinc, nx1, ny1
Local cChaveSE5, cIndexSE5   

// Se a comissão será definida na liquidação ou na baixa (1 = Liq, 2 = Baixa)
Local lComiLiq 	:= SuperGetMv("MV_COMILIQ",,"1") == "2" 

Private nDecs   := MsDecimais(mv_par05)
Private nIndexSE5

// criação do indice temporario pra busca do numero da fatura
//***************************************
cChaveSE5  := "E5_FILIAL + E5_FATURA"
dbSelectArea("SE5")
cIndexSE5 := CriaTrab(nil,.f.)	
IndRegua("SE5",cIndexSE5,cChaveSE5,,,OemToAnsi(STR0006))  //"Selecionando Registros..."
nIndexSE5 := RetIndex("SE5")
dbSelectArea("SE5")
#IFNDEF TOP
	dbSetIndex(cIndexSE5+OrdBagExt())
#ENDIF
dbSetOrder(nIndexSE5+1)
dbGoTop()
//***************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("E1_VEND1")
AADD(aCampos,{ "CODIGO" ,"C",aTam[1],aTam[2] } )
AADD(aCampos,{ "CHAVE"  ,"C",10,0 } )
AADD(aCampos,{ "NVEND"  ,"N",01,0 } )
AADD(aCampos,{ "PVEND"  ,"C",01,0 } )
AADD(aCampos,{ "CHVFAT" ,"N",10,0 } )
AADD(aCampos,{ "RECPRINC","N",10,0 } )

aTam := TamSX3("E1_CLIENTE")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq,"CODIGO+CHAVE",,,OemToAnsi(STR0023))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo+=  OemToAnsi(STR0022)+GetMV("MV_MOEDA"+Str(mv_par05,1))
cabec1:= IIF(aTam[1] > 6, STR0017,STR0006) // "PRF TITULO       P CODIGO               LJ   NOME                 DATA DE    DATA               VALOR      COMISSAO      COMISSAO    VALOR BASE %COMIS   VALOR TOTAL P/T"###"PRF NUMERO       P CODIGO  LJ NOME      DATA DE  DATA           VALOR          COMISSAO        COMISSAO    VALOR BASE  %COMIS  VALOR TOTAL"
cabec2:= IIF(aTam[1] > 6, STR0018,STR0007) // "    PEDIDO         CLIENTE                                        EMISSAO    VENCTO            TITULO     P/EMISSAO       P/BAIXA      P/ BAIXA  TOTAL   DA COMISSAO    "### "    TITULO         CLIENTE              EMISSAO  VENCTO         TITULO         P/EMISSAO       P/BAIXA     P/ BAIXA    TOTAL   DA COMISSAO"

dbSelectarea("TRB")
dbSetOrder(1)
dbGoTop()

dbSelectarea("SE1")
dbsetOrder(7)

SetRegua(Reccount())

If MV_PAR14 == 1
	Fr610ProcP(,lEnd)
Else
	Fr610ProcF(,lEnd)
Endif

dbSelectarea("TRB")
dbGotop()
SetRegua(RecCount())

While !Eof()
	
	lFirst  := .T.
	cVendAnt:= CODIGO
	nCount	:= 0
	While !Eof() .and. cVendAnt == CODIGO
		IF lEnd
			@PROW()+1,001 PSAY STR0008 // "CANCELADO PELO OPERADOR"
			Exit
		Endif
		IncRegua()
		nComissao := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a previsao sera calculada por titulo ja gerado   ³
		//³ ou pedido de vendas.                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->PVEND == "N"		
			dbSelectArea("SE1")
			dbSetOrder(1)
			If TRB->CHVFAT > 0
				dbGOTO(TRB->CHVFAT)
			Else              
				dbGoTo(Val(TRB->CHAVE))
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo Bases, valores e percentuais de comissao.            ³
			//³ Constituicao de aBases{} retornada por FA440COMIS()          ³
			//³ Coluna 01    Vendedor        	       		                 ³
			//³ Coluna 02    Valor do Titulo    		                       ³
			//³ Coluna 03    Base Comissao Emissao			                    ³
			//³ Coluna 04    Base Comissao Baixa	                          ³
			//³ Coluna 05    Comissao Emissao										  ³
			//³ Coluna 06    Comissao Baixa                                  ³
			//³ Coluna 07    % Total da comissao                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
            aBases   := Fa440Comis(SE1->(Recno()),.F.,.T.,,,TRB->RECPRINC)
			nBases 	:= aScan(aBases,{|x| x[1] == TRB->CODIGO })

			SE3->( dbSetOrder(3) )			

			If 	TRB->CHVFAT > 0 .And. aBases[nBases][7] == 0 .And.;	// Existe mais de um percentual de comissao (comissao por produto)
				!SE3->( MsSeek( xFilial("SE3") + aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) ) ) // Nao eh comissao realizada
				// Recalcula bases pelo total da nota de saida, sem considerar parcelas geradas.
				aBases := Fa440Comis(SE1->(Recno()),.F.,.T.,,.F./*Nao calcula por parcelas*/)
			EndIf	
			
			If TRB->CHVFAT > 0
				dbGoTo(Val(TRB->CHAVE))
			Endif
			If nBases = 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso vendedor n„o seja encontrado...           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("TRB")
				dbSkip()
				LOOP
			Endif
			aBases[nBases][2] := SE1->E1_VLCRUZ
			If TRB->CHVFAT > 0
				aBases[nBases][4] := SE1->E1_VALOR
				If aBases[nBases][7] > 0
					aBases[nBases][6] := SE1->E1_VALOR * (aBases[nBases][7]/100)
				EndIf	
			Endif
			cChaveSE3 := aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
			cTipo 	 := SE1->E1_TIPO
			cParcela	 := SE1->E1_PARCELA                                     
			nBaseCom	 := SE1->&("E1_BASCOM"+Str(TRB->NVEND,1)) // Utilizado para estornar a base de comissao do titulo
			nComissao := (SE1->&("E1_COMIS"+Str(TRB->NVEND,1))/100)*nBaseCom // Utilizado para estornar o valor da comissao do titulo
			If !Empty(SE1->E1_FATURA) .And. AllTrim(SE1->E1_FATURA) != "NOTFAT"
		        cTipoFat := SE1->E1_TIPOFAT
  				// Localiza o titulo de fatura, pois no SE3 eh gerado o titulo de fatura
        	    // para verificar as comissoes que ja foram pagas.
				SE1->(MsSeek(xFilial("SE1")+E1_FATPREF+E1_FATURA)) // Localiza o titulo de fatura
    	        cPrefixo := SE1->E1_PREFIXO
	    	    cNum	   := SE1->E1_NUM
	            // Processar todas as parcelas da fatura gerada e verificar se a comissao
    	        // para a parcela nao foi paga.
	         	While xFilial("SE1")+SE1->(E1_PREFIXO+E1_NUM) == xFilial("SE1")+cPrefixo+cNum .And.;
            			SE1->(!Eof())
            		If SE1->E1_TIPO == cTipoFat
	   	         		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			            //³ Verificar comissoes ja pagas                                 ³
		            	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    	        	cChaveSE3 := aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
	        	    	cTipo 	 := SE1->E1_TIPO
						cParcela	 := SE1->E1_PARCELA
						nValorFat := SE1->E1_VLCRUZ
		            	FA610ComPg(@aBases,cChaveSE3,nBases,cTipo,cParcela,nValorFat,nBaseCom,nComissao)
		            Endif	
        	    	SE1->(DbSkip())
            	End
	            dbSelectArea("SE1")
				dbSetOrder(1)
				dbGOTO(Val(TRB->CHAVE))
			Else
				FA610ComPg(@aBases,cChaveSE3,nBases,cTipo,cParcela,SE1->E1_VLCRUZ,nBaseCom,nComissao)
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso percentual de comissao seja retornado == a zero, devo   ³
			//³ calcular a media (Faturamento com comissao no item <> percen-³
			//³ tual do vendedor)                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aBases[nBases,7] == 0
				aBases[nBases,7] := (((aBases[nBases,5]+aBases[nBases,6])*100)/aBases[nBases,2])
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica tamanho do campo E1_CLIENTE para posicionamento das ³
			//³ colunas do relatorio                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aColu := IIF (aTam[1] > 6,;
								{000,004,017,021,042,047,068,079,090,104,118,132,146,153,168},;
								{000,004,017,021,028,031,052,063,074,088,102,116,130,137,152})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime o Vendedor caso possa imprimir Comiss„o Zero ou      ³
			//³ exista alguma comiss„o para o Vendedor                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par08 == 1 .or. aBases[nBases,6] != 0 .Or. aBases[nBases,5] != 0 
				IF li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
				EndIF
				If lFirst
					Li++
					dbSelectArea("SA3")
					dbSeek(cFilial+TRB->CODIGO)
					@li,  0 PSAY STR0009 + TRB->CODIGO //"CODIGO : "
					@li, 16 PSAY STR0010 + SA3->A3_NOME //"NOME : "
					dbSelectArea("TRB")
					Li+=2
					lFirst := .F.
				Endif
				dbSelectArea("SE1")
				dbSetOrder(1)
				dbGOTO(Val(TRB->CHAVE))
				
				If cPaisLoc == "BRA"
				   nMoedaBco := 1
				   dDataConv := dDataBase
				Else
				   dDataConv := SE1->E1_EMISSAO
				EndIf

    			nComissao := xMoeda(aBases[nBases,5] + aBases[nBases,6],nMoedaBco,mv_par05,dDataConv,nDecs+1)
    			aBases[nBases,2] := xMoeda(aBases[nBases,2],nMoedaBco,mv_par05,dDataConv,nDecs+1)
    			aBases[nBases,4] := xMoeda(aBases[nBases,4],nMoedaBco,mv_par05,dDataConv,nDecs+1)
    			aBases[nBases,5] := xMoeda(aBases[nBases,5],nMoedaBco,mv_par05,dDataConv,nDecs+1)
    			aBases[nBases,6] := xMoeda(aBases[nBases,6],nMoedaBco,mv_par05,dDataConv,nDecs+1)

				@li, aColu[1] PSAY E1_PREFIXO
				@li, aColu[2] PSAY E1_NUM
				@li, aColu[3] PSAY E1_PARCELA
				@li, aColu[4] PSAY E1_CLIENTE
				@li, aColu[5] PSAY E1_LOJA
				dbSelectArea("SA1")
				dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
				@li, aColu[6] PSAY IF(mv_par13 == 1,Substr(SA1->A1_NREDUZ,1,20),Substr(SA1->A1_NOME,1,20))
				dbSelectArea("SE1")
				@li, aColu[7] PSAY E1_EMISSAO
				@li, aColu[8] PSAY E1_VENCREA
				@li, aColu[9]  PSAY aBases[nBases,2]	Picture tm(aBases[nBases,2],13,nDecs)
				@li, aColu[10] PSAY aBases[nBases,5]	Picture tm(aBases[nBases,5],13,nDecs)
				@li, aColu[11] PSAY aBases[nBases,6]	Picture tm(aBases[nBases,6],13,nDecs)
				@li, aColu[12] PSAY aBases[nBases,4]	Picture tm(aBases[nBases,4],13,nDecs)
				@li, aColu[13] PSAY aBases[nBases,7]	Picture "999.99"
				@li, aColu[14] PSAY nComissao			Picture tm(nComissao,13,nDecs)
				@li, aColu[15] PSAY "T"     // identificador de Titulo ou Pedido
				li++
            nValMinRet := GetMv( "MV_VLRETIR" )
				nValTit		+= aBases[nBases,2]
				nComEnt		+= aBases[nBases,5]
				nIrEnt		+= If(aBases[nBases,2] > nValMinRet,aBases[nBases,5] * (mv_par10/100),0)
				nComVen		+= aBases[nBases,6]
				nIrVen		+= If(aBases[nBases,2] > nValMinRet, aBases[nBases,6] * (mv_par10/100),0)
				nValBas		+= aBases[nBases,4]
				nPorc		+= aBases[nBases,7]
				nVendComis	+= nComissao
				nVendIr		+= If(aBases[nBases,2] > nValMinRet,(aBases[nBases,5]+aBases[nBases,6])* (mv_par10/100),0)
				nCount++
			EndIf
		Else
			// calculo das comissoes p/ pedido venda
			dbSelectArea("SC5")
			dbSetOrder(1)
			DbGoto(Val(TRB->CHAVE))
			//Fecho os dados fiscais de um pedido antes de carregar um novo pedido
			MaFisEnd()
			//Inicializo a funcao fiscal
			MaFisIni(C5_CLIENTE,;// 1-Codigo Cliente/Fornecedor
						C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
						IIf(C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
						C5_TIPO,;				// 4-Tipo da NF
						C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						"MATA461")

			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SC5->C5_NUM)
				While !Eof() .and. SC6->C6_NUM == SC5->C5_NUM
					nRecOri := 0
					If !Empty(SC6->C6_NFORI) .And. !Empty(SC6->C6_ITEMORI)
						SD1->(dbSetOrder(1))
						If SD1->(MSSeek(xFilial("SD1")+SC6->C6_NFORI+SC6->C6_SERIORI+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC6->C6_PRODUTO+SC6->C6_ITEMORI))
							nRecOri := SD1->(Recno())
						Endif	
					Endif

					MaFisAdd(C6_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
						C6_TES,;	   	// 2-Codigo do TES ( Opcional )
						C6_QTDVEN,;  	// 3-Quantidade ( Obrigatorio )
						C6_PRCVEN,;		  	// 4-Preco Unitario ( Obrigatorio )
						a410Arred(C6_QTDVEN*C6_PRCVEN,"D2_DESCON")-C6_VALOR,; 	// 5-Valor do Desconto ( Opcional )
						"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
						"",;				// 7-Serie da NF Original ( Devolucao/Benef )
						nRecOri,;					// 8-RecNo da NF Original no arq SD1/SD2
						0,;					// 9-Valor do Frete do Item ( Opcional )
						0,;					// 10-Valor da Despesa do item ( Opcional )
						0,;					// 11-Valor do Seguro do item ( Opcional )
						0,;					// 12-Valor do Frete Autonomo ( Opcional )
						C6_VALOR ,;			// 13-Valor da Mercadoria ( Obrigatorio )
						0)					// 14-Valor da Embalagem ( Opiconal )
						
					SC6->(DBSkip())
				Enddo
			Endif
			nComissao	:= 0
			nVlTotPed	:= 0
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SC5->C5_NUM)
				aParcelas	:= {}
				nVendSC5		:= SC5->(FieldPos("C5_VEND"+STR(TRB->NVEND,1)))
				nComiSC5		:= SC5->(FieldPos("C5_COMIS"+STR(TRB->NVEND,1)))
				nComiSC6		:= SC6->(FieldPos("C6_COMIS"+STR(TRB->NVEND,1)))
				dbSelectArea("SA3")
				dbSeek(xFilial("SA3")+SC5->(FieldGet(nVendsc5)))
				nPerComE		:= (SA3->A3_ALEMISS/100)
				nPerComB		:= (SA3->A3_ALBAIXA/100)
				dbSelectArea("SC6")
				nRegSC6 := Recno()
				// valor de nao entregues total no pedido
				bAcao:= {|| nVlTotPed += SC6->(C6_PRCVEN * (C6_QTDVEN - C6_QTDENT))}
				dbEval(bAcao,,{||!Eof() .and. SC6->C6_NUM == SC5->C5_NUM},,,.T.)
				dbGoto(nRegSC6)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Constituicao de aParcelas{}				                       ³
				//³ Coluna 01    Data Vencto da Parcela			                 ³
				//³ Coluna 02    Valor da Parcela			                       ³
				//³ Coluna 03    Valor Comissao Emissao		                    ³
				//³ Coluna 04    Valor Comissao Baixa                            ³
				//³ Coluna 05    Base da Baixa                                   ³
				//³ Coluna 06    % Total da comissao                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aParcelas := Condicao (nVlTotPed,SC5->C5_CONDPAG,,SC5->C5_EMISSAO)
				aEval(aParcelas,{|elem| aadd(elem,0),aadd(elem,0),aadd(elem,0),aadd(elem,0),aadd(elem,0)})
				dbSelectArea("SC6")
				nItem		:= 0
				nTotImp	:= 0
				While !Eof() .and. SC6->C6_NUM == SC5->C5_NUM
					nItem++
					If SC6->C6_QTDENT >= SC6->C6_QTDVEN .Or.;
						!Empty(SC6->C6_BLOQUEI)          .Or.;
						Left(SC6->C6_BLQ,1) $ "RS"
						dbskip()
						Loop
					Endif
					nQtdItem := SC6->(C6_QTDVEN - C6_QTDENT)  // Qtde nao entregue
					nBasItem := SC6->(C6_PRCVEN * nQtdItem) 	// Valor ref. nao entregue

					nIrrItem := 0
					nInsItem := 0
					nPisItem := 0
					nCofItem := 0
					nCslItem := 0
					nIcmItem := 0
					nIssItem := 0
					nSolItem := 0

					If SuperGetMv("MV_COMISIR") == "N"
						nIrrItem := MafisRet(nItem, "IT_VALIRR") 
						nBasItem -= nIrrItem
					Endif
					If GetNewPar("MV_COMIINS","N") == "N"
						nInsItem := MafisRet(nItem, "IT_VALINS") 
						nBasItem -= nInsItem
					EndIf
					If GetNewPar("MV_COMIPIS","N") == "N"
						nPisItem := MafisRet(nItem, "IT_VALPIS") 
						nBasItem -= nPisItem
					EndIf
					If GetNewPar("MV_COMICOF","N") == "N"
						nCofItem := MafisRet(nItem, "IT_VALCOF") 
						nBasItem -= nCofItem
					EndIf
					If GetNewPar("MV_COMICSL","N") == "N"
						nCslItem := MafisRet(nItem, "IT_VALCSL") 
						nBasItem -= nCslItem
					EndIf

					// Calcula abatimento de ISS e ICMS da base da comissao do vendedor
					SF4->(dbSetOrder(1))
					SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
					If !(SF4->F4_ISS == "S")
						If ( SA3->A3_ICM == "N" )
							nIcmItem := MaFisRet(nItem, "IT_VALICM")
							nBasItem -= nIcmItem
						EndIf
					Else
						If ( SA3->A3_ISS == "N" )
							nIssItem := MaFisRet(nItem, "IT_VALISS")
							nBasItem -= nIssItem
						EndIf
					EndIf				
					If ( SA3->A3_ICMSRET == "N" )
						nSolItem := MaFisRet(nItem, "IT_VALSOL")
						nBasItem -= nSolItem
					EndIf

					nPercItem:= IIF(SC6->(FieldGet(nComiSC6))== 0,;
										 SC5->(FieldGet(nComiSC5)),	 ;	// Percentual no Pedido
										 SC6->(FieldGet(nComiSC6)))		// Percentual no Item
					aParcItem:= Condicao(nBasItem,SC5->C5_CONDPAG,,SC5->C5_EMISSAO)

					//valor dos impostos do pedido
					nTotImp := nIrrItem + nInsItem + nPisItem + nCofItem + nCslItem + nIcmItem + nIssItem + nSolItem

					dbSelectArea("SC6")
					For nCond := 1 to Len(aParcItem)
						aParcelas[nCond,3] += ((aParcItem[nCond,2] * (nPercItem/100)) * nPerComE)
						aParcelas[nCond,4] += ((aParcItem[nCond,2] * (nPercItem/100)) * nPerComB)
						aParcelas[nCond,5] += (aParcItem[nCond,2] * nPerComB)
						aParcelas[nCond,7] += (nTotImp / Len(aParcItem))
					Next
					dbskip()
				Enddo
				For nCond := 1 to	Len(aParcelas)
					aParcelas[nCond,6] += (((aParcelas[nCond,3]+aParcelas[nCond,4]) * 100) / (aParcelas[nCond,2] - aParcelas[nCond,7]))
					nComissao += (aParcelas[nCond,3]+aParcelas[nCond,4])
				Next

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica tamanho do campo C5_CLIENTE para posiciona- ³
				//³ mento das colunas do relatorio                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aColu := IIF (aTam[1] > 6,;
									{000,004,017,021,042,047,068,079,090,104,118,132,146,153,168},;
									{000,004,017,021,028,031,052,063,074,088,102,116,130,137,152})

		
				// impressao das previsoes de comiss do ped venda
				If ( nComissao != 0 )
					IF li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
					EndIF
					If lFirst                                                                                 
						Li++
						@li,  0 PSAY STR0009 + TRB->CODIGO //"CODIGO : "
						@li, 16 PSAY STR0010 + SA3->A3_NOME //"NOME : "
						dbSelectArea("TRB")
						Li+=2
						lFirst := .F.
					Endif
					dbSelectArea("SC5")
					dbSetOrder(1)
					dbGOTO(Val(TRB->CHAVE))
					
					If cPaisLoc == "BRA"
					   nMoedaBco := 1
					   dDataConv := dDataBase
					Else
					   nMoedaBco := SC5->C5_MOEDA
					   dDataConv := SC5->C5_EMISSAO
					Endif
					
					For nCond := 1 to Len(aParcelas)
						If aParcelas[nCond,1] > mv_par03 .and.  ;
							aParcelas[nCond,1] < mv_par04

							aParcelas[nCond,2] := xMoeda(aParcelas[nCond,2],nMoedaBco,mv_par05,dDataConv,nDecs+1)
							aParcelas[nCond,3] := xMoeda(aParcelas[nCond,3],nMoedaBco,mv_par05,dDataConv,nDecs+1)
							aParcelas[nCond,4] := xMoeda(aParcelas[nCond,4],nMoedaBco,mv_par05,dDataConv,nDecs+1)
							aParcelas[nCond,5] := xMoeda(aParcelas[nCond,5],nMoedaBco,mv_par05,dDataConv,nDecs+1)

							@li, aColu[2] PSAY C5_NUM
							@li, aColu[3] PSAY Str(nCond,3)
							@li, aColu[4] PSAY C5_CLIENTE
							@li, aColu[5] PSAY C5_LOJACLI
							dbSelectArea("SA1")
							dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
							@li, aColu[6] PSAY IF(mv_par13 == 1,Substr(SA1->A1_NREDUZ,1,20),Substr(SA1->A1_NOME,1,20))
							dbSelectArea("SC5")
							@li, aColu[7] PSAY C5_EMISSAO
							@li, aColu[8] PSAY aParcelas[nCond,1]   //Vencto
							@li, aColu[9]  PSAY aParcelas[nCond,2] Picture tm(aParcelas[nCond,2],13,nDecs) //Valor do titulo
							@li, aColu[10] PSAY aParcelas[nCond,3] Picture tm(aParcelas[nCond,3],13,nDecs)	//Comissao Emissao
							@li, aColu[11] PSAY aParcelas[nCond,4] Picture tm(aParcelas[nCond,4],13,nDecs)	//Comissao Baixa
							@li, aColu[12] PSAY aParcelas[nCond,5] Picture tm(aParcelas[nCond,5],13,nDecs)	//Base Comissao Baixa
							@li, aColu[13] PSAY aParcelas[nCond,6] Picture "999.99"		//Percentual de Comissao
							@li, aColu[14] PSAY aParcelas[nCond,3]+aParcelas[nCond,4] ;		//Total Comissao (Emissao+Baixa)
							                Picture tm(aParcelas[nCond,3]+aParcelas[nCond,4],13,nDecs)
							@li, aColu[15] PSAY "P"     // identificador de Titulo ou Pedido

							li++
 		                    nValMinRet := GetMv( "MV_VLRETIR" )
							nValTit		+= aParcelas[nCond,2]
							nComEnt		+= aParcelas[nCond,3]
							nIrEnt		+= If(aParcelas[nCond,2] > nValMinRet, aParcelas[nCond,3] * (mv_par10/100),0)
							nComVen		+= aParcelas[nCond,4]
							nIrVen		+= If(aParcelas[nCond,2] > nValMinRet, aParcelas[nCond,4] * (mv_par10/100),0)
							nValBas		+= aParcelas[nCond,5]
							nPorc		+= aParcelas[nCond,6]
							nVendComis	+= aParcelas[nCond,3]+aParcelas[nCond,4]
							nVendIr		+= If(aParcelas[nCond,2] > nValMinRet, aParcelas[nCond,3]+aParcelas[nCond,4] * (mv_par10/100),0)
							nCount++
						Endif
					Next
				Endif
			Endif
		EndIf
		dbSelectArea("TRB")
		dbSkip()
	End
	nTotTit  +=nValTit
	nTotEnt  +=nComEnt
	nTotIrE  +=nIrEnt
	nTotVen  +=nComVen
	nTotIrB  +=nIrVen
	nTotBas  +=nValBas
	nTotComis+=nVendComis
	nTotIrVen+=nVendIr
	nTotPorc += nPorc	
	nTotCount+= nCount
	If (nVendComis <> 0 .or. nTotCount > 0) .or. mv_par08 == 1
		ImpSub610(nValTit,nComEnt,nComVen,nValBas,nPorc,nVendComis,nIrEnt,;
						nIrVen,nVendIr,nCount,aColu)
	Endif
	nValTit		:= 0.00
	nComEnt		:= 0.00
	nIrEnt		:= 0.00
	nComVen		:= 0.00
	nIrVen		:= 0.00
	nValBas		:= 0.00
	nPorc 		:= 0
	nVendComis 	:= 0.00
	nVendIr		:= 0.00
	If mv_par12 == 1
		li := 80
	Endif
Enddo
If nTotComis <> 0
	ImpTot610(nTotTit,nTotEnt,nTotVen,nTotBas,nTotComis,nTotIrE,;
					nTotIrB,nTotIrVen,nTotPorc,nTotCount,aColu)
Endif
IF li != 80
	li++
	roda(cbcont,cbtxt,"G")
End
//Fecho os dados fiscais de um pedido
MaFisEnd()

dbSelectarea("Trb")
dbCloseArea( )
Ferase(cNomArq+GetDBExtension())         //arquivo de trabalho
Ferase(cNomArq+OrdBagExt())    //indice gerado

dbSelectArea("SE3")
dbSetOrder(1)
DbSelectarea("SE1")
DbsetOrder(1)
dbClearFilter()
Set Device To Screen

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GRAVACOM ³ Autor ³  Paulo Boschetti      ³ Data ³ 13.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava Arquivo de Trabalho                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GRAVACOM(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function GRAVACOM(nX,lPVen,nChvFat,cVend, nRecPrinc)
Local cAlias := Alias()  

Default nChvFat := 0
Default cVend   := ""                                                         
Default nRecPrinc := 0

dbSelectarea("TRB")                                   
If Empty(cVend)
	cVend := IIf(lPVen,"SC5->C5_VEND","SE1->E1_VEND")+nX
	cVend := &cVend
Endif               

nChave := AllTrim(Str(&(cAlias+"->(RECNO())")))

If TRB->(!DbSeek(cVend+nChave))                                        
	RecLock("TRB",.T.)                                                                              
	Replace CODIGO With cVend                                                                             
	Replace CHAVE  With AllTrim(Str(&(cAlias+"->(RECNO())")))
	Replace NVEND  With VAL(nX)
	Replace PVEND  With IIF(lPVen,"S","N")  
	Replace RECPRINC With nRecPrinc
	If nChvFat > 0
		Replace CHVFAT With nChvFat
	Endif
	MsUnlock()
Endif
DbSelectarea(cAlias)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ IMPSUB610³ Autor ³  Paulo Boschetti      ³ Data ³ 13.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Sub-Total                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpSub610(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpSub610(nValTit,nComEnt,nComVen,nValBas,nPorc,nVendComis,nIrEnt,nIrVen,nVendIr,nCount, aColu)

If mv_par10 > 0  // Aliquota IRRF
	Li++
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
	EndIF
	@li, aColu[1]  PSAY STR0013  //"SUBTOTAL DO VENDEDOR --->"
	@li, aColu[9]  PSAY nValTit          Picture tm(nValTit,13,nDecs)
	@li, aColu[10] PSAY nComEnt          Picture tm(nComEnt,13,nDecs)
	@li, aColu[11] PSAY nComVen          Picture tm(nComVen,13,nDecs)
	@li, aColu[12] PSAY nValBas		  Picture tm(nValBas,13,nDecs)
	@li, aColu[13] PSAY nPorc/nCount	  Picture "999.99"
	@li, aColu[14] PSAY nVendComis       PicTure tm(nVendComis,13,nDecs)
	Li++
	@li, aColu[1]  PSAY STR0014  //"TOTAL IR VENDEDOR    --->"
	@li, aColu[10] PSAY nIrEnt				Picture tm(nIrEnt,13,nDecs)
	@li, aColu[11] PSAY nIrVen				Picture tm(nIrVen,13,nDecs)
	@li, aColu[13] PSAY mv_par10   		Picture "999.99"
	@li, aColu[14] PSAY nVendIr			PicTure tm(nVendIr,13,nDecs)
Endif
Li++
IF li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
EndIF
@li, aColu[1]  PSAY STR0011 // "TOTAL DO VENDEDOR    --->"
@li, aColu[9]  PSAY nValTit          Picture tm(nValTit,13,nDecs)
@li, aColu[10] PSAY nComEnt          Picture tm(nComEnt,13,nDecs)
@li, aColu[11] PSAY nComVen          Picture tm(nComVen,13,nDecs)
@li, aColu[12] PSAY nValBas		  Picture tm(nValBas,13,nDecs)
@li, aColu[13] PSAY nPorc/nCount	  Picture "999.99"
@li, aColu[14] PSAY nVendComis       PicTure tm(nVendComis,13,nDecs)
Li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ IMPTOT610³ Autor ³  Paulo Boschetti      ³ Data ³ 13.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Total De Comiss”es                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpTot610(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpTot610(nTotTit,nTotEnt,nTotVen,nTotBas,nTotComis,nTotIrE,;
									nTotIrB,nTotIrVen,nTotPorc,nTotCount,aColu)

Li++
IF li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
EndIF
If mv_par10 > 0  // Aliquota IRRF
	Li++

	@li, aColu[1]  PSAY STR0015   //"SUBTOTAL GERAL    --->"
	@li, aColu[9]  PSAY nTotTit			Picture tm(nTotTit,13,nDecs)
	@li, aColu[10] PSAY nTotEnt 	        Picture tm(nTotEnt,13,nDecs)
	@li, aColu[11] PSAY nTotVen    	    Picture tm(nTotVen,13,nDecs)
	@li, aColu[12] PSAY nTotBas		   	Picture tm(nTotBas,13,nDecs)
	@li, aColu[13] PSAY nTotPorc/nTotCount	Picture "999.99"
	@li, aColu[14] PSAY nTotComis			PicTure tm(nTotComis,13,nDecs)
	Li++
	@li, aColu[1]  PSAY STR0016  //"TOTAL GERAL IR    --->"
	@li, aColu[10] PSAY nTotIrE			Picture tm(nTotIrE,13,nDecs)
	@li, aColu[11] PSAY nTotIrB			Picture tm(nTotIrB,13,nDecs)
	@li, aColu[13] PSAY mv_par10   		Picture "999.99"
	@li, aColu[14] PSAY nTotIrVen			PicTure tm(nTotIrVen,13,nDecs)
Endif
Li++
IF li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
EndIF
@li, aColu[1]  PSAY STR0012  //"TOTAL  GERAL         --->"
@li, aColu[9]  PSAY nTotTit          	Picture tm(nTotTit,13,nDecs)
@li, aColu[10] PSAY nTotEnt          	Picture tm(nTotEnt,13,nDecs)
@li, aColu[11] PSAY nTotVen          	Picture tm(nTotVen,13,nDecs)
@li, aColu[12] PSAY nTotBas		    Picture tm(nTotBas,13,nDecs)
@li, aColu[13] PSAY nTotPorc/nTotCount	Picture "999.99"
@li, aColu[14] PSAY nTotComis        	PicTure tm(nTotComis,13,nDecs)
Li++

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA610COMPG³ Autor ³ Mauricio Pequim jr    ³ Data ³ 30.07.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica comissoes j  pagas								        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FA610COMPG(aBases,cChaveSE3)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                         	  	              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA610ComPg(aBases,cChaveSE3,nBases,cTipo,cParcela,nValorFat,nBaseCom,nComissao)
Local nPercBase := 0
Local nPercEst

DEFAULT cTipo    := SE1->E1_TIPO
DEFAULT cParcela := SE1->E1_PARCELA
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso percentual de comissao seja retornado == a zero, devo   ³
//³ calcular a media (Faturamento com comissao no item <> percen-³
//³ tual do vendedor)                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aBases[nBases,7] == 0 
	aBases[nBases,7] := (((aBases[nBases,5]+aBases[nBases,6])*100)/aBases[nBases,2])
Endif

dbSelectArea("SE3")
dbSetOrder(3)
If dbSeek(xFilial("SE3")+cChaveSE3)
	While !Eof() .and. xFilial("SE3")== E3_FILIAL .and.;
		E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM == cChaveSE3
		If !Empty(E3_DATA) .or. E3_COMIS < 0
			nPercEst	:= Abs(SE3->E3_BASE / nValorFat)
		   If E3_BAIEMI == "E" 
            If E3_COMIS < 0
					aBases[nBases,3] += E3_BASE
					aBases[nBases,5] += E3_COMIS
				Else
					If aBases[nBases,3] > 0 .and. E3_BASE <> aBases[nBases,3]
						nPercBase:= Round(NoRound((aBases[nBases,3] * 100) / E3_BASE, 3),2)
					Else
						nPercBase:= 100
					Endif
					aBases[nBases,3] -= Round(NoRound(E3_BASE * (nPercBase/100) ,3),2)
					aBases[nBases,5] -= Round(NoRound(E3_COMIS * (nPercBase/100) ,3),2)
				Endif
	   	Else
				If E3_BAIEMI == "B" .and. cTIPO+cPARCELA == SE3->E3_TIPO+SE3->E3_PARCELA .and. E3_COMIS > 0
					aBases[nBases,4] -= (nBaseCom*nPercEst)
					aBases[nBases,6] -= (nComissao*nPercEst)
				ElseIf E3_BAIEMI == "B" .and. cTIPO+cPARCELA == SE3->E3_TIPO+SE3->E3_PARCELA .and. E3_COMIS < 0
					aBases[nBases,4] += (nBaseCom*nPercEst)
					aBases[nBases,6] += (nComissao*nPercEst)
				Endif
		   Endif
		EndIf
		dbSkip()
	EndDo
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Vendedor610 ³ Autor ³ Marcelo Celi Marques³Data ³ 18/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Complemento a função TitPrinc para retorno da array de     ³±±
±±³          ³ vendedores com dados de comissão de titulos principais     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr610.prx                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Vendedor610(cAliasSe1,nIndexSE5)
Local aAreaSe1 := GetArea()
Local aVend610	:= {{},{},{},{}}
TitPrinc(xFilial(cAliasSe1),(cAliasSe1)->e1_PREFIXO,(cAliasSe1)->e1_NUM,(cAliasSe1)->e1_PARCELA,(cAliasSe1)->e1_TIPO,"SE1",@aVend610,nIndexSE5)
RestArea(aAreaSe1)
Return aVend610
                 



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fr610ProcF  ³ Autor ³ Marcelo Celi Marques³Data ³ 23/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Trata o abastecimento do TRB a partir dos títulos filhos   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr610.prx                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr610ProcF(oReport,lEnd)
Local JX
Local nVendTit
Local nRecPrinc, nx1, ny1
// Se a comissão será definida na liquidação ou na baixa (1 = Liq, 2 = Baixa)
Local lComiLiq 	:= SuperGetMv("MV_COMILIQ",,"1") == "2" 

Default oReport := .F.
Default lEnd := .F.


dbSeek(xFilial("SE1")+DtoS(mv_par03),.T.)
While SE1->(!Eof()) .and. xFilial("SE1") == SE1->E1_FILIAL .and. SE1->E1_VENCREA <= mv_par04
	lPVen := .F.
	
	If Valtype(oReport) <> "L"
		// chamado pelo r4
		oReport:IncMeter()
	Else
		// chamado pelo r3
		IF lEnd
			@PROW()+1,001 PSAY STR0008 // "CANCELADO PELO OPERADOR"
			Exit
		Endif	
		IncRegua()
	Endif	
	
	If E1_TIPO $ MVABATIM
		dbSkip()
		Loop
	Endif
		
	If E1_SALDO == 0
		dbSkip()
		Loop
	Endif
	
	If E1_EMISSAO < mv_par06 .or. E1_EMISSAO > mv_par07
		dbSkip()
		Loop
	Endif

	// Despreza registros de outra moeda se escolhido nao imprimir
	If mv_par11 == 2 .AND. E1_MOEDA != mv_par05 
		dbSkip()
		Loop
	Endif
	
	// Se título for uma liquidação e a comissão será gerada na liquidação
	If !Empty(E1_NUMLIQ) .And. !lComiLiq
		dbSkip()
		Loop  	
	Endif
		
	aVendedor := Vendedor610("SE1",nIndexSE5)
		
	For nVendTit := 1 to len(aVendedor[1])										
		For JX:=1 TO 5
			nx := Str(JX,1)
			cVendedor := aVendedor[1][nVendTit][JX]					                 			
			If !Empty(cVendedor)
				
				// Descobrir o recno() do titulo principal
				For nx1 := 1 to Len(aVendedor[1])
					nPos := aScan(aVendedor[1],{|x| x[nx1] == cVendedor})
					If nPos > 0
					   nx1 := Len(aVendedor[1])+1
					   dbSelectArea("SE1")
					   aAreaSE1 := GetArea()
					   dbSetOrder(1)
					   If dbSeek(aVendedor[4][nPos])
					      nRecPrinc := 0
					      For ny1 := 1 to 5
					      	If aVendedor[1][nPos][ny1] == cVendedor
					      	   nRecPrinc := SE1->(Recno())
					      	Endif					   
					      Next	
					   Endif
					   RestArea(aAreaSE1)					   
					Endif
				Next	
				
								
				If cVendedor >= mv_par01 .And. cVendedor <= mv_par02
					If !Empty(SE1->E1_FATURA) .And. (AllTrim(SE1->E1_FATURA) <> "NOTFAT")
						aAreaSE1 := GetArea()
						cCliente := E1_CLIENTE  //Declarar variaveis 
						cLoja    := E1_LOJA
						cFatura  := E1_FATURA           
						cFatPref := E1_FATPREF  						
						nChvFat  := SE1->(Recno())   
						SE1->(dbSetOrder(1))
						SE1->(dbGotop())
						cChaveSE1 := xFilial("SE1") + cFatPref + cFatura 
						SE1->(dbSeek(cChaveSE1))					
						While(cChaveSE1 == xFilial("SE1") + E1_PREFIXO + E1_NUM)                
							If SE1->E1_VENCREA >= mv_par03 .And. SE1->E1_VENCREA <= mv_par04					
								If AllTrim(E1_FATURA) == "NOTFAT" .And. E1_SALDO > 0 									
									GravaCom(nX,lPVen,nChvFat,cVendedor,nRecPrinc)
			  					Endif
			  				Endif	
			  				DbSkip()
						EndDo
						RestArea(aAreaSE1)
					Else
						GravaCom(nX,lPVen,,cVendedor,nRecPrinc)
					Endif
				Endif
			Endif	
		Next                               		
	Next	
	SE1->(dbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se considera pedidos de venda                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par09 == 1  // Considera Ped. Venda
	lPVen := .T.
	dbSelectarea("SC5")
	dbsetOrder(2)
	
	If Valtype(oReport) <> "L"
		oReport:SetMeter(SC5->(Reccount()))
	Endif	

	dbSeek(cFilial+DtoS(mv_par03),.T.)
	While !Eof() .and. cFilial == C5_FILIAL .and. C5_EMISSAO <= mv_par04
		
		If Valtype(oReport) <> "L"
			// chamado pelo r4
			oReport:IncMeter()
		Else
			// chamado pelo R3
			IF lEnd
				@PROW()+1,001 PSAY STR0008 // "CANCELADO PELO OPERADOR"
				Exit
			Endif
			IncRegua()
		Endif	
		
		If C5_EMISSAO < mv_par06 .or. C5_EMISSAO > mv_par07
			dbSkip()
			Loop
		Endif
		For JX:=1 TO 5  // grava vendedores no arq TRB
			nx := Str(JX,1)
			IF !EMPTY(C5_VEND&nx.)
				If C5_VEND&nx. >= mv_par01 .and. C5_VEND&nx. <= mv_par02
					GravaCom(nX,lPVen)
				End
			End
		EndFor
		dbSkip()
	Enddo
Endif

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fr610ProcP  ³ Autor ³ Marcelo Celi Marques³Data ³ 23/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Trata o abastecimento do TRB a partir dos títulos pais     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr610.prx                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr610ProcP(oReport,lEnd)
Local JX
Local nVendTit
Local nRecPrinc, nx1, ny1
// Se a comissão será definida na liquidação ou na baixa (1 = Liq, 2 = Baixa)
Local lComiLiq 	:= SuperGetMv("MV_COMILIQ",,"1") == "2" 

Default oReport := .F.
Default lEnd := .F.


dbSeek(xFilial("SE1")+DtoS(mv_par03),.T.)
While SE1->(!Eof()) .and. xFilial("SE1") == SE1->E1_FILIAL .and. SE1->E1_VENCREA <= mv_par04
	lPVen := .F.
	
	If Valtype(oReport) <> "L"
		// chamado pelo r4
		oReport:IncMeter()
	Else
		// chamado pelo r3
		IF lEnd
			@PROW()+1,001 PSAY STR0008 // "CANCELADO PELO OPERADOR"
			Exit
		Endif	
		IncRegua()
	Endif			
	
	If E1_TIPO $ MVABATIM
		dbSkip()
		Loop
	Endif
	
	If (E1_SALDO == 0  .and. Empty(SE1->E1_FATURA) .and. Empty(SE1->E1_NUMLIQ)) 
		dbSkip()
		Loop
	Endif
	
	If E1_EMISSAO < mv_par06 .or. E1_EMISSAO > mv_par07
		dbSkip()
		Loop
	Endif

	// Despreza registros de outra moeda se escolhido nao imprimir
	If mv_par11 == 2 .AND. E1_MOEDA != mv_par05 
		dbSkip()
		Loop
	Endif  
		
	nRecSe1 	:= SE1->(Recno())
	aArea       := GetArea()
	If Empty(Alltrim((E1_VEND1+E1_VEND2+E1_VEND3+E1_VEND4+E1_VEND5))) .And. E1_SALDO > 0 								
		dbSelectArea("SE5")
		dbSetOrder(10)
		If dbSeek(xFilial("SE5")+SE1->E1_NUMLIQ)			
			dbSelectArea("SE1")				
			dbSetOrder(1)
			If ! dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)				
			   SE1->(dbGoto(nRecSe1)) 			   			
			Endif					
		Endif
	Endif	
	dbSelectArea("SE1")	
	nRecSe1Pr	:= SE1->(Recno())			

	SE1->(dbGoto(nRecSe1Pr)) 
	If "NOTFAT" $ SE1->E1_FATURA .And. Empty(Alltrim((E1_VEND1+E1_VEND2+E1_VEND3+E1_VEND4+E1_VEND5))) .And. SE1->E1_SALDO == 0			
		#IFDEF TOP
			cQuery := "SELECT * FROM" + RetSqlName("SE5") + " WHERE E5_FILIAL = '" + SE1->E1_FILIAL + "' AND "		
			cQuery += "E5_FATURA = '" + SE1->E1_NUM + "' AND "
			cQuery += "D_E_L_E_T_=' ' "
			cQuery := ChangeQuery(cQuery)
			dbSelectArea("SE5")
			dbCloseArea()					
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SE5",.F., .T.)
		#ELSE			
			dbSelectArea("SE5")
			cFiltro := "E5_FILIAL == '" + SE1->E1_FILIAL + "' .And. E5_FATURA == '" + SE1->E1_NUM + "'"			
			cIndTmp := CriaTrab(nil,.F.)
			IndRegua("SE5",cIndTmp,IndexKey(),,cFiltro,STR0023)
		#ENDIF
			
		dbSelectArea("SE1")
		dbSetOrder(1)
		If (!Empty(SE5->E5_FATURA) .And. !("NOTFAT" $ SE5->E5_FATURA)) .And. dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO) 				
			nRecSe1Pr := Recno()
		Else
			nRecSe1Pr := nRecSe1
		Endif
		
		#IFDEF TOP
			dbSelectArea("SE5")
			dbCloseArea()
			ChKFile("SE5")
			dbSelectArea("SE5")
			dbSetOrder(1)			
		#ELSE			
			dbSelectArea("SE5")
			dbClearFil()
			RetIndex( "SE5" )
			dbSetOrder(1)						      				
		#ENDIF		
	ElseIf !Empty(SE1->E1_FATURA) .And. Empty(Alltrim((E1_VEND1+E1_VEND2+E1_VEND3+E1_VEND4+E1_VEND5))) .And. SE1->E1_SALDO == 0			
	    
	    dbSelectArea("SE3")
	    dbSetOrder(1)
	    If dbSeek(xFilial("SE3")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			dbSelectArea("SE1")
			RestArea(aArea)
			SE1->(dbSkip())	    	
	    	Loop
	    Endif	    
	    
	    dbSelectArea("SE5")                    
	    dbSetOrder(10)
	    If dbSeek(xFilial("SE5")+SE1->E1_NUMLIQ)
	    	dbSelectarea("SE1")
	    	dbSetOrder(1)	    	
		    If ! dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)				
			   SE1->(dbGoto(nRecSe1)) 			   							
			Endif
		Endif	
		dbSelectArea("SE1")	
		nRecSe1Pr	:= SE1->(Recno())		
	Endif
		
	RestArea(aArea)	
			
	For JX:=1 TO 5
		nx := Str(JX,1)
		
		dbSelectArea("SE1")		   
		SE1->(dbGoto(nRecSe1Pr)) 			
		
		IF !EMPTY(E1_VEND&nx.)
			If E1_VEND&nx. >= mv_par01 .and. E1_VEND&nx. <= mv_par02
						
				cVend    := E1_VEND&nx
				RestArea(aArea)
								
				If !Empty(SE1->E1_FATURA) .And. (AllTrim(SE1->E1_FATURA) <> "NOTFAT")
					aAreaSE1 := GetArea()
					cCliente := E1_CLIENTE  //Declarar variaveis 
					cLoja    := E1_LOJA
					cFatura  := E1_FATURA           
					cFatPref := E1_FATPREF  					       
					cLiquid  := "/"
					nChvFat  := SE1->(Recno())   
					SE1->(dbSetOrder(1))
					SE1->(dbGotop())
					cChaveSE1 := xFilial("SE1") + cFatPref + cFatura 
					SE1->(dbSeek(cChaveSE1))														
					
					While((cChaveSE1 == xFilial("SE1") + E1_PREFIXO + E1_NUM))
						If SE1->E1_VENCREA >= mv_par03 .And. SE1->E1_VENCREA <= mv_par04																			
							If AllTrim(E1_FATURA) == "NOTFAT" .And. E1_SALDO > 0 .And. (If(!lComiLiq,If(Empty(E1_NUMLIQ),.T.,.F.),.T.))
								GravaCom(nX,lPVen,nChvFat,cVend,nRecSe1Pr)
		  					ElseIf AllTrim(E1_FATURA) == "NOTFAT" .And. E1_SALDO == 0 .And. !Empty(SE1->E1_TIPOLIQ)		  						
		  						dbSelectArea("SE5")
		  						dbSetOrder(7)
		  						If dbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE)
		  							nRegSE1 := SE1->(Recno())
		  							dbSelectarea("SE1")
		  							dbSetOrder(15)   
		  							dbSeek(xFilial("SE1")+SE5->E5_DOCUMEN)
		  							cChaveLiq := SE1->E1_FILIAL+SE1->E1_NUMLIQ
		  							Do While cChaveLiq == SE1->E1_FILIAL+SE1->E1_NUMLIQ .And. !Eof()
		  								If SE1->E1_SALDO > 0 .And. (If(!lComiLiq,If(Empty(E1_NUMLIQ),.T.,.F.),.T.)) 
		  									GravaCom(nX,lPVen,nChvFat,cVend,nRecSe1Pr)
		  								Endif	                                                                        
		  								dbSkip()
		  							Enddo
		  							SE1->(dbGoto(nRegSE1))						
		  							dbSetOrder(1)		  									  							
		  						Endif  
		  						dbSelectArea("SE1")
		  						
		  					Endif      	
		  				Endif	
		  				DbSkip()
					EndDo
										
					RestArea(aAreaSE1)
				Else					
					If SE1->E1_SALDO > 0 .And. (If(!lComiLiq,If(Empty(E1_NUMLIQ),.T.,.F.),.T.)) 
						GravaCom(nX,lPVen,,cVend,nRecSe1Pr)					
					Endif	
				Endif
			Endif						
		Endif					
	Next
	RestArea(aArea)
	SE1->(dbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se considera pedidos de venda                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par09 == 1  // Considera Ped. Venda
	lPVen := .T.
	dbSelectarea("SC5")
	dbsetOrder(2)
		
	If Valtype(oReport) <> "L"
		oReport:SetMeter(SC5->(Reccount()))
	Endif    

	dbSeek(cFilial+DtoS(mv_par03),.T.)
	While !Eof() .and. cFilial == C5_FILIAL .and. C5_EMISSAO <= mv_par04
		
		If Valtype(oReport) <> "L"
			// chamado pelo r4
			oReport:IncMeter()
		Else
			// chamado pelo R3
			IF lEnd
				@PROW()+1,001 PSAY STR0008 // "CANCELADO PELO OPERADOR"
				Exit
			Endif
			IncRegua()
		Endif					
		
		If C5_EMISSAO < mv_par06 .or. C5_EMISSAO > mv_par07
			dbSkip()
			Loop
		Endif
		For JX:=1 TO 5  // grava vendedores no arq TRB
			nx := Str(JX,1)
			IF !EMPTY(C5_VEND&nx.)
				If C5_VEND&nx. >= mv_par01 .and. C5_VEND&nx. <= mv_par02
					GravaCom(nX,lPVen)
				End
			End
		EndFor
		dbSkip()
	Enddo
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AtuSX1      ³ Autor ³ Marcelo Celi Marques³Data ³ 23/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza SX1											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr610.prx                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AtuSX1()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

// Pergunte se deseja imprimir nome reduzido ou por razão social
//**************************************************************

Aadd( aHelpPor, 'Selecione a opção "Nome Reduzido" para '  )
Aadd( aHelpPor, 'que o cliente seja impresso pelo nome  '  )
Aadd( aHelpPor, 'reduzido, conforme cadastro, ou        '  )
Aadd( aHelpPor, '"Razão Social", para que o nome seja a '  )
Aadd( aHelpPor, 'Razão Social.' )                 

Aadd( aHelpSpa, 'Elija la opcion "Nombre Reducido" para ' )
Aadd( aHelpSpa, 'que el cliente sea impreso por el nombre')
Aadd( aHelpSpa, ' reducido, conforme el archivo, o       ' )
Aadd( aHelpSpa, '"Razon Social", para que el nombre sea ' )
Aadd( aHelpSpa, 'la Razon Social.'  )

Aadd( aHelpEng, 'Select between the options "Trade Name" ' )
Aadd( aHelpEng, 'or "Company Name" to have the customer´s')
Aadd( aHelpEng, ' name printed in the report'        )

PutSx1( "FIN610", "13","Nome cliente?","¿Nombre Cliente ?","Name customer ?","mv_chd","N",1,0,1,"C","","","","",;
		  "mv_par13","Nome reduzido","Nombre reducido","Reduced name","","Razão social","Razon social","Trade name","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


// Pergunte se deseja efetuar a busca por títulos originais ou títulos renegociados
//*********************************************************************************

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, 'Processando pelo título original, o range '		)
Aadd( aHelpPor, 'de data de vencimento considerará somente o '		)
Aadd( aHelpPor, 'título que originalizou os títulos renegociados '	) 
Aadd( aHelpPor, 'exibindo-os independente de seus vencimentos.'		)

Aadd( aHelpSpa, 'Procesando por el título original, el ' 			)
Aadd( aHelpSpa, 'intervalo de fecha de vencimiento considerará '	)
Aadd( aHelpSpa, 'solamente el título que originó los títulos ' 		) 
Aadd( aHelpSpa, 'renegociados mostrándolos independientemente ' 	) 
Aadd( aHelpSpa, 'de su vencimiento.'								)

Aadd( aHelpEng, 'When processing the original bill, the due ' 		)
Aadd( aHelpEng, 'date range will only consider the bill which '		)
Aadd( aHelpEng, 'originated the renegotiable ones, displaying '		) 
Aadd( aHelpEng, 'them regardless of their due date. '				)


PutSx1( "FIN610", "14","Considerar por?","¿Considerar por?","Consider?","mv_che","N",1,0,1,"C","","","","",;
		  "mv_par14","Tit. Originais","Tít Originales","Original Bills","","Tit. Renegociados","Tit. Renegociados","Renegotiable Bills","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

return





