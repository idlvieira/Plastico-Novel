#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03
#INCLUDE "TOPCONN.CH"

/*
Programa		KATINV02.PRW
Descrição		Browse para selecao da Invoice e digitacao dos complementos
Autor           TBA087 - Beatriz Azevedo
Data            Agosto/2005
*/

************************
User Function KATINV02()
************************

cCadastro := "Complementacao da Invoice"
aRotina := {{"Pesquisar","AxPesqui",0,1},;
{"Container",'ExecBlock("KATINV05",.F.)',0,3},;
{"Complementos",'ExecBlock("OBTCOMPL",.F.)',0,3}}
MBrowse(6, 1, 22, 75, "SCJ")

Return

//*********************
// Complementos da Invoice
//*********************
User Function ObtCompl()

Calias   := "SZ8"
CFiltro  := "SZ8->Z8_INVOICE = SCJ->CJ_NUM " 
Cchave   := "SZ8->Z8_FILIAL+SZ8->Z8_INVOICE+SZ8->Z8_CONT"
CindSE11 := CriaTrab(Nil,.F.)                                                                     
IndRegua("SZ8",CindSE11, Cchave, ,CFiltro ,"Selecionando Registros...")     
dbSelectArea("SZ8")

cCadastro := "Complementacao da Invoice X Container"
aRotina := {{"Pesquisar","AxPesqui",0,1},;
{"Container",'ExecBlock("KATINV05",.F.)',0,3},;
{"Calibre",'ExecBlock("KATINV03",.F.)',0,3},;
{"Produtor",'ExecBlock("KATINV04")',0,4},;
{"Imprimir",'ExecBlock("SELPROD",.F.)',0,3}}
MBrowse(6, 1, 22, 75, "SZ8")

Return

*************************
User Function SelProd()
*************************

Private cPerg   := "KTINV02"  

CriaPerg()

If  Pergunte(cPerg,.T.)=.F.
	Return
Endif

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

Z5Fil:=xFilial("SZ5")
B1Fil:=xFilial("SB1")

cQry := "SELECT Z5_PRODUTO, B1_DESC FROM " + RetSqlName("SZ5") + " Z5, " + RetSqlName("SB1") + " B1"
cQry := cQry + " WHERE Z5_FILIAL = '"+z5Fil+"' AND B1_FILIAL = '"+B1Fil+"'"     
cQry := cQry + " AND Z5_INVOICE ='"+SZ8->Z8_INVOICE+"'" 
cQry := cQry + " AND Z5_CONT ='"+SZ8->Z8_CONT+"'" 
cQry := cQry + " AND Z5_PRODUTO = B1_COD"
cQry := cQry + " AND Z5.D_E_L_E_T_<>'*'"
cQry := cQry + " AND B1.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY Z5_PRODUTO"
 
Tcquery cQry new alias "aQRY"  

aStru:={}
AADD( aStru, {"Produto","C" ,15 ,0} )
AADD( aStru, {"Descri" ,"C" ,40 ,0} )

cArq :=CriaTrab(aStru,.T.)
Use &cArq alias TMP2 new   
   Index On Produto To &cArq 

aQRY->( DBGoTop() )

Do  While aQRY->(Eof())=.F.

    TMP2->(dbSeek(Produto,.F.))
    If  TMP2->(Found())=.F.
        RecLock("TMP2",.T.) 
        Produto:=aQry->Z5_PRODUTO
        Descri :=aQry->B1_DESC
        dbUnlock()
    Endif

    aQry->(dbSkip())
    
Enddo    

DbSelectArea("aQRY")
DbCloseArea()

dbSelectArea("TMP2")
dbGotop()                    

aCampos1 := {}
AADD(aCampos1,{"DESCRI","Produto"})

// Monta tela do browse com registros selecionados
If  mv_par03=1
    @ 010,050 TO 280,480 DIALOG oDlg4 TITLE "Impressao Packing List" 
Else
    @ 010,050 TO 280,480 DIALOG oDlg4 TITLE "Impressao Romaneio Produtor" 
Endif    
@ 020,010 TO 100,210 BROWSE "TMP2" FIELDS aCampos1  
If  mv_par03=1
    @ 120,080 BMPBUTTON TYPE 01 ACTION (ImpCal(),oDlg4:End())
