#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M460RAT  ³ Autor ³ Leandro Ferreira    ³ Data ³ 28/01/2021 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza o rateio de frete pelos itens do faturados         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT - R4                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteração ³ Descrição                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 28/01/2021 Leandro Ferreira           Fernando Baldo  Ajuste calculo frete
// 29/01/2021 Leandro Ferreira           Diana			 Valor do frete não estava calculando corretamente pelo total em liberação parcial

User Function M460RAT()

    Local n         :=0
    Local aCols     := PARAMIXB
    Local nQuant    := 0
    Local nVLftr    := posicione("SC5",1,xFilial("SC5")+aCols[1,1],"C5_FRETE")
    Local nVlftuni  := 0
	Local cPedatu	:= ""

    if nVLftr <= 0
       Return(ParamIxb)
    EndIF  

  	For n:=1 to Len(aCols)  
    	dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+aCols[n,1])
		While !Eof() .And. SC6->C6_FILIAL+Alltrim(SC6->C6_NUM)==xFilial("SC6")+Alltrim(aCols[n,1]) .And. cPedatu != aCols[n,1]
            nQuant := nQuant + SC6->C6_QTDVEN
			dbSelectArea("SC6")
			dbSkip()
	    Enddo
		cPedatu := aCols[n,1]
	Next n

    nVlftuni := nVLftr/nQuant

    For n:=1 to Len(aCols)  
    	dbSelectArea("SC9")
		dbSetOrder(1)
		dbSeek(xFilial("SC9")+aCols[n,1]+aCols[n,2]+aCols[n,3])
		While !Eof() .And. SC9->C9_FILIAL+Alltrim(SC9->C9_PEDIDO)+SC9->C9_ITEM+SC9->C9_SEQUEN==xFilial("SC9")+aCols[n,1]+aCols[n,2]+aCols[n,3]
            aCols[n,4] := Round(nVlftuni * SC9->C9_QTDLIB,2)
			dbSelectArea("SC9")
			dbSkip()
	    Enddo

		Next n

Return(aCols)
