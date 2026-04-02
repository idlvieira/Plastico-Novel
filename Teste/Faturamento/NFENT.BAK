#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 17/07/02

User Function NFENT()        // incluido pelo assistente de conversao do AP5 IDE em 17/07/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡„o    ³ NFENT    ³ Autor ³   CHESTER BRAGA       ³ Data ³ 30/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Nota Fiscal de Entrada                            vers„o 1 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

xQtEmbal  := {0,0,0,0,0}
xTpEmbal  := {" "," "," "," "," "}
nValDesc := 0
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
linha:=0
tamanho:="M" 
limite:=132
titulo :="Nota Fiscal Entrada"
cDesc1 :="Este programa ira emitir a Nota Fiscal de Entrada de mercadorias da Novel"
cDesc2 :=""
cDesc3 :=""
cNatureza:="" 
aReturn := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nomeprog:="NFENT" 
cPerg:="MTR740"
nLastKey:= 0 
lContinua := .T.
nLin:=0
linha:=0
z:=0
wnrel    := "NFENT"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=73     // Apenas Informativo 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,,.f.,Tamanho)
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³          
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

VerImp()       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento da Nota Fiscal                       ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 17/07/02 ==> 	RptStatus({|| Execute(RptDetail)})
	Return
// Substituido pelo assistente de conversao do AP5 IDE em 17/07/02 ==> 	Function RptDetail
Static Function RptDetail()
#ENDIF

@ 0,0 PSay AvalImp(limite)

DbSelectArea("SF1")                // * Cabecalho da Nota Fiscal
DbSetOrder(1)
DbSeek( xFilial("SF1") + Mv_Par01, .T. )

