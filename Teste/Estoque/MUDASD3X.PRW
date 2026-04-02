#INCLUDE "rwmake.ch" 

User Function mudasd3x

dbSelectArea("SD3")
dbgotop()

wProd:=Space(15)
wTipo:=space(2)

While !EOF()
    
    wProd:= SD3->D3_COD 
    
    dbSelectArea("SB1") 
    DbSeek(xFilial("SB1") + wProd, .T.)
    If found()   
         wTipo:= SB1->B1_TIPO
         dbSelectArea("SD3")
         RecLock("SD3",.f.)
         REPLACE SD3->D3_tipo with "XX"
         MSUNLOCK()
    endif

    dbSelectArea("SD3")
    Dbskip()
enddo  

return