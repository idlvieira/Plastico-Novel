#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"      


User Function PEDCART()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ PEDCART  ³ Autor ³ Wellington Carvalho   ³ Data ³ 06/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RelatORIO de Pedidos em Carteira          (Plasticos Novel)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaTMK                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NTOTIPI,APEDCLI,CSTRING,AQUANT,AQTOTAL,ASTRU")
SetPrvt("CARQTRAB,CIND,ASTRU2,XCLIME,CNOM_VEND,CDESC_PROD")
SetPrvt("CGRP_PROD,CCODP,CCODV,NQTD,NLIQ,NIPI")
SetPrvt("ASTRU3,CCODVEN,CNOMVEN,NTOTVEND,M,K")
SetPrvt("NVINI,W,LVOLTA,LTOPOP,LREG,LITEM")
SetPrvt("_NREG,CDINI,CDFIM,NTOTGER,NTOTLIQ,CGRP")
SetPrvt("LACHOUGRP,CDESC,NTOT,NTLIQ,NTIPI,CHEADER")
SetPrvt("CHEADER2,CVEND1,NAJUSTE,LCONTINUA,CCODPROD,I")
SetPrvt("LPULOUP,_CALIASTEMP,_NREGTEMP1,_NREGTEMP2,LACHOU,J")
SetPrvt("G,")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//

wnrel            :=""
tamanho          :="G"
titulo           :="RELATORIO DE PEDIDOS EM CARTEIRA"
cDesc1           :="RELATORIO DE PEDIDOS EM CARTEIRA"
cDesc2           :=""
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :="" //  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="ATC010"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog         :="PEDCART"
nLastKey         :=0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=80
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          :=nTotVal:=0
nTotIPI          :=0
aPedCli          := {}
wnrel            := "PEDCART"
cString          := "SE1"     
NPag             := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              De Emissao                            ³
//³ mv_par02              Ate Emissao                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)
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
limite   := 220
li       := 80
nPag     := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSAY AvalImp(Limite)

QtdNF:=0
QtdDias:=0 

DbSelectArea("SC5")
DbSetOrder(2)
DbSeek(xFilial("SC5")+Dtos(mv_par01),.T.)
SetRegua(RecCount())  
li := 75
TOTALG = 0.00
LINHA01 = 0.00     
LINHA02 = 0.00
LINHA03 = 0.00
LINHA04 = 0.00
LINHA05 = 0.00
LINHA06 = 0.00
LINHA51 = 0.00
LINHA53 = 0.00
LINHA54 = 0.00
       
