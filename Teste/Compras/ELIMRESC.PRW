#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

User Function ELIMRESC()        // incluido pelo assistente de conversao do AP6 IDE em 18/03/04

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ ELIMRESC  ³ Autor ³   Eliene Cerqueira   ³ Data ³ 11.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Elimina pedidos de compra com residuo                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Compras                                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

SetPrvt("WLOCAL,CPROG1,CPROG2,CPROG3,CPROG4,AROTINA")
SetPrvt("CCADASTRO,AFIXE")

cPROG1 := 'EXECBLOCK("resC7")'
*
aRotina := {{"Pesquisa","AxPesqui",0,1},;
            {"Visualiza","AxVisual",0,2},;
            {"Elimina Resíduo",cProg1,0,5}}
aFixe := {{"PEDIDO","C7_NUM"}}
cCadastro := "Pedidos de Compra"
Mbrowse(3,8,22,78,"SC7",aFixe)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

User Function RESC7()        // incluido pelo assistente de conversao do AP6 IDE em 20/04/04

If C7_QUANT=C7_QUJE
   MsgBox("PEDIDO/ITEM TOTALMENTE ATENDIDO!")
   Return
Endif
                                     
IF  MsgBox("CONFIRMA A ELIMINAÇÃO DO RESÍDUO DESTE REGISTRO CONFIRMA??","CONFIRMA ?","YESNO")
    delOK1()
ENDIF

REturn

// Substituido pelo assistente de conversao do AP6 IDE em 20/04/04 ==> Function BotOk1
Static Function delOk1()
***************
If C7_QUJE<>0
   Reclock("SC7",.F.)
   C7_QUANT:=C7_QUJE
   C7_RESIDUO:=" "
   Dbunlock()     
Endif
If C7_QUJE=0
   Reclock("SC7",.F.)
   SC7->( DBDELETE( ) )
   Dbunlock()
Endif

Return
