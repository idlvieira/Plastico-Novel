#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 09/10/03

User Function MATR150()        // incluido pelo assistente de conversao do AP6 IDE em 09/10/03

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ MATR150  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao das Cotacoes - Impressão direta                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

nSegundaUnid:=""
wnrel :=""
cDesc1:="Emissao das cotacoes de compras"
cDesc2:=""
cDesc3:=" "
Tamanho:="P"
li     :=80
limite :=80
m_pag  := 1
nPag   := 0
cTel   :=""
titulo:="Relacao de Cotacoes"
aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog:="MATR150"
nLastKey := 0
cString :="SC8"

If Upper(FUNNAME())=="MATA130"
   cPerg := "MR150A" // Impressao direta
Else   
   cPerg  :="MTR150"
Endif
wnrel  := "MATR150"

static aTamSXG
static aTamSXG2

pergunte(cPerg,.F.)

// Verifica conteudo da variavel static p/ Grupo Fornec. (001) e Loja (002)
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey = 27
	Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

If Upper(FUNNAME())=="MATA130"
   nSegundaUnid := mv_par06		// Grupo MR150A
   cTel     := mv_par07
   mv_par09 := mv_par05
   mv_par08 := mv_par04
   mv_par07 := mv_par03
   mv_par06 := mv_par02
   mv_par05 := mv_par01
   mv_par01 := SC8->C8_NUM
   mv_par02 := SC8->C8_NUM
   mv_par03 := "      "
   mv_par04 := "ZZZZZZ"
Else
   nSegundaUnid := mv_par10
   cTel         := mv_par11		// Grupo MR150A
Endif   

RptStatus({|lEnd| R150Imp(lEnd,wnrel,cString,cTel)},Titulo)
                 
Return 

Static Function R150Imp(lEnd,wnrel,cString,cTel)

@ 0,0 PSay AvalImp(limite)

cNumero:=""
nItem:=""
cFornece:=""
cLoja:=""
cDescri:=""
cabec1:= ""
cabec2:= ""
cabec3:= ""
cbCont:= 0
cContato:=""
dEmissao:=""
cEndere	:= Iif(Empty(MV_PAR07), Iif(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT), MV_PAR07)
cCidEst	:= Iif(Empty(MV_PAR08), Iif(Empty(SM0->M0_CIDENT+SM0->M0_ESTENT), ALLTRIM(SM0->M0_CIDCOB) + "-" + SM0->M0_ESTCOB,  ALLTRIM(SM0->M0_CIDENT) + "-" + SM0->M0_ESTENT),MV_PAR08)
cFax	:= Iif(Empty(MV_PAR09), SM0->M0_FAX, MV_PAR09)
cTel    := Iif(Empty(cTel), SM0->M0_TEL, cTel)
dbSelectArea("SC8")
dbSetOrder(1)
Set SoftSeek On
dbSeek(xFilial()+mv_par01)
Set SoftSeek Off

SetRegua(RecCount())

