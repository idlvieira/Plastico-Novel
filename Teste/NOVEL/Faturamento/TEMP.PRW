#INCLUDE "RWMAKE.CH"

User Function TEMP

dbSelectArea("SC6")
dbSetOrder(1) // pedido+item
dbGoTop()

While !EOF()

   dbSelectArea("SC5")
   dbSetOrder(1) 
   dbSeek(xFilial("SC5")+SC6->C6_NUM,.F.)	
   If !Found()
      dbSelectArea("SC6")
	  Reclock("SC6",.F.)
	  SC6->( DbDelete() )
  	  MsUnlock()
   	  dbSkip()
	  Loop
   Endif
   IF SC6->C6_TES$"508/515/516/517/521/522/523/524/528/529/531/535/536/537/538/541/543/544/545/546/547/548/549/550/551/552/555/556/557"
      dbSelectArea("SC6")
      dbSkip()
      Loop
   Endif
   If SC6->C6_QTDVEN-SC6->C6_QTDENT = 0
      Reclock("SC6",.F.)
      C6_QTDEMP := 0
      MsUnlock()
      dbSelectArea("SC9")
      dbSetOrder(1)
      dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
      If !Found()// Bloqueado em vendas
         dbSelectArea("SC6")
  	     dbSkip()
         Loop
      Else
         While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
            If EMPTY(C9_NFISCAL)
	           Reclock("SC9",.F.)
	           SC9->( DbDelete() )
  	           MsUnlock()
  	        Endif 
            dbSkip()
         Enddo
      Endif
   Endif
   dbSelectArea("SC6")
   dbSkip()
Enddo
Return