While !EOF() .AND. C5_EMISSAO <= mv_par02
  IncRegua()
  If li > 59 
     If li <> 75
        @ li,000 PSAY Replicate("-",limite)
     Endif
     ImpCabec()
     li:=li+1
  End
  
  // filtra remessa
         
  if SC5->C5_CONDPAG = "040"
     SKIP()
     LOOP
  ENDIF         
       
  dbSelectArea("SC6")
  dbSetOrder(1) // produto+pedido+item
  dbGoTop()
  dbSeek(xFilial("SC5")+SC5->C5_NUM,.F.)	 

  WHILE C6_NUM = SC5->C5_NUM 

        dbSelectArea("SA1")
        dbSeek(xFilial()+SC5->C5_CLIENTE) 
        STORE A1_EST TO MEST
        QTDSD = SC6->C6_QTDVEN - SC6->C6_QTDENT  
        IF QTDSD = 0 
           dbSelectArea("SC6")
           SKIP             
           LOOP
        ENDIF         
        
        DBSELECTAREA("SF4")
	    DBSETORDER(1)
	    DBSEEK(xFilial()+SC6->C6_TES)
	    IF SF4->F4_DUPLIC = "N"
           DBSELECTAREA("SC6")
           SKIP
           LOOP
        ENDIF   
                    
         dbSelectArea("SC9")
         dbSetOrder(1)
         dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
   
         If !Found()// Bloqueado em vendas
            xStatus:="4"
         Else
         While !EOF() .AND. SC6->C6_NUM=SC9->C9_PEDIDO .AND. SC6->C6_ITEM=SC9->C9_ITEM
              BLCRED:=C9_BLCRED               
              BLEST :=C9_BLEST
              DATLIB:=C9_DATALIB
      	      dbSkip()
         Enddo
         If BLCRED="10" .and. BLEST="10" // Já faturado
            xStatus:=" "
         ElseIf (BLCRED="01" .and. BLEST="02") .or. (BLCRED="01" .and. BLEST="  ") // Bloqueado no crédito
            xStatus:="3"
         ElseIf BLCRED="  " .and. BLEST="02" // Bloqueado no estoque
            xStatus:="2"
         ElseIf BLCRED="  " .and. BLEST="  "
            xStatus:="1"  // Liberado para faturar  
         ElseIf (BLCRED="09" .and. BLEST="02") .or. (BLCRED="09" .and. BLEST="  ") // Rejeitado no crédito
            xStatus:="5"
         Endif
         endif
         IF xstatus = "3" .or. xstatus = "4"       
            dbSelectArea("SC6")
            DbSkip()
            loop
         endif

        @ li,000 PSAY SC5->C5_NUM 
        @ li,008 PSAY SC5->C5_EMISSAO
        @ li,020 psay SC5->C5_CLIENTE
        @ li,029 PSAY SUBSTR(SA1->A1_NOME,1,15) 
        @ li,047 psay SC6->C6_PRODUTO+"  "+SUBSTR(SC6->C6_DESCRI,1,20)
        @ LI,086 PSAY QTDSD Picture "999999999.99"   
        
        DbSelectArea("SB1")
        DbSetOrder(1)
        DbSeek(xFilial()+SC6->C6_PRODUTO,.T.)

                
        // CALCULA VALOR SEM IMPOSTOS
        
        liq = 0
        
        DBSELECTAREA("SF4")
	    DBSETORDER(1)
	    DBSEEK(xFilial()+SC6->C6_TES)  
	    
	    TIRAICMS = 0.00
	    LIQ = 0.00
	    TIRAPISCOF = 0
	    
	    
        IF SF4->F4_ICM = "S" .AND. SF4->F4_PISCOF = "3"
           TIRAPISCOF = (SC6->C6_PRCVEN * 0.0925) 
           
           IF MEST = "BA"
              TIRAICMS = (SC6->C6_PRCVEN * 0.10)
           ELSE
              TIRAICMS = (SC6->C6_PRCVEN * 0.05)
           ENDIF
                           
           LIQ = SC6->C6_PRCVEN - (TIRAPISCOF + TIRAICMS)
         ENDIF        
        
        IF SF4->F4_ICM = "S" .AND. SF4->F4_PISCOF = "4"
           
           IF MEST = "BA"
              TIRAICMS = (SC6->C6_PRCVEN * 0.10)
           ELSE
              TIRAICMS = (SC6->C6_PRCVEN * 0.05)
           ENDIF
                           
           LIQ = SC6->C6_PRCVEN - TIRAICMS
        ENDIF   
             
        IF SF4->F4_ICM = "N" .AND. SF4->F4_PISCOF = "3"
           TIRAPISCOF = (SC6->C6_PRCVEN * 0.0925) 
                           
           LIQ = SC6->C6_PRCVEN - TIRAPISCOF   
           
        ENDIF
        
        IF F4_ICM = "S" .AND. SF4->F4_PISCOF = "4"
           IF MEST = "BA"
              TIRAICMS = (SC6->C6_PRCVEN * 0.10)
           ELSE
              TIRAICMS = (SC6->C6_PRCVEN * 0.05)
           ENDIF 
                           
           LIQ = SC6->C6_PRCVEN - TIRAICMS 
        ENDIF                   
        
        IF F4_ICM = "N" .AND. SF4->F4_PISCOF = "4"
           IF MEST = "BA"
              TIRAICMS = 0.00
           ELSE
              TIRAICMS = 0.00
           ENDIF 
                           
           LIQ = SC6->C6_PRCVEN - TIRAICMS 
        ENDIF                  
        
        IF MEST = "AM"
           LIQ = SC6->C6_PRCVEN
        ENDIF   
        
        
        @ Li,100 PSAY LIQ Picture  "999999999.99"        
        TOTAL = LIQ * QTDSD
        
        @ Li,120 PSAY TOTAL Picture "999999999.99"      
        TOTALG = TOTALG + TOTAL      
  
  
        @ Li,140 PSAY SB1->B1_CTITEM1 Picture "99999"  
          
        // SOMA LINHAS
        
        IF SB1->B1_CTITEM1 = "01"
          LINHA01 = LINHA01 + TOTAL 
        ENDIF
        
        IF SB1->B1_CTITEM1 = "02"
           LINHA02 = LINHA02 + TOTAL 
        ENDIF
        
        IF SB1->B1_CTITEM1 = "03"
           LINHA03 = LINHA03+ TOTAL 
        ENDIF
        
        IF SB1->B1_CTITEM1 = "04"
           LINHA04 = LINHA04 + TOTAL 
        ENDIF
        
        IF SB1->B1_CTITEM1 = "05"
          LINHA05 = LINHA05 + TOTAL 
        ENDIF
        
        IF SB1->B1_CTITEM1 = "06"
           LINHA01 = LINHA01 + TOTAL 
        ENDIF

        IF SB1->B1_CTITEM1 = "51"
          LINHA51 = LINHA51 + TOTAL 
        ENDIF
        
        IF SB1->B1_CTITEM1 = "53"
           LINHA53 = LINHA53 + TOTAL 
        ENDIF
        
        IF SB1->B1_CTITEM1 = "54"
           LINHA54 = LINHA54 + TOTAL 
        ENDIF
        
        li:=li+1
        
        dbSelectArea("SC6")
        DbSkip()
    End            
    
   DbSelectArea("SC5")
   DbSkip() 
