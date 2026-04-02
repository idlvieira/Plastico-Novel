#include "rwmake.ch"

USER FUNCTION PCP02()

//----------------------------------------------------------------------------
//|Programa  | PCP02       | Autor | Eliene Cerqueira    |Criado| 03.Mar.2006|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo D3_PERDAS - Grava D3_CODS = b1_sucata        |
//----------------------------------------------------------------------------
//|Uso       | SIGAPCP                                                       |
//----------------------------------------------------------------------------

cAlias := Alias()
cOrd   := IndexOrd()

If FunName() == "MATA250" .and. M->D3_PERDAS > 0
   DbSelectArea("SB1")
   DbSetOrder(1)
   DbSeek(xFilial()+M->D3_COD,.F.)
   nCOD := SB1->B1_SUCATA
   If Empty(nCOD)
      msgBox("Digite o Codigo para Perda!","Atencao")
   Endif
Else
   nCOD   := SPACE(15)
Endif

Dbselectarea(cAlias)
Dbsetorder(cOrd)

Return(nCOD) 