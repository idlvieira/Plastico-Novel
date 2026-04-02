#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 04/07/02
#Include "MYFAT02.CH"
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

User Function MYFAT02()        // incluido pelo assistente de conversao do AP5 IDE em 04/07/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ MYFAT02  ³ Autor ³   Marcos L. Santos    ³ Data ³ 01.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Pedido de Venda  (Plasticos Novel)              ³±±
±±³          ³ Alterado por Daniel Gouvea em 24/06/10                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/       
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante      Motivo
// 29/08/2023  Leandro Ferreira          Totvs		   	  Migração para banco

                                                    
SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,ttt")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NTOTIPI,APEDCLI,CSTRING,COMPRA1,MV_PEDDE,MV_PEDATE")
SetPrvt("MV_PAR01,MV_PAR02,NREG,NTOTVALCM,CPEDIDO,CNOMSUP,CCODSUP")
SetPrvt("CHEADER,NPED,CMOEDA,CCAMPO,CCOMIS,CHEADER2")
SetPrvt("CMIDIA,CCIDCLI,CESTCLI,CENDCLI,CCEPCLI,CCOBCLI")
SetPrvt("CENTCLI,CNOMCLI,CCGCCLI,CIECLI,CBAICLI,CBAICOB")
SetPrvt("CCIDCOB,CTELCLI,CFAXCLI,CCONTAT,LSUFRAMA,LZFRANCA")
SetPrvt("CQQCOR,CNATOPER,NIPI,NVIPI,NBASEIPI,NVALBASE")
SetPrvt("NVALITEM,LIPIBRUTO,NPERCIPI,NTOTVALIPI,CGRAV")
SetPrvt("NPERCMFIN,NVALICM,NVALMERC,NPERCICM,CCIFATE,CMODA")
SetPrvt("CTCARGA,NPERRET,CESTADO,TNORTE,CINSCRCLI")

wnrel            := ""
tamanho          := "M"
titulo           := "FORMULARIO DE CUBAGEM E CARREGAMENTO"
cDesc1           := "Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2           := "intervalo informado na op‡„o Parƒmetros."
cDesc3           := " "
nRegistro        := 0
cKey             := ""
nIndex           := ""
cIndex           := ""//  && Variaveis para a criacao de Indices Temp.
cCondicao        := ""
lEnd             := .T.
cPerg            := ""
//aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }   
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
nomeprog         := "MYFAT02"
nLastKey         := 0
nBegin           := 0
aLinha           := { }
li               := 80
limite           := 132
lRodape          := .F.
// cPictQtd         :=""
nTotQtd          := 0
nTotVal          := 0
nTotIPI          := 0
nVlDesc          := 0        
aPedCli          := {}
wnrel            := "MYFAT02"
cString          := "SUB"
COMPRA1	 	     := "" // variavel para definir se eh a 1a. Copra do Cliente
Public nPerc
private nvlicm
private cTES
private cEstCli
private cME
//X:=Upper(FUNNAME())

If TYPE("uPorPrograma") == "U"
   cPerg            :="MTR730"
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Variaveis utilizadas para parametros                        ³
   //³ mv_par01              Do Pedido                             ³
   //³ mv_par02              Ate o Pedido                          ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   pergunte(cPerg,.F.)
   wnrel :=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
Else
   mv_pedde  := SC5->C5_NUM
   mv_pedate := SC5->C5_NUM
   wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
Endif

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

