#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 16/09/05

User Function MATR110()        // incluido pelo assistente de conversao do AP6 IDE em 16/09/05

      
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ MATR110  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Pedido de Compras - Impressao direta            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LAUTO")
SetPrvt("TAMANHO,TITULO,ARETURN,NOMEPROG,NLASTKEY,NBEGIN")
SetPrvt("ALINHA,ASENHAS,AUSUARIOS,M_PAG,LPEDIDO,ATAMSXG")
SetPrvt("MV_PAR08,MV_PAR12,ASAVREC,NLINOBS,CCEPPICT,CCGCPICT")
SetPrvt("LIMITE,LI,NDESCPROD,NTOTAL,NUMPED,MV_PAR01")
SetPrvt("MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR09,MV_PAR10")
SetPrvt("MV_PAR11,CCONDBUS,NORDER,NTIPO,NORDEM,NREEM")
SetPrvt("COBS01,COBS02,COBS03,COBS04,NCW,NSAVREC")
SetPrvt("CVAR,I,NLINREF,CDESCRI,NLINHA,NTAMDESC")
SetPrvt("ACOLUNA,MV_PAR06,NK,NQUEBRA,NTOTDESC,LNEWALC")
SetPrvt("LLIBER,LIMPLEG,CCOMPRADOR,CALTER,CAPROV,NTOTIPI")
SetPrvt("NTOTICMS,NTOTDESP,NTOTFRETE,NTOTALNF,NTOTSEGURO,AVALIVA")
SetPrvt("NVALIVA,NG,CMENSAGEM,NTOTLINHAS,CALIAS,NREGISTRO")
SetPrvt("COBS,NX,CLIBERADOR,NPOSICAO,NAUXLIN,NTOTNF,_cUsuario")
SetPrvt("CMOEDA,CCGC,EXPC1,EXPC2,AREGISTROS,J")

wnrel	:= "MATR110"
tamanho := "P"
titulo	:= "Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
cDesc1 	:= "Emissao dos pedidos de compras ou autorizacoes de entrega"
cDesc2	:= "cadastradados e que ainda nao foram impressos"
cDesc3	:= " "
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nLastKey         :=0
li       :=80
limite   :=80
lRodape  :=.F.
cString	:= "SC7"                  
_cUsuario := cusername

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto    	     ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
//³ mv_par09               Numero de vias                        ³
//³ mv_par10               Pedidos ? Liberados Bloqueados Ambos  ³
//³ mv_par11               Impr. SC's Firmes, Previstas ou Ambas ³
//³ mv_par12               Qual a Moeda ?                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// AjustaSX1()
Pergunte("MTR110",.F.)
If Upper(FUNNAME())=="MATA121"
   cPerg:=""
   mv_par01 := C7_NUM
   mv_par02 := C7_NUM
   mv_par03 := C7_EMISSAO
   mv_par04 := C7_EMISSAO
   mv_par05 := 2
   mv_par08 := C7_TIPO
   mv_par09 := 1
   mv_par10 := 3
   mv_par11 := 3
Else
   cPerg:="MTR110"
Endif

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verif. conteudo da variavel C. Custo (004) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamSXG  := If(aTamSXG  == NIL, TamSXG("004"), aTamSXG)

RptStatus({|lEnd| C110PC(@lEnd,wnRel,cString)},titulo)
            
Return .T.

Static Function C110PC(lEnd,WnRel,cString)

m_pag    := 1
nPag     := 0
@ 0,0 PSay AvalImp(limite)

nReem
nOrder
cCondBus
nSavRec
aSavRec := {}
nLinObs := 0 

Private cCGCPict, cCepPict
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

nDescProd:= 0
nTotal   := 0
nTotMerc := 0
NumPed   := Space(6)

dbSelectArea("SC7")
SetRegua(1)

cCondBus	:=mv_par01
nOrder	:=	1
cEndere	:= SM0->M0_ENDENT
cCidEst	:= SM0->M0_CIDENT
cTel    := SM0->M0_TEL

dbSelectArea("SC7")
dbSetOrder(nOrder)
SetRegua(RecCount())
dbSeek(xFilial("SC7")+cCondBus,.T.)

