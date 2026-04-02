#include "rwmake.ch"

USER FUNCTION PNVFT102()

//----------------------------------------------------------------------------
//|Programa  | PNVFT102    | Autor | Eliene Cerqueira    |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo C6_PRCVEN                                    |
//----------------------------------------------------------------------------
//|Uso       | SIGAFAT                                                       |
//----------------------------------------------------------------------------
nvalor2:=acols[n][8] //UB_VLRITEM
nQt:=acols[n][6]   //M->UB_QUANT
nVunit:=acols[n][7] 
DbSelectArea("SA1")

//msgbox("cliente"+SA1->A1_COD)    

IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA" .AND. SB1->B1_TS<>'529'
   
   nvalor2 := nVunit *  nQt
  
ENDIF

return(nValor2)