#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE PAE_LEFT	0
#DEFINE PAE_RIGHT	1
#DEFINE PAE_CENTER	2

/*/{Protheus.doc} ³MYTMK15

Relatorio Faturamento Mensal 

@type function
@author	Natanael
@since 29/05/2006
@version P11,P12
@database MSSQL,Oracle

@history 17/08/2022, Júlio César Dias de Oliveira - FSW Seven Consultoria RP, Criação do parâmetro 7V_TMK15DT, para permitir flexibilidade nos tipos de despesas que deverão ser desconsiderados do valor liquido.
@history 17/08/2022, Júlio César Dias de Oliveira - FSW Seven Consultoria RP, Revisão ProtheusDoc

@see SIGAFAT.XNU
/*/
User Function MYTMK15()

	Local cPerg    := "MYTMK15"
	Local nOpc     := 4
	Local lPreview := .F.
	Local lExcel   := .F.
	
	Private _cTemp  := AllTrim( GetTempPath() ) //capturo a pasta temporaria do usuario
	Private cTitulo := "RELATORIO FATURAMENTO MENSAL"
	Private nPagina := 0
	Private oPrint  := TMSPrinter():New(cTitulo)
	//Private oExcel  := Myex001():New()
	Private oExcel  := MYTMK16():New()
	
	cPerg := PadR(cPerg,10)
	
	SX1->(dbSetOrder(1))
	If !SX1->(dbSeek(cPerg))
		ValidPerg(@cPerg)
	EndIf
	
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
	While nOpc == 4
		nOpc := Aviso("Emissão de Relatório",cTitulo,{"Disco","Imprimir","Excel","Configurar"})
		If nOpc == 4
			oPrint:Setup()
		EndIf
	EndDo
	
	If nOpc == 1
		lPreview := .T.
	ElseIf nOpc == 3
		lExcel := .T.
	ElseIf nOpc == 0
		Return
	EndIf
	
	Processa( { |lEnd| ImprimeRel(cTitulo,@lPreview,@lExcel),"Gerando o Relatório"},"Aguarde...")

Return