While !eof() .and. SF1->F1_DOC    <= Mv_Par02 .and. lContinua      == .T.
  If SF1->F1_SERIE  <> Mv_Par03
	 Dbskip()
	 Loop
  Endif
  x := SF1->F1_DOC
  Y := SF1->F1_SERIE
  Z := SF1->F1_FORNECE
  DbSelectArea("SD1")
  DbSetOrder(1)
  DbSeek( xFilial() + X + Y + Z )
  xD1tes := SD1->D1_TES

  DbSelectArea("SF1")

  //If (SF1->F1_FORMUL == "S" .and. SF1->F1_TIPO == "D") .or.  xD1Tes == "008"
  If SF1->F1_FORMUL == "S"
     SetRegua(Val(mv_par02)-Val(mv_par01))

	 IF LastKey()==286
	    @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	    lContinua := .F.
	    Exit
	 Endif
	 IF lAbortPrint
	    @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	    lContinua := .F.
	    Exit
	 Endif

	 nLinIni := Linha                    // Armazema Linha Inicial da Impressao
  
	 xFornece := SF1->F1_FORNECE         // Fornecedor
	 xDoc     := SF1->F1_DOC             // Numero
	 xSerie   := SF1->F1_SERIE           // Serie
	 xEmissao := SF1->F1_EMISSAO         // Data de Emissao
	 xLoja    := SF1->F1_LOJA            // Loja do Cliente
	 xBaseIcm := SF1->F1_BASEICM         // Base   do ICMS
	 xBaseIpi := SF1->F1_BASEIPI         // Base   do IPI
	 xValIcm  := SF1->F1_VALICM          // Valor  do ICMS
	 xValIpi  := SF1->F1_VALIPI          // Valor  do IPI
	 xValMerc := SF1->F1_VALMERC         // Valor  da Mercadoria
	 xValBrut := SF1->F1_VALBRUT         // Valor  da Mercadoria
	 DbSelectArea("SA4")
	 DbSetOrder(1)
	 If DbSeek( xFilial() + SF1->F1_TRANSP )
		 //Dados da Transportadora
	    xNTransp := A4_NOME
		xPTransp := A4_PLACA
		xUTransp := A4_EST
		xCTransp := A4_CGC
		xETransp := A4_END
		xMTransp := A4_MUN
		xITransp := A4_INSCR
	 Else
		xNTransp := xPTransp := xUTransp := xCTransp := ""
		xETransp := xMTransp := xITransp := ""
	 EndIf
	 xPBruto  := 0
	 xPLiqui  := 0         
	 xME	  := ""	
     xDescME := 0
     If SF1->F1_TIPO == "D" 
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek( xFilial() + xFornece )
	    xNome   := SA1->A1_NOME               // Nome
		xEnd    := SA1->A1_END                // Endereco
		xBairro := SA1->A1_BAIRRO             // Bairro
		xCep    := SA1->A1_CEP                // CEP
		xMun    := SA1->A1_MUN                // Municipio
		xEst    := SA1->A1_EST                // Estado
		xCgc    := SA1->A1_CGC                // CGC
		xInscr  := SA1->A1_INSCR              // Inscricao estadual
		xTel    := SA1->A1_TEL                // Telefone
		xFax    := SA1->A1_FAX                // Fax
		xMarca  := SA1->A1_MARCA              // Marca
		xME	  := SA1->A1_ME					// Micro Empresa
		xDescME := SA1->A1_DESC				// desconto micro empresa
     Else   
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek( xFilial() + xFornece )
    	xNome   := SA2->A2_NOME               // Nome
		xEnd    := SA2->A2_END                // Endereco
		xBairro := SA2->A2_BAIRRO             // Bairro
		xCep    := SA2->A2_CEP                // CEP
		xMun    := SA2->A2_MUN                // Municipio
		xEst    := SA2->A2_EST                // Estado
		xCgc    := SA2->A2_CGC                // CGC
		xInscr  := SA2->A2_INSCR              // Inscricao estadual
		xTel    := SA2->A2_TEL                // Telefone
		xFax    := SA2->A2_FAX                // Fax
		xMarca  := ""                         // Marca
	 EndIf
	 DbSelectArea("SD1")
	 DbSetOrder(1)
	 DbSeek( xFilial() + xDoc + xSerie + xFornece )
	 xCodProd  := {}      // Codigo  do Produto
	 xDesProd  := {}      // Descricao do Produto
	 xQtdProd  := {}      // Quantidade do Produto
	 xUnidMed  := {}      // Unidade de Medida
	 xPreUnit  := {}      // Preco Unitario de Venda
	 xPercIcm  := {}      // Porcentagem do ICMS
	 xPercIpi  := {}      // Porcentagem do IPI
	 xValoIpi  := {}      // Valor do IPI
	 xValoMer  := {}      // Valor da Mercadoria
	 xClasFis  := {}      // Classificao Fiscal 
	 xGrpTrib  := {}      // Grupo de Tributacao
	 xCodgFis  := {}      // Codigo Fiscal
	 xCFO      := {}
	 xNatOper  := {}      // Natureza da Operacao
	 xCodgMen  := {}      // Codigo Mensagem Padrao
	 xMensNfe  := {}      // Mensagem Nf
	 X := 1
	 nValDesc := 0
	 While !Eof() .and. SD1->D1_DOC == xDoc .and. SD1->D1_SERIE == xSerie ;
								  .and. SD1->D1_FORNECECE == xFornece

	   AaDd( xCodProd, D1_COD     )
	   AaDd( xDesProd, D1_DESCRI  )
	   AaDd( xQtdProd, D1_QUANT   )
	   AaDd( xUnidMed, D1_UM      )  
	   AaDd( xPercIcm, D1_PICM    )
	   AaDd( xPercIpi, D1_IPI     )
	   AaDd( xValoIpi, D1_VALIPI  )
	   AaDd( xMensNfe, D1_MENNF   )
       AaDd( xQtEmbal, D1_VOLUME  )
	   xQtEmbal[X] := D1_VOLUME
	   If xME = "S"
	      xDescA1 := 100 - SA1->A1_DESC
	      xVlUnit := (Round((SD1->D1_VUNIT * 100)/ xDescA1,2) * 100) /100
	      nPreUni := xVlUnit
	   Else   
	      nPreUni := SD1->D1_VUNIT
 	   Endif   

       AaDd( xPreUnit, nPreUni    )//D1_VUNIT   ) 
	   AaDd( xValoMer, SD1->D1_QUANT * nPreUni )//D1_TOTAL   )
 	   nValDesc += ((SD1->D1_QUANT * nPreUni ) - (SD1->D1_QUANT * SD1->D1_VUNIT))
