#include "rwmake.ch"

USER FUNCTION PNVCC05()
//----------------------------------------------------------------------------
//|Programa  | PNVCC05     | Autor | Eliene Cerqueira    |Criado| 25.Out.2004|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo UB_QUANT - calcula desconto para ME          |
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------


nvalor3 := acols[n][7] //Valor total UB_VLRITEM
nQt:=acols[n][5]   //quantidade M->UB_QUANT 
nVunit:=acols[n][6] //valor unitario 
DbSelectArea("SA1")

IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA" .AND. SB1->B1_TS<>'529'  
   acols[n][7] := int((nVunit *  nQt)*100)/100   //-- Atualiza Valor total
   nvalor3 := int(nVunit *  nQt*100)/100         //--  retornar para a base do icm  
ENDIF
               
return(nValor3)