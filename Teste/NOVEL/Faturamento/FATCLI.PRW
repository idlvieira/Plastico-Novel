#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"

User Function FATCLI()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ FATCLI   ³ Autor ³ Eliene Cerqueira      ³ Data ³ 08.11.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faturamento por cliente                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

titulo := "Faturamento por Cliente"
cDesc1 := "Este relatorio emite a relacao de faturamento. Podera ser"
cDesc2 := "emitido por ordem de Cliente ou por Valor (Ranking).     "
cDesc3 := "Se no TES estiver gera duplicata (N), nao sera computado."
cabec1 := " CODIGO      RAZAO SOCIAL                                           FATURAMENTO       VALOR DA         VALOR"
cabec2 := "                                                                      SEM ICM        MERCADORIA        TOTAL"
tamanho:="M"
limite :=132
cString:="SF2"

PRIVATE aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nomeprog:="FATCLI"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="MTR590"
cArqTrb1:=""
cbtxt    := SPACE(10)
li       := 80
m_pag    := 01

pergunte("MTR590",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01       	// Data de                  		         ³
//³ mv_par02       	// Data ate  						 	     ³
//³ mv_par03       	// Cliente de                                ³
//³ mv_par04        // Cliente ate                               ³
//³ mv_par05        // Estado de                                 ³
//³ mv_par06        // Estado ate                                ³
//³ mv_par07        // Cliente  Valor  Estado                    ³
//³ mv_par08        // Moeda                                     ³
//³ mv_par09        // Devolucao  (SIM / NAO)	                 ³
//³ mv_par10        // Duplicatas (SIM / NAO / S e N)            ³
//³ mv_par11        // Estoque    (SIM / NAO / S e N)            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "FATCLI"
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
DbSelectArea("FATC")
dbCloseArea()
If !Empty( cArqTrb1 )
   dbSelectArea("TRAB")
   dbCloseArea()
   FErase( cArqTrb1+".*")
Endif
If mv_par09 = 1
   DbSelectArea("DEVC")
   dbCloseArea()
Endif
Return

// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==>     Function C730IMP
Static Function C590IMP()

aStru1:={}
AADD( aStru1, {"CLIENTE" ,"C" ,6  ,0} )
AADD( aStru1, {"LOJA"    ,"C" ,2  ,0} )
AADD( aStru1, {"NOME"    ,"C" ,50 ,0} )
AADD( aStru1, {"EST"     ,"C" ,2  ,0} )
AADD( aStru1, {"VALOR1"  ,"N" ,12 ,2} )
AADD( aStru1, {"VALOR2"  ,"N" ,12 ,2} )
AADD( aStru1, {"VALOR3"  ,"N" ,12 ,2} )
AADD( aStru1, {"VALOR4"  ,"N" ,12 ,2} )
AADD( aStru1, {"VALOR5"  ,"N" ,12 ,2} )
AADD( aStru1, {"VALOR6"  ,"N" ,12 ,2} )
cArqTrb1:=CriaTrab(aStru1,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb1,"TRAB",.F.)
If mv_par07 = 1
   IndRegua("TRAB",cArqTrb1,"CLIENTE+LOJA")
ElseIf mv_par07 = 2
   IndRegua("TRAB",cArqTrb1,"StrZero(1000000000000 - VALOR3 + VALOR6,18)")
ElseIf mv_par07 = 3
   IndRegua("TRAB",cArqTrb1,"EST+CLIENTE+LOJA")
Endif

cQry := "SELECT DISTINCT SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NOME, SA1.A1_EST, SUM(SD2.D2_TOTAL) AS TOTAL,"
cQry := cQry + " SUM(SD2.D2_VALICM) AS ICMS, SUM(SD2.D2_VALIPI) AS IPI"
cQry := cQry + " FROM SD2010 AS SD2, SF2010 AS SF2, SA1010 AS SA1, SF4010 AS SF4"
cQry := cQry + " WHERE SD2.D2_DOC = SF2.F2_DOC"
cQry := cQry + " AND SF2.F2_EMISSAO>='"+DTOS(mv_par01)+"'"
cQry := cQry + " AND SF2.F2_EMISSAO<='"+DTOS(mv_par02)+"'"
cQry := cQry + " AND SF2.F2_CLIENTE>='"+mv_par03+"'"
cQry := cQry + " AND SF2.F2_CLIENTE<='"+mv_par04+"'"
cQry := cQry + " AND SF2.F2_CLIENTE=SA1.A1_COD"
cQry := cQry + " AND SA1.A1_EST>='"+mv_par05+"'"
cQry := cQry + " AND SA1.A1_EST<='"+mv_par06+"'"
cQry := cQry + " AND SF2.F2_TIPO NOT IN ('D','I')"
//cQry := cQry + " AND SUBSTR(SD2.D2_CF,2,3) NOT  IN ('117','201','202','553','556','558','901','902','908','909','910','911','912','913','914','915','916','918','923')"
cQry := cQry + " AND SD2.D2_TES=SF4.F4_CODIGO"
If mv_par10 = 1
   cQry := cQry + " AND SF4.F4_DUPLIC='S'"
ElseIf mv_par10 = 2
   cQry := cQry + " AND SF4.F4_DUPLIC='N'"
Endif
If mv_par11 = 1
   cQry := cQry + " AND SF4.F4_ESTOQUE='S'"
ElseIf mv_par10 = 2
   cQry := cQry + " AND SF4.F4_ESTOQUE='N'"
Endif
cQry := cQry + " AND SF2.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SD2.D_E_L_E_T_<>'*'"
cQry := cQry + " GROUP BY SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NOME, SA1.A1_EST"
Tcquery cQry new alias "FATC"

dbSelectArea("FATC")
Do While !Eof()   
   DbSelectArea("TRAB")
   RecLock("TRAB",.T.)
     TRAB->CLIENTE :=FATC->F2_CLIENTE
     TRAB->LOJA    :=FATC->F2_LOJA
     TRAB->NOME    :=FATC->A1_NOME
     TRAB->EST     :=FATC->A1_EST
     TRAB->VALOR1  :=FATC->TOTAL-FATC->ICMS
     TRAB->VALOR2  :=FATC->TOTAL
     TRAB->VALOR3  :=FATC->TOTAL+FATC->IPI
   MSUnlock()
   DbSelectArea("FATC")
   Skip()
Enddo

If mv_par09 = 1
   cQry := "SELECT DISTINCT SF1.F1_FORNECE, SF1.F1_LOJA, SA1.A1_NOME, SA1.A1_EST, SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) AS TOTAL,"
   cQry := cQry + " SUM(SD1.D1_VALICM) AS ICMS, SUM(SD1.D1_VALIPI) AS IPI"
   cQry := cQry + " FROM SD1010 AS SD1, SF1010 AS SF1, SA1010 AS SA1, SF4010 AS SF4"
   cQry := cQry + " WHERE SD1.D1_DOC = SF1.F1_DOC"
   cQry := cQry + " AND SF1.F1_DTDIGIT>='"+DTOS(mv_par01)+"'"
   cQry := cQry + " AND SF1.F1_DTDIGIT<='"+DTOS(mv_par02)+"'"
   cQry := cQry + " AND SF1.F1_FORNECE>='"+mv_par03+"'"
   cQry := cQry + " AND SF1.F1_FORNECE<='"+mv_par04+"'"
   cQry := cQry + " AND SF1.F1_FORNECE=SA1.A1_COD"
   cQry := cQry + " AND SA1.A1_EST>='"+mv_par05+"'"
   cQry := cQry + " AND SA1.A1_EST<='"+mv_par06+"'"
   cQry := cQry + " AND SF1.F1_TIPO='D'"
   cQry := cQry + " AND SD1.D1_TES=SF4.F4_CODIGO"
   If mv_par10 = 1
      cQry := cQry + " AND SF4.F4_DUPLIC='S'"
   ElseIf mv_par10 = 2
      cQry := cQry + " AND SF4.F4_DUPLIC='N'"
   Endif
   If mv_par11 = 1
      cQry := cQry + " AND SF4.F4_ESTOQUE='S'"
   ElseIf mv_par10 = 2
      cQry := cQry + " AND SF4.F4_ESTOQUE='N'"
   Endif
   cQry := cQry + " AND SF1.D_E_L_E_T_<>'*'"
   cQry := cQry + " AND SD1.D_E_L_E_T_<>'*'"
   cQry := cQry + " GROUP BY SF1.F1_FORNECE, SF1.F1_LOJA, SA1.A1_NOME, SA1.A1_EST"
   Tcquery cQry new alias "DEVC"

   dbSelectArea("DEVC")
   Do While !Eof()   
      DbSelectArea("TRAB")
      If dbSeek(DEVC->F1_FORNECE+DEVC->F1_LOJA,.F.)
         Reclock("TRAB",.F.)
      Else
         Reclock("TRAB",.T.)
         TRAB->CLIENTE :=DEVC->F1_FORNECE
         TRAB->LOJA    :=DEVC->F1_LOJA
         TRAB->NOME    :=DEVC->A1_NOME
         TRAB->EST     :=DEVC->A1_EST
      Endif
      TRAB->VALOR4  :=DEVC->TOTAL-DEVC->ICMS
      TRAB->VALOR5  :=DEVC->TOTAL
      TRAB->VALOR6  :=DEVC->TOTAL+DEVC->IPI
      MSUnlock()
      DbSelectArea("DEVC")
      Skip()
   Enddo
Endif

nTipo:=IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

IF mv_par07 = 1
	titulo := "FATURAMENTO POR CLIENTE  (CODIGO)"
ElseIf mv_par07 == 2
	titulo := "FATURAMENTO POR CLIENTE  (RANKING)"
    cabec1 := " CODIGO      RAZAO SOCIAL                                           FATURAMENTO       VALOR DA         VALOR       RANKING"
Else
	titulo := "FATURAMENTO POR CLIENTE  (ESTADO)"
EndIF
nTotV1:=nTotV2:=nTotV3:=nTotV4:=nTotV5:=nTotV6:=0
cEst:=''
nEstV1:=nEstV2:=nEstV3:=nEstV4:=nEstV5:=nEstV6:=0
li:=65
rank:=1
DbSelectArea("TRAB")
SetRegua(RecCount())
DbGoTop()           
While TRAB->( !Eof() )
   IncRegua()
   If lEnd
  	  @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
	  Exit
   Endif
	
   If li > 55
	  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
   Endif
	
   If mv_par07 == 3
      If Empty(cEst)
		 cEst := TRAB->EST
 	     @ li,00 PSAY "Estado: " + cEst
	     li++
	  ElseIf cEst != TRAB->EST
	 	 li++
		 @li, 00       PSAY "Total do Estado de " + cEst + "--->"
		 @li,PCOL()+50 PSAY nEstV1		Picture "@E 999,999,999.99"
		 @li,PCOL()+2  PSAY nEstV2		Picture "@E 999,999,999.99"
		 @li,PCOL()+2  PSAY nEstV3		Picture "@E 999,999,999.99"
			
		 If nEstv4+nEstv5+nEstv6!=0
			li++
			@li, 66       PSAY nEstV4		Picture "@E) 99,999,999.99"
			@li,PCOL()+2  PSAY nEstV5		Picture "@E) 99,999,999.99"
			@li,PCOL()+2  PSAY nEstV6		Picture "@E) 99,999,999.99"
			@li,PCOL()+10 PSAY "DEV"
		 Endif
			
		 cEst := TRAB->EST
		 nEstV1:=nEstV2:=nEstV3:=nEstV4:=nEstV5:=nEstV6:=0
		 li++
		 li++
 	     @ li,00 PSAY "Estado: " + cEst
	     li++
	  EndIf
   EndIf

   @ li, 001      PSAY TRAB->CLIENTE+"-"+TRAB->LOJA
   @ li, PCOL()+3 PSAY TRAB->NOME
   @ li, PCOL()+2 PSAY TRAB->VALOR1 Picture "@E 999,999,999.99"
   @ li, PCOL()+2 PSAY TRAB->VALOR2 Picture "@E 999,999,999.99"
   @ li, PCOL()+2 PSAY TRAB->VALOR3 Picture "@E 999,999,999.99"
   If mv_par07 == 2
     @ li, PCOL()+4 PSAY StrZero(rank,4)
     rank:=rank+1
   Endif
   li:=li+1
   If TRAB->VALOR4+TRAB->VALOR5+TRAB->VALOR6<>0
      @li, 66       PSAY TRAB->VALOR4*-1  PICTURE "@E) 99,999,999.99"
      @li,PCOL()+2  PSAY TRAB->VALOR5*-1  PICTURE "@E) 99,999,999.99"
      @li,PCOL()+2  PSAY TRAB->VALOR6*-1  PICTURE "@E) 99,999,999.99"
	  @li,PCOL()+10 PSAY "DEV"
      li:=li+1
   Endif
   nEstV1:=nEstV1+TRAB->VALOR1
   nEstV2:=nEstV2+TRAB->VALOR2
   nEstV3:=nEstV3+TRAB->VALOR3
   nEstV4:=nEstV4+(TRAB->VALOR4*-1)
   nEstV5:=nEstV5+(TRAB->VALOR5*-1)
   nEstV5:=nEstV5+(TRAB->VALOR6*-1)
   nTotV1:=nTotV1+TRAB->VALOR1
   nTotV2:=nTotV2+TRAB->VALOR2
   nTotV3:=nTotV3+TRAB->VALOR3
   nTotV4:=nTotV4+(TRAB->VALOR4*-1)
   nTotV5:=nTotV5+(TRAB->VALOR5*-1)
   nTotV6:=nTotV6+(TRAB->VALOR6*-1)
   TRAB->(dbSkip())
End

If mv_par07 == 3 .and. nEstV1+nEstV2+nEstV3+nEstV4+nEstV5+nEstV6<>0
   li++
   @li, 00       PSAY "Total do Estado de " + cEst + "--->"
   @li,PCOL()+50 PSAY nEstV1		Picture "@E 999,999,999.99"
   @li,PCOL()+2  PSAY nEstV2		Picture "@E 999,999,999.99"
   @li,PCOL()+2  PSAY nEstV3		Picture "@E 999,999,999.99"
			
   If nEstv4+nEstv5+nEstv6!=0
      li++
	  @li, 66       PSAY nEstV4		Picture "@E) 99,999,999.99"
	  @li,PCOL()+2  PSAY nEstV5		Picture "@E) 99,999,999.99"
	  @li,PCOL()+2  PSAY nEstV6		Picture "@E) 99,999,999.99"
	  @li,PCOL()+10 PSAY "DEV"
   Endif
EndIf

li:=li+1
@ li,000 PSAY Replicate("-",Limite)
li:=li+1

@ li,000       PSAY " TOTAL --->"
@ li,PCOL()+54 PSAY nTotV1 Picture "@E 999,999,999.99"
@ li,PCOL()+2  PSAY nTotV2 Picture "@E 999,999,999.99"
@ li,PCOL()+2  PSAY nTotV3 Picture "@E 999,999,999.99"
If nTotV4+nTotV5+nTotV6!=0
   li++
   @li, 66       PSAY nTotV4		Picture "@E) 99,999,999.99"
   @li,PCOL()+2  PSAY nTotV5		Picture "@E) 99,999,999.99"
   @li,PCOL()+2  PSAY nTotV6		Picture "@E) 99,999,999.99"
   @li,PCOL()+10 PSAY "DEV"
Endif
li:=li+1
@ li,000 PSAY Replicate("-",Limite)
li:=li+5
@ li,000 PSAY chr(18)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return