#include "rwmake.ch"

USER FUNCTION PNPCP01()

//----------------------------------------------------------------------------
//|Programa  | PNPCP01     | Autor | Eliene Cerqueira    |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo C2_PRODUTO                                   |
//----------------------------------------------------------------------------
//|Uso       | SIGAPCP                                                       |
//----------------------------------------------------------------------------

WCOD:=M->C2_PRODUTO

DbSelectArea("SG1")
dbSetOrder(1)
DbSeek(xFilial("SG1")+WCOD,.T.)
If EOF() .or. SG1->G1_COD<>WCOD
   msgBox("Produto sem estrutura!","Atencao")
   WCOD := SPACE(14)
Endif

Return(WCOD) 