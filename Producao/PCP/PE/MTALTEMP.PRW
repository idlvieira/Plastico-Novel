#Include "rwmake.ch"
#include 'protheus.ch'
#include 'parmtype.ch'
#Include "topconn.ch"
#Include "MsObject.ch"
#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MTALTEMP.prw    | Autor : Leandro Ferreira      | Data : 29/04/2020|\
/|-------------------------------------------------------------------------------|\
/| Descricao: Após a tela de alteração de empenho, para checar se o empenho 	 |\
/|            original foi alterado pelo usuário e coletar o motivo				 |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante       Motivo
// 29/04/2020  Leandro Ferreira          Giuliano Olivetti Unificação do apontamento           

User Function MTALTEMP()
	Local aParam := PARAMIXB
	Local oDialogo
	Local _cMotivoPcp := "OPE"
	//aParam[3] := 25 // altera quantidade
	GETAREA()
	//alert("OI")

	if aParam[15][aParam[16]][18] != aParam[3]
		@ 200,001 To 450,350 Dialog oDialogo Title "LOG DE ALTERAÇÃO DE BUILD UP"
		@ 002,010 To 120,170 PIXEL
		@ 015,015 Say "OP: " + aParam[9] COLOR CLR_HBLUE PIXEL
		@ 030,015 Say "CODIGO: " + aParam[1] COLOR CLR_HBLUE	PIXEL
		@ 045,015 Say "QUANTIDADE ORIGINAL: " + cValToChar(aParam[15][aParam[16]][18]) COLOR CLR_HBLUE	PIXEL
		@ 060,015 Say "QUANTIDADE ALTERADA: " + cValToChar(aParam[3]) COLOR CLR_HBLUE	PIXEL
		@ 075,015 Say "Motivo : " COLOR CLR_HBLUE PIXEL
		aItems:= {'OPE=Operacional','MAQ=Maquina','MAT=Material','EST=Estrutura'}
		cCombo:= aItems[1]
		oCombo := TComboBox():New(078,045,{|u|if(PCount()>0,cCombo:=u,cCombo)},; 
		aItems,100,013,oDialogo,,;
		,,,,.T.,,,,,,,,,'cCombo')
		//@ 100,030 BmpButton Type 01 Action iif(Continua(_cDigUsu,_cSenha,.F.,@_lRet,@_cUserLiberado,@_cNomeFull),Close(oDialogo),NIL)
		//@ 100,080 BmpButton Type 02 Action iif(Continua(_cDigUsu,_cSenha,.T.,@_lRet,@_cUserLiberado,@_cNomeFull),NIL,Close(oDialogo))
		@ 110,030 BmpButton Type 01 Action Close(oDialogo)
		Activate Dialog oDialogo Centered
		
		  RecLock("ZZ4",.T.)
          ZZ4->ZZ4_FILIAL 	:= xFilial("ZZ4")
          ZZ4->ZZ4_OP		:= aParam[9]
          ZZ4->ZZ4_COD    	:= aParam[1]
          ZZ4->ZZ4_QTDOR	:= aParam[15][aParam[16]][18]
          ZZ4->ZZ4_QTDNEW 	:= aParam[3]
          ZZ4->ZZ4_LOG		:= cCombo
          ZZ4->(MSUNLOCK())
	endIf 

Return (aParam)
