#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYCTB09.prw    | Autor : Leonardo Bergamasco   | Data : 12/01/2016 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina customizada controle de Journal                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        


User Function MYCTB10()

  //** Variaveis de Dimensao da tela **\\
  Local aAdvSize     := MsAdvSize( NIL , .F. )
  Local aInfoAdvSize := {aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0}
  Local aObjCoords   := {{100 , 000 , .T. , .T.}}
  Local aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )

  Private nTop,nLeft,nBottom,nRight,nXY, nBottomDT
  Private oJournal, aTFolder, aTFolder

  Private oGetCt2, oGetJou, oGetSld
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
  
  //** Montagem da TELA de manutenção **\\
  Define MsDialog oJournal Title "Tela de gerenciamento de Journal"  From 0,0 To nXY[1], nXY[2] Of oMainWnd Pixel
  
    //** Cria a Folder - Principal **\\
    aTFolder := { 'Lançamento', 'Resultado' }
    oTFolder := TFolder():New(nTop,0, aTFolder ,,oJournal,,,,.T.,,nRight, nBottom+10 )

    oGetCt2 := MSNewGetDados():New(20,20,((nBottom-40)*0.6),nRight-10, 3,,"AlwaysTrue",,aCpoEdit[1],0,1,,,,oTFolder:aDialogs[1],xHeader[1])
    oGetJou := MSNewGetDados():New(20+10+((nBottom-40)*0.6),20,(nBottom-40),nRight-10, 3,,"AlwaysTrue",,aCpoEdit[2],0,1,,,,oTFolder:aDialogs[1],xHeader[2])
  Activate MsDialog oJournal Centered  
  
	
Return

*Funcao***************************************************************************************************************************************

//Configuração dos MSNewGetDados
Static Function fHeader()

  //MSNewGetDados de Sequenciamento - oGetCt2
  aadd(xHeader[1], {"col 1"  ,"xPrd","@!"  ,15,0,"","","C",,,,})
  aadd(xHeader[1], {"col 2"  ,"xPrd","@!"  ,15,0,"","","C",,,,})
  aCpoEdit[1] := {""}
  //MSNewGetDados de Sequenciamento - oGetJou
  aadd(xHeader[2], {"col A"  ,"xPrd","@!"  ,15,0,"","","C",,,,})
  aadd(xHeader[2], {"col B"  ,"xPrd","@!"  ,15,0,"","","C",,,,})
  aCpoEdit[2] := {""}

Return

*Funcao********************************************************************************************************

Static Function fSQLct2()


Return