#include "topconn.ch"
#include "rwmake.ch"
/*
Programa	EXCEL01.PRW
Descrição	Execblock utilizado para retornar o valor orçado por centro de custo.
			Usado na integração com o Excel -> ORCAMENTO_REALIZADO.XLS
Criação		Julho/2005 - Beatriz Azevedo (TBA087)
Cliente		EAO
*/
User Function Excel01

Return
                         
User Function OrcadoCC
//Gravando valores orcados

Local nOrcado:=0            
Local cGrupo :=Space(8)

// PARAMIXB = CCCCXXYYYYDDMMNNNNN
//            12345678901234567890123
// CCCC - Centro de Custo / XX = Mes do Relatorio / YYYY = Ano do Relatorio / DDMM = Dia Final/Mes / CCCCC = Grupo da Natureza

//PARAMIXB:="06200530061101    "      
cDia :=SubStr(PARAMIXB,11,2)
cMes :=SubStr(PARAMIXB,13,2)
cAno :=SubStr(PARAMIXB,7,4)
cGrp :=SubStr(PARAMIXB,15,Len(Alltrim(PARAMIXB))-14)
cCCst:=Substr(PARAMIXB,1,4)

If  cMes>SubStr(PARAMIXB,5,2)
    Return(nOrcado)
Endif

mv_par01:=Ctod("01/"+cMes+"/"+cAno)
mv_par02:=Ctod(cDia+"/"+cMes+"/"+cAno)

/*
cFil:=xFilial("SE5")

cQry := "SELECT EW_VALOR, EW_NATUREZ, EW_CCUSTO, EW_ANO, EW_MES"
cQry += " FROM " + RetSqlName("SEW") + " EW"
cQry += " WHERE EW.D_E_L_E_T_ <> '*' AND EW_FILIAL = '" + cFil + "'"
cQry += " AND EW_MES = '" + cMes + "' AND EW_ANO = '" + cAno + "'"

TCQUERY cQry NEW ALIAS QRY

*/

aStru:={}
AADD( aStru, {"EW_VALOR"  ,"N" ,17 ,2} )
AADD( aStru, {"EW_NATUREZ","C" ,10 ,0} )
AADD( aStru, {"EW_CCUSTO" ,"C" ,9 ,0} )
AADD( aStru, {"EW_ANO"    ,"C" ,4 ,0} )
AADD( aStru, {"EW_MES"    ,"C" ,2 ,0} )

cArq :=CriaTrab(aStru,.T.)
Use &cArq alias QRY new   

dbSelectArea("SEW")
dbSetOrder(1)
dbGoTop()

SEW->(DbSeek(xFilial("SEW")+cAno+cMes,.T.))
Do  While SEW->( !Eof() ) .and. SEW->EW_Ano=cAno .and. SEW->EW_Mes=cMes

    RecLock("QRY",.T.) 
    QRY->EW_VALOR  := SEW->EW_VALOR
    QRY->EW_NATUREZ:= SEW->EW_NATUREZ
    QRY->EW_CCUSTO := SEW->EW_CCUSTO
    QRY->EW_ANO    := SEW->EW_ANO
    QRY->EW_MES    := SEW->EW_MES
    DbUnlock()
    
    SEW->( DbSkip() )

Enddo

dbSelectArea("QRY")
dbGoTop()

Do  While QRY->( !Eof() )

    If  cCCst<>"XXXX" .and. QRY->EW_CCUSTO<>cCCst
        SZ2->(dbSkip())
        Loop
    Endif

    cGrupo:=Posicione("SED",1,xFilial("SED")+QRY->EW_NATUREZ,"ED_GRUPO")
    If  Alltrim(cGrupo)<>Alltrim(cGrp)
        QRY->(dbSkip())
        Loop
   Endif   

   nOrcado := nOrcado + QRY->EW_VALOR
        
   QRY->(dbSkip())
    
Enddo                

dbSelectArea("QRY")
dbCloseArea()

Return(nOrcado)

***********************
User Function RealizCC
***********************
//Gravando valores realizados    

nRealiz:=0            
cGrupo :=Space(8)

//Return(nRealiz)
// PARAMIXB = CCCCXXYYYYDDMMNNNNN
//            12345678901234567890123
// CCCC - Centro de Custo / XX = Mes do Relatorio / YYYY = Ano do Relatorio / DDMM = Dia Final/Mes / CCCCC = Grupo da Natureza

//PARAMIXB:="06200530061101    "      
cDia :=SubStr(PARAMIXB,11,2)
cMes :=SubStr(PARAMIXB,13,2)
cAno :=SubStr(PARAMIXB,7,4)
cGrp :=SubStr(PARAMIXB,15,Len(Alltrim(PARAMIXB))-14)
cCCst:=Substr(PARAMIXB,1,4)

If  cMes>SubStr(PARAMIXB,5,2)
    Return(nRealiz)
Endif

mv_par01:=Ctod("01/"+cMes+"/"+cAno)
mv_par02:=Ctod(cDia+"/"+cMes+"/"+cAno)

dbSelectArea("SZ2")
dbSetOrder(1)
dbGoTop()

SZ2->(DbSeek(xFilial("SZ2")+Dtos(mv_par01)+Alltrim(cGrp),.T.))
Do  While SZ2->( !Eof() ) .and. SZ2->Z2_Data<=mv_par02

    If  Alltrim(SZ2->Z2_GRUPO)<>Alltrim(cGrp) .OR. (cCCst<>"XXXX" .and. SZ2->Z2_CCUSTO<>cCCst)
        SZ2->(dbSkip())
        Loop
    Endif
    
    nRealiz := nRealiz + SZ2->Z2_VALOR
        
    SZ2->(dbSkip())
    
Enddo                

Return(nRealiz)

***********************
User Function AcumulCC
***********************
//Gravando valores realizados acumulados

nAcumul:=0            
cGrupo :=Space(8)

// PARAMIXB = CCCCXXYYYYDDMMNNNNN
//            12345678901234567890123
// CCCC - Centro de Custo / XX = Mes do Relatorio / YYYY = Ano do Relatorio / DDMM = Dia Final/Mes / CCCCC = Grupo da Natureza

//PARAMIXB:="06200530061101    "      
cDia :=SubStr(PARAMIXB,11,2)
cMes :=SubStr(PARAMIXB,13,2)
cAno :=SubStr(PARAMIXB,7,4)
cGrp :=SubStr(PARAMIXB,15,Len(Alltrim(PARAMIXB))-14)
cCCst:=Substr(PARAMIXB,1,4)

mv_par01:=Ctod("01/01/"+cAno)
mv_par02:=Ctod(cDia+"/"+cMes+"/"+cAno)

dbSelectArea("SZ2")
dbSetOrder(1)
dbGoTop()

SZ2->(DbSeek(xFilial("SZ2")+Dtos(mv_par01)+Alltrim(cGrp),.T.))
Do  While SZ2->( !Eof() ) .and. SZ2->Z2_Data<=mv_par02

    If  Alltrim(SZ2->Z2_GRUPO)<>Alltrim(cGrp) .OR. (cCCst<>"XXXX" .and. SZ2->Z2_CCUSTO<>cCCst)
        SZ2->(dbSkip())
        Loop
    Endif
    
    nAcumul := nAcumul + SZ2->Z2_VALOR
        
    SZ2->(dbSkip())
    
Enddo                

Return(nAcumul)
