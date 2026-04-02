#include "rwmake.ch"
USER FUNCTION PNVFT103()

//----------------------------------------------------------------------------
//|Programa  | PNVFT103    | Autor | Eliene Cerqueira    |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo C6_QTDLIB                                    |
//----------------------------------------------------------------------------
//|Uso       | SIGAFAT                                                       |
//----------------------------------------------------------------------------
nquant:=M->C6_QTDLIB
If (dDatabase-SC5->C5_EMISSAO)>60 .AND. SC5->C5_OK<>"SS" .AND. !Empty(SC5->C5_EMISSAO)
   msgBox("Pedido emitido a mais de 60 dias. Bloqueado para faturamento.")
   nquant:=0
Endif

return(nquant)