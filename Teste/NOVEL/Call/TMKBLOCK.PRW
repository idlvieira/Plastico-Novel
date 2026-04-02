#include "rwmake.ch"           

USER FUNCTION TMKBLOCK()
//----------------------------------------------------------------------------
//|Programa  | TMKBLOCK   | Autor | Wellington Carvalho |Criado| 13.Mar.2013|  
//----------------------------------------------------------------------------
//|Descricao | Verificar cadastro de clientes                                    |
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       

mcliente := M->UA_CLIENTE  
mprod := M->UB_PRODUTO
DbSelectArea("SA1") 
DbSetOrder(1) 
dbgotop()
DbSeek( xFilial("SA1") + mcliente, .T.)
IF SA1->A1_CADVAL <= dDatabase .OR. Empty(SA1->A1_CADVAL)
   msgBox("Atenção, Proceder atualização do Cadastro de Clientes antes de gerar Pedidos!!! O Cadastro deste Cliente esta desatualizado") 
   RecLock("SA1",.F.)
   SA1->A1_MSBLQL:="1"
   MsUnLock()      
   DbSelectArea("SUA")
   mprod := " "  
   return(mprod)   
else
   return(mprod)   
ENDIF

return   

