#INCLUDE "RWMAKE.CH"

User Function GRDOCUA

dbSelectArea("SUA")
DbSetOrder(8)
dbSelectArea("SF2")
DbSetOrder(1)
dbSelectArea("SC5")
dbSetOrder(1) 
dbGoTop()
While !EOF()
   If !EMPTY(SC5->C5_NOTA)
      dbSelectArea("SF2")
      DbSeek(xFilial()+SC5->C5_NOTA,.T.)
      XNF:=SF2->F2_DOC
      DbSelectArea("SUA")
      DbSeek(xFilial()+SC5->C5_NUM,.T.)
      If Found()
         Reclock("SUA",.F.)
         UA_DOC     := SC5->C5_NOTA
         UA_SERIE   := SC5->C5_SERIE
         UA_EMISNF  := SF2->F2_EMISSAO
         MsUnlock()
      Endif
   Endif
   dbSelectArea("SC5")
   dbSkip()
Enddo
Return
