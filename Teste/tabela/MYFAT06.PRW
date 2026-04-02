#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³ MYFAT06  ºAutor  ³ NEWTON ALVES       º Data ³  28/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ USADO PARA TRAVAR O ORCAMENTO NO CALL CENTER PARA TODA     º±±
±±º          ³ ALTERACAO NO ORCAMENTO BLOQUEIA AUTOMATICAMENTE            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MYFAT06(_cCampo)

//_PnQtd		:= gdFieldPos("UB_QUANT")
//_nValor		:= M->UB_QUANT   
_lAlterou	:= .F. 
                    

// alert(str(UB_QUANT))

/*
_PcProduto	:= gdFieldPos("UB_PRODUTO")
_PnQtd		:= gdFieldPos("UB_QUANT")
_PnValor	:= gdFieldPos("UB_VRUNIT")
_PnTotal	:= gdFieldPos("UB_VLRITEM")
_PnDesc		:= gdFieldPos("UB_DESC")
_PnValdesc	:= gdFieldPos("UB_VALDESC")
_PnTes		:= gdFieldPos("UB_TES")


If acols[N,_PcProduto] <> SUB->UB_PRODUTO
	_lAlterou	:= .T.
EndIf
If acols[N,_PnQtd] <> M->UB_QUANT
	_lAlterou	:= .T.
EndIf
If acols[N,_PnValor] <> M->UB_VRUNI
	_lAlterou	:= .T.
EndIf
If acols[N,_PnDesc] <> M->UB_VLRITEM
	_lAlterou	:= .T.
EndIf 

If acols[N,_PnValdesc] <> M->UB_DESC
	_lAlterou	:= .T.
EndIf
If acols[N,_PnTes] <> M->UB_TES
	_lAlterou	:= .T.
EndIf

*/


DBSELECTAREA("SUA")
If (SUA->UA_STATU2 == "LIB" .OR. SUA->UA_STATU2== "REJ") .AND. ALTERA // .OR. SUA->UA_STATU1 == "LIB") .and. ALTERA
	//alert("Este Orcamento foi alterado e será enviado para liberacao novamente!!")
	ALERT("Este Orcamento foi alterado e será enviado para liberacao novamente!!!")
		SUA->UA_STATU2 := "BLO"
		SUA->UA_STATU1 := "BLO"  
		M->UA_STATU2 := SUA->UA_STATU2 
		M->UA_STATU1 := SUA->UA_STATU1
		_lAlterou := .T.
	
EndIf

If _lAlterou
	Return &_cCampo
Else  
    Return &_cCampo

EndIf

Return 
