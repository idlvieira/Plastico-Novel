#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02
#INCLUDE "TOPCONN.CH"

User Function BOLFAT()        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02   


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ BOLFAT   ³ Autor ³ Eliene Cerqueira      ³ Data ³ 18.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao do Boletim Diario de Faturamento (pnvfa02)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NTOTIPI,APEDCLI,CSTRING,AVAL,AVTOTAL")
SetPrvt("NVOBTIDO,AVOBTIDO,NDIAS,ASTRU,CARQTRAB")
SetPrvt("CIND,ASTRU2,CARQTRAB2,CMES,CANO,CGERENC")
SetPrvt("DDATAINI,NVALMERC,DEMISSAO,CCODVEN,CCODGER,NVAL")
SetPrvt("CQUERY,ASTRU3,CARQTRAB3,CNOMVEN,M,K")
SetPrvt("W,NCOTAMES,NCOTAINI,NVINI,LVOLTA,NCOTADIA")
SetPrvt("I,Y,CHEADER,CHEADER2,CVEND1,NAJUSTE")
SetPrvt("NVPARCIAL,LCONTINUA,CDSEMANA,LPULOUE,NQTD,_CALIASTEMP")
SetPrvt("_NREGTEMP1,_NREGTEMP2,LACHOU,J,NPERCCOT,G")
SetPrvt("NFIM,NCOTAATE,NVOBTMES,NEFICIENC,")

