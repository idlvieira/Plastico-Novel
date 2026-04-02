
#include "PROTHEUS.CH"

user function M410VRES()
	local lRet 		:= .T. as logical
	local cPiperun 	:= SC5->C5_PIPERUN
	local cMotivo	:= ""
	local cJustic	:= ""

	if !empty(cPipeRun)
		cMotivo := u_MotPerda(cPiperun)
		cJustic	:= u_Justif()
		if !empty(cMotivo) .and. !empty(cJustic)
			PipeRun.Deals.U_DealsLoss(cPipeRun, left(cMotivo,6), cJustic)
		else 
			FwAlertInfo("E necessario informar o Motivo do cancelamento e a Justificativa", "Atenção")
		endif
	endif

Return lRet

user function MotPerda(cPiperun)
	local aMot 		 := {} 									as Array
	local cName		 := "Selecione o Motivo da Perda"		as character
	local oButton1											as object
	local oComboBo1											as object
	local nSelect 	:= 1									as numeric
	local oSay1												as object
	Static oDlg												as object

	aMot 	:= PipeRun.Deals.U_lostReason()

	DEFINE MSDIALOG oDlg TITLE "PipeRun - "+cPipeRun FROM 000, 000  TO 150, 620 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME

	@ 012, 015 SAY oSay1 PROMPT cName SIZE 165, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 024, 015 MSCOMBOBOX oComboBo1 VAR aMot[nSelect] ITEMS aMot SIZE 340, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040, 070 BUTTON oButton1 PROMPT "Salvar" SIZE 035, 015  ACTION {|| oDlg:End()  } OF oDlg PIXEL
	@ 040, 140 BUTTON oButton1 PROMPT "Cancelar" SIZE 035, 015  ACTION {|| nSelect = 0, oDlg:End()  } OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if nSelect > 0
		cReturn := left(aMot[nSelect],6)
	endif

return cReturn

user function Justif()
	local cJustic		:= ""
	Local aArea         := FWGetArea()
	Local nCorFundo     := RGB(238, 238, 238)
	Local nJanAltura    := 300
	Local nJanLargur    := 470
	Local cJanTitulo    := 'Justificativa'
	Local lDimPixels    := .T.
	Local lCentraliz    := .T.
	Local nObjLinha     := 0
	Local nObjColun     := 0
	Local nObjLargu     := 0
	Local nObjAltur     := 0

	Private oDialogPvt
	Private bBlocoIni   := {||}
	//objeto1
	Private oSayObj1
	Private cSayObj1    := 'Descreva a justificativa'
	//objeto3
	Private oBtnObj3
	Private cBtnObj3    := 'Salvar'
	Private bBtnObj3    := {|| oDialogPvt:end()}

	//objeto4
	Private oMulObj4
	Private cMulObj4    := ''
	Private cSayInfo    := '...'

	//Cria a dialog
	oDialogPvt := TDialog():New(0, 0, nJanAltura, nJanLargur, cJanTitulo, , , , DS_MODALFRAME, , nCorFundo, , , lDimPixels)

	//TSay Title
	nObjLinha := 10
	nObjColun := 10
	nObjLargu := 150
	nObjAltur := 10
	oSayObj1  := TSay():New(nObjLinha, nObjColun, {|| cSayObj1}, oDialogPvt, /*cPicture*/, , , , , lDimPixels, /*nClrText*/, /*nClrBack*/, nObjLargu, nObjAltur, , , , , , /*lHTML*/)

	//TMultiGet desc
	nObjLinha := 20
	nObjColun := 10
	nObjLargu := 210
	nObjAltur := 100
	oMulObj4  := TMultiGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , cMulObj4 := u, cMulObj4)}, oDialogPvt, nObjLargu, nObjAltur, , , , , , lDimPixels, , , /*bWhen*/, , , /*lReadOnly*/, /*bValid*/, , , /*lNoBorder*/, .T.)
	oMulObj4:bGetKey := {|self, cText, nKey| fKeyPress(self, cText, nKey)}

	//TButton Send
	nObjLinha := 130
	nObjColun := 160
	nObjLargu := 50
	nObjAltur := 15
	oBtnObj3  := TButton():New(nObjLinha, nObjColun, cBtnObj3,  oDialogPvt, bBtnObj3, nObjLargu, nObjAltur, , , , lDimPixels)

	//TSay Desc
	nObjLinha := 130
	nObjColun := 10
	nObjLargu := 150
	nObjAltur := 15
	oSayInfo  := TSay():New(nObjLinha, nObjColun, {|| cSayInfo}, oDialogPvt, /*cPicture*/, , , , , lDimPixels, /*nClrText*/, /*nClrBack*/, nObjLargu, nObjAltur, , , , , , /*lHTML*/)

	//Ativa e exibe a janela
	oDialogPvt:Activate(, , , lCentraliz, , , bBlocoIni)

	if !empty(cMulObj4)
		cJustic := cMulObj4
	endif

	FWRestArea(aArea)

return cJustic

Static Function fKeyPress(oObjeto, cTextoComp, nKey)
	Local nTamDigit := Len(Alltrim(cTextoComp))

	If nKey < 255 .Or. nKey == 16777219 .Or. nKey == 16777223
		cSayInfo := "Qtde Digitada " + cValToChar(nTamDigit)
		oSayInfo:Refresh()
	EndIf
Return

