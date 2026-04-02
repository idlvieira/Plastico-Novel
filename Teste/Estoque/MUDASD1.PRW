#INCLUDE "rwmake.ch" 

User Function mudasd1

dbSelectArea("SD1")
dbgotop()

wProd:=Space(15)
wTipo:=space(2)

While !EOF()
    
    wProd:= SD1->D1_COD 
    
    dbSelectArea("SB1") 
    DbSeek(xFilial("SB1") + wProd, .T.)
    If found()   
         wTipo:= SB1->B1_TIPO
         dbSelectArea("SD1")
         RecLock("SD1",.f.)
         REPLACE SD1->D1_tp with wTipo
         MSUNLOCK()
    endif

    dbSelectArea("SD1")
    Dbskip()
enddo  

return