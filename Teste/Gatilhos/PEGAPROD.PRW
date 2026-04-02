#include "rwmake.ch"        

User Function PEGAPROD()

_cAlias := ALIAS( )
_cOrd   := INDEXORD( )
 nReg   := RECNO( )
               
SetPrvt("xCOD")
          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a conta contabil do produto para requisicao do ALX para o LP
                              ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       


DbSelectArea("SD3")
Mcp  := D3_NUMSA
Mcpi := D3_ITEMSA

DbSelectArea("SCP")
DbSetOrder(1)
DbSeek(xFilial()+Mcp+Mcpi) // Posiciona no PRODUTO.

DBSELECTAREA( _cAlias )
DBSETORDER( _cOrd )
DBGOTO( nReg )


Return( SCP->CP_CONTA ) 
                                   
