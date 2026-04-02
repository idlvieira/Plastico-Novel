#include "protheus.ch"

/*
Ponto de Entrada para contablizar IPI
*/

User Function A952CONT()

Local nValor, nValor1, nValor2 := 0
Local aCab, aItens := {}
Local aHeadCtb		:= {}
Local aColsCtb		:= {}
Local aAltCtb		:= {}

Private xoDlg
Private oDtCtb
Private oLtCtb
Private oSimCtb
Private oCtbDeb
Private oCtbCre
Private dDtCtb		:= ""
Private cLtCtb		:= ""
Private nCtbDeb		:= 0
Private nCtbCre		:= 0
Private lExist          
Private cDoc        := ""

nValor1 := U_MYCTB06(1)
nValor2 := U_MYCTB06(2)

IF nValor1 < nValor2
	nValor := nValor1
Else
	nValor := nValor2
Endif

//Verifica se existe Lancamento Contabil
lExist := VerCT2(dDatabase,nvalor,"008880")

If lExist
	IF Aviso("Atencao","Confirma a REVERSÃO da Contabilização?",{"SIM","NAO"}) = 1
		lExist := .T.
	Else
		lExist := .F.
	Endif
Endif

If lExist //Excluir
	aCab := {{'DDATALANC'  ,dDataBase             ,NIL},;
	{'CLOTE'      ,'008880'              ,NIL},;
	{'CSUBLOTE'   ,'002'                 ,NIL},;
	{'CDOC'       ,cDoc                  ,NIL},;
	{'CPADRAO'    ,''                    ,NIL},;
	{'NTOTINF'    ,0                     ,NIL},;
	{'NTOTINFLOT' ,0                     ,NIL} }
	
	aAdd(aItens,{{'CT2_FILIAL' ,cfilant                                ,NIL},;
	{'CT2_LINHA'  ,'001'                                  ,NIL},;
	{'CT2_MOEDLC' ,'01'                                   ,NIL},;
	{'CT2_DC'     ,'3'                                    ,NIL},;
	{'CT2_DEBITO' ,'11040105'                             ,NIL},;
	{'CT2_CREDIT' ,'21010701'                             ,NIL},;
	{'CT2_VALOR'  ,nValor                                 ,NIL},;
	{'CT2_ORIGEM' ,'APUR952EXC'                           ,NIL},;
	{'CT2_HP'     ,''                                     ,NIL},;
	{'CT2_HIST'   ,'EXCLUSAO TRANSFERENCIA IPI RECOLHER/RECUPERAR' ,NIL} } )
	
Else
	aCab := {{'DDATALANC'  ,dDataBase             ,NIL},;
	{'CLOTE'      ,'008880'              ,NIL},;
	{'CSUBLOTE'   ,'001'                 ,NIL},;
	{'CDOC'       ,cDoc                  ,NIL},;
	{'CPADRAO'    ,''                    ,NIL},;
	{'NTOTINF'    ,0                     ,NIL},;
	{'NTOTINFLOT' ,0                     ,NIL} }
	
	aAdd(aItens,{{'CT2_FILIAL' ,cfilant                                ,NIL},;
	{'CT2_LINHA'  ,'001'                                  ,NIL},;
	{'CT2_MOEDLC' ,'01'                                   ,NIL},;
	{'CT2_DC'     ,'3'                                    ,NIL},;
	{'CT2_DEBITO' ,'21010701'                             ,NIL},;
	{'CT2_CREDIT' ,'11040105'                             ,NIL},;
	{'CT2_VALOR'  ,nValor                                 ,NIL},;
	{'CT2_ORIGEM' ,'APUR952'                              ,NIL},;
	{'CT2_HP'     ,''                                     ,NIL},;
	{'CT2_HIST'   ,'TRANSFERENCIA IPI RECOLHER/RECUPERAR' ,NIL} } )
	
Endif
MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCab ,aItens, 3)


//Cria o painel da simulação da contabilização

dDtCtb := dDatabase
cLtCtb := "008880"

DEFINE MSDIALOG xoDlg TITLE "Contabilização IPI - SÓ VISUALIZAÇÃO" FROM C(001),C(100) TO C(575),C(845) PIXEL

@ 017,005 SAY OemToAnsi("Data")	SIZE 020,015 OF xoDlg PIXEL
@ 015,030 MSGET oDtCtb Var dDtCtb	SIZE 040,008 OF xoDlg PIXEL When .F.  Picture PesqPict("CT2","CT2_DATA",8,1)
@ 017,090 SAY OemToAnsi("Lote")	SIZE 020,015 OF xoDlg PIXEL
@ 015,115 MSGET oLtCtb Var cLtCtb	SIZE 040,008 OF xoDlg PIXEL When .F.

oDtCtb:CtrlRefresh()
oLtCtb:CtrlRefresh()

