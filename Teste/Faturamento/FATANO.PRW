#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"

User Function FATANO()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ FATANO   ³ Autor ³ Eliene Cerqueira      ³ Data ³ 31.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Comparativo de vendas por cliente entre 2 anos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

titulo := "Vendas ano X ano"
cDesc1 := "Este relatorio emite a relacao dos clientes com maior "
cDesc2 := " faturamento, comparando entre dois anos."
cDesc3 := "Se no TES estiver gera duplicata (N), nao sera computado."                                            
cabec1 := " CODIGO      RAZAO SOCIAL                                              [ANO1]         [ANO2]           VARIACAO %"
cabec2 := ""
tamanho:="M"
limite :=132
cString:="SF2"
cPerg  :="FATANO"

PRIVATE aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nomeprog:="FATANO"
PRIVATE aLinha  := { },nLastKey := 0
cArqTrb1:=""
cbtxt    := SPACE(10)
li       := 80
m_pag    := 01

// Criar arquivo de Perguntas
//GRAV_1SX()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Execute(GRAV_1SX)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01       	// Ano1                     		         ³
//³ mv_par02       	// Ano2      						 	     ³
//³ mv_par03       	// Valor Minimo                              ³
//³ mv_par04        // Vendedor                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "FATANO"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C590Imp(@lEnd,wnRel,cString)},Titulo)
DbSelectArea("FAT1")
dbCloseArea()
DbSelectArea("FAT2")
dbCloseArea()
If !Empty( cArqTrb1 )
   dbSelectArea("TRAB")
   dbCloseArea()
   FErase( cArqTrb1+".*")
Endif
Return

// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==>     Function C730IMP
Static Function C590IMP()

aStru1:={}
AADD( aStru1, {"VENDEDOR","C" ,6  ,0} )
AADD( aStru1, {"NOMEVEND","C" ,30 ,0} )
AADD( aStru1, {"CLIENTE" ,"C" ,6  ,0} )
AADD( aStru1, {"LOJA"    ,"C" ,2  ,0} )
AADD( aStru1, {"NOME"    ,"C" ,50 ,0} )
AADD( aStru1, {"VALOR1"  ,"N" ,12 ,2} )
AADD( aStru1, {"VALOR2"  ,"N" ,12 ,2} )
cArqTrb1:=CriaTrab(aStru1,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb1,"TRAB",.F.)
IndRegua("TRAB",cArqTrb1,"VENDEDOR+CLIENTE")

WdataI:=Ctod("01/01/"+mv_par01)
WdataF:=Ctod("31/12/"+mv_par01)

cQry := "SELECT DISTINCT SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NOME, SA1.A1_REGIAO, SUM(SD2.D2_TOTAL) AS TOTAL,"
cQry := cQry + " SUM(SD2.D2_VALICM) AS ICMS, SUM(SD2.D2_VALIPI) AS IPI"
cQry := cQry + " FROM SD2010 AS SD2, SF2010 AS SF2, SA1010 AS SA1, SF4010 AS SF4"
cQry := cQry + " WHERE SD2.D2_DOC = SF2.F2_DOC"
cQry := cQry + " AND SF2.F2_EMISSAO>='"+DTOS(WdataI)+"'"
cQry := cQry + " AND SF2.F2_EMISSAO<='"+DTOS(WdataF)+"'"
cQry := cQry + " AND SF2.F2_CLIENTE=SA1.A1_COD"
cQry := cQry + " AND SF2.F2_TIPO NOT IN ('D','I')"
cQry := cQry + " AND SD2.D2_TES=SF4.F4_CODIGO"
cQry := cQry + " AND SF4.F4_DUPLIC='S'"
cQry := cQry + " AND SF2.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SD2.D_E_L_E_T_<>'*'"
cQry := cQry + " GROUP BY SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NOME, SA1.A1_REGIAO"
Tcquery cQry new alias "FAT1"

WdataI:=Ctod("01/01/"+mv_par02)
WdataF:=Ctod("31/12/"+mv_par02)

