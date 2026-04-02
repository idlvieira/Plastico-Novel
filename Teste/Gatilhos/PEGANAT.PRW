#include "rwmake.ch"        

User Function PEGANAT()

_cAlias := ALIAS( )
_cOrd   := INDEXORD( )
 nReg   := RECNO( )
  
               

SetPrvt("xFORNECE,xLOJA,xPREFIXO,xTITULO")
 
         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a conta contabil do banco do pagamento                         ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       
xTITULO     := SF1->F1_DOC
xPREFIXO    := SF1->F1_SERIE
xFORNECE    := SF1->F1_FORNECE
xLOJA       := SF1->F1_LOJA

DbSelectArea("SE2")
DbSetOrder(6)
DbSeek(xFilial()+xFORNECE+xLOJA+xPREFIXO+xTITULO) // Posiciona no titulo original do SE2.

_cNatureza    := SE2->E2_NATUREZ

dbSelectArea( "SED" )  //Abre o SED
dbSetOrder(1)
dbSeek( xFilial("SED") + _cNatureza,.T. )


DBSELECTAREA( _cAlias )
DBSETORDER( _cOrd )
DBGOTO( nReg )


Return( SED->ED_CONTAD ) 
                                   