end                                         
LI = LI + 1
@ Li,120 PSAY TOTALG Picture "999999999.99"
LI = LI + 1                     
@ li,000 PSAY  "TOTAL POR LINHA"
LI = LI + 1
@ li,000 PSAY "LINHA01: "
@ li,013 psay LINHA01 Picture "999999999.99"
LI = LI + 1
@ li,000 PSAY "LINHA02: "
@ li,013 psay LINHA02 Picture "999999999.99"
LI = LI + 1
@ li,000 PSAY "LINHA03: "
@ li,013 psay LINHA03 Picture "999999999.99"
LI = LI + 1
@ li,000 PSAY "LINHA04: "
@ li,013 psay LINHA04 Picture "999999999.99"
LI = LI + 1
@ li,000 PSAY "LINHA05 "
@ li,013 psay LINHA05 Picture "999999999.99"
LI = LI + 1
@ li,000 PSAY "LINHA06: "
@ li,013 psay LINHA06 Picture "999999999.99"
LI = LI + 1
@ li,000 PSAY "LINHA51: "
@ li,013 psay LINHA51 Picture "999999999.99"
LI = LI + 1
@ li,000 PSAY "LINHA53: "
@ li,013 psay LINHA53 Picture "999999999.99"
LI = LI + 1
@ li,000 PSAY "LINHA54: "
@ li,013 psay LINHA54 Picture "999999999.99"
LI = LI + 1
    
TOTALG = 0.00


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
  @ li,211 PSAY SubStr(cDIni,7,2)+"/"+SubStr(cDIni,5,2)+"/"+SubStr(cDIni,1,4)
  li := li+1   
  @ li,000 PSAY "PEDIDOS EM CARTEIRA"
  @ li,215 PSAY Npag Picture "999"
  li := li+1
  cDIni:=Dtos(mv_par01)
  cDFin:=Dtos(mv_par02)
  @ li,000 PSAY "EMISSAO DE " +SubStr(cDIni,7,2)+"/"+SubStr(cDIni,5,2)+"/"+SubStr(cDIni,1,4)
  @ li,PCol() PSAY " A "+SubStr(cDFin,7,2)+"/"+SubStr(cDFin,5,2)+"/"+SubStr(cDFin,1,4)
  li := li+1
  @ li,000 PSAY Replicate("-",limite)
  li := li+1
  @ li,000 PSAY  "PEDIDO    DATA    CLIENTE        NOME             PRODUTO             DESCRICAO           SALDO QTD         VALOR UNIT       VALOR TOTAL    LINHA "    
//                999999   999999   999999  AAAAAAAAAAAAAAAAAAAAAAAA  A99999999999999  99   AAAAAAAAAAAAAAAAAAAAAAAA   999,999,999.99  999,999,999.99   999,999,999.99    999,999,999.99" 
  li := li+1
  @ li,000 PSAY Replicate("-",limite)
  li:=li+1

Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
