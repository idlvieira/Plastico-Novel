#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKGRPED   ºAutor  ³Fernando Amorim     º Data ³  01/22/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esse ponto de entrada eh executado no inicio do processo   º±±
±±º          ³ de ligacao.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 10 Ms-Sql Server                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
User Function TKGRPED(nLiquido, aParcelas, cOper, cNum, cCODLIG, cCodPagto, cOpFat, cCodTransp)

	local aAreaATU	:= getArea()
	local aAreaSA1	:= SA1->(getArea())
	local aAreaSE1	:= SE1->(getArea())
	local aAreaSUB	:= SUB->(getArea())
	local aAreaSUS	:= SUS->(getArea())
	local nValor	:= 0 
	local ltemVenc	:= .F.  
	local nDesc		:= 0
	local nX		:= 0
	local n			:= 0

	public lMudou	:= .F.
	public lBloq	:= .F.
	
	nDsc			:= gdFieldPos("UB_DESC")
	cOpFat			:= allTrim(SuperGetMv("MV_OPFAT"))
	nDescOrc		:= U_MYCFG02("TMK000001", "001", "P",, "N")        //Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000001"+"001","ZZZ_RETORN",,"N") //SuperGetMv("MV_DESORC1",,17.63)
	
	// solucao para analise de desconto,qd o operador colocar o campo ua_oper para faturamento swnso que temos uma analise de desconto antes
	for n := 1 to len(aCols)
		if aCols[n, nDsc] > nDescOrc .and. M->UA_ZZSTAT2 != "LIB" .and. IIF(ALTERA, SUA->UA_ZZSTAT2 != "LIB",.T.)
	   		cOper      := "2"
	   		M->UA_OPER := "2"
	   		exit
		endif
	next nA
	
	// validacao de bloqueio de limite de credito
	if cOper == "1" .and. M->UA_ZZSTAT1 != "LIB" .and. IIF(ALTERA, SUA->UA_ZZSTAT1 != "LIB",.T.)
		if allTrim(cCodPagto) != Posicione("ZZZ", 1, xFilial("ZZZ") + "TMK000009" + "001", "ZZZ_RETORN") //"001" 	
			SA1->(dbSetOrder(1))
	   		if SA1->(dbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA))
				if SA1->A1_LC < nLiquido // valor do pedido maior que o limite de credito
					M->UA_OPER := "2" 
					lMudou     := .T.

					return .T.
				elseif SA1->A1_VENCLC < dDataBase // data de validade do limite vencida
					M->UA_OPER := "2" 
					lMudou     := .T.

					return .T.
				else
					// valida no financeiro pendencias do cliente
					dbSelectArea("SE1")
					SE1->(dbSetOrder(2))
			        if SE1->(dbSeek(xfilial("SE1") + M->UA_CLIENTE + M->UA_LOJA))
			        	nValor   := 0 
			        	ltemVenc := .F.
						while SE1->(!eof() .and. SE1->E1_FILIAL + SE1->E1_CLIENTE + SE1->E1_LOJA == xfilial("SE1")+ M->UA_CLIENTE + M->UA_LOJA)
							if empty(SE1->E1_BAIXA) .and. SE1->E1_SALDO > 0
								if SE1->E1_VENCREA < dDatabase
									ltemVenc := .T.
								else
									nValor += SE1->E1_VALOR
								endif										
							endif
						
							SE1->(dbSkip())
						enddo
						
						if ltemVenc
							M->UA_OPER := "2" 
							lMudou     := .T.
							return .T.
						elseif SA1->A1_LC < (nValor + nLiquido)
							M->UA_OPER := "2" 
							lMudou     := .T.  
							return .T.
						endif					
					endif									
				endif
			else
				SUS->(dbSetOrder(1)) 
				SUS->(dbSeek(xfilial("SUS") + M->UA_CLIENTE + M->UA_LOJA)) 
				if !empty(SUS->US_CODCLI)
			   		M->UA_OPER := "2"
			   		lMudou     := .T.
			   		return .T.
			 	else
			 		M->UA_OPER := "2"
					msgAlert("Não pode gerar pedido para Prospect, será gravado um orçamento", "Atenção")
					return .T.
				endif 	
			endif			
		endif
	endif	

	// validacao de limite de desconto                                                        
	if cOper == "2" .and. M->UA_ZZSTAT2 != "LIB"  .and. IIF(ALTERA, SUA->UA_ZZSTAT2 != "LIB", .T.)		
		for nX := 1 to len(aCols)			
			if nDescOrc < aCols[nX, nDsc]
	       		nDesc := aCols[nX, nDsc]
	    		exit
	    	endif		
		next nX
		
		if nDesc > nDescOrc		
		    lBloq      := .T.
		    M->UA_OPER := "2"	
			return .T.
		endif
	elseif cOper == "1" .and. M->UA_ZZSTAT2 != "LIB" .and. IIF(ALTERA,SUA->UA_ZZSTAT2 != "LIB",.T.)
		SUB->(dbSetOrder(1)) 
		SUB->(dbSeek(xFilial("SUB")+ M->UA_NUM)) 
		nDesc := 0	
		while SUB->(!eof()) .and. SUB->UB_FILIAL + SUB->UB_NUM == xfilial("SUB") + M->UA_NUM	       
	    	if nDesc < SUB->UB_DESC	    	
	    		nDesc := SUB->UB_DESC	    	
	    	endif
	
	   		SUB->(dbSkip())
		enddo
		
		if nDesc > nDescOrc		
		    lBloq := .T.
		    M->UA_OPER := "2"	
			return .T.
		endif	
	endif

	restArea(aAreaSA1)
	restArea(aAreaSE1)
	restArea(aAreaSUB)
	restArea(aAreaSUS)
	restArea(aAreaATU)

return .T.

// funcao de desconto
User Function atDesc()

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