&&
Static Function ImprimeRel(cTitulo,lPreview,lExcel)

	Local oDlg
	Local oBmp
	Local nPag          := 0
	Local nTot          := 0
	Local cQuery        := ""
	Local nSaltoDetalhe := 0
	Local cProduto      := ""
	Local aEstrut       := {}
	Local nValTmp		:= 0
	Local nTotTmp		:= 0
	
	Local cGarNac	 :=	Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000007"+"001","ZZZ_RETORN") //GetMv("SC_GARNAC")  && Garantia Nacional
	Local cGarExp	 :=	Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000007"+"002","ZZZ_RETORN") //GetMv("SC_GAREXP")  && Garantia Exportacao
	Local cAmoNac	 :=	Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000007"+"003","ZZZ_RETORN") //GetMv("SC_AMONAC")  && Amostra Gratis Nacional
	Local cAmoExp	 :=	Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000007"+"004","ZZZ_RETORN") //GetMv("SC_AMOEXP")  && Amostra Gratis Exportacao
	Local cNaoImp	 :=	Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000007"+"005","ZZZ_RETORN") //GetMv("SC_NAOIMP")
	//Local cNaoImp2	 :=	GetMv("SC_NAOIMP2")
	//Local cNaoImp3	 :=	GetMv("SC_NAOIMP3")	
	Local oExcelApp  :=  Nil
	Local cDocumento := ""
	Local nTotItens  := 0
	Local nVlrDesp   := 0
	Local cTiposDespesasDesconsiderados	:= GetNewPar("7V_TMK15DT","NC")
	Private nItens	  := 0
	Private cFLogo   := "lgrl01.bmp"   
	Private oFont06  := tFont():New("Arial",,06,,.f.,,,,.f.,.f.) 
	Private oFont06b := tFont():New("Arial",,06,,.T.,,,,.f.,.f.)
	Private oFont08  := tFont():New("Arial",,08,,.f.,,,,.f.,.f.)
	Private oFont08b := tFont():New("Arial",,08,,.T.,,,,.f.,.f.)
	Private oFont09  := tFont():New("Arial",,09,,.f.,,,,.f.,.f.)
	Private oFont09b := tFont():New("Arial",,09,,.T.,,,,.f.,.f.)
	Private oFont10  := tFont():New("Arial",,10,,.f.,,,,.f.,.f.)
	Private oFont10b := tFont():New("Arial",,10,,.T.,,,,.f.,.f.)
	Private oFont11  := tFont():New("Arial",,11,,.f.,,,,.f.,.f.)
	Private oFont11b := tFont():New("Arial",,11,,.T.,,,,.f.,.f.)
	Private oFont12  := tFont():New("Arial",,12,,.f.,,,,.f.,.f.)
	Private oFont12b := tFont():New("Arial",,12,,.T.,,,,.f.,.f.)
	Private oFont14  := tFont():New("Arial",,14,,.f.,,,,.f.,.f.)
	Private oFont14b := tFont():New("Arial",,14,,.T.,,,,.f.,.f.)
	Private oFont16b := tFont():New("Arial",,16,,.T.,,,,.f.,.T.)
	Private	oBrush  := TBrush():New(,4)
	Private	oPen	  := TPen():New(0,5,CLR_BLACK)
	
	Private nColIni	:= 0010
	Private nColFim	:= 3350
	Private nLinFim	:= 2350
	Private nAltura := 0000
	Private nLinha	:= 5000
	Private lPula	:= .T.
	  
	
	&& Niveis de quebra
	&& 1 = Divisao
	&& 2 = Grupo
	
	&& Contadores para cálculo da média das margens de lucro
	Private nCont1 := nCont2 := nContT := 0
	
	&& Variáveis de Totais
	Private nQtd1 := nVlTotal1 := nIPI1 := nICMS1 := nPisCof1 := nTotNF1 := nTotLiq1 := nCusto1 := nMargem1 := 0.00
	Private nQtd2 := nVlTotal2 := nIPI2 := nICMS2 := nPisCof2 := nTotNF2 := nTotLiq2 := nCusto2 := nMargem2 := 0.00
	Private nQtdT := nVlTotalT := nIPIT := nICMST := nPisCofT := nTotNFT := nTotLiqT := nCustoT := nMargemT := 0.00
	
	&& Variaveis diversas
	
	Private cArray	:= ""		&& Array para processamento
	Private nTam	:= 0		&& Tamanho do array
	Private nPos	:= 0		&& Posicao do array
	
	&& Cria arrays de cada divisao
	Private aVendas,aGn,aGe,aAgn,aAge,aDev,aCIcms
	
	/*
	aVendas		Vendas
	aGn			Garantia Nacional
	aGe			Garantia Exportaçao
	aAgn			Amostra Gratis Nacional
	aAge			Amostra Gratis Exportacao
	aDev	  		Devolucao
	aCIcms		Complemento ICMS
	*/
	
	&& Carrega Arrays
	aVendas := {}  && Vendas
	aGn		:= {}  && Garantia Nacional
	aGe		:= {}  && Garantia Exportaçao
	aAgn	:= {}  && Amostra Gratis Nacional
	aAge	:= {}  && Amostra Gratis Exportacao
	aDev	:= {}  && Devolucao
	aCIcms	:= {}  && Complemento ICMS
	
	&& Monta query
	cQuery 	:= 	"SELECT * "
	cQuery 	+= 	"FROM " + RetSqlName("SD2") + " D2 "
	cQuery  +=  "LEFT JOIN SA1010 AS SA1 ON A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND SA1.D_E_L_E_T_!='*' "
	cQuery  +=  "LEFT JOIN ZZZ010 AS ZZZ ON ZZZ_FILIAL=D2_FILIAL AND ZZZ_COD='FAT000005' AND ZZZ_DESCCO=A1_ZZSEG AND ZZZ.D_E_L_E_T_!='*' "
	cQuery  +=  "LEFT JOIN SC6010 AS SC6 ON C6_FILIAL=D2_FILIAL AND C6_CLI=D2_CLIENTE AND C6_LOJA=D2_LOJA AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV AND SC6.D_E_L_E_T_!='*' "	
	cQuery 	+= 	"WHERE   D2_FILIAL = '" + xFilial("SD2")	+ "' "
	cQuery 	+= 		"AND D2_EMISSAO >= '" + DtoS(mv_par01)	+ "' AND D2_EMISSAO <= '" + DtoS(mv_par02)	+ "' "
	cQuery 	+= 		"AND D2_CLIENTE >= '" + mv_par03		+ "' AND D2_CLIENTE <= '" + mv_par05		+ "' "
	cQuery 	+= 		"AND D2_LOJA    >= '" + mv_par04		+ "' AND D2_LOJA    <= '" + mv_par06		+ "' "
	cQuery 	+= 		"AND D2_DOC     >= '" + mv_par07		+ "' AND D2_DOC     <= '" + mv_par08		+ "' "
	cQuery 	+= 		"AND D2_GRUPO   != 'TERC' " //Ewerton - 24/09/09
	cQuery 	+= 		"AND D2.D_E_L_E_T_ = ' ' AND (SELECT F4_DUPLIC FROM SF4010 SF4 WHERE F4_FIlIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ' ' AND D2_TES = F4_CODIGO) = 'S' " //AND D2_TES<>'557' "        //Verificar
	cQuery 	+=	"ORDER BY D2_GRUPO, D2_DOC"
	cQuery 	:= ChangeQuery(cQuery)
	
	TcQuery cQuery New Alias "TSD2"
	
	aEval(SD2->(dbStruct()),{ |x| IIF( x[2] != "C" , TcSetField("TSD2",x[1],x[2],x[3],x[4]) , Nil ) } )
	
	dbSelectArea("TSD2")
	
	Count to nTot
	
	TSD2->(dbGoTop())
	
	SF4->(dbSetorder(1))
	SBM->(dbSetorder(1))
	SA1->(dbSetorder(1))
	SC5->(dbSetorder(1))
	SA3->(dbSetorder(1))  
	SB1->(dbSetorder(1))
	
	While TSD2->(!Eof())
		
		SF4->(dbSeek(xFilial("SF4")+TSD2->D2_TES))			&& Posiciona na TES
		SBM->(dbSeek(xFilial("SBM")+TSD2->D2_GRUPO))		&& Posiciona Descricao do Grupo
		SA1->(dbSeek(xFilial("SA1")+TSD2->D2_CLIENTE))		&& Posiciona Nome cliente
		SC5->(dbSeek(xFilial("SC5")+TSD2->D2_PEDIDO))		&& Posiciona no Pedido
		SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND1))   
		SB1->(dbSeek(xFilial("SB1")+TSD2->D2_COD))	  

		
		dbSelectArea("TSD2")
		
		Do Case
			Case D2_TIPO = "D" .and. SF4->F4_DUPLIC = "S"		&& Devolucao
				cArray := "aDev"
			Case D2_TIPO = "I"									&& Complemento de ICMS
				cArray := "aCIcms"
			Case Alltrim(D2_CF) $ cGarNac						&& Garantia Nacional
				cArray := "aGn"
			Case Alltrim(D2_CF) $ cGarExp						&& Garantia Exportacao
				cArray := "aGe"
			Case Alltrim(D2_CF) $ cAmoNac						&& Amostra Gratis Nacional
				cArray := "aAgn"
			Case Alltrim(D2_CF) $ cAmoExp						&& Amostra Gratis Exportacao
				cArray := "aAge"
			OtherWise											   && Vendas
				cArray := "aVendas"
		EndCase
		
		If	Alltrim(D2_CF) $ cNaoImp //.or. Alltrim(D2_CF) $ cNaoImp2 .or. Alltrim(D2_CF) $ cNaoImp3
			TSD2->(dbSkip())
			Loop
		EndIf		
		
		nValTmp	:= D2_TOTAL
		nValTmp	-= IIF( D2_TIPO == 'P' , D2_VALIPI , 0 )
		nValTmp -= D2_VALICM  
			
		//customizado - Retira o pis caso seja importacao
		If Posicione("SF4",1,xFilial("SF4")+D2_TES,"F4_CSTPIS") == "01"
			nValTmp -= D2_VALIMP5
			nValTmp -= D2_VALIMP6
		EndIf
		
		nTotTmp	:=	D2_TOTAL + IIF( D2_TIPO != 'P' , D2_VALIPI , 0 )
		 
		//customizado - Retira o pis caso seja importacao
		If (Posicione("SF4",1,xFilial("SF4")+D2_TES,"F4_CSTPIS") == "01")

			Aadd( &cArray,{ D2_DOC,;						&& 01 NUM.NOTA&DOCUMENTO
			D2_EMISSAO,;		   			&& 02 DATA EMISSAO
			(Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_NOME")),;	&& 03 NOME DO CLIENTE
			D2_COD,;						&& 04 CODIGO DO PRODUTO
			D2_UM,;							&& 05 UNIDADE DE MEDIDA
			D2_QUANT,;						&& 06 QUANTIDADE DO ITEM
			D2_PRCVEN,;						&& 07 PRECO UNITÁRIO
			D2_TOTAL,;						&& 08 VALOR TOTAL DO ITEM
			D2_VALIPI,;						&& 09 VALOR DO IPI
			D2_VALICM,;						&& 10 VALOR DO ICMS
			D2_VALIMP6+D2_VALIMP5,;			&& 11 VALOR PIS+COFINS
			nTotTmp,;           			&& 12 VALOR TOTAL DO ITEM
			nValTmp	,;						&& 13 VALOR LIQ.ITEM
			If(D2_CUSTO1==0,Posicione("SB1",1,xFilial("SB1") + D2_COD, "B1_CUSTD")*D2_QUANT, D2_CUSTO1),;	&& 14 VALOR CUSTO
			0.00,;							&& 15 MARGEM DE LUCRO
			SBM->BM_DESC,;					&& 16 DESCRICAO DO GRUPO
			D2_GRUPO,;						&& 17 GRUPO DO PRODUTO
			D2_SERIE,;						&& 18 SERIE DA NOTA
			AllTrim(SA3->A3_NREDUZ),;		&& 19 VENDEDOR
			D2_CF ,;						&& 20 CFOP  
			D2_VALFRE,;                     && 21 FRETE NF 
			SA1->A1_ZZSEG,;                 && 22 SEGMENTO   
			D2_PEDIDO,;                     && 23 PEDIDO
			(SB1->B1_DESC),;                									&& 24 DESCRICAO PRODUTO    
			(SC5->C5_TPFRETE),;													&& 25 TIPO FRETE
			(Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_COD")),;	&& 26 CODIGO DO CLIENTE    
			(Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_LOJA")),;	&& 27 LOJA DO CLIENTE
			nValTmp/D2_QUANT,;												   	&& 28 VALOR LIQ. UNITARIO ITEM SEM FRETE  
			((nValTmp+D2_VALFRE)/D2_QUANT),; 									&& 29 VALOR LIQ. UNITARIO ITEM COM FRETE
            ZZZ_RETORN,;														&& 30 DESCRICAO DO SEGMENTO   
			C6_NUMPCOM,;  													   	&& 31 NUMERO PEDIDO COMPRA DO CLIENTE
			C6_ITEMPC,; 	                 									&& 32 ITEM DO PEDIDO COMPRA DO CLIENTE  
		    (Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_ZZEMAIL"))})	&& 33 EMAIL DO CLIENTE
		Else
			Aadd( &cArray,{ D2_DOC,;						&& 01 NUM.NOTA&DOCUMENTO
			D2_EMISSAO,;		   			&& 02 DATA EMISSAO
			(Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_NOME")),;	&& 03 NOME DO CLIENTE
			D2_COD,;						&& 04 CODIGO DO PRODUTO
			D2_UM,;							&& 05 UNIDADE DE MEDIDA
			D2_QUANT,;						&& 06 QUANTIDADE DO ITEM
			D2_PRCVEN,;						&& 07 PRECO UNITÁRIO
			D2_TOTAL,;						&& 08 VALOR TOTAL DO ITEM
			D2_VALIPI,;						&& 09 VALOR DO IPI
			D2_VALICM,;						&& 10 VALOR DO ICMS
			0,;								&& 11 VALOR PIS+COFINS
			nTotTmp,;           			&& 12 VALOR TOTAL DO ITEM
			nValTmp	,;						&& 13 VALOR LIQ.ITEM
			If(D2_CUSTO1==0,Posicione("SB1",1,xFilial("SB1") + D2_COD, "B1_CUSTD")*D2_QUANT, D2_CUSTO1),;	&& 14 VALOR CUSTO
			0.00,;							&& 15 MARGEM DE LUCRO
			SBM->BM_DESC,;					&& 16 DESCRICAO DO GRUPO
			D2_GRUPO,;						&& 17 GRUPO DO PRODUTO
			D2_SERIE,;						&& 18 SERIE DA NOTA
			AllTrim(SA3->A3_NREDUZ),;		&& 19 VENDEDOR
			D2_CF ,;						&& 20 CFOP   
			D2_VALFRE,;                     && 21 FRETE NF   
			SA1->A1_ZZSEG,;               	&& 22 SEGMENTO
			D2_PEDIDO,;                     && 23 PEDIDO
			(SB1->B1_DESC),;                									&& 24 DESCRICAO PRODUTO    
			(SC5->C5_TPFRETE),;													&& 25 TIPO FRETE
			(Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_COD")),;	&& 26 CODIGO DO CLIENTE    
			(Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_LOJA")),;	&& 27 LOJA DO CLIENTE
			nValTmp/D2_QUANT,;												   	&& 28 VALOR LIQ. UNITARIO ITEM SEM FRETE  
			((nValTmp+D2_VALFRE)/D2_QUANT),; 									&& 29 VALOR LIQ. UNITARIO ITEM COM FRETE
            ZZZ_RETORN,;														&& 30 DESCRICAO DO SEGMENTO   
			C6_NUMPCOM,;  													   	&& 31 NUMERO PEDIDO COMPRA DO CLIENTE
			C6_ITEMPC,; 	                 									&& 32 ITEM DO PEDIDO COMPRA DO CLIENTE  
			(Posicione("SA1",1,xFilial("SA1")+D2_CLIENTE+D2_LOJA,"A1_ZZEMAIL"))})	&& 33 EMAIL DO CLIENTE
		EndIf	
		nTam     			:= Len(&cArray)
		nLiqItem			:=	&cArray[nTam][13]
		&cArray[nTam][15]	:=	Round( (&cArray[nTam][13] - &cArray[nTam][14]) / &cArray[nTam][13] * 100, 2)
		
		cDocumento := TSD2->D2_DOC+TSD2->D2_SERIE+TSD2->D2_CLIENTE+TSD2->D2_LOJA
		nTotItens  += 1
		
		TSD2->(dbSkip())
		
		if cDocumento != TSD2->D2_DOC+TSD2->D2_SERIE+TSD2->D2_CLIENTE+TSD2->D2_LOJA
			SF2->(dbSetOrder(1))
			SF2->(dbSeek(xFilial("SF2")+cDocumento))
			
			if SF2->F2_FRETE+SF2->F2_SEGURO+SF2->F2_DESPESA > 0 .AND. !( SF2->F2_TIPO $ cTiposDespesasDesconsiderados )
				nVlrDesp  := (SF2->F2_FRETE+SF2->F2_SEGURO+SF2->F2_DESPESA) / nTotItens
				nTam      := nTam - (nTotItens-1)

				while nTam <= Len(&cArray)
					&cArray[nTam][13] += nVlrDesp
					nTam++
				enddo
			endif   
			nTotItens := 0
		endif
	EndDo
	
	oPrint:SetLandscape()  
	oPrint:SetpaperSize(9)
	
	If lExcel
		oExcel:ImpCabec()
	Else
		fImpCabec(cTitulo,@nPagina,.T.,.F.,.T.)  &&Titulo , Num. da Página, Pula Pagina, Imprime Detalhes
	EndIf
	
	&& Imprime Divisão Vendas
	cArray := "aVendas"
	cXtitu := "Divisão Vendas"
	If Len(&cArray) > 0
		IIF(!lExcel,fImpTit(cXtitu),oExcel:ImpTit(cXtitu))
		cGrupo :=&cArray[1,17]
		For nPos := 1 to Len(&cArray)
			If	cGrupo != &cArray[nPos][17] .and. mv_par13 == 1
				IIF(!lExcel,fImpT1(),oExcel:ImpT1())
				cGrupo := &cArray[nPos][17]
			Else
				cGrupo := &cArray[nPos][17]
			EndIf
			IIF(!lExcel,fImpDet(),oExcel:ImpDet(nPos))
			fAcumT1()	&& Acumula grupo
			fAcumT2()	&& Acumula total
			fAcumTG()	&& Acumula total geral
		Next nPos
		If	mv_par13 == 1
			IIF(!lExcel,fImpT1(),oExcel:ImpT1())
		EndIf
		IIF(!lExcel,fImpT2(),oExcel:ImpT2())
	EndIf
	
	&& Imprime Garantia Nacional
	cArray := "aGn"
	cXtitu := "Garantia Nacional"
	If Len(&cArray) > 0 .and. mv_par09 == 1
		IIF(!lExcel,fImpTit(cXtitu),oExcel:ImpTit(cXtitu))
		cGrupo :=&cArray[1,17]
		For nPos = 1 to Len(&cArray)
			If	cGrupo != &cArray[nPos][17] .and. mv_par13 == 1
				IIF(!lExcel,fImpT1(),oExcel:ImpT1())
				cGrupo := &cArray[nPos][17]
			Else
				cGrupo := &cArray[nPos][17]
			EndIf
			IIF(!lExcel,fImpDet(),oExcel:ImpDet())
			fAcumT1()	&& Acumula grupo
			fAcumT2()	&& Acumula total
			fAcumTG()	&& Acumula total geral
		Next nPos
		If	mv_par13 == 1
			IIF(!lExcel,fImpT1(),oExcel:ImpT1())
		EndIf
		IIF(!lExcel,fImpT2(),oExcel:ImpT2())
	EndIf
	
	&& Imprime Garantia Exportaccao
	cArray := "aGe"
	cXtitu := "Garantia Exportacao"
	If Len(&cArray) > 0  .and. mv_par10 == 1
		IIF(!lExcel,fImpTit(cXtitu),oExcel:ImpTit(cXtitu))
		cGrupo :=&cArray[1,17]
		For nPos = 1 to Len(&cArray)
			If	cGrupo != &cArray[nPos][17] .and. mv_par13 == 1
				IIF(!lExcel,fImpT1(),oExcel:ImpT1())
				cGrupo := &cArray[nPos][17]
			Else
				cGrupo := &cArray[nPos][17]
			EndIf
			IIF(!lExcel,fImpDet(),oExcel:ImpDet())
			fAcumT1()	&& Acumula grupo
			fAcumT2()	&& Acumula total
			fAcumTG()	&& Acumula total geral
		Next nPos
		If	mv_par13 == 1
			IIF(!lExcel,fImpT1(),oExcel:ImpT1())
		EndIf
		IIF(!lExcel,fImpT2(),oExcel:ImpT2())
	EndIf
	
	&& Imprime Amostra Gratis Nacional
	cArray := "aAgn"
	cXtitu := "Amostra Grátis Nacional"
	If Len(&cArray) > 0 .and. mv_par11 == 1
		IIF(!lExcel,fImpTit(cXtitu),oExcel:ImpTit(cXtitu))
		cGrupo :=&cArray[1,17]
		For nPos = 1 to Len(&cArray)
			If	cGrupo != &cArray[nPos][17] .and. mv_par13 == 1
				IIF(!lExcel,fImpT1(),oExcel:ImpT1())
				cGrupo := &cArray[nPos][17]
			Else
				cGrupo := &cArray[nPos][17]
			EndIf
			IIF(!lExcel,fImpDet(),oExcel:ImpDet())
			fAcumT1()	&& Acumula grupo
			fAcumT2()	&& Acumula total
			fAcumTG()	&& Acumula total geral
		Next nPos
		If	mv_par13 == 1
			IIF(!lExcel,fImpT1(),oExcel:ImpT1())
		EndIf
		IIF(!lExcel,fImpT2(),oExcel:ImpT2())
	EndIf
	
	&& Imprime Amostra Gratis Exportacao
	cArray := "aAge"
	cXtitu := "Amostra Grátis Exportacao"
	If Len(&cArray) > 0 .and. mv_par12 == 1
		IIF(!lExcel,fImpTit(cXtitu),oExcel:ImpTit(cXtitu))
		cGrupo :=&cArray[1,17]
		For nPos = 1 to Len(&cArray)
			If	cGrupo != &cArray[nPos][17] .and. mv_par13 == 1
				IIF(!lExcel,fImpT1(),oExcel:ImpT1())
				cGrupo := &cArray[nPos][17]
			Else
				cGrupo := &cArray[nPos][17]
			EndIf
			IIF(!lExcel,fImpDet(),oExcel:ImpDet())
			fAcumT1()	&& Acumula grupo
			fAcumT2()	&& Acumula total
			fAcumTG()	&& Acumula total geral
		Next nPos
		If	mv_par13 == 1
			IIF(!lExcel,fImpT1(),oExcel:ImpT1())
		EndIf
		IIF(!lExcel,fImpT2(),oExcel:ImpT2())
	EndIf
	
	grvDev(@aDev)
	&& Imprime Devolucao
	cArray := "aDev"
	cXtitu := "Devolução"
	If Len(&cArray) > 0
		IIF(!lExcel,fImpTit(cXtitu),oExcel:ImpTit(cXtitu))
		cGrupo :=&cArray[1,17]
		For nPos = 1 to Len(&cArray)
			If	cGrupo != &cArray[nPos][17] .and. mv_par13 == 1
				IIF(!lExcel,fImpT1(),oExcel:ImpT1())
				cGrupo := &cArray[nPos][17]
			Else
				cGrupo := &cArray[nPos][17]
			EndIf
			IIF(!lExcel,fImpDet(),oExcel:ImpDet())
			fAcumT1()	&& Acumula grupo
			fAcumT2()	&& Acumula total
			fAcumTG()	&& Acumula total geral
		Next nPos
		If	mv_par13 == 1
			IIF(!lExcel,fImpT1(),oExcel:ImpT1())
		EndIf
		IIF(!lExcel,fImpT2(),oExcel:ImpT2())
	EndIf
	
	&& Imprime Complemento de ICMS
	cArray := "aCicms"
	cXtitu := "Complemento de ICMS"
	If Len(&cArray) > 0
		IIF(!lExcel,fImpTit(cXtitu),oExcel:ImpTit(cXtitu))
		cGrupo :=&cArray[1,17]
		For nPos = 1 to Len(&cArray)
			If	cGrupo != &cArray[nPos][17] .and. mv_par13 == 1
				IIF(!lExcel,fImpT1(),oExcel:ImpT1())
				cGrupo := &cArray[nPos][17]
			Else
				cGrupo := &cArray[nPos][17]
			EndIf
			IIF(!lExcel,fImpDet(),oExcel:ImpDet())
			fAcumT1()	&& Acumula grupo
			fAcumT2()	&& Acumula total
			fAcumTG()	&& Acumula total geral
		Next nPos
		If	mv_par13 == 1
			IIF(!lExcel,fImpT1(),oExcel:ImpT1())
		EndIf
		IIF(!lExcel,fImpT2(),oExcel:ImpT2())
	EndIf
	
	IIF(!lExcel,fImpTG(),oExcel:ImpTG())
	
	TSD2->(dbCloseArea())
	
	If lExcel
		oExcelApp := MsExcel():New()
		MemoWrit("Myers001.xls",oExcel:cArq)  //novel
	
		__copyfile( "Myers001.xls", _cTemp + "Myers001.xls")
		
		&&Copy File &("Myers001.xls") to &("c:\Myers001.xls")
		&&Copy File &("\Myers001.xls") to &("c:\Myers002.xls")
		&&Copy File &("\system\Myers001.xls") to &("c:\Myers003.xls")
		
		oExcelApp:WorkBooks:Open( _cTemp + "Myers001.xls")
		
		&&oExcelApp:WorkBooks:Open("\\server2\P10_OFICIAL\Protheus_Data\system\myers001.xls")
		&&oExcelApp:WorkBooks:Open("c:\Myers001.xls")
		
		oExcelApp:SetVisible(.T.)
	
	Else
		If lPreview
			oPrint:Preview()
		Else
			oPrint:Print()
		EndIf
	EndIf

Return

&& Acumula totais do grupo
Static Function fAcumT1()

	nQtd1		+= &cArray[nPos][06]		&& Quantidade
	nVlTotal1	+= &cArray[nPos][08]		&& Valor total do item
	nIPI1		+= &cArray[nPos][09]		&& IPI
	nICMS1		+= &cArray[nPos][10]		&& ICMS
	nPisCof1	+= &cArray[nPos][11]		&& PIS + COFINS
	nTotNF1		+= &cArray[nPos][12]		&& Total do item
	nTotLiq1	+= &cArray[nPos][13]		&& Liquido item
	nCusto1		+= &cArray[nPos][14]		&& Custo item
	nMargem1	+= &cArray[nPos][15]		&& Margem de lucro
	
	nCont2++

Return

&& Acumula totais do grupo
Static Function fAcumT2()

	nQtd2		+= &cArray[nPos][06]		&& Quantidade
	nVlTotal2	+= &cArray[nPos][08]		&& Valor total do item
	nIPI2		+= &cArray[nPos][09]		&& IPI
	nICMS2		+= &cArray[nPos][10]		&& ICMS
	nPisCof2	+= &cArray[nPos][11]		&& PIS + COFINS
	nTotNF2		+= &cArray[nPos][12]		&& Total do item
	nTotLiq2	+= &cArray[nPos][13]		&& Liquido item
	nCusto2		+= &cArray[nPos][14]		&& Custo item
	nMargem2	+= &cArray[nPos][15]		&& Margem de lucro
	
	nCont2++

Return

&& Acumula totais do grupo
Static Function fAcumTG()

	if cArray == "aDev"
		nQtdT		-= &cArray[nPos][06]		&& Quantidade
		nVlTotalT	-= &cArray[nPos][08]		&& Valor total do item
		nIPIT		-= &cArray[nPos][09]		&& IPI
		nICMST		-= &cArray[nPos][10]		&& ICMS
		nPisCofT	-= &cArray[nPos][11]		&& PIS + COFINS
		nTotNFT		-= &cArray[nPos][12]		&& Total do item
		nTotLiqT	-= &cArray[nPos][13]		&& Liquido item
		nCustoT		-= &cArray[nPos][14]		&& Custo item
		nMargemT	-= &cArray[nPos][15]		&& Margem de lucro
	else
		nQtdT		+= &cArray[nPos][06]		&& Quantidade
		nVlTotalT	+= &cArray[nPos][08]		&& Valor total do item
		nIPIT		+= &cArray[nPos][09]		&& IPI
		nICMST		+= &cArray[nPos][10]		&& ICMS
		nPisCofT	+= &cArray[nPos][11]		&& PIS + COFINS
		nTotNFT		+= &cArray[nPos][12]		&& Total do item
		nTotLiqT	+= &cArray[nPos][13]		&& Liquido item
		nCustoT		+= &cArray[nPos][14]		&& Custo item
		nMargemT	+= &cArray[nPos][15]		&& Margem de lucro
	endif
	
	nCont2++

Return

&& VerIficar as quebras
User Function fQuebra()

	nProx := nPos+1
	If nProx > Len(&cArray)
		fImpT2()
	ElseIf cGrupo # &cArray[nProx][17]
		&& Imprime, acumula e zera totais do grupo
		fImpT2()
	EndIf

Return .T.

&&
Static Function fImpT1()

	If nLinha > 2300
		fImpCabec(cTitulo,@nPagina,.T.,.T.,.f.)
	EndIf
	
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	nLinha +=035
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	&& Acumula totais da divisao do relatorio
	nLinha +=004
	oPrint:Say(nLinha ,0020  	,"Sub-Total"                         		,oFont06b,,CLR_BLACK,,PAE_LEFT)
	&&oPrint:Say(nLinha ,1250 	,Transform(nQtd1,"@E 999,999.99")	   		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1600 	,Transform(nVltotal1,"@E 999,999,999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1800 	,Transform(nIPI1,"@E 9,999,999.99")			,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2000 	,Transform(nICMS1,"@E 9,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2200 	,Transform(nPisCof1,"@E 9,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2450 	,Transform(nTotNF1,"@E 999,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2700 	,Transform(nTotLiq1,"@E 999,999,999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2900 	,Transform(00,"@E 999,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,3100 	,Transform(00,"@E 9999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	
	nLinha +=031
	oPrint:Box(nLinha,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	nLinha +=035
	
	&& Zera acumuladores do grupo
	nQtd1:=nVlTotal1:=nIPI1:=nICMS1:=nPisCof1:=nTotNF1:=nTotLiq1:=nCusto1:=nMargem1:=nCont1:=0.00

Return .T.

&&
Static Function fImpT2()

	If nLinha > 2300
		fImpCabec(cTitulo,@nPagina,.T.,.T.,.f.)
	EndIf
	
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	nLinha +=035
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	
	&& Acumula totais da divisao do relatorio
	nLinha +=004
	oPrint:Say(nLinha ,0020   	,"Total"	                         		,oFont06b,,CLR_BLACK,,PAE_LEFT)
	oPrint:Say(nLinha ,1400 	,Transform(nVltotal2,"@E 999,999,999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1550 	,Transform(nIPI2,"@E 9,999,999.99")			,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1700 	,Transform(nICMS2,"@E 9,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1850 	,Transform(nPisCof2,"@E 9,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2050 	,Transform(nTotNF2,"@E 999,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2250 	,Transform(nTotLiq2,"@E 999,999,999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2400 	,Transform(00,"@E 999,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2520 	,Transform(00,"@E 9999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	
	nLinha +=031
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	nLinha +=035
	
	&& Zera acumuladores do grupo
	nQtd2:=nVlTotal2:=nIPI2:=nICMS2:=nPisCof2:=nTotNF2:=nTotLiq2:=nCusto2:=nMargem2:=nCont2:=0.00

Return .T.

&&
Static Function fImpTG()

	If nLinha > 2300
		fImpCabec(cTitulo,@nPagina,.T.,.T.,.f.)
	EndIf
	
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	nLinha +=035
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	
	&& Acumula totais da divisao do relatorio
	nLinha +=004
	oPrint:Say(nLinha ,0020    	,"Total Geral"                       		,oFont06b,,CLR_BLACK,,PAE_LEFT)
	&&oPrint:Say(nLinha ,1250 	,Transform(nQtdT,"@E 999,999.99")			,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1400 	,Transform(nVltotalT,"@E 999,999,999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1550 	,Transform(nIPIT,"@E 9,999,999.99")			,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1700 	,Transform(nICMST,"@E 9,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1850 	,Transform(nPisCofT,"@E 9,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2050 	,Transform(nTotNFT,"@E 999,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2250 	,Transform(nTotLiqT,"@E 999,999,999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2450 	,Transform(00,"@E 999,999,999.99")		,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2520 	,Transform(00,"@E 9999.99")	,oFont06b,,CLR_BLACK,,PAE_RIGHT)
	
	nLinha +=031
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	nLinha +=04
	
Return .T.

&& Imprime o Cabecalho
Static Function fImpCabec(cTitulo,nPagina,lPula,lImpd,lPriVez)

	If lPula
		If	!lPriVez
			oPrint:EndPage()
		EndIf
		oPrint:StartPage()
		nLinha := 0010
		nPagina++
		oPrint:Box(nLinha,nColIni,nLinha + 110,nColFim)		&& Tamanho total do quadro em Landscape
		oPrint:Say(nLinha + 12, nColFim/2 	,"FATURAMENTO MENSAL MYERS",oFont14b,,CLR_BLUE,,PAE_CENTER)
		oPrint:Say(nLinha + 72, nColFim/2 	,"Período de Emissão das Notas Fiscais - De: "+Dtoc(mv_par01)+" - Até "+Dtoc(mv_par02),oFont10b,,CLR_BLUE,,PAE_CENTER)
		OPrint:Say(nLinha + 72, nColFim-30  ,"Página: "+Strzero(nPagina,3),oFont10b,,CLR_BLUE,,PAE_RIGHT)
		nLinha += 120
	EndIf
	
	If lImpD
		oPrint:Box(nLinha,nColIni,nLinha + 60,nColFim)		&& Tamanho total do quadro em Landscape
		Imprev(nLinha,nLinha + 60)
		nLinha +=025
		oPrint:Say(nLinha ,0025 ,"N.F. / Serie" 	,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[01] E [18]
		oPrint:Say(nLinha ,0190 ,"Data"       	 	,oFont06b,,CLR_BLACK,,PAE_CENTER)	//[02] 
		oPrint:Say(nLinha ,0260 ,"Cliente"			,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[03]
		oPrint:Say(nLinha ,0650 ,"P/N"				,oFont06b,,CLR_BLACK,,PAE_CENTER)	//[04]
		oPrint:Say(nLinha ,0780 ,"Descricao"	    ,oFont06b,,CLR_BLACK,,PAE_CENTER)	//[24]
		oPrint:Say(nLinha ,1100 ,"Qtd."				,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[06]
		oPrint:Say(nLinha ,1250 ,"Vl.Unit."			,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[07]
		oPrint:Say(nLinha ,1400 ,"Vl.Total"			,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[08]
		oPrint:Say(nLinha ,1550 ,"IPI"				,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[09]
		oPrint:Say(nLinha ,1700 ,"ICMS"				,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[10]
		oPrint:Say(nLinha ,1850 ,"PIS/Cofins"		,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[11]
		oPrint:Say(nLinha ,2050 ,"Total NF"			,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[12]
		oPrint:Say(nLinha ,2250 ,"Total Liquido R$"	,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[13]
		oPrint:Say(nLinha ,2400 ,"Custo"			,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[14]
		oPrint:Say(nLinha ,2520 ,"% Margem"			,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[15]
		oPrint:Say(nLinha ,2580 ,"Grupo"			,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[16] 
		oPrint:Say(nLinha ,2750 ,"Vendedor"			,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[19]
		oPrint:Say(nLinha ,2900 ,"CFOP"		    	,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[20]
		oPrint:Say(nLinha ,3100 ,"Frete"        	,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[21]
		oPrint:Say(nLinha ,3130 ,"Segmento"			,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[22]
		oPrint:Say(nLinha ,3250 ,"Pedido"			,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[23]
		oPrint:Say(nLinha ,3250 ,"TP Frete"			,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[25]
		oPrint:Say(nLinha ,0240 ,"Cod.Cliente"		,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[26] 
		oPrint:Say(nLinha ,0250 ,"Loja	"			,oFont06b,,CLR_BLACK,,PAE_LEFT)		//[27] 
		oPrint:Say(nLinha ,3250 ,"Vl.Unit. Item	"	,oFont06b,,CLR_BLACK,,PAE_RIGHT)	//[28]
	   		
		nLinha +=050
	EndIf

Return .T.

&&
Static Function fImpDet()

	If nLinha > 2300
		fImpCabec(cTitulo,@nPagina,.T.,.T.)
	EndIf
	oPrint:Box(nLinha-2,nColIni,nLinha + 35,nColFim)		&& Tamanho total do quadro em Landscape
	Imprev(nLinha-2,nLinha + 35)
	nLinha +=004
	oPrint:Say(nLinha ,0025 ,&cArray[nPos][01]+"/"+&cArray[nPos][18]			,oFont06,,CLR_BLACK,,PAE_LEFT)
	oPrint:Say(nLinha ,0190 ,DtoC(&cArray[nPos][02])      						,oFont06,,CLR_BLACK,,PAE_CENTER)
	oPrint:Say(nLinha ,0240 ,&cArray[nPos][03]									,oFont06,,CLR_BLACK,,PAE_LEFT)
	oPrint:Say(nLinha ,0650 ,&cArray[nPos][04]									,oFont06,,CLR_BLACK,,PAE_CENTER)
	oPrint:Say(nLinha ,0740 ,Substr(&cArray[nPos][24],01,20)					,oFont06,,CLR_BLACK,,PAE_LEFT) 
	oPrint:Say(nLinha ,1100 ,Transform(&cArray[nPos][06],"@E 9,999,999.99")		,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1250 ,Transform(&cArray[nPos][07],"@E 9,999,999.99")		,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1400 ,Transform(&cArray[nPos][08],"@E 999,999,999.99")	,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1550 ,Transform(&cArray[nPos][09],"@E 9,999,999.99") 	,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1700 ,Transform(&cArray[nPos][10],"@E 9,999,999.99") 	,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,1850 ,Transform(&cArray[nPos][11],"@E 9,999,999.99")	    ,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2050 ,Transform(&cArray[nPos][12],"@E 999,999,999.99")	,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2250 ,Transform(&cArray[nPos][13],"@E 999,999,999.99")	,oFont06,,CLR_BLACK,,PAE_RIGHT)
&&	oPrint:Say(nLinha ,2400 ,Transform(&cArray[nPos][14],"@E 999,999,999.99")	,oFont06,,CLR_BLACK,,PAE_RIGHT)
&&	oPrint:Say(nLinha ,2520 ,Transform(&cArray[nPos][15],"@E 9999.99")			,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2400 ,Transform(00,"@E 999,999,999.99")	,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2520 ,Transform(00,"@E 9999.99")			,oFont06,,CLR_BLACK,,PAE_RIGHT)
	oPrint:Say(nLinha ,2580 ,Substr(&cArray[nPos][16],01,12)					,oFont06,,CLR_BLACK,,PAE_LEFT)   
	oPrint:Say(nLinha ,2750 ,Substr(&cArray[nPos][19],01,12)					,oFont06,,CLR_BLACK,,PAE_LEFT) 
	oPrint:Say(nLinha ,2900 ,Substr(&cArray[nPos][20],01,12)					,oFont06,,CLR_BLACK,,PAE_LEFT) 
	oPrint:Say(nLinha ,3100 ,Transform(&cArray[nPos][21],"@E 999,9999.99")		,oFont06,,CLR_BLACK,,PAE_RIGHT) 
	oPrint:Say(nLinha ,3130 ,Substr(&cArray[nPos][22],01,12)					,oFont06,,CLR_BLACK,,PAE_LEFT)
	oPrint:Say(nLinha ,3250 ,Substr(&cArray[nPos][23],01,12)					,oFont06,,CLR_BLACK,,PAE_LEFT) 
	oPrint:Say(nLinha ,3250 ,Substr(&cArray[nPos][25],01,12)					,oFont06,,CLR_BLACK,,PAE_LEFT)  
	oPrint:Say(nLinha ,3250 ,Substr(&cArray[nPos][26],01,12)					,oFont06,,CLR_BLACK,,PAE_LEFT)
	oPrint:Say(nLinha ,3250 ,Substr(&cArray[nPos][27],01,12)					,oFont06,,CLR_BLACK,,PAE_LEFT)
	oPrint:Say(nLinha ,2250 ,Transform(&cArray[nPos][28],"@E 999,999,999.99")	,oFont06,,CLR_BLACK,,PAE_RIGHT)
		
	nLinha +=031

Return .T.

&&
Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	&& Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Data emissao NF de"  ,"" ,"" ,"mv_ch1", "D", 08, 0, 0, "G", "", "mv_par01","   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "02", "Data emissao NF ate" ,"" ,"" ,"mv_ch2", "D", 08, 0, 0, "G", "", "mv_par02","   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "03", "Cliente de"          ,"" ,"" ,"mv_ch3", "C", 06, 0, 0, "G", "", "mv_par03","   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "04", "Loja de"             ,"" ,"" ,"mv_ch4", "C", 02, 0, 0, "G", "", "mv_par04","   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "05", "Cliente ate"         ,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05","   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "06", "Loja ate"            ,"" ,"" ,"mv_ch6", "C", 02, 0, 0, "G", "", "mv_par06","   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "07", "NF de"               ,"" ,"" ,"mv_ch7", "C", 09, 0, 0, "G", "", "mv_par07","   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "08", "NF ate"              ,"" ,"" ,"mv_ch8", "C", 09, 0, 0, "G", "", "mv_par08","   ", "", "", "", "", "   ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "09", "Imp Garantia Nac ?"  ,"" ,"" ,"mv_ch9", "N", 01, 0, 0, "C", "", "mv_par09","Sim", "", "", "", "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "10", "Imp Garantia Exp ?"  ,"" ,"" ,"mv_cha", "N", 01, 0, 0, "C", "", "mv_par10","Sim", "", "", "", "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "11", "Imp Amo Grat Nac ?"  ,"" ,"" ,"mv_chb", "N", 01, 0, 0, "C", "", "mv_par11","Sim", "", "", "", "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "12", "Imp Amo Grat Exp ?"  ,"" ,"" ,"mv_chc", "N", 01, 0, 0, "C", "", "mv_par12","Sim", "", "", "", "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "13", "Totaliza por Grupo"  ,"" ,"" ,"mv_chd", "N", 01, 0, 0, "C", "", "mv_par13","Sim", "", "", "", "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
		EndIf
	Next
	
	dbSelectArea(_sAlias)

Return .T.

&&
Static Function Imprev(nDalin,nAteLin)

	oPrint:Line(nDaLin,0140,nAtelin,0140)
	oPrint:Line(nDaLin,0235,nAtelin,0235)
	oPrint:Line(nDaLin,0580,nAtelin,0580)
	oPrint:Line(nDaLin,0730,nAtelin,0730)  
	oPrint:Line(nDaLin,1000,nAtelin,1000)
	
Return

&&
Static Function fImpTit(cXtitu)

	nLinha +=50
	oPrint:Say(nLinha + 15, nColFim/2 ,cXtitu ,oFont12b,,CLR_RED,,PAE_CENTER)
	nLinha +=070
	fImpCabec(cTitulo,@nPagina,.F.,.T.)

Return

static function grvDev(aDev)

	local cQuery := ""
	local cCfop  := Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000007"+"006","ZZZ_RETORN") //getMv("MV_ZZCFREL")

	cQuery := "SELECT * "
	cQuery += "FROM " + RetSQLName("SD1") + " SD1 " 
	cQuery += "WHERE D1_FILIAL	=  '" + xFilial("SD1")	+ "' "
	cQuery += "AND D1_DTDIGIT	>= '" + DtoS(mv_par01)	+ "' AND D1_DTDIGIT <= '" + DtoS(mv_par02)	+ "' "
	cQuery += "AND D1_FORNECE	>= '" + mv_par03		+ "' AND D1_FORNECE <= '" + mv_par05		+ "' " 
	cQuery += "AND D1_LOJA		>= '" + mv_par04		+ "' AND D1_LOJA    <= '" + mv_par06		+ "' " 
	cQuery += "AND D1_DOC		>= '" + mv_par07		+ "' AND D1_DOC     <= '" + mv_par08		+ "' " 
	cQuery += "AND D1_CF IN (" + cCfop + ")  " 
	cQuery += "AND SD1.D_E_L_E_T_ = ' ' " 
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"QRYSD1", .F., .F.)
	
	aEval(SD1->(dbStruct()),{ |x| IIF( x[2] != "C" , TcSetField("QRYSD1",x[1],x[2],x[3],x[4]) , Nil ) } )
		
	While QRYSD1->(!eof())	
	
		Posicione("SB1",1,xFilial("SB1") + QRYSD1->D1_COD  ,"B1_GRUPO")
		Posicione("SBM",1,xFilial("SBM") + QRYSD1->D1_GRUPO,"BM_DESC")

		Aadd( aDev,{ QRYSD1->D1_DOC,;			&& 01 NUM.NOTA&DOCUMENTO
		QRYSD1->D1_DTDIGIT,;		   			&& 02 DATA EMISSAO
		(Posicione("SA1", 1, xFilial("SA1") + QRYSD1->D1_FORNECE + QRYSD1->D1_LOJA, "A1_NOME")),;	&& 03 NOME DO CLIENTE
		QRYSD1->D1_COD,;						&& 04 CODIGO DO PRODUTO
		QRYSD1->D1_UM,;							&& 05 UNIDADE DE MEDIDA
		QRYSD1->D1_QUANT,;						&& 06 QUANTIDADE DO ITEM
		QRYSD1->D1_VUNIT,;						&& 07 PRECO UNITÁRIO
		QRYSD1->D1_TOTAL,;						&& 08 VALOR TOTAL DO ITEM
		QRYSD1->D1_VALIPI,;						&& 09 VALOR DO IPI
		QRYSD1->D1_VALICM,;						&& 10 VALOR DO ICMS
		QRYSD1->D1_VALIMP5+QRYSD1->D1_VALIMP6,;	&& 11 VALOR PIS+COFINS
		QRYSD1->D1_TOTAL+QRYSD1->D1_VALIPI,;           			&& 12 VALOR TOTAL DO ITEM
		QRYSD1->D1_TOTAL-QRYSD1->D1_VALICM-QRYSD1->D1_VALIMP5-QRYSD1->D1_VALIMP6,;	&& 13 VALOR LIQ.ITEM
		0,;                         	&& 14 VALOR CUSTO
		0.00,;							&& 15 MARGEM DE LUCRO
		SBM->BM_DESC,;					&& 16 DESCRICAO DO GRUPO
		SB1->B1_GRUPO,;					&& 17 GRUPO DO PRODUTO
		QRYSD1->D1_SERIE,;				&& 18 SERIE DA NOTA   
		"",;                            && 19 VENDEDOR
		D1_CF ,;						&& 20 CFOP     
		D1_VALFRE ,;					&& 21 FRETE	    
		SA1->A1_ZZSEG,;                	&& 22 SEGMENTO	 
		QRYSD1->D1_NFORI,;				&& 23 NF ORIGINAL  
		SB1->B1_DESC,;	                											&& 24 DESCRICAO DO PRODUTO   
		0,;                 														&& 25 TP FRETE     
		(Posicione("SA1", 1, xFilial("SA1") + QRYSD1->D1_FORNECE + QRYSD1->D1_LOJA, "A1_COD")),;			&& 26 CODIGO DO CLIENTE    
		(Posicione("SA1", 1, xFilial("SA1") + QRYSD1->D1_FORNECE + QRYSD1->D1_LOJA, "A1_LOJA")),;			&& 27 LOJA DO CLIENTE 
		(QRYSD1->D1_TOTAL - QRYSD1->D1_VALICM - QRYSD1->D1_VALIMP5 - QRYSD1->D1_VALIMP6) / (QRYSD1->D1_QUANT),;	&& 28 VALOR LIQ. UNITARIO SEM FRETE
		((QRYSD1->D1_TOTAL + QRYSD1->D1_VALFRE) - QRYSD1->D1_VALICM - QRYSD1->D1_VALIMP5 - QRYSD1->D1_VALIMP6) / (QRYSD1->D1_QUANT),;	&& 29 VALOR LIQ. UNITARIO COM FRETE
        "",;														&& 30 DESCRICAO DO SEGMENTO   
		"",;  													   	&& 31 NUMERO PEDIDO COMPRA DO CLIENTE
		"",; 	                 									&& 32 ITEM DO PEDIDO COMPRA DO CLIENTE  
	    (Posicione("SA1", 1, xFilial("SA1") + QRYSD1->D1_FORNECE + QRYSD1->D1_LOJA, "A1_ZZEMAIL"))})	&& 33 EMAIL DO CLIENTE	
			QRYSD1->(dbSkip())
	Enddo
	
	QRYSD1->(dbCloseArea())

return
