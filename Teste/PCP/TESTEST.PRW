#include "rwmake.ch" 
#INCLUDE "TOPCONN.CH"

USER FUNCTION TESTEST()

ncod := acols[n][2]


DbSelectArea("SG1") 
DbSetOrder(2)
dbgotop()
dbseek(xfilial()+M->CP_PRODUTO)
if found()
   msgbox("Componente de Estrutura, Requisição não Permitida!!")
   ncod = " "  
   acols[n][3] = " "
else
   ncod = M->CP_PRODUTO  
 
endif
                                                                                     

return(ncod)



