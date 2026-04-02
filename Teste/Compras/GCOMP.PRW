#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
#INCLUDE "TOPCONN.CH"

User Function GCOMP()        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ GCOMP    ³ Autor ³ Eliene Cerqueira      ³ Data ³ 31.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Programação de Compras       (Plasticos Novel)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigacom                                                    ³±±
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
wnrel            :=""
tamanho          :="P"
titulo           :="GESTAO DE COMPRAS"
cDesc1           :="Relatorio de programação de compras."
cDesc2           :=""
cDesc3           :=" "
cabec1 	         := "PRODUTOS                                     PEDIDOS PENDENTES +"
cabec2 	         := "                                             PREVISAO VENDAS"
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :="" //  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="GCOMP1"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nTipo	         := GetMv("MV_COMP")
nomeprog         :="GCOMP"
nLastKey         :=0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=80
m_pag            := 1
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          :=nTotVal:=0
nTotIPI          :=0
aPedCli          := {}
wnrel            := "GCOMP"
cString          := "SC6"     

aQuant         :={} // Array com quantidades para somatorio total
aQTotal        :={} // Array com os totais de cada vendedor

// Criar arquivo de Perguntas
//GRAV_1SX()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Execute(GRAV_1SX)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Da Data                               ³
//³ mv_par02              Ate a Data                            ³
//³ mv_par03              Do Vendedor                           ³
//³ mv_par04              Ate o Vendedor                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)
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

aStru:={}
AADD( aStru, {"COD_P"  ,"C" ,15 ,0} )
AADD( astru, {"DESC_P" ,"C" ,30 ,0} )
AADD( astru, {"TIPO"   ,"C" ,02 ,0} )
AADD( aStru, {"QUANT"  ,"N" ,18 ,2} )
cArqTrb1:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb1,"QUERY1",.F.)
IndRegua("QUERY1",cArqTrb1,"COD_P")

aStru:={}
AADD( aStru, {"COD_P"  ,"C" ,15 ,0} )
AADD( astru, {"DESC_P" ,"C" ,30 ,0} )
AADD( astru, {"TIPO"   ,"C" ,02 ,0} )
AADD( aStru, {"QUANT"  ,"N" ,18 ,2} )
cArqTrb3:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb3,"QUERY3",.F.)
IndRegua("QUERY3",cArqTrb3,"COD_P")

If mv_par03 = 1
   TEM:=.F.
   DbSelectArea("SC4")
   DbSetOrder(2) // C4_DATA
   Dbgotop()
   SetRegua(RecCount())
   DbSeek(xFilial("SC4")+Dtos(mv_par01),.T.)
   While !EOF() .AND. C4_DATA <= mv_par02
     IncRegua()   
     TEM:=.T.
     cDesc_Prod:=Space(30)
     DbSelectArea("SB1")
     DbSetOrder(1)
     DbSeek(xFilial("SB1")+SC4->C4_PRODUTO,.F.)
     DbSelectArea("QUERY1")
     If dbSeek(SC4->C4_PRODUTO,.F.)
        Reclock("QUERY1",.F.)
     Else
        Reclock("QUERY1",.T.)
        QUERY1->COD_P  := SC4->C4_PRODUTO
        QUERY1->DESC_P := SB1->B1_DESC
        QUERY1->TIPO   := SB1->B1_TIPO
     Endif
     QUERY1->QUANT  := QUERY1->QUANT+SC4->C4_QUANT
     MSUnlock()                           
     DbSelectArea("SC4")
     DbSkip()
   End
   If !TEM
      Msgbox("Data sem previsão de vendas!")
   Endif
Else
   cabec1 	         := "PRODUTOS                                     PEDIDOS PENDENTES"
   cabec2 	         := ""
Endif
          
DbSelectArea("SC6")
DbSetOrder(3) // C6_ENTREG
Dbgotop()
SetRegua(RecCount())
While SC6->( !Eof() )
  IncRegua()   
  If !Empty(SC6->C6_DATFAT)
   	 SC6->( DbSkip() )       
	 Loop
  Endif                	

  SC5->( DbSeek(xFilial()+SC6->C6_NUM,.T.) ) 
  //Pular se o pedido for de beneficiamento ou devolução de compras.
  If SC5->C5_TIPO $ "BD"
   	 SC6->( DbSkip() )       
     Loop
  Endif                	
  cDesc_Prod:=Space(30)
  DbSelectArea("SB1")
  DbSetOrder(1)
  DbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.F.)
  DbSelectArea("QUERY1")
  If dbSeek(SC6->C6_PRODUTO,.F.)
     Reclock("QUERY1",.F.)
  Else
     Reclock("QUERY1",.T.)
     QUERY1->COD_P  := SC6->C6_PRODUTO
     QUERY1->DESC_P := SB1->B1_DESC
     QUERY1->TIPO   := SB1->B1_TIPO
  Endif
  QUERY1->QUANT  := QUERY1->QUANT+SC6->C6_QTDVEN
  MSUnlock()                           
  SC6->( DbSkip() )       
