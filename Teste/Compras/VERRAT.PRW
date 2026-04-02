 #include "rwmake.ch"

USER FUNCTION VERRAT()

//----------------------------------------------------------------------------
//|Programa  |VERRAT       | Autor | WELLINGTON          |Criado| 20-04-2007 |  
//----------------------------------------------------------------------------
//|Descricao |VERIFICAR RATEIO DE ITENS DE COMPRAS	                                               |
//----------------------------------------------------------------------------
//|Uso       | VERRAT()                                                      |
//----------------------------------------------------------------------------

mvl      := M->CT5_VLR01  
mdoc     := M->D1_DOC
mfornece := M->D1_FORNECE


DbSelectArea("SDE")
DbSetOrder(1)
DbSeek(xFilial()+mdoc+mfornece)  
If found()
   mvl := 0 
else
   mvl := IIF(SUBS(SD1->D1_CF,2,3) $ "101/102/124/125/252", SD1->D1_TOTAL - (SD1->D1_VALICM + SD1->D1_VALDESC+SD1->D1_VALIMP6+SD1->D1_VALIMP5), 0)                                                               
endif      
      
Return(mvl) 
