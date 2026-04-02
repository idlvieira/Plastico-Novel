#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOK  ºAutor 	º Kleverson Melo      ³ Data ³  10/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para verificar se o Usuario Logado pode   º±±
±±º          ³ Emitir todos pedidos ou somento que não gera Financeiro     ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT - MT410LIOK  ( PEDIDO DE VENDA )                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION M410LIOK()
Local aArea    := GetArea()
Local aAreaSC6 := SC6->(GetArea()) 
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSF4 := SF4->(GetArea())
Local lRet     := .T.
Local nPercent := 0 
Local nPosTES  := GDFIELDPOS("C6_TES")  
Local nPosCfo  := GDFIELDPOS("C6_CF")
Local lDel	   := aCols[ n , Len(aCols[n]) ] 
  
  	If !lDel
		cQuery := "SELECT F4_DUPLIC, F4_MYFATUR FROM "+ RetSQLName("SF4") +" WHERE"
		cQuery += " F4_FILIAL ='"+ xFILIAL("SF4") +"' AND F4_CODIGO ='"+ aCols[ n , nPosTES ] +"'"
		cQuery += " AND D_E_L_E_T_ = ' '"
		TcQuery cQuery Alias TSF4 New
		TSF4->(dbGoTop())
		   
		   /* Verifica se gera duplicata. 		  		
			If TSF4->F4_DUPLIC == "S"  .AND. !L410AUTO
				Alert("Voce nao esta autorizado a incluir, alterar ou excluir pedidos de Venda!!!")
				lRet := .F.
			Endif 
			*/
			
	//SSILVA	
    If !IsBlind()
		IF TSF4->F4_MYFATUR <>"S"
			Alert("Voce nao esta autorizado a incluir, alterar ou excluir esta linha do Pedido de Venda!!!")
	    lRet := .F.  
   		Endif 
   	Endif	
   	//SSILVA 
			  
		TSF4->(dbCloseArea())
	Endif 

RestArea(aAreaSF4) 
RestArea(aAreaSC6) 
RestArea(aAreaSC5)
RestArea(aArea)

RETURN lRet