#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYEST01f.prw               | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 17/09/2017                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina de Ctrl de Custo - Fases do Custo                           |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYEST01f() 

  //** Variaveis de Dimensao da tela **\\
  Local aAdvSize     := MsAdvSize( NIL , .F. )
  Local aInfoAdvSize := {aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0}
  Local aObjCoords   := {{100 , 000 , .T. , .T.}}
  Local aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )
  Private nTop,nLeft,nBottom,nRight, nXY
 
  //** Variavies Geral **\\ 
  Private Oqry    := NVLxFUN():New(.f.)
  Private cQuery  := ""                

  Private oFont12 := TFont():New('Arial',,-12,,.T.)
  Private oFont14 := TFont():New('Arial',,-14,,.T.)
  
  //Imagem
  Private oBran := LoadBitmap( GetResources(), "BR_BRANCO")  //Esfera Branca
  Private oVerd := LoadBitmap( GetResources(), "BR_VERDE")   //Esfera Verde
  Private oAmar := LoadBitmap( GetResources(), "BR_AMARELO") //Esfera Amarela
  Private oPret := LoadBitmap( GetResources(), "BR_PRETO")   //Esfera Preta
  Private oVerm := LoadBitmap( GetResources(), "BR_VERMELHO")//Esfera Vermelha
  Private oTVrm := LoadBitmap( GetResources(), "PMSEDT1")    //Triangulo Vermelho
  Private oTCnz := LoadBitmap( GetResources(), "PMSEDT4")    //Triangulo Cinza
  Private oTVrd := LoadBitmap( GetResources(), "PMSEDT3")    //Triangulo Verde

  Private oDlgFS, oPMFS, oPBFS, oGetItm
  Private oID, cID, oDT, cDT, oUser, cUSer

  //** Variaveis de MSNewGetDados **\\
  Private xHeaderItm, aCpoEditItm, aItemOrc

  //** Carrega as Dimensoes de tela
  Eval({|| nXY := {aAdvSize[6],aAdvSize[5]} , nTop := aObjSize[1][1] , nLeft := aObjSize[1][2] , nBottom := aObjSize[1][3] , nRight := aObjSize[1][4] })
 
  Eval({|| cID:=space(6), cDT:=CtoD("  /  /  "), cUSer:=space(30) })

  //** Montagem dos aHeaders **\\
  fHeader() 

  cID := AllTrim(aItem[1])
  cDT := Date()
  cUSer := __cUserID + " " + cUserName 

  Define MsDialog oDlgFS Title "FASE " + cFase From 0,0 To nXY[1], nXY[2] Of oMainWnd Pixel

    oPMFS := tPanel():New(05,05,,oDlgFS, ,,, ,SetTransparentColor(8421504, 80),345, 22, .F., .F.)
    TSay():New(09,05,{|| "ID.:"  },oPMFS,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oID := TGet():New(05,20,{|u| if(PCount()>0,cID:=u,cID)},oPMFS,35,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cID")
    TSay():New(09,65,{|| "Data:" },oPMFS,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oDT := TGet():New(05,85,{|u| if(PCount()>0,cDT:=u,cDT)},oPMFS,40,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cDT")
    TSay():New(09,135,{|| "Analista:" },oPMFS,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,50)
    oUSer := TGet():New(05,180,{|u| if(PCount()>0,cUSer:=u,cUSer)},oPMFS,110,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cUSer")

    oPBFS := tPanel():New(03,305,,oPMFS, ,,, ,SetTransparentColor(8421504,120), 35, 17, .F., .F.)
    TBtnBmp2():New(02, 12,26,26,'NOCHECKED',,,,{|| lSalveInc := .F. , oDlgFS:End() },oPBFS,,,.T. )
    TBtnBmp2():New(02, 42,26,26,'CHECKED'  ,,,,{|| lSalveInc := .T. , oDlgFS:End() },oPBFS,,,.T. )

    oGetItm := MSNewGetDados():New(nTop,nLeft+03,nBottom,nRight,3,,"AlwaysTrue",,aCpoEditItm,0, Len(aItemOrc) ,,,, oDlgFS, xHeaderItm, aItemOrc)
    oGetItm:oBrowse:lUseDefaultColors := .F.
    //oGetItm:oBrowse:SetBlkBackColor({|| fGetColor(@oGetItm) })
    //oGetItm:oBrowse:bLDblClick:={|| fExpandir(oGetItm:aCols[oGetItm:nAt,1], oGetItm:aCols[oGetItm:nAt,2], oGetItm:aCols[oGetItm:nAt,Len(oGetItm:aCols[oGetItm:nAt])-1]) }
        
  Activate MsDialog oDlgFS Centered

Return

*Funcao***************************************************************************************************************************************

//Configuração dos MSNewGetDados
Static Function fHeader() 
  Eval({|| aItemOrc := {} , xHeaderItm := {} , aCpoEditItm := ""})
  aadd(xHeaderItm, {"Orcamento" ,"xC01","@!"  ,02,0,"","","C",,,,})
  aadd(xHeaderItm, {"Referencia","xC02","@!"  ,25,0,"","","C",,,,})
  aadd(xHeaderItm, {"Qualid"    ,"xS02","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeaderItm, {"Compra"    ,"xS03","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeaderItm, {"Custo"     ,"xS04","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeaderItm, {"Produto"   ,"xC03","@!"  ,15,0,"","","C",,,,})
  aadd(xHeaderItm, {"Descr.Prod","xC04","@!"  ,50,0,"","","C",,,,})
  aadd(xHeaderItm, {"Cliente/Lj","xC05","@!"  ,09,0,"","","C",,,,})
  aadd(xHeaderItm, {"Razão"     ,"xC06","@!"  ,25,0,"","","C",,,,})
  aadd(xHeaderItm, {"Dt.Env.Cot","xC07","@!"  ,08,0,"","","C",,,,})
  aadd(xHeaderItm, {"Volume Mes","xC08","@!"  ,10,0,"","","N",,,,})
  aadd(xHeaderItm, {"Volume Ano","xC09","@!"  ,10,0,"","","N",,,,}) 
  aCpoEditItm := ""  
  aadd(aItemOrc, {oBran,space(6),"TESTE PRODUTO",oTCnz,oTCnz,oTCnz,"","","","","",0,0,.F.})
  
Return 

*Funcao***************************************************************************************************************************************