While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. ;
		C7_NUM <= mv_par02
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
	   (C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif
	If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	If C7_TIPO == 2
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf
	dEmissao := SC7->C7_EMISSAO
		
	MaFisEnd()
	MaFisIniPC(SC7->C7_NUM)

	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas
		
		ImpCabec()
		
		nTotal   := 0
		nTotMerc	:= 0
		nDescProd:= 0
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
        nLinObs  := 0

		While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed
		
			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			
			IncRegua()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se havera salto de formulario                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If li > 56
				nOrdem++
				ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec()
			Endif
			
			li++
			
 		    @ li,  0      PSAY "|" + Substr(C7_ITEM,3,2) + "|"
//		    @ li,PCol()   PSAY SUBSTR(C7_PRODUTO,1,11) + "|"

            cDesc := " "
//            dbSelectArea("SB1")
//            dbSeek(xFilial()+SC7->C7_PRODUTO)
            cDescri := SC7->C7_DESCRI
            dbSelectArea("SA5")
            dbSetOrder(1)
            If dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO).And. !Empty(SA5->A5_CODPRF)
               cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
            EndIf
            dbSelectArea("SC7")
            nBegin:=0
            @ li,Pcol()  PSAY SubStr(cDescri,1,24) + "|"
            @ li,Pcol()  PSAY SC7->C7_UM
            @ li,Pcol()  PSAY "|"
            If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM) 
               @li,Pcol() PSAY  SC7->C7_QTSEGUM Picture "@E 9999999.9999"
            Else
               @li,Pcol() PSAY  SC7->C7_QUANT Picture "@E 9999999.9999"
            Endif
            @li,Pcol()   PSAY "|"
            @ li,PCOL()	 PSAY SC7->C7_PRECO Picture "@E 99999.9999"
            @ li,Pcol()  PSAY "|"
            @ li,Pcol()  PSAY SC7->C7_TOTAL Picture "@E 9999999.99"
            @ li,Pcol()  PSAY "|"
            @ li,Pcol()  PSAY SC7->C7_IPI Picture PesqPictQt("C7_IPI",5)
            @ li,Pcol()  PSAY "|"
            @ li,Pcol()  PSAY  SC7->C7_DATPRF 
            @ li,Pcol()  PSAY "|"
              
            If Len(Trim(cDescri))>24
               For nBegin := 25 To Len(Trim(cDescri)) Step 24
            	   li++
                   @ li,  0      PSAY "|  |"
        	       @ li,Pcol()   PSAY Substr(cDescri,nBegin,24)
                   @ li,Pcol()   PSAY "|  |            |          |          |     |        |"
               Next nBegin 
            Endif
            li++
            @ li,000 PSAY "|"+Replicate("-",limite)+"|"
			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
            nTotal  :=nTotal+SC7->C7_TOTAL
            nTotMerc:=MaFisRet(,"NF_TOTAL")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !EMPTY(SC7->C7_OBS) .And. nLinObs < 5
                nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			
			dbSkip()
		EndDo
		
		dbGoto(nSavRec)

		If li>38
			nOrdem++
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec()
		Endif

 	    li++
		FinalPed(nDescProd)		// Imprime os dados complementares do PC

	Next

	MaFisEnd()
		
    @ li,000 PSAY chr(18)
	If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			Replace C7_EMITIDO With "S"
			MsUnLock()
		Next
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	Endif
	
	aSavRec := {}
	
	dbSkip()
EndDo

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

lPedido := .F.

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/05 ==> Static Function FinalPed(nDescProd)
Static Function FinalPed(nDescProd)

nTotDesc  := nDescProd
nTotIpi	  := MaFisRet(,'NF_VALIPI')
nTotIcms  := MaFisRet(,'NF_VALICM')
nTotDesp  := MaFisRet(,'NF_DESPESA')
nTotFrete := MaFisRet(,'NF_FRETE')
nTotalNF  := MaFisRet(,'NF_TOTAL')
nTotSeguro:= MaFisRet(,'NF_SEGURO')
aValIVA   := MaFisRet(,"NF_VALIMP")

nk 		  := 0
nTotLinhas :=  39
While li<nTotLinhas
	@ li,000 PSAY "|  |"
//	If Pcol() + nk < 28
    @ li,Pcol() + nk PSAY "*"
	nk := IIf( nk == 23 , 0 , nk + 1 )
	@ li,028 PSAY "|  |            |          |          |     |        |"
	li++