Else
    @ 120,080 BMPBUTTON TYPE 01 ACTION (ImpForn(),oDlg4:End())
Endif    
@ 120,120 BMPBUTTON TYPE 02 ACTION oDlg4:End()

ACTIVATE DIALOG oDlg4 CENTERED

DbSelectArea("TMP2")
DbCloseArea()

Return()

************************
Static Function ImpCal()
************************
oPrn := TAVPrinter():New()
If  oPrn:Setup() = .F. // para configurar impressora
    nLastkey:=27
    Return
Endif    

nPag:=nLin:=nCol:=nColf:=nLi1:=nLi2:=nTCol:=nLP:=nLQ:=nPall:=0
nTot:=nTGer:=0
aImpCal:={}
aCabCal:={}

cProd:=TMP2->Produto
cCont:=SZ8->Z8_CONT
cCox :=SZ8->Z8_COX

cFil:=xFilial("SZ5")

cQry := "SELECT Z5_CALIBRE, Z5_PALLETE, Z5_QUANT, Z5_CAIXA FROM " + RetSqlName("SZ5") + " Z5"
cQry := cQry + " WHERE Z5_FILIAL = '"+cFil+"'"     
cQry := cQry + " AND Z5_INVOICE ='"+SZ8->Z8_INVOICE+"'" 
cQry := cQry + " AND Z5_CONT ='"+cCont+"'" 
cQry := cQry + " AND Z5_PRODUTO ='"+cProd+"'" 
cQry := cQry + " AND Z5.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY Z5_CAIXA, Z5_PALLETE"
 
Tcquery cQry new alias "aQRY"  

aQRY->( DBGoTop() )

cDesIng:=Alltrim(Posicione("SB1",1,xFilial("SB1")+cPROD,"B1_KTDESIN"))
aCabCal:={}
ObtTabcal()
aImpCal:=Array(Len(aCabCal))
Afill(aImpCal,0)
aTCol:=Array(Len(aCabCal))
Afill(aTCol,0)        
aTGer:=Array(Len(aCabCal))
Afill(aTGer,0)        

Execblock("ImpCabec",.F.)

cCaixa:=Space(15)

Do  While aQry->(Eof())=.F.

    If  cCaixa<>aQry->Z5_CAIXA
        If  Empty(cCaixa)=.F.
            ImpSubTot() 
        Endif
        cCaixa:=aQry->Z5_CAIXA
        ImpCabProd()
        aTCol:=Array(Len(aImpCal))
        Afill(aTCol,0)        
    Endif    

    nLin:=nLin+20
        
    nPall++
    oPrn:Say(nLin,0070 ,aQry->Z5_PALLETE,oFont10,100) 
    oPrn:Say(nLin,0200 ,"Katopé",oFont10,100) 
    oPrn:Say(nLin,0350 ,cDesIng,oFont10,100) 
    nCol:=1020                            
    cPall:=aQry->Z5_Pallete
    Do  While aQry->(Eof())=.F. .and. aQry->Z5_Pallete=cPall .and. aQry->Z5_Caixa=cCaixa    

        cVar:=Alltrim(aQry->Z5_CALIBRE)
        nCCab:= aScan(aCabCal, cVar)       
        If  nCCab<>0
            aImpCal[nCCab]:=aQry->Z5_QUANT
        Endif
       
        aQry->(dbSkip())

    Enddo    

    If  Len(aImpCal) < 10
        N:=Len(aImpCal)
    Else 
        N:=10
    Endif    
    nTot:=0
    For I = 1 to N                                         
        If  aImpCal[I] <> 0
            oPrn:Say(nLin,nCol,Transform(aImpCal[I],"@E 9999"),oFont10,100) 
        Else
            oPrn:Say(nLin,nCol,"    ",oFont10,100) 
        Endif    
        nCol+=nTCol
        nTot+=aImpCal[I]
        aTCol[I]+=aImpCal[I]
    Next    
    oPrn:Say(nLin,nCol+10,Transform(nTot,"@E 9999"),oFont10,100) 
    nLin:=nLin+50
    nFin:=nLin+3
    Afill(aImpCal,0)
    oPrn:Box(nLin,050,nFin,nColf)  

