#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"                                               
//ETIQUETA NOVEL
//CRIADO POR DANIEL GOUVEA, BASEADO NO CODIGO DE JOÃO PAULO
//DATA: 23/09/10

User Function ETIQMAN2()
Tpedido   := Space(06)
TProd     := Space(15)
TdescPro  := Space(40)
Tcliente  := Space(06)
TdescCli  := Space(20)
TqtdEmb   := 0
Tqtdetq   := 0
Tqtdeprod := 0
Titped    := Space(02)
qtde      := 0
qtderes   := 0     
_prod     := space(60)

@ 00,00 to 280,580 Dialog tela1 Title "IDENTIFICACAO DE LOTES DE PRODUTOS"

@ 06, 05 Say "Pedido "                                                         
@ 06, 40 Get Tpedido Picture "@!" Valid !Empty(Tpedido) .and. Pedido() F3 "SC6"
@ 06, 70 Say "Item Pedido "
@ 06,100 Get Titped Valid itemped() Picture  "99"
@ 17, 05 Say "Cliente " 
@ 17, 40 Get Tcliente Picture "999999" Valid Cliente() F3 "SA1NOV" 
@ 28, 05 Say "Produto  "
@ 28, 40 GET TProd SIZE 50,20 PICTURE "999999999999999" VALID NaoVazio() .and. Mostra(TProd) F3 "SB1"
@ 39, 05 Say "Qtd. Palete: "
@ 39, 40 Get Tqtdemb  Picture "99999"
@ 39,100 Say "Qtd.a Produzir: "
@ 39,135 Get Tqtdeprod  Picture "9999999"
@ 44,230 BmpButton Type 01 Action Relat()
@ 44,260 BmpButton Type 02 Action Close(Tela1)
Activate Dialog Tela1 Centered
                                      
return

Static Function relat()
Close(Tela1)
nCol  := 0
y   := 0
qtde := Int(Tqtdeprod / Tqtdemb)
qtderes:= Tqtdeprod - (qtde * Tqtdemb)


while y < qtde
		MSCBPRINTER("OS 214","LPT1",,27,.F., , , , , ,.T.)
		MSCBCHKStatus(.F.)
		MSCBBEGIN(1,1)
		nLinha := 1.5 
		MSCBSay(05,nLinha,"( )RETRABALHO ( )V3R3      |  ( )REPROVADO          ","N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"( )APROVADO ( )REPROVADO   |  ( )APROVADO           ","N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"INSPECAO APOS INJECAO      |  INSPECAO APOS GRAVACAO","N", "1","1,2")
		nLinha += 4.5
		MSCBSay(05,nLinha,"DATA PRODUCAO:           /           /               ","N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"PRODUZIDO TURNO:    A(  )         B(  )        C(  ) ","N", "1","1,2")		
		nLinha += 3.5
		MSCBSay(05,nLinha,"Pedido: "+TPedido + " Item: "+Titped +"  QTDADE NO PALETE:"+ Str(Tqtdemb,5),"N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"Produto: "+(TdescPro),"N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"Cliente: "+(Tcliente)+"-"+(TdescCli),"N", "1","1,2")
		MSCBEND()
		MSCBCLOSEPRINTER()    		
	y    := y + 1
enddo                         

if qtderes > 0
		MSCBPRINTER("OS 214","LPT1",,27,.F., , , , , ,.T.)
		MSCBCHKStatus(.F.)
		MSCBBEGIN(1,1)
		nLinha := 1.5 
		MSCBSay(05,nLinha,"( )RETRABALHO ( )V3R3      |  ( )REPROVADO          ","N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"( )APROVADO ( )REPROVADO   |  ( )APROVADO           ","N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"INSPECAO APOS INJECAO      |  INSPECAO APOS GRAVACAO","N", "1","1,2")
		nLinha += 4.5
		MSCBSay(05,nLinha,"DATA PRODUCAO:           /           /               ","N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"PRODUZIDO TURNO:    A(  )         B(  )        C(  ) ","N", "1","1,2")		
		nLinha += 3.5
		MSCBSay(05,nLinha,"Pedido: "+TPedido + " Item: "+Titped +"  QTDADE NO PALETE:"+ Str(qtderes,5),"N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"Produto: "+(TdescPro),"N", "1","1,2")
		nLinha += 3.5
		MSCBSay(05,nLinha,"Cliente: "+(Tcliente)+"-"+(TdescCli),"N", "1","1,2")
		MSCBEND()
		MSCBCLOSEPRINTER()    		
	y    := y + 1
			
end

return 
                     
Static Function Pedido()
if (Tpedido $ GETMV("MV_UPEDPRO")) 
Tcliente := Space(06)
    TProd    := Space(15)
    Titped   := Space(02)
    TdescCli := Space(80)
    TdescPro := Space(40)
    return .t.
endif

Dbselectarea("SC5")
dbsetorder(1)
if Dbseek(xFilial()+Tpedido)
	Tcliente := SC5->C5_CLIENTE
	return .t.
else
	MSGINFO("Atencao, Pedido Nao Encontrado !")
	return .f.
Endif

Return .t.


static function itemped()
if (Tpedido $ GETMV("MV_UPEDPRO")) 
    Tcliente := Space(06)
    TProd    := Space(15)
    Titped   := Space(02)
    TdescCli := Space(80)
    return .t.
endif
dbselectarea("SC6")
dbsetorder(1)
if dbseek(xFilial()+Tpedido+Titped)           
	Tprod := SC6->C6_PRODUTO
	return .t.
else
	msginfo("Esse item não existe no pedido")
	return .f.	
endif         

return .f.

Static Function Mostra()
dbSelectArea("SB1")
if DbSeek(xFilial("SB1") + TProd, .T.)
	_prod := SB1->B1_DESC
	@ 29,95  GET  _prod SIZE 180,20 WHEN .F. 
	TdescPro:=SB1->B1_DESC
else
	TdescPro:=space(40)
	return .f.
endif


Static Function Cliente()
Dbselectarea("SA1")
dbsetorder(1)
if (Tpedido $ GETMV("MV_UPEDPRO")) 
    Tcliente := Space(06)
    TProd    := Space(15)
    Titped   := Space(02)
    TdescCli := Space(80) 
    return .t.
endif
if Dbseek(xFilial("SA1")+Tcliente)
	TdescCli := SA1->A1_NREDUZ	
	@ 17,70 GET TdescCli SIZE 210,20 WHEN .F.
else
	MSGINFO("Atencao, Cliente Nao Encontrado !")
	TdescCli:=space(20)
	return .f.
Endif
      

Return