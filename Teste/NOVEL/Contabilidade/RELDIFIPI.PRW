#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"

User Function RELDIFIPI()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ RELDIFIPI ³ Autor ³ Eliene Cerqueira     ³ Data ³ 19.09.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rel. de Difer. entre o IPI da NF e o IPI com Desc.no Frete ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafis                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

wnrel    :=""
tamanho  :="P"
titulo   :="RELATORIO DE DIFERENCA NO IPI"
cDesc1   :="Relatorio de diferenca entre o IPI da NF e o IPI com desconto do frete"
cDesc2   :=""
cDesc3   :=" "
cabec1 	 := "NF           EMISSAO            IPI               IPI            DIFERENÇA" 
cabec2 	 := "                             DESTACADO        C/DESCONTO                   "
//           999999-XXX   99/99/99      9.999.999,99      9.999.999,99      9.999.999,99
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :="" //  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg    :="VCR610"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nTipo	 := GetMv("MV_COMP")
nomeprog :="DIFIPI"
nLastKey :=0
nBegin   :=0
aLinha   :={ }
li       :=80
limite   :=80
lRodape  :=.F.
wnrel    := "DIFIPI"
cString  := "SF2"     
M_Pag     := 1

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

Return

// Substituido pelo assistente de conversao do AP5 IDE em 06/09/02 ==>     Function C730IMP
Static Function Gera()

TOTF:=0
DbSelectArea("SF2")
DbGoTop()      
SetRegua(RecCount())
DbSetOrder(3)
DbSeek(xFilial("SF2")+" "+Dtos(mv_par01),.T.)
While !EOF() .AND. F2_EMISSAO <= mv_par02
  IncRegua()
  If F2_IPISFR=0
     SF2->( DbSkip() )       
     Loop
  Endif                               
  If li > 60
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
     li:=li+1
  End
//999999-XXX   99/99/99        9.999.999,99        9.999.999,99        9.999.999,99
//999999-XXX   99/99/99      9.999.999,99      9.999.999,99      9.999.999,99

  @ li,000       PSAY F2_DOC+"-"+F2_SERIE
  @ li, PCol()+3 PSAY F2_EMISSAO
  @ li, PCol()+6 PSAY F2_VALIPI Picture "@E 9,999,999.99"
  @ li, PCol()+6 PSAY F2_IPISFR Picture "@E 9,999,999.99"
  @ li, PCol()+6 PSAY F2_VALIPI-F2_IPISFR Picture "@E 9,999,999.99"
  TOTF:=TOTF+F2_VALIPI-F2_IPISFR
  li:=li+1
  SF2->( DbSkip() )       
End

If TOTF<>0
   li:=li+1
   @ li,047    PSAY "TOTAL -->       "
   @ li,PCol() PSAY TOTF Picture "@E 9,999,999.99"
   li:=li+2
End

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
