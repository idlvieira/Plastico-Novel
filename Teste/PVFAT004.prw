#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/03/03
#INCLUDE "TOPCONN.CH"
#INCLUDE "MATA415.CH"

/*
Programa		PVFAT004.PRW
Descrição		Geração da IMB - PEVAL
Autor           TBA087 - Beatriz Azevedo
Data            08/05/05     
*/

************************
User Function PVFAT004()
************************

Private nLastKey     := 0
Private cPerg   := "PV0002"  
Private aRotina		:= { {STR0002,"AxPesqui"  , 0 , 1 },; 	//"Pesquisar"
   	{STR0003,"A415Visual", 0 , 2 },; 							//"Visualizar"
   	{STR0005,"A415Altera", 0 , 4 },; 							//"Alterar"
   	{STR0038,"A415Exclui", 0 , 5 },;							//"Exclui"
   	{STR0039,"A415Cancel" , 0 , 4 },;							//"Cancela"
   	{STR0006,"A415Impri" , 0 , 2 },; 							//"impRimir"
   	{STR0007,"A415Copia" , 0 , 3 }}								//"Copiar"

CriaPerg()

If  Pergunte(cPerg,.T.)=.F.
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If  mv_par07 = 2 .and. Empty(mv_par08)=.T.
    Msgbox("Venda nao pode ficar sem cliente","MSG DE ERRO")
    Return
Endif

If nLastKey == 27
	Return
Endif

dbSelectArea("SD5")
dbSetOrder(1) // CODIGO
dbGoTop()

cFil:=xFilial("SD5")

//Só selecionar os registros com D5_PVSIT=" "

cQry := "SELECT D5_PRODUTO, D5_DATA, D5_PVNLOC, D5_LOTECTL, D5_PVTERC, D5_PVNTERC, D5_COMVOL, D5_LIQVOL, B1_COD, B1_DESC, B1_UM, B1_LOCPAD"
cQry := cQry + " FROM SD5010 D5, SB1010 B1"
cQry := cQry + " WHERE D5_ORIGLAN = '400'"
cQry := cQry + " AND D5_PVSTAT <> 'V'"
cQry := cQry + " AND D5_ESTORNO <> 'S'"
cQry := cQry + " AND D5_PVSIT = ' '"
cQry := cQry + " AND D5_FILIAL = '"+cFil+"'"     
cQry := cQry + " AND D5_DATA>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND D5_DATA<='"+dtos(mv_par02)+"'" 
cQry := cQry + " AND D5_PRODUTO>='"+mv_par03+"'"
cQry := cQry + " AND D5_PRODUTO<='"+mv_par04+"'" 
cQry := cQry + " AND D5_PRODUTO = B1_COD
cQry := cQry + " AND D5.D_E_L_E_T_<>'*'"
cQry := cQry + " AND B1.D_E_L_E_T_<>'*'"
cQry := cQry + " ORDER BY D5_LOTECTL, D5_DATA"
 
Tcquery cQry new alias "aQRY"  

aStru:={}
AADD( aStru, {"PRODUTO"  ,"C" ,15 ,0} )
AADD( aStru, {"DPROD"    ,"C" ,35 ,0} )
AADD( aStru, {"UPROD"    ,"C" ,3 ,0} )
AADD( aStru, {"LPROD"    ,"C" ,2 ,0} )
AADD( aStru, {"DTAL"     ,"D" ,8 ,0} )
AADD( astru, {"NLOC"     ,"C" ,25,0} )
AADD( astru, {"LOTE"     ,"C" ,10,0} ) 
AADD( astru, {"OK"       ,"C" ,2 ,0} )
AADD( astru, {"TERC"     ,"C" ,6 ,0} )
AADD( astru, {"NTERC"    ,"C" ,30,0} )
AADD( astru, {"PVOL"     ,"N" ,10 ,3} )

cArq :=CriaTrab(aStru,.T.)
Use &cArq alias TRB new   
Index on Terc+Lote  To &cArq
//Index on LProd To "iTrb2.ntx"

aQRY->( DBGoTop() )

Do  While aQRY->( !Eof() )

    dData:=Ctod(Substr(aQRY->D5_DATA,7,2)+"/"+Substr(aQRY->D5_DATA,5,2)+"/"+Substr(aQRY->D5_DATA,1,4))
    RecLock("TRB",.T.) 
    TRB->PRODUTO := aQRY->D5_PRODUTO
    TRB->DPROD   := aQRY->B1_DESC
    TRB->UPROD   := aQRY->B1_UM
    TRB->LPROD   := aQRY->B1_LOCPAD
    TRB->DTAL    := dData
    TRB->NLOC    := aQRY->D5_PVNLOC
    TRB->LOTE    := aQRY->D5_LOTECTL
    TRB->TERC    := aQRY->D5_PVTERC
    TRB->NTERC   := aQRY->D5_PVNTERC    
  //  If  mv_Par07 = 1
  //      TRB->PVOL    := aQRY->D5_LIQVOL
  //  Else
        TRB->PVOL    := aQRY->D5_COMVOL
  //  Endif    
    TRB->OK      := "  "
    DbUnlock()
    
    aQRY->( DbSkip() )

