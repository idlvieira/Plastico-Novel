#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"

User Function RELPREV()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ RELPREV   ³ Autor ³ Eliene Cerqueira     ³ Data ³ 25.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Previsao de Vendas           (Plasticos Novel)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel            :=""
tamanho          :="G"
titulo           :="RELATORIO DE PREVISAO DE VENDAS"
cDesc1           :="Relatorio de previsao de vendas."
cDesc2           :=""
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :="" //  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="RELPRE"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog         :="RELPREV"
nLastKey         :=0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=80
lRodape          :=.F.
wnrel            := "RELPREV"
cString          := "SC4"     
NPag             := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSx1()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Mes                                   ³
//³ mv_par02              Ano                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

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
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSAY AvalImp(Limite)

aStru:={}
AADD( aStru, {"CODIGO" ,"C" ,15 ,0} )
AADD( aStru, {"DESCRICAO" ,"C" ,30 ,0} )
AADD( astru, {"QUANT"  ,"N" ,12 ,2} )
cArqTrab:=CriaTrab(aStru,.T.)

DbUseArea(.T.,"DBFCDX",cArqTrab,"QUERY1",.F.)
INDEX ON QUERY1->DESCRICAO TO CTRAB10
SET INDEX TO CTRAB10

WdataI:=Ctod("01/"+Strzero(mv_par01,2)+"/"+Strzero(mv_par02,4))
If mv_par01<12
   WdataF:=Ctod("01/"+Strzero(mv_par01+1,2)+"/"+Strzero(mv_par02,4))-1
Else
   WdataF:=Ctod("01/01/"+Strzero(mv_par02+1,4))-1
Endif
DbSelectArea("SC4")
DbSetOrder(2) // C4_DATA
Dbgotop()
DbSeek(xFilial("SC4")+Dtos(WdataI),.T.)
While SC4->( !Eof() ) .AND. C4_DATA <= WdataF
  DbSelectArea("SB1")
  DbSetOrder(1)
  DbSeek(xFilial("SB1")+SC4->C4_PRODUTO,.F.)
  DbSelectArea("QUERY1")
  If dbSeek(SC4->C4_PRODUTO,.F.)
     Reclock("QUERY1",.F.)
  Else
     Reclock("QUERY1",.T.)
     QUERY1->CODIGO    := SC4->C4_PRODUTO
     QUERY1->DESCRICAO := SB1->B1_DESC
  Endif
  QUERY1->QUANT  := QUERY1->QUANT+SC4->C4_QUANT
  MSUnlock()                           
  SC4->( DbSkip() )
End

DbSelectArea("QUERY1")
DbSetOrder(1)
Dbgotop()
SetRegua(RecCount())
li := 65
While !EOF()
  IncRegua()                            
  If li > 59 
     If li <> 65
        @ li,000 PSAY Replicate("-",limite)
     Endif
     ImpCabec()
     li:=li+1
  End
  @ li,000       PSAY CODIGO+"   "+DESCRICAO
  @ li, PCol()+10 PSAY QUANT Picture "@E 999,999.99"
  li:=li+1
  DbSkip()
End

DbselectArea("QUERY1")
DbCloseArea("QUERY1")
DELETE FILE CTRAB10.CDX

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Static Function ImpCabec()

  NPag:=NPag+1
  @ 02,000 PSAY Replicate("-",limite)
  li := 03
  @ li,000 PSAY SM0->M0_NOMECOM
  cDIni:=DTOS(DATE())
  @ li,070 PSAY SubStr(cDIni,7,2)+"/"+SubStr(cDIni,5,2)+"/"+SubStr(cDIni,1,4)
  li := li+1   
  @ li,000 PSAY "RELATORIO DE PREVISAO DE VENDAS - "+STRZERO(mv_par01,2)+"/"+STRZERO(mv_par02,4)
  @ li,077 PSAY Npag Picture "999"
  li := li+1
  @ li,000 PSAY Replicate("-",limite)
  li := li+1
  @ li,000 PSAY "PRODUTO           DESCRICAO                               QUANTIDADE"

  li := li+1
  @ li,000 PSAY Replicate("-",limite)
  li:=li+1

Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

Static Function AjustaSX1()

LOCAL aArea    := GetArea()
LOCAL aReg     := {}

LOCAL nLoop    := 0
LOCAL nLoop2   := 0
LOCAL nPosCpo  := 0

AAdd(aReg,{	{"X1_GRUPO","RELPRE"},;
{"X1_ORDEM","01"},;
{"X1_PERGUNT","Mes                ?"},;
{"X1_PERSPA","Mes                ?"},;
{"X1_PERENG","Mes                ?"},;
{"X1_VARIAVL","mv_ch1"},;
{"X1_TIPO","N"},;
{"X1_TAMANHO",2},;
{"X1_DECIMAL",0},;
{"X1_PRESEL",0},;
{"X1_GSC","G"},;
{"X1_VALID",""},;
{"X1_VAR01","mv_par01"},;
{"X1_PYME","N"} })

AAdd(aReg,{	{"X1_GRUPO","RELPRE"},;
{"X1_ORDEM","02"},;
{"X1_PERGUNT","Ano                ?"},;
{"X1_PERSPA","Ano                ?"},;
{"X1_PERENG","Ano                ?"},;
{"X1_VARIAVL","mv_ch2"},;
{"X1_TIPO","N"},;
{"X1_TAMANHO",4},;
{"X1_DECIMAL",0},;
{"X1_PRESEL",0},;
{"X1_GSC","G"},;
{"X1_VALID","NAOVAZIO"},;
{"X1_VAR01","mv_par02"},;
{"X1_PYME","N"} })

dbSelectArea("SX1")
dbSetOrder(1)
For nLoop := 1 to Len(aReg)
	If !dbSeek(aReg[nLoop][1][2]+aReg[nLoop][2][2])
		RecLock("SX1",.T.)
		For nLoop2 := 1 to Len(aReg[nLoop])
			nPosCpo := SX1->(FieldPos(aReg[nLoop][nLoop2][1]))
			If nPosCpo > 0
				SX1->(FieldPut(nPosCpo,aReg[nLoop][nLoop2][2]))
			EndIf
		Next nLoop2
		MsUnlock()
	EndIf
Next nLoop

RestArea(aArea)
Return(NIL)