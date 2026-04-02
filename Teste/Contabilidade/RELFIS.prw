#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

User Function RELFIS()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ RELFIS   ³ Autor ³   Marcos L. Santos    ³ Data ³ 06.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao das NFS. - Livros Fiscais (Por Estado)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafis                                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,M_PAG,WNREL,NVLCTOT,NBICMTOT")
SetPrvt("NICMTTOT,NICMITOT,NICMOTOT,NBIPITOT,NIPITTOT,NIPIITOT")
SetPrvt("NIPIOTOT,NVLCEST,NBICMEST,NICMTEST,NICMIEST,NICMOEST")
SetPrvt("NBIPIEST,NIPITEST,NIPIIEST,NIPIOEST,NVLCCFO,NBICMCFO")
SetPrvt("NICMTCFO,NICMICFO,NICMOCFO,NBIPICFO,NIPITCFO,NIPIICFO")
SetPrvt("NIPIOCFO,NLIN,CCFOATU,CESTATU,CCFODE,CCFOATE")
SetPrvt("DSERDE,DSERATE,VEZ_EST,VEZ_CFO,VEZ,_CALIAS")
SetPrvt("_CSX1,S,")

cString :="SF3"
cDesc1  := OemToAnsi("Este programa tem como objetivo, emitir as NFs por")
cDesc2  := OemToAnsi("estado conforme os parametros selecionados.           ")
cDesc3  := ""
tamanho :="G"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="RELFIS"
aLinha  := { }
nLastKey:= 0
cPerg   :="PNV004"
titulo  :="NFs Entrada/Saida"
cabec1  :="SER  N.F.    EMISSAO    VL.CONTABIL  CFO       BASE ICMS  UF     ICMS TRIB     ICMS ISEN     ICMS OUTR      BASE IPI     IPI TRIB.     IPI ISEN.     IPI OUTR."
cabec2  :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag   := 1  //Variavel que acumula numero da pagina

wnrel   :="RELFIS"            //Nome Default do relatorio em Disco


// Criar arquivo de Perguntas
GRAV_1SX()// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==> Execute(GRAV_1SX)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01         Da Emissao      D  8  0                    ³
//³ mv_par02         Ate a Emissao   D  8  0                    ³
//³ mv_par03         Da Serie        C  3  0                    ³
//³ mv_par04         Ate a Serie     C  3  0                    ³
//³ mv_par05         Do CFO          C  3  0                    ³
//³ mv_par06         Ate o CFO       C  3  0                    ³
//³ mv_par07         Inclui BA?      N  1  0 (Sim/Nao)          ³
//³ mv_par08         Tipo            N  1  0 (Geral/Por Estado) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("PNV004",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==> RptStatus({|| Execute(RptDetail) })
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==> Function RptDetail
Static Function RptDetail()

nVlCTot  := 0
nBIcmTot := 0
nIcmTTot := 0
nIcmITot := 0
nIcmOTot := 0
nBIpiTot := 0
nIpiTTot := 0
nIpiITot := 0
nIpiOTot := 0

nVlCEst  := 0
nBIcmEst := 0
nIcmTEst := 0
nIcmIEst := 0
nIcmOEst := 0
nBIpiEst := 0
nIpiTEst := 0
nIpiIEst := 0
nIpiOEst := 0

nVlCCFO  := 0
nBIcmCFO := 0
nIcmTCFO := 0
nIcmICFO := 0
nIcmOCFO := 0
nBIpiCFO := 0
nIpiTCFO := 0
nIpiICFO := 0
nIpiOCFO := 0

nLin     := 0

cCFOAtu := Space(4)
cESTAtu := Space(2)
cCFODe  := mv_par05
cCFOAte := mv_par06
dSERDe  := mv_par03
dSERAte := mv_par04

DbSelectArea("SF3")

If mv_par08==2
    DbSetOrder(8) // Estado+CFO+Emissao
	DbSeek(xFilial()+"AA",.T.)
Else
    DbSetOrder(9) // CFO+Emissao
	DbSeek(xFilial(),.T.)
EndIF