EndDo
@ li,000 PSAY "|"+Replicate("-",limite)+"|"            
li++  

PswOrder(2) // POSICIONA NO USUARIO
PswSeek(SUBSTR(cUsuario,7,15))      

if alltrim(substr(cusuario,7,15)) = "Angelo" .or. Upper(Trim(_cUsuario)) = "SRIBEIRO" .or. alltrim(substr(cusuario,7,15)) = "amoreira"
                                                                                                                                           
   @ li,000 PSAY "|          H O R A R I O    D E    D E S C A R G A    N A    N O V E L           |"
   li++                                                                                                                                             
   @ li,000 PSAY "|                 0 7 : 2 8    A S    1 5 : 0 0    H O R A S                     |"
   li++
else
   @ li,000 PSAY "|          H O R A R I O    D E    D E S C A R G A    N A    N O V E L           |"
   li++                                                                                                                                             
   @ li,000 PSAY "|                 0 8 : 00    A S    1 7 : 0 0    H O R A S                      |"
   li++
endif   

@ li,000 PSAY "|                                                                                |"
li++
@ li,000 PSAY "|NOTA: So aceitaremos a mercadoria se na sua NF constar o numero deste Pedido.   |"
@ li,000 PSAY "|      Nao acataremos boletos negociados com factoring, bem como os pagamentos   |"
@ li,000 PSAY "|      serão feitos com Boleto Bancario.O Vencimento da(s) fatura(s) devera(o)   |"
@ li,000 PSAY "|      ser agendado(s) para o(s) dia(s) 15 ou 30 de cada mês subsequente à data  |"
@ li,000 PSAY "|      de emissao da NF. Nao efetuaremos nemhum pagamento fora dessa(s) data(s)  |"
@ li,000 PSAY "|      O Recebimento de mercadorias será feito até o dia 26 de cada mês.         |" 
@ li,000 PSAY "|"+Replicate("-",limite)+"|"            
li++                                                    
dbSelectArea("SC1")                                                      
dbSetOrder(1)                      
dbSeek(xFilial()+SC7->C7_NUMSC)
cSolic:=SC1->C1_SOLICIT 
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")

@ li,000      PSAY "| Condicao de Pagto          | Data Emissao | Total Mercadorias : "
@ li,Pcol()   PSAY nTotal Picture "@E 999,999,999.99"
@ li,081      PSAY "|"
li++
@ li,000      PSAY "|"
@ li,002      PSAY SubStr(SE4->E4_DESCRI,1,26)
@ li,029      PSAY "|   "
@ li,Pcol()   PSAY SC7->C7_EMISSAO
@ li,Pcol()   PSAY "   | Total Impostos    : "
@ li,Pcol()   PSAY nTotMerc Picture "@E 999,999,999.99"
@ li,081      PSAY "|"

li++
@ li,000      PSAY "|"+Replicate("-",limite)+"|"            
li++         

@ li,000      PSAY "| Frete: "
@ li,Pcol()   PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
@ li,027      PSAY "IPI      : "
@ li,Pcol()   PSAY nTotIPI Picture "@E 999,999,999.99"
@ li,052      PSAY "ICMS        : "
@ li,Pcol()   PSAY nTotIcms Picture "@E 999,999,999.99"
@ li,081      PSAY "|"

li++
@ li,000      PSAY "|"
@ li,027      PSAY "Frete    : " 
@ li,Pcol()   PSAY nTotFrete Picture "@E 999,999,999.99"
@ li,052      PSAY "Despesas    : "
@ li,Pcol()   PSAY nTotDesp Picture "@E 999,999,999.99"
@ li,081      PSAY "|"

li++

@ li,000      PSAY "|"
@ li,027      PSAY "DESCONTO : "
@ li,Pcol()   PSAY nTotDesc Picture "@E 999,999,999.99"
@ li,052      PSAY "Seguro      : "
@ li,Pcol()   PSAY nTotSeguro Picture "@E 999,999,999.99"
@ li,081      PSAY "|"
li++         

@ li,000      PSAY "|"
@ li,046      PSAY "Total Geral   :"
@ li,Pcol()   PSAY nTotalNF Picture "@E 999,999,999,999.99"
@ li,081      PSAY "|"
li++

