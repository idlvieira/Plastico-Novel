#include 'protheus.ch'
#include 'parmtype.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±																		  ´±±
±±																		  ´±±
±±³Programa  ³ MT100GE2 ³ Autor ³ Leandro Ferreira      ³ Data ³ 13/07/20 ³±±
±±																		  ´±±
±±³Descricao ³ PE PARA PREENCHER O CAMPOS DO CONTAS A PAGAR COM			  ³±±
±±³          ³ COM BASE NO CADASTRO DO FORNECEDOR.						  ³±±
±±																		  ´±±
±±³Uso       ³ SIGACOM                                                    ³±±
±±																		  ´±±
±±																		  ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT100GE2()
	Local aTitAtual := PARAMIXB[1]
	Local nOpc := PARAMIXB[2]
	Local aHeadSE2:= PARAMIXB[3]
	Local aParcelas := ParamIXB[5]
	Local nX := ParamIXB[4]

	If nOpc == 1 //.. inclusao 2 > EXCLUSAO
		SE2->E2_ZBOL	:=	SA2->A2_ZBOL
		SE2->E2_ZCOND 	:=	SF1->F1_COND 	
	Endif

Return(Nil)