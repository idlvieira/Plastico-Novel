User Function MT110FIL
      
Local aArea	    := GetArea()    &&Salva Area    
Local aAliasSAI:= SAI->(GetArea())
Local cFiltro := ''
Local _cLista  := 'N' && Filtra as Solicitacoes de Compras 

dbSelectArea("SAI")
dbSetOrder(2) //Filial + User	
If SAI->(dbSeek(xFilial("SAI")+__CUSERID))
		_cLista    := SAI->AI_M_BROWS
EndIf
dbCloseArea("SAI")

IF _cLista = 'S'
	cFiltro := " ( C1_ZZCAPRO = '" + ALLTRIM(__CUSERID) + "' .OR. C1_USER = '"  + ALLTRIM(__CUSERID) + "' )"	
Endif

RestArea(aAliasSAI)
RestArea(aArea)

Return (cFiltro)
