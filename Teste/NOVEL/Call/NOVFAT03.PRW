#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NOVFAT03 ºAutor  Rui Ronaldo Scandiuzzi Data ³ 02/06/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutencao em campo de observacao no pedido de venda.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NOVFAT03()

Private aRotina := {{ OemToAnsi("Pesquisar"),  "AxPesqui", 0 , 1},;
                    { OemToAnsi("Visualizar"), "AxVisual", 0 , 2},;
                    { OemToAnsi("Alterar"),  'ExecBlock("NVFT03",.F.,.F.)', 0 , 3 } }

Private cCadastro := OemtoAnsi("")

aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'ENABLE' },;		//Pedido em Aberto
			{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
			{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)",'BR_AMARELO'},;
			{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
			{ "C5_BLQ == '2'",'BR_LARANJA'}}	//Pedido Bloquedo por verba

mBrowse(6,1,22,75,"SC5",,,,,, aCores)

Return()

User Function NVFT03()

LOCAL AAREA_SC5 := SC5->(GETAREA())
LOCAL CNOME     := ""
LOCAL LTOTAL    := .T.

DBSELECTAREA("SC6")
DBSETORDER(1)
DBSEEK(SC5->C5_FILIAL+SC5->C5_NUM)
WHILE !EOF() .AND. C6_FILIAL+C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
	IF C6_QTDENT < C6_QTDVEN
		LTOTAL := .F.
		EXIT
	ENDIF
	DBSKIP()
ENDDO

IF LTOTAL
	MSGBOX("Pedido ja encerrado !","Atencao","ERROR")
ELSE
	IF SC5->C5_TIPO $ "BD"
		DBSELECTAREA("SA2")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			CNOME := SA2->A2_NOME
		ENDIF
	ELSE
		DBSELECTAREA("SA1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			CNOME := SA1->A1_NOME
		ENDIF
	ENDIF
	
	CTEXTO := SC5->C5_UHISTOR
	@ 116,001 To 416,640 Dialog oDlgMemo Title "Histórico do Pedido de Vendas"
	@ 004,010 say "Pedido: "+SC5->C5_NUM+"  "+CNOME of OdlgMemo Pixel
	@ 012,010 Get cTexto Size 300,080 MEMO of OdlgMemo Pixel
	@ 105,010 to 135,310
	@ 007,001 to 010,039
	@ 115,110 Button "Salvar" Size 35,14 Action (FRSalva(),Close(oDlgMemo)) of OdlgMemo Pixel
	@ 115,170 Button "Sair"   Size 35,14 Action Close(oDlgMemo) of OdlgMemo Pixel
	Activate Dialog oDlgMemo  
	
	RESTAREA(AAREA_SC5)
ENDIF
	
RETURN()    


STATIC FUNCTION FRSALVA()

DBSELECTAREA("SC5")
IF RECLOCK("SC5",.F.)
	SC5->C5_UHISTOR := CTEXTO
	MSUNLOCK()
ENDIF

RETURN()