SetRegua(LastRec())
//SETPRC(0,0)
nLin := 65
VEZ_Est := 0
VEZ_CFO := 0
Do While !EOF()
    
   If nLin >= 60
      nLin := 0
      nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
      nLin := nLin + 1
   Endif
   If !Empty(SF3->F3_DTCANC)
	  DbSkip()
	  Incregua()
	  Loop
   EndIf 

   If mv_par07==2 // Nao Inclui Bahia!
      If Alltrim(SF3->F3_ESTADO)=="BA"
 		 DbSkip()
		 Incregua()
		 Loop
      EndIf
   EndIF

   If (DtoS(F3_EMISSAO)<DtoS(mv_par01) .Or. DtoS(F3_EMISSAO)>DtoS(mv_par02))
	  DbSkip()
	  Incregua()
	  Loop
   EndIF

   If (F3_CFO<mv_par05 .Or. F3_CFO>mv_par06) .or. (F3_SERIE<mv_par03 .or. F3_SERIE>mv_par04)
      DbSkip()
	  IncRegua()
	  Loop
   EndIF

   If mv_par08==1  // Tipo: Geral
      If cCFOAtu <> SF3->F3_CFO .AND. VEZ_CFO <> 0 .AND. nVlCCFO>0
		 nVlCTot  := nVlCTot + nVlCCFO
		 nBIcmTot := nBIcmTot + nBIcmCFO
		 nIcmTTot := nIcmTTot + nIcmTCFO
		 nIcmITot := nIcmITot + nIcmICFO  
		 nIcmOTot := nIcmOTot + nIcmOCFO
		 nBIpiTot := nBIpiTot + nBIpiCFO  
		 nIpiTTot := nIpiTTot + nIpiTCFO 
		 nIpiITot := nIpiITot + nIpiICFO
         nIpiOtot := nIpiOTot + nIpiOCFO
         nLin := nLin + 1
	     @ nlin, 000 PSAY "Totais do Grupo:"
		 @ nlin, PCOL()+7 PSAY nVlCCFO   Picture "@E 9,999,999.99"
		 @ nlin, PCOL()+9 PSAY nBIcmCFO  Picture "@E 9,999,999.99"
		 @ nlin, PCOL()+6 PSAY nIcmTCFO  Picture "@E 9,999,999.99"
		 @ nlin, PCOL()+2 PSAY nIcmICFO  Picture "@E 9,999,999.99"  
		 @ nlin, PCOL()+2 PSAY nIcmOCFO  Picture "@E 9,999,999.99"
		 @ nlin, PCOL()+2 PSAY nBIpiCFO  Picture "@E 9,999,999.99"
		 @ nlin, PCOL()+2 PSAY nIpiTCFO  Picture "@E 9,999,999.99"
		 @ nlin, PCOL()+2 PSAY nIpiICFO  Picture "@E 9,999,999.99"
		 @ nlin, PCOL()+2 PSAY nIpiOCFO  Picture "@E 9,999,999.99"
         nLin := nLin + 1
		 nVlCCFO  := 0
		 nBIcmCFO := 0
		 nIcmTCFO := 0
		 nIcmICFO := 0
		 nIcmOCFO := 0
		 nBIpiCFO := 0
		 nIpiTCFO := 0
		 nIpiICFO := 0
		 nIpiOCFO := 0
		 nLin    := 0
		 nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	     nLin := nLin + 1
	  EndIf

	  If cCFOAtu <> SF3->F3_CFO
         nLin := nLin + 1
	     @ nLin,00 Psay "CFO  --> "+SF3->F3_CFO
         nLin := nLin + 2
         VEZ_CFO := 1
		 VEZ     := 1
	  EndIf

	  cCFOAtu := SF3->F3_CFO

	  @ nlin, 000      PSAY F3_SERIE + "  " + F3_NFISCAL
	  @ nlin, PCOL()+2 PSAY F3_EMISSAO
	  @ nlin, PCOL()+2 PSAY F3_VALCONT Picture "@E 9,999,999.99"
	  @ nlin, PCOL()+2 PSAY F3_CFO
	  @ nlin, PCOL()+2 PSAY F3_BASEICM Picture "@E 9,999,999.99"
	  @ nlin, PCOL()+2 PSAY F3_ESTADO
	  @ nlin, PCOL()+2 PSAY F3_VALICM Picture "@E 9,999,999.99"
	  @ nlin, PCOL()+2 PSAY F3_ISENICM Picture "@E 9,999,999.99"
	  @ nlin, PCOL()+2 PSAY F3_OUTRICM Picture "@E 9,999,999.99"
	  @ nlin, PCOL()+2 PSAY F3_BASEIPI Picture "@E 9,999,999.99"
	  @ nlin, PCOL()+2 PSAY F3_VALIPI Picture "@E 9,999,999.99"
	  @ nlin, PCOL()+2 PSAY F3_ISENIPI Picture "@E 9,999,999.99"
	  @ nlin, PCOL()+2 PSAY F3_OUTRIPI Picture "@E 9,999,999.99"
      nLin := nLin + 1
	  
	  nVlCCFO  := nVlCCFO + F3_VALCONT
	  nBIcmCFO := nBIcmCFO + F3_BASEICM
	  nIcmTCFO := nIcmTCFO + F3_VALICM
	  nIcmICFO := nIcmICFO + F3_ISENICM
	  nIcmOCFO := nIcmOCFO + F3_OUTRICM
	  nBIpiCFO := nBIpiCFO + F3_BASEIPI
	  nIpiTCFO := nIpiTCFO + F3_VALIPI
	  nIpiICFO := nIpiICFO + F3_ISENIPI
	  nIpiOCFO := nIpiOCFO + F3_OUTRIPI
   Else  // Tipo: Por Estado
      If ((cCFOAtu <> SF3->F3_CFO).AND. VEZ_CFO <> 0) .OR. cESTAtu <> SF3->F3_ESTADO .AND. (nVlCCFO>0)
		  nVlCEst  := nVlCEst + nVlCCFO
		  nBIcmEst := nBIcmEst + nBIcmCFO
		  nIcmTEst := nIcmTEst + nIcmTCFO
		  nIcmIEst := nIcmIEst + nIcmICFO  
		  nIcmOEst := nIcmOEst + nIcmOCFO
		  nBIpiEst := nBIpiEst + nBIpiCFO  
		  nIpiTEst := nIpiTEst + nIpiTCFO 
		  nIpiIEst := nIpiIEst + nIpiICFO
		  nIpiOEst := nIpiOEst + nIpiOCFO
          nLin := nLin + 1
		  @ nlin, 000 PSAY "Totais do Grupo:"
		  @ nlin, PCOL()+7 PSAY nVlCCFO   Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+9 PSAY nBIcmCFO  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+6 PSAY nIcmTCFO  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIcmICFO  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIcmOCFO  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nBIpiCFO  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIpiTCFO  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIpiICFO  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIpiOCFO  Picture "@E 9,999,999.99"
		  nVlCCFO  := 0
		  nBIcmCFO := 0
		  nIcmTCFO := 0
		  nIcmICFO := 0
		  nIcmOCFO := 0
		  nBIpiCFO := 0
		  nIpiTCFO := 0
		  nIpiICFO := 0
		  nIpiOCFO := 0
	      nLin := nLin + 1
	   EndIf

	   If cESTAtu <> SF3->F3_ESTADO .And. VEZ_Est<>0
		  nVlCTot  := nVlCTot + nVlCEst
		  nBIcmTot := nBIcmTot + nBIcmEst
		  nIcmTTot := nIcmTTot + nIcmTEst
		  nIcmITot := nIcmITot + nIcmIEst  
		  nIcmOTot := nIcmOTot + nIcmOEst
		  nBIpiTot := nBIpiTot + nBIpiEst  
		  nIpiTTot := nIpiTTot + nIpiTEst 
		  nIpiITot := nIpiITot + nIpiIEst
		  nIpiOtot := nIpiOTot + nIpiOEst
          nLin := nLin + 1
		  @ nlin, 000 PSAY "Totais do Estado:"
		  @ nlin, PCOL()+6 PSAY nVlCEst   Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+9 PSAY nBIcmEst  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+6 PSAY nIcmTEst  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIcmIEst  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIcmOEst  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nBIpiEst  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIpiTEst  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIpiIEst  Picture "@E 9,999,999.99"
		  @ nlin, PCOL()+2 PSAY nIpiOEst  Picture "@E 9,999,999.99"
		  nVlCEst  := 0
		  nBIcmEst := 0
		  nIcmTEst := 0
		  nIcmIEst := 0
		  nIcmOEst := 0
		  nBIpiEst := 0
		  nIpiTEst := 0
		  nIpiIEst := 0
		  nIpiOEst := 0
  		  nLin    := 0
	      nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
 	      nLin := nLin + 1
	   EndIf

	   If cESTAtu <> SF3->F3_ESTADO
          nLin := nLin + 1
    	  @ nLin,00 Psay "Estado: "+SF3->F3_ESTADO
          nLin := nLin + 1
	      VEZ_Est := 1
		  VEZ     := 1
	   EndIf

	   If (cCFOAtu <> SF3->F3_CFO .And. VEZ<>0) .OR. (cESTAtu <> SF3->F3_ESTADO .AND. cCFOAtu <> SF3->F3_CFO .AND. VEZ<>0)
          nLin := nLin + 1
	      @ nLin,00 Psay "CFO  --> "+SF3->F3_CFO
          nLin := nLin + 2
	      VEZ_CFO := 1
	   EndIf

	   cESTAtu := SF3->F3_ESTADO
	   cCFOAtu := SF3->F3_CFO

	   @ nlin, 000 PSAY F3_SERIE + "  " + F3_NFISCAL
	   @ nlin, PCOL()+2 PSAY F3_EMISSAO
	   @ nlin, PCOL()+2 PSAY F3_VALCONT Picture "@E 9,999,999.99"
	   @ nlin, PCOL()+2 PSAY F3_CFO
	   @ nlin, PCOL()+2 PSAY F3_BASEICM Picture "@E 9,999,999.99"
 	   @ nlin, PCOL()+2 PSAY F3_ESTADO
	   @ nlin, PCOL()+2 PSAY F3_VALICM Picture "@E 9,999,999.99"
	   @ nlin, PCOL()+2 PSAY F3_ISENICM Picture "@E 9,999,999.99"
	   @ nlin, PCOL()+2 PSAY F3_OUTRICM Picture "@E 9,999,999.99"
	   @ nlin, PCOL()+2 PSAY F3_BASEIPI Picture "@E 9,999,999.99"
	   @ nlin, PCOL()+2 PSAY F3_VALIPI Picture "@E 9,999,999.99"
	   @ nlin, PCOL()+2 PSAY F3_ISENIPI Picture "@E 9,999,999.99"
	   @ nlin, PCOL()+2 PSAY F3_OUTRIPI Picture "@E 9,999,999.99"
       nLin := nLin + 1

       nVlCCFO  := nVlCCFO + F3_VALCONT
	   nBIcmCFO := nBIcmCFO + F3_BASEICM
	   nIcmTCFO := nIcmTCFO + F3_VALICM
	   nIcmICFO := nIcmICFO + F3_ISENICM
	   nIcmOCFO := nIcmOCFO + F3_OUTRICM
	   nBIpiCFO := nBIpiCFO + F3_BASEIPI
	   nIpiTCFO := nIpiTCFO + F3_VALIPI
	   nIpiICFO := nIpiICFO + F3_ISENIPI
	   nIpiOCFO := nIpiOCFO + F3_OUTRIPI
   EndIF
   IncRegua() //Incrementa a posicao da regua de relatorios
   DbSkip()
