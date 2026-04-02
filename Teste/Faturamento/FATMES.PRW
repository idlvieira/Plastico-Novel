#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"

User Function FATMES()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ FATMES   ³ Autor ³ Eliene Cerqueira      ³ Data ³ 19.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faturamento Mensal com serviços incluídos (Era a 2ª parte  ³±±
±±³            do BOLQTD                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NTOTIPI,APEDCLI,CSTRING,AQUANT,AQTOTAL,ASTRU")
SetPrvt("CARQTRAB,CIND,ASTRU2,XCLIME,CNOM_VEND,CDESC_PROD")
SetPrvt("CGRP_PROD,CCODP,CCODV,NQTD,NLIQ,NIPI")
SetPrvt("ASTRU3,CCODVEN,CNOMVEN,NTOTVEND,M,K")
SetPrvt("NVINI,W,LVOLTA,LTOPOP,LREG,LITEM")
SetPrvt("_NREG,CDINI,CDFIM,NTOTGER,NTOTLIQ,CGRP")
SetPrvt("LACHOUGRP,CDESC,NTOT,NTLIQ,NTIPI,CHEADER")
SetPrvt("CHEADER2,CVEND1,NAJUSTE,LCONTINUA,CCODPROD,I")
SetPrvt("LPULOUP,_CALIASTEMP,_NREGTEMP1,_NREGTEMP2,LACHOU,J")
SetPrvt("G,")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel            := "FATMES"
tamanho          :="G"
titulo           :="EMISSAO DO FATURAMENTO MENSAL"
cDesc1           :="Emissao do faturamento mensal"
cDesc2           :=""
cDesc3           :=" "
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nLastKey         :=0
li               :=80
limite           :=220 //180  // 220
lRodape          :=.F.
nTotIPI          :=0
cString          := "SC6"     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg :="VCR610"
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Da Data                               ³
//³ mv_par02              Ate a Data                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)
wnrel:=SetPrint("",wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

cArqTrb1:=""
RptStatus({||C730Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==>     RptStatus({||Execute(C730Imp)})
DbSelectArea("FATM")
dbCloseArea()
Return

// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==>     Function C730IMP
Static Function C730IMP()
pergunte(cPerg,.F.)
limite   := 220
li       := 80
m_pag    := 1
nPag     := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSAY AvalImp(Limite)

cQry := "SELECT DISTINCT SUBSTRING(SD2.D2_COD,1,6) AS COD, SB1.B1_CLASSE1, SUM(SD2.D2_QUANT) AS QUANT, "
cQry := cQry + " SUM(SD2.D2_TOTAL) AS TLIQ, SUM(SD2.D2_VALIPI) AS TIPI"
cQry := cQry + " FROM SD2010 AS SD2, SF2010 AS SF2, SB1010 AS SB1, SF4010 AS SF4"
cQry := cQry + " WHERE SD2.D2_DOC = SF2.F2_DOC"
cQry := cQry + " AND SF2.F2_EMISSAO>='"+DTOS(mv_par01)+"'"
cQry := cQry + " AND SF2.F2_EMISSAO<='"+DTOS(mv_par02)+"'"
cQry := cQry + " AND SF2.F2_TIPO NOT IN ('D','I')"
//cQry := cQry + " AND SUBSTR(SD2.D2_CF,2,3) NOT  IN ('117','201','202','553','556','558','901','902','908','909','910','911','912','913','914','915','916','918','923')"
cQry := cQry + " AND SD2.D2_TES=SF4.F4_CODIGO"
cQry := cQry + " AND SF4.F4_DUPLIC='S'"
cQry := cQry + " AND SD2.D2_COD=SB1.B1_COD"
cQry := cQry + " AND SF2.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SD2.D_E_L_E_T_<>'*'"
cQry := cQry + " GROUP BY SUBSTRING(SD2.D2_COD,1,6), SB1.B1_CLASSE1"
Tcquery cQry new alias "FATM"

nTotGer:=0
nTotLiq:=0
nTotIPI:=0       
li:=65
DbSelectArea("FATM")
SetRegua(RecCount())
DbGoTop()           
While FATM->( !Eof() )
   IncRegua()
   If li > 63 
      If li <> 65
         @ li,000 PSAY Replicate("-",limite)
      Endif
      li:=1
      @ li,001 PSAY Replicate("-",limite)
      li := li+1
      @ li,001 PSAY SM0->M0_NOMECOM
      li := li+1
      @ li,001 PSAY "FATURAMENTO MENSAL - Periodo de"
      cDIni:=DTOS(mv_par01)
      cDFim:=DTOS(mv_par02)
      @ li,044 PSAY SubStr(cDIni,7,2)+"/"+SubStr(cDIni,5,2)+"/"+SubStr(cDIni,1,4)+" a "+SubStr(cDFim,7,2)+"/"+SubStr(cDFim,5,2)+"/"+SubStr(cDFim,1,4)
      @ li,116 PSAY "DATA:"
	  @ li,122 PSAY SubStr(Dtos(Date()),7,2)+"/"+SubStr(Dtos(Date()),5,2)+"/"+SubStr(Dtos(Date()),1,4)
      li:=li+1
      @ li,001 PSAY Replicate("-",Limite)
      li:=li+1
      @ li,001 PSAY "  PRODUTO                                |    Q U A N T     |  L I Q U I D O   |    P R E C O     |    T A B E L A   |  D I F  |  D I F  |        I P I     |    T O T A L     |"
      li:=li+1                                                    
      @ li,001 PSAY "                                         |                  |                  |    M E D I O     |     A T U A L    |   R $   |    %    |                  |    B R U T O     | "
      li:=li+1                                                                                                                              
      @ li,001 PSAY Replicate("-",Limite)                         
      li:=li+1
   End
   DbselectArea("SZ2")
   DbSeek(xFilial()+FATM->B1_CLASSE1,.T.)
   cDesc := Z2_DESC                                                          
   XPCM:=0
   DbselectArea("SB1")
   SB1->( DbSetOrder(1) )
   SB1->( dbSeek(xFilial()+FATM->COD,.T.) )
   While SB1->( !Eof() ) .AND. SUBSTR(SB1->B1_COD,1,6)=FATM->COD
      If SB1->B1_PRV2>XPCM
         XPCM:=SB1->B1_PRV2
      Endif
      SB1->(dbSkip())
   End
   XPCM:=XPCM/0.88
   DIFR:=(FATM->TLIQ/FATM->QUANT)-XPCM
   DIFP:=DIFR*100/XPCM
   @ li, 001      PSAY FATM->COD+" "+SubStr(cDesc,1,30)+"    |"
   @ li, PCOL()+2 PSAY FATM->QUANT             Picture "@E 999,999,999.99"
   @ li, PCOL()+2 PSAY "|"
   @ li, PCOL()+2 PSAY FATM->TLIQ              Picture "@E 999,999,999.99"
   @ li, PCOL()+2 PSAY "|"
   @ li, PCOL()+6 PSAY FATM->TLIQ/FATM->QUANT  Picture "@E 999.99"
   @ li, PCOL()+6 PSAY "|"
   @ li, PCOL()+6 PSAY XPCM Picture "@E 999.99"
   @ li, PCOL()+6 PSAY "|"
   @ li, PCOL()+1 PSAY DIFR Picture "@E 999.99"
   @ li, PCOL()+2 PSAY "|"
   @ li, PCOL()+3 PSAY DIFP Picture "@E 999"
   @ li, PCOL()+3 PSAY "|"
   @ li, PCOL()+2 PSAY FATM->TIPI              Picture "@E 999,999,999.99"
   @ li, PCOL()+2 PSAY "|"
   @ li, PCOL()+2 PSAY FATM->TLIQ+FATM->TIPI   Picture "@E 999,999,999.99"
   @ li, PCOL()+2 PSAY "|"
   li:=li+1
   ntotGer:=nTotGer+FATM->QUANT
   ntotLIQ:=nTotLiq+FATM->TLIQ
   ntotIPI:=nTotIPI+FATM->TIPI
   FATM->(dbSkip())
End

li:=li+1
@ li,000 PSAY Replicate("-",Limite)
li:=li+1
@ li,000      PSAY "  TOTAL GERAL                             |"
@ li,PCOL()+2 PSAY nTotGer Picture "@E 999,999,999.99"
@ li,PCOL()+2 PSAY "|"
@ li,PCOL()+2 PSAY nTotLiq Picture "@E 999,999,999.99"
@ li,PCOL()+2 PSAY "|                  |"
@ li,PCOL()+2 PSAY nTotIPI Picture "@E 999,999,999.99"
@ li,PCOL()+2 PSAY "|"
@ li,PCOL()+2 PSAY nTotLiq+nTotIPI Picture "@E 999,999,999.99"
@ li,PCOL()+2 PSAY "|"
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

