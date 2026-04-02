#include "rwmake.ch"  
      

User Function PEGAREQ2()

_cAlias := ALIAS( )
_cOrd   := INDEXORD( )
 nReg   := RECNO( )
 
SetPrvt("xCOD")
         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a Descrição da Requisição para o historico                     ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       
xcod  := SB1->B1_COD
MHIST := SPACE(40)   
MSUMAR := SPACE(40)
DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial()+xCOD) // Posiciona no PRODUTO. 
Mdesc := alltrim(B1_DESC)
   
DbSelectArea("SD3")
Mcp  := D3_NUMSA
Mcpi := D3_ITEMSA
Mqtd := alltrim(STR(D3_QUANT,16,6))
Musa := alltrim(D3_USUARIO)

DbSelectArea("SCP")
DbSetOrder(1)
DbSeek(xFilial()+Mcp+Mcpi) // Posiciona no PRODUTO.  
mobs := alltrim(cp_obs)

MHIST = mqtd+" "+mdesc+" "+"Solic Por: "+musa+" "+mobs  

MSUMAR = substr(MHIST,41,40)

DBSELECTAREA( _cAlias )
DBSETORDER( _cOrd )
DBGOTO( nReg )

Return( MSUMAR ) 
                         
