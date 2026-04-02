#include "rwmake.ch"

USER FUNCTION PNVFT105()

//----------------------------------------------------------------------------
//|Programa  | PNVFT105    | Autor | Eliene Cerqueira    |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo C6_QUANT                                     |
//----------------------------------------------------------------------------
//|Uso       | SIGAFAT                                                      |
//----------------------------------------------------------------------------

nQt:=acols[n][6]   //M->C6_QUANT

If ! (alltrim(substr(cusuario,7,15)) $ getmv("MV_AMGRAT"))
   DbSelectArea("SB1")
   dbSetOrder(1)
   dbSeek(xFilial("SB1")+acols[n][2],.F.)
   If B1_QE<>0 .and. nQt <> Int(nQt/B1_QE)*B1_QE
      msgBox("Quantidade não é multiplo da embalagem","Atencao")
      nQt := 0
   Endif
Endif

Return(nQt) 