#include "rwmake.ch"

USER FUNCTION PNVCC04()
//----------------------------------------------------------------------------
//|Programa  | PNVCC04     | Autor | Eliene Cerqueira    |Criado| 25.Out.2004|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo UB_VRUNIT - Grava o valor unit. em UB_BASEICM|
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------
nvalor3:=acols[n][7] //UB_VLRITEM alterado
//nQt:=acols[n][4]   //M->UB_QUANT
//nVunit:=acols[n][5] 
//DbSelectArea("SA1")


//msgbox("cliente"+SA1->A1_COD)    
/*
IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA" .AND. SB1->B1_TS<>'529'
   
   nvalor3 := nVunit *  nQt
  
ENDIF
*/
return(nValor3)