End

DbSelectArea("QUERY1")
IndRegua("QUERY1",cArqTrb1,"DESC_P")
DbGoTop()      
SetRegua(RecCount())  
li := 65
While QUERY1->(!EOF()) 
  IncRegua()
  If li > 59 
     If li <> 65
        @ li,000 PSAY Replicate("-",limite)
     Endif
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
//     ImpCabec(1)
     li:=li+1
  End 
  
// alterado por wellington 27/06/2006 
   if Substr(QUERY1->COD_P,1,3) <> "MOD"
      @ li,000 PSAY Substr(QUERY1->COD_P,1,11)+" "+QUERY1->DESC_P+ "  "
      @ li, PCol() PSAY QUERY1->QUANT Picture "@E 9999,999.99"
      li:=li+1
      QUERY1->( DbSkip() )
    else
      QUERY1->( DbSkip() )
    Endif
                
End

Flag:=.T.
While Flag=.T.
  aStru:={}
  AADD( aStru, {"COD_P"  ,"C" ,15 ,0} )
  AADD( astru, {"DESC_P" ,"C" ,30 ,0} )
  AADD( astru, {"TIPO"   ,"C" ,02 ,0} )
  AADD( aStru, {"QUANT"  ,"N" ,18 ,2} )
  cArqTrb2:=CriaTrab(aStru,.T.)
  DbUseArea(.T.,"DBFCDX",cArqTrb2,"QUERY2",.F.)
  IndRegua("QUERY2",cArqTrb2,"COD_P")
  Flag:=.F.
  DbSelectArea("QUERY1")
  DbGoTop()      
  SetRegua(RecCount())  
  While QUERY1->(!EOF()) 
    IncRegua()
    DbSelectArea("SG1")
    DbSetOrder(1)
    DbSeek(xFilial("SG1")+QUERY1->COD_P,.T.)
    If EOF() .or. SG1->G1_COD<>QUERY1->COD_P .or. Substr(QUERY1->COD_P,1,1)<>"1"
       DbSelectArea("SB1")
       DbSetOrder(1)
       DbSeek(xFilial("SB1")+QUERY1->COD_P,.F.)
       DbSelectArea("QUERY3")
       If dbSeek(QUERY1->COD_P,.F.)
          Reclock("QUERY3",.F.)
       Else
          Reclock("QUERY3",.T.)
          QUERY3->COD_P  := QUERY1->COD_P
          QUERY3->DESC_P := SB1->B1_DESC
          QUERY3->TIPO   := SB1->B1_TIPO
       Endif
       QUERY3->QUANT  := QUERY3->QUANT+QUERY1->QUANT
       MSUnlock()              
    Endif
    If Substr(QUERY1->COD_P,1,1)<>"1"
       QUERY1->( DbSkip() )
       Loop
    Endif
    DbSelectArea("SG1")
    DbSetOrder(1)
    Do while !EOF() .and. SG1->G1_COD=QUERY1->COD_P
       QTDE:=QUERY1->QUANT
       DbSelectArea("SB1")
       DbSetOrder(1)
       DbSeek(xFilial("SB1")+SG1->G1_COMP,.F.)
       If SB1->B1_TIPO<>"MP"
          DbSelectArea("QUERY2")
          If dbSeek(SG1->G1_COMP,.F.)
             Reclock("QUERY2",.F.)
          Else
             Reclock("QUERY2",.T.)
             QUERY2->COD_P  := SG1->G1_COMP
             QUERY2->DESC_P := SB1->B1_DESC
             QUERY2->TIPO   := SB1->B1_TIPO
          Endif
          QUERY2->QUANT  := QUERY2->QUANT+(SG1->G1_QUANT*QTDE)
          MSUnlock()
          Flag:=.T.
       Else   
          DbSelectArea("QUERY3")
          If dbSeek(SG1->G1_COMP,.F.)
             Reclock("QUERY3",.F.)
          Else
             Reclock("QUERY3",.T.)
             QUERY3->COD_P  := SG1->G1_COMP
             QUERY3->DESC_P := SB1->B1_DESC
             QUERY3->TIPO   := SB1->B1_TIPO
          Endif
          QUERY3->QUANT  := QUERY3->QUANT+(SG1->G1_QUANT*QTDE)
          MSUnlock()              
       Endif
       SG1->( DbSkip() )
    Enddo
    QUERY1->( DbSkip() )
  Enddo
  If Flag
     dbSelectArea("QUERY1")
     dbCloseArea()
     If !Empty( cArqTrb1 )
        FErase( cArqTrb1+".*")
     Endif
     aStru:={}
     AADD( aStru, {"COD_P"  ,"C" ,15 ,0} )
     AADD( astru, {"DESC_P" ,"C" ,30 ,0} )
     AADD( astru, {"TIPO"   ,"C" ,02 ,0} )
     AADD( astru, {"MARCA"  ,"C" ,01 ,0} )
     AADD( aStru, {"QUANT"  ,"N" ,18 ,2} )
     cArqTrb1:=CriaTrab(aStru,.T.)
     DbUseArea(.T.,"DBFCDX",cArqTrb1,"QUERY1",.F.)
     IndRegua("QUERY1",cArqTrb1,"COD_P")
     Flag:=.F.
     DbSelectArea("QUERY2")
     DbGoTop()      
     SetRegua(RecCount())  
     While QUERY2->(!EOF()) 
       IncRegua()
       DbSelectArea("SG1")
       DbSetOrder(1)
       DbSeek(xFilial("SG1")+QUERY2->COD_P,.T.)
       Do while !EOF() .and. SG1->G1_COD=QUERY2->COD_P
          QTDE:=QUERY2->QUANT
          DbSelectArea("SB1")
          DbSetOrder(1)
          DbSeek(xFilial("SB1")+SG1->G1_COMP,.F.)
          If SB1->B1_TIPO<>"MP"
             DbSelectArea("QUERY1")
             If dbSeek(SG1->G1_COMP,.F.)
                Reclock("QUERY1",.F.)
             Else
                Reclock("QUERY1",.T.)
                QUERY1->COD_P  := SG1->G1_COMP
                QUERY1->DESC_P := SB1->B1_DESC
                QUERY1->TIPO   := SB1->B1_TIPO
             Endif
             QUERY1->QUANT  := QUERY1->QUANT+(SG1->G1_QUANT*QTDE)
             MSUnlock()
             Flag:=.T.
          Else   
             DbSelectArea("QUERY3")
             If dbSeek(SG1->G1_COMP,.F.)
                Reclock("QUERY3",.F.)
             Else
                Reclock("QUERY3",.T.)
                QUERY3->COD_P  := SG1->G1_COMP
                QUERY3->DESC_P := SB1->B1_DESC
                QUERY3->TIPO   := SB1->B1_TIPO
             Endif
             QUERY3->QUANT  := QUERY3->QUANT+(SG1->G1_QUANT*QTDE)
             MSUnlock()              
          Endif
          SG1->( DbSkip() )
       Enddo
       QUERY2->( DbSkip() )
     Enddo
  Endif   
  dbSelectArea("QUERY2")
  dbCloseArea()
  If !Empty( cArqTrb2 )
     FErase( cArqTrb2+".*")
  Endif
