// Ponto de Entrada chamado na inclusaão da NF Entrada para recalcular o valor
// do IPI quando a nota devolvida se refereir a um cliente micro empresa. É preciso
// recalcular o IPI pois a base do mesmo é calculada pelo sistema como sendo a soma
// do total de cada item, que no caso de micro empresa é o valor do produto com 10,75%
// de desconto. Porém a base do IPI deve ser a soma do valor bruto dos itens, ou seja o valor
// sem o desconto de micro empresa, daí a necessidade de fazer o reacálculo.
// Renata Barreto - 05/11/2002
// Específico Plásticos Novel
User Function MT100AGR   


If M->cTipo = "D"
	cFornece := SF1->F1_FORNECE
	cLoja := SF1->F1_LOJA
	cNota := SF1->F1_DOC
	cSerie := SF1->F1_SERIE
	
	/*
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA)
	
	If alltrim(SA1->A1_ME) == "S"
	DbSelectArea("SD1")
	DbSetOrder(1)
	DbSeek( xFilial() + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
	nPerc:= 100-(SA1->A1_DESC)
	BaseIpiD1 := 0; ValIpiD1 := 0
	BaseIpiF1 := 0; ValipiF1 := 0
	nBIpi1:=0;nBIpi2:=0;nBIpi3:=0
	nIpi1:=0;nIpi2:=0;nIpi3:=0
	nOutr1:=0;nOutr2:=0;nOutr3:=0
	nValBrut:=0
	nVCont1:=0;nVCont2:=0;nVCont3:=0
	while TRIM(SF1->F1_DOC)==TRIM(SD1->D1_DOC) .AND. TRIM(SF1->F1_SERIE)==TRIM(SD1->D1_SERIE)
	BaseIpiD1 := If(SD1->D1_IPI>0,int((SD1->D1_TOTAL*100)/nPerc*100)/100,0)
	ValIpiD1 := ROUND(int((SD1->D1_TOTAL*100)/nPerc*100)/100,2)*(SD1->D1_IPI/100)
	nValBrut += SD1->D1_TOTAL
	If SD1->D1_CF = "131"
	nBIpi1 += BaseIpiD1
	nIpi1  += ValIpiD1
	nOutr1 +=  IF(SD1->D1_IPI=0,int((SD1->D1_TOTAL*100)/nPerc*100)/100,0)
	nVCont1+=SD1->D1_TOTAL
	ElseIf SD1->D1_CF = "132"
	nBIpi2 += BaseIpiD1
	nIpi2  += ValIpiD1
	nOutr2 +=  IF(SD1->D1_IPI=0,int((SD1->D1_TOTAL*100)/nPerc*100)/100,0)
	nVCont2+=SD1->D1_TOTAL
	Else
	nBIpi3 += BaseIpiD1
	nIpi3  += ValIpiD1
	nOutr3 +=  IF(SD1->D1_IPI=0,int((SD1->D1_TOTAL*100)/nPerc*100)/100,0)
	nVCont3+=SD1->D1_TOTAL
	Endif
	
	IF SD1->D1_IPI>0
	RecLock("SD1",.F.)
	Replace SD1->D1_VALIPI  WITH ValIpiD1
	Replace SD1->D1_BASEIPI WITH BaseIpiD1
	DbUnlock()
	ValIpiF1 += ValIpiD1
	BaseIpiF1 += BaseIpiD1
	ENDIF
	dbSkip()
	end
	DbSelectArea("SF1")   // Altera Cabecalho de Nf's de Saida
	RecLock("SF1",.F.)
	Replace F1_VALIPI  WITH ValIpiF1
	Replace F1_BASEIPI WITH BaseIpiF1
	Replace F1_VALBRUT WITH nValBrut + ValIpiF1
	DbUnlock()
	
	DbSelectArea("SF3")    // Altera Livro Fiscal
	DbSetOrder(4)
	DBGOTOP()
	DbSeek(xFilial()+cFornece+cLoja+cNota+cSerie,.T.)
	While  cFornece=SF3->F3_CLIEFOR .AND. cLoja = SF3->F3_LOJA .AND. cNota = SF3->F3_NFISCAL .AND. cSerie = SF3->F3_SERIE
	if TRIM(SF3->F3_CFO)=="1201"
	RecLock("SF3",.F.)
	Replace F3_VALCONT    With nVcont1+nIpi1
	Replace F3_VALIPI     WITH nIpi1
	Replace F3_BASEIPI    WITH nBIpi1
	Replace F3_OUTRIPI    WITH nOutr1
	DbUnlock()
	Elseif TRIM(SF3->F3_CFO)=="1202"
	RecLock("SF3",.F.)
	Replace F3_VALCONT    With nVcont2+nIpi2
	Replace F3_VALIPI     WITH nIpi2
	Replace F3_BASEIPI    WITH nBIpi2
	Replace F3_OUTRIPI    WITH nOutr2
	DbUnlock()
	Else
	RecLock("SF3",.F.)
	Replace F3_VALCONT    With nVcont3+nIpi3
	Replace F3_VALIPI     WITH nIpi3
	Replace F3_OUTRIPI    WITH nOutr3
	Replace F3_BASEIPI    WITH nBIpi3
	DbUnlock()
	endif
	DBSKIP()
	ENDDO
	
	DbSelectArea("SE1")    // Altera Contas a Receber
	DbSetOrder(2)
	DbSeek( xFilial() + cFornece + cLoja + cSerie + cNota )
	If Found()
	RecLock("SE1",.F.)
	Replace E1_VALOR  WITH nValBrut + ValIpiF1
	Replace E1_SALDO  WITH nValBrut + ValIpiF1
	Replace E1_VLCRUZ WITH nValBrut + ValIpiF1
	MsUnlock()
	Endif
	Endif
	//
	*/
	DbSelectArea("SE1")    // Altera Contas a Receber
	DbSetOrder(2)
	DbSeek( xFilial() + cFornece + cLoja + cSerie + cNota )
	If Found()
		RecLock("SE1",.F.)
		Replace E1_HIST   WITH "Nf. "+SD1->D1_NFORI
		MsUnlock()
	Endif
	
Endif
Return