#IFDEF WINDOWS
    RptStatus({||C730Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 04/07/02 ==>     RptStatus({||Execute(C730Imp)})
    Return
// Substituido pelo assistente de conversao do AP5 IDE em 04/07/02 ==>     Function C730IMP
Static Function C730IMP()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho        := "M"
titulo         := "FORMULARIO DE CUBAGEM E CARREGAMENTO"
cDesc1         := "Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2         := "intervalo informado na op‡„o Parƒmetros."
cDesc3         := " "
nRegistro      := 0
cKey           := ""
nIndex         := ""
cIndex         := "" //  && Variaveis para a criacao de Indices Temp.
cCondicao      := ""
Private _totFrete := 0
@ 0,0 PSay AvalImp(limite)
pergunte("MTR730",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Do Pedido                             ³
//³ mv_par02              Ate o Pedido                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Val(AllTrim(mv_pedate)) > Val(Alltrim(mv_pedde))
   nReg := Val(mv_pedate) - Val(mv_pedde)
Else
   nReg := 10
Endif
  
SetRegua(nReg)  // (RecCount())		// Total de Elementos da regua

If TYPE("uPorPrograma") == "U"
   mv_pedde  := mv_par01
   mv_pedate := mv_par02
Endif

Dbselectarea("SC5")
Dbsetorder(1)
Dbseek(xFilial()+mv_pedde,.T.)
nTotQtd   := 0
nTotVal   := 0
nTotValCM := 0
nTotIPI   := 0

While !Eof() .And. SC5->C5_NUM <= mv_pedate
	_totFrete := 0	
   	nTotQtd   := 0
   	nTotVal   := 0
    nTotValCM := 0
    nTotIPI   := 0        
	
    DbSelectArea("SUA")
    DbSetOrder(8)
    DbSeek(xFilial()+SC5->C5_NUM,.T.)
    xNum := SUA->UA_NUM
	dbSelectArea("SA4")
	dbSeek(xFilial()+SUA->UA_TRANSP)
	dbSelectArea("SA3")
    dbSeek(xFilial()+SUA->UA_SUPLENT)
    cNomSup := A3_NREDUZ
    cCodSup := A3_COD
	dbSeek(xFilial()+SUA->UA_VEND)
	dbSelectArea("SE4")
	dbSeek(xFilial()+SUA->UA_CONDPG)
	
	
	nRegistro:= RECNO()
	#IFNDEF WINDOWS
	If LastKey() == 286    //ALT_A
		lEnd := .t.
		exit
	End
	#ENDIF
	
	IF LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tabela de pedidos do cliente p/ o cabe‡alho            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        nBaseIcm:=0
      	li := 0
	    SetPrc(0,0)
       	ImpCabec()
	
    fGrav := "FG -> "
	dbSelectArea("SUB")
    DbSetOrder(1)
    dbgotop()
	dbSeek(xFilial()+xNum,.T.)
	While !Eof() .And. SUB->UB_NUM == xNum
		#IFNDEF WINDOWS
		If LastKey() == 286    //ALT_A
			lEnd := .t.
		End
		#ENDIF
		
		IF LastKey()==27
			@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
        If li > 34
        	If lRodape
            	li := 35
                ImpRodape()
                lRodape := .F.
			    li:=li+5
       		Endif
       Endif    
       
       nBaseIcm:=nBaseIcm+SUB->UB_BASEICM
		
		ImpItem()
		dbSkip()
		li := li+1
	Enddo


	nVlDesc:=0
	IF lRodape
 		li := 35                
   	    ImpRodape()
	   	lRodape:=.F.
	   	li:=li+2
	Endif

	dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RetIndex("SUA")  

dbSelectArea("SUB")
dbSetOrder(1)
dbGotop()
Set device to screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 04/07/02 ==> Function ImpCabec

Static Function ImpCabec()

@ li, 000 PSAY CHR(15)

lRodape     := .T.
cHeader     := ""
nPed        := ""
cMoeda      := ""
cCampo      := ""
cComis      := ""
//             0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111
//              0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333
//              0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

cHeader     := "CODIGO      PRODUTO - MARCA - COR                          QUANTIDADE            OBSERVAÇÃO"

                                                                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMidia := ""

DbSelectArea("SUH")
DbSeek(xFilial()+SUA->UA_MIDIA,.T.)
cMidia:=SUH->UH_DESC
	
dbSelectArea("SA1")
dbSeek(xFilial()+SUA->UA_CLIENTE+SUA->UA_LOJA)
cCidCli  := Alltrim(SA1->A1_MUN)
cEstCli  := Alltrim(SA1->A1_EST)
cEndCli  := Alltrim(SA1->A1_END)
cCepCli  := AllTrim(SA1->A1_CEP)
cCobCli  := Alltrim(SA1->A1_ENDCOB)
cEntCli  := Alltrim(SA1->A1_ENDENT)
cNomCli  := Alltrim(SA1->A1_NOME)
cCgcCli  := Alltrim(SA1->A1_CGC)
cIECli   := Alltrim(SA1->A1_INSCR)
cBaiCli  := AllTrim(SA1->A1_BAIRRO)
cBaiCob  := AllTrim(SA1->A1_BAIRROC)
cCidCob  := AllTrim(SA1->A1_MUNC)
cTelCli  := AllTrim(SA1->A1_TEL)
cFaxCli  := AllTrim(SA1->A1_FAX)
cContat  := AllTrim(SA1->A1_CONTATO)
lSuframa := IIF(Len(AllTrim(SA1->A1_SUFRAMA))>0,.T.,.F.)
lZFranca := IIF(Len(AllTrim(SA1->A1_CODMUN))>0,.T.,.F.)
nPerc    := 100 - SA1->A1_DESC
cME      := SA1->A1_ME
If (A1_PRICOM == A1_ULTCOM)
	COMPRA1 := "SIM"
Else
	COMPRA1 := "NAO"
EndIf

dbSelectArea("SUA")
AUTENT := ""
If (UA_AUTENT == "S")
	AUTENT := "SIM"
EndIf
If (UA_AUTENT == "N")     
	AUTENT := "NAO"
EndIf     
Dbselectarea("SC5")
Dbsetorder(1)
Dbseek(xFilial()+SUA->UA_NUMSC5,.T.)
                                    
Dbselectarea("SA3")
Dbsetorder(1)
Dbseek(xFilial()+SC5->C5_VEND2,.T.)


cCIFAte := ""

If SC5->C5_TPFRETE="C"
   cCIFAte := "Cif (pago) ate "+AllTrim(SUA->UA_CIF_ATE)
Else
   cCIFAte := "FOB (a pagar) "+AllTrim(SUA->UA_CIF_ATE)
EndIf      

//@ li,000 PSAY Replicate("-",limite)
//li := li+1

cTCarga := ""
If (SUA->UA_TPCARGA == "C")
   cTCarga := "Completa"
ElseIf (SUA->UA_TPCARGA == "F")
   cTCarga := "Francionada"
ElseIf (SUA->UA_TPCARGA == "R")
   cTCarga := "Retira"
EndIf

@ 01,000 PSAY  SM0->M0_NOMECOM
@ 01,100 PSAY "PEDIDO Num: "+CHR(18)+SUA->UA_NUMSC5+CHR(15)
@ 02,000 PSAY SM0->M0_ENDCOB +" "+"CEP "+SM0->M0_CEPCOB+"    "+SM0->M0_CIDCOB+"   Parana - Brasil" 
@ 03,000 PSAY "CNPJ: "+SM0->M0_CGC+" "+"INSCRICAO ESTADUAL: "+SM0->M0_INSC
@ 03,080 PSAY "Data: "+dtoc(date())
@ 03,095 PSAY "Hora: "+time()
@ 04,000 PSAY "Fones: "+SM0->M0_TEL+"    Fax: "+SM0->M0_FAX 
@ 05,000 PSAY Replicate("-",limite)
@ 06,000 PSAY "DATA DO PEDIDO: " +DTOC(SUA->UA_EMISSAO) 
@ 06,050 PSAY "DATA ENTREGA: " +DTOC(SUA->UA_DATFAT)
@ 06,090 PSAY "AUT. ENTREGA ANTECIPADA: "+AUTENT
@ 08,000 PSAY "TRANSPORTADORA:"+Substr(SUA->UA_TRANSP,1,3)+" "+Substr(SA4->A4_NOME,1,25)
@ 08,060 PSAY "PLACA/UF____________________________"// MOTORISTA__________________"
//@ 08,115 PSAY "Carga:"+cTCarga
@ 09,000 PSAY Replicate("-",limite)
@ 10,000 PSAY "Cod: "+SUA->UA_CLIENTE +"  Cliente: "+Substr(cNomCli,1,60)
IF SA1->A1_PESSOA = 'J'
   @ 10,070 PSAY "CNPJ/MF:"
   @ 10,090 PSAY cCgcCli Picture "@R 99.999.999/9999-99"
ELSE 
   @ 10,070 PSAY "CPF/MF:"
   @ 10,090 PSAY cCgcCli Picture "@R 999.999.999-99"
ENDIF   
@ 11,000 PSAY Replicate("-",limite)
li:=12
@ li,000 PSAY cHeader
li :=li +1
Static Function ImpItem()
nIPI       := 0
nVipi      := 0
nBaseIPI   := 100
nValBase   := 0
nValItem   := 0
lIpiBruto  := IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)

dbSelectArea("SB1")
dbSeek(xFilial()+SUB->UB_PRODUTO)
dbSelectArea("SF4")
dbSeek(xFilial()+SUB->UB_TES)
gravacao:= Space(120)
gravacao:=SUB->UB_GRAVPV

@ li,000 PSAY Left(SUB->UB_PRODUTO,11)
@ li,012 PSAY Left(SB1->B1_DESC,39)
@ li,059 PSAY SUB->UB_QUANT      Picture "@E 999999.99"
li :=li +1
@ li,000 PSAY "Gravação: "+gravacao
li :=li +1
@ li,000 PSAY Replicate("-",limite)
li :=li+1
RecLock("SUB",.F.)
Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 04/07/02
MsUnLock()
Return( NIL )        // incluido pelo assistente de conversao do AP5 IDE em 04/07/02

Static Function Improdape()

@ li,000 PSAY "_____________________________________________________________________________________________________________________________________"
li :=li +1
@ li,000 PSAY "|             1ª CUBAGEM              |             2ª CUBAGEM              |             3ª CUBAGEM              |     CHAPÉU      |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------|                 |"
li :=li +1
@ li,000 PSAY "|ALTURA        |                      |ALTURA        |                      |ALTURA        |                      |                 |"
li :=li +1
@ li,000 PSAY "|              |                      |              |                      |              |                      |                 |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------|                 |"
li :=li +1
@ li,000 PSAY "|LARGURA       |                      |LARGURA       |                      |LARGURA       |                      |                 |"
li :=li +1
@ li,000 PSAY "|              |                      |              |                      |              |                      |                 |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------|                 |"
li :=li +1
@ li,000 PSAY "|COMPRIMENTO   |                      |COMPRIMENTO   |                      |COMPRIMENTO   |                      |                 |" 
li :=li +1
@ li,000 PSAY "|              |                      |              |                      |              |                      |                 |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------|                 |"
li :=li +1
@ li,000 PSAY "|TOTAL         |                      |TOTAL         |                      |TOTAL         |                      |                 |"
li :=li +1
@ li,000 PSAY "|              |                      |              |                      |              |                      |                 |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------------------------|"
li :=li +1
@ li,000 PSAY "|                                                                                                                                   |"
li :=li +1
@ li,000 PSAY "|CUBAGEM TOTAL: __________________________________________________                                                                  |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------------------------|"
li :=li +1
@ li,000 PSAY "|INSPEÇÃO: (  ) MODELO DO PRODUTO     |     (   ) COR      |     (   ) GRAVAÇÃO     |     (   ) QUANTIDADE   |  (   ) SUJIDADE      |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------------------------|"
li :=li +1
@ li,000 PSAY "|OBSERVAÇÃO:  (  )                                                                                                                  |"
li :=li +1
@ li,000 PSAY "|                                                                                                                                   |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------------------------|"  
li :=li +1
@ li,000 PSAY "|(  ) CONSIDERANDO O QUE CONSTA DO PROCESSO No. 80001.003544/2006-56; ART. 1o. AS DIMENSOES AUTORIZADAS PARA VEICULOS, COM OU SEM   |"
li :=li +1
@ li,000 PSAY "|     CARGA, SAO AS SEGUINTES: I- LARGURA MAXIMA: 2,60M      II- ALTURA MAXIMA: 4,40M                                               |"
li :=li +1  
@ li,000 PSAY "|(  ) CONNFORME VERIFICACAO DOS PRODUTOS NO ATO DO CARREGAMENTO, OS MESMOS ESTAO DENTRO DOS PADROES DE QUALIDADE NOVEL.             |"
li :=li +1
@ li,000 PSAY "|-----------------------------------------------------------------------------------------------------------------------------------|"
li :=li +3
@ li,000 PSAY "_______________________________   ______________________________   _______________________________   _______________________________ "
li :=li +1
@ li,000 PSAY "          CONFERENTE 1                      CONFERENTE 2                      LOGISTICA                         MOTORISTA            " 
li :=li +1
 
Dbselectarea("SC5")
Dbsetorder(1)
Dbseek(xFilial()+SUA->UA_NUMSC5,.T.)
                                    
Dbselectarea("SA3")
Dbsetorder(1)
Dbseek(xFilial()+SC5->C5_VEND2,.T.)


cCIFAte := ""

If SC5->C5_TPFRETE="C"
   cCIFAte := "Cif (pago) ate "+AllTrim(SUA->UA_CIF_ATE)
Else
   cCIFAte := "FOB (a pagar) "+AllTrim(SUA->UA_CIF_ATE)
EndIf      

@ li,000 PSAY Replicate("-",limite)
li := li+1

cTCarga := ""
If (SUA->UA_TPCARGA == "C")
   cTCarga := "Completa"
ElseIf (SUA->UA_TPCARGA == "F")
   cTCarga := "Francionada"
ElseIf (SUA->UA_TPCARGA == "R")
   cTCarga := "Retira"
EndIf


@ li,000 PSAY "Obs do Pedido |" + Substr(SUA->UA_OBS1,1,70) // + Campo MSG1 no SUA
li := li+1
@ li,000 PSAY "Obs do Pedido |" + Substr(SUA->UA_OBS2,1,70) // + Campo MSG2 no SUA
li := li+1
@ li,000 PSAY "Obs do Pedido |" + Substr(SUA->UA_OBS3,1,70) // + Campo MSG3 no SUA
li := li+1
//@ li,000 PSAY Replicate("-",limite)
//li := li+6 
//@ li,000 PSAY chr(18)

Return( NIL )        // incluido pelo assistente de conversao do AP5 IDE em 04/07/02