cQry := "SELECT DISTINCT SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NOME, SA1.A1_REGIAO, SUM(SD2.D2_TOTAL) AS TOTAL,"
cQry := cQry + " SUM(SD2.D2_VALICM) AS ICMS, SUM(SD2.D2_VALIPI) AS IPI"
cQry := cQry + " FROM SD2010 AS SD2, SF2010 AS SF2, SA1010 AS SA1, SF4010 AS SF4"
cQry := cQry + " WHERE SD2.D2_DOC = SF2.F2_DOC"
cQry := cQry + " AND SF2.F2_EMISSAO>='"+DTOS(WdataI)+"'"
cQry := cQry + " AND SF2.F2_EMISSAO<='"+DTOS(WdataF)+"'"
cQry := cQry + " AND SF2.F2_CLIENTE=SA1.A1_COD"
cQry := cQry + " AND SF2.F2_TIPO NOT IN ('D','I')"
cQry := cQry + " AND SD2.D2_TES=SF4.F4_CODIGO"
cQry := cQry + " AND SF4.F4_DUPLIC='S'"
cQry := cQry + " AND SF2.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SD2.D_E_L_E_T_<>'*'"
cQry := cQry + " GROUP BY SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NOME, SA1.A1_REGIAO"
Tcquery cQry new alias "FAT2"

aVend := {}
AADD( aVend, {SPACE(3),SPACE(6),"CLIENTES SEM REGIAO"} )
DbSelectArea("SA3")
DbSetOrder(1)
DbGoTop()           
Do While !Eof()
   If A3_REGIAO<>"   "
      AADD( aVend, {A3_REGIAO,A3_COD,A3_NOME} )
   Endif
   Skip()
Enddo

dbSelectArea("FAT1")
Do While !Eof()   
   If FAT1->TOTAL < mv_par03
      Skip()
      Loop
   Endif
//   I:=aScan(aVend,FAT1->A1_REGIAO)
   I:=0
   For J:=1 to Len(aVend)
      If aVend[J,1]=FAT1->A1_REGIAO
         I:=J
      Endif
   Next
   If mv_par04 <> SPACE(6) .and. mv_par04<>aVend[I,2]
      Skip()
      Loop
   Endif
   DbSelectArea("TRAB")
   RecLock("TRAB",.T.)
     TRAB->VENDEDOR:=aVend[I,2]
     TRAB->NOMEVEND:=aVend[I,3]
     TRAB->CLIENTE :=FAT1->F2_CLIENTE
     TRAB->LOJA    :=FAT1->F2_LOJA
     TRAB->NOME    :=FAT1->A1_NOME
     TRAB->VALOR1  :=FAT1->TOTAL
   MSUnlock()
   DbSelectArea("FAT1")
   Skip()
Enddo

dbSelectArea("FAT2")
Do While !Eof()   
   If FAT2->TOTAL < mv_par03
      Skip()
      Loop
   Endif
//   I:=aScan(aVend,FAT1->A1_REGIAO)
   I:=0
   For J:=1 to Len(aVend)
      If aVend[J,1]=FAT2->A1_REGIAO
         I:=J
      Endif
   Next
   If mv_par04 <> SPACE(6) .and. mv_par04<>aVend[I,2]
      Skip()
      Loop
   Endif
   DbSelectArea("TRAB")
   If dbSeek(aVend[I,2]+FAT2->F2_CLIENTE,.F.)
      Reclock("TRAB",.F.)
   Else
     Reclock("TRAB",.T.)
     TRAB->VENDEDOR:=aVend[I,2]
     TRAB->NOMEVEND:=aVend[I,3]
     TRAB->CLIENTE :=FAT2->F2_CLIENTE
     TRAB->LOJA    :=FAT2->F2_LOJA
     TRAB->NOME    :=FAT2->A1_NOME
   Endif
   TRAB->VALOR2  :=FAT2->TOTAL
   MSUnlock()
   DbSelectArea("FAT2")
   Skip()
Enddo

DbSelectArea("TRAB")
IndRegua("TRAB",cArqTrb1,"VENDEDOR+StrZero(1000000000000 - VALOR1,18)")
DbGoTop()      
SetRegua(RecCount())  

