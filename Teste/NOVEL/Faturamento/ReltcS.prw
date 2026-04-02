#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³reltcS    º Autor ³ Eliene Cerqueira   º Data ³  24/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Estatistica de tempo de liberacao             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function reltcS()

SetPrvt("cDesc1,cDesc2,cDesc3,cPict,titulo,nLin")
SetPrvt("Cabec1,Cabec2,imprime,aOrd")
SetPrvt("ARADIO,NRADIO,Qtd,Dias")

cDesc1        	:= "Este programa tem como objetivo imprimir relatorio "
cDesc2       	:= "de estatistica de tempo de liberação de crédito."
cDesc3       	:= ""
cPict        	:= ""
titulo       	:= "Estatistica de Tempo de Liberação"
nLin         	:= 80
Cabec1       	:= "Mes/Ano          |  Quantidade de Pedidos Aprovados"
Cabec2       	:= "                 |  0 - 4 dias   %   |  5 - 10 dias   %   |  11 - 20 dias   %   |  21 - 40 dias   %   |  41 - 60 dias   %   |  61 - 80 dias   %   | Mais de 80     %    |   Total"
//"                 Fevereiro/2005   |     999     999   |     999      999   |      999      999   |      999      999   |      999      999   |      999      999   |     999      999    |    999
imprime      	:= .T.             
aOrd            := {}
Qtd             :=0
Dias            :=0
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nTipo       := GetMv("MV_COMP")
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELTCS"
Private DATLIB      := "  /  /  "
Private LIBCRED     := "N"

Private cString 	:= "SC6"
Private cPerg       := "RELTCS"

AjustaSx1()
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Ano                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|lEnd| C700Imp(@lEnd,wnrel,cString,aReturn,tamanho,limite,;	
						  titulo,cDesc1,cDesc2,cDesc3)},Titulo)
Return 

Static Function C700Imp(lEnd,WnRel,cString,aReturn,tamanho,limite,titulo,;
						cDesc1,cDesc2,cDesc3)
DatIni:=CTOD("01/01/"+MV_PAR01)
DatFin:=CTOD("31/12/"+MV_PAR01)
Faixa1:=Faixa2:=Faixa3:=Faixa4:=Faixa5:=Faixa6:=Faixa7:=0
dbSelectArea("SUA")
SetRegua(RecCount())
dbSetOrder(4) // emissao
dbSeek(xFilial("SUA")+DTOS(Datini),.T.)
Mes:=Month(SUA->UA_EMISSAO)
While !EOF() .and. SUA->UA_EMISSAO <= DatFin

   IncRegua()
   If lAbortPrint
   	  @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 70
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
	  nLin := 9
   Endif   
   dbSelectArea("SA1")
   dbSetOrder(1) 
   dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,.F.)
        
   dbSelectArea("SC5")
   dbSetOrder(1) 
   dbSeek(xFilial("SC5")+SUA->UA_NUMSC5,.F.)	

   dbSelectArea("SC6")
   dbSetOrder(1) 
   dbSeek(xFilial("SC6")+SUA->UA_NUMSC5,.F.)	
   Achou1:=Achou2:=Achou3:=Achou4:=Achou5:=Achou6:=Achou7:=.f.
   While !EOF() .and. SC6->C6_NUM = SC5->C5_NUM

      IF SC6->C6_TES$"508/515/516/517/521/522/523/524/528/529/531/536/537/538/543/544/545/546/547/548/549/550/555/556/557"
         dbSelectArea("SC6")
	     dbSkip()
	     Loop
      Endif
      LIBCRED:="N"
      BLCRED:="99"
      BLEST :="99"
      DbSelectArea("SC9")
      dbSetOrder(1)
      dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)	
      While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
         BLCRED:=C9_BLCRED               
         BLEST :=C9_BLEST           
         DATLIB:=C9_DATALIB
         dbSkip()
      Enddo
      If BLCRED="10" .and. BLEST="10" // Já faturado
         LIBCRED:="S"
      ElseIf (BLCRED="01" .and. BLEST="02") .or. (BLCRED="01" .and. BLEST="  ") // Bloqueado no crédito
         LIBCRED:="N"
      ElseIf BLCRED="  " .and. BLEST="02" // Bloqueado no estoque
         LIBCRED:="S"
      ElseIf BLCRED="  " .and. BLEST="  "
         LIBCRED:="S"
      Endif

      dbSelectArea("SC2")
      dbSetOrder(6) 
      dbSeek(xFilial("SC2")+SC6->C6_NUM+SC6->C6_ITEM,.F.)	

      dbSelectArea("SD3")
      dbSetOrder(1) 
      dbSeek(xFilial("SD3")+SC2->C2_NUM+SC6->C6_ITEM,.F.)	
                           	
      If LIBCRED="S"
         If !Empty(SC5->C5_NOVULT)
            If (SC5->C5_NOVULT - DATLIB)<5
               achou1:=.t.                
            ElseIf (SC5->C5_NOVULT - DATLIB)>=5 .and. (SC5->C5_NOVULT - DATLIB)<=10
               achou2:=.t.
            ElseIf (SC5->C5_NOVULT - DATLIB)>=11 .and. (SC5->C5_NOVULT - DATLIB)<=20
               achou3:=.t.
            ElseIf (SC5->C5_NOVULT - DATLIB)>=21 .and. (SC5->C5_NOVULT - DATLIB)<=40
               achou4:=.t.
            ElseIf (SC5->C5_NOVULT - DATLIB)>=41 .and. (SC5->C5_NOVULT - DATLIB)<=60
               achou5:=.t.
            ElseIf (SC5->C5_NOVULT - DATLIB)>=61 .and. (SC5->C5_NOVULT - DATLIB)<=80
               achou6:=.t.
            ElseIf (SC5->C5_NOVULT - DATLIB)>80
               achou7:=.t.
            Endif
         Else
            achou1:=.t.                
         Endif
      Endif
      dbSelectArea("SC6")
	  dbSkip()
   EndDo
   If Achou1
      Faixa1:=Faixa1+1
   Endif
   If Achou2
      Faixa2:=Faixa2+1
   Endif
   If Achou3
      Faixa3:=Faixa3+1
   Endif
   If Achou4
      Faixa4:=Faixa4+1
   Endif
   If Achou5
      Faixa5:=Faixa5+1
   Endif
   If Achou6
      Faixa6:=Faixa6+1
   Endif
   If Achou7
      Faixa7:=Faixa7+1
   Endif
   dbSelectArea("SUA")
   dbSkip()
   If Mes<>Month(SUA->UA_EMISSAO) .and. Faixa1+Faixa2+Faixa3+Faixa4+Faixa5+Faixa6+Faixa7>0
      ImpDET()
      Faixa1:=Faixa2:=Faixa3:=Faixa4:=Faixa5:=Faixa6:=Faixa7:=0
   Endif   
   Mes:=Month(SUA->UA_EMISSAO)
