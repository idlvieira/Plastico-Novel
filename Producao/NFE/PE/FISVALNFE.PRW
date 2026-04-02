#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include 'parmtype.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FISVALNFE ºAutor  ³ Leandro Ferreira   º     ³ 13/08/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação de gravação no chamado.						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Impede a emissão de NF com data inferior à data atual      º±±
±±º          ³              											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante            Motivo
// 13/04/20    Leandro Ferreira      96  Leonardo Bergamasco    Trava de data para emissão

User Function FISVALNFE()	
	Local lTran		:=.T.	
	Local cTipo		:=PARAMIXB[1]	
	Local cFilnf	:=PARAMIXB[2]	
	Local cEmissao	:=PARAMIXB[3]	
	Local cNota		:=PARAMIXB[4]	
	Local cSerie	:=PARAMIXB[5]	
	Local cClieFor	:=PARAMIXB[6]	
	Local cLoja		:=PARAMIXB[7]	
	Local cEspec	:=PARAMIXB[8]	
	Local cFormul	:=PARAMIXB[9]		
	dbSelectArea("SF2")	
	dbSetOrder(1)			
	dbseek(cFilnf+cNota+cSerie+cClieFor+cLoja+cFormul+cTipo)		
	While !EOF() .AND. SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_FORMUL+SF2->F2_TIPO  == cFilnf+cNota+cSerie+cClieFor+cLoja+cFormul+cTipo				
		If SF2->F2_EMISSAO < Date()	
				ShowHelpDlg(SM0->M0_NOME, {"Atenção, a NF: " + cValtoChar(SF2->F2_DOC) + " está com data inferior à atual! Data da NF: " + DToC(SF2->F2_EMISSAO) + " Data atual: " + DToC(Date())},5,{"Faça o cancelamento da mesma e emita uma nova com a data atual."},5)
			lTran:=.F.			
			Exit		
		EndIf	
		If SF2->F2_EMISSAO > Date()	
				ShowHelpDlg(SM0->M0_NOME, {"Atenção, a NF: " + cValtoChar(SF2->F2_DOC) + " está com data superior à atual! Data da NF: " + DToC(SF2->F2_EMISSAO) + " Data atual: " + DToC(Date())},5,{"Faça o cancelamento da mesma e emita uma nova com a data atual."},5)
			lTran:=.F.			
			Exit		
		EndIf		
		dbSkip()	
	End 
Return  lTran
