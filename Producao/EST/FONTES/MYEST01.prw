#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYEST01.prw                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 17/09/2017                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina de Ctrle de Custo                                           |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYEST01() 

  //** Variaveis de Dimensao da tela **\\
  Local aAdvSize     := MsAdvSize( NIL , .F. )
  Local aInfoAdvSize := {aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0}
  Local aObjCoords   := {{100 , 000 , .T. , .T.}}
  Local aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )
  Private nTop,nLeft,nBottom,nRight, nXY
 
  Private oFont12 := TFont():New('Arial',,-12,,.T.)
  Private oFont14 := TFont():New('Arial',,-14,,.T.)
  
  Private oBran := LoadBitmap( GetResources(), "BR_BRANCO")  //Esfera Branca
  Private oVerd := LoadBitmap( GetResources(), "BR_VERDE")   //Esfera Verde
  Private oAmar := LoadBitmap( GetResources(), "BR_AMARELO") //Esfera Amarela
  Private oPret := LoadBitmap( GetResources(), "BR_PRETO")   //Esfera Preta
  Private oVerm := LoadBitmap( GetResources(), "BR_VERMELHO")//Esfera Vermelha
  Private oTVrm := LoadBitmap( GetResources(), "PMSEDT1")    //Triangulo Vermelho
  Private oTCnz := LoadBitmap( GetResources(), "PMSEDT4")    //Triangulo Cinza
  Private oTVrd := LoadBitmap( GetResources(), "PMSEDT3")    //Triangulo Verde

  //** Variaveis de Objeto **\\
  Private oDlgCX, oPanel, oPlBtn, oGetDet
  Private oGBusca, oGFases, oGForma
  Private cGBusca, cGFases, cGForma  

  //** Variaveis de MSNewGetDados **\\
  Private xHeaderOrc, aCpoEditOrc, aOrcam

  //** Variavies Geral **\\ 
  Private Oqry    := NVLxFUN():New(.f.)
  Private cQuery  := ""                

  //** Carrega as Dimensoes de tela
  Eval({|| nXY := {aAdvSize[6],aAdvSize[5]} , nTop := aObjSize[1][1] , nLeft := aObjSize[1][2] , nBottom := aObjSize[1][3] , nRight := aObjSize[1][4] })

  Eval({|| cGBusca := space(50), nGFase := 0 , cGForma := 0 })

  //** Montagem dos aHeaders **\\
  fHeader()

  Define MsDialog oDlgCX Title "Controle de Custo" From 0,0 To nXY[1], nXY[2] Of oMainWnd Pixel

    oPanel := tPanel():New(05,nLeft+03,,oDlgCX, ,,, ,SetTransparentColor(8421504, 80),nRight-05, 22, .F., .F.)
    TSay():New(09,005,{|| "Procurar.:"  },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oGBusca := TGet():New(05, 45,{|u| if(PCount()>0,cGBusca:=u,cGBusca)},oPanel,100,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cGBusca")
    TSay():New(09,160,{|| "Fase:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oGFases := TComboBox():New(05,185,{|u|if(PCount()>0,cGFases:=u,cGFases)},{"Todas","Qualidade","Compras","Custo"},60,15,oPanel,,{|| nGFase:=0  },,,,.T.,,,,,,,,,"cGFases")
    oGFases:SetFont(oFont14)    
    oGForma := TComboBox():New(05,250,{|u|if(PCount()>0,cGForma:=u,cGForma)},{"Ambas","Concluida","Pendente"},60,15,oPanel,,{|| cGForma:=0  },,,,.T.,,,,,,,,,"cGForma")
    oGForma:SetFont(oFont14)    
    TBtnBmp2():New(10,630,26,26,'s4wb014b' ,,,,{|| oDlgCX:End() },oPanel,,,.T. )
    
    oPlBtn := tPanel():New(03,nRight-115,,oPanel, ,,, ,SetTransparentColor(8421504,120),100, 15, .F., .F.)
    TBtnBmp2():New(02, 12,26,26,'form'      ,,,,{|| fConfigura("BASE") },oPlBtn,,,.T. )
    TBtnBmp2():New(02, 42,26,26,'sducount'  ,,,,{|| fConfigura("ORCA") },oPlBtn,,,.T. )
    TBtnBmp2():New(02, 72,26,26,'roteiro'   ,,,,{|| fConfigura("FASE") },oPlBtn,,,.T. )
    TBtnBmp2():New(02,102,26,26,'impressao' ,,,,{|| fConfigura("PREL") },oPlBtn,,,.T. )
    TBtnBmp2():New(02,132,26,26,'engrenagem' ,,,,{|| fConfigura("UPLD") },oPlBtn,,,.T. )
    TBtnBmp2():New(02,162,26,26,'final'     ,,,,{|| oDlgCX:End()       },oPlBtn,,,.T. )
    
    oGetDet := MSNewGetDados():New(nTop,nLeft+03,nBottom,nRight,3,,"AlwaysTrue",,aCpoEditOrc,0, Len(aOrcam) ,,,, oDlgCX, xHeaderOrc, aOrcam)
    oGetDet:oBrowse:lUseDefaultColors := .F.
    //oGetDet:oBrowse:SetBlkBackColor({|| fGetColor(@oGetDet) })
    //oGetDet:oBrowse:bLDblClick:={|| fExpandir(oGetDet:aCols[oGetDet:nAt,1], oGetDet:aCols[oGetDet:nAt,2], oGetDet:aCols[oGetDet:nAt,Len(oGetDet:aCols[oGetDet:nAt])-1]) }
    
  Activate MsDialog oDlgCX Centered  

Return                

*Funcao***************************************************************************************************************************************

//Configuração dos MSNewGetDados
Static Function fHeader() 

  Eval({|| aOrcam := {} , xHeaderOrc := {} , aCpoEditOrc := ""})
  aadd(xHeaderOrc, {"ST"        ,"xS01","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeaderOrc, {"Orcamento" ,"xC01","@!"  ,02,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Referencia","xC02","@!"  ,25,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Qualid"    ,"xS02","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeaderOrc, {"Compra"    ,"xS03","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeaderOrc, {"Custo"     ,"xS04","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeaderOrc, {"Produto"   ,"xC03","@!"  ,15,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Descr.Prod","xC04","@!"  ,50,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Cliente/Lj","xC05","@!"  ,09,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Razão"     ,"xC06","@!"  ,25,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Dt.Env.Cot","xC07","@!"  ,08,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Volume Mes","xC08","@!"  ,10,0,"","","N",,,,})
  aadd(xHeaderOrc, {"Volume Ano","xC09","@!"  ,10,0,"","","N",,,,}) 
  aCpoEditOrc := ""  
  aadd(aOrcam, {oBran,space(6),"Aguardando busca",oTCnz,oTCnz,oTCnz,"","","","","",0,0,.F.})
  
Return 

*Funcao***************************************************************************************************************************************

Static Function fConfigura(xOpc)

  Local nAviso := 0 
  Local aFase := {"1 Qualidade","2 Compras","3 Custos","Sair"}

  If xOpc == "BASE"
    //u_MYEST01b()
  ElseIf xOpc == "ORCA"
    //u_MYEST01i()
  ElseIf xOpc == "FASE"
    nAviso := Aviso("Controle de Custo","Inclusão das informações referente as fases do custo",aFase,3,"Fases")
    If nAviso > 0 .and. nAviso < 4
      //u_MYEST01f(Upper(aFase[nAviso]), oGetDet:aCols[oGetDet:nAt])
    EndIf
  ElseIf xOpc == "PREL"
    MsAguarde( {|| fPrintREL() },"Aguarde... ","Gerando...")
  ElseIf xOpc == "UPLD"
    MsAguarde( {|| fSetupGRL() },"Aguarde... ","Gerando...")
  EndIf

Return

*Funcao***************************************************************************************************************************************

Static Function fPrintREL()

  Local nOpc := 0
  Local aOpc := {"1 Ped.Venda","Sair"}
  
  nOpc := Aviso("Controle de Custo","Relatorios para analise de custo",aOpc,3,"Novel")
  If nOpc > 0 .and. nOpc < 2
    u_MYEST01r("PVDA")
  EndIF

Return

*Funcao***************************************************************************************************************************************

Static Function fSetupGRL()

  Local nOpc := 0
  Local aOpc := {"1 UPLOAD","Sair"}
  
  nOpc := Aviso("Controle de Custo","Rotinas gerais",aOpc,3,"Novel")
  If nOpc > 0 .and. nOpc < 2
    u_MYEST01u()
  EndIF

Return