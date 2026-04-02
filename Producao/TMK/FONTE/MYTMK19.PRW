#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"      

User Function MYTMK19()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ MYTMK19  ³ Autor ³ JOAO PAULO RUFINI     ³ Data ³ 23/08/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Descri‡…o ³ Relatorio de Pedidos em Emitidos          (Plasticos Novel)³±±
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
titulo           :="RELATORIO DE PEDIDOS EMITIDOS"
cDesc1           :="RELATORIO DE PEDIDOS EMITIDOS"
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
nomeprog         :="PEDEMIT"
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
wnrel            := "PEDEMIT"
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
While !EOF() .AND. C5_EMISSAO <= mv_par02
  IncRegua()
  If li > 59 
     If li <> 75
        @ li,000 PSAY Replicate("-",limite)
     Endif
     ImpCabec()
     li:=li+1
  End
       
  dbSelectArea("SC6")
  dbSetOrder(1) // produto+pedido+item
  dbGoTop()
  dbSeek(xFilial("SC5")+SC5->C5_NUM,.F.)	 

  WHILE C6_NUM = SC5->C5_NUM 

        dbSelectArea("SA1")
        dbSeek(xFilial()+SC5->C5_CLIENTE) 
        STORE A1_EST TO MEST
        QTDSD = SC6->C6_QTDVEN - SC6->C6_QTDENT  
        QTDEPV = SC6->C6_QTDVEN


        DBSELECTAREA("SF4")
	    DBSETORDER(1)
	    DBSEEK(xFilial()+SC6->C6_TES)
	    IF SF4->F4_DUPLIC = "N" .OR. SF4->F4_TIPONF = "D"
           DBSELECTAREA("SC6")
           SKIP
           LOOP
        ENDIF   
		
		DbSelectArea("SA3")
    	DbSetOrder(1)
    	DbSeek(xFilial()+SC5->C5_VEND1,.T.)
		cCodVen := SA3->A3_COD
		cNomeVen:= SA3->A3_NREDUZ
        
        
        
        @ li,000 PSAY SC5->C5_NUM 
        @ li,008 PSAY SC5->C5_EMISSAO
        @ li,020 psay SC5->C5_CLIENTE
        @ li,029 PSAY SUBSTR(SA1->A1_NOME,1,15) 
        @ li,047 psay SC6->C6_PRODUTO+"  "+SUBSTR(SC6->C6_DESCRI,1,20)
        @ LI,086 PSAY SC6->C6_QTDVEN Picture "@E 999,999.99"   
        @ LI,096 PSAY QTDSD Picture "@E 999,999,999.99"   
        
        DbSelectArea("SB1")
        DbSetOrder(1)
        DbSeek(xFilial()+SC6->C6_PRODUTO,.T.)
        
        LINHA := " "                                     
		DbSelectArea("SZ1")
        DbSetOrder(1)
        DbSeek(xFilial()+SB1->B1_SUBGRUP)
        LINHA = Z1_DESC
                
 //////// CALULO DE ICMS PARA NOVEL-PR/EPP/PLAST
	 
	 nPcICM := 0.00 
	 	    
	 dbSelectArea("SA1")
	 dbgotop()
     //dbSeek(xFilial()+SUA->UA_CLIENTE+SUA->UA_LOJA)
	 dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	 ESTCLI := SA1->A1_EST
	 TIPCLI := SA1->A1_TIPO
	 GRPCLI := SA1->A1_GRPTRIB
	 
	 
	 IF SF4->F4_ICM ="N" 
	 	nPcICM := 0
	 ELSE	
	 	dbSelectArea("SF7")    
	 	dbgotop()
	 	do while .not. eof() 
	    	IF SF7->F7_EST = ESTCLI .AND. alltrim(SF7->F7_GRTRIB) $ Posicione("ZZZ",1,xFilial("ZZZ")+"TMK000011"+"001","ZZZ_RETORN") //"001"
	        
	       		IF SF7->F7_TIPOCLI = TIPCLI .AND.  alltrim(SF7->F7_GRPCLI) = alltrim(GRPCLI) 
	        		nPcICM := SF7->F7_ALIQINT  
	          
				ENDIF
        
        	ENDIF
	    SKIP          
     	ENDDO
     ENDIF
           
//FIM DO CALCULO ICMS
       
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
            TIRAICMS = (SC6->C6_PRCVEN * (nPcICM /100)) 
		
			LIQ = SC6->C6_PRCVEN - (TIRAPISCOF + TIRAICMS)

        ENDIF        
        
        IF SF4->F4_ICM = "S" .AND. SF4->F4_PISCOF = "4"
        
            TIRAICMS = (SC6->C6_PRCVEN * (nPcICM /100))                                     
        	LIQ = SC6->C6_PRCVEN - TIRAICMS

        ENDIF   
             
        IF SF4->F4_ICM = "N" .AND. SF4->F4_PISCOF = "3"
           TIRAPISCOF = (SC6->C6_PRCVEN * 0.0925) 
                           
           LIQ = SC6->C6_PRCVEN - TIRAPISCOF   
           
        ENDIF
        
        
        IF F4_ICM = "N" .AND. SF4->F4_PISCOF = "4"
                               
           LIQ = SC6->C6_PRCVEN
        
        ENDIF                  
        
        IF MEST = "AM"
           LIQ = SC6->C6_PRCVEN
        ENDIF   
        
        
        @ Li,110 PSAY LIQ Picture  "@E 999,999,999.9999"
        
//      TOTAL = LIQ * QTDSD
		TOTAL = LIQ * QTDEPV
        
        @ Li,130 PSAY TOTAL Picture "@E 999,999,999.9999"      
        TOTALG = TOTALG + TOTAL      
        /*
        @ Li,152 PSAY nPcICM      Picture "99"
        @ Li,158 PSAY TIRAICMS    Picture "999.999"
        @ Li,168 PSAY TIRAPISCOF  Picture "999.999"     
		@ Li,180 PSAY LINHA   
        li:=li+1
        */
        @ Li,149 PSAY nPcICM      Picture "99"
        @ Li,154 PSAY cCodVen     
        @ Li,161 PSAY SUBSTR(cNomeVen,1,15)
        @ Li,177 PSAY LINHA    
        li:=li+1
            
        
        dbSelectArea("SC6")
        DbSkip()
    End            
 
   DbSelectArea("SC5")
   DbSkip() 
end                                        
LI = LI + 1
@ Li,120 PSAY TOTALG Picture "@E 999,999,999.9999"    
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
  @ li,000 PSAY "PEDIDOS EMITIDOS         -     (valor sem impostos)"
  @ li,215 PSAY Npag Picture "999"
  li := li+1
  cDIni:=Dtos(mv_par01)                        
  cDFin:=Dtos(mv_par02)
  @ li,000 PSAY "EMISSAO DE " +SubStr(cDIni,7,2)+"/"+SubStr(cDIni,5,2)+"/"+SubStr(cDIni,1,4)
  @ li,PCol() PSAY " A "+SubStr(cDFin,7,2)+"/"+SubStr(cDFin,5,2)+"/"+SubStr(cDFin,1,4)
  li := li+1
  @ li,000 PSAY Replicate("-",limite)
  li := li+1
  @ li,000 PSAY  "PEDIDO    DATA    CLIENTE        NOME             PRODUTO             DESCRICAO          QTDE P.V     SALDO QTD      VALOR UNIT        VALOR TOTAL  ICM  CODIGO    VENDEDOR     LINHA"    
//                123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 
//                         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18

  li := li+1
  @ li,000 PSAY Replicate("-",limite)
  li:=li+1

Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02