@ li,000      PSAY "|"+Replicate("-",limite)+"|"            
li++         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs := cObs01
		cObs01 := Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

@ li,000 PSAY "| Observacoes                                        | Solicitante               |"
li++
@ li,000 PSAY "|"
@ li,002 PSAY cObs01
@ li,053 PSAY "|"
@ li,055 PSAY cSolic
@ li,081 PSAY "|"
li++
@ li,000 PSAY "|"
@ li,002 PSAY cObs02
@ li,053 PSAY "|"
@ li,081 PSAY "|"
li++
@ li,000 PSAY "|"
@ li,002 PSAY cObs03
@ li,053 PSAY "|"
@ li,081 PSAY "|"
li++

@ li,000      PSAY "|"+Replicate("-",limite)+"|"            
li++         
@ li,000 PSAY "|     GERIN           |     Comprador     |    CONTROLLER     |    Diretoria     |"
li++         
@ li,000 PSAY "| Liberacao do Pedido |                   |                   |                  |"
li++         
@ li,000 PSAY "|                     |                   |                   |                  |"
li++         
@ li,000 PSAY "|                     |                   |                   |                  |"
li++         
@ li,000      PSAY "|"+Replicate("-",limite)+"|"            
li++         

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/05 ==> Static Function ImpRodape()
Static Function ImpRodape()
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,134 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,070 PSAY "Continua ..."
@ li,134 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,134 PSAY "|"
li:=0
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/05 ==> Static Function ImpCabec()
Static Function ImpCabec()

cMoeda := Iif(mv_par12<10,Str(mv_par12,1),Str(mv_par12,2))
nPag ++

If nOrdem<2                        