EndDo

If  nVLCCFO > 0 .And. VEZ <> 0 
    nLin := nLin + 1
	@ nlin, 000 PSAY "Totais do Grupo:"
	@ nlin, PCOL()+7 PSAY nVlCCFO   Picture "@E 9,999,999.99"
	@ nlin, PCOL()+9 PSAY nBIcmCFO  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+6 PSAY nIcmTCFO  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIcmICFO  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIcmOCFO  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nBIpiCFO  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiTCFO  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiICFO  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiOCFO  Picture "@E 9,999,999.99"
    nLin := nLin + 1
	nVlCTot  := nVlCTot + nVlCCFO
	nBIcmTot := nBIcmTot + nBIcmCFO
	nIcmTTot := nIcmTTot + nIcmTCFO
	nIcmITot := nIcmITot + nIcmICFO  
	nIcmOTot := nIcmOTot + nIcmOCFO
	nBIpiTot := nBIpiTot + nBIpiCFO  
	nIpiTTot := nIpiTTot + nIpiTCFO 
	nIpiITot := nIpiITot + nIpiICFO
	nIpiOtot := nIpiOTot + nIpiOCFO
EndIf
If  nVLCEst > 0 .And. VEZ <> 0
    nLin := nLin + 1
	@ nlin, 000 PSAY "Totais do Estado:"
	@ nlin, PCOL()+6 PSAY nVlCEst   Picture "@E 9,999,999.99"
	@ nlin, PCOL()+9 PSAY nBIcmEst  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+6 PSAY nIcmTEst  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIcmIEst  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIcmOEst  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nBIpiEst  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiTEst  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiIEst  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiOEst  Picture "@E 9,999,999.99"
    nLin := nLin + 1
	nVlCTot  := nVlCTot + nVlCEst
	nBIcmTot := nBIcmTot + nBIcmEst
	nIcmTTot := nIcmTTot + nIcmTEst
	nIcmITot := nIcmITot + nIcmIEst  
	nIcmOTot := nIcmOTot + nIcmOEst
	nBIpiTot := nBIpiTot + nBIpiEst  
	nIpiTTot := nIpiTTot + nIpiTEst 
	nIpiITot := nIpiITot + nIpiIEst
	nIpiOtot := nIpiOTot + nIpiOEst