While xFilial() = C8_FILIAL .And. C8_NUM >= mv_par01 .And. C8_NUM <= mv_par02 .And. !Eof()
        
	IncRegua()
	
	IF C8_FORNECE < mv_par03 .OR. C8_FORNECE > mv_par04
		dbSkip()
		Loop
	Endif

	IF C8_VALIDA > mv_par05
		dbSkip()
		Loop
	Endif

	cContato := SC8->C8_CONTATO
	dEmissao := SC8->C8_EMISSAO

	IF li > 58
		nPag ++
        @ 1 ,000 PSAY "|"+Replicate("-",limite)+"|"
		@ 2 ,000 PSAY "| "+ SM0->M0_NOMECOM
        @ 2 ,081 PSAY "|"
		@ 3 ,000 PSAY "| "+ ALLTRIM(cEndere) + " - " + ALLTRIM(cCidEst) + " - " + cTel
        @ 3 ,081 PSAY "|"
		@ 4 ,000 PSAY "|"
        @ 4 ,081 PSAY "|"
		@ 5 ,000 PSAY "| COMPRADORA: DENISE MASCARENHAS - denisemascarenhas@novel.com.br"
        @ 5 ,081 PSAY "|"
        @ 6 ,000 PSAY "| Tel: (71)3369-8114 - Fax: 3379-1292"
        @ 6 ,081 PSAY "|"
        @ 7 ,000 PSAY "|"+Replicate("-",limite)+"|"
		@ 8 ,000 PSAY "| C O T A C A O - " 
		@ 8 ,PCol() PSAY SC8->C8_NUM
        @ 8 ,038 PSAY " EMISSAO: "
		@ 8 ,PCol() PSAY dEmissao
		@ 8 ,069 PSAY "Pagina: " + STRZERO(nPag,4) + "|"
        @ 9 ,000 PSAY "|"+Replicate("-",limite)+"|"
		@ 10,000 PSAY "| PREZADOS SENHORES"
		@ 10,081 PSAY "|"
		dbSelectArea("SA2")
		dbSeek(xFilial()+SC8->C8_FORNECE+SC8->C8_LOJA)
   		@ 11,000 PSAY "| " + ALLTRIM(SubStr(A2_NOME,1,40))+" ("+A2_COD+" - "+A2_LOJA+")"  		
        @ 11,081 PSAY "|"
		@ 12,000 PSAY "| " + ALLTRIM(A2_END) + ALLTRIM(A2_BAIRRO)
        @ 12,081 PSAY "|"
		@ 13,000 PSAY "| Fone: " + Substr(SA2->A2_TEL,1,15) + "  Fax : "+ALLTRIM(Substr(SA2->A2_FAX,1,15)) + "  E-Mail :"+ALLTRIM(SA2->A2_EMAIL)
        @ 13,081 PSAY "|"
        @ 14,000 PSAY "|                                                                                |"
		@ 15,000 PSAY "| Solicitamos cotacao de precos para os produtos discriminados conforme padroes  |"
		@ 16,000 PSAY "| abaixo estabelecidos:                                                          |"
        @ 17,000 PSAY "|"+Replicate("-",limite)+"|"
		@ 18,000 PSAY "|It|   Codigo  |Descricao     |UM|   Quant. | Vl. Unit.|IPI% |Vl. Total |Entrega |"