PswOrder(2) // POSICIONA NO USUARIO
PswSeek(SUBSTR(cUsuario,7,15))      
                   
    
   if alltrim(substr(cusuario,7,15)) = "Angelo" .or. Upper(Trim(_cUsuario)) = "SRIBEIRO"  .or. alltrim(substr(cusuario,7,15)) = "amoreira" 
      @ 1 ,000 PSAY "|"+Replicate("-",limite)+"|"
      @ 2 ,000 PSAY "| "+ "PLASTICOS NOVEL DO NORDESTE LTDA"
      @ 2 ,081 PSAY "|"
      @ 3 ,000 PSAY "| "+ ALLTRIM(cEndere) + " - " + ALLTRIM(cCidEst) + " - CEP : 42700-000"
      @ 3 ,081 PSAY "|"
      @ 4 ,000 PSAY "| Tel.: "+cTel + "       CNPJ/CPF 13926910000141            IE:01224632      |"
      dbSelectArea("SC7") 
      @ 5,000 PSAY "| "+"COMPRADOR: "+"ANGELO MOREIRA"+" angelo@novel.com.br"
      @ 5 ,081 PSAY "|"
      @ 6 ,000 PSAY "| Tel: (71)3369-8114 - Fax: (71)3379-1292"
      @ 6 ,081 PSAY "|"
      @ 7 ,000 PSAY "|"+Replicate("-",limite)+"|"
      @ 8 ,000 PSAY "| P E D I D O  D E  C O M P R A S - " 
      @ 8 ,PCol()   PSAY SC7->C7_NUM
      @ 8 ,PCol()+6 PSAY " EMISSAO: "
      @ 8 ,PCol()   PSAY dEmissao
      @ 8 ,PCol()+5 PSAY "Pag.: " + STRZERO(nPag,4) + "|"
      @ 9,000 PSAY "|"+Replicate("-",limite)+"|"
   ELSE                                      
      IF cNumEmp = "2001" 
         @ 1 ,000 PSAY "|"+Replicate("-",limite)+"|"
         @ 2 ,000 PSAY "| "+"PLASTICOS NOVEL DO PARANA S/A"
         @ 2 ,081 PSAY "|"
         @ 3 ,000 PSAY "| "+"RUA LUIZ CARLOS ZANI, 2949 - PQ.INDUSTRIAL 3"+", IBIPORA-PR - CEP : 86200-000"
         @ 3 ,081 PSAY "|"
         @ 4 ,000 PSAY "| Tel.: "+"(43)3258-8003 - Fax:(43)3258-8020" + " CNPJ:803190640001-99  IE:60500471-70" 
         @ 4 ,081 PSAY "|"
         dbSelectArea("SC7") 
         @ 5,000 PSAY "| "+"COMPRADORA:"+" FATIMA "+" fatima@novel.com.br"
         @ 5 ,081 PSAY "|"
         @ 6 ,000 PSAY "| Tel: (43)3258-8003 - Fax:(43)32588020"
         @ 6 ,081 PSAY "|"
         @ 7 ,000 PSAY "|"+Replicate("-",limite)+"|"
         @ 8 ,000 PSAY "| P E D I D O  D E  C O M P R A S - " 
         @ 8 ,PCol()   PSAY SC7->C7_NUM
         @ 8 ,PCol()+6 PSAY " EMISSAO: "
         @ 8 ,PCol()   PSAY dEmissao
         @ 8 ,PCol()+5 PSAY "Pag.: " + STRZERO(nPag,4) + "|"
         @ 9,000 PSAY "|"+Replicate("-",limite)+"|" 
      ENDIF                                                        
      
      IF cNumEmp = "3001" 
         @ 1 ,000 PSAY "|"+Replicate("-",limite)+"|"
         @ 2 ,000 PSAY "| "+"EPPPLAST IND E COM DE PLASTICOS LTDA"
         @ 2 ,081 PSAY "|"
         @ 3 ,000 PSAY "| "+"RUA GUARA 161 - PQ.INDUSTRIAL 3"+", IBIPORA-PR - CEP : 86200-000"
         @ 3 ,081 PSAY "|"
         @ 4 ,000 PSAY "| Tel.: "+"(43)3258-8003 - Fax:(43)3258-8020" + " CNPJ:803190640001-99  IE:60500471-70" 
         @ 4 ,081 PSAY "|"
         dbSelectArea("SC7") 
         @ 5,000 PSAY "| "+"COMPRADORA:"+" FATIMA "+" fatima@novel.com.br"
         @ 5 ,081 PSAY "|"
         @ 6 ,000 PSAY "| Tel: (43)3258-8003 - Fax:(43)32588020"
         @ 6 ,081 PSAY "|"
         @ 7 ,000 PSAY "|"+Replicate("-",limite)+"|"
         @ 8 ,000 PSAY "| P E D I D O  D E  C O M P R A S - " 
         @ 8 ,PCol()   PSAY SC7->C7_NUM
         @ 8 ,PCol()+6 PSAY " EMISSAO: "
         @ 8 ,PCol()   PSAY dEmissao
         @ 8 ,PCol()+5 PSAY "Pag.: " + STRZERO(nPag,4) + "|"
         @ 9,000 PSAY "|"+Replicate("-",limite)+"|" 
      ENDIF
      
      IF cNumEmp = "4001" 
         @ 1 ,000 PSAY "|"+Replicate("-",limite)+"|"
         @ 2 ,000 PSAY "| "+"PLASTCAIXAS - IND. E COM. DE PLASTICOS LTDA"
         @ 2 ,081 PSAY "|"
         @ 3 ,000 PSAY "| "+"RUA GUARA 161 FUNDOS - PQ.INDUSTRIAL 3"+", IBIPORA-PR - CEP : 86200-000"
         @ 3 ,081 PSAY "|"
         @ 4 ,000 PSAY "| Tel.: "+"(43)3258-8003 - Fax:(43)3258-8020" + " CNPJ:803190640001-99  IE:60500471-70" 
         @ 4 ,081 PSAY "|"
         dbSelectArea("SC7") 
         @ 5,000 PSAY "| "+"COMPRADORA:"+" FATIMA "+" fatima@novel.com.br"
         @ 5 ,081 PSAY "|"
         @ 6 ,000 PSAY "| Tel: (43)3258-8003 - Fax:(43)32588020"
         @ 6 ,081 PSAY "|"
         @ 7 ,000 PSAY "|"+Replicate("-",limite)+"|"
         @ 8 ,000 PSAY "| P E D I D O  D E  C O M P R A S - " 
         @ 8 ,PCol()   PSAY SC7->C7_NUM
         @ 8 ,PCol()+6 PSAY " EMISSAO: "
         @ 8 ,PCol()   PSAY dEmissao
         @ 8 ,PCol()+5 PSAY "Pag.: " + STRZERO(nPag,4) + "|"
         @ 9,000 PSAY "|"+Replicate("-",limite)+"|" 
      ENDIF
         
   endif
   dbSelectArea("SA2")
   dbSetOrder(1)        
   dbgotop()
   dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
   @ 10,000 PSAY "| " + ALLTRIM(SubStr(A2_NOME,1,40))+" ("+A2_COD+")"
   @ 10,052 PSAY "I.E.: " + SA2->A2_INSCR
   @ 10,081 PSAY "|"
   @ 11,000 PSAY "| " + ALLTRIM(A2_END) + ALLTRIM(A2_BAIRRO)
   @ 11,081 PSAY "|"                                                                         
   @ 12,000 PSAY "| " + ALLTRIM(A2_MUN) + " - " + A2_EST + "   CEP : "
   @ 12,PCOL() PSAY A2_CEP    		Picture PesqPict("SA2","A2_CEP")
   @ 12,052 PSAY "CNPJ/CPF : "
   @ 12,PCOL() PSAY A2_CGC    		Picture PesqPict("SA2","A2_CGC")
   @ 12,081 PSAY "|"                                                                         
   dbSelectArea("SC7")
   @ 13,000 PSAY "| " + SC7->C7_CONTATO
   @ 13,020 PSAY "Fone: " + Substr(SA2->A2_TEL,1,15)
   @ 13,052 PSAY "Fax : " + ALLTRIM(Substr(SA2->A2_FAX,1,15))
   @ 13,081 PSAY "|"
   @ 14,000 PSAY "| " + SA2->A2_EMAIL
   @ 14,081 PSAY "|"
   @ 15,000 PSAY "|"+Replicate("-",limite)+"|"
   li := 16
