#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110GRV  º Autor ³Eduardo Cseh Vasquesº Data ³  24.01.2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada para detalhar Motivo do Bloqueio           º±±
±±º          ³solicitacao de compras. Envia e-mail Solicitante/Comprador. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Compras                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT110GRV()


/*
Local aArea	   := GetArea()    &&Salva Area
Local aAliasSAI:= SAI->(GetArea())
Local aAliasSC1:= SC1->(GetArea())
Local nNumSC   := SC1->C1_NUM      // Numero da Solicitação de compras
Local _cAprov  := ""

dbSelectArea("SAI")
dbSetOrder(2) //Filial + User	
If SAI->(dbSeek(xFilial("SAI")+SC1->C1_USER))
	PswOrder(1)
	If PswSeek(SAI->AI_M_APROV,.T.) //Pego as informacoes do Aprovador no cadastro de usuarios (Protheus)
		_cAprov    := SAI->AI_M_APROV
	EndIf	
EndIf
dbCloseArea("SAI")
	
dbSelectArea("SC1")
dbSetOrder(1)
IF DbSeek(xFILIAL("SC1")+nNumSc)
	While !EOF() .and. SC1->C1_NUM == nNumSc
		RecLock("SC1",.f.)
		SC1->C1_ZZCAPRO:= _cAprov
		MsUnlock()
		DbSkip()
	End
Endif    

dbCloseArea("SC1")
	
RestArea(aAliasSAI)
RestArea(aAliasSC1)
RestArea(aArea)
*/

Local aArea	   := GetArea()    &&Salva Area
Local aAliasSAI:= SAI->(GetArea())
Local aAliasSC1:= SC1->(GetArea())
Local nNumSC   := SC1->C1_NUM      // Numero da Solicitação de compras
Local _cAprov  := ""


//BUSCA NO CADASTRO DE C.CUSTO
If !Empty(SC1->C1_CC) 
	_cAprov	:= Posicione("CTT",1,xFilial("CTT")+SC1->C1_CC,"CTT_MBLOGI")
	
	
	// BUSCA O LOGIN DO USUARIO /////////////
	aUsu	:= AllUsers(.T.)
	For I := 1 To Len(aUsu)
		If alltrim(aUsu[I,1,2])==alltrim(_cAprov)
			_cLogin := aUsu[I,1,1] //Login do usuario
			_cNomeC	:= aUsu[I,1,4] //Nome do usuario
			exit
		EndIf
	Next
	
	_cAprov	:= _cLogin


//BUSCA NO CADASTRO DE SOLICITANTES
Else

	dbSelectArea("SAI")
	dbSetOrder(2) //Filial + User	
	If SAI->(dbSeek(xFilial("SAI")+SC1->C1_USER))
		PswOrder(1)
		If PswSeek(SAI->AI_M_APROV,.T.) //Pego as informacoes do Aprovador no cadastro de usuarios (Protheus)
			_cAprov    := SAI->AI_M_APROV
		EndIf	
	EndIf
	dbCloseArea("SAI")
	
EndIf	




dbSelectArea("SC1")
dbSetOrder(1)
IF DbSeek(xFILIAL("SC1")+nNumSc)
	While !EOF() .and. SC1->C1_NUM == nNumSc
		RecLock("SC1",.f.)
		SC1->C1_ZZCAPRO:= _cAprov
		MsUnlock()
		DbSkip()
	End
Endif    

dbCloseArea("SC1")
	
RestArea(aAliasSAI)
RestArea(aAliasSC1)
RestArea(aArea)



Return

