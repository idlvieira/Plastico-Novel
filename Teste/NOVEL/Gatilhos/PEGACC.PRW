#include "rwmake.ch"        

User Function PEGACC()

_cAlias := ALIAS( )
_cOrd   := INDEXORD( )
 nReg   := RECNO( )
  
SetPrvt("xOP,xNSEQ,xTM")
 
         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a conta contabil do produto produzido                          ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       
xOP     := SD3->D3_OP
xNSEQ   := SD3->D3_NUMSEQ
xTM     := SD3->D3_TM

DbSelectArea("SD3")
DbSetOrder(12)
DbSeek(xFilial()+xOP+xNSEQ) // Posiciona no Produto produzido pela OP e pega a Conta Contábil.

XCC := SD3->D3_CONTA

DBSELECTAREA( _cAlias )
DBSETORDER( _cOrd )
DBGOTO( nReg )

Return( XCC ) 
                                   