Enddo

ImpSubTot() 

nLin:=nLin+50
nLi1:=nLin
nFin:=nLin+70
nLi2:=nFin
oPrn:Box(nLin,050,nFin,nColf)  
nLin:=nLin+30
oPrn:Say(nLin,0350 ,"TOTAL  GERAL",oFont10n,100) 
nCol:=1020
If  Len(aTGer) < 10
    N:=Len(aTGer)
Else 
    N:=10
Endif    
nTot:=0
For I = 1 to N                                         
    If  aTGer[I] <> 0
        oPrn:Say(nLin,nCol,Transform(aTGer[I],"@E 9999"),oFont10n,100) 
    Else
        oPrn:Say(nLin,nCol,"    ",oFont10n,100) 
    Endif    
    nCol+=nTCol
    nTot+=aTGer[I]
Next
oPrn:Say(nLin,nCol+10,Transform(nTot,"@E 9999"),oFont10n,100) 
//Linhas verticais
nCol:=1000
For I = 1 to N+1
    oPrn:Box(nLi1,nCol,nLi2,nCol+3)  
    nCol+=nTCol
Next    
oPrn:Say(nLP,1400,": "+Strzero(nPall,2),oFont10n,100) 
oPrn:Say(nLQ,1400,": "+Transform(nTot,"@E 9999"),oFont10n,100) 


Execblock("ImpFinal",.F.)

oPrn:Preview()
oPrn:EndPage() 

DbSelectArea("aQry")
DbCloseArea()

MS_FLUSH()

SET DEVICE TO SCREEN

Return()

************************
Static Function ImpForn()
************************
oPrn := TAVPrinter():New()
If  oPrn:Setup() = .F. // para configurar impressora
    nLastkey:=27
    Return
Endif    

nPag:=nLin:=nCol:=nColf:=nLi1:=nLi2:=nTCol:=nLP:=nLQ:=nPall:=0
nTot:=nTGer:=0
aImpCal:={}
aCabCal:={}

cProd:=TMP2->Produto
cCont:=SZ8->Z8_CONT
cCox :=SZ8->Z8_COX

cFil:=xFilial("SZ6")

cQry := "SELECT Z6_CALIBRE, Z6_FORNECE, Z6_QUANT, Z6_CAIXA FROM " + RetSqlName("SZ6") + " Z6"
cQry := cQry + " WHERE Z6_FILIAL = '"+cFil+"'"     
cQry := cQry + " AND Z6_INVOICE ='"+SZ8->Z8_INVOICE+"'" 
cQry := cQry + " AND Z6_CONT ='"+cCont+"'" 
cQry := cQry + " AND Z6_PRODUTO ='"+cProd+"'" 
cQry := cQry + " AND Z6.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY Z6_CAIXA, Z6_FORNECE"
 
Tcquery cQry new alias "aQRY"  

aQRY->( DBGoTop() )

cDesIng:=Alltrim(Posicione("SB1",1,xFilial("SB1")+cPROD,"B1_KTDESIN"))
aCabCal:={}
ObtTabcal()
aImpCal:=Array(Len(aCabCal))
Afill(aImpCal,0)
aTCol:=Array(Len(aCabCal))
Afill(aTCol,0)        
aTGer:=Array(Len(aCabCal))
Afill(aTGer,0)        

Execblock("ImpCabec",.F.)

cCaixa:=Space(15)

