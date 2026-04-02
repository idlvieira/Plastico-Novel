#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYCTB12.prw    | Autor : Leonardo Bergamasco   | Data : 22/06/2020 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina customizada Visão Gerencial (Cockpit - Novel)               |\
/|-------------------------------------------------------------------------------|\
/| Processo.: Tela de apresentação de dados                                      |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        


User Function MYCTB12()

  //** Variaveis de Dimensao da tela **\\
  Local aAdvSize     := MsAdvSize( NIL , .F. )
  Local aInfoAdvSize := {aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0}
  Local aObjCoords   := {{100 , 000 , .T. , .T.}}
  Local aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )
  
  Private Oqry   := NVLxFUN():New(.f.)
  Private cQuery := ""

  Private nTop,nLeft,nBottom,nRight,nXY
  Private oJournal, aTFolder
  Private cCORsup := ""

  Private oGetCt2, oGetJou
  Private aGetCt2, aGetJou
  Private xHeader  := {{},{},{},{},{},{},{},{}}
  Private aCpoEdit := {{},{},{},{},{},{},{},{}}
  
  //** Carrega as Dimensoes de tela
  nXY     := {aAdvSize[6],aAdvSize[5]} //Tamanho da Tela
  nTop    := aObjSize[1][1]
  nLeft   := aObjSize[1][2]
  nBottom := aObjSize[1][3]
  nRight  := aObjSize[1][4]

  //** Montagem dos aHeaders **\\
  fHeader()
  
  //** Select de dados **\\  
  fSQLct()
  
  //** Montagem da TELA de manutenção **\\
  Define MsDialog oJournal Title "GERENCIAL NOVEL"  From 0,0 To nXY[1], nXY[2] Of oMainWnd Pixel
  
    //** Cria a Folder - Principal **\\
    aTFolder := { 'JAG', 'LAU', 'IBI' }
    oTFolder := TFolder():New(0,0, aTFolder ,,oJournal,,,,.T.,,nRight, nBottom )

    oGetCt2 := MSNewGetDados():New(10,5,((nBottom-20)*0.6),nRight-10, 3,,"AlwaysTrue",,aCpoEdit[1],0,1,,,,oTFolder:aDialogs[1],xHeader[1], aGetCt2)
    oGetCt2:oBrowse:lUseDefaultColors := .F.
    oGetCt2:oBrowse:SetBlkBackColor({|| fGetColor(@oGetCt2)})
    oGetCt2:oBrowse:bLDblClick:={|| fExpandir(oGetCt2:aCols[oGetCt2:nAt,2])}
    
    oGetJou := MSNewGetDados():New(10+((nBottom-20)*0.6),5,(nBottom-20),nRight-15, 3,,"AlwaysTrue",,aCpoEdit[2],0,1,,,,oTFolder:aDialogs[1],xHeader[2])
  Activate MsDialog oJournal Centered  
  
Return

*Funcao***************************************************************************************************************************************

//Configuração dos MSNewGetDados
Static Function fHeader()

  //MSNewGetDados de Sequenciamento - oGetCt2
  aadd(xHeader[1], {"_","xSgl","@!"  ,1,0,"","","C",,,,})
  aadd(xHeader[1], {"ID","xIDt","@!"  ,5,0,"","","C",,,,})
  aadd(xHeader[1], {"Descrição","xDsc","@!",40,0,"","","C",,,,})
  aadd(xHeader[1], {"Abril","xM04","@E 999,999,999.99",14,2,"","","N",,,,})
  aCpoEdit[1] := {""}
  //MSNewGetDados de Sequenciamento - oGetJou
  aadd(xHeader[2], {"ID","xIDt","@!"  ,5,0,"","","C",,,,})
  aadd(xHeader[2], {"Descrição","xDsc","@!",40,0,"","","C",,,,})
  aadd(xHeader[2], {"Abril","xM04","@E 999,999,999.99",14,2,"","","N",,,,})
  aCpoEdit[2] := {""}

Return

*Funcao********************************************************************************************************

Static Function fGetColor(oObjG)

  Local nPadrao := 16777215 // Default  - RGB(255,255,255)
  Local nDestaq := 12379352  //9737946
   
  nRColor := IIF(oObjG:aCols[oObjG:nAt,2] == cCORsup, nDestaq, nPadrao)

Return nRColor

*Funcao********************************************************************************************************

Static Function fSQLct()

  Local nPos := 0
  aGetCt2 := {} 
  aGetJou := {}
  
  cQuery := ""
  cQuery += "SELECT ZGR_FILIAL, CVF_CLASSE, ZGR_IDTAG, CVF_CTASUP, CVF_DESCCG, ZGR_M4 " + linha
  cQuery += "FROM ZGR010 ZGR " + linha
  cQuery += "INNER JOIN CVF010 AS CVF ON CVF_CODIGO=ZGR_IDGR AND CVF_CONTAG=ZGR_IDTAG AND CVF.D_E_L_E_T_!='*' " + linha 
  cQuery += "WHERE ZGR_FILIAL='0201' AND ZGR_ANO='2020' AND ZGR_REF='RZ' AND ZGR_VERSAO='00' AND ZGR_IDGR='GR1' AND ZGR.D_E_L_E_T_!='*' " + linha 
  cQuery += "ORDER BY ZGR_FILIAL,ZGR_ANO,ZGR_REF,ZGR_VERSAO,CVF_ORDEM " + linha
 
  Oqry:TcQry("GR",cQuery,2,.f.)
  
  While ! GR->(EOF())
    If Empty(CVF_CTASUP)
      aadd(aGetCt2, {"*",AllTrim(ZGR_IDTAG),CVF_DESCCG,ZGR_M4,.F.})
      aadd(aGetJou, {AllTrim(ZGR_IDTAG),{}})
    Else
      nPos := ascan(aGetJou, {|x| x[1]==AllTrim(CVF_CTASUP)})
      If nPos > 0
        aadd(aGetJou[nPos,2], {AllTrim(ZGR_IDTAG),CVF_DESCCG,ZGR_M4,.F.})
      EndIf
    EndIF
  GR->(dbSkip())  
  EndDo
  GR->(dbCloseArea())

Return

*Funcao********************************************************************************************************

Static Function fExpandir(ctasup)

  Local nPos := 0
  Local aDados := {}

  cCORsup := ctasup
  oGetCt2:Refresh()
    
  nPos := ascan(aGetJou, {|x| x[1]==AllTrim(ctasup)})
  If nPos > 0
    aDados := aClone(aGetJou[nPos,2])
    oGetJou:aCols := aClone(aDados)
    oGetJou:Refresh()
  EndIf

Return