Enddo

dbSelectArea("QUERY1")
dbCloseArea()
If !Empty( cArqTrb1 )
   FErase( cArqTrb1+".*")
Endif

cabec1 	         := "INSUMOS                                      NECESSARIA     ESTOQUE     COMPRAR"
cabec2 	         := ""

DbSelectArea("QUERY3")
DbGoTop()      
SetRegua(RecCount())
li := 65
While QUERY3->(!EOF())
  IncRegua()
  If SUBSTR(QUERY3->COD_P,1,1)="1"
     QUERY3->( DbSkip() )       
     Loop
  Endif
  DbSelectArea("SB1")
  DbSeek(xFilial("SB1")+QUERY3->COD_P,.F.)
  DbSelectArea("QUERY3")
  If SB1->B1_CLASSE1="870" .OR. SB1->B1_CLASSE1="871" .OR. SB1->B1_CLASSE1="872"
     QUERY3->( DbSkip() )       
     Loop
  Endif
  If li > 59 
     If li <> 65
        @ li,000 PSAY Replicate("-",limite)
     Endif
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
//     ImpCabec(2)
     li:=li+1
  End
  QtdEst:=0
  QtdCom:=0
  DbSelectArea("SB2")
  DbSetOrder(1)
  DbSeek(xFilial("SB2")+QUERY3->COD_P+SB1->B1_LOCPAD,.T.)
  If Found()
     do while QUERY3->COD_P = SB2->B2_COD 
              QtdEst:= Qtdest + SB2->B2_QATU
        Dbskip()   
     enddo   
  Endif                                 
   
  
  // alterado em 27/06/2006 - wellington
  If Substr(QUERY3->COD_P,1,3) <> "MOD" 
     QtdCom:=QUERY3->QUANT-QtdEst
     @ li,000 PSAY Substr(QUERY3->COD_P,1,11)+" "+QUERY3->DESC_P+ "  "
     @ li, PCol() PSAY QUERY3->QUANT Picture "@E 9999,999.99"
     @ li, PCol() PSAY " "
     @ li, PCol() PSAY QtdEst        Picture "@E 9999,999.99"
     @ li, PCol() PSAY " "
     @ li, PCol() PSAY QtdCom        Picture "@E 9999,999.99"
     li:=li+1
     QUERY3->( DbSkip() )
  else   
     QUERY3->( DbSkip() )
  Endif
  //           