Do  While aQry->(Eof())=.F.

    If  cCaixa<>aQry->Z6_CAIXA
        If  Empty(cCaixa)=.F.
            ImpSubTot() 
        Endif
        cCaixa:=aQry->Z6_CAIXA
        ImpCabProd()
        aTCol:=Array(Len(aImpCal))
        Afill(aTCol,0)        
    Endif    

    nLin:=nLin+20
        
    nPall++
    DFornece:=Posicione("SA2",1,xFilial("SA2")+aQRY->Z6_FORNECE,"A2_NREDUZ")
    oPrn:Say(nLin,0070 ,Substr(DFornece,1,25),oFont10,100) 
    oPrn:Say(nLin,0600 ,Substr(cDesIng,1,20),oFont10,100) 
    nCol:=1020                            
    cForn:=aQry->Z6_Fornece
    Do  While aQry->(Eof())=.F. .and. aQry->Z6_Fornece=cForn .and. aQry->Z6_Caixa=cCaixa    

        cVar:=Alltrim(aQry->Z6_CALIBRE)
        nCCab:= aScan(aCabCal, cVar)       
        If  nCCab<>0
            aImpCal[nCCab]:=aQry->Z6_QUANT
        Endif
       
        aQry->(dbSkip())

    Enddo    

    If  Len(aImpCal) < 10
        N:=Len(aImpCal)
    Else 
        N:=10
    Endif    
    nTot:=0
    For I = 1 to N                                         
        If  aImpCal[I] <> 0
            oPrn:Say(nLin,nCol,Transform(aImpCal[I],"@E 9999"),oFont10,100) 
        Else
            oPrn:Say(nLin,nCol,"    ",oFont10,100) 
        Endif    
        nCol+=nTCol
        nTot+=aImpCal[I]
        aTCol[I]+=aImpCal[I]
    Next    
    oPrn:Say(nLin,nCol+10,Transform(nTot,"@E 9999"),oFont10,100) 
    nLin:=nLin+50
    nFin:=nLin+3
    Afill(aImpCal,0)
    oPrn:Box(nLin,050,nFin,nColf)  

Enddo

ImpSubTot() 

nLin:=nLin+50
nLi1:=nLin
nFin:=nLin+70
nLi2:=nFin
oPrn:Box(nLin,050,nFin,nColf)  
nLin:=nLin+30
oPrn:Say(nLin,0350 ,"TOTAL  GERAL",oFont10n,100) 
nCol:=1020
If  Len(aTGer) < 10
    N:=Len(aTGer)
Else 
    N:=10
Endif    
nTot:=0
For I = 1 to N                                         
    If  aTGer[I] <> 0
        oPrn:Say(nLin,nCol,Transform(aTGer[I],"@E 9999"),oFont10n,100) 
    Else
        oPrn:Say(nLin,nCol,"    ",oFont10n,100) 
    Endif    
    nCol+=nTCol
    nTot+=aTGer[I]
Next
oPrn:Say(nLin,nCol+10,Transform(nTot,"@E 9999"),oFont10n,100) 
//Linhas verticais
nCol:=1000
For I = 1 to N+1
    oPrn:Box(nLi1,nCol,nLi2,nCol+3)  
    nCol+=nTCol
Next    
//oPrn:Say(nLP,1400,": "+Strzero(nPall,2),oFont10n,100) 
oPrn:Say(nLQ,1400,": "+Transform(nTot,"@E 9999"),oFont10n,100) 

Execblock("ImpFinal",.F.)

oPrn:Preview()
oPrn:EndPage() 

DbSelectArea("aQry")
DbCloseArea()

MS_FLUSH()

SET DEVICE TO SCREEN

Return()

****************************
Static Function ImpCabProd()
****************************
nLin:=nLin+70
nLi1:=nLin
If  mv_par03=1
    oPrn:Say(nLin,0070 ,"Pallet",oFont10n,100) 
    oPrn:Say(nLin,0200 ,"Brand",oFont10n,100) 
    oPrn:Say(nLin,0350 ,"Variety",oFont10n,100) 
Else
    oPrn:Say(nLin,0070 ,"Produtor",oFont10n,100) 
    oPrn:Say(nLin,0600 ,"Variety",oFont10n,100) 
Endif    
nCol:=1020
If  Len(aCabCal) < 10
    N:=Len(aCabCal)
Else 
    N:=10
Endif    
For I = 1 to N       
    If     aCabCal[I]="1S" 
           oPrn:Say(nLin,nCol,"Small",oFont10n,100) 
    ElseIf aCabCal[I]="2M" 
           oPrn:Say(nLin,nCol,"Medium",oFont10n,100) 
    ElseIf aCabCal[I]="3L" 
           oPrn:Say(nLin,nCol,"Large",oFont10n,100) 
    ElseIf aCabCal[I]="4X" 
           oPrn:Say(nLin,nCol,"X-Large",oFont10n,100) 
    Else
           oPrn:Say(nLin,nCol,aCabCal[I],oFont10n,100) 
    Endif       
    nCol+=nTCol
