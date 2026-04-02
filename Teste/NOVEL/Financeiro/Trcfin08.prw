USER FUNCTION TRCFIN08

cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()
dbSelectArea("SX6")

If FUNNAME() == "FINA150" 
  dbSeek(xFilial()+"MV_CNABCR")
else
   If FUNNAME() == "FINA420" 
      dbSeek(xFilial()+"MV_CNABCP")
   else
     If FUNNAME() == "GPEM410" 
        dbSeek(xFilial()+"MV_CNABFOL")
      Endif
   Endif
Endif

RecLock("SX6",.f.)
   Replace X6_CONTEUD With "00000"
MsUnLock()           
cRet := Space(9)
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(cRet)
