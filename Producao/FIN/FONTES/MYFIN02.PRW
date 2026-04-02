#INCLUDE "MYFIN02.CH"
#INCLUDE "PROTHEUS.CH"     


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR540  ³ Autor ³ Marco Bianchi            ³ Data ³ 23/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Comissoes.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR540(void)                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER Function MYFIN02()

Local oReport
Private cAliasQry := GetNextAlias()

#IFDEF TOP
   Private cAlias    := cAliasQry
#ELSE
   Private cAlias    := "SE3"
#ENDIF

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()  
Else
	Matr540R3()
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³23/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oComissaoA
Local oComissaoS
Local oDetalhe
Local oTotal
Local cVend  		:= ""
Local dVencto   	:= CTOD( "" ) 
Local dBaixa    	:= CTOD( "" ) 
Local nVlrTitulo	:= 0
Local nBasePrt  	:= 0
Local nComPrt   	:= 0
Local cTipo     	:= ""
Local cLiquid 
Local aValLiq   	:= {}
Local nI2       	:= 0
Local aLiqProp  	:= {}
Local nValIR    	:= 0
Local nTotSemIR 	:= 0
Local nAc1      	:= 0
Local nAc2      	:= 0
Local nAc3      	:= 0
Local nDecPorc		:= TamSX3("E3_PORC")[2]
Local nTamData  	:= Len(DTOC(MsDate()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MATR540",STR0025,"MTR540P9R1", {|oReport| ReportPrint(oReport,cAliasQry,oComissaoA,oComissaoS,oDetalhe,oTotal)},STR0026)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)


Pergunte("MTR540P9R1",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oComissaoA := TRSection():New(oReport,STR0048,{"SE3","SA3"},{STR0046,STR0047},/*Campos do SX3*/,/*Campos do SIX*/)
oComissaoA:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analitico                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oComissaoA,"E3_VEND" ,"SE3",/*Titulo*/,/*Picture*/                ,/*Tamanho*/         ,/*lPixel*/  ,{|| cVend })
TRCell():New(oComissaoA,"A3_NOME" ,"SA3",/*Titulo*/,/*Picture*/                ,/*Tamanho*/         ,/*lPixel*/  ,{|| SA3->A3_NOME })

// Titulos da Comissao
oDetalhe := TRSection():New(oComissaoA,STR0048,{"SE3","SA3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oDetalhe:SetTotalInLine(.F.)
oDetalhe:SetHeaderBreak(.T.)
TRCell():New(oDetalhe,"E3_PREFIXO" 	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_NUM"		,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,{|| E3_NUM })
TRCell():New(oDetalhe,"E3_PARCELA" 	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_CODCLI"	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"A1_NREDUZ"	,cAlias,/*Titulo*/,/*Picture*/               ,30			,/*lPixel*/,{|| Substr(SA1->A1_NREDUZ,1,30) })
TRCell():New(oDetalhe,"A1_NOME"		,cAlias,/*Titulo*/,/*Picture*/               ,30			,/*lPixel*/,{|| Substr(SA1->A1_NOME,1,30)  })
TRCell():New(oDetalhe,"E3_EMISSAO"	,cAlias,/*Titulo*/,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"DVENCTO"		,"    ",STR0033   ,/*Picture*/               ,nTamData  ,/*lPixel*/,{|| dVencto })
TRCell():New(oDetalhe,"DBAIXA"		,"    ",STR0034   ,/*Picture*/               ,nTamData  ,/*lPixel*/,{|| dBaixa })
TRCell():New(oDetalhe,"E3_DATA"		,cAlias,/*Titulo*/,/*Picture*/               ,nTamData  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"E3_PEDIDO"	,cAlias,STR0039   ,/*Picture*/               ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oDetalhe,"NVLRTITULO"	,"    ",STR0035   ,PesqPict('SE3','E3_COMIS'),TamSx3("E3_COMIS"	)[1],/*lPixel*/,{|| 5,5 }) //nVlrTitulo })
TRCell():New(oDetalhe,"NBASEPRT"		,"    ",STR0036   ,PesqPict('SE3','E3_BASE') ,TamSx3("E3_BASE"	)[1],/*lPixel*/,{|| nBasePrt })
If cPaisLoc<>"BRA"
	TRCell():New(oDetalhe,"E3_PORC"	,cAlias,STR0032,tm(SE3->E3_PORC,6,nDecPorc)  ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
Else
	TRCell():New(oDetalhe,"E3_PORC"	,cAlias,STR0032,tm(SE3->E3_PORC,6)           ,/*Tamanho*/  ,/*lPixel*/,/*{|| code-block de impressao }*/)
Endif
TRCell():New(oDetalhe,"NCOMPRT"		,"   ",STR0038,PesqPict('SE3','E3_COMIS')   ,TamSx3("E3_COMIS")[1]	,/*lPixel*/,{|| nComPrt })
TRCell():New(oDetalhe,"E3_BAIEMI"	,cAlias,STR0040,/*Picture*/                   ,/*Tamanho*/  ,/*lPixel*/,{|| Substr(cTipo,1,1) })
TRCell():New(oDetalhe,"AJUSTE"		,"   ",STR0037,/*Picture*/                   ,/*Tamanho*/  ,/*lPixel*/,{|| ""})



// Titulos de Liquidacao
oLiquida := TRSection():New(oDetalhe,STR0048,{"SE1","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oLiquida:SetTotalInLine(.F.)
TRCell():New(oLiquida,"E1_NUMLIQ" 	,"   ",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,{|| cLiquid })
TRCell():New(oLiquida,"E1_PREFIXO"	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_NUM"	    ,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_PARCELA" 	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_TIPO"   	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_CLIENTE"	,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"E1_LOJA"		,"SE1",/*Titulo*/ ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oLiquida,"A1_NREDUZ"	,"SA1",/*Titulo*/ ,/*Picture*/                ,TamSX3("A1_NREDUZ")[1],/*lPixel*/,{|| Substr(SA1->A1_NREDUZ,1,30) })
TRCell():New(oLiquida,"A1_NOME"		,"SA1",/*Titulo*/ ,/*Picture*/                ,TamSX3("A1_NOME")[1],/*lPixel*/,{|| Substr(SA1->A1_NOME,1,30) })

TRCell():New(oLiquida,"E1_VALOR"		,"SE1",/*Titulo*/ ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLiquida,"NVALLIQ1"		,"   ",STR0043    ,/*Picture*/                ,/*Tamanho*/  		,/*lPixel*/,{|| aValLiq[nI2,1] })
TRCell():New(oLiquida,"NVALLIQ2"		,"   ",STR0044    ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,{|| aValLiq[nI2,2] })
TRCell():New(oLiquida,"NLIQPROP"		,"   ",STR0045    ,Tm(SE1->E1_VALOR,15,2)    ,/*Tamanho*/  		,/*lPixel*/,{|| aLiqProp[nI2] })

//-- Secao Totalizadora do Valor do IR e Total (-) IR
oTotal := TRSection():New(oReport,"",{},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oTotal,"TOTALIR"     ,"   ",STR0028,"@E 99,999,999.99",12         ,/*lPixel*/,{|| nValIR })
TRCell():New(oTotal,"TOTSEMIR"    ,"   ",STR0029,"@E 99,999,999.99",12         ,/*lPixel*/,{|| nTotSemIR })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sintetico                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oComissaoS := TRSection():New(oReport,STR0049,{"SE3","SA3"},{STR0046,STR0047},/*Campos do SX3*/,/*Campos do SIX*/)
oComissaoS:SetTotalInLine(.F.)

TRCell():New(oComissaoS,"E3_VEND" ,"SE3",/*Titulo*/,/*Picture*/                	,/*Tamanho*/          	,/*lPixel*/	,{|| cVend })
TRCell():New(oComissaoS,"A3_NOME" ,"SA3",/*Titulo*/,/*Picture*/					,/*Tamanho*/          	,/*lPixel*/	,{|| SA3->A3_NOME })
TRCell():New(oComissaoS,"TOTALTIT",""		,STR0027   ,PesqPict('SE3','E3_BASE') 	,TamSx3("E3_BASE")[1] 	,/*lPixel*/	,{|| nAc3 })
TRCell():New(oComissaoS,"E3_BASE" ,cAlias,STR0030   ,PesqPict('SE3','E3_BASE') 	,TamSx3("E3_BASE")[1] 	,/*lPixel*/	,{|| nAc1 })
TRCell():New(oComissaoS,"E3_PORC" ,cAlias,STR0032   ,PesqPict('SE3','E3_PORC') 	,TamSx3("E3_PORC")[1] 	,/*lPixel*/	,{|| (nAc2*100) / nAc1})
TRCell():New(oComissaoS,"E3_COMIS",cAlias,STR0031   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{|| nAc2 })
TRCell():New(oComissaoS,"VALIR"   ,""   	,STR0028   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{||nValIR })
TRCell():New(oComissaoS,"TOTSEMIR",""   	,STR0029   ,PesqPict('SE3','E3_COMIS')	,TamSx3("E3_COMIS")[1]	,/*lPixel*/	,{||nTotSemIR})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho no topo da pagina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):SetHeaderPage()
oReport:Section(3):SetHeaderPage()
oReport:Section(2):Setedit(.F.)
oReport:Section(1):Section(1):Setedit(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alinhamento a direita dos campos de valores                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Analitico
oDetalhe:Cell("NVLRTITULO"):SetHeaderAlign("RIGHT")
oDetalhe:Cell("NBASEPRT"):SetHeaderAlign("RIGHT")
oDetalhe:Cell("NCOMPRT"):SetHeaderAlign("RIGHT")
//Sintetico
oComissaoS:Cell("TOTALTIT"):SetHeaderAlign("RIGHT")
oComissaoS:Cell("E3_BASE" ):SetHeaderAlign("RIGHT")
oComissaoS:Cell("E3_COMIS"):SetHeaderAlign("RIGHT")
oComissaoS:Cell("VALIR"   ):SetHeaderAlign("RIGHT")
oComissaoS:Cell("TOTSEMIR"):SetHeaderAlign("RIGHT")

//IR
oTotal:Cell("TOTALIR"):SetHeaderAlign("RIGHT")
oTotal:Cell("TOTSEMIR"):SetHeaderAlign("RIGHT")

Return(oReport)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Eduardo Riera          ³ Data ³04.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasQry,oComissaoA,oComissaoS,oDetalhe,oTotal)

Local lQuery   := .F.
Local dEmissao := CTOD( "" ) 
Local nTotLiq  := 0
Local aLiquid  := {}
Local ny 
Local cWhere   := ""
Local cNomArq, cFilialSE1, cFilialSE3
Local nI       := 0
Local cOrder   := ""
Local nDecs
Local nTotPorc := 0

#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

Local cDocLiq   := ""
Local cTitulo   := ""                                     
Local cAjuste   := ""
Local nTotBase	:= 0
Local nTotComis	:= 0
Local nSection	:= 0
Local nOrdem	:= 0

If oReport:Section(1):GetOrder() == 1		// Ordem: por Titulo
	nOrdem := 1
Else										// Ordem: por Cliente
	nOrdem := 2
EndIf	

If mv_par10 == 1	// Analitico
	oReport:Section(3):Disable()
	nSection := 1   
	
	If mv_par12 == 1
		oReport:Section(1):section(1):Cell("A1_NOME"):Disable()
		oReport:Section(1):section(1):Section(1):Cell("A1_NOME"):Disable()
	Else
		oReport:Section(1):section(1):Cell("A1_NREDUZ"):Disable()
		oReport:Section(1):section(1):Section(1):Cell("A1_NREDUZ"):Disable()
	EndIf
	oReport:Section(1):Cell("E3_VEND"):SetBlock({|| cVend })	
	oReport:Section(1):Section(1):Cell("DVENCTO" ):SetBlock({|| dVencto })	
	oReport:Section(1):Section(1):Cell("DBAIXA" ):SetBlock({|| dBaixa })	
	oReport:Section(1):Section(1):Cell("NVLRTITULO" ):SetBlock({|| nVlrTitulo })	
	oReport:Section(1):Section(1):Cell("NBASEPRT" ):SetBlock({|| nBasePrt })	
	oReport:Section(1):Section(1):Cell("NCOMPRT" ):SetBlock({|| nComPrt })	
	oReport:Section(1):Section(1):Cell("E3_BAIEMI" ):SetBlock({|| Substr(cTipo,1,1) })	
	oReport:Section(1):Section(1):Cell("AJUSTE" ):SetBlock({|| IIf( (cAjuste == "S" .And. MV_PAR06 == 1),"AJUSTE","" ) })	
	oReport:Section(1):Section(1):Section(1):Cell("E1_NUMLIQ" ):SetBlock({|| cLiquid  })	
	oReport:Section(1):Section(1):Section(1):Cell("NVALLIQ1" ):SetBlock({|| aValLiq[nI2,1] })	
	oReport:Section(1):Section(1):Section(1):Cell("NVALLIQ2" ):SetBlock({|| aValLiq[nI2,2] })	
	oReport:Section(1):Section(1):Section(1):Cell("NLIQPROP" ):SetBlock({|| aLiqProp[nI2] })	
	oReport:Section(2):Cell("TOTALIR" ):SetBlock({|| nValIR })	
	oReport:Section(2):Cell("TOTSEMIR" ):SetBlock({|| nTotSemIR })	

    bVOrig := { || cDocLiq := SE1->E1_NUMLIQ, nVlrTitulo := Iif(cTitulo <> (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA .And. Empty(cDocLiq), nVlrTitulo, 0 ) }
    
	TRFunction():New(oDetalhe:Cell("NVLRTITULO"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,bVOrig,.T./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oDetalhe:Cell("NBASEPRT")  ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oDetalhe:Cell("NCOMPRT")   ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oDetalhe:Cell("E3_PORC")   ,/* cID */,"AVERAGE",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,IIf(mv_par11 == 2,.T.,.F.)/*lEndReport*/,.F.)	
	
	If mv_par08 > 0
		TRFunction():New(oTotal:Cell("TOTALIR") ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oTotal:Cell("TOTSEMIR") ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,IIf(mv_par09 == 2,.T.,.F.)/*lEndReport*/,/*lEndPage*/)
	EndIf	

	cVend		:= ""
	dVencto 	:= ctod("  /  /  ")
	dBaixa 		:= ctod("  /  /  ")
	nVlrTitulo 	:= 0
	nBasePrt 	:= 0
	nComPrt 	:= 0
	cTipo 		:= ""
	cLiquid  	:= ""
	nValIR		:= 0
	nTotSemIR 	:= 0
	
Else				// Sintetico

	TRFunction():New(oComissaoS:Cell("TOTALTIT"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_BASE"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_PORC"),/* cID */,"MAX",/*oBreak*/,/*cTitle*/,/*cPicture*/,{||nTotPorc},.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("E3_COMIS"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("VALIR"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oComissaoS:Cell("TOTSEMIR"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

	oReport:Section(1):Disable()
	oReport:Section(1):Section(1):Disable()
	oReport:Section(1):Section(1):Section(1):Disable()
	nSection := 3
	
	oReport:Section(3):Cell("E3_VEND" ):SetBlock({|| cVend })		
	oReport:Section(3):Cell("TOTALTIT" ):SetBlock({|| nAc3 })		
	oReport:Section(3):Cell("E3_BASE" ):SetBlock({|| nAc1 })		
	oReport:Section(3):Cell("E3_PORC" ):SetBlock({|| (nAc2*100) / nAc1 })		
	oReport:Section(3):Cell("E3_COMIS" ):SetBlock({||nAc2 })		
	oReport:Section(3):Cell("VALIR" ):SetBlock({|| nValIR })	
	oReport:Section(3):Cell("TOTSEMIR" ):SetBlock({|| nTotSemIR })	

	cVend		:= ""
	nAc1		:= 0
	nAc2		:= 0
	nAc3		:= 0
	nValIR		:= 0
	nTotSemIR	:= 0
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF TOP

	// Indexa de acordo com ordem escolhida oelo cliente
	dbSelectArea("SE3")
	If nOrdem == 1		// Ordem: por Titulo
		dbSetOrder(2)   
		cOrder := "%E3_FILIAL,E3_VEND,E3_PREFIXO,E3_NUM,E3_PARCELA%"
	Else										// Ordem: por Cliente
		dbSetOrder(3)
		cOrder := "%E3_FILIAL,E3_VEND,E3_CODCLI,E3_LOJA,E3_PREFIXO,E3_NUM,E3_PARCELA%"
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuery := .T.                 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)	
	
	oReport:Section(nSection):BeginQuery()
	cWhere :="%"             
	If mv_par01 == 1
		cWhere += "AND E3_BAIEMI <> 'B'"  //Baseado pela emissao da NF
	Elseif mv_par01 == 2
		cWhere += "AND E3_BAIEMI =  'B'"  //Baseado pela baixa do titulo
	EndIf
	If mv_par05 == 1 		//Comissoes a pagar
		cWhere += "AND E3_DATA = '" + Dtos(Ctod("")) + "'"
	ElseIf mv_par05 == 2 //Comissoes pagas
		cWhere += "AND E3_DATA <> '" + Dtos(Ctod("")) + "'"
	Endif
	cWhere +="%"
	
	BeginSql Alias cAliasQry
	SELECT E3_FILIAL,E3_BASE, E3_COMIS, E3_VEND, E3_PORC, A3_NOME, E3_PREFIXO,E3_NUM, E3_PARCELA,E3_TIPO,E3_CODCLI,E3_LOJA,E3_AJUSTE,E3_BAIEMI,E3_EMISSAO,E3_DATA, E3_PEDIDO
		FROM %table:SE3% SE3
		LEFT JOIN %table:SA3% SA3
	        ON A3_FILIAL = %xFilial:SA3%
			AND A3_COD = E3_VEND
			AND SA3.%NotDel%
		WHERE E3_FILIAL = %xFilial:SE3%
			AND	E3_EMISSAO >= %Exp:Dtos(mv_par02)%
			AND E3_EMISSAO <= %Exp:Dtos(mv_par03)%
			AND SE3.%notdel%
			%Exp:cWhere%
	ORDER BY %Exp:cOrder%
	EndSql
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(nSection):EndQuery({MV_PAR04})


#ELSE
   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros para ambiente CDX ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr("MTR540P9R1") 

	// Indexa de acordo com ordem escolhida oelo cliente
	dbSelectArea("SE3")
	If nOrdem == 1		// Ordem: por Titulo
		dbSetOrder(2)   
		cOrder := "E3_FILIAL+E3_VEND+E3_PREFIXO+E3_NUM+E3_PARCELA"
	Else										// Ordem: por Cliente
		dbSetOrder(3)
		cOrder := "E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM+E3_PARCELA"
	EndIf	
	
	DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
	DbSetOrder(3)			// Por Vendedor, Cliente, Loja, Prefixo, Numero
	cFilialSE3 := xFilial()
	cNomArq    := CriaTrab("",.F.)
	
	cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
	
	If !Empty(mv_par04)
		cCondicao +=  " .AND. "+MV_PAR04
	EndIf
	
	cCondicao += " .AND. DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
	cCondicao += " .AND. DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'"	
	                                 
	If mv_par01 == 1
		cCondicao += " .AND. SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
	Elseif mv_par01 == 2
		cCondicao += " .AND. SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
	Endif	
		
	If mv_par05 == 1 		// Comissoes a pagar
		cCondicao += " .AND. Dtos(SE3->E3_DATA)== '"+Dtos(Ctod(""))+"'"
	ElseIf mv_par05 == 2 // Comissoes pagas
		cCondicao += " .AND. Dtos(SE3->E3_DATA)!= '"+Dtos(Ctod(""))+"'"
	Endif
	
	oReport:Section(nSection):SetFilter(cCondicao,cOrder)      // abre tela de imprimindo...
	
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oReport:Section(nSection),"SA3",1,{|| xFilial("SA3")+cVend })
If mv_par10 == 1
   TRPosition():New(oReport:Section(1):Section(1),"SA1",1,{|| xFilial("SA1")+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA })
   TRPosition():New(oReport:Section(1):Section(1):Section(1),"SA1",1,{|| xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA })
EndIf   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par10 == 2
	nTotBase	:= 0
	nTotComis	:= 0
EndIf

dbSelectArea(cAlias)
dbGoTop()
nDecs     := GetMv("MV_CENT"+(IIF(mv_par07 > 1 , STR(mv_par07,1),"")))

oReport:SetMeter(SE3->(LastRec()))
dbSelectArea(cAlias)
While !oReport:Cancel() .And. !&(cAlias)->(Eof())
	
	cVend := &(cAlias)->(E3_VEND)
	nAc1 := 0
	nAc2 := 0
	nAc3 := 0
	
	oReport:Section(nSection):Init()
	If mv_par10 == 1
		oReport:Section(nSection):PrintLine()
	EndIf	

	
	While !Eof() .And. xFilial("SE3") == (cAlias)->E3_FILIAL .And. (cAlias)->E3_VEND == cVend
		nBasePrt   := 0
		nComPrt    := 0
		nVlrTitulo := 0
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+&(cAlias)->(E3_PREFIXO)+&(cAlias)->(E3_NUM)+&(cAlias)->(E3_PARCELA)+&(cAlias)->(E3_TIPO))
		nVlrTitulo:= Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR07,SE1->E1_EMISSAO,nDecs+1),nDecs)
		dEmissao  := SE1->E1_EMISSAO
		cLiquid   := ""
		cDocLiq   := SE1->E1_NUMLIQ
		
		If mv_par10 == 1
			dVencto   := SE1->E1_VENCTO
			aLiquid	  := {}
			aValLiq	  := {}
			aLiqProp  := {}
			nTotLiq	  := 0
			If mv_par11 == 1 .And. !Empty(SE1->E1_NUMLIQ) .And. FindFunction("FA440LIQSE1")
				cLiquid := SE1->E1_NUMLIQ
				cDocLiq := SE1->E1_NUMLIQ
				// Obtem os registros que deram origem ao titulo gerado pela liquidacao
				Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid,@aValLiq)
				For ny := 1 to Len(aValLiq)
					nTotLiq += aValLiq[ny,2]
				Next
				For ny := 1 to Len(aValLiq)
					aAdd(aLiqProp,(nVlrTitulo/nTotLiq)*aValLiq[ny,2])
				Next
			Endif
			
			If (cAlias)->E3_BAIEMI == "B"
				dBaixa     := (cAlias)->E3_EMISSAO
			Else
				dBaixa     := SE1->E1_BAIXA
			Endif
		EndIf
		
		If Eof()
			dbSelectArea("SF2")
			dbSetorder(1)
			dbSeek(xFilial()+(cAlias)->E3_NUM+(cAlias)->E3_PREFIXO)
			nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par07,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
			dEmissao   := SF2->F2_EMISSAO
			
			If mv_par10 == 1
				dVencto    := CTOD( "" )
				dBaixa     := CTOD( "" )  	
			EndIf
			
			If Eof()
				nVlrTitulo := 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				cFilialSE1 := xFilial()
				dbSeek(cFilialSE1+&(cAlias)->(E3_PREFIXO)+&(cAlias)->(E3_NUM))
				While ( !Eof() .And. (cAlias)->E3_PREFIXO == SE1->E1_PREFIXO .And.;
					(cAlias)->E3_NUM == SE1->E1_NUM .And.;
					(cAlias)->E3_FILIAL == cFilialSE1 )
					If ( SE1->E1_TIPO == (cAlias)->E3_TIPO  .And. ;
						SE1->E1_CLIENTE == (cAlias)->E3_CODCLI .And. ;
						SE1->E1_LOJA == (cAlias)->E3_LOJA )
						nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR07,SE1->E1_EMISSAO,nDecs+1),nDecs)
						
						If mv_par10 == 1
							dVencto    := CTOD( "" )
							dBaixa     := CTOD( "" )
						EndIf

						If Empty(dEmissao)
							dEmissao := SE1->E1_EMISSAO
						EndIf
						
					EndIf
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
		Endif
		
		If Empty(dEmissao)
			dEmissao := NIL
		EndIf
		
		nBasePrt:=	Round(xMoeda((cAlias)->E3_BASE ,1,MV_PAR07,dEmissao,nDecs+1),nDecs)
		nComPrt :=	Round(xMoeda((cAlias)->E3_COMIS,1,MV_PAR07,dEmissao,nDecs+1),nDecs)
		
		If nBasePrt < 0 .And. nComPrt < 0
			nVlrTitulo := nVlrTitulo * -1
		Endif
		
		If mv_par10 == 1
			cAjuste := (cAlias)->E3_AJUSTE
			cTipo   := (cAlias)->E3_BAIEMI
			dbSelectArea(cAlias)
			oReport:Section(1):Section(1):Init()
			oReport:Section(1):Section(1):PrintLine()
			oReport:IncMeter()
			
			If mv_par11 == 1
				For nI := 1 To Len(aLiquid)
					nI2 := nI
					SE1->(MsGoto(aLiquid[nI]))
				    oReport:Section(1):SetHeaderBreak(.T.)
					oReport:Section(1):Section(1):Section(1):Init()
					oReport:Section(1):Section(1):Section(1):PrintLine()
				Next
				oReport:Section(1):Section(1):Section(1):Finish()
			Endif			
			
		EndIf
		
		nAc1 += nBasePrt
		nAc2 += nComPrt
		If cTitulo <> (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA  .And. Empty(cDocLiq)
			nAc3   += nVlrTitulo
			cTitulo:= (cAlias)->E3_PREFIXO+(cAlias)->E3_NUM+(cAlias)->E3_PARCELA+(cAlias)->E3_TIPO+(cAlias)->E3_VEND+(cAlias)->E3_CODCLI+(cAlias)->E3_LOJA
			cDocLiq:= ""
		EndIf
		
		dbSelectArea(cAlias)
		dbSkip()
	EndDo
	
	If mv_par10 == 1
		oReport:Section(1):Section(1):SetTotalText("Total do Vendedor " + cVend)
		oReport:Section(1):Section(1):Finish()
	EndIf
	
	nValIR    := 0
	nTotSemIR := 0
	If mv_par08 > 0 .And. (nAc2 * mv_par08 / 100) > GetMV("MV_VLRETIR") //IR
		nValIR    := nAc2 * (MV_PAR08/100)
		nTotSemIR := nAc2 - (nAc2 * (MV_PAR08/100))
	Else
		nTotSemIR := nAc2
	EndIf
	
	If mv_par10 == 2
		nTotBase 	+= nAc1
		nTotComis 	+= nAc2
		nTotPorc	:= (nTotComis / nTotBase)*100
		oReport:Section(nSection):Init()				
		oReport:Section(nSection):PrintLine()
	EndIf	
	oReport:Section(nSection):Finish()
	
	If mv_par10 == 1 .And. mv_par08 > 0
		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	EndIf
	
	If mv_par09 == 1
	   oReport:Section(nSection):SetPageBreak(.T.)
	EndIf
	
	If mv_par10 == 2
		oReport:IncMeter()
	EndIf
	
EndDo

oReport:Section(nSection):SetPageBreak(.T.)

#IFNDEF TOP
   RetIndex("SE3")
#ENDIF
   


Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR540R3³ Autor ³ Claudinei M. Benzi       ³ Data ³ 13.04.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Comissoes.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR540(void)                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Programad.³ALTERACAO                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³05.02.03³XXXXXX³Eduardo Ju³Inclusao de Queries para filtros em TOPCONNECT.³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

STATIC Function Matr540R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel
Local titulo    := STR0001  //"Relatorio de Comissoes"
Local cDesc1    := STR0002  //"Emissao do relatorio de Comissoes."
Local tamanho   := "G"
Local limite    := 220
Local cString   := "SE3"
Local cAliasAnt := Alias()
Local cOrdemAnt := IndexOrd()
Local nRegAnt   := Recno()
Local cDescVend := " "

Private aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:= "MATR540A"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "MTR540"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
Pergunte("MTR540",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                          ³
//³ mv_par01        	// Pela <E>missao,<B>aixa ou <A>mbos      ³
//³ mv_par02        	// A partir da data                       ³
//³ mv_par03        	// Ate a Data                             ³
//³ mv_par04 	    	// Do Vendedor                            ³
//³ mv_par05	     	// Ao Vendedor                            ³
//³ mv_par06	     	// Quais (a Pagar/Pagas/Ambas)            ³
//³ mv_par07	     	// Incluir Devolucao ?                    ³
//³ mv_par08	     	// Qual moeda                             ³
//³ mv_par09	     	// Comissao Zerada ?                      ³
//³ mv_par10	     	// Abate IR Comiss                        ³
//³ mv_par11	     	// Quebra pag.p/Vendedor                  ³
//³ mv_par12	     	// Tipo de Relatorio (Analitico/Sintetico)³
//³ mv_par13	     	// Imprime detalhes origem                ³
//³ mv_par14         // Nome cliente							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "MATR540A"
wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,"","",.F.,"",.F.,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey ==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C540Imp(@lEnd,wnRel,cString)},Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna para area anterior, indice anterior e registro ant.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(caliasAnt)
DbSetOrder(cOrdemAnt)
DbGoto(nRegAnt)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C540IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR540			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C540Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbCont,cabec1,cabec2
Local tamanho  := "G"
Local limite   := 220
Local nomeprog := "MATR540A"
Local imprime  := .T.
Local cPict    := ""
Local cTexto,j :=0,nTipo:=0
Local cCodAnt,nCol:=0
Local nAc1:=0,nAc2:=0,nAg1:=0,nAg2:=0,nAc3:=0,nAg3:=0,nAc4:=0,nAg4:=0,lFirstV:=.T.
Local nTregs,nMult,nAnt,nAtu,nCnt,cSav20,cSav7
Local lContinua:= .T.
Local cNFiscal :=""
Local aCampos  :={}
Local lImpDev  := .F.
Local cBase    := ""
Local cNomArq, cCondicao, cFilialSE1, cFilialSE3, cChave, cFiltroUsu
Local nDecs    := GetMv("MV_CENT"+(IIF(mv_par08 > 1 , STR(mv_par08,1),"")))
Local nBasePrt :=0, nComPrt:=0 
Local aStru    := SE3->(dbStruct()), ni
Local nDecPorc := TamSX3("E3_PORC")[2]

Local cDocLiq   := ""
Local cTitulo  := "" 
Local dEmissao := CTOD( "" ) 
Local nTotLiq  := 0
Local aLiquid  := {}
Local aValLiq  := {}
Local aLiqProp := {}
Local ny
Local aColuna := IIF(cPaisLoc <> "MEX",{15,19,42,46,83,95,107,119,130,137,153,169,176,195,203},{28,35,58,62,99,111,123,135,146,153,169,185,192,211,219})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

nTipo := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par12 == 1
	If mv_par01 == 1
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0006)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
	Elseif mv_par01 == 2
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0007)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
	Else
		titulo := OemToAnsi(STR0008)+" ("+OemToAnsi(STR0019)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
	Endif

	cabec1:=OemToAnsi(STR0009)	//"PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE     DATA        DATA        DATA       NUMERO                          VALOR      %           VALOR    TIPO"
	cabec2:=OemToAnsi(STR0010)	//"    TITULO         CLIENTE                                                         COMISSAO    VENCTO      BAIXA       PAGTO      PEDIDO                           BASE               COMISSAO   COMISSAO"
									// XXX XXXXXXxxxxxx X XXXXXXxxxxxxxxxxxxxx   XX  012345678901234567890123456789012345 XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx XXXXXX 12345678901,23  12345678901,23  99.99  12345678901,23     X       AJUSTE
									// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
									// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	If cPaisLoc == "MEX"
		Cabec1 := Substr(Cabec1,1,10) + Space(16) + Substr(Cabec1,11)
		Cabec2 := Substr(Cabec2,1,10) + Space(16) + Substr(Cabec2,11)
	EndIf								
Else
	If mv_par01 == 1
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0006)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
	Elseif mv_par01 == 2
		titulo := OemToAnsi(STR0005)+OemToAnsi(STR0007)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
	Else
		titulo := OemToAnsi(STR0008)+" ("+OemToAnsi(STR0020)+") "+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
	Endif
	cabec1:=OemToAnsi(STR0021) //"CODIGO VENDEDOR                                                            TOTAL      %            TOTAL           TOTAL           TOTAL"
	cabec2:=OemToAnsi(STR0022) //"                                                                            BASE                COMISSAO              IR          (-) IR"
                                //"XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 123456789012,23  123456789012,23  99.99  123456789012,23 123456789012,23 123456789012,23
                                //"0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
                                //"0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
EndIf
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta condicao para filtro do arquivo de trabalho            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
DbSetOrder(2)			// Por Vendedor
cFilialSE3 := xFilial()
cNomArq :=CriaTrab("",.F.)

cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
cCondicao += ".And.SE3->E3_VEND>='" + mv_par04 + "'"
cCondicao += ".And.SE3->E3_VEND<='" + mv_par05 + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'" 

If mv_par01 == 1
	cCondicao += ".And.SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
Elseif mv_par01 == 2
	cCondicao += " .And.SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
Endif 

If mv_par06 == 1 		// Comissoes a pagar
	cCondicao += ".And.Dtos(SE3->E3_DATA)=='"+Dtos(Ctod(""))+"'"
ElseIf mv_par06 == 2 // Comissoes pagas
	cCondicao += ".And.Dtos(SE3->E3_DATA)!='"+Dtos(Ctod(""))+"'"
Endif

If mv_par09 == 1 		// Nao Inclui Comissoes Zeradas
   cCondicao += ".And.SE3->E3_COMIS<>0"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria expressao de filtro do usuario                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( ! Empty(aReturn[7]) )
	cFiltroUsu := &("{ || " + aReturn[7] +  " }")
Else
	cFiltroUsu := { || .t. }
Endif

nAg1 := nAg2 := nAg3 := nAg4 := 0

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cOrder := SqlOrder(SE3->(IndexKey()))
		
		cQuery := "SELECT * "
		cQuery += "  FROM "+	RetSqlName("SE3")
		cQuery += " WHERE E3_FILIAL = '" + xFilial("SE3") + "' AND "
	  	cQuery += "	E3_VEND >= '"  + mv_par04 + "' AND E3_VEND <= '"  + mv_par05 + "' AND " 
		cQuery += "	E3_EMISSAO >= '" + Dtos(mv_par02) + "' AND E3_EMISSAO <= '"  + Dtos(mv_par03) + "' AND " 
		
		If mv_par01 == 1
			cQuery += "E3_BAIEMI <> 'B' AND "  //Baseado pela emissao da NF
		Elseif mv_par01 == 2
			cQuery += "E3_BAIEMI =  'B' AND "  //Baseado pela baixa do titulo  
		EndIf	
		
		If mv_par06 == 1 		//Comissoes a pagar
			cQuery += "E3_DATA = '" + Dtos(Ctod("")) + "' AND "
		ElseIf mv_par06 == 2 //Comissoes pagas
  			cQuery += "E3_DATA <> '" + Dtos(Ctod("")) + "' AND "
		Endif 
		
		If mv_par09 == 1 		//Nao Inclui Comissoes Zeradas
   		cQuery+= "E3_COMIS <> 0 AND "
		EndIf  
		
		cQuery += "D_E_L_E_T_ <> '*' "   

		cQuery += " ORDER BY "+ cOrder

		cQuery := ChangeQuery(cQuery)
											
		dbSelectArea("SE3")
		dbCloseArea()
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE3', .F., .T.)
			
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE3', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next 
	Else
	
#ENDIF	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria arquivo de trabalho                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cChave := IndexKey()
		cNomArq :=CriaTrab("",.F.)
		IndRegua("SE3",cNomArq,cChave,,cCondicao, OemToAnsi(STR0016)) //"Selecionando Registros..."
		nIndex := RetIndex("SE3")
		DbSelectArea("SE3") 
		#IFNDEF TOP
			DbSetIndex(cNomArq+OrdBagExT())
		#ENDIF
		DbSetOrder(nIndex+1)

#IFDEF TOP
	EndIf
#ENDIF	

SetRegua(RecCount())		// Total de Elementos da regua 
DbGotop()
While !Eof()
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi(STR0011)  //"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF
	IncRegua()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa condicao do filtro do usuario                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! Eval(cFiltroUsu)
		Dbskip()
		Loop
	Endif
	
	nAc1 := nAc2 := nAc3 := nAc4 := 0
	lFirstV:= .T.
	cVend  := SE3->E3_VEND
	
	While !Eof() .AND. SE3->E3_VEND == cVend
		IncRegua()
		cDocLiq:= ""
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processa condicao do filtro do usuario                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! Eval(cFiltroUsu)
			Dbskip()
			Loop
		Endif  
		
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona o Codigo do Vendedor e Imprime o seu Nome          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lFirstV
			dbSelectArea("SA3")
			dbSeek(xFilial()+SE3->E3_VEND)
			If mv_par12 == 1
				cDescVend := SE3->E3_VEND + " " + A3_NOME 
				@li, 00 PSAY OemToAnsi(STR0012) + cDescVend //"Vendedor : "
				li+=2
			Else
				@li, 00 PSAY SE3->E3_VEND
				@li, 07 PSAY A3_NOME 
			EndIf
			dbSelectArea("SE3")
			lFirstV := .F.
		EndIF
		
		If mv_par12 == 1
			@li, 00 PSAY SE3->E3_PREFIXO
			@li, 04 PSAY SE3->E3_NUM
			@li, aColuna[1] PSAY SE3->E3_PARCELA
			@li, aColuna[2] PSAY SE3->E3_CODCLI
			@li, aColuna[3] PSAY SE3->E3_LOJA
		
			dbSelectArea("SA1")
			dbSeek(xFilial()+SE3->E3_CODCLI+SE3->E3_LOJA)
			@li, aColuna[4] PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
		
			dbSelectArea("SE3")
			@li, aColuna[5] PSAY SE3->E3_EMISSAO
		EndIf
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)
		nVlrTitulo := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
		dVencto    := SE1->E1_VENCTO  
		dEmissao   := SE1->E1_EMISSAO 
		aLiquid	  := {}
		aValLiq		:= {}
		aLiqProp	  	:= {}
		nTotLiq		:= 0
		If mv_par13 == 1 .And. !Empty(SE1->E1_NUMLIQ) .And. FindFunction("FA440LIQSE1")
			cLiquid := SE1->E1_NUMLIQ			
			cDocLiq := SE1->E1_NUMLIQ
			// Obtem os registros que deram origem ao titulo gerado pela liquidacao
			Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid,@aValLiq)
			For ny := 1 to Len(aValLiq)
				nTotLiq += aValLiq[ny,2]
			Next
			For ny := 1 to Len(aValLiq)
				aAdd(aLiqProp,(nVlrTitulo/nTotLiq)*aValLiq[ny,2])
			Next
		Endif
		/*
		Nas comissoes geradas por baixa pego a data da emissao da comissao que eh igual a data da baixa do titulo.
		Isto somente dara diferenca nas baixas parciais
		*/	 
		
		If SE3->E3_BAIEMI == "B"
			dBaixa     := SE3->E3_EMISSAO
    	Else
			dBaixa     := SE1->E1_BAIXA
		Endif
		
		If Eof()
			dbSelectArea("SF2")
			dbSetorder(1)
			dbSeek(xFilial()+SE3->E3_NUM+SE3->E3_PREFIXO) 
			nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par08,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
			
			dVencto    := " "
			dBaixa     := " "
			
			dEmissao   := SF2->F2_EMISSAO 
			
			If Eof()
				nVlrTitulo := 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				cFilialSE1 := xFilial()
				dbSeek(cFilialSE1+SE3->E3_PREFIXO+SE3->E3_NUM)
				While ( !Eof() .And. SE3->E3_PREFIXO == SE1->E1_PREFIXO .And.;
						SE3->E3_NUM == SE1->E1_NUM .And.;
						SE3->E3_FILIAL == cFilialSE1 )
					If ( SE1->E1_TIPO == SE3->E3_TIPO  .And. ;
						SE1->E1_CLIENTE == SE3->E3_CODCLI .And. ;
						SE1->E1_LOJA == SE3->E3_LOJA )
						nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
						dVencto    := " "
						dBaixa     := " "
						If Empty(dEmissao)
							dEmissao := SE1->E1_EMISSAO
						EndIf
					EndIf
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
		Endif


		If Empty(dEmissao)
			dEmissao := NIL
		EndIf
		
		//Preciso destes valores para pasar como parametro na funcao TM(), e como 
		//usando a xmoeda direto na impressao afetaria a performance (deveria executar
		//duas vezes, uma para imprimir e outra para pasar para a picture), elas devem]
		//ser inicializadas aqui. Bruno.

		nBasePrt:=	Round(xMoeda(SE3->E3_BASE ,1,MV_PAR08,dEmissao,nDecs+1),nDecs)
		nComPrt :=	Round(xMoeda(SE3->E3_COMIS,1,MV_PAR08,dEmissao,nDecs+1),nDecs)

		If nBasePrt < 0 .And. nComPrt < 0
			nVlrTitulo := nVlrTitulo * -1
		Endif	
		
		dbSelectArea("SE3")
		
		If mv_par12 == 1
			@ li,aColuna[6]  PSAY dVencto
			@ li,aColuna[7]  PSAY dBaixa
			@ li,aColuna[8]  PSAY SE3->E3_DATA
			@ li,aColuna[9]  PSAY SE3->E3_PEDIDO	Picture "@!"
	  //		@ li,aColuna[10] PSAY nVlrTitulo		Picture tm(nVlrTitulo,14,nDecs)
			@ li,aColuna[11] PSAY nBasePrt 			Picture tm(nBasePrt,14,nDecs)
			If cPaisLoc<>"BRA"
				@ li,aColuna[12] PSAY SE3->E3_PORC		Picture tm(SE3->E3_PORC,6,nDecPorc)
			Else
				@ li,aColuna[12] PSAY SE3->E3_PORC		Picture tm(SE3->E3_PORC,6)
			Endif
			@ li,aColuna[13] PSAY nComPrt			Picture tm(nComPrt,14,nDecs)
			@ li,aColuna[14] PSAY SE3->E3_BAIEMI

			If ( SE3->E3_AJUSTE == "S" .And. MV_PAR07==1)
				@ li,aColuna[15] PSAY STR0018 //"AJUSTE "
			EndIf
			li++
			// Imprime titulos que deram origem ao titulo gerado por liquidacao
			If mv_par13 == 1
				For nI := 1 To Len(aLiquid)
					If li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
					EndIF
					If nI == 1
						@ ++li, 0 PSAY __PrtThinLine()
						@ ++li, 0 PSAY STR0023 +SE1->E1_NUMLIQ // "Detalhes : Titulos de origem da liquidação "
						@ ++li,10 PSAY STR0024 // "Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                                         Data Liq.         Valor Liquidação      Valor Base Liq."
//         Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                                         Data Liq.         Valor Liquidação      Valor Base Liq.
//         XXX        XXXXXXXXXXXX    XXX     XXXX    XXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999999999999999     99/99/9999          999999999999999      999999999999999 
   					@ ++li, 0 PSAY __PrtThinLine()
						li++
					Endif
					cDocLiq  := SE1->E1_NUMLIQ
					SE1->(MsGoto(aLiquid[nI]))
					SA1->(MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
					@li,  10 PSAY SE1->E1_PREFIXO
					@li,  21 PSAY SE1->E1_NUM
					@li,  37 PSAY SE1->E1_PARCELA
					@li,  45 PSAY SE1->E1_TIPO
					@li,  53 PSAY SE1->E1_CLIENTE
					@li,  64 PSAY SE1->E1_LOJA
					@li,  71 PSAY IF(mv_par14 == 1,Substr(SA1->A1_NREDUZ,1,35),Substr(SA1->A1_NOME,1,35))
					@li, 111 PSAY SE1->E1_VALOR PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					@li, 132 PSAY aValLiq[nI,1] 
					@li, 151 PSAY aValLiq[nI,2] PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					@li, 172 PSAY aLiqProp[nI] PICTURE Tm(SE1->E1_VALOR,15,nDecs)
					li++
				Next
				// Imprime o separador da ultima linha
				If Len(aLiquid) >= 1
					@ li++, 0 PSAY __PrtThinLine()
				Endif
			Endif	
		EndIf
		nAc1 += nBasePrt
		nAc2 += nComPrt
		If cTitulo <> SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO+SE3->E3_VEND+SE3->E3_CODCLI+SE3->E3_LOJA  .And. Empty(cDocLiq)
			nAc3   += nVlrTitulo
			cTitulo:= SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO+SE3->E3_VEND+SE3->E3_CODCLI+SE3->E3_LOJA
			cDocLiq:= ""
		EndIf
		
		dbSelectArea("SE3")
		dbSkip()
	EndDo
	
	If mv_par12 == 1
		li++
	
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		@ li, 00  PSAY OemToAnsi(STR0013)+cDescVend  //"TOTAL DO VENDEDOR --> "
	//	@ li,aColuna[10]-1  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,aColuna[11]-1  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
	
		If nAc1 != 0
			If cPaisLoc=="BRA"
				@ li, aColuna[12] PSAY (nAc2/nAc1)*100   PicTure "999.99"
			Else
				@ li, aColuna[12] PSAY NoRound((nAc2/nAc1)*100)   PicTure "999.99"
			Endif
		Endif
	
		@ li, aColuna[13]-1  PSAY nAc2 PicTure tm(nAc2,15,nDecs)
		li++
	
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
			@ li, 00  PSAY OemToAnsi(STR0015)  //"TOTAL DO IR       --> "
			nAc4 += (nAc2 * mv_par10 / 100)				
			@ li, aColuna[13]-1  PSAY nAc4 PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi(STR0017)  //"TOTAL (-) IR      --> "
			@ li, aColuna[13]-1 PSAY nAc2 - nAc4 PicTure tm(nAc2,15,nDecs)
			li ++
		EndIf
	
		@ li, 00  PSAY __PrtThinLine()

		If mv_par11 == 1  // Quebra pagina por vendedor (padrao)
			li := 60  
		Else
		   li+= 2
		Endif
	Else
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		@ li,048  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,065  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
		If nAc1 != 0
			If cPaisLoc=="BRA"
				@ li, 081 PSAY (nAc2/nAc1)*100   PicTure "999.99"
			Else
				@ li, 081 PSAY NoRound((nAc2/nAc1)*100)   PicTure "999.99"
			Endif
		Endif
		@ li, 089  PSAY nAc2 PicTure tm(nAc2,15,nDecs)
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
			nAc4 += (nAc2 * mv_par10 / 100)
			@ li, 105  PSAY nAc4 PicTure tm(nAc2 * mv_par10 / 100,15,nDecs)
			@ li, 121 PSAY nAc2 - nAc4 PicTure tm(nAc2,15,nDecs)
		EndIf
		li ++
	EndIf
	
	dbSelectArea("SE3")
	nAg1 += nAc1
	nAg2 += nAc2
 	nAg3 += nAc3
 	nAg4 += nAc4
EndDo

If (nAg1+nAg2+nAg3+nAg4) != 0
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif

	If mv_par12 == 1
		@li,  00 PSAY OemToAnsi(STR0014)  //"TOTAL  GERAL      --> "
	//	@li, aColuna[10]-1 PSAY nAg3	Picture tm(nAg3,15,nDecs)
		@li, aColuna[11]-1 PSAY nAg1	Picture tm(nAg1,15,nDecs)
		If cPaisLoc=="BRA"
			@li, aColuna[12] PSAY (nAg2/nAg1)*100 Picture "999.99"
		Else
			@li, aColuna[12] PSAY NoRound((nAg2/nAg1)*100) Picture "999.99"
		Endif
		@li, aColuna[13]-1 PSAY nAg2 Picture tm(nAg2,15,nDecs)
		If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > GetMV("MV_VLRETIR")//IR
			li ++
			@ li, 00  PSAY OemToAnsi(STR0015)  //"TOTAL DO IR       --> "
			@ li, 175  PSAY nAg4 PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
			li ++
			@ li, 00  PSAY OemToAnsi(STR0017)  //"TOTAL (-) IR       --> "
			@ li, 175  PSAY nAg2 - nAg4 Picture tm(nAg2,15,nDecs)
		EndIf
	Else
		@li,000  PSAY __PrtThinLine()
		li ++
		@li,000 PSAY OemToAnsi(STR0014)  //"TOTAL  GERAL      --> "
//		@li,048 PSAY nAg3	Picture tm(nAg3,15,nDecs)
		@li,065 PSAY nAg1	Picture tm(nAg1,15,nDecs)
		If cPaisLoc=="BRA"
			@li,081 PSAY (nAg2/nAg1)*100 Picture "999.99"
		Else
			@li,081 PSAY NoRound((nAg2/nAg1)*100) Picture "999.99"
		Endif
		@li,089 PSAY nAg2 Picture tm(nAg2,15,nDecs)
		If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > GetMV("MV_VLRETIR")//IR
			@ li,105  PSAY nAg4 PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
			@ li,121  PSAY nAg2 - nAg4 Picture tm(nAg2,15,nDecs)
		EndIf
	EndIf
	roda(cbcont,cbtxt,"G")
EndIF
    
#IFDEF TOP
	If TcSrvType() != "AS/400"
  		dbSelectArea("SE3")
		DbCloseArea()
		chkfile("SE3")
	Else	
#ENDIF
		fErase(cNomArq+OrdBagExt())
#IFDEF TOP
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SE3")
RetIndex("SE3")
DbSetOrder(2)
dbClearFilter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Ana Paula N. Silva  º Data ³  20/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR540                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local aAreaSX1 := GetArea()

DbSelectArea("SX1")
DbSetOrder(1)

DbSeek(PadR("MTR540",Len(SX1->X1_GRUPO)) + "09")
RecLock("SX1",.F.)
Replace X1_PRESEL With 1
Replace X1_DEF01 With "Não"
Replace X1_DEFSPA1 With "No"
Replace X1_DEFENG1 With "No" 

Replace X1_DEF02 With " "
Replace X1_DEFSPA2 With " "
Replace X1_DEFENG2 With " " 

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
AADD(aHelpPor,'Indica que não será impresso')
AADD(aHelpPor,'comissões zeradas.')
AADD(aHelpSpa,'Indica que no se imprimirán') 
AADD(aHelpSpa,'comisiones en cero.')
AADD(aHelpEng,'Indicates the system will not')
AADD(aHelpEng,'print commissions zeroed.')
                                                             

PutSX1Help("P.MTR54009.",aHelpPor,aHelpEng,aHelpSpa)


SX1->(MsUnLock())
RestArea(aAreaSX1)

Return