wnrel            :=""
tamanho          :="G"
titulo           :="Emissao do Boletim Diario de Faturamento"
cDesc1           :="Emiss„o do Boletim Diario de Faturamento, de acordo com"
cDesc2           :="intervalo informado na op‡„o Parƒmetros."
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :="" //  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="PNV002"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog         :="BOLFAT"
nLastKey         :=0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=220
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          :=nTotVal:=0
nTotIPI          :=0
aPedCli          := {}
wnrel            := "BOLFAT"
cString          := "SF2"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte("PNV002",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Mes/Ano         C  6  0               ³
//³ mv_par02              Gerencia        C  4  0               ³
//³ mv_par03              Do Vendedor     C  6  0               ³
//³ mv_par04              Ao Vendedor     C  6  0               ³
//³ mv_par05              Dias Uteis      C  2  0               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint("",wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

#IFDEF WINDOWS
    RptStatus({||C730Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 13/08/02 ==>     RptStatus({||Execute(C730Imp)})
    DbSelectArea("FAT")
    dbCloseArea()
    Return
// Substituido pelo assistente de conversao do AP5 IDE em 13/08/02 ==>     Function C730IMP
Static Function C730IMP()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho        :="G"
titulo         :="EMISSAO DO BOLETIM DIARIO DE FATURAMENTO"
cDesc1         :="Emissao do boletim Diario de Faturmento, de acordo com"
cDesc2         :="os Parƒmetros informados."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :="" //  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""
aVal           :={} // Array com valores para somatorio total
aVTotal        :={} // Array com os totais de cada vendedor
nVObtido       := 0
aVObtido       :={} // Array com os obtidos de cada vendedor (aVtotal[n]/aVCota[n])
pergunte("PNV002",.F.)
nDias          := Val(AllTrim(mv_par05))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSAY AvalImp(Limite)

nCotTot  := 0
cMes     := SubStr(mv_par01,1,2)
cAno     := SubStr(mv_par01,3,4)
cGerenc  := mv_par02
dDataIni := CToD("01/"+cMes+"/"+cAno)
If Val(cMes)<12
   dDataFim:=Ctod("01/"+Strzero(Val(cMes)+1,2)+"/"+Strzero(Val(cAno),4))-1
Else
   dDataFim:=Ctod("01/01/"+Strzero(Val(cAno)+1,4))-1
Endif

cQry := " SELECT SF2.F2_DOC AS DOC, SF2.F2_EMISSAO AS EMISSAO, SF2.F2_VEND1 AS VEND,"
cQry := cQry + " (SELECT SUM(SD2.D2_TOTAL) FROM SD2010 AS SD2, SF4010 AS SF4"
cQry := cQry + " WHERE SD2.D2_DOC=SF2.F2_DOC"
cQry := cQry + " AND SF2.F2_TIPO NOT IN ('D','I')"
cQry := cQry + " AND SD2.D_E_L_E_T_<>'*'"
//cQry := cQry + " AND SUBSTR(SD2.D2_CF,2,3) NOT  IN ('117','201','202','553','556','558','901','902','909','910','911','912','913','914','915','916','918','923')) AS TOTAL FROM SF2010 AS SF2"
cQry := cQry + " AND SD2.D2_TES=SF4.F4_CODIGO"
cQry := cQry + " AND SF4.F4_DUPLIC='S') AS TOTAL FROM SF2010 AS SF2"
cQry := cQry + " WHERE SF2.F2_EMISSAO>='"+DTOS(dDataIni)+"'"
cQry := cQry + " AND SF2.F2_EMISSAO<='"+DTOS(dDataFim)+"'"
cQry := cQry + " AND SF2.F2_VEND1>='"+MV_PAR03+"'"
cQry := cQry + " AND SF2.F2_VEND1<='"+MV_PAR04+"'"
cQry := cQry + " AND SF2.F2_TIPO NOT IN ('D','I')"
cQry := cQry + " AND SF2.D_E_L_E_T_<>'*'"
cQry := cQry + " UNION"
cQry := cQry + " SELECT SF2.F2_DOC AS DOC, SF2.F2_EMISSAO AS EMISSAO, SF2.F2_VEND2 AS VEND,"
cQry := cQry + " (SELECT SUM(SD2.D2_TOTAL) FROM SD2010 AS SD2, SF4010 AS SF4"
cQry := cQry + " WHERE SD2.D2_DOC=SF2.F2_DOC"
cQry := cQry + " AND SF2.F2_TIPO NOT IN ('D','I')"
cQry := cQry + " AND SD2.D_E_L_E_T_<>'*'"
//cQry := cQry + " AND SUBSTR(SD2.D2_CF,2,3) NOT  IN ('117','201','202','553','556','558','901','902','909','910','911','912','913','914','915','916','918','923')) AS TOTAL FROM SF2010 AS SF2"
cQry := cQry + " AND SD2.D2_TES=SF4.F4_CODIGO"
cQry := cQry + " AND SF4.F4_DUPLIC='S') AS TOTAL FROM SF2010 AS SF2"
cQry := cQry + " WHERE SF2.F2_EMISSAO>='"+DTOS(dDataIni)+"'"
cQry := cQry + " AND SF2.F2_EMISSAO<='"+DTOS(dDataFim)+"'"
cQry := cQry + " AND ((SF2.F2_VEND1='999999' AND SF2.F2_VEND2>='"+MV_PAR03+"'" 
cQry := cQry + " AND SF2.F2_VEND2<='"+MV_PAR04+"'"
cQry := cQry + " ) OR (SF2.F2_VEND1<>'999999' AND SF2.F2_VEND2='A00039'))"
//cQry := cQry + " AND SF2.F2_VEND2>='"+MV_PAR03+"'" 
//cQry := cQry + " AND SF2.F2_VEND2<='"+MV_PAR04+"'"
cQry := cQry + " AND SF2.F2_TIPO NOT IN ('D','I')"
cQry := cQry + " AND SF2.D_E_L_E_T_<>'*'"
cQry := cQry + " UNION"
cQry := cQry + " SELECT SZ4.Z4_FILIAL AS DOC, SZ4.Z4_DTCOMP AS EMISSAO, SZ4.Z4_VEND AS VEND, "
cQry := cQry + " SZ4.Z4_VRCOMP AS TOTAL FROM SZ4010 AS SZ4"
cQry := cQry + " WHERE SZ4.Z4_DTCOMP>='"+DTOS(dDataIni)+"'"
cQry := cQry + " AND SZ4.Z4_DTCOMP<='"+DTOS(dDataFim)+"'"
cQry := cQry + " AND SZ4.Z4_VEND>='"+MV_PAR03+"'"
cQry := cQry + " AND SZ4.Z4_VEND<='"+MV_PAR04+"'"
cQry := cQry + " AND SZ4.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY 2, 3"

Tcquery cQry new alias "FAT"

aStru3:={}
AADD( aStru3, {"CODIGO"  ,"C" ,6  ,0} )
AADD( aStru3, {"VENDEDOR","C" ,8  ,0} )
AADD( aStru3, {"ORDEM"   ,"C" ,2  ,0} )
AADD( aStru3, {"VLTOT"   ,"N" ,12 ,2} )
AADD( aStru3, {"VLCOTA"  ,"N" ,12 ,2} )
cArqTrb1:=CriaTrab(aStru3,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb1,"VENDEDOR",.F.)
IndRegua("VENDEDOR",cArqTrb1,"CODIGO")

COTAVEND:=0
DbSelectArea("SA3")
DbSetOrder(1)
DbGoTop()
While !EOF()
  If (SA3->A3_COD < mv_par03) .And. !EOF()
     dbSkip()
     Loop
  EndIf
  If (SA3->A3_COD > mv_par04) .And. !EOF()
     dbSkip()
     Loop
  EndIf
  DbSelectArea("SZ5")
  DbSetOrder(1) //Z5_MES+Z5_VEND+Z5_GEREN
  DbSeek(xFilial("SZ5")+mv_par01+SA3->A3_COD+mv_par02,.T.)
  If !Found()
     dbSelectArea("SA3")
     DbSkip()
     Loop
  EndIf
  DbSelectArea("VENDEDOR")
  RecLock("VENDEDOR",.T.)
    VENDEDOR->CODIGO   := SA3->A3_COD
    VENDEDOR->VENDEDOR := SubStr(SA3->A3_NREDUZ,1,8)
    VENDEDOR->VLCOTA   := SZ5->Z5_VLCOTA
  MSUnlock()
  COTAVEND:=COTAVEND+SZ5->Z5_VLCOTA
  DbSelectArea("SA3")
  DbSkip()
End
//
DbSelectArea("VENDEDOR")
QTDVEND:=RecCount()
DbGoTop()           
I:=1
While !EOF()
  RecLock("VENDEDOR",.F.)
    VENDEDOR->ORDEM    := STRZERO(I,2)
  MSUnlock()
  I:=I+1
  DbSkip()
End
//
nCotaMes:=0 
nCotaini:=0
DbSelectArea("SZ6")
DbSetOrder(1)
DbSeek(xFilial("SZ6")+mv_par02+mv_par01,.t.)
If Found()
   nCotaMes := Val(AllTrim(Str(SZ6->Z6_VLCOTAG)))
   nCotaIni := nCotaMes/nDias  
EndIf

aStru:={}
AADD( aStru, {"EMISSAO" ,"D" ,8  ,0} )
For I:=1 to QTDVEND
    campo:="VLVEND"+strzero(I,2)
    AADD( aStru, {campo ,"N" ,12 ,2} )
Next
AADD( aStru, {"VLTOT"   ,"N" ,12 ,2} )
AADD( aStru, {"VLCTDIA" ,"N" ,12 ,2} )
cArqTrb2:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb2,"MATRIZ",.F.)
IndRegua("MATRIZ",cArqTrb2,"DTOS(MATRIZ->EMISSAO)")

DbSelectArea("FAT")
SetRegua(RecCount())
DbGoTop()           
TOTDIA:=0
COTADIA:=0
While FAT->( !Eof() )
   IncRegua()
   XEMISSAO:=FAT->EMISSAO
   DbSelectArea("MATRIZ")
   RecLock("MATRIZ",.T.)
     MATRIZ->EMISSAO := CTOD(SUBSTR(FAT->EMISSAO,7,2)+"/"+SUBSTR(FAT->EMISSAO,5,2)+"/"+SUBSTR(FAT->EMISSAO,1,4))
   MSUnlock()
   DbSelectArea("FAT")
   DO While FAT->( !Eof() ) .AND. FAT->EMISSAO=XEMISSAO 
      XVEND:=FAT->VEND
      DbSelectArea("VENDEDOR")
      DbSeek(FAT->VEND,.F.)
      If !Found()
         DbSelectArea("FAT")
         DbSkip()
         Loop
      Endif
      campo:="VLVEND"+VENDEDOR->ORDEM
      XVLVEND:=0
      DbSelectArea("FAT")
      DO While FAT->( !Eof() ) .AND. FAT->VEND=XVEND .AND. FAT->EMISSAO=XEMISSAO 
         XVLVEND:=XVLVEND+FAT->TOTAL
         DbSkip()
      End
      RecLock("MATRIZ",.F.)
        &campo := XVLVEND
      MSUnlock()

      RecLock("VENDEDOR",.F.)
        VENDEDOR->VLTOT := VENDEDOR->VLTOT+XVLVEND
      MSUnlock()

      TOTDIA:=TOTDIA+XVLVEND
   END
   COTADIA:=COTADIA+(COTAVEND/nDias)
   RecLock("MATRIZ",.F.)
     VLTOT   := TOTDIA
     VLCTDIA := COTADIA
   MSUnlock()
END

DbSelectArea("MATRIZ")
SetRegua(RecCount())
DbGoTop()
If !Eof()
   li := 0
   SetPrc(0,0)
   ImpCabec()
   li:=li+1
   lRodape:=.T.
Endif
DbSelectArea("MATRIZ")
While !Eof()
    IncRegua()
	IF LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	cDSemana:=""
	Do Case
	   Case DOW(EMISSAO)==1
	        cDSemana:="Dom"
	   Case DOW(EMISSAO)==2
	        cDSemana:="Seg"
	   Case DOW(EMISSAO)==3
	        cDSemana:="Ter"
	   Case DOW(EMISSAO)==4
	        cDSemana:="Qua"
	   Case DOW(EMISSAO)==5
	        cDSemana:="Qui"
	   Case DOW(EMISSAO)==6
	        cDSemana:="Sex"
	   Case DOW(EMISSAO)==7
	        cDSemana:="Sab"
	EndCase

	@li,000 PSAY Day(EMISSAO) PICTURE "@R 99"
	@li,003 PSAY cDSemana
	@li,007 PSAY "|" 
    nAjuste:=0
    For I:=1 to QTDVEND
       campo:="VLVEND"+strzero(I,2)
       @ li,PCol()+1 PSAY &campo Picture "@E 999,999,999"
       @ li,PCol()+1 PSAY "|"
    Next
    @ li,PCol()+1 PSAY VLTOT   Picture "@E 99,999,999"
    @ li,PCol()+1 PSAY "|"
    @ li,PCol()+1 PSAY VLCTDIA Picture "@E 99,999,999"
    @ li,PCol()+1 PSAY "|"
    @ li,PCol()+1 PSAY (VLTOT/VLCTDIA)*100   Picture "@E 999.99"
    @ li,PCol()+1 PSAY "|"
    li:=li+1
    DbSkip()
End

IF lRodape
   li := 58                
   ImpRodape()
   lRodape:=.F.
   li:=li+5
Endif             

// Atualiza o campo Z6_OBTMES conforme o relatorio

DbSelectArea("SZ6")
DbSetOrder(1) // Gerenc + MesAno
DbSeek(xFilial("SZ6")+mv_par02+mv_par01,.t.)
If Found()
   RecLock("SZ6",.F.)
   Replace SZ6->Z6_OBTMES with nVObtido
   MSUnlock()
EndIf

// Fechamento do programa

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

dbSelectArea("VENDEDOR")
dbCloseArea()
If !Empty( cArqTrb1 )
   FErase( cArqTrb1+".*")
Endif
dbSelectArea("MATRIZ")
dbCloseArea()
If !Empty( cArqTrb2 )
   FErase( cArqTrb2+".*")
Endif

MS_FLUSH()

Static Function ImpCabec()
	@ li, 000 PSAY CHR(15)
	lRodape     := .T.
	li:=li+1
	@ li,000 PSAY Replicate("-",limite)
	li := li+1
	@ li,000 PSAY SM0->M0_NOMECOM
	li := li+1                                                                   
	@ li,000 PSAY "BOLETIM DIARIO DE FATURAMENTO        GERENCIA: GVEN      MES: "
	@ li,062 PSAY SubStr(mv_par01,1,2)+"/"+SubStr(mv_par01,3,4)
	@ li,075 PSAY "IMPRESSO EM"
	@ li,088 PSAY SubStr(Dtos(Date()),7,2)+"/"+SubStr(Dtos(Date()),5,2)+"/"+SubStr(Dtos(Date()),1,4)
	li := li+1
	@ li,000 PSAY Replicate("-",limite)
	li := li+1
	@ li,000 PSAY "       |"
	DbSelectArea("VENDEDOR")
    DbGoTop()           
	While !EOF()
	  @ li,PCol()+1 PSAY VENDEDOR->VENDEDOR+"    |"
	  DbSkip()
	End
	@ li,PCol() PSAY "            |            |        |"
	li := li+1
	@ li,000 PSAY "  DIA  |"
    DbGoTop()           
	nAjuste:=0
	While !EOF()
	  @ li,PCol()+1 PSAY VENDEDOR->CODIGO+"      |"
	  DbSkip()
	End
	@ li,PCol() PSAY "     TOTAL  |      COTA  |    %   |"
	li:=li+1
	@ li,000 PSAY Replicate("-",limite)
	li:=li+1

Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02

Static Function ImpRodape()
	@ li,000 PSAY Replicate("-",limite)
	li:=li+1
	@ li,000 PSAY "TOTAL"
	@ li,007 PSAY "|"                     
	XOBTMES:=0
	DbSelectArea("VENDEDOR")
    DbGoTop()           
	While !EOF()
   	  XOBTMES:=XOBTMES+VLTOT
      @ li,PCol()+1 PSAY VLTOT   Picture "@E 999,999,999"
   	  @ li,PCol()+1 PSAY "|"
	  DbSkip()
	End
	@ li,PCol()+1 PSAY "COTA MES..:"
    @ li,PCol()+1 PSAY nCotaMes Picture "@E 999,999,999.99"
	li:=li+1
	@ li,000 PSAY "COTA"
	@ li,007 PSAY "|"
	DbSelectArea("VENDEDOR")
    DbGoTop()           
	While !EOF()
      @ li,PCol()+1 PSAY VLCOTA   Picture "@E 999,999,999"
   	  @ li,PCol()+1 PSAY "|"
	  DbSkip()
	End
	@ li,PCol()+1 PSAY "OBTIDO MES:"
  	@ li,PCol()+2 PSAY XOBTMES Picture "@E 999,999,999.99"
	li:=li+1
	@ li,000 PSAY "OBTIDO%"
	@ li,007 PSAY "|"
	DbSelectArea("VENDEDOR")
    DbGoTop()           
	While !EOF()
      @ li,PCol()+1 PSAY (VLTOT/VLCOTA)*100   Picture "@E 999,999,999
   	  @ li,PCol()+1 PSAY "|"
	  DbSkip()
	End
	@ li,PCol()+1 PSAY "EFICIENCIA:"
  	@ li,PCol()+2 PSAY (XOBTMES/NCOTAMES)*100 Picture "@E 999,999,999.99"
	li:=li+1
	@ li,000 PSAY Replicate("-",limite)
	li:=li+2
	@ li,000 PSAY "."            
	li:=li+1 
	@ li,000 PSAY chr(18)
// Substituido pelo assistente de conversao do AP5 IDE em 13/08/02 ==> __Return( NIL )
Return( NIL )        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02
