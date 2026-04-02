#include "rwmake.ch"           

USER FUNCTION TMKFRETE()

//----------------------------------------------------------------------------
//|Programa  | PNVFT101    | Autor | Wellington Carvalho |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Informa sobre o preenchimento de frete                                    |
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------


nqtd:=acols[n][5] 
DbSelectArea("SB1")

if (SB1->B1_SUBGRUP ="04" .OR. SB1->B1_SUBGRUP = "01") .and. SUA->UA_TPFRETE = "C"
  msgBox("Atenção Produto requer informação de Frete, informar no campo Frete do Item!!")
endif

return(nqtd)