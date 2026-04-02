#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³reltc     º Autor ³ Eliene Cerqueira   º Data ³  06/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio com tempo entre a emissao e a liberação crédito  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function reltc()

SetPrvt("cDesc1,cDesc2,cDesc3,cPict,titulo,nLin")
SetPrvt("Cabec1,Cabec2,imprime,aOrd")
SetPrvt("ARADIO,NRADIO,Qtd,Dias")

cDesc1        	:= "Este programa tem como objetivo imprimir relatorio "
cDesc2       	:= "de pedidos com o tempo de liberação de crédito."
cDesc3       	:= "Tempo de Liberação"
cPict        	:= ""
titulo       	:= "Relatório de Tempo de Liberação"
nLin         	:= 80
                    //          10        20        30        40        50        60        70        80
                    // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//Local Cabec1      := "Pedido   It  Cliente                Produto             Dt.Lib.   Dt.Op.   Dt.Ini.Op  Dt.Prod.  Dt.Fat."
Cabec1       	:= "Pedido   It  Cliente                Produto             Dt.Emis  Dt.Lib.  Dt.Lib.Cre    O.P.    Dt.Prod.  Dt.Fat.   Dias"
Cabec2       	:= ""
imprime      	:= .T.
aOrd            := {}
Qtd             :=0
Dias            :=0
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 120
Private tamanho     := "M"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELTC"
Private DATLIB      := "  /  /  "
Private LIBCRED     := "N"

Private cString 	:= "SC6"
Private cPerg       := "CONPV2"                  

Pergunte(cPerg,.F.)

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
//DbSelectArea("FAT")
//dbCloseArea()
Return 

Static Function C700Imp(lEnd,WnRel,cString,aReturn,tamanho,limite,titulo,;
						cDesc1,cDesc2,cDesc3)


QtdPed:=0
dbSelectArea("SUA")
SetRegua(RecCount())
dbSetOrder(4) // emissao
dbSeek(xFilial("SUA")+DTOS(MV_PAR01),.T.)

While !EOF() .and. SUA->UA_EMISSAO <= MV_PAR02

   IncRegua()
   If lAbortPrint
   	  @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 70
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
	  nLin := 8
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
   achou:=.f.
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
            If (SC5->C5_NOVULT - DATLIB)>=MV_PAR03 .AND. (SC5->C5_NOVULT - DATLIB)<=MV_PAR04
               ImpDET()
               achou:=.t.
            Endif
         Else
            If MV_PAR03=0
               ImpDET()
               achou:=.t.
            Endif
         Endif
      Endif
      dbSelectArea("SC6")
	  dbSkip()
   EndDo
   If Achou
      QtdPed:=QtdPed+1
   Endif
   dbSelectArea("SUA")
   dbSkip()
EndDo

If nLin > 65
   Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
   nLin := 8
Endif   
nLin := nLin + 1
@nLin,90  PSAY "Total de Dias        :"
@nLin,114 PSAY Dias     Picture "@E 999999"
nLin := nLin + 1
@nLin,90  PSAY "Quant.de Pedidos     :"
@nLin,114 PSAY QtdPed   Picture "@E 999999"
nLin := nLin + 1
@nLin,90  PSAY "Quant.de Itens       :"
@nLin,114 PSAY Qtd      Picture "@E 999999"
nLin := nLin + 1
@nLin,90  PSAY "Media de Liberação   :"
@nLin,114 PSAY Dias/Qtd Picture "@E 999.99"

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
    @nLin,00 PSAY SC6->C6_NUM
  	@nLin,10 PSAY SC6->C6_ITEM
   	@nLin,14 PSAY SA1->A1_NREDUZ
   	@nLin,36 PSAY SC6->C6_PRODUTO   
   	@nLin,55 PSAY SUA->UA_EMISSAO    
   	@nLin,65 PSAY DATLIB
   	If !Empty(SC5->C5_NOVULT)
       @nLin,75 PSAY SC5->C5_NOVULT
    Else
       @nLin,75 PSAY DATLIB
    Endif
    If SC6->C6_ENCOMED='N'
       @nLin,86 PSAY 'P/ESTOQ'
   	   @nLin,96 PSAY 'P/ESTOQ'
    Else   
   	   @nLin,85 PSAY SC2->C2_EMISSAO
   	   @nLin,95 PSAY SD3->D3_EMISSAO
   	Endif
   	@nLin,105 PSAY SC6->C6_DATFAT

	Qtd:=Qtd+1
   	If !Empty(SC5->C5_NOVULT)
   	   DiasP:=SC5->C5_NOVULT - DATLIB
   	Else
   	   DiasP:=0
   	Endif
   	Dias:=Dias+DiasP
   	@nLin,117 PSAY DiasP Picture "@E 999"
   	nLin := nLin + 1
Return