// 	   nValDesc += SD1->D1_DESC
	   DbSelectArea("SF4")
	   DbSetOrder(1)
	   DbSeek( xFilial() + SD1->D1_TES )

	   AaDd( xCFO, SF4->F4_CF    )   
	   AaDd( xNatOper, SF4->F4_TEXTO )   
						 
	   Dbselectarea("SB1")
	   DbSeek( xFilial() + SD1->D1_COD)

	   AaDd( xClasFis, B1_CLASFIS )
  	   AaDd( xGrpTrib, B1_POSIPI  )
	   AaDd( xCodgFis, SB1->B1_ORIGEM + SF4->F4_SITTRIB)   
						 
	   xPBruto := xPBruto + ( B1_PESO * SD1->D1_QUANT ) + ( B1_PSE * SD1->D1_QUANT )
	   xPLiqui := xPLiqui + ( B1_PESO * SD1->D1_QUANT ) 

	   If B1_QE <> 0
	      If B1_QE < SD1->D1_QUANT
			 If SD1->D1_QUANT/B1_QE <> INT( SD1->D1_QUANT/B1_QE )
		    	xPBruto := xPBruto + ( B1_QE - MOD( SD1->D1_QUANT, B1_QE ) ) * B1_PSE
			 EndIf
		  Else
			 xPBruto := xPBruto + ( B1_QE - SD1->D1_QUANT ) * B1_PSE
		  EndIF
	   EndIf

	   DbSelectArea("SX5")
	   DbSetOrder(1)
	   DbSeek( xFilial()+"97" + SB1->B1_TPEMB )
	   AADD( xTpEmbal, Alltrim( SX5->X5_DESCRI ) )
	   xTpEmbal[x] := Alltrim( SX5->X5_DESCRI )
	   X := X + 1

	   DbSelectarea("SD1")
	   Dbskip()

	 End
  
     linha := linha + 5
     @ linha-5, 000 PSay chr(15)
     // Descompactacao da Impressora Para Impressao do Cabecalho
     @ linha-4, 115 PSay "X"
     @ linha-4, 129 PSay xDoc

     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Estas Condicoes Abaixo, sao Para a Impressao de Varios Tes   ³
     //³ Numa Unica Nota de Saida.                                    ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

     Coluna  := 1
     xBarra  := ""
     xUltima := ""

     For xContador := 1 To Len( xNatOper )
     	 If xUltima <> xNatOper[xContador]
	     	 @ linha, Coluna PSay xBarra + AllTrim(SubStr(xNatOper[xContador],1,10))
     		 Coluna  := Coluna + Len( SubStr(xNatOper[xContador] ,1,10) )
	     	 xBarra  := "/"
		      xUltima := xNatOper[xContador]
     	 EndIf
     Next

     Coluna  := 43          
     xBarra  := ""          
     xUltima := ""
     
     For xContador := 1 To Len( xCFO )
     	 If xUltima <> xCfo[xContador]
	     	 @ linha, Coluna PSay xBarra + SubStr(xCfo[xContador],1,4)
		     Coluna  := Coluna + Len( SubStr(xCfo[xContador] ,1,4) )
     		 xBarra  := "/"
	     	 xUltima := xCfo[xContador]
     	 EndIf
     Next
				  

     @ linha, 058 PSay xInscr  
     Linha := Linha + 3
     @ linha,  00 PSay xNome
     If !Empty(xCgc)
     	@ linha, 090 PSay xCgc Picture "@R 99.999.999/9999-99" 
     EndIf
     @ linha, 129 PSay xEmissao
     linha:=Linha + 2
     @ linha, 002 PSay xEnd
     @ linha, 072 PSay xBairro
     If !Empty(xCep)
     	@ linha, 103 PSay xCep Picture "@R 99999-999"
     EndIf
     linha := linha + 2
     @ linha, 002 PSay xMun
     @ linha, 035 PSay Alltrim(xTel) + " / " + Alltrim(xFax)
     @ linha, 082 PSay xEst
     @ linha, 088 PSay xInscr
     @ linha, 129 PSay Time()
     linha := linha + 3
     @ linha, 129 PSay xFornece
     linha:=linha + 7
     
     ImpDet()

     linha := linha +2

     @ linha, 002 PSay xBaseIcm  Picture "@E@Z 999,999,999,999.99"
     @ linha, 025 PSay xValIcm   Picture "@E@Z 99,999,999,999.99"

     @ linha, 119 PSay xValMerc  Picture "@E@Z 999,999,999,999.99"

     linha := linha + 2

     @ linha, 090 PSay xValIpi   Picture "@E@Z 99,999,999,999.99"
     @ linha, 119 PSay xValMerc+xValIpi  Picture "@E@Z 999,999,999,999.99"

     linha := linha + 3

     @ linha, 002 PSay xNTransp
     @ Linha, 084 PSay "1"
     @ linha, 092 PSay xPTransp
     @ linha, 105 PSay xUTransp
     If !Empty(xCTransp)
     	@ linha, 111 PSay xCTransp Picture "@R 99.999.999/9999-99"  // Linha 18
     EndIf
     linha := linha + 2
     @ linha, 002 PSay xETransp
     @ linha, 070 PSay xMTransp
     @ linha, 105 PSay xUTransp
     @ linha, 111 PSay xITransp
     
     linha := linha + 1

     If xQtEmbal[1] <> 0  .or. xQtEmbal[2] <> 0 .or. xQtEmbal[3] <> 0 .or. xQtEmbal[4] <> 0
     	@ Linha, 000  PSay Alltrim(Str(xQtEmbal[1])) + "/" + Alltrim(Str(xQtEmbal[2])) + "/" +Alltrim(Str(xQtEmbal[3])) + "/" + Alltrim(Str(xQtEmbal[4]))
     EndIf

     If !Empty(xTpEmbal[1]) .or.!Empty(xTpEmbal[2]).or.!Empty(xTpEmbal[3]).or.!Empty(xTpEmbal[4])
     	@ Linha, 019  PSay UPPER(Alltrim(xTpEmbal[1])) + "/" + UPPER(Alltrim(xTpEmbal[2])) + "/" + UPPER(Alltrim(xTpEmbal[3])) + "/" + UPPER(Alltrim(xTpEmbal[4]))
     EndIf

     @ linha, 055 PSay xMarca
     @ linha, 108 PSay xPBruto Picture "@E@Z 99999.99"
     @ Linha, 127 PSay xPLiqui Picture "@E@Z 99999.99"

     linha:=linha + 3

     //Mensagem
     For i := 1 to Len(xMensNfe)
         If !Empty(xMensNfe[i])
         	@ Linha,  4 PSay PADC(UPPER(SUBSTR(xMensNfe[i],001,055)),55)
     		@ Linha+1,4 PSay PADC(UPPER(SUBSTR(xMensNfe[i],056,110)),55)
     		@ Linha+2,4 PSay PADC(UPPER(SUBSTR(xMensNfe[i],111,165)),55)
     		@ Linha+3,4 PSay PADC(UPPER(SUBSTR(xMensNfe[i],166,220)),55)
     		@ Linha+4,4 PSay PADC(UPPER(SUBSTR(xMensNfe[i],221,275)),55)
     		@ Linha+5,4 PSay PADC(UPPER(SUBSTR(xMensNfe[i],276,330)),55)
     	Endif	
     Next
     Linha := Linha + 20
     
     @ linha,125 PSay xDoc

     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Termino da Impressao da Nota Fiscal                          ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
     Linha:=Linha+5
     	 
  EndIf   // EndIF final
	  
  dbSelectArea("SF1")     //
  dbSetOrder(1)           // Reestabelece Area Principal de Pesquisa
  dbSkip()                // e passa para a proxima Nota Fiscal
  //IncRegua()
  xQtEmbal  := {0,0,0,0,0}
  xTpEmbal  := {" "," "," "," "," "}

