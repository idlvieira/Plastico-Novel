#INCLUDE "rwmake.ch" 
         

User Function MUDASD1

dbSelectArea("SD1")
dbgotop()
wProd:=Space(15)
walx:=space(2)

While !EOF()
    wProd:= SD1->D1_COD
    dbSelectArea("SB1")   
    DbSeek(xFilial("SB1") + wProd, .T.)
    If found().AND. B1_COD=wProd                 
         walx := SB1->B1_LOCPAD
         dbSelectArea("SD1")
         RecLock("SD1",.f.)
         REPLACE SD1->D1_LOCAL with walx
         MSUNLOCK()
    endif
    dbSelectArea("SD1")
    Dbskip()
enddo  


dbSelectArea("SD2")
dbgotop()
wProd:=Space(15)
walx:=space(2)

While !EOF()
    wProd:= SD2->D2_COD
    dbSelectArea("SB1")   
    DbSeek(xFilial("SB1") + wProd, .T.)
    If found().AND. B1_COD=wProd                 
         walx := SB1->B1_LOCPAD
         dbSelectArea("SD2")
         RecLock("SD2",.f.)
         REPLACE SD2->D2_LOCAL with walx
         MSUNLOCK()
    endif
    dbSelectArea("SD2")
    Dbskip()
enddo  
                   

dbSelectArea("SD3")
dbgotop()
wProd:=Space(15)
walx:=space(2)

While !EOF()
    wProd:= SD3->D3_COD
    dbSelectArea("SB1")   
    DbSeek(xFilial("SB1") + wProd, .T.)
    If found().AND. B1_COD=wProd                 
         walx := SB1->B1_LOCPAD
         dbSelectArea("SD3")
         RecLock("SD3",.f.)
         REPLACE SD3->D3_LOCAL with walx
         MSUNLOCK()
    endif
    dbSelectArea("SD3")
    Dbskip()
enddo  


return
         