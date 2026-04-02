#include "rwmake.ch"
USER FUNCTION PNVFT101()

//----------------------------------------------------------------------------
//|Programa  | PNVFT101    | Autor | Eliene Cerqueira    |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo C6_PRCVEN                                    |
//----------------------------------------------------------------------------
//|Uso       | SIGAFAT                                                       |
//----------------------------------------------------------------------------
nvalor:=M->C6_PRCVEN  
//ntipo:=M->C5_TIPO
//If ntipo = "N"
//   msgBox("Voce não pode alterar o Preco Unit.")
//   nValor:=0
//Else
   DbSelectArea("SA1")
   IF SA1->A1_ME=="S"  .AND. SA1->A1_EST=="BA"  .AND. SB1->B1_TS<>'529'
      nValor:=nValor-(nValor *  SA1->A1_DESC/100)
   ENDIF
//Endif

return(nValor)