Next    
oPrn:Say(nLin,nCol,"TOTAL",oFont10n,100) 
nColf:=nCol+150
nFin:=nLi1+3
oPrn:Box(nLi1,050,nFin,nColf)  
nLin :=nLin+50
nFin :=nLin+3
oPrn:Box(nLin,050,nFin,nColf)  
nLi2 :=nLi1-60
oPrn:Say(nLi2+20,070,Alltrim(Posicione("SB1",1,xFilial("SB1")+cCaixa,"B1_DESC")),oFont09n,100) 
oPrn:Box(nLi2,1000,nLi2+3,nColf)  
nCol2:=1000+Int((nColf-1000-125)/2)
oPrn:Say(nLi2+20,nCol2,"S I Z E",oFont10n,100) 

Return

***************************
Static Function ImpSubTot()
***************************
nLin:=nLin+20
oPrn:Say(nLin,0350 ,"SUB-TOTAL",oFont10n,100) 
nCol:=1020
If  Len(aTCol) < 10
    N:=Len(aTCol)
Else 
    N:=10
Endif    
nTot:=0
For I = 1 to N                                         
    If  aTCol[I] <> 0
        oPrn:Say(nLin,nCol,Transform(aTCol[I],"@E 9999"),oFont10n,100) 
    Else
        oPrn:Say(nLin,nCol,"    ",oFont10n,100) 
    Endif    
    nCol+=nTCol
    nTot+=aTCol[I]
    aTGer[I]+=aTCol[I]
Next

oPrn:Say(nLin,nCol+10,Transform(nTot,"@E 9999"),oFont10n,100) 
nLin:=nLin+50
nFin:=nLin+3
oPrn:Box(nLin,050,nFin,nColf)  
//Linhas verticais dos produtos
oPrn:Box(nLi1,050,nLin,053)      
If  mv_par03=1
    oPrn:Box(nLi1,180,nLin,183)  
    oPrn:Box(nLi1,330,nLin,333)  
Else
    oPrn:Box(nLi1,580,nLin-70,583)  
Endif    
nCol:=1000
If  Len(aImpCal) < 10
    N:=Len(aImpCal)
Else 
    N:=10
Endif    
For I = 1 to N                                         
    If  I=1
        oPrn:Box(nLi2,nCol,nLin,nCol+3)  
    Else
        oPrn:Box(nLi1,nCol,nLin,nCol+3)  
    Endif    
    nCol+=nTCol
Next    
oPrn:Box(nLi1,nCol,nLin,nCol+3)  
oPrn:Box(nLi2,nColf-3,nLin,nColf)  
nLin:=nLin+50

Return

***************************                                                       
Static Function ObtTabCal()
***************************                                                       

Z2Fil:=xFilial("SZ2")

If  mv_par03=1 //Packing List
    Z5Fil:=xFilial("SZ5")
    cQry1 := "SELECT Z2_CALIBRE FROM " + RetSqlName("SZ2") + " Z2, " + RetSqlName("SZ5") + " Z5 "
    cQry1 := cQry1 + " WHERE  Z2_FILIAL = '"+Z2Fil+"' AND Z5_FILIAL = '"+Z5Fil+"'"     
    cQry1 := cQry1 + " AND Z5_INVOICE ='"+SZ8->Z8_INVOICE+"'" 
    cQry1 := cQry1 + " AND Z5_CONT ='"+cCont+"'" 
    cQry1 := cQry1 + " AND Z5_PRODUTO ='"+cProd+"'" 
    cQry1 := cQry1 + " AND Z5_CAIXA=Z2_PRODUTO"
    cQry1 := cQry1 + " AND Z2.D_E_L_E_T_<>'*' AND Z5.D_E_L_E_T_<>'*'
