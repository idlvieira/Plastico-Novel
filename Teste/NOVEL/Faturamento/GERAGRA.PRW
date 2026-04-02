#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 22/04/04

User Function GERAGRA()        // incluido pelo assistente de conversao do AP6 IDE em 22/04/04

//----------------------------------------------------------------------------
//|Programa  | GERAGRA     | Autor | Eliene Cerqueira    |Criado| 01.Jul.2005|  
//----------------------------------------------------------------------------
//|Descricao | Rotina para geracao de pedido de amostra grátis baseado nos   |
//|            vários pedidos emitidos durante o mes                         |
//----------------------------------------------------------------------------
//|Uso       | SIGAFAT                                                       |
//----------------------------------------------------------------------------

SetPrvt("NLASTKEY,LCONTINUA,WREGUA,WCHAVE,WGRAV,WCMED")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mv_par01:=mv_par02:=CTOD("00/00/00")
@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Geracao de Pedido de Amostra"
@ 8,10 TO 84,222
@ 13,14 SAY "Esta rotina tem como objetivo juntar os pedidos de amostra gratis (039)"
@ 23,14 SAY "emitidos durante o mes para o cliente 001556."
@ 43,14 SAY "  DATA INICIAL :"
@ 53,14 SAY "  DATA FINAL   :"
@ 43,55 GET mv_par01 SIZE 40,20 PICTURE X3Picture("F2_Emissao")  VALID NaoVazio()
@ 53,55 GET mv_par02 SIZE 40,20 PICTURE X3Picture("F2_Emissao")  VALID NaoVazio()
//@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("VCR610")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5

nLastKey:= 0 
lContinua := .T.

Return

// Substituido pelo assistente de conversao do AP6 IDE em 22/04/04 ==> Function OkProc
Static Function OkProc()
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP6 IDE em 22/04/04 ==> Processa( {|| Execute(RunProc) } )
Close(oDlg5)
Return

****> FUncao RunProc
// Substituido pelo assistente de conversao do AP6 IDE em 22/04/04 ==> Function RunProc
Static Function RunProc()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                        ³
//³ mv_par01            // Data Inicial                         ³
//³ mv_par02            // Data Final                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nLastkey == 27
    Return
EndIf

xPEDIDO := {}            
xITEM := {}            
xPRODUTO := {}            
xDESCRI := {}            
xUM := {}            
xSERVICO := {}            
xQTDVEN := {}            
xPRCVEN := {}            
xVALOR := {}            
xVUNTREA := {}            
xQTDLIB := {}            
xSLDALIB := {}            
xENCOMED := {}            
xTES := {}            
xCF := {}            
xSEGUM := {}            
xUNSVEN := {}            
xLOCAL := {}            
xQTDEMP := {}            
xQTDENT := {}            
xNRFG := {}            
xINIPROD := {}            
xENTREG := {}            
xLA := {}            
xVALDESC := {}            
xDESCONT := {}            
xPRUNIT := {}            
xIPIDEV := {}            
xPICMRET := {}            
xCODISS := {}            
xDTVALID := {}            
xNUMORC := {}            
xCLASFIS := {}            
xAMOSTRA := {}            
xPCM := {}            
xENTREGA := {}            
dbSelectArea("SC5")
dbSetOrder(2)
Dbgotop()
wRegua:=Reccount()
dbSeek(xFilial("SC5")+DTOS(Mv_Par01),.F.)
cNumPedido:=""
nItem := 1
ProcRegua( Wregua )

Do  While SC5->( !Eof() ) .and. SC5->C5_Emissao<=Mv_Par02

    IncProc()
    If SC5->C5_CONDPAG<>"039" .OR. SC5->C5_CLIENTE<>"001556"
       SC5->( DbSkip() )
       Loop
    Endif
    dbSelectArea("SC6")
    dbSetOrder(1)
    dbSeek(xFilial("SC6")+SC5->C5_NUM,.F.)
    Do  While SC6->( !Eof() ) .and. SC6->C6_NUM=SC5->C5_NUM
        dbSelectArea("SC9")
        dbSetOrder(1)
        dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
        If Found()
           If C9_BLCRED="10" .and. C9_BLEST="10" // Já faturado
              SC6->( DbSkip() )
              Loop
           Endif
        Endif
		AADD(xPEDIDO, SC6->C6_NUM)    
		AADD(xITEM, SC6->C6_ITEM)    
		AADD(xPRODUTO, SC6->C6_PRODUTO)
		AADD(xDESCRI, SC6->C6_DESCRI)
		AADD(xUM, SC6->C6_UM)
		AADD(xSERVICO, SC6->C6_SERVICO)
		AADD(xQTDVEN, SC6->C6_QTDVEN)
		AADD(xPRCVEN, SC6->C6_PRCVEN)
		AADD(xVALOR, SC6->C6_VALOR)
		AADD(xVUNTREA, SC6->C6_VUNTREA)
		AADD(xQTDLIB, SC6->C6_QTDLIB)
		AADD(xENCOMED, SC6->C6_ENCOMED)
		AADD(xTES, SC6->C6_TES)
		AADD(xCF, SC6->C6_CF)
		AADD(xSEGUM, SC6->C6_SEGUM)
		AADD(xUNSVEN, SC6->C6_UNSVEN)
		AADD(xLOCAL, SC6->C6_LOCAL)
		AADD(xQTDEMP, SC6->C6_QTDEMP)
		AADD(xQTDENT, SC6->C6_QTDENT)
		AADD(xNRFG, SC6->C6_NRFG)
		AADD(xINIPROD, SC6->C6_INIPROD)
		AADD(xENTREG, SC6->C6_ENTREG)
		AADD(xLA, SC6->C6_LA)
		AADD(xVALDESC, SC6->C6_VALDESC)
		AADD(xDESCONT, SC6->C6_DESCONT)
        AADD(xENTREGA, SC6->C6_ENTREG)
		AADD(xPRUNIT, SC6->C6_PRUNIT)
		AADD(xIPIDEV, SC6->C6_IPIDEV)
		AADD(xPICMRET, SC6->C6_PICMRET)
		AADD(xCODISS, SC6->C6_CODISS)
		AADD(xDTVALID, SC6->C6_DTVALID)
		AADD(xNUMORC, SC6->C6_NUMORC)
		AADD(xCLASFIS, SC6->C6_CLASFIS)
		AADD(xAMOSTRA, SC6->C6_AMOSTRA)
		AADD(xPCM, SC6->C6_PCM)
        SC6->( DbSkip() )
	ENDDO    
    SC5->( DbSkip() )