EndIf
If  nVLCTot > 0
    nLin := nLin + 1
	@ nlin, 000 PSAY "Total Geral:  "
    @ nlin, PCOL()+9 PSAY nVlCTot   Picture "@E 9,999,999.99"
    @ nlin, PCOL()+9 PSAY nBIcmTot  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+6 PSAY nIcmTTot  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIcmITot  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIcmOTot  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nBIpiTot  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiTTot  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiITot  Picture "@E 9,999,999.99"
	@ nlin, PCOL()+2 PSAY nIpiOTot  Picture "@E 9,999,999.99"
EndIf

Roda(0,"","M")
Set Filter To
If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para Gravacao das perguntas no SX1                 ³
//³ Autor: Tito Roland (Deve ser alterada conforme            ³
//³        necessidade do programa.)                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==> Function GRAV_1SX
Static Function GRAV_1SX()
   *
   _cAlias:=Select()
   *
   _cSX1:={}
   Aadd(_cSX1,{cPerg,"01","Da Emissao        ?","MV_CH1", "D",0, 8,0,"G","","MV_PAR01","","","",""})
   Aadd(_cSX1,{cPerg,"02","Ate a Emissao     ?","MV_CH2", "D",0, 8,0,"G","","MV_PAR02","","","",""})
   Aadd(_cSX1,{cPerg,"03","Da Serie          ?","MV_CH3", "C",0, 3,0,"G","","MV_PAR03","","","",""})
   Aadd(_cSX1,{cPerg,"04","Ate a Serie       ?","MV_CH4", "C",0, 3,0,"G","","MV_PAR04","","","",""})
   Aadd(_cSX1,{cPerg,"05","Do CFO            ?","MV_CH5", "C",0, 3,0,"G","","MV_PAR05","","","",""})
   Aadd(_cSX1,{cPerg,"06","Ate o CFO         ?","MV_CH6", "C",0, 3,0,"G","","MV_PAR06","","","",""})
   Aadd(_cSX1,{cPerg,"07","Inclui BA         ?","MV_CH7", "N",0, 1,0,"C","","MV_PAR07","Sim","Nao","",""})
   Aadd(_cSX1,{cPerg,"08","Tipo              ?","MV_CH8", "N",0, 1,0,"C","","MV_PAR08","Geral","Por Estado","",""})
   *   
   For S := 1 To Len(_cSX1)
       *
       dbSelectArea("SX1")
       dbSetOrder(1)
       dbSeek(cPerg+Right(Strzero(S),2),.T.)
       *
       If ! Found()
          RecLock("SX1",.T.)
          *
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
