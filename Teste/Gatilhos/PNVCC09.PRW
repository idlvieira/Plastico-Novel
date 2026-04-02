#include "rwmake.ch"
USER FUNCTION PNVCC09() 

//----------------------------------------------------------------------------
//|Programa  | PNVCC08     | Autor | wellington carvalho    |Criado| 11.set.2008|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho de diversos campos para verificar se o pedido encontra-se liberado|
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------
       

mprod:=acols[n][1] // produto
DbSelectArea("SUA")
If SUA->UA_STATUS="LIB"
   msgBox("Pedido Liberado,Alteração, Não Permitida!!!")
   mprod := " " 
endif

return(mprod)