Else          //Romaneio de Produtor 
    Z6Fil:=xFilial("SZ6")
    cQry1 := "SELECT Z2_CALIBRE FROM " + RetSqlName("SZ2") + " Z2, " + RetSqlName("SZ6") + " Z6 "
    cQry1 := cQry1 + " WHERE  Z2_FILIAL = '"+Z2Fil+"' AND Z6_FILIAL = '"+Z6Fil+"'"     
    cQry1 := cQry1 + " AND Z6_INVOICE ='"+SZ8->Z8_INVOICE+"'" 
    cQry1 := cQry1 + " AND Z6_CONT ='"+cCont+"'" 
    cQry1 := cQry1 + " AND Z6_PRODUTO ='"+cProd+"'" 
    cQry1 := cQry1 + " AND Z6_CAIXA=Z2_PRODUTO"
    cQry1 := cQry1 + " AND Z2.D_E_L_E_T_<>'*' AND Z6.D_E_L_E_T_<>'*'
Endif    
cQry1 := cQry1 + " ORDER BY Z2_CALIBRE" 
 
Tcquery cQry1 new alias "aQRY1"  

dbSelectArea("aQry1")
dbGotop()

cAchou:="S"
If  aQry1->(Eof())=.T.
    cAchou:="N"
Endif

Do  While aQry1->(Eof())=.F.
    cVar:=Alltrim(aQry1->Z2_CALIBRE)
    nCCab:= aScan(aCabCal, cVar)       
    If  nCCab=0       
        AADD( aCabCal, cVar )
    Endif    

    aQry1->(dbSKip())

Enddo

nTCol:=Int(1100/Len(aCabCal))
dbSelectArea("aQry1")
dbCloseArea()

Return

************************
Static Function Impant()
************************
oPrn := TAVPrinter():New()

If  oPrn:Setup() = .F. // para configurar impressora
    nLastkey:=27
    Return
Endif    

nPag:=nLin:=nCol:=0
nTot:=nTGer:=0
aTCol:=Array(Len(aCalibre))
Afill(aTCol,0)

cCont   :=SZ8->Z8_INVOICE

Execblock("ImpCabec",.F.)

nLin:=nLin+30
nLi1:=nLin
oPrn:Say(nLin,0070 ,"Produtor",oFont10n,100) 
oPrn:Say(nLin,0550 ,"Variety",oFont10n,100) 
nCol:=1150
For I = 1 to 10       
    If  I <= Len(aCalibre)
        cVar :=aCalibre[I]   
        cVar1:=Substr(cVar,2,Len(cVar)-1)
        oPrn:Say(nLin,nCol ,cVar1,oFont10n,100) 
        nCol+=100
    Endif                      
Next    
oPrn:Say(nLin,nCol,"TOTAL",oFont10n,100) 
nColf:=nCol+150
nFin:=nLi1+3
oPrn:Box(nLi1,050,nFin,nColf)  
nLin :=nLin+50
nFin :=nLin+3
oPrn:Box(nLin,050,nFin,nColf)  
nLi2 :=nLi1-60
oPrn:Box(nLi2,1130,nLi2+3,nColf)  
nCol2:=1130+Int((nColf-1130-125)/2)
oPrn:Say(nLi2+20,nCol2,"S I Z E",oFont10n,100) 

dbSelectArea("TMP1")
dbGotop()

Do  While TMP1->(Eof())=.F.

    cDesIng:=Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->PRODUTO,"B1_KTDESIN"))

    nLin:=nLin+20
        
    oPrn:Say(nLin,0070 ,TMP1->DFORNECE,oFont09,100) 
    oPrn:Say(nLin,0550 ,cDesIng,oFont09,100) 
    nCol:=1150
    For I = 1 to 10       
        If  I <= Len(aCalibre)
            cVar :=aCalibre[I]   
            cVar1:=Substr(cVar,2,Len(cVar)-1)
            oPrn:Say(nLin,nCol ,Transform(&cVar,"@E 9999"),oFont10,100) 
            nCol+=100
            nTot+=&cVar
            aTCol[I]+=&cVar
//        Else    
//            oPrn:Say(nLin,nCol ,"9999",oFont10,100) 
//            nCol+=100
        Endif                      
    Next    
    oPrn:Say(nLin,nCol+10,Transform(nTot,"@E 9999"),oFont10,100) 
    nTGer+=nTot
    nTot:=0
    nLin:=nLin+50
    nFin:=nLin+3
    oPrn:Box(nLin,050,nFin,nColf)  

    TMP1->(dbSkip())

