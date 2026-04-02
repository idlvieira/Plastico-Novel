#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"

User Function RELDF()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ RELDF    ³ Autor ³ Eliene Cerqueira      ³ Data ³ 29.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Diferencas no Frete                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigacom                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

wnrel            :=""
tamanho          :="P"
titulo           :="Relatorio de Diferencas no Frete"
cDesc1           :="Relatorio de diferencas no frete"
cDesc2           :=""
cDesc3           :=" "
cabec1 	         := "DT.DIGIT.      CF/NF          VALOR NF    PEDIDO     VL.PEDIDO       DIFERENÇA"
cabec2 	         := ""
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :="" //  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="VCR610"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nTipo	         := GetMv("MV_COMP")
nomeprog         :="RELDF"
nLastKey         :=0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=80
m_pag            := 1
lRodape          :=.F.
wnrel            := "RELDF"
cString          := "SD1"     
NPag             := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Da Data                               ³
//³ mv_par02              Ate a Data                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint("",wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey==27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
   Return
Endif

RptStatus({||Gera()})// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==>     RptStatus({||Execute(C730Imp)})

DbSelectArea("DIF")
dbCloseArea()
Return

// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==>     Function C730IMP
Static Function Gera()
/*
limite   := 80
li       := 80
nPag     := 0
@ 0,0 PSAY AvalImp(Limite)
*/
cQry := " SELECT SD1.D1_DOC, SD1.D1_NFORI, SD1.D1_FORNECE, SA2.A2_NOME, SD1.D1_TOTAL," 
cQry := cQry + " SD1.D1_PEDIDO, SD1.D1_DTDIGIT, SC7.C7_TOTAL"
cQry := cQry + " FROM SD1010 AS SD1, SC7010 AS SC7, SA2010 AS SA2"
cQry := cQry + " WHERE SD1.D1_DTDIGIT >= '"+DTOS(MV_PAR01)+"'" 
cQry := cQry + " AND SD1.D1_DTDIGIT <= '"+DTOS(MV_PAR02)+"'" 
cQry := cQry + " AND SD1.D1_SERIE = 'CTR'"
cQry := cQry + " AND SD1.D1_PEDIDO = SC7.C7_NUM"
cQry := cQry + " AND SA2.A2_COD = SD1.D1_FORNECE"
cQry := cQry + " AND SD1.D1_TOTAL<>SC7.C7_TOTAL"
cQry := cQry + " AND SD1.D_E_L_E_T_<>'*'"
cQry := cQry + " AND SC7.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SD1.D1_FORNECE ASC, SD1.D1_DTDIGIT ASC"

Tcquery cQry new alias "DIF"

li := 65
DbSelectArea("DIF")
SetRegua(RecCount())   
TOTF:=TOTG:=0  
FORN:=DIF->D1_FORNECE
While !EOF()
  IncRegua()
  If li > 60
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
     li:=li+1
     @ li,000       PSAY DIF->D1_FORNECE + " - " + DIF->A2_NOME
     li:=li+1
  End
  @ li,000       PSAY SUBSTR(DIF->D1_DTDIGIT,7,2)+"/"+SUBSTR(DIF->D1_DTDIGIT,5,2)+"/"+SUBSTR(DIF->D1_DTDIGIT,3,2)
  @ li, PCol()+3 PSAY DIF->D1_DOC+"/"+DIF->D1_NFORI
  @ li, PCol()+2 PSAY DIF->D1_TOTAL Picture "@E 9,999,999.99"
  @ li, PCol()+4 PSAY DIF->D1_PEDIDO
  @ li, PCol()+2 PSAY DIF->C7_TOTAL Picture "@E 9,999,999.99"
  @ li, PCol()+2 PSAY DIF->D1_TOTAL-DIF->C7_TOTAL Picture "@E 9,999,999.99"
  TOTF:=TOTF+DIF->D1_TOTAL-DIF->C7_TOTAL
  li:=li+1
  DIF->( DbSkip() )       

  If FORN<>D1_FORNECE
     If TOTF<>0                 
        li:=li+1
        @ li,048    PSAY "TOTAL -->       "
        @ li,PCol() PSAY TOTF Picture "@E 9,999,999.99"
        li:=li+2
        TOTG:=TOTG+TOTF
        TOTF:=0
     End
     @ li,000       PSAY DIF->D1_FORNECE + " - " + DIF->A2_NOME
     li:=li+2
     FORN:=DIF->D1_FORNECE
  Endif
End

If TOTF<>0
   li:=li+1
   @ li,048    PSAY "TOTAL -->       "
   @ li,PCol() PSAY TOTF Picture "@E 9,999,999.99"
   li:=li+2
   TOTG:=TOTG+TOTF
   TOTF:=0
End
If TOTG<>0
   @ li,048    PSAY "TOTAL GERAL --> "
   @ li,PCol() PSAY TOTG Picture "@E 9,999,999.99"
   li:=li+2
End

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
