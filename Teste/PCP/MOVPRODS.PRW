#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"  
   


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MOVPRODS ³ Autor ³ Eliene Cerqueira      ³ Data ³ 30.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio dos lancamentos da produção - Sintético          ³±±
±±³            Por grupo de produtos                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

User Function MOVPRODS
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  	:= "MOVPRODS"    
titulo 	:= "Movimentação de Estoque da Produção-Sintético"
cDesc1 	:= "Este programa ira emitir a movimentação de estoque da Produção"
cDesc2 	:= ""
cDesc3 	:= ""
tamanho	:= "M"
limite 	:= 132
cString := "SD3"
lEnd    := .F.                                                                                                             
cabec1 	:= "PRODUTO                                QUANT.PRODUZIDA    INSUMO                                QUANT.CONSUMIDA" 
//          999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    9.999.999,99     999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    9.999.999,99
cabec2 	:= ""
lContinua  := .T.
nTipo	:= GetMv("MV_COMP")
LI      := 80
m_pag   := 1
nLastKey := 0
IMP     :=.F.
cPerg   :="ATC010"
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
cArqTrb1:=cArqTrb2:=cArqTrb3:=""

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              De Emissao                            ³
//³ mv_par02              Ate Emissao                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C700Imp(@lEnd,wnrel,cString,aReturn,tamanho,limite,;	
						  titulo,cDesc1,cDesc2,cDesc3)},Titulo)
If !Empty( cArqTrb1 )
   dbSelectArea("QUERY1")
   dbCloseArea()
   FErase( cArqTrb1+".*")
Endif
If !Empty( cArqTrb2 )
   dbSelectArea("QUERY2")
   dbCloseArea()
   FErase( cArqTrb2+".*")
Endif
DbSelectArea("PRODS")
dbCloseArea()
Return 

Return 

Static Function C700Imp(lEnd,WnRel,cString,aReturn,tamanho,limite,titulo,;
						cDesc1,cDesc2,cDesc3)

aStru:={}
AADD( aStru, {"COD_P"  ,"C" ,6  ,0} )
AADD( astru, {"DESC_P" ,"C" ,30 ,0} )
AADD( aStru, {"QUANT"  ,"N" ,18 ,2} )
cArqTrb1:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb1,"QUERY1",.F.)
IndRegua("QUERY1",cArqTrb1,"COD_P")

aStru:={}
AADD( aStru, {"COD_P"  ,"C" ,6  ,0} )
AADD( aStru, {"COD_I"  ,"C" ,6  ,0} )
AADD( astru, {"DESC_I" ,"C" ,30 ,0} )
AADD( aStru, {"QUANT"  ,"N" ,18 ,2} )
cArqTrb2:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb2,"QUERY2",.F.)
IndRegua("QUERY2",cArqTrb2,"COD_P+COD_I")

cQry := " SELECT SD3.D3_OP, SD3.D3_TM, SD3.D3_COD, SD3.D3_EMISSAO, SD3.D3_QUANT, SB1.B1_DESC"
cQry := cQry + " FROM SD3010 AS SD3, SB1010 AS SB1"
cQry := cQry + " WHERE SD3.D3_EMISSAO>='"+DTOS(MV_PAR01)+"'"
cQry := cQry + " AND SD3.D3_EMISSAO<='"+DTOS(MV_PAR02)+"'"
cQry := cQry + " AND SD3.D3_ESTORNO<>'S'"
cQry := cQry + " AND SD3.D3_OP<>'           '"
cQry := cQry + " AND (SUBSTRING(SD3.D3_TM,1,1)='3' OR SD3.D3_TM='999')"
cQry := cQry + " AND SB1.B1_COD=SD3.D3_COD
cQry := cQry + " AND SD3.D_E_L_E_T_<>'*'
cQry := cQry + " ORDER BY SD3.D3_OP, SD3.D3_NUMSEQ, SD3.D3_TM

Tcquery cQry new alias "PRODS"

dbSelectArea("PRODS")
SetRegua(RecCount())
dbGoTop()
While !EOF()

  IncRegua()
  cClas1:=""
  DbSelectArea("SB1")
  DbSetOrder(1)
  DbSeek(xFilial("SB1")+PRODS->D3_COD,.T.)

  DbselectArea("SZ2")
  DbSeek(xFilial()+SB1->B1_CLASSE1,.T.)
  
  If PRODS->D3_TM<>'999'
     CODP:=Substring(PRODS->D3_COD,1,6)
     DbSelectArea("QUERY1")
     If dbSeek(Substring(PRODS->D3_COD,1,6),.F.)
        Reclock("QUERY1",.F.)
     Else
        Reclock("QUERY1",.T.)
        QUERY1->COD_P  := Substring(PRODS->D3_COD,1,6)
        QUERY1->DESC_P := SZ2->Z2_DESC
     Endif
     QUERY1->QUANT  := QUERY1->QUANT+PRODS->D3_QUANT
  Else
     DbSelectArea("QUERY2")
     If dbSeek(CODP+Substring(PRODS->D3_COD,1,6),.F.)
        Reclock("QUERY2",.F.)
     Else
        Reclock("QUERY2",.T.)
        QUERY2->COD_P  := CODP
        QUERY2->COD_I  := Substring(PRODS->D3_COD,1,6)
        QUERY2->DESC_I := SZ2->Z2_DESC
     Endif
     QUERY2->QUANT  := QUERY2->QUANT+PRODS->D3_QUANT
  Endif
  dbSelectArea("PRODS")
  dbSkip()
Enddo

DbSelectArea("QUERY1")
DbGoTop()      
While QUERY1->(!EOF())

   If lAbortPrint
   	  @LI,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif 

   If LI > 70
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
      LI := LI + 1
   Endif   
   @ LI,000      PSAY QUERY1->COD_P + "-" + QUERY1->DESC_P
   @ LI,PCOL()+4 PSAY QUERY1->QUANT Picture "@E 9,999,999.99"
   DbSelectArea("QUERY2")
   DbSeek(QUERY1->COD_P,.T.)
   While QUERY2->(!EOF()) .AND. QUERY2->COD_P=QUERY1->COD_P
      If LI > 70
         Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
         LI := LI + 1
      Endif   
      @ LI,058      PSAY QUERY2->COD_I + "-" + QUERY2->DESC_I
      @ LI,PCOL()+4 PSAY QUERY2->QUANT Picture "@E 9,999,999.99"
      LI := LI + 1
      dbSkip()
  Enddo    
  LI := LI + 1
  dbSelectArea("QUERY1")
  dbSkip()
EndDo
@ LI,01 PSAY "."
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return        