Enddo

nLin:=nLin+20
oPrn:Say(nLin,0550 ,"T O T A L",oFont10n,100) 
nCol:=1150
For I = 1 to 10       
    If  I <= Len(aCalibre)
        oPrn:Say(nLin,nCol ,Transform(aTCol[I],"@E 9999"),oFont10n,100) 
        nCol+=100
//    Else    
//        oPrn:Say(nLin,nCol ,"9999",oFont10n,100) 
//        nCol+=100
    Endif    
Next    
oPrn:Say(nLin,nCol+10,Transform(nTGer,"@E 9999"),oFont10,100) 
nLin:=nLin+50
nFin:=nLin+3
oPrn:Box(nLin,050,nFin,nColf)  

//Linhas verticais dos produtos
oPrn:Box(nLi1,050,nLin,053)  
oPrn:Box(nLi1,530,nLin,533)  
nCol:=1130
//For I = 1 to 10       
For I = 1 to Len(aCalibre)       
    If  I=1
        oPrn:Box(nLi2,nCol,nLin,nCol+3)  
    Else
        oPrn:Box(nLi1,nCol,nLin,nCol+3)  
    Endif    
    nCol+=100
Next    
oPrn:Box(nLi1,nCol,nLin,nCol+3)  
oPrn:Box(nLi2,nColf-3,nLin,nColf)  

Execblock("ImpFinal",.F.)

oPrn:Preview()
oPrn:EndPage() 

MS_FLUSH()

SET DEVICE TO SCREEN

Return()

//*********************
// IMPRIME CABECALHO
//*********************
User Function ImpCabec()