End

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

dbSelectArea("QUERY3")
dbCloseArea()
If !Empty( cArqTrb3 )
   FErase( cArqTrb3+".*")
Endif

dbSelectArea("SB1")
retindex("SB1")
dbSelectArea("SF2")
retindex("SF2")
dbSelectArea("SD2")
retindex("SD2")
dbSelectArea("SA3")
retindex("SA3")

MS_FLUSH()

Static Function ImpCabec(Tipo)

  NPag:=NPag+1
  @ 02,000 PSAY Replicate("-",limite)
  li := 03
  @ li,000 PSAY SM0->M0_NOMECOM
  @ li,077 PSAY Npag Picture "999"
  li := li+1   
  If Tipo=1
     @ li,000 PSAY "PROGRAMACAO DE VENDAS"
  Else
     @ li,000 PSAY "PROGRAMACAO DE COMPRAS"
  Endif
  cDIni:=DTOS(DATE())
  @ li,070 PSAY SubStr(cDIni,7,2)+"/"+SubStr(cDIni,5,2)+"/"+SubStr(cDIni,1,4)
  li := li+1
  @ li,000 PSAY Replicate("-",limite)
  li := li+1
  If Tipo=1
     If mv_par03=1
        @ li,000 PSAY "PRODUTOS                                     PEDIDOS PENDENTES +"
        li := li+1
        @ li,000 PSAY "                                             PREVISAO VENDAS"
     Else
        @ li,000 PSAY "PRODUTOS                                     PEDIDOS PENDENTES"
        li := li+1
        @ li,000 PSAY " "
     Endif
  Else
     @ li,000 PSAY "INSUMOS                                      NECESSARIA     ESTOQUE     COMPRAR"
  Endif
  li := li+1
  @ li,000 PSAY Replicate("-",limite)
  li:=li+1

Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 06/09/02
                                  

Static Function GRAV_1SX()
   _cAlias:=Select()
   _cSX1:={}
   Aadd(_cSX1,{cPerg,"01","Da Data           ?","MV_CH1", "D",0, 8,0,"G","","MV_PAR01","","","",""})
   Aadd(_cSX1,{cPerg,"02","Ate a Data        ?","MV_CH2", "D",0, 8,0,"G","","MV_PAR02","","","",""})
   Aadd(_cSX1,{cPerg,"03","Inclui Previsao   ?","MV_CH3", "N",0, 1,0,"C","","MV_PAR03","Sim","Nao","",""})
   For S := 1 To Len(_cSX1)
       dbSelectArea("SX1")
       dbSetOrder(1)
       dbSeek(cPerg+Strzero(S,2),.T.)
       If ! Found()
          RecLock("SX1",.T.)
          Replace X1_GRUPO         WITH _cSX1[S,1]
          Replace X1_ORDEM         WITH _cSX1[S,2]
          Replace X1_PERGUNT       WITH _cSX1[S,3]
          Replace X1_VARIAVL       WITH _cSX1[S,4]
          Replace X1_TIPO          WITH _cSX1[S,5]
          Replace X1_PRESEL        WITH _cSX1[S,6]
          Replace X1_TAMANHO       WITH _cSX1[S,7]
          Replace X1_DECIMAL       WITH _cSX1[S,8]
          Replace X1_GSC           WITH _cSX1[S,9]
          Replace X1_VALID         WITH _cSX1[S,10]
          Replace X1_VAR01         WITH _cSX1[S,11]
          Replace X1_DEF01         WITH _cSX1[S,12]
          Replace X1_DEF02         WITH _cSX1[S,13]
          Replace X1_DEF03         WITH _cSX1[S,14]
          Replace X1_F3            WITH _cSX1[S,15]
          MSUnlock()
       Endif
   Next
   dbSelectArea(_cAlias)
Return