EndDo

@nLin+2,1 PSAY '.'

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ImpDet()                                                                                                                                    
"                 |  0 - 4 dias   %   |  5 - 10 dias   %   | 11 - 20 dias   %   | 21 - 40 dias   %   | 41 - 60 dias   %   | 61 - 80 dias   %   | Mais de 80     %   |   Total"
"Fevereiro/2005   |     999     999   |     999      999   |     999      999   |     999      999   |     999      999   |     999      999   |     999      999   |    999
    QtdTot:=Faixa1+Faixa2+Faixa3+Faixa4+Faixa5+Faixa6+Faixa7
    @nLin,00        PSAY MesExtenso(Mes)+"/"+MV_PAR01
    @nLin,017       PSAY "|     "
  	@nLin,PCol()    PSAY Faixa1 Picture "@E 999"
   	@nLin,PCol()+5  PSAY Faixa1*100/QtdTot Picture "@E 999"
   	@nLin,PCol()    PSAY "   |     "
   	@nLin,PCol()    PSAY Faixa2 Picture "@E 999"
   	@nLin,PCol()+6  PSAY Faixa2*100/QtdTot Picture "@E 999"
   	@nLin,PCol()    PSAY "   |      "
   	@nLin,PCol()    PSAY Faixa3 Picture "@E 999"
   	@nLin,PCol()+6  PSAY Faixa3*100/QtdTot Picture "@E 999"
   	@nLin,PCol()    PSAY "   |      "
   	@nLin,PCol()    PSAY Faixa4 Picture "@E 999"
   	@nLin,PCol()+6  PSAY Faixa4*100/QtdTot Picture "@E 999"
   	@nLin,PCol()    PSAY "   |      "
   	@nLin,PCol()    PSAY Faixa5 Picture "@E 999"
   	@nLin,PCol()+6  PSAY Faixa5*100/QtdTot Picture "@E 999"
   	@nLin,PCol()    PSAY "   |      "
   	@nLin,PCol()    PSAY Faixa6 Picture "@E 999"
   	@nLin,PCol()+6  PSAY Faixa6*100/QtdTot Picture "@E 999"
   	@nLin,PCol()    PSAY "   |      "
   	@nLin,PCol()    PSAY Faixa7 Picture "@E 999"
   	@nLin,PCol()+6  PSAY Faixa7*100/QtdTot Picture "@E 999"
    @nLin,PCol()    PSAY "   |    "
   	@nLin,PCol()    PSAY QtdTot Picture "@E 999"
   	nLin := nLin + 1
Return

Static Function AjustaSX1()

LOCAL aArea    := GetArea()
LOCAL aReg     := {}

LOCAL nLoop    := 0
LOCAL nLoop2   := 0
LOCAL nPosCpo  := 0

AAdd(aReg,{	{"X1_GRUPO","RELTCS"},;
{"X1_ORDEM","01"},;
{"X1_PERGUNT","Ano                ?"},;
{"X1_PERSPA","Ano                ?"},;
{"X1_PERENG","Ano                ?"},;
{"X1_VARIAVL","mv_ch1"},;
{"X1_TIPO","C"},;
{"X1_TAMANHO",4},;
{"X1_DECIMAL",0},;
{"X1_PRESEL",0},;
{"X1_GSC","G"},;
{"X1_VALID","NAOVAZIO"},;
{"X1_VAR01","mv_par01"},;
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