cReceiv :=Alltrim(Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME"))
cPorEmb :=Alltrim(Posicione("SZ3",1,xFilial("SZ3")+SCJ->CJ_KTPORIG,"Z3_NOME"))
cPorDesc:=Alltrim(Posicione("SZ3",1,xFilial("SZ3")+SCJ->CJ_KTPDESC,"Z3_NOME"))
cNavio  :=Alltrim(Posicione("SZ1",1,xFilial("SZ1")+SCJ->CJ_KTNAVIO,"Z1_NOME"))
cArmad  :=Alltrim(Posicione("SZ4",1,xFilial("SZ4")+SCJ->CJ_KTNAVIO,"Z4_NOME"))
cBook   :=SCJ->CJ_KTBOOKI
dEmiss  :=SCJ->CJ_EMISSAO
dDesc   :=SCJ->CJ_KTDTDES

cFil:=xFilial("SC6")
cNumOrc:=SZ8->Z8_INVOICE+"01"
cNF:=Space(6)

cQry := "SELECT C6_NOTA AS xNF FROM " + RetSqlName("SC6") + " C6"
cQry := cQry + " WHERE C6_NUMORC = '"+cNumOrc+"'"
cQry := cQry + " AND C6_FILIAL = '"+cFil+"'"     
cQry := cQry + " AND C6.D_E_L_E_T_<>'*'"
 
Tcquery cQry new alias "aQRY1"  

cNF:=xNf

DbSelectArea("aQRY1")
DbCloseArea()

oPrn:StartPage()

nLin:=10

cBitMap:="\system\Logokatope.BMP"
oPrn:SayBitmap(030,005,cBitMap,200,200)   
        
nPag++
nLin:=300                
If  mv_par03=1
    oPrn:Say(nLin,810,"PACKING LIST",oFont18n,100)
Else
    oPrn:Say(nLin,730,"ROMANEIO DE PRODUTOR",oFont18n,100)
Endif    

nLin+=200
oPrn:Say(nLin,0070,"Shipper",oFont10n,100)
oPrn:Say(nLin,0350,": "+SM0->M0_NOMECOM,oFont10n,100)
oPrn:Say(nLin,1250,"Date",oFont10n,100)
oPrn:Say(nLin,1400,": "+DTOC(dEmiss),oFont10n,100)
nLin+=40
oPrn:Say(nLin,70,"Receiver",oFont10n,100)
oPrn:Say(nLin,0350,": "+cReceiv,oFont10n,100)

nLin+=80
oPrn:Say(nLin,70,"Product",oFont10n,100)
oPrn:Say(nLin,0350,": "+cDesIng,oFont10n,100)
oPrn:Say(nLin,1250,"Pallets",oFont10n,100)
nLp:=nLin
//oPrn:Say(nLin,1300,Strzero(TRB->PALLETE,2),oFont10n,100)
oPrn:Say(nLin,1850,"Invoice",oFont10n,100)
oPrn:Say(nLin,2000,": "+SZ8->Z8_INVOICE,oFont10n,100)
nLin+=40
oPrn:Say(nLin,0070,"Vessel",oFont10n,100)
oPrn:Say(nLin,0350,": "+cNavio,oFont10n,100)
oPrn:Say(nLin,1250,"Boxes",oFont10n,100)
nLQ:=nLin
//oPrn:Say(nLin,1300,Transform(TRB->QUANT,"@E 9,999"),oFont10n,100)
oPrn:Say(nLin,1850,"NF",oFont10n,100)
oPrn:Say(nLin,2000,": "+cNF,oFont10n,100)
nLin+=40
oPrn:Say(nLin,0070,"Shipping Line",oFont10n,100)
oPrn:Say(nLin,0350,": "+cArmad,oFont10n,100)
oPrn:Say(nLin,1250,"Loaded",oFont10n,100)
oPrn:Say(nLin,1400,": "+cPorEmb,oFont10n,100)
nLin+=40
oPrn:Say(nLin,0070,"Container",oFont10n,100)
oPrn:Say(nLin,0350,": "+cCont,oFont10n,100)
oPrn:Say(nLin,1250,"Arrival",oFont10n,100)
oPrn:Say(nLin,1400,": "+cPorDesc,oFont10n,100)
nLin+=40
oPrn:Say(nLin,0070,"Booking",oFont10n,100)
oPrn:Say(nLin,0350,": "+cBOOK,oFont10n,100)
oPrn:Say(nLin,1250,"ETA",oFont10n,100)
oPrn:Say(nLin,1400,": "+DTOC(dDesc),oFont10n,100)
nLin+=40
oPrn:Say(nLin,70,"Cox*",oFont10n,100)
oPrn:Say(nLin,0350,": "+cCox,oFont10n,100)
nLin+=100

Return()

//***************************
//Imprimir finalização
//***************************
User Function ImpFinal()

nLin:=nLin+150
//nFin:=nLin+250
//oPrn:Box(nLin,050,nFin,650)  
//nlin:=nlin+20
oPrn:Say(nLin,070,SM0->M0_NOMECOM,oFont08,100)
nlin:=nlin+50
oPrn:Say(nLin,070,SM0->M0_ENDCOB,oFont08,100)
nlin:=nlin+50
oPrn:Say(nLin,070,Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB,oFont08,100)
nlin:=nlin+50
oPrn:Say(nLin,070,"CEP: "+Alltrim(Substr(SM0->M0_CEPCOB,1,5))+" - "+Alltrim(Substr(SM0->M0_CEPCOB,6,3)),oFont08,100)
nlin:=nlin+50
oPrn:Say(nLin,070,"Tel: + 55 71 "+Alltrim(Substr(SM0->M0_TEL,5,8)),oFont08,100)

Return()

*---------------------------------------------------------------------------------*
Static Function CriaPerg
*---------------------------------------------------------------------------------*
Local _sAlias := Alias()
Local aRegs   := {}
Local i
Local j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Invoice     ","","","mv_ch1","C",6,00,0,"S","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Container   ","","","mv_ch2","C",6,00,0,"S","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Impressao   ","","","mv_ch3","N",1,00,0,"C","","mv_par03","Packing List","","","","","Roman.Produtor","","","","","","","","","","","","","","","","","","",""})

For I:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to Len(aRegs[i])//FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Else                        
        If  I = 1
            RecLock("SX1",.F.)
            X1_CNT01:=SZ8->Z8_INVOICE
            MsUnlock()
        ElseIf I = 2    
            RecLock("SX1",.F.)
            X1_CNT01:=SZ8->Z8_CONT
            MsUnlock()
        Endif    
    Endif
Next

dbSelectArea(_sAlias)

Return
