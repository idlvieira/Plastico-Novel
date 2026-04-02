#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 23/07/02

User Function ETIQMAN()        // incluido pelo assistente de conversao do AP5 IDE em 23/07/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ ETIQAUT   º Autor ³ 				     º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ IMPRESSAO DE ETIQUETAS AUTOMATICAS PELO PEDIDO             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO                                                º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

cString:="SA1"
cDesc1:= "Este Programa tem como objetivo imprimir as etiquetas no formato"
cDesc2:= "1 x 1, selecionado pelo usuario"
cDesc3:= ""
tamanho:="M"
limite:=132
aReturn := { "Zebrado", 1,"Administracao", 1, 1, 1, "",1 }
nomeprog:="ETIQMAN"
aLinha  := { }
nLastKey := 0
titulo      :="Impressao de etiquetas - 1 X 1"
cabec1      :=""
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0  //Variavel que acumula numero da pagina

wnrel:="ETIQMAN"            //Nome Default do relatorio em Disco

//SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)
wnrel:=SetPrint(cString,wnrel,,Titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Saida                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TcodCli := Space(06)
TlojCLi := Space(02)
Tendcli := Space(40)
Tnomcli := Space(50)
Tcidade := Space(15)
Test    := Space(02)
Tbairro := Space(20)
Tfone   := Space(10)
Tcep    := Space(08)
Tpedido := Space(06)
TProd   := Space(15)
TdescPro:= Space(30)
TqtdEmb := 0
Tqtdetq := 0

@ 00,00 to 280,580 Dialog tela1 Title "Impressao de Etiquetas 1 x 1"
@ 06, 05 Say "Cliente "
@ 06, 30 Get TcodCli Valid !Empty(TcodCli) F3 "SA1"
@ 06, 65 Get TlojCli Valid Etiq1()// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> @ 06, 65 Get TlojCli Valid Execute(Etiq1)
@ 18, 05 Say "Nome    "
@ 18, 30 Get TnomCli SIZE 200,20 Picture "@!S40"
@ 30, 05 Say "Endereco"
@ 30, 30 Get TendCli SIZE 200,20 
@ 42, 05 Say "Bairro  "
@ 42, 30 Get Tbairro SIZE 100,20 
@ 54, 05 Say "Cidade"
@ 54, 30 Get Tcidade SIZE 100,20 
@ 54,140 Say "CEP "
@ 54,160 Get Tcep    Picture "@R 99999-999"
@ 54,222 Say "Estado"
@ 54,243 Get Test  
@ 66, 05 Say "Telefone "
@ 66, 30 Get  Tfone  SIZE 50,20
@ 85,00 to 85,579
@ 92,  05 Say "Pedido   "
@ 92,  30 Get Tpedido Picture "@!" Valid !Empty(Tpedido) .and. Pedido()// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> @ 92,  30 Get Tpedido Picture "@!" Valid !Empty(Tpedido) .and. Execute(Pedido)
@ 104, 05 Say "Produto  "
@ 104, 30 GET TProd SIZE 50,20 PICTURE "999999999999999" VALID NaoVazio() .and. Mostra(TProd) F3 "SB1"
@ 116, 05 Say "Qtd./Emb "
@ 116, 30 Get Tqtdemb  Picture "999999"
@ 116,100 Say "Qtd. Etq...: "
@ 116,135 Get Tqtdetq  Picture "999999"
@ 121,230 BmpButton Type 01 Action Relat()// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> @ 121,230 BmpButton Type 01 Action Execute(Relat)
@ 121,260 BmpButton Type 02 Action Close(Tela1)
Activate Dialog Tela1 Centered

Return


// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> Function Relat
Static Function Relat()

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> RptStatus({|| Execute(RptDetail) })

Return


// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> Function RptDetail
Static Function RptDetail()


@ 0,0 PSay AvalImp(limite)
nLastKey  := 0 
lContinua := .T.
nLin      := 2
nLinIni := nLin                      // Armazema Linha Inicial da Impressao

ImpEtq()// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> Execute(ImpEtq)

Return


// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> Function Etiq1
Static Function Etiq1()
Tnomcli := Space(50)
Tcidade := Space(15)
Test    := Space(02)
Tbairro := Space(20)
Tfone   := Space(10)
Tcep    := Space(08)

Dbselectarea("SA1")
Dbsetorder(1) 
dbgotop()
DbSeek(xFilial()+TcodCli+Tlojcli)
If Found()
	Tnomcli := SA1->A1_NOME
    If  !Empty(SA1->A1_CEPE)
		Tcep := SA1->A1_CEPE
	Else
		Tcep := SA1->A1_CEP
	Endif
	Tfone   := SA1->A1_TEL        
    If  !Empty(SA1->A1_ENDENT)
  		Tendcli := SA1->A1_ENDENT
  	Else
  		Tendcli := SA1->A1_END
  	Endif
  	If  !Empty(SA1->A1_BAIRROE)
  		Tbairro := SA1->A1_BAIRROE
  	Else
  		Tbairro := SA1->A1_BAIRRO
  	Endif
  	If !Empty(SA1->A1_MUNE)
		Tcidade := SA1->A1_MUNE
	Else
		Tcidade := SA1->A1_MUN
	Endif
	If !Empty(SA1->A1_ESTE)
   		Test    := SA1->A1_ESTE
    Else
        Test    := SA1->A1_EST
    Endif

Else
	Tendcli := "CLIENTE NAO ENCONTRADO"
	Tnomcli := Space(50)
	Tcidade := Space(15)
	Test    := Space(02)
	Tbairro := Space(20)
	Tfone   := Space(10)
	Tcep    := Space(08)
Endif

Return


// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> Function ImpEtq
Static Function ImpEtq()

Close(Tela1)
nLinIni := nLin                      // Armazema Linha Inicial da Impressao
nOpc       := 1
SetPrc(0,0)

@ nLin,00 PSay Chr(15)   // ALTERADO NLIN-1
nCol := 0
nLin := nLin + 1

y   := 0

While y < TqtdEtq

      @ nLin,nCol    PSay Tnomcli
	  nLin := nLin + 1
      @ nLin,nCol    PSay AllTrim(Tendcli) + " - " + Tbairro
	  If !Empty(Tcep)
	     nLin := nLin + 2
		 @ nLin, nCol PSay Tcep Picture "@R 99999-999"
    	 @ nLin, 16 PSay alltrim(Tcidade) + "-" + trim(Test) + " Tel: "+alltrim(Tfone)
	  EndIf       
	  If Empty(Tcep)
		 nLin := nLin + 2
    	 @ nLin, 16 PSay alltrim(Tcidade) + "-" + trim(Test) + " Tel: "+alltrim(Tfone)
	  Endif
      nLin := nLin + 6
      @ nLin,nCol    PSay TPedido + Space(9) + Str(TqtdEmb,3) + " VOL"+ Space(3) + Tdescpro
      nLin := nLin + 9
      y    := y + 1

End

nLin:=nLin-6 // Alterado para o posicionamento final (nao existia)
// @ nLin, 000 PSay " " + chr(18) // Descompressao de Impressao
@ nLin, 000 PSay " "		

If aReturn[5] == 1
      //  Testa se o relatorio foi direcionado para disco, esvazia
      //  os Buffers e chama funcao de Spool padrao.
      Set Printer To
      Commit
      ourspool( wnrel )
EndIf

MS_FLUSH()      // Libera fila de relatorios em spool.

Return


// Substituido pelo assistente de conversao do AP5 IDE em 23/07/02 ==> Function Pedido
Static Function Pedido()

Dbselectarea("SC6")
Dbseek(xFilial()+Tpedido)
If !Found()
	MsgBox("Atencao, Pedido Nao Encontrado !","Pedido Inexistente","ALERT")
Endif

Return

Static Function Mostra()
***************
dbSelectArea("SB1")
DbSeek(xFilial("SB1") + TProd, .T.)
@ 104,85  SAY  SB1->B1_DESC
TdescPro:=SB1->B1_DESC
REturn