Enddo

DbSelectArea("aQRY")
DbCloseArea()

aCampos := {}
AADD(aCampos,{"OK"," "})
AADD(aCampos,{"LOTE","Bloco"})
AADD(aCampos,{"DPROD","Produto"})
AADD(aCampos,{"DTAL","Data"}) 
AADD(aCampos,{"NTERC","Terceiro"}) 
AADD(aCampos,{"NLOC","Local"})

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

cMarca := GetMark()

cBloco := Space(10)

// Monta tela do browse com registros selecionados
@ 010,020 TO 480,800 DIALOG oDlg1 TITLE "Geracao da IMB"
@ 010,020 SAY "Este programa tem o objetivo de gerar as IMB para os produtos selecionados."
@ 030,005 TO 220,345 BROWSE "TRB" MARK "OK"  FIELDS aCampos Object _oMark
@ 080,360 BMPBUTTON TYPE 01 ACTION (Processa({|| Gera_Orc() },"Gerando IMB."),oDlg1:End())
@ 100,360 BMPBUTTON TYPE 02 ACTION oDlg1:End()
@ 120,345 BUTTON "Marca Todos" SIZE 45,15 ACTION Marca()
@ 140,345 BUTTON "Desmarca Todos" SIZE 45,15 ACTION Desmarca()
//@ 160,348 Say "Busca por Bloco" SIZE 40,15 
//@ 170,348 Get cBloco SIZE 40,15 
//@ 180,360 BUTTON "Buscar" SIZE 25,15 ACTION Pesquisa()

Desmarca()

ACTIVATE DIALOG oDlg1 CENTER

DbSelectArea("TRB")
DbCloseArea()

Return

//---------------------------------------------------------------------------------
Static Function Pesquisa
      
dbSelectArea("TRB")
dbSetOrder(2)
dbSeek(cBloco,.T.)
cBloco := Space(10)
   
Return

//---------------------------------------------------------------------------------

//---------------------------------------------------------------------------------
Static Function DesMarca()    //WCS
//---------------------------------------------------------------------------------

cMarca:=" "

DbSelectArea("TRB")
DbGoTop()
Do While !EOF()
      
   If  Marked("OK")     //Registro esta marcado
       Reclock("TRB",.F.)
       TRB->OK := ThisMark()
       MsUnlock()
   EndIf
   DbSkip()
End
DbGoTop()
_oMark:oBrowse:Refresh()

Return                               

//---------------------------------------------------------------------------------
Static Function Marca()    //WCS
//---------------------------------------------------------------------------------

cMarca:=GetMark()

DbSelectArea("TRB")
DbGoTop()
Do  While !EOF()
      
    If  !Marked("OK")     //Registro nao esta marcado
        Reclock("TRB",.F.)
        TRB->OK := cMarca
        MsUnlock()
    EndIf
    DbSkip()
Enddo
DbGoTop()
_oMark:oBrowse:Refresh()

Return                              
 
Static Function Gera_Orc()
*************************
Local aArea     := GetArea()
Local aAreaSCJ  := SCJ->(GetArea())
Local aCab      := {}
Local aLinha    := {}
Local aItens    := {}
Local aStruSCK  := {}
Local cQuery    := ""
Local cAliasSCK := "SCK"

If  mv_par07 = 1
    cTes    :="507"
Else
    cTes    :="501"
Endif              

dbSelectArea("TRB")
dbSetOrder(1) 
dbGotop()
Do  While TRB->(Eof())=.F.  
    If  TRB->OK<>cMarca
        TRB->(DbSkip())
        Loop
    Endif            
    xTerc :=TRB->TERC         
    xProd :=TRB->PRODUTO     
    nItem :=0
    nTotal:=0
    cNorc:=GETSX8NUM("SCJ","NUM")
    Do  While TRB->(Eof())=.F. .and. TRB->TERC=xTerc .and. TRB->PRODUTO=xProd

        If  TRB->OK<>cMarca
            TRB->(DbSkip())
            Loop
        Endif            
        
        nItem:=nItem+1  

        RecLock("SCK",.T.)       
        SCK->CK_FILIAL:=cFil
    	SCK->CK_NUM:=cNorc
        SCK->CK_ITEM:=STRZERO(nItem,2)
		SCK->CK_PRODUTO:=TRB->PRODUTO
		SCK->CK_UM:=TRB->UPROD           
		SCK->CK_DESCRI:=TRB->DPROD
		SCK->CK_QTDVEN:=TRB->PVOL
//		SCK->CK_PRCVEN
//      SCK->CK_VALOR
    	SCK->CK_TES:=cTes
    	SCK->CK_LOCAL:=TRB->LPROD
    	IF  mv_Par07=1
	    	SCK->CK_CLIENTE:="999999"
		    SCK->CK_LOJA   :="01"
		Else
	    	SCK->CK_CLIENTE:=MV_PAR08
		    SCK->CK_LOJA:=MV_PAR09
		Endif    
    	SCK->CK_FILVEN:=cFil    
    	SCK->CK_FILENT:=cFil    
		SCK->CK_PVBLOCO:=TRB->LOTE
		SCK->CK_PVTERC:=TRB->TERC
		SCK->CK_ENTREG:=dDATABASE
		DbUnLock()
		dbSelectArea("SD5")
        dbSetOrder(5)    
        SD5->(dbSeek(xFilial("SD5")+TRB->LOTE,.F.))
        Do  While SD5->(Eof()) =.F. .and. SD5->D5_LOTECTL=TRB->LOTE
            If  SD5->D5_OrigLan="400"
                RecLock("SD5",.F.)       
                SD5->D5_PVSIT:="R"
                SD5->D5_PVIMB:=cNorc
    	     	DbUnLock()
    	     	Exit
            Endif
            SD5->(dbSkip())
        Enddo  
        TRB->(DbSkip())                  
    Enddo    
    
    If  nItem>0
        RecLock("SCJ",.T.) 
        SCJ->CJ_FILIAL:=cFil      
        SCJ->CJ_NUM:=cNorc			
        SCJ->CJ_EMISSAO:=dDATABASE	
    	IF  mv_Par07=1
	    	SCJ->CJ_CLIENTE:="000327"
		    SCJ->CJ_LOJA   :="01"
            SCJ->CJ_CLIENT :="000327"
            SCJ->CJ_LOJAENT:="01"
            SCJ->CJ_CONDPAG:="999"          
		Else
	    	SCJ->CJ_CLIENTE:=MV_PAR08
		    SCJ->CJ_LOJA   :=MV_PAR09
            SCJ->CJ_CLIENT :=MV_PAR08    	   
            SCJ->CJ_LOJAENT:=MV_PAR09
            SCJ->CJ_CONDPAG:="  "          
		Endif    
        SCJ->CJ_PVTIPO :=Str(mv_par07,1)
        SCJ->CJ_STATUS :="A"
        SCJ->CJ_PVORIG :=mv_par05
        SCJ->CJ_PVDEST :=mv_par06
        SCJ->CJ_PVTERC :=xTerc
        SCJ->CJ_PVLOJA :="01"
        SCJ->CJ_PVTXM  :=mv_Par10
        dbUnlock()
        ConfirmSX8()
        cAlias:="SCJ"
        nReg:=SCJ->(RECNO())
        nOpcx:=3  
        Inclui:=.F.
        Altera=.T.
        A415Altera(cAlias,nReg,nOpcx)
        xPar01:=mv_par01
        xPar02:=mv_par02
        xPar03:=mv_par03
        mv_par01:=mv_par02:=SCJ->CJ_NUM
        mv_par03:=mv_par11
        ExecBlock("IMPIMB",.F.)
        mv_par01:=xPar01
        mv_par02:=xPar02
        mv_par03:=xPar03
    Else
        RollBackSX8()    
    Endif    
Enddo        

Return

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

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data de"         ,"","","mv_ch1","D",8,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Ate"        ,"","","mv_ch2","D",8,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo Produto de" ,"","","mv_ch3","C",15,00,0,"G","","mv_par3","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"04","Tipo Produto Ate","","","mv_ch4","C",15,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"05","Origem "         ,"","","mv_ch5","C",3,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SZ3"})
aAdd(aRegs,{cPerg,"06","Destino  "       ,"","","mv_ch6","C",3,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SZ3"})
aAdd(aRegs,{cPerg,"07","Tipo Operacao"   ,"","","mv_ch7","N",1,00,0,"C","","mv_par07","Remessa","","","","","Venda","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Cliente "        ,"","","mv_ch8","C",6,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"09","Loja    "        ,"","","mv_ch9","C",2,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Taxa do Dolar"   ,"","","mv_cha","N",9,04,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Para           " ,"","","mv_chb","C",30,00,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to Len(aRegs[i])//FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

dbSelectArea(_sAlias)

Return

