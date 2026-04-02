#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MOVPROD  ³ Autor ³ Eliene Cerqueira      ³ Data ³ 30.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio dos lancamentos da produção                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

User Function MOVPROD
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  	:= "MOVPROD"    
titulo 	:= "Relacao dos Lançamentos da Produção"
cDesc1 	:= "Este programa ira emitir a relacao dos Lançamentos da Produção"
cDesc2 	:= ""
cDesc3 	:= ""
tamanho	:= "M"
limite 	:= 132
cString := ""
lEnd    := .F.                                                                                                   
cabec1 	:= "      OP                QUANT.      PERDA(Un)     BORRA(Kg)    EMISSAO   MAQUINA   TURNO  OCORRENCIAS  HORAS TRABALHADAS" 
//                0077170100100  9.999.999,99  9.999.999,99  9.999.999,99  99/99/99  999999999   A    XXXXXXXXXX   10:00 AS 11:00
cabec2 	:= ""
lContinua  := .T.
nTipo	:= GetMv("MV_COMP")
LI      := 80
m_pag   := 1
nLastKey := 0
IMP     :=.F.
cPerg   :="MOVPRO"
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                           ³
//³ mv_par01              TM Inicial                               ³
//³ mv_par02              TM Final                                 ³
//³ mv_par03              Produto Inicial                          ³
//³ mv_par04              Produto Final                            ³
//³ mv_par05              OP Inicial                               ³
//³ mv_par06              OP Final                                 ³
//³ mv_par07              Data Inicial                             ³
//³ mv_par08              Data Inicial                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint("",wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

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

DbSelectArea("PROD")
dbCloseArea()
Return 

Static Function C700Imp(lEnd,WnRel,cString,aReturn,tamanho,limite,titulo,;
						cDesc1,cDesc2,cDesc3)

cQry := " SELECT SD3.D3_COD, SD3.D3_OP, SD3.D3_EMISSAO, SD3.D3_QUANT, SD3.D3_PERDAS, SD3.D3_PERDAB, SD3.D3_CC, SD3.D3_TURNO,"
cQry := cQry + " SD3.D3_OCORR, SD3.D3_HORA, SB1.B1_DESC FROM SD3010 AS SD3, SB1010 AS SB1"
cQry := cQry + " WHERE SD3.D3_TM >= '"+MV_PAR01+"'"
cQry := cQry + " AND SD3.D3_TM <= '"+MV_PAR02+"'"
cQry := cQry + " AND SD3.D3_COD>='"+MV_PAR03+"'"
cQry := cQry + " AND SD3.D3_COD<='"+MV_PAR04+"'"
cQry := cQry + " AND SD3.D3_OP>='"+MV_PAR05+"'"
cQry := cQry + " AND SD3.D3_OP<='"+MV_PAR06+"'"
cQry := cQry + " AND SD3.D3_EMISSAO>='"+DTOS(MV_PAR07)+"'"
cQry := cQry + " AND SD3.D3_EMISSAO<='"+DTOS(MV_PAR08)+"'"
cQry := cQry + " AND SD3.D3_ESTORNO<>'S'"
cQry := cQry + " AND SB1.B1_COD=SD3.D3_COD
cQry := cQry + " AND SD3.D_E_L_E_T_<>'*'
cQry := cQry + " ORDER BY SD3.D3_COD, SD3.D3_EMISSAO, SD3.D3_OP, SD3.D3_TURNO, SD3.D3_CC

Tcquery cQry new alias "PROD"

dbSelectArea("PROD")
SetRegua(RecCount())
xCod:=Space(6)
Ok:=.F.
xQuant:=xPerda:=0    
tQuant:=tPerda:=0    
xBorra:=tBorra:=0    

While !EOF()

  IncRegua()
  If lAbortPrint
   	  @LI,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
  Endif 

  If xCod<>PROD->D3_COD
     If Ok
     	LI := LI + 1
        @ LI,021 PSAY xQuant     Picture "@E 9,999,999.99"
   	    @ LI,035 PSAY xPerda     Picture "@E 9,999,999.99"
   	    @ LI,049 PSAY xBorra     Picture "@E 9,999,999.99"
     	LI := LI + 2
     Endif
     xCod:=PROD->D3_COD
     If LI < 70
        @ LI,01 PSAY Alltrim(xCod)+" - "+PROD->B1_DESC
        LI := LI + 1
     Endif
     tQuant:=tQuant+xQuant
     tPerda:=tPerda+xPerda    
     tBorra:=tBorra+xBorra    
     xQuant:=xPerda:=xBorra:=0
  Endif

  If LI > 70
     Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
     @ LI,01 PSAY Alltrim(xCod)+" - "+PROD->B1_DESC
     LI := LI + 1
  Endif   
//      0077170100100  9.999.999,99  9.999.999,99  99/99/99  999999999  A  XXXXXXXXXX  10:00 AS 11:00
  @ LI,006      PSAY PROD->D3_OP
  @ LI,PCOL()+2 PSAY PROD->D3_QUANT Picture "@E 9,999,999.99"
  @ LI,PCOL()+2 PSAY PROD->D3_PERDAS Picture "@E 9,999,999.99"
  @ LI,PCOL()+2 PSAY PROD->D3_PERDAB Picture "@E 9,999,999.99"
  @ LI,PCOL()+2 PSAY SUBSTR(PROD->D3_EMISSAO,7,2)+"/"+SUBSTR(PROD->D3_EMISSAO,5,2)+"/"+SUBSTR(PROD->D3_EMISSAO,3,2)
  @ LI,PCOL()+2 PSAY PROD->D3_CC
  @ LI,PCOL()+3 PSAY PROD->D3_TURNO
  @ LI,PCOL()+4 PSAY PROD->D3_OCORR
  @ LI,PCOL()+2 PSAY PROD->D3_HORA
  xQuant:=xQuant+PROD->D3_QUANT
  xPerda:=xPerda+PROD->D3_PERDAS
  xBorra:=xBorra+PROD->D3_PERDAB
  Ok:=.T. 
  LI := LI + 1
  dbSelectArea("PROD")
  dbSkip()
EndDo
If Ok
   LI := LI + 1
   @ LI,021 PSAY xQuant     Picture "@E 9,999,999.99"
   @ LI,035 PSAY xPerda     Picture "@E 9,999,999.99"
   @ LI,049 PSAY xBorra     Picture "@E 9,999,999.99"
   tQuant:=tQuant+xQuant
   tPerda:=tPerda+xPerda    
   tBorra:=tBorra+xBorra    
   LI := LI + 2
Endif
If tQuant<>0
   @ LI,022 PSAY tQuant     Picture "@E 9,999,999.99"
   @ LI,035 PSAY tPerda     Picture "@E 9,999,999.99"
   @ LI,049 PSAY tBorra     Picture "@E 9,999,999.99"
Endif
@ LI,01 PSAY "."
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return        