nTipo:=IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))
xvend:="ZZZZZZ"   
TOT1:=TOT2:=0
titulo := "Relatorio de Vendas "+mv_par01+" X "+mv_par02
cabec1 := " CODIGO      RAZAO SOCIAL                                                     "+mv_par01+Space(12)+mv_par02+"           VARIACAO %"
li := 76
While TRAB->( !Eof() )
   IncRegua()
   If lEnd
  	  @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
	  Exit
   Endif
	
   If xVend<>TRAB->VENDEDOR
      If xvend<>"ZZZZZZ"
         li:=li+1
         @ li,013      PSAY "TOTAL"
         @ li,070      PSAY TOT1 Picture "@E 999,999,999.99"
         @ li,PCOL()+2 PSAY TOT2 Picture "@E 999,999,999.99"
         @ li,PCOL()+8 PSAY (TOT2-TOT1)/TOT1*100 Picture "@E 99 999.99"
         li:=li+1
         TOT1:=TOT2:=0
         @ li,000 PSAY Replicate("-",Limite)
         li:=li+1
      Endif
	  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
      @ li, 001      PSAY TRAB->VENDEDOR+" - "+TRAB->NOMEVEND
      xVend=TRAB->VENDEDOR
      li:=li+2
   Endif
   If li > 75
	  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
   Endif
	
   @ li, 001      PSAY TRAB->CLIENTE+"-"+TRAB->LOJA
   @ li, PCOL()+3 PSAY TRAB->NOME
   @ li, PCOL()+7 PSAY TRAB->VALOR1 Picture "@E 999,999,999.99"
   @ li, PCOL()+2 PSAY TRAB->VALOR2 Picture "@E 999,999,999.99"
   @ li, PCOL()+8 PSAY (TRAB->VALOR2-TRAB->VALOR1)/TRAB->VALOR1*100 Picture "@E 99 999.99"
   li:=li+1
   TOT1:=TOT1+TRAB->VALOR1
   TOT2:=TOT2+TRAB->VALOR2
   TRAB->(dbSkip())
End
li:=li+1
@ li,000 PSAY Replicate("-",Limite)
li:=li+1
@ li,000 PSAY chr(18)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function GRAV_1SX()
   _cAlias:=Select()
   _cSX1:={}
   Aadd(_cSX1,{cPerg,"01","Ano 1             ?","MV_CH1", "C",0, 4,0,"G","","MV_PAR01","","","",""})
   Aadd(_cSX1,{cPerg,"02","Ano 2             ?","MV_CH2", "C",0, 4,0,"G","","MV_PAR02","","","",""})
   Aadd(_cSX1,{cPerg,"03","Valor Minimo      ?","MV_CH3", "N",0,10,2,"G","","MV_PAR03","","","",""})
   Aadd(_cSX1,{cPerg,"04","Vendedor          ?","MV_CH4", "C",0, 6,0,"G","","MV_PAR04","","","","SA3"})
   For S := 1 To Len(_cSX1)
       dbSelectArea("SX1")
       dbSetOrder(1)
       dbSeek(cPerg+Strzero(S,2),.T.)
       If ! Found()
          RecLock("SX1",.T.)
          Replace X1_GRUPO         WITH _cSX1[S,1]
          Replace X1_ORDEM         WITH _cSX1[S,2]
          Replace X1_PERGUNT       WITH _cSX1[S,3]
          Replace X1_VARIAVL       WITH _cSX1[S,4]
          Replace X1_TIPO          WITH _cSX1[S,5]
          Replace X1_PRESEL        WITH _cSX1[S,6]
          Replace X1_TAMANHO       WITH _cSX1[S,7]
          Replace X1_DECIMAL       WITH _cSX1[S,8]
          Replace X1_GSC           WITH _cSX1[S,9]
          Replace X1_VALID         WITH _cSX1[S,10]
          Replace X1_VAR01         WITH _cSX1[S,11]
          Replace X1_DEF01         WITH _cSX1[S,12]
          Replace X1_DEF02         WITH _cSX1[S,13]
          Replace X1_DEF03         WITH _cSX1[S,14]
          Replace X1_F3            WITH _cSX1[S,15]
          MSUnlock()
       Endif
   Next
   dbSelectArea(_cAlias)
Return
