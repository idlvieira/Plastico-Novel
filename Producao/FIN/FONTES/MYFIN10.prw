#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYFIN10.prw    | Autor : Leonardo Bergamasco   | Data : 02/07/2020 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina customizada inclusão de titulos sem pedido de compras       |\
/|-------------------------------------------------------------------------------|\
/| Processo.: Tela para inclusão, fluxo de aprovação e criação do titulo (SE1)   |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        


User Function MYFIN10()

  //** Variaveis de Dimensao da tela **\\
  Local aAdvSize     := MsAdvSize( NIL , .F. )
  Local aInfoAdvSize := {aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0}
  Local aObjCoords   := {{100 , 000 , .T. , .T.}}
  Local aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )
  
  Private oFont14  := TFont():New('Arial',,-14,,.T.)
  Private oFont12  := TFont():New('Arial',,-12,,.T.)

  Private oBran := LoadBitmap( GetResources(), "BR_BRANCO")  //Esfera Branca
  Private oPret := LoadBitmap( GetResources(), "BR_PRETO")   //Esfera Preta
  Private oVerd := LoadBitmap( GetResources(), "BR_VERDE")   //Esfera Verde
  Private oAmar := LoadBitmap( GetResources(), "BR_AMARELO") //Esfera Amarela
  Private oVerm := LoadBitmap( GetResources(), "BR_VERMELHO")//Esfera Vermelha
  		
  //** Variaveis de Objeto **\\
  Private oDlgTP, oPnl, oScr, oGetDd
  Private xHeader, aCpoEdit
  Private cBusca, aDados
  
  Private Oqry   := NVLxFUN():New(.f.)
  Private cQuery := ""

  Private nTop,nLeft,nBottom,nRight,nXY
  
  //** Carrega as Dimensoes de tela
  nXY     := {aAdvSize[6],aAdvSize[5]} //Tamanho da Tela
  nTop    := aObjSize[1][1]
  nLeft   := aObjSize[1][2]
  nBottom := aObjSize[1][3]
  nRight  := aObjSize[1][4]

  oPnl := {}
  cBusca := space(9)
  fHeader()
  
  //** TELA principal **\\
  Define MsDialog oDlgTP Title "Controle de Titulo a pagar sem pedido"  From 0,0 To nXY[1], nXY[2] Of oMainWnd Pixel
    
    oScr := TScrollBox():New(oDlgTP,05,05,nBottom-10,230,.T.,.T.,.T.)
      aadd(oPnl, tPanel():New(05,10,"",oScr,oFont14,,,CLR_RED,CLR_WHITE,210,60, .F., .T.))
        TBitmap():New(05,05,80,80,,"\system\novel75x74px.bmp",.T.,oPnl[1], ,,.F.,.F.,,,.F.,,.T.,,.F.)
        TSay():New(20,50,{|| "Controle de Titulo a pagar sem pedido" } ,oPnl[1],, oFont14 ,,,,.T.,CLR_RED,CLR_WHITE,180,10)
      aadd(oPnl, tPanel():New(10+65,10,"Menu",oScr,oFont14,,,CLR_RED,CLR_WHITE,210,60, .F., .T.))
        TSay():New(10,10,{|| "Solicitante" } ,oPnl[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TSay():New(20,10,{|| "LEONARDO DELINARDI BERGAMASCO" } ,oPnl[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TButton():New(35,10,"Visualizar",oPnl[2],{|| fTitSPC("V") },35,15,, ,.F.,.T.)
        TButton():New(35,50,"Incluir"   ,oPnl[2],{|| fTitSPC("I") },35,15,, ,.F.,.T.)
        TButton():New(35,90,"Alterar"   ,oPnl[2],{|| fTitSPC("A") },35,15,, ,.F.,.T.)
        TButton():New(35,130,"Excluir"  ,oPnl[2],{|| fTitSPC("E") },35,15,, ,.F.,.T.)
        TButton():New(35,170,"Sair"     ,oPnl[2],{|| oDlgTP:end() },35,15,, ,.F.,.T.)
      aadd(oPnl, tPanel():New(75+65,10,"Pesquisa",oScr,oFont14,,,CLR_RED,CLR_WHITE,210,60, .F., .T.))
        TGet():New(15,05,{|u| if(PCount()>0,cBusca:=u,cBusca)},oPnl[3],40,15,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cBusca")
        TButton():New(15,50,"Buscar",oPnl[3],{|| fViewRegra() },35,15,, ,.F.,.T.)
        TButton():New(35,05,"Listar titulos nao Aprovados",oPnl[3],{|| fViewRegra() },90,15,, ,.F.,.T.)
        TButton():New(35,105,"Listar titulos aprovados",oPnl[3],{|| fViewRegra() },90,15,, ,.F.,.T.)
      TSay():New(145+60,10,{|| "Legenda (Doc.Suporte):" } ,oScr,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TBitmap():New(220,10,26,26,"BR_BRANCO",,.T.,oScr, ,,.F.,.F.,,,.F.,,.T.,,.F.)
        TSay():New(220,20,{|| "Documento anexado" } ,oScr,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TBitmap():New(230,10,26,26,"BR_PRETO",,.T.,oScr, ,,.F.,.F.,,,.F.,,.T.,,.F.)
        TSay():New(230,20,{|| "Sem documento" } ,oScr,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
      TSay():New(145+60,100,{|| "Legenda (Aprovação):" } ,oScr,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TBitmap():New(220,100,26,26,"BR_BRANCO",,.T.,oScr, ,,.F.,.F.,,,.F.,,.T.,,.F.)
        TSay():New(220,120,{|| "Aguardando 1o. Aprov." } ,oScr,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TBitmap():New(230,100,26,26,"BR_AMARELO",,.T.,oScr, ,,.F.,.F.,,,.F.,,.T.,,.F.)
        TSay():New(230,120,{|| "Aguardando 2o. Aprov" } ,oScr,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TBitmap():New(240,100,26,26,"BR_VERDE",,.T.,oScr, ,,.F.,.F.,,,.F.,,.T.,,.F.)
        TSay():New(240,120,{|| "Aprovado" } ,oScr,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TBitmap():New(250,100,26,26,"BR_VERMELHO",,.T.,oScr, ,,.F.,.F.,,,.F.,,.T.,,.F.)
        TSay():New(250,120,{|| "Rejeitado" } ,oScr,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
    oGetDd := MSNewGetDados():New(05,nLeft+(nRight*(25/100)),nBottom-05,nRight,3,,"AlwaysTrue",,aCpoEdit,0, ,,,,oDlgTP,xHeader,aDados)
  
  Activate MsDialog oDlgTP Centered  
  
Return

*Funcao***************************************************************************************************************************************

Static Function fHeader()

    xHeader := {}
    aadd(xHeader, {"Doc.Suporte", "xSUP","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
    aadd(xHeader, {"Aprovações" , "xAPV","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
    aadd(xHeader, {"ID Sistema" , "xIDS","@!"  ,06,0,"","","C",,,,})
    aadd(xHeader, {"Emissao"    , "xDTE","  "  ,08,0,"","","D",,,,})
    aadd(xHeader, {"Num. Doc."  , "xDOC","@!"  ,09,0,"","","C",,,,})
    aadd(xHeader, {"Vencimento" , "xDTV","  "  ,08,0,"","","D",,,,})
    aadd(xHeader, {"Valor"      , "xVLR","@E 999,999,999.99",14,2,"","","N",,,,})
    aadd(xHeader, {"Fornec/Lj"  , "xCFJ","@!"  ,09,0,"","","C",,,,})
    aadd(xHeader, {"Razão"      , "xRZS","@!"  ,60,0,"","","C",,,,})
    
    aCpoEdit := {}
    
    aDados := {}
    aadd(aDados, {oPret,oPret,"RS0001",date(),"123456789",date(),24115.88,"123456/00","TESTE DE INCLUSÃO 1",.F.})
    aadd(aDados, {oBran,oAmar,"RS0002",date(),"123456789",date(), 1000.67,"123456/00","TESTE DE INCLUSÃO 2",.F.})
    aadd(aDados, {oBran,oVerd,"RS0003",date(),"123456789",date(),   50.50,"123456/00","TESTE DE INCLUSÃO 3",.F.})
    aadd(aDados, {oBran,oVerm,"RS0004",date(),"123456789",date(),  150.50,"123456/00","TESTE DE INCLUSÃO 4",.F.})

Return

*Funcao***************************************************************************************************************************************

Static Function fTitSPC(arg)

  Local cTitle := ""
  
  Private oDlgTt, oPnlTt
  Private aBt3 := {nil, nil, "S", "3"}
  Private aOb3 := {nil, nil, nil, nil, .t., nil, 0}
  Private cRef, cDoc, cID, cForn, cLoja, nValor, dVenc, cCHist, cRHist
  
  oPnlTt := {}
  cTitle := IIF(arg=="V","Visualizar",IIF(arg=="I","Incluir",IIF(arg=="A","Alterar","Excluir")))
  cRef   := 1
  cForn  := space(6)
  cLoja  := space(2)
  nValor := 0
  dVenc  := CtoD("  /  /  ")
  cCHist := ""
  cRHist := space(40)
  cDoc   := space(9)
  cID    := "TT-123456"

  //** TELA titulo **\\
  Define MsDialog oDlgTt Title (cTitle + " Titulo")  From 0,0 To 555, 450 Of oMainWnd Pixel
    
    aadd(oPnlTt, tPanel():New(05,10,"Menu",oDlgTt,oFont14,,,CLR_RED,CLR_WHITE,210,55, .F., .T.))
      TBitmap():New(10,05,80,80,,"\system\novel75x74px.bmp",.T.,oPnlTt[1], ,,.F.,.F.,,,.F.,,.T.,,.F.)
      TSay():New(15,50,{|| "Controle de Titulo a pagar sem pedido" } ,oPnlTt[1],, oFont14 ,,,,.T.,CLR_RED,CLR_WHITE,180,10)
      TButton():New(30,60,"Cancelar",oPnlTt[1],{|| oDlgTt:end() },35,15,, ,.F.,.T.)
      TButton():New(30,100,"Gravar"  ,oPnlTt[1],{|| oDlgTt:end() },35,15,, ,.F.,.T.)
      TButton():New(30,140,"E-mail"  ,oPnlTt[1],{|| oDlgTt:end() },35,15,, ,.F.,.T.)
    aadd(oPnlTt, tPanel():New(10+60,10,"Detalhes",oDlgTt,oFont14,,,CLR_RED,CLR_WHITE,210,200, .F., .T.))
      TSay():New(12,10,{|| "Referencia:" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TComboBox():New(10,60,{|u|if(PCount()>0,cRef:=u,cRef)},{"SD01 - Dias produção","SD02 - Porcentagem segurança","SD03 - Tempo produção","SD04 - Kanban"},145,10,oPnlTt[2],,{||},,,,.T.,,,,,,,,,"cRef")

      TSay():New(29,10,{|| "Documento:" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TGet():New(25,60,{|u| if(PCount()>0,cDoc:=u,cDoc)},oPnlTt[2],40,10,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cDoc")
      TSay():New(29,150,{|| "ID:" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TGet():New(25,165,{|u| if(PCount()>0,cID:=u,cID)},oPnlTt[2],40,10,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cID")

      TSay():New(44,10,{|| "Fornecedor:" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TGet():New(40,60,{|u| if(PCount()>0,cForn:=u,cForn)},oPnlTt[2],40,10,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,"SA2","cForn")
        TGet():New(40,105,{|u| if(PCount()>0,cLoja:=u,cLoja)},oPnlTt[2],20,10,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cLoja")
        TSay():New(55,60,{|| "Teste Fornecedor:" } ,oPnlTt[2],,  ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
      TSay():New(69,10,{|| "Valor:" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TGet():New(65,60,{|u| if(PCount()>0,nValor:=u,nValor)},oPnlTt[2],60,10,"@E 999,999,999.99",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"nValor")
      TSay():New(84,10,{|| "Dt.Vencimento:" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TGet():New(80,60,{|u| if(PCount()>0,dVenc:=u,dVenc)},oPnlTt[2],45,10,'@!',{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"dVenc")
      TSay():New(99,10,{|| "Historico:" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        tMultiget():new(95,60, {| u | if( pCount() > 0, cCHist := u, cCHist ) },oPnlTt[2], 145,55, , , , , , .T. )
      TSay():New(159,10,{|| "Resumo Hist.:" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,180,10)
        TGet():New(155,60,{|u| if(PCount()>0,cRHist:=u,cRHist)},oPnlTt[2],145,10,'@!',{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cRHist")
    TSay():New(170,10,{|| "Documento suporte" } ,oPnlTt[2],, oFont12 ,,,,.T.,CLR_BLUE,CLR_WHITE,180,20)
      aOb3[2]:= THButton():New(180,10,"(+)Anexar"   ,oPnlTt[2],{|| fArqAnexo("+","SC_Cotacao") },40,15,,"Clique") 
      aOb3[2]:SetCss("QPushButton { font: bold 12px Arial; padding: 6px;}")
      aOb3[2]:Show()
      aOb3[3]:= THButton():New(180,60,"(-)Remover"  ,oPnlTt[2],{|| fArqAnexo("-","SC_Cotacao") },40,15,,"Clique")
      aOb3[3]:SetCss("QPushButton { font: bold 12px Arial; padding: 6px;}") 
      aOb3[3]:Show()
      aOb3[4]:= THButton():New(180,110,"(*)Verificar",oPnlTt[2],{|| fArqAnexo("*","SC_Cotacao") },40,15,,"Clique")
      aOb3[4]:SetCss("QPushButton { font: bold 12px Arial; padding: 6px;}")
      aOb3[4]:Show()
      aOb3[6]:= TGet():New(180,160,{|u| if(PCount()>0,aOb3[7]:=u,aOb3[7])},oPnlTt[2],15,10,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"aOb3[7]") 
      aOb3[6]:SetEnable(.F.)
    
  Activate MsDialog oDlgTt Centered
  
Return