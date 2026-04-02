#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"  
                                             

User Function ETQALMOX()
Tpedido   := Space(06)
TProd     := Space(15)
TProd2    := Space(15)
TdescPro  := Space(30)
TqtdEmb   := 0
Tqtdetq   := 0
Tqtdeprod := 0
Titped    := Space(02)
qtde      := 0
qtderes   := 0
qtdetiq   := 1
cCombo := "Linha 02"
   
   
@ 00,00 to 280,580 Dialog tela1 Title "IDENTIFICACAO DE PRODUTOS ALMOXARIFADO"
@ 17, 05 Say "Produto de : "
@ 17, 60 GET TProd SIZE 50,20 PICTURE "999999999999999" VALID NaoVazio() .and. Mostra(TProd) F3 "SB1"
@ 30, 05 Say "Produto Até: "
@ 30, 60 GET TProd2 SIZE 50,20 PICTURE "999999999999999" VALID NaoVazio() .and. Mostra(TProd) F3 "SB1"
@ 46,150 BmpButton Type 01 Action Relat()
@ 46,200 BmpButton Type 02 Action Close(Tela1)
Activate Dialog Tela1 Centered
                                      
return    


Static Function relat()
Close(Tela1)
nCol  	:= 0



dbselectarea("SB1")                      
dbgotop()
DbSeek(xFilial("SB1") + TProd, .T.)



do While SB1->B1_COD >= TProd .and. SB1->B1_COD <= TProd2 
    TdescPro := SB1->B1_DESC
    TdescCod := SB1->B1_COD
    Tlocapad := SB1->B1_LOCPAD
    TUM := SB1->B1_UM
    TCODBAR := SB1->B1_CODBAR
    
 	MSCBPRINTER("OS 214","COM1",,27,.F., , , , , ,.T.)
	MSCBCHKStatus(.F.)
 	MSCBBEGIN(1,1)
	nLinha := 1.0 
    MSCBSay(05,nLinha,(Tlocapad),"N", "1","2,2")
    nLinha += 3.5                                                   
    MSCBSay(05,nLinha,"Almoxarifado     :","N", "1","2,2")
    nLinha += 3.5
    MSCBSay(05,nLinha,(TUM),"N", "1","2,2") 
    nLinha += 3.5                         
    MSCBSay(05,nLinha,"Unidade Medida   :","N", "1","2,2")
    nLinha += 3.5
   	MSCBSay(05,nLinha,(TdescPro),"N", "1","2,2")
 	nLinha += 3.5                         
 	MSCBSay(05,nLinha,"Descricao        :","N", "1","2,2")
 	nLinha += 3.5
    MSCBSay(05,nLinha,(TdesccOD),"N", "1","2,2")
    nLinha += 3.5                                         
    MSCBSay(05,nLinha,"Cod.Produto      :","N", "1","2,2")
    
	MSCBEND()
	MSCBCLOSEPRINTER()   
    
    dbskip()
    if eof()
       exit
    endif     
enddo    
  
return 
                    

Static Function Mostra()
***************
dbSelectArea("SB1")
if DbSeek(xFilial("SB1") + TProd, .T.)
	@ 18,110  SAY  SB1->B1_DESC
	TdescPro:=SB1->B1_DESC
else
	TdescPro:=space(40)
	return .f.
endif

Return