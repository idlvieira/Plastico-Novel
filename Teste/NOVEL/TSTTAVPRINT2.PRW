#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 02/09/03
#INCLUDE "TOPCONN.CH"

User Function OPTST()        // incluido pelo assistente de conversao do AP5 IDE em 02/09/03

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

cPerg:="MTR820"
If  Pergunte(cPerg,.T.)=.F.
	Return
Endif

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

Private oFont, cCode

oFont08n:= TFont():New( "Arial",,08,,.t.,,,,,.f.)
oFont08	:= TFont():New( "Arial",,08,,.f.,,,,,.f.)
oFont09n:= TFont():New( "Arial",,09,,.t.,,,,,.f.)
oFont09s:= TFont():New( "Arial",,09,,.t.,,.t.,,,.f.)
oFont09	:= TFont():New( "Arial",,09,,.f.,,,,,.f.)
oFont10	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
oFont10n:= TFont():New( "Arial",,10,,.t.,,,,,.f.)
oFont12	:= TFont():New( "Arial",,12,,.f.,,,,,.f.) 
oFont12n:= TFont():New( "Arial",,12,,.t.,,,,,.f.)
oFont13	:= TFont():New( "Arial",,13,,.f.,,,,,.f.) 
oFont14	:= TFont():New( "Arial",,14,,.f.,,,,,.f.) 
oFont14n:= TFont():New( "Arial",,14,,.t.,,,,,.f.) 
oFont16	:= TFont():New( "Arial",,16,,.f.,,,,,.f.)
oFont16n:= TFont():New( "Arial",,16,,.t.,,,,,.f.)
oFont18n:= TFont():New( "Arial",,18,,.t.,,,,,.f.)
oFont20	:= TFont():New( "Arial",,20,,.f.,,,,,.f.)

oPrn := TAVPrinter():New()
If  oPrn:Setup() = .F. // para configurar impressora
    nLastkey:=27
    Return
Endif    

/*wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif
*/

RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

DbSelectArea("OP")
dbCloseArea()

Return NIL

Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//@ 0,0 PSAY AvalImp(Limite)

cQry := " SELECT CONCAT(CONCAT(SC2.C2_NUM, SC2.C2_ITEM), SC2.C2_SEQUEN) AS OP, SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_QUJE,"
cQry := cQry + " SC2.C2_PERDA, SC2.C2_DATPRI, SC2.C2_DATPRF, SC2.C2_CC, SC2.C2_COR, SC2.C2_NRFG, SC2.C2_OBS,"
cQry := cQry + " SC2.C2_IMPINS, SB1.B1_DESC, SB1.B1_QE FROM DB2ADMIN.SC2010 AS SC2, DB2ADMIN.SB1010 AS SB1" 
cQry := cQry + " WHERE CONCAT(CONCAT(SC2.C2_NUM, SC2.C2_ITEM), SC2.C2_SEQUEN) >='"+MV_PAR01+"'"
cQry := cQry + " AND CONCAT(CONCAT(SC2.C2_NUM, SC2.C2_ITEM), SC2.C2_SEQUEN) <='"+MV_PAR02+"'"
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
	
/*   IF lEnd
      @ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
      Exit
   EndIF*/
	
   oPrn:StartPage()
   Li := 30					// linha inicial do relatorio
   oPrn:Box(Li,050,Li+3,2300)  
   Li := Li +30
   cBitMap:="\system\Lgrl01.BMP"
   oPrn:SayBitmap(Li,050,cBitMap,40,40)
   oPrn:Say(Li,810,"ORDEM DE PRODUÇÃO",oFont16n,100)
   Li := Li +100
   oPrn:Box(Li,050,Li+3,2300)  // 1º replicate
   Li := Li +200         
   NFi:= Li +100
   L1 := Li
   oPrn:Box(Li,050,NFi,2300)  // 1º box
   oPrn:Say(Li,180,"OPERADORES",oFont10n,100)
   oPrn:Say(Li,600,"H. ENT.",oFont10n,100)
   oPrn:Say(Li,800,"H. SAI.",oFont10n,100)
   oPrn:Say(Li,1000,"OPERADORES",oFont10n,100)
   oPrn:Say(Li,1500,"H. ENT.",oFont10n,100)
   oPrn:Say(Li,1700,"H. SAI.",oFont10n,100)
   Li := NFi +2
   NFi:= Li + 100
   oPrn:Box(Li,050,NFi,2300)  
   Li := NFi +2
   NFi:= Li + 100
   oPrn:Box(Li,050,NFi,2300)  
   Li := NFi +2
   NFi:= Li + 100
   oPrn:Box(Li,050,NFi,2300)  
 
   oPrn:Box(L1,570,NFi,573)  // Imprime a linha vertical
   oPrn:Box(L1,770,NFi,773)  // Imprime a linha vertical
   oPrn:Box(L1,970,NFi,973)  // Imprime a linha vertical
   oPrn:Box(L1,1470,NFi,1473)  // Imprime a linha vertical
   oPrn:Box(L1,1670,NFi,1673)  // Imprime a linha vertical


// outra opção

   Li := Li +200         
   NFi:= Li +400
   L1 := Li
   oPrn:Box(Li,050,NFi,2300)  // Box inteiro
   oPrn:Say(Li,180,"OPERADORES",oFont10n,100)
   oPrn:Say(Li,600,"H. ENT.",oFont10n,100)
   oPrn:Say(Li,800,"H. SAI.",oFont10n,100)
   oPrn:Say(Li,1000,"OPERADORES",oFont10n,100)
   oPrn:Say(Li,1500,"H. ENT.",oFont10n,100)
   oPrn:Say(Li,1700,"H. SAI.",oFont10n,100)
   Li := Li + 100
   oPrn:Box(Li,050,Li+3,2300)  
   Li := Li + 100
   oPrn:Box(Li,050,Li+3,2300)  
   Li := Li + 100
   oPrn:Box(Li,050,Li+3,2300)  
 
   oPrn:Box(L1,570,NFi,573)  // Imprime a linha vertical
   oPrn:Box(L1,770,NFi,773)  // Imprime a linha vertical
   oPrn:Box(L1,970,NFi,973)  // Imprime a linha vertical
   oPrn:Box(L1,1470,NFi,1473)  // Imprime a linha vertical
   oPrn:Box(L1,1670,NFi,1673)  // Imprime a linha vertical


   oPrn:EndPage() 
   dbSelectArea("OP")
   dbSkip()
	
EndDO

oPrn:Preview()

Return NIL

