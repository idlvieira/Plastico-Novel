#INCLUDE "rwmake.ch" 

User Function mudasd2

dbSelectArea("SD2")
dbgotop()

wProd:=Space(15)
wTipo:=space(2)

While !EOF()
    
    wProd:= SD2->D2_COD 
    
    dbSelectArea("SB1") 
    DbSeek(xFilial("SB1") + wProd, .T.)
    If found()   
         wTipo:= SB1->B1_TIPO
         dbSelectArea("SD2")
         RecLock("SD2",.f.)
         REPLACE SD2->D2_tp with wTipo
         MSUNLOCK()
    endif

    dbSelectArea("SD2")
    Dbskip()
enddo  

return