Else
   @ 0 ,000 PSAY "|"+Replicate("-",limite)+"|"
   @ 1 ,000 PSAY "| Continuacao .. P E D I D O  D E  C O M P R A S - " 
   @ 1 ,PCol()   PSAY SC7->C7_NUM
   @ 1 ,PCol()+5 PSAY " EMISSAO: "
   @ 1 ,PCol()   PSAY dEmissao
   @ 1 ,PCol()+5 PSAY "Pag.: " + STRZERO(nPag,4) + "|"
   @ 2 ,000 PSAY "|"+Replicate("-",limite)+"|"
   li := 3
Endif
@ li,000 PSAY "|It|Descricao               |UN|  Quant.    | Vl. Unit.|Vl. Total |IPI% |Entrega |"
//             |01|99999999999|XXXXXXXXXXXX|XX|       2,00 |          |     |          |15/12/05|
//@ li,000 PSAY "|It|   Codigo  |Descricao   |UM|  Quant.    | Vl. Unit.|Vl. Total |IPI% |Entrega |"
//               |01|99999999999|XXXXXXXXXXXX|XX|       2,00 |          |     |          |15/12/05|
li++
@ li,000 PSAY "|"+Replicate("-",limite)+"|"
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R110Center³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centralizar o Nome do Liberador do Pedido.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := R110CenteR(ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do Liberador                                 ³±±
±±³Parametros³ ExpC2 := Nome do Liberador Centralizado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/05 ==> Static Function R110Center(cLiberador)
Static Function R110Center(cLiberador)
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³Alexandre Inacio Lemes³Data³ 11/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/05 ==> Static Function AjustaSX1()
Static Function AjustaSX1()
cAlias := Alias()
aRegistros:={}
j:=0
i:=0
Aadd(aRegistros,{"MTR110","12","Qual a Moeda       ?"," Cual Moneda       ?","Which Currency     ?","mv_chc","N",1,0,1,"C","","mv_par12" ;
,"Moeda 1","Moneda 1","Currency 1","","","Moeda 2","Moneda 2","Currency 2","","" ;
,"Moeda 3","Moneda 3","Currency 3","","","Moeda 4","Moneda 4","Currency 4","","" ;
,"Moeda 5","Moneda 5","Currency 5","","",""})

dbSelectArea("SX1")
For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next j
		MsUnlock()
	EndIf
Next I
dbSelectArea(cAlias)
Return NIL