//Cria aHeader da simulação da contabilização
dbSelectArea("SX3")
dbSetOrder(1)
dbGoTop()
SX3->(dbSeek("CT2"))
While !EoF() .And. AllTrim(SX3->X3_ARQUIVO) == "CT2"
	If (!(AllTrim(SX3->X3_CAMPO) $ "CT2_MOEDLC|CT2_SBLOTE|") .And. X3USO(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL) .And. (Upper(AllTrim(SX3->X3_CONTEXT)) != "V")) .Or. (AllTrim(SX3->X3_CAMPO) $ "CT2_LINHA|")
		AADD(aHeadCtb, {TRIM(X3TITULO()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
		SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
	EndIf
	dbSkip()
EndDo

//Cria aCols da simulação da contabilização
aColsCtb := Array(1,Len(aHeadCtb)+1)
aColsCtb[1,Len(aHeadCtb)+1] := .T.

nPosDeb   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_DEBITO'})
nPosCre   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_CREDIT'})
nPosHis   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_HIST'})
nPosLot   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_LOTE'})
nPosDat   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_DATA'})
nPosDoc   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_DOC'})
nPosLin   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_LINHA'})
nPosOri   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_ORIGEM'})
nPosVlr   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_VALOR'})
nPosTdc   := aScan(aHeadCtb,{|x| AllTrim(x[2]) == 'CT2_DC'})

IF lExist //Excluir
	aColsCtb[1][nPosDeb] := "11040105"
	aColsCtb[1][nPosCre] := "21010701"
	aColsCtb[1][nPosHis] := "EXCLUSAO TRANSFERENCIA IPI RECOLHER/RECUPERAR"
	aColsCtb[1][nPosLot] := "008880"
	aColsCtb[1][nPosDat] := dDatabase
	aColsCtb[1][nPosDoc] := cDoc
	aColsCtb[1][nPosLin] := "002"
	aColsCtb[1][nPosTdc] := "3"
	aColsCtb[1][nPosOri] := "APUR952EXC"
	aColsCtb[1][nPosVlr] := nValor
Else
	aColsCtb[1][nPosDeb] := "21010701"
	aColsCtb[1][nPosCre] := "11040105"
	aColsCtb[1][nPosHis] := "TRANSFERENCIA IPI RECOLHER/RECUPERAR"
	aColsCtb[1][nPosLot] := "008880"
	aColsCtb[1][nPosDat] := dDatabase
	aColsCtb[1][nPosDoc] := cDoc
	aColsCtb[1][nPosLin] := "001"
	aColsCtb[1][nPosTdc] := "3"
	aColsCtb[1][nPosOri] := "APUR952"
	aColsCtb[1][nPosVlr] := nValor
Endif

//MsNewGetDados da simulação da contabilização
aAltCtb := {}
oSimCtb := MsNewGetDados():New(035,005,290,465,GD_UPDATE,"AllwaysTrue()","AllwaysTrue()", , aAltCtb,000,999,"AllwaysTrue()","","AllwaysTrue()",xoDlg,aHeadCtb,aColsCtb)
oSimCtb:Refresh()

nCtbDeb := nValor
nCtbCre := nValor

@ 302,005 SAY OemToAnsi("Total Débito")	SIZE 040,015 OF xoDlg PIXEL
@ 300,050 MSGET oCtbDeb Var nCtbDeb	SIZE 100,008 OF xoDlg PIXEL When .F.  Picture PesqPict("CT2","CT2_VALOR",17,1)
@ 302,200 SAY OemToAnsi("Total Crédito")	SIZE 040,015 OF xoDlg PIXEL
@ 300,250 MSGET oCtbCre Var nCtbCre	SIZE 100,008 OF xoDlg PIXEL When .F.  Picture PesqPict("CT2","CT2_VALOR",17,1)

oCtbDeb:CtrlRefresh()
oCtbCre:CtrlRefresh()

xoDlg:Refresh()

ACTIVATE MSDIALOG xoDlg CENTER ON INIT EnchoiceBar(xoDlg,{||xoDlg:End()},{||xoDlg:End()})

Return



Static Function VerCt2(vData,vValor,vLote)

Local aArea1 := Getarea()
Local lRet   := .F.

Dbselectarea("CT2")
DbOrderNickName("MYCT200000")
//Nickname = MYCT200000
//INDICE H = CT2_FILIAL+CT2_VALOR+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA
DbSeek(cfilant+STR(vValor,16,2)+DTOS(vData)+vLote)
IF !EOF()
	While !EOF()
		cChave := (CT2->CT2_FILIAL+STR(CT2->CT2_VALOR,16,2)+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE)
		IF cChave <> (cfilant+STR(vValor,16,2)+DTOS(vData)+vLote)
			IF DbSeek(cfilant+STR(vValor,16,2)+DTOS(vData)+vLote)
				IF ALLTRIM(CT2->CT2_ORIGEM) = "APUR952EXC"
					cDoc := CT2->CT2_DOC
					lRet := .F.
					Exit
				Else
					cDoc := CT2->CT2_DOC
					lRet := .T.
					Exit
				Endif
			Endif
		ENDif
		DbSkip()
	End
Else
	cDoc := "000001"
Endif

Restarea(aArea1)

Return (lRet)