ENDDO	    
	    
wGrav:=0
J:=Len(xPEDIDO)
wRegua:=J
ProcRegua( Wregua )
If J>0
   cNumPedido:=""       
   nItem := 1
   For  I:=1 to J
        IncProc()
	    If nItem>11     
	       cNumPedido:=""       
        Endif
        If cNumPedido=""
	       cNumPedido := GetSX8Num("SC5","C5_NUM")
   		   dbselectArea("SC5")
     	   RecLock("SC5",.T.)
  		   SC5->C5_FILIAL  := xFilial()
    	   SC5->C5_NUM     := cNumPedido
    	   SC5->C5_TIPO    := "N"
     	   SC5->C5_CLIENTE := "001556"
    	   SC5->C5_LOJAENT := "01"
           SC5->C5_LOJACLI := "01"
  		   SC5->C5_TRANSP  := "000001"
	       SC5->C5_EMISSAO := dDataBase
    	   SC5->C5_CONDPAG := "039"
	       SC5->C5_TABELA  := "1"
		   SC5->C5_VEND1   := "A00022"
		   SC5->C5_COMIS1  := 0
	       SC5->C5_TPFRETE := "F"
		   SC5->C5_NATOPER := "1"
		   SC5->C5_MENPED1 := "ASM MES "+STRZERO(MONTH(Mv_Par01),2)
           MsUnlock()
     	   ConfirmSX8() 
           wGrav:=wGrav+1
	       nItem := 1
	    Endif
   		dbselectArea("SC6")
   		RecLock("SC6",.T.)
  		SC6->C6_FILIAL  := xFilial()
    	SC6->C6_NUM     := cNumPedido
   		SC6->C6_ITEM    := StrZero(nItem,2)
   		SC6->C6_PRODUTO := xPRODUTO[I]
        SC6->C6_DESCRI  := xDESCRI[I]
  		SC6->C6_UM      := xUM[I]
		SC6->C6_SERVICO := "N"
	    SC6->C6_QTDVEN  := xQTDVEN[I]
	    SC6->C6_PRCVEN  := xPRCVEN[I]
    	SC6->C6_VALOR   := xVALOR[I]
		SC6->C6_VUNTREA := xVUNTREA[I]
		SC6->C6_QTDLIB  := xQTDLIB[I]
   		SC6->C6_ENCOMED := xENCOMED[I]
        SC6->C6_TES     := xTES[I]
        SC6->C6_CF      := xCF[I]
        SC6->C6_SEGUM   := xSEGUM[I]
        SC6->C6_LOCAL   := xLOCAL[I]
		SC6->C6_QTDEMP  := xQTDEMP[I]
		SC6->C6_QTDENT  := xQTDENT[I]
		SC6->C6_NRFG    := xNRFG[I]
    	SC6->C6_INIPROD := xINIPROD[I]
        SC6->C6_ENTREG  := xENTREGA[I]
		SC6->C6_VALDESC := xVALDESC[I]
		SC6->C6_DESCONT := xDESCONT[I]
	    SC6->C6_CLI     := "001556"
	    SC6->C6_LOJA    := "01"
	    SC6->C6_VEND1   := "A00021"
    	SC6->C6_PRUNIT  := xPRUNIT[I]
		SC6->C6_COMIS1  := 0
		SC6->C6_PRUNIT  := xPRUNIT[I]
		SC6->C6_IPIDEV  := xIPIDEV[I]
		SC6->C6_PICMRET := xPICMRET[I]
		SC6->C6_CODISS  := xCODISS[I]
		SC6->C6_DTVALID := xDTVALID[I]
		SC6->C6_CLASFIS := xCLASFIS[I]
		SC6->C6_AMOSTRA := xAMOSTRA[I]
		SC6->C6_PCM     := xPCM[I]
       	MSUnLock()   

        dbSelectArea("SC5")
        dbSetOrder(1)
        dbSeek(xFilial("SC5")+xPEDIDO[I],.F.)
        If Found()
           Reclock("SC5",.F.)
           SC5->( DBDELETE( ) )
           Dbunlock()
        Endif
        dbSelectArea("SC6")
        dbSeek(xFilial("SC6")+xPEDIDO[I]+xITEM[I],.F.)
        Reclock("SC6",.F.)
        SC6->( DBDELETE( ) )
        Dbunlock()
        dbSelectArea("SC9")
        dbSeek(xFilial("SC9")+xPEDIDO[I]+xITEM[I],.F.)
        If Found()
           Reclock("SC9",.F.)
           SC9->( DBDELETE( ) )
           Dbunlock()
        Endif
        nItem := nItem+1
   Next
//   MsgBox(str(J,2) + " pedidos substituidos por " + str(wGrav,2) + " pedidos novos")
Endif

Return