//                     |01|99999999999|XXXXXXXXXXXXXX|XX|     2,00 |          |     |          |15/12/05|
        @ 19,000 PSAY "|"+Replicate("-",limite)+"|"
		li:=19
		dbSelectArea("SC8")
		cNumero := C8_NUM
		cFornece:= C8_FORNECE
		cLoja   := C8_LOJA
	Endif
	
	nItem := 0
	While !Eof() .And. C8_NUM == cNumero .And. cFornece == C8_FORNECE .And. C8_LOJA == cLoja
		IF li > 58
			li ++
			li ++
			nPag ++
			@ li,00 PSAY Replicate("-",limite-Len(" Continua ..."))+" Continua ..."
            @ 0 ,000 PSAY "|"+Replicate("-",limite)+"|"
	   	    @ 1 ,000 PSAY "| Continuacao ..    C O T A C A O - " 
		    @ 1 ,PCol()   PSAY SC8->C8_NUM
		    @ 1 ,PCol()+5 PSAY " EMISSAO: "
		    @ 1 ,PCol()   PSAY dEmissao
		    @ 1 ,PCol()+4 PSAY "Pagina: " + STRZERO(nPag,4) + "|"
            @ 2 ,000 PSAY "|"+Replicate("-",limite)+"|"
			li := 3
		Endif
		
		IncRegua()			
		
		li++
		nItem++
		@li,  0      PSAY "|" + StrZero(nItem,2) + "|"
		@li,PCol()   PSAY SUBSTR(C8_PRODUTO,1,11) + "|"

        cDesc := " "
        cDescri := " "
        nLinRef := 1

        If Empty(mv_par06) 
           mv_par06 := "B1_DESC"
        EndIf 
        If AllTrim(mv_par06) == "B5_CEME"
           dbSelectArea("SB5")
           dbSetOrder(1)
           If dbSeek(xFilial()+SC8->C8_PRODUTO)
          	  cDescri := B5_CEME
           EndIf
        ElseIf AllTrim(mv_par06) == "A5_NOMPROD"
           dbSelectArea("SA5")
           dbSetOrder(1)
           If dbSeek(xFilial()+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_PRODUTO)
        	  cDescri := A5_NOMPROD
           EndIf
        EndIf
        If AllTrim(mv_par06) == "C1_DESCRI"
           dbSelectArea("SC1")
           dbSetOrder(1)
           If dbSeek(xFilial()+SC8->C8_NUMSC+SC8->C8_ITEMSC)
              cDescri := C1_DESCRI
           Endif
        EndIf
        If Empty(cDescri)
           dbSelectArea("SB1")
           dbSeek(xFilial()+SC8->C8_PRODUTO)
           cDescri := SB1->B1_DESC
        EndIf

        dbSelectArea("SC8")
        nBegin:=0
        @ li,Pcol()  PSAY SubStr(cDescri,1,14) + "|"
        @ li,Pcol()  PSAY SC8->C8_SEGUM
        @ li,Pcol()  PSAY "|"

        If nSegundaUnid == 2 .And. !Empty(SC8->C8_QTSEGUM) 
           @li,Pcol() PSAY  SC8->C8_QTSEGUM Picture "@E 99999.9999"
        Else
           @li,Pcol() PSAY  SC8->C8_QUANT Picture "@E 99999.9999"
        Endif
        @li,Pcol()   PSAY "|          |     |          |"
        @li,Pcol()   PSAY  SC8->C8_DATPRF 
        @li,Pcol()   PSAY "|"

        XCODPRF:=SPACE(11)
        dbSelectArea("SA5")
        dbSetOrder(2)
        If dbSeek(xFilial()+SC8->C8_PRODUTO+SC8->C8_FORNECE+SC8->C8_LOJA)
           XCODPRF:= Substr(SA5->A5_CODPRF,1,11)
        Endif
        dbSelectArea("SC8")
        If Len(Trim(cDescri))>14
           For nBegin := 15 To Len(Trim(cDescri)) Step 14
            	li++
                @ li,  0      PSAY "|  |"+XCODPRF+"|"
                XCODPRF:=SPACE(11)
        	    @ li,Pcol()   PSAY Substr(cDescri,nBegin,14)
                @ li,Pcol()   PSAY "|  |          |          |     |          |        |"
           Next nBegin 
        Elseif XCODPRF<>SPACE(11)
           li++
           @ li,  0      PSAY "|  |"+XCODPRF+"|              |  |          |          |     |          |        |"
        Endif
        li++
        @li,000 PSAY "|"+Replicate("-",limite)+"|"

		cFilEnt := SC8->C8_FILENT
		dbSkip()
	End

	If li > 50
		li ++
		li ++
		nPag ++
		@ li,00 PSAY Replicate("-",limite-Len(" Continua ..."))+" Continua ..."
        @ 0 ,000 PSAY "|"+Replicate("-",limite)+"|"
	   	@ 1 ,000 PSAY "| Continuacao ..    C O T A C A O - " 
		@ 1 ,PCol()   PSAY SC8->C8_NUM
		@ 1 ,PCol()+5 PSAY " EMISSAO: "
		@ 1 ,PCol()   PSAY dEmissao
		@ 1 ,PCol()+5 PSAY "Pagina: " + STRZERO(nPag,4) + "|"
        @ 2 ,000 PSAY "|"+Replicate("-",limite)+"|"
		li := 3
	Endif
	li:=50
	li++
	@li,000 PSAY "|--------------------------------------------------------------------------------|"
	li++
	@li,000 PSAY "|  Sub Total       :                              | Condicao de Pagamento        |"
	li++
	@li,000 PSAY "|                                                 |                              |"
	li++
	@li,000 PSAY "|  Descontos       :                              |                              |"
	li++
	@li,000 PSAY "|                                                 |                              |"
	li++
	@li,000 PSAY "|  Total do IPI    :                              |                              |"
	li++
	@li,000 PSAY "|                                                 | Condicao de Reajuste         |"
	li++
	@li,000 PSAY "|  Frete           :                              |                              |"
	li++
	@li,000 PSAY "|-------------------------------------------------|                              |"
	li++
	@li,000 PSAY "|                                                 |                              |"
	li++
	@li,000 PSAY "|  TOTAL DO PEDIDO :                              |                              |"
	li++
	@li,000 PSAY "|--------------------------------------------------------------------------------|"
	li++
	dbSelectArea("SC8")
	li := 80
	nPag := 0
End

dbSelectArea("SC8")
Set Filter To
dbSetOrder(1)

dbSelectArea("SA5")
dbSetOrder(1)

If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif

MS_FLUSH()