End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechamento do Programa da Nota Fiscal                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ Linha, 002 PSay " "+chr(18) // Descompressao de Impressao
@ Linha, 002 PSay " "

dbSelectArea("SF1")
Set SoftSeek Off
dbSetOrder(1)

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	DbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do Programa                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                   FUNCOES ESPECIFICAS                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³   CHESTER BRAGA       ³ Data ³ 30/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica posicionamento de papel na Impressora             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EXCLUSIVO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 17/07/02 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2

   nOpc       := 1
	#IFNDEF WINDOWS
	   cCor       := "B/BG"
	#ENDIF
   While .T.

      SetPrc(0,0)
      dbCommitAll()

      @ nLin ,000 PSAY " "
      @ nLin ,004 PSAY "*"
      @ nLin ,022 PSAY "."
		#IFNDEF WINDOWS
	      Set Device to Screen
	      DrawAdvWindow(" Formulario ",10,25,14,56)
	      SetColor(cCor)
	      @ 12,27 Say "Formulario esta posicionado?"
	      nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device to Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF

      Do Case
         Case nOpc==1
            lContinua:=.T.
            Exit
         Case nOpc==2
            Loop
         Case nOpc==3
            lContinua:=.F.
            Return
      EndCase
   End
Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPDET   ³ Autor ³   CHESTER BRAGA       ³ Data ³ 30/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Linhas de Detalhe da Nota Fiscal              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EXCLUSIVO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 17/07/02 ==> Function IMPDET
Static Function IMPDET()

