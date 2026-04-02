#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 02/09/03
#INCLUDE "TOPCONN.CH"

User Function NOVIMPOP()        // incluido pelo assistente de conversao do AP5 IDE em 02/09/03

  

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ MATR820  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07.07.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao Das Ordens de Producao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ Novo Lay-out ³ Autor ³ Eliene            ³ Data ³ 25/01/05 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Private aReturn  := {"Zebrado",1,"Administracao", 1, 2, 1, "",1 }
cPerg    :="MTR820"
nLastKey := 0
titulo   := "Ordem de Produção"
cString  := "SC2"
wnrel    :="OP"
cDesc    := "Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o"
tamanho  := "P"
limite   := 80
nomeprog := "OP"
nTipo    := 18
cCabec1  := SM0->M0_NOME+"        O R D E M   D E   P R O D U C A O       NRO :"
cCabec2  := SM0->M0_NOME+"                I N S U M O S                   NRO :"
m_pag    := 1

pergunte("MTR820",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Da OP                                 ³
//³ mv_par02            // Ate a OP                              ³
//³ mv_par03            // Da data                               ³
//³ mv_par04            // Ate a data                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//³ mv_par05            // Imprime roteiro de operacoes          ³
//³ mv_par06            // Imprime codigo de barras              ³
//³ mv_par07            // Imprime Nome Cientifico               ³
//³ mv_par08            // Imprime Op Encerrada                  ³
//³ mv_par09            // Impr. por Ordem de                    ³
//³ mv_par10            // Impr. OP's Firmes, Previstas ou Ambas ³
//³ mv_par11            // Impr.                                 *
//³ mv_par12            // Nr.linhas para rodape ref.a Mov.Prods *
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

DbSelectArea("OP")
dbCloseArea()

Return NIL

Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

@ 0,0 PSAY AvalImp(Limite)

//cQry := " SELECT CONCAT(CONCAT(SC2.C2_NUM, SC2.C2_ITEM), SC2.C2_SEQUEN) AS OP, SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_QUJE,"
cQry := " SELECT SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS OP, SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_QUJE,"
cQry := cQry + " SC2.C2_PERDA, SC2.C2_DATPRI, SC2.C2_DATPRF, SC2.C2_CC, SC2.C2_COR, SC2.C2_NRFG, SC2.C2_OBS,"
cQry := cQry + " SC2.C2_IMPINS, SB1.B1_DESC, SB1.B1_QE FROM SC2010 AS SC2, SB1010 AS SB1" 
cQry := cQry + " WHERE SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN >='"+MV_PAR01+"'"
cQry := cQry + " AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN  <='"+MV_PAR02+"'"
cQry := cQry + " AND SC2.C2_DATPRF >= '"+DTOS(MV_PAR03)+"'"
cQry := cQry + " AND SC2.C2_DATPRF <= '"+DTOS(MV_PAR04)+"'"
cQry := cQry + " AND SB1.B1_COD = SC2.C2_PRODUTO"
cQry := cQry + " AND SC2.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN ASC"

Tcquery cQry new alias "OP"
        

dbSelectArea("OP")
SetRegua(RecCount())

While !EOF()

   IncRegua()
	
   IF lEnd
      @ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
      Exit
   EndIF
	
   IncRegua()
	
   Li := 0					// linha inicial do relatorio
   @Li,000 PSay REPLICATE("-",80)
   Li++
   @Li,000  PSay cCabec1
   @Li,069  PSay OP->OP
   Li++
   @Li,000 PSay REPLICATE("-",80)
   Li++
   @Li,000 PSay "Produto   : "+OP->C2_PRODUTO+" "+SUBSTR(OP->B1_DESC,1,30)+" Emissao   :  "+DTOC(dDatabase)
   Li++

   @Li,000 PSay "Quantidade:"
   @Li,011 PSay OP->C2_QUANT	PICTURE "@E 999,999.99"
   @Li,028 PSay "Saldo:"
   @Li,035 PSay OP->C2_QUANT-OP->C2_QUJE-OP->C2_PERDA PICTURE "@E 999,999.99"
   @Li,059 PSay "Turno Ant.:__________"
   Li++
   Li++
   @ Li,000 	Psay "MAQUINA:_______ TURNO:_______ SUPERVISOR:___________________ DATA:____/____/____"
   Li++                                                                                               
   Li++                                                                                               
   @ Li,000 	Psay "                                PRODUCAO                                        "
   Li++
   @ Li,000 	Psay "--------------------------------------------------------------------------------"   
   Li++                                                                                                
   @ Li,000 	Psay "|   L.I.  |   L.F.  |  TOTAL   |  PERDAS  |    V2   | SALDO |  FISICO  | VISTO |"
   Li++                                                                                               
   @ Li,000 	Psay "|---------+---------+----------+----------+---------+-------+----------+-------|"
   Li++                                                                                               
   @ Li,000 	Psay "|         |         |          |          |         |       |          |       |"
   Li++                                                                                               
   @ Li,000 	Psay "--------------------------------------------------------------------------------"
   Li++                                                                                               
   Li++                                                                                               
   @ Li,000 	Psay "                            PARADA DE MAQUINA                                   "
   Li++
   @ Li,000 	Psay "--------------------------------------------------------------------------------"   
   Li++
   @ Li,000 	Psay "|MOTIVO| H. INI. | H. FIN. |MOTIVO| H. INI. | H. FIN. |MOTIVO| H. INI.| H. FIN.|" 
   Li++                                                                                               
   @ Li,000 	Psay "|---------+---------+---------+---------+---------+---------+--------+---------|"
   Li++                                                                                               
   @ Li,000 	Psay "|         |         |         |         |         |         |        |         |"
   Li++                                                                                               
   @ Li,000 	Psay "|---------+---------+---------+---------+---------+---------+--------+---------|"
   Li++                                                                                               
   @ Li,000 	Psay "|         |         |         |         |         |         |        |         |"
   Li++                                                                                               
   @ Li,000 	Psay "--------------------------------------------------------------------------------"
   Li++                                                                                               
   Li++                                                                                               
   @ Li,000 	Psay "                             CONTROLE DE PESO                                   "
   Li++
   @ Li,000 	Psay "--------------------------------------------------------------------------------"   
   Li++                                                                                                
   @ Li,000 	Psay "|  PESO   | HORARIO |  PESO   | HORARIO |  PESO   | HORARIO |  PESO  | HORARIO |"
   Li++                                                                                               
   @ Li,000 	Psay "|---------+---------+---------+---------+---------+---------+--------+---------|"
   Li++                                                                                               
   @ Li,000 	Psay "|         |         |         |         |         |         |        |         |"
   Li++                                                                                               
   @ Li,000 	Psay "--------------------------------------------------------------------------------"
   Li++                                                                                               
   Li++                                                                                               
   @ Li,000 	Psay "                             CONTROLE DE CICLO                                  "
   Li++
   @ Li,000 	Psay "--------------------------------------------------------------------------------"   
   Li++                                                                                                
   @ Li,000 	Psay "|  CICLO  | MOTIVO  |  CICLO  | MOTIVO  |  CICLO  | MOTIVO  |  CICLO | MOTIVO  |"
   Li++                                                                                               
   @ Li,000 	Psay "|---------+---------+---------+---------+---------+---------+--------+---------|"
   Li++                                                                                               
   @ Li,000 	Psay "|         |         |         |         |         |         |        |         |"
   Li++                                                                                               
   @ Li,000 	Psay "|---------+---------+---------+---------+---------+---------+--------+---------|"
   Li++                                                                                               
   @ Li,000 	Psay "|         |         |         |         |         |         |        |         |"
   Li++                                                                                               
   @ Li,000 	Psay "--------------------------------------------------------------------------------"   
   Li++                                                                                               
   Li++                                                                                               
   @ Li,000 	Psay "                            CONTROLE DE PERDAS                                "
   Li++
   @ Li,000 	Psay "--------------------------------------------------------------------------------"   
   Li++                                                                                                
   @ Li,000 	Psay "|  QUANT  | MOTIVO  |  QUANT  | MOTIVO  |  QUANT  | MOTIVO  |  QUANT | MOTIVO  |"
   Li++                                                                                               
   @ Li,000 	Psay "|---------+---------+---------+---------+---------+---------+--------+---------|"
   Li++                                                                                               
   @ Li,000 	Psay "|         |         |         |         |         |         |        |         |"
   Li++                                                                                               
   @ Li,000 	Psay "|---------+---------+---------+---------+---------+---------+--------+---------|"
   Li++                                                                                               
   @ Li,000 	Psay "|         |         |         |         |         |         |        |         |"
   Li++                                                                                               
   @ Li,000 	Psay "--------------------------------------------------------------------------------"
   Li++
   Li++
   @ Li,000 	Psay "RELATORIO DA MAQUINA                                                            "
   Li++
   @ Li,000 	Psay "--------------------------------------------------------------------------------"   
   Li++
   @ Li,000 	Psay "|                                                                              |"
   Li++                                                                                               
   @ Li,000 	Psay "|------------------------------------------------------------------------------|"
   Li++                                                                                               
   @ Li,000 	Psay "|                                                                              |"
   Li++                                                                                               
   @ Li,000 	Psay "|------------------------------------------------------------------------------|"
   Li++                                                                                               
   @ Li,000 	Psay "|                                                                              |"
   Li++                                                                                               
   @ Li,000 	Psay "|------------------------------------------------------------------------------|"
   Li++                                                                                               
   @ Li,000 	Psay "|                                                                              |"
   Li++                                                                                               
   @ Li,000 	Psay "--------------------------------------------------------------------------------"
   Li++                                                                                               
   @ Li,000 	Psay "--------------------------------------------------------------------------------"
   Li++                                  
   @ Li,000 	Psay "|1-TROCA MOLDE   | 7-FALTA D'AGUA      |13-FALTA OPERADOR   |19-SEM PROGRAMACAO|"
   Li++                               
   @ Li,000 	Psay "|2-FALTA ENERGIA | 8-CONSERTO MOLDE    |14-TROCA POSTICO    |20-FALHA INJECAO  |"                                                                                
   Li++               
   @ Li,000 	Psay "|3-DEFEITO ELET. | 9-TROCA DE COR      |15-REVISAO ELETRICA |21-TRINCA         |"                                                                                
   Li++               
   @ Li,000 	Psay "|4-DEFEITO MEC.  |10-SUJEIRA MATERIAL  |16-FALTA DE PARTES  |22-BOLHA          |"                                                                                
   Li++                               
   @ Li,000 	Psay "|5-MANUTENCAO    |11-PRODUTO C/REBARBA |17-ENTUP. BICO      |23-CHUP           |"                                                                                
   Li++               
   @ Li,000 	Psay "|6-FALTA M.PRIMA |12-DEFEITO NO MOLDE  |18-INICIO/FIM PROD  |24-OUTROS         |"                                                                                
   Li++                                                                                               
   @ Li,000 	Psay "--------------------------------------------------------------------------------"
   m_pag++
   Li := 0					// linha inicial - ejeta automatico
   aArray:={}

   If OP->C2_IMPINS="S"  
      PCOL() = 0
      XQUANT := 0 
      @Li,000 PSay REPLICATE("-",80)
      Li++
      @Li,000  PSay cCabec2
      @Li,069  PSay OP->OP
      Li++
      @Li,000 PSay REPLICATE("-",80)
      Li++
      Li++
      DbSelectArea("SB1")
      DbSetOrder(1)
      DbSeek(xFilial("SB1")+OP->C2_PRODUTO,.F.)
      IF SUBSTR(OP->C2_PRODUTO,1,3) <> "MOD" 
         XQUANT = OP->C2_QUANT
         Li++
         Li++
         @Li,000 PSay "Produto : "+ALLTRIM(OP->C2_PRODUTO)+" - "+SUBSTR(SB1->B1_DESC,1,30) 
         Li++
         @LI,10 Psay "QUANTIDADE A SER PRODUZIDA->>"
         @LI,42 Psay XQUANT Picture "@E 999,999,999.99"
         Li++
         Li++             
         @LI,60 Psay "QTD NECESSARIA"
         Li++
      ENDIF            
      
                  
      DbSelectArea("SD4")
      DbSetOrder(2)
      DBGOTOP()
      DbSeek(xFilial("SD4")+OP->OP,.T.) 
      
      Do while !EOF() .and. SD4->D4_OP = OP->OP 
                    
         IF SUBSTR(TRIM(SD4->D4_COD),1,1) <> 'M' 
            Li++
            DbSelectArea("SB1")
            DbSetOrder(1)
            DbSeek(xFilial("SB1")+SD4->D4_COD,.F.)
            @Li,010 PSay ALLTRIM(SD4->D4_COD)+" - "+SUBSTR(SB1->B1_DESC,1,30)
            DbSelectArea("SG1")
            DbSetOrder(1)
            DbSeek(xFilial("SG1")+OP->C2_PRODUTO+SD4->D4_COD,.T.)
            // QUANTUSA = SG1->G1_QUANT * SD4->D4_QUANT
            QUANTUSA = SD4->D4_QUANT            
            @LI,060 Psay QUANTUSA Picture "@E 999,999.999999"
            QUANTUSA = 0
            Li++
         
         ENDIF
         
         
          DbSelectArea("SD4")        
          dbSkip()
          IF EOF()
             Exit
          endif   
       ENDDO    
                   
   ENDIF   
   
   dbSelectArea("OP")
   dbSkip()
     
 ENDDO     

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL

