#Include "protheus.ch"
#Include "topconn.ch"
#Include "totvs.ch"

#include "colors.ch"
#Include "Font.ch"
#INCLUDE "FWPrintSetup.ch"

#define linha chr(13)+chr(10)
#Define IMP_SPOOL  2
#Define IMP_PDF    6
#Define DMPAPER_A4 9

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYGPE01.prw                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 17/06/2019                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina de Avaliacao Desempenho por Competencia e Potencial ADCP e  |\
/|            Diagnostico Operacional                                            |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYGPE01() 

  Local oFont11 := TFont():New('Arial',,-11,,.T.)
  Local oFont12 := TFont():New('Arial',,-12,,.T.)
  Local oFont16 := TFont():New('Arial',,-16,,.T.)

  //** Variaveis de Dimensao da tela **\\
  Local aAdvSize     := MsAdvSize( NIL , .F. )
  Local aInfoAdvSize := {aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0}
  Local aObjCoords   := {{100 , 000 , .T. , .T.}}
  Local aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )
  Private nTop,nLeft,nBottom,nRight, nXY

  Private Oqry := NVLxFUN():New(.f.), cQuery
  
  Private oGrid, aZP0, aIdent, aObj, xHeader, xCol, aGestor, aColab, btSalvar

  aObj :={{},{},{},{},{},{},{},{}}
  aIdent :={}  
  aadd(aIdent, {"Informe seu CPF: ",space(11),nil,nil,.T.})
  aadd(aIdent, {"Identificação: ",space(50)})
  aadd(aIdent, {"CPF Colaborador: ",space(11),nil,nil,.T.})
  aadd(aIdent, {"Identificação: ",space(50)})
  
  //** Carrega as Dimensoes de tela
  nXY     := {aAdvSize[6],aAdvSize[5]} //Tamanho da Tela
  nTop    := aObjSize[1][1]
  nLeft   := aObjSize[1][2]
  nBottom := aObjSize[1][3]
  nRight  := aObjSize[1][4]
  
  aZP0 := {}
  fPesquisa()
  If Empty(aZP0)
    APMsgInfo("Não existe pesquisa disponivel no momento","MYGPE01")
    Return
  EndIf
  fHeader()
  
  Define MsDialog oDlgChLt Title "Avaliação de Desempenho por Competência e Potencal / Diagnóstico Operacional - (ADCP / DO)"  From 0,0 To nXY[1], nXY[2] Pixel

    TSay():New(05,15,{|| "Avaliação: " + aZP0[2] } ,oDlgChLt,, oFont16 ,,,,.T.,CLR_RED,CLR_WHITE,380,20)
    
    TSay():New(24,15,{|| aIdent[1,1] } ,oDlgChLt,, oFont12 ,,,,.T.,CLR_BLUE,CLR_WHITE,380,20)
    aIdent[1,3] := TGet():New(20,70,{|u| if(PCount()>0,aIdent[1,2]:=u,aIdent[1,2])},oDlgChLt,60,10,"@ 99999999999",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"aIdent[1,2]")
    aIdent[1,4] := TButton():New(20,135,"Verificar",oDlgChLt,{|| fViewRegra(@aIdent[1,2],"1","","") },35,13,, ,.F.,.T.)
    TSay():New(35,15,{|| aIdent[2,1]+" "+ aIdent[2,2] } ,oDlgChLt,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,380,20)
    
    TButton():New(50,15,"Desistir",oDlgChLt,{|| oDlgChLt:End() },35,13,, ,.F.,.T.)
    btSalvar:= TButton():New(50,55,"Salvar"  ,oDlgChLt,{|| fGravar() },35,13,, ,.F.,.T.)
    aObj[1] := { TButton():New(50,95 ,"Autoavaliar",oDlgChLt,{|| fViewRegra(@aIdent[1,2],"2","",aZP0[4]) },35,13,, ,.F.,.T.) , .F.}
    aObj[2] := { TButton():New(50,135,"Aval.Gestor",oDlgChLt,{|| fViewRegra(@aIdent[1,2],"3","","") },35,13,, ,.F.,.T.) , .F.}
    aObj[3] := { TButton():New(50,95 ,"Feedback"   ,oDlgChLt,{|| fViewRegra(@aIdent[2,2],"4","","") },35,13,, ,.F.,.T.) , .F.}
    
    TBtnBmp2():New(135,30,26,26,'engrenagem'    ,,,,{|| fConfig() }, oDlgChLt,,,.F. )
    TSay():New(70,30,{|| "Status: " + IIF(aZP0[3]=="A", "Processo aberto",IIF(aZP0[3]=="F", "Processo Feedback", "Processo encerrado")) } ,oDlgChLt,, oFont16 ,,,,.T.,CLR_BLUE,CLR_WHITE,380,20)
    
    TSay():New(18,230,{|| "* Citérios de avaliação *" } ,oDlgChLt,, oFont12 ,,,,.T.,CLR_BLUE,CLR_WHITE,250,20)
    TSay():New(26,230,{|| "1 - Não demostra a competência esperada" } ,oDlgChLt,, oFont11 ,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)
    TSay():New(33,230,{|| "2 - Demostra a competência em grau inferior ao esperado" } ,oDlgChLt,, oFont11 ,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)
    TSay():New(40,230,{|| "3 - Demostra a competência esperada" } ,oDlgChLt,, oFont11 ,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)
    TSay():New(47,230,{|| "4 - Demostra a competência em grau superior ao esperado" } ,oDlgChLt,, oFont11 ,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)
    TSay():New(54,230,{|| "5 - Demostra a competência e é tido como exemplo dentro e fora da sua área de atuação" } ,oDlgChLt,, oFont11 ,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)

    oGrid := MSNewGetDados():New(nTop+55,nLeft+15,nBottom-35,nRight-15,3,,"AlwaysTrue",,{},0,1,,,,oDlgChLt, xHeader,xCol)   
    Eval({|| oGrid:oBrowse:bLDblClick:={|| fGrid(oGrid:nAt, oGrid:oBrowse:nColpos) } , oGrid:oBrowse:lUseDefaultColors := .F. , oGrid:oBrowse:SetBlkBackColor({|| fGetColor(oGrid:nAt) }) })
    
    aObj[4] := { TButton():New(nBottom-25,15,"Pontos Fortes",oDlgChLt,{|| oDlgChLt:End() },50,13,, ,.F.,.T.) , .F.}
    aObj[5] := { TButton():New(nBottom-25,75,"Pontos Melhorar",oDlgChLt,{|| oDlgChLt:End() },50,13,, ,.F.,.T.) , .F.}
    aObj[6] := { TButton():New(nBottom-25,135,"Observações",oDlgChLt,{|| oDlgChLt:End() },50,13,, ,.F.,.T.) , .F.}
    
    aObj[7] := { TSay():New(nBottom-26,230,{|| aIdent[3,1]+" "+aIdent[3,2] } ,oDlgChLt,, oFont16 ,,,,.T.,CLR_BLUE,CLR_WHITE,380,20) , .F.}
    aObj[8] := { TSay():New(nBottom-15,230,{|| aIdent[4,1]+" "+aIdent[4,2] } ,oDlgChLt,, oFont16 ,,,,.T.,CLR_BLUE,CLR_WHITE,380,20) , .F.}
    
    fVisivel()

  Activate MsDialog oDlgChLt Centered     
    
Return
                                                                                                                                                                                                        
*Funcao***************************************************************************************************************************************
 
Static Function fGetColor(nL)

  Local nRColor   := 16777215 // Default  - RGB(255,255,255)
  Local nCrlVrd   := 10214530 // VerdeCla - RGB(118,148, 60)
  Local nCrlCrm   := 10271428 // CremeEsc - RGB(196,186,156)

  If oGrid:aCols[nL,Len(xHeader)] == "|"
    nRColor := nCrlCrm
  ElseIf oGrid:aCols[nL,Len(xHeader)] == "*"
    nRColor := nCrlVrd
  EndIf

Return nRColor

*Funcao***************************************************************************************************************************************

Static Function fGrid(nL, nC)

  Local oLeg := nil
  Local cAuxInfo := ""
  
  If nC < 3 .or. nC > 7 .or. oGrid:aCols[nL,Len(xHeader)] == "|"
    Return
  EndIf

  //** Marca a Linha **\\
  For c:=3 to Len(xHeader)
    oGrid:aCols[nL,c]:= " "
  Next
  oGrid:aCols[nL,nC] := "X"
  oGrid:aCols[nL,Len(xHeader)] := "*"
      
Return

*Funcao***************************************************************************************************************************************

Static Function fViewRegra(cpfC, rgr, cpfG, psq)

  Local oDlg, oList, aList:={}, nList := 1   
  
  If aZP0[3] == "F"
    fFeedback(cpfC, rgr, cpfG, psq)
    fVisivel()
    Return
  EndIf
  
  If rgr == "1"
    cQuery := ""
    cQuery += "SELECT RA_MAT, RA_NOME, COALESCE(QB_FILRESP,'') QB_FILRESP, COALESCE(QB_MATRESP,'') QB_MATRESP, COUNT(ZP2_IDP) RESPONDIDO " "
    cQuery += "FROM SRA010 SRA "
    cQuery += "LEFT JOIN SQB010 AS QB ON QB_MATRESP=RA_MAT AND QB.D_E_L_E_T_!='*' "
    cQuery += "LEFT JOIN ZP2010 AS P2 ON ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C=RA_CIC AND ZP2_AV_C>0 AND P2.D_E_L_E_T_!='*'"
    cQuery += "WHERE RA_CIC='"+AllTrim(cpfC)+"' AND RA_DEMISSA='' AND SRA.D_E_L_E_T_!='*' "
    cQuery += "GROUP BY RA_MAT, RA_NOME, COALESCE(QB_FILRESP,''), COALESCE(QB_MATRESP,'') "
    Oqry:TcQry("xSRA", cQuery,1,.f.)

    aGestor := {.F.,"",""}
    While ! EOF()
      If RESPONDIDO > 0
        APMsgStop("Você já realizou a pesquisa","Avaliação - MYGPE01")
        aObj[1,2]:=.F.
      Else
        aObj[1,2]:=.T.
      EndIf
      aIdent[2,2] := AllTrim(RA_NOME) 
      If ! Empty(QB_MATRESP)
        aGestor := {.T.,QB_FILRESP,QB_MATRESP}
      EndIf
    xSRA->(dbSkip())
    EndDo
    xSRA->(dbCloseArea())
    
    If ! Empty(aIdent[2,2])
      aIdent[1,5] := .F.
      aIdent[1,3]:SetEnable(aIdent[1,5])
      aIdent[1,4]:SetEnable(aIdent[1,5])
      If aGestor[1]
        aObj[2,2]:=.T.
      EndIf
    Else
      APMsgStop("Não foi encontrado o CPF informado ("+AllTrim(aIdent[1,2])+")","Avaliação - MYGPE01")
      Return
    EndIf
  EndIf
  
  If rgr == "2"
    fSelect(psq)
    Eval({|| aZP0[6]:=cpfC , aZP0[7]:=cpfG , aZP0[8]:=psq })
    Eval({|| aObj[1,2]:=.F., aObj[2,2]:=.F. })
  EndIf
    
  If rgr == "3" .and. aGestor[1]
    cQuery := ""
    cQuery += "SELECT RA_FILIAL, RA_CIC, RA_NOME, RA_DEPTO, COUNT(ZP2_IDP) RESPONDIDO "
    cQuery += "FROM SQB010 AS QB "
    cQuery += "INNER JOIN SRA010 AS RA ON RA_DEPTO=QB_DEPTO AND RA_DEMISSA='' AND RA_SITFOLH!='D' AND RA.D_E_L_E_T_!='*' "
    cQuery += "LEFT JOIN ZP2010 AS P2 ON ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C=RA_CIC AND ZP2_CPF_G='"+aIdent[1,2]+"' AND P2.D_E_L_E_T_!='*'"
    cQuery += "WHERE QB_MATRESP='"+AllTrim(aGestor[3])+"' AND QB.D_E_L_E_T_!='*' "
    cQuery += "GROUP BY RA_FILIAL, RA_CIC, RA_NOME, RA_DEPTO "
    cQuery += "ORDER BY RA_NOME "
    Oqry:TcQry("xSRA", cQuery,1,.f.)

    aColab:={}
    While ! EOF()
      aadd(aList, "["+IIF(RESPONDIDO>0,"x","-")+"] "+AllTrim(RA_NOME))
      aadd(aColab, {RA_FILIAL, RA_CIC, RA_NOME, RA_DEPTO, IIF(RESPONDIDO>0,"x","-")})
    xSRA->(dbSkip())
    EndDo
    xSRA->(dbCloseArea())
    
    DEFINE DIALOG oDlg TITLE "Colaborador" FROM 180,180 TO 500,455 PIXEL
      oList := TListBox():New(05,05,{|u|if(Pcount()>0,nList:=u,nList)},aList,130,130, ,oDlg,,,,.T.)
      TButton():New(140,10,"ADCP",oDlg,{|| fColab(@oDlg,nList,aZP0[4]) },35,13,, ,.F.,.T.)
      TButton():New(140,50,"DO"  ,oDlg,{|| fColab(@oDlg,nList,aZP0[5]) },35,13,, ,.F.,.T.)
      TButton():New(140,90,"Desisitir",oDlg,{|| oDlg:End(), oDlgChLt:End() },35,13,, ,.F.,.T.)
    ACTIVATE DIALOG oDlg CENTERED
  EndIf
  
  fVisivel()

Return


*Funcao***************************************************************************************************************************************

Static Function fColab(oSTela, nColab, psq)
  If aColab[nColab,5] == "-"
    oSTela:End()
    aIdent[3,2] := aColab[nColab,2]
    aIdent[4,2] := aColab[nColab,3]
    Eval({|| aObj[7,2]:=.T., aObj[8,2]:=.T. })
    fViewRegra(@aIdent[3,2],"2",@aIdent[1,2], psq)
  Else
    APMsgStop("Colaborador já avaliado","Avaliação - MYGPE01")
  EndIf

Return

*Funcao***************************************************************************************************************************************

Static Function fVisivel()

  For kv:=1 to Len(aObj)
    If aObj[kv,2]
      aObj[kv,1]:Show()
    Else
      aObj[kv,1]:Hide()  
    EndIf
  Next

Return

*Funcao***************************************************************************************************************************************

Static Function fHeader()

  xHeader := {}
  aadd(xHeader, {"---"   ,"xPrd","@!"  ,3,0,"","","C",,,,})
  aadd(xHeader, {"Avaliação","xPrd","@!" ,150,0,"","","C",,,,})
  aadd(xHeader, {"1"  ,"xPrd","@!"  ,3,0,"","","C",,,,})
  aadd(xHeader, {"2"  ,"xPrd","@!"  ,3,0,"","","C",,,,})
  aadd(xHeader, {"3"  ,"xPrd","@!"  ,3,0,"","","C",,,,})
  aadd(xHeader, {"4"  ,"xPrd","@!"  ,3,0,"","","C",,,,})
  aadd(xHeader, {"5"  ,"xPrd","@!"  ,3,0,"","","C",,,,})
  aadd(xHeader, {"-"  ,"xPrd","@!" ,1,0,"","","C",,,,})
  
  xCol := {}
  aadd(xCol, {"","","","","","","","-",.T.})

Return   

*Funcao***************************************************************************************************************************************

Static Function fPesquisa()

    cQuery := ""
    cQuery += "SELECT ZP0_ID, ZP0_DSC, ZP0_STATUS, ZP0_ADM, ZP0_OPC "
    cQuery += "FROM ZP0010 "
    cQuery += "WHERE ZP0_STATUS!='E' AND D_E_L_E_T_!='*' "
    Oqry:TcQry("xZP0", cQuery,1,.f.)

    While ! EOF()
      aZP0 := {ZP0_ID, ZP0_DSC, ZP0_STATUS, ZP0_ADM, ZP0_OPC, "", "", ""}
    xZP0->(dbSkip())
    EndDo
    xZP0->(dbCloseArea())

Return   

*Funcao***************************************************************************************************************************************

Static Function fSelect(psq)
    
    cQuery := ""
    cQuery += "SELECT ZP1_ID,ZP1_GRP,ZP1_NVL,ZP1_DSC,ZP1_GESTOR "
    cQuery += "FROM ZP1010 ZP1 "
    cQuery += "INNER JOIN ZP0010 AS ZP0 ON ZP0_ADM=ZP1_ID OR ZP0_OPC=ZP1_ID AND ZP0.D_E_L_E_T_!='*' "
    cQuery += "WHERE ZP1_ID='"+psq+"' AND ZP1.D_E_L_E_T_!='*' "
    cQuery += "ORDER BY ZP1_GRP, ZP1_NVL "
    Oqry:TcQry("xZP1", cQuery,1,.f.)
    
    aCol:= {}
    While ! EOF()
      If ZP1_GESTOR == "N"
        aadd(aCol, {ZP1_GRP+ZP1_NVL,ZP1_DSC,"","","","","",IIF(ZP1_NVL="00","|","-"),.F.})
      ElseIf ZP1_GESTOR == "S" .and. aGestor[1]
        aadd(aCol, {ZP1_GRP+ZP1_NVL,ZP1_DSC,"","","","","",IIF(ZP1_NVL="00","|","-"),.F.})
      EndIf
    xZP1->(dbSkip())
    EndDo
    xZP1->(dbCloseArea())
    
    oGrid:aCols := aClone(aCol)
    
Return

*Funcao***************************************************************************************************************************************

Static Function fGravar()
  
  Local aGrid := aClone(oGrid:aCols)
  Local lOK   := .T.
  Local AV_C, AV_G, AV_M

  If aZP0[3] == "A"
    //Valida o preenchimento
    For k:=1 to Len(aGrid)
      If aGrid[k,8] == "-"
        lOK := .F.
      EndIf
      aGrid[k,3] := IIF(Empty(aGrid[k,3]),0,1)
      aGrid[k,4] := IIF(Empty(aGrid[k,4]),0,2)
      aGrid[k,5] := IIF(Empty(aGrid[k,5]),0,3)
      aGrid[k,6] := IIF(Empty(aGrid[k,6]),0,4)
      aGrid[k,7] := IIF(Empty(aGrid[k,7]),0,5)
    Next  
    If lOK
      cQuery := ""
      cQuery += "SELECT COALESCE(SUM(ZP2_AV_C),0) ZP2_AV_C, COALESCE(SUM(ZP2_AV_G),0) ZP2_AV_G, COALESCE(SUM(ZP2_AV_M),0) ZP2_AV_M "
      cQuery += "FROM ZP2010 WHERE ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C='"+aZP0[6]+"' "
      Oqry:TcQry("xZP2", cQuery,1,.f.)
      If ! EOF()
        Eval({|| AV_C := xZP2->ZP2_AV_C , AV_G := xZP2->ZP2_AV_G , AV_M := xZP2->ZP2_AV_M })
      EndIf
      xZP2->(dbCloseArea())
      
      If AV_C < 1 .and. AV_G < 1 .and. AV_M < 1
        For k:=1 to Len(aGrid)
        RecLock("ZP2",.T.) 
          ZP2->ZP2_IDP   := aZP0[1]
          ZP2->ZP2_CPF_C := aZP0[6]
          ZP2->ZP2_CPF_G := aZP0[7]
          ZP2->ZP2_IDQ   := aZP0[8]
          ZP2->ZP2_GRP   := SubStr(aGrid[k,1],1,1)
          ZP2->ZP2_NVL   := SubStr(aGrid[k,1],2,2)
          ZP2->ZP2_AV_C  := IIF(Empty(aZP0[7]).or.aZP0[8]="OPC", aGrid[k,3]+aGrid[k,4]+aGrid[k,5]+aGrid[k,6]+aGrid[k,7], 0)
          ZP2->ZP2_AV_G  := IIF(Empty(aZP0[7]), 0, aGrid[k,3]+aGrid[k,4]+aGrid[k,5]+aGrid[k,6]+aGrid[k,7])
          ZP2->ZP2_AV_M  := IIF(aZP0[8]="OPC", aGrid[k,3]+aGrid[k,4]+aGrid[k,5]+aGrid[k,6]+aGrid[k,7], 0)
        MSUnLock()
        Next
      Else
        For k:=1 to Len(aGrid)
          If AV_C < 1
            TcSqlExec("UPDATE ZP2010 SET ZP2_AV_C="+AllTrim(Str(aGrid[k,3]+aGrid[k,4]+aGrid[k,5]+aGrid[k,6]+aGrid[k,7]))+" WHERE ZP2_GRP+ZP2_NVL='"+aGrid[K,1]+"' AND ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C='"+aZP0[6]+"'")
          ElseIF AV_G < 1                                                                                                          
            TcSqlExec("UPDATE ZP2010 SET ZP2_CPF_G='"+aZP0[7]+"', ZP2_AV_G="+AllTrim(Str(aGrid[k,3]+aGrid[k,4]+aGrid[k,5]+aGrid[k,6]+aGrid[k,7]))+" WHERE ZP2_GRP+ZP2_NVL='"+aGrid[K,1]+"' AND ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C='"+aZP0[6]+"'")
          EndIf
        Next
      EndIf
      APMsgInfo("Obrigado por participar da avaliacao"+linha+linha+"NOVEL","Avaliação - MYGPE01")
      oDlgChLt:End()
    Else
      APMsgInfo("Por favor, verifique o formulario se todas as questões foram respondidas","Avaliação - MYGPE01")
    EndIf
  ElseIf aZP0[3] == "F"
    //Valida o preenchimento
    For k:=1 to Len(aGrid)
      If aGrid[k,8] == "-"
        lOK := .F.
      EndIf
      aGrid[k,3] := IIF(Empty(aGrid[k,3]),0,1)
      aGrid[k,4] := IIF(Empty(aGrid[k,4]),0,2)
      aGrid[k,5] := IIF(Empty(aGrid[k,5]),0,3)
      aGrid[k,6] := IIF(Empty(aGrid[k,6]),0,4)
      aGrid[k,7] := IIF(Empty(aGrid[k,7]),0,5)
    Next  
    If lOK                    
      For k:=1 to Len(aGrid)
        TcSqlExec("UPDATE ZP2010 SET ZP2_AV_M="+AllTrim(Str(aGrid[k,3]+aGrid[k,4]+aGrid[k,5]+aGrid[k,6]+aGrid[k,7]))+" WHERE ZP2_GRP+ZP2_NVL='"+aGrid[K,1]+"' AND ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C='"+aZP0[6]+"'")
      Next
      fResult()  
    Else
      APMsgInfo("Por favor, verifique o formulario se todas as questões foram respondidas","Avaliação - MYGPE01")
    EndIf
  EndIf

Return

*Funcao***************************************************************************************************************************************

Static Function fConfig()

  Local nCad := 0
  Local cRH  := POSICIONE("ZZZ",1,xFilial("ZZZ")+"GPE000001"+"001","ZZZ_RETORN")
  
  If Alltrim(UsrRetName(RetCodUsr())) $ cRH
    nCad := Aviso("ADCP / DO","Selecione o cadastro que deseja acessa:"+chr(13)+"1 Cadastro de pesquisa; 2 Cadastro de questionario.",{"1-Pesquisa","2-Questoes","Voltar"},3,"Novel")
  Else
    APMsgStop("Usuário sem acesso as configurações","MYGPE01")
  EndIf  

Return

*Funcao***************************************************************************************************************************************

Static Function fFeedback(cpfC, rgr, cpfG, psq)

  Local oDlg, oList, aList:={}, nList := 1   
  
  If rgr == "1"
    cQuery := ""
    cQuery += "SELECT RA_MAT, RA_NOME, COALESCE(QB_FILRESP,'') QB_FILRESP, COALESCE(QB_MATRESP,'') QB_MATRESP "//, COUNT(ZP2_IDP) RESPONDIDO "
    cQuery += "FROM SRA010 SRA "
    cQuery += "LEFT JOIN SQB010 AS QB ON QB_MATRESP=RA_MAT AND QB.D_E_L_E_T_!='*' "
    cQuery += "WHERE RA_CIC='"+AllTrim(cpfC)+"' AND RA_DEMISSA='' AND SRA.D_E_L_E_T_!='*' "
    Oqry:TcQry("xSRA", cQuery,1,.f.)

    aGestor := {.F.,"",""}
    While ! EOF()
      aObj[1,2]:=.F.
      aIdent[2,2] := AllTrim(RA_NOME) 
      If ! Empty(QB_MATRESP)
        aGestor := {.T.,QB_FILRESP,QB_MATRESP}
      EndIf
    xSRA->(dbSkip())
    EndDo
    xSRA->(dbCloseArea())
    
    If ! Empty(aIdent[2,2])
      aIdent[1,5] := .F.
      aIdent[1,3]:SetEnable(aIdent[1,5])
      aIdent[1,4]:SetEnable(aIdent[1,5])
      If aGestor[1]
        aObj[2,2]:=.F.
        aObj[3,2]:=.T.
      EndIf
    Else
      APMsgStop("Não foi encontrado o CPF informado ("+AllTrim(aIdent[1,2])+")","Avaliação - MYGPE01")
      Return
    EndIf
  EndIf
    
  If rgr == "4" .and. aGestor[1]
    cQuery := ""
    cQuery += "SELECT RA_FILIAL, RA_CIC, RA_NOME, RA_DEPTO, SUM(ZP2_AV_M) RESPONDIDO "
    cQuery += "FROM SQB010 AS QB "
    cQuery += "INNER JOIN SRA010 AS RA ON RA_DEPTO=QB_DEPTO AND RA_DEMISSA='' AND RA_SITFOLH!='D' AND RA.D_E_L_E_T_!='*' "
    cQuery += "LEFT JOIN ZP2010 AS P2 ON ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C=RA_CIC AND ZP2_CPF_G='"+aIdent[1,2]+"' AND P2.D_E_L_E_T_!='*'"
    cQuery += "WHERE QB_MATRESP='"+AllTrim(aGestor[3])+"' AND QB.D_E_L_E_T_!='*' "
    cQuery += "GROUP BY RA_FILIAL, RA_CIC, RA_NOME, RA_DEPTO "
    cQuery += "ORDER BY RA_NOME "
    Oqry:TcQry("xSRA", cQuery,1,.f.)

    aColab:={}
    While ! EOF()
      aadd(aList, "["+IIF(RESPONDIDO>0,"x","-")+"] "+AllTrim(RA_NOME))
      aadd(aColab, {RA_FILIAL, RA_CIC, RA_NOME, RA_DEPTO, IIF(RESPONDIDO>0,"x","-")})
    xSRA->(dbSkip())
    EndDo
    xSRA->(dbCloseArea())
    
    DEFINE DIALOG oDlg TITLE "Feedback - Colaborador" FROM 180,180 TO 500,455 PIXEL
      oList := TListBox():New(05,05,{|u|if(Pcount()>0,nList:=u,nList)},aList,130,130, ,oDlg,,,,.T.)
      TButton():New(140,10,"ADCP",oDlg,{|| fClbFB(@oDlg,nList,aZP0[4]) },35,13,, ,.F.,.T.)
      TButton():New(140,50,"DO"  ,oDlg,{|| fClbFB(@oDlg,nList,aZP0[5]) },35,13,, ,.F.,.T.)
      TButton():New(140,90,"Desisitir",oDlg,{|| oDlg:End(), oDlgChLt:End() },35,13,, ,.F.,.T.)
    ACTIVATE DIALOG oDlg CENTERED
  EndIf
  
  If rgr == "5"
    Eval({|| aObj[4,2]:=.T. , aObj[5,2]:=.T. , aObj[6,2]:=.T. })
  EndIf

Return

*Funcao***************************************************************************************************************************************

Static Function fClbFB(oSTela, nColab, psq)  

  If aColab[nColab,5] == "-"
    oSTela:End()
    aIdent[3,2] := aColab[nColab,2]
    aIdent[4,2] := aColab[nColab,3]
    Eval({|| aObj[3,2]:=.F. , aObj[7,2]:=.T., aObj[8,2]:=.T. })
    fSelectFB(@aIdent[3,2],@aIdent[1,2])
  Else
    APMsgStop("Fedback já realizado","Avaliação - MYGPE01")
  EndIf

Return     

*Funcao***************************************************************************************************************************************

Static Function fSelectFB(cpfC,cpfG)  

    Eval({|| aZP0[6]:=cpfC , aZP0[7]:=cpfG })

    cQuery := ""  
    cQuery += "SELECT ZP1_GRP, ZP1_NVL, ZP1_DSC, ZP2_AV_C, ZP2_AV_G "
    cQuery += "FROM ZP2010 AS ZP2 "
    cQuery += "INNER JOIN ZP1010 AS ZP1 ON ZP1_ID=ZP2_IDQ AND ZP1_GRP=ZP2_GRP AND ZP1_NVL=ZP2_NVL AND ZP1.D_E_L_E_T_!='*' "
    cQuery += "WHERE ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C='"+cpfC+"' AND ZP2_CPF_G='"+cpfG+"' AND ZP2.D_E_L_E_T_!='*' "
    cQuery += "ORDER BY ZP2_GRP, ZP2_NVL "
    Oqry:TcQry("xZP1", cQuery,1,.f.)
    
    aCol:= {}
    While ! EOF()
      aadd(aCol, {ZP1_GRP+ZP1_NVL,ZP1_DSC,"","","","","",IIF(ZP1_NVL="00","|","-"),.F.}) 
      If ! ZP1_NVL="00"
        aCol[Len(aCol),(2+ZP2_AV_C)] += "C"
        aCol[Len(aCol),(2+ZP2_AV_G)] += "G" 
      EndIf
    xZP1->(dbSkip())
    EndDo
    xZP1->(dbCloseArea())
    
    oGrid:aCols := aClone(aCol)

Return     

*Funcao***************************************************************************************************************************************

Static Function fResult() 

  Local oFont16 := TFont():New('Arial',,-16,,.T.)
  Local aRlt := {}, xHdr := {}
  Private oRlt, oDlg

  cQuery := ""  
  cQuery += "SELECT ZP2_GRP, ZP1_DSC, ROUND(SUM(ZP2_AV_M) / COUNT(*),0,1) RESULTADO "
  cQuery += "FROM ZP2010 AS ZP2 "
  cQuery += "INNER JOIN ZP1010 AS ZP1 ON ZP1_ID=ZP2_IDQ AND ZP1_GRP=ZP2_GRP AND ZP1_NVL='00' AND ZP1.D_E_L_E_T_!='*' "
  cQuery += "WHERE ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C='"+aZP0[6]+"' AND ZP2_CPF_G='"+aZP0[7]+"' AND ZP2_NVL!='00' AND ZP2.D_E_L_E_T_!='*' "
  cQuery += "GROUP BY ZP2_GRP, ZP1_DSC "
  cQuery += "ORDER BY ZP2_GRP "
  Oqry:TcQry("xZP1", cQuery,1,.f.)
    
  While ! EOF()
    aadd(aRlt, {ZP2_GRP,ZP1_DSC,RESULTADO,space(180),.F.}) 
  xZP1->(dbSkip())
  EndDo
  xZP1->(dbCloseArea()) 
  
  aadd(xHdr, {"---"      ,"xPrd","@!" ,  3,0,"","","C",,,,})
  aadd(xHdr, {"Avaliação","xPrd","@!" , 50,0,"","","C",,,,})
  aadd(xHdr, {"---"      ,"xPrd","@!" ,  3,0,"","","C",,,,})
  aadd(xHdr, {"Anotação" ,"xAtc","@!" ,150,0,"","","C",,,,})
    
  //Tela de resultado e anotações
  DEFINE DIALOG oDlg TITLE "Feedback - Colaborador" FROM 0,0 TO nXY[1],nXY[2] PIXEL
    TButton():New(05,10,"CONCLUIR O FEEADBACK",oDlg,{|| fOKfdb() },nRight-10,15,, ,.F.,.T.)
    oRlt := MSNewGetDados():New(25,10,130,nRight-10,3,,"AlwaysTrue",,{"xAtc"},0,1,,,,oDlg, xHdr,aRlt)
    Eval({||oRlt:oBrowse:lUseDefaultColors := .F. , oRlt:oBrowse:SetBlkBackColor({|| fColorFDB(oRlt:nAt) }) })    
    TSay():New(145,10,{|| '** Avaliação com o resultado de grupo menor que "3", é obrigatório informar o plano de ação no campo de anotação **'} ,oDlg,, oFont16 ,,,,.T.,CLR_HRED,CLR_WHITE,680,20)
  ACTIVATE DIALOG oDlg CENTERED    

Return

*Funcao***************************************************************************************************************************************
 
Static Function fColorFDB(nL)

  Local nRColor   := 16777215 // Default  - RGB(255,255,255)

  If oRlt:aCols[nL,3] < 3
    nRColor := CLR_HRED
  EndIf

Return nRColor

*Funcao***************************************************************************************************************************************
 
Static Function fOKfdb()

  Local nPos := 0

  For k:=1 to Len(oRlt:aCols)
    If oRlt:aCols[k,3] < 3
      If Len(AllTrim(oRlt:aCols[k,4])) < 50
        APMsgInfo('Obrigatorio informar o plano de ação para o grupo "'+AllTrim(oRlt:aCols[k,1])+' (50 caracteres)"',"MYGPE01")
        Return
      EndIf
    EndIf
  Next 

  For k:=1 to Len(oRlt:aCols)
    nPos := ascan(oGrid:aCols, {|x| x[1] == oRlt:aCols[k,1]+"00"})
    If nPos > 0
      oGrid:aCols[nPos,(2+oRlt:aCols[k,3])] := "X"
      oGrid:aCols[nPos,(2+5+1)] := AllTrim(oRlt:aCols[k,4])
      TcSqlExec("UPDATE ZP2010 SET ZP2_AV_M="+AllTrim(Str(oRlt:aCols[k,3]))+" WHERE ZP2_GRP+ZP2_NVL='"+oRlt:aCols[k,1]+"00"+"' AND ZP2_IDP='"+aZP0[1]+"' AND ZP2_CPF_C='"+aZP0[6]+"'")
      RecLock("ZP3",.T.) 
          ZP3->ZP3_IDP   := aZP0[1]
          ZP3->ZP3_CPF_C := aZP0[6]
          ZP3->ZP3_GRP   := oRlt:aCols[k,1]
          ZP3->ZP3_AV_M  := oRlt:aCols[k,3]
          ZP3->ZP3_INFORM:= oRlt:aCols[k,4]
        MSUnLock()      
    EndIf
  Next
  btSalvar:Hide()
  oDlg:End() 

Return
