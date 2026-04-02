#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MYTMKCLASS  ºAutor  ³Leandro Ferreira  º Data ³  14/10/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º																		  º±±
±±ºDesc.     ³ Fonte para servir de base para diversas validações e 	  º±±
±±º          ³ classes do SIGATMK                                         º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
//                              ALTERACOES  
// Data        Colaborador        Chamado  Solicitante     Motivo
// 14/10/20    Leandro Ferreira		  192  Kerolem Inacio  Bloqueio de campos TMK e FAT


//***********************//
//Valida se a tabela utilizada permite a alteração do preço unitário
//
User Function myPRFIX()

	local cPRFIX := " "

	if funname() == "MATA410" .and. M->C5_TABELA != ' '
		cPRFIX := POSICIONE("DA0",1,xFilial("DA0")+M->C5_TABELA,"DA0_ZPRFIX")
		if 	cPRFIX == 'S'		
			return .F.
		endif 
	ElseIf funname() == "TMKA271"
		cPRFIX := POSICIONE("DA0",1,xFilial("DA0")+M->UA_TABELA,"DA0_ZPRFIX")
		if 	cPRFIX == 'S'		
			return .F.
		endif 
	EndIf 

return .T.

//***********************//
// funcao de desconto
User Function atDesc1()

	local nPosUnit		:= aScan(aHeader, {|x| allTrim(x[2]) == "UB_VRUNIT"	})
	local nPosPrcTab	:= aScan(aHeader, {|x| allTrim(x[2]) == "UB_PRCTAB"	})
	local nPosDesc		:= aScan(aHeader, {|x| allTrim(x[2]) == "UB_DESC"	})
	local nPosVlDesc	:= aScan(aHeader, {|x| allTrim(x[2]) == "UB_VALDESC"})
	local nPosQuant		:= aScan(aHeader, {|x| allTrim(x[2]) == "UB_QUANT"	}) 
	
	if aCols[n, nPosUnit] < aCols[n, nPosPrcTab]			
		aCols[n, nPosDesc]   := round((((aCols[n, nPosUnit] / aCols[n, nPosPrcTab]) - 1) * 100) * - 1, 2)
		aCols[n, nPosVlDesc] := (aCols[n, nPosPrcTab] - aCols[n, nPosUnit]) * aCols[n, nPosQuant]
	endif

return .T.
