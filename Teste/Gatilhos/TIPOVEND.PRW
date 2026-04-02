#include "rwmake.ch"  
User Function TIPOVEND()

                  
_cAlias := ALIAS( )
_cOrd   := INDEXORD( )
 nReg   := RECNO( )
 
SetPrvt("xCOD")
SetPrvt("MPED")
SetPrvt("MVEND")
SetPrvt("MTIPO")
SetPrvt("MCONTA")        

xCOD := " "
MPED := " "
MVEND := " "
MTIPO := " "
MCONTA := " "       


         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar tipo de vendedor e indica conta contabil                  ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                 
xcod  := SD2->D2_PEDIDO
DbSelectArea("SD2")
DbSetOrder(3)
DbSeek(xFilial()+xCOD)
if found()
   mped := SD2->D2_PEDIDO
   DbSelectArea("SC5")
   DbSetOrder(1)      
   DbSeek(xFilial()+mped)
   mvend := SC5->C5_VEND1
   DbSelectArea("SA3")
   DbSeek(xFilial()+mvend)
   DbSetOrder(1)
   mtipo = A3_TIPOPES
   IF MTIPO = "F"
      MCONTA =  "615023003"
   ELSE
      MCONTA =  "615023002"    
   ENDIF
ELSE   
   MCONTA =  " "
ENDIF
DBSELECTAREA( _cAlias )
DBSETORDER( _cOrd )
DBGOTO( nReg )

Return( MCONTA )                   
