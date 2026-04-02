#include "rwmake.ch"
USER FUNCTION TMKCOM()

//----------------------------------------------------------------------------
//|Programa  | TMKCOM      | Autor | Eliene Cerqueira    |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo UB_PRODUTO - Pega % comissao do vendedor     |
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------

DbSelectArea("SA3")
If SA3->A3_TIPO=="E"
   nValor:=SA3->A3_COMIS
ElseIf SA3->A3_COD="999999"
   nValor:=0
Else
   DbSelectArea("SB1")
   nValor:=SB1->B1_COMIS
   If Date()-SB1->B1_DATREF<120
      nValor:=SB1->B1_COMIS*2
   Endif
Endif

return(nValor)