nTamDet       := 11            // Tamanho da Area de Detalhe
nLinIniImpDet := Linha         // Linha de Inicio de Impressao de Detalhe
Linha         := nLinIniImpDet

I := 1

// Compactacao Para Impressao do Detalhe e Totais da Nota

@ linha-1, 000 Psay Chr(15)

For I:=1 to nTamDet
  If Len(xCodProd) >= I
	 @ Linha, 000 PSay xCodProd[I]
	 @ Linha, 014 PSay xDesProd[I]
	 @ Linha, 055 PSay xGrpTrib[I]
	 @ Linha, 069 PSay xCodgFis[I]
	 @ Linha, 074 PSay xUnidMed[I]
	 @ Linha, 077 PSay xQtdProd[I] Picture "@E@Z 9999999"
	 @ Linha, 088 PSay xPreUnit[I] Picture "@E@Z 999,999.9999"
	 @ Linha, 110 PSay xValoMer[I] Picture "@E@Z 99,999,999.99"
	 @ Linha, 125 PSay xPercIcm[I] Picture "@E 99"
	 @ Linha, 128 PSay xPercIpi[I] Picture "@E 99"
	 @ Linha, 135 PSay xValoIpi[I] Picture "@E@Z 999,999.99"
  EndIf
  Linha:=Linha+1
	 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	 //³ Atualiza regua de impressao                                  ³
	 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Next
If nValDesc > 0 
   @ Linha,080 PSAY "DESCONTO ME: "
   @ Linha,110 PSAY nValDesc Picture "@E@Z 99,999,999.99"
Endif
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim de Programa     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

