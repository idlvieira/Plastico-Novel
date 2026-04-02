#include "rwmake.ch"
USER FUNCTION TMKITEM()

//----------------------------------------------------------------------------
//|Programa  | TMKITEM     | Autor |                     |Criado|            |  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo UB_PRODUTO - verifica qtde de itens          |
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------

IF LEN(ACOLS)>11 
        MSGBOX("O NUMERO MAXIMO DE ITENS E 11!")
        RETURN(" ")
ELSE
        RETURN(UB_PRODUTO)
ENDIF

return