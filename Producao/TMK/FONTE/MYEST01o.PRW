#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYEST01sprw                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 28/09/2020                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina de Ctrle de Custo - Tela Visualização e Simulação Orçamento |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYEST01o() 

  //** Variaveis de Dimensao da tela **\\
  Local aAdvSize     := MsAdvSize( NIL , .F. )
  Local aInfoAdvSize := {aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0}
  Local aObjCoords   := {{100 , 000 , .T. , .T.}}
  Local aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )
  Private nTop,nLeft,nBottom,nRight, nXY
 
  Private oFont12 := TFont():New('Arial',,-12,,.T.)
  Private oFont14 := TFont():New('Arial',,-14,,.T.)
  
  Private oBran := LoadBitmap( GetResources(), "BR_BRANCO")  //Esfera Branca
  Private oVerm := LoadBitmap( GetResources(), "BR_VERMELHO")//Esfera Vermelha
  Private oAmar := LoadBitmap( GetResources(), "BR_AMARELO") //Esfera Amarela
  Private oVerd := LoadBitmap( GetResources(), "BR_VERDE")   //Esfera Verde

  //** Variaveis de Objeto **\\
  Private oDlgCX, oPanel, oPlBtn, oGetDet, cExibCampo
    
  Private oNum, oEmissao, oCliente, oTpFrt, oVrFrt, oTabPrc, oTpCli, oVended, oEstCli, oAICMS, oCondPG, oTotNet, oMPuro, oMVda, oTComis
  Private cNum, cEmissao, cCliente, cTpFrt, cVrFrt, cTabPrc, cTpCli, cVended, cEstCli, cAICMS, cCondPG, nTotNet, nMPuro, nMVda, nTComis

  //** Variaveis de MSNewGetDados **\\
  Private xHeaderOrc, aCpoEditOrc, aOrcam

  //** Variavies Geral **\\ 
  Private Oqry    := NVLxFUN():New(.f.)
  Private cQuery  := ""                

  //** Carrega as Dimensoes de tela
  Eval({|| nXY := {aAdvSize[6],aAdvSize[5]} , nTop := aObjSize[1][1] , nLeft := aObjSize[1][2] , nBottom := aObjSize[1][3] , nRight := aObjSize[1][4] })

  //Carrega dos dados selecionado no Browser
  cNum    := SUA->UA_NUM
  cEmissao:= SUA->UA_EMISSAO
  If UA_PROSPEC == .F.
    cCliente:= SUA->UA_CLIENTE + "/" + SUA->UA_LOJA + " " + posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_NOME")
    cEstCli := posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_EST")
  Else
    cCliente:= "prospect - " + SUA->UA_CLIENTE + "/" + SUA->UA_LOJA + " " + posicione("SUS",1,xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA,"US_NOME")
    cEstCli := posicione("SUS",1,xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA,"US_EST")
  EndIf
  cTpFrt  := "(" + SUA->UA_TPFRETE + ")" + " - " + IIF(SUA->UA_TPFRETE=="F","FOB","CIF")
  cVrFrt  := SUA->UA_FRETE
  cTabPrc := SUA->UA_TABELA
  cTpCli  := SUA->UA_TIPOCLI
  cVended := SUA->UA_VEND
  cCondPG := SUA->UA_CONDPG + " - " + posicione("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI")
  nTotNet := 0
  nMPuro  := 0
  nMVda   := 0
  nTComis := 0
  
  //Omite ou não campo de Custo Puro ou Margem Pura
  cExibCampo := IIF(UPPER(AllTrim(GetMV("ZZ_EST01O"))) == UPPER(Alltrim(CUSERNAME)), .T., .F.)

  //** Montagem dos aHeaders **\\
  fHeader()
  
  //** Carrega dados **\\
  fLoadItem()

  Define MsDialog oDlgCX Title "Analise de desconto" From 0,0 To nXY[1], nXY[2] Of oMainWnd Pixel

    oPanel := tPanel():New(05,nLeft+05,,oDlgCX, ,,, ,SetTransparentColor(8421504, 80),nRight-05, 65, .F., .F.)
    TSay():New(09,005,{|| "Orcamento.:"  },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oNum := TGet():New(05, 50,{|u| if(PCount()>0,cNum:=u,cNum)},oPanel,35,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cNum")
    TSay():New(09,090,{|| "Dt.Emissão:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oEmissao := TGet():New(05,140,{|u| if(PCount()>0,cEmissao:=u,cEmissao)},oPanel,40,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cEmissao")
    TSay():New(09,185,{|| "Tabela:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oTabPrc := TGet():New(05,215,{|u| if(PCount()>0,cTabPrc:=u,cTabPrc)},oPanel,60,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cTabPrc")

    TSay():New(09,280,{|| "Vr. Total Net:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oTotNet := TGet():New(05,330,{|u| if(PCount()>0,nTotNet:=u,nTotNet)},oPanel,65,12,"@E 99,999,999.99",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"nTotNet")
    If cExibCampo
      TSay():New(29,280,{|| "% Puro:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
      oMPuro := TGet():New(25,313,{|u| if(PCount()>0,nMPuro:=u,nMPuro)},oPanel,25,12,"@E 999.99",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"nMPuro")
    EndIf
    TSay():New(29,343,{|| "% Vda:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oMVda := TGet():New(25,370,{|u| if(PCount()>0,nMVda:=u,nMVda)},oPanel,25,12,"@E 999.99",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"nMVda")

    TSay():New(29,005,{|| "Cliente:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oCliente := TGet():New(25, 50,{|u| if(PCount()>0,cCliente:=u,cCliente)},oPanel,225,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cCliente")

    TSay():New(49,005,{|| "Tipo Frete:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oTpFrt := TGet():New(45, 50,{|u| if(PCount()>0,cTpFrt:=u,cTpFrt)},oPanel,30,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cTpFrt")
    TSay():New(49,095,{|| "Valor Frete:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oVrFrt := TGet():New(45,140,{|u| if(PCount()>0,cVrFrt:=u,cVrFrt)},oPanel,40,12,"@E 999,999.99",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cVrFrt")
    TSay():New(49,185,{|| "UF:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oEstCli := TGet():New(45,200,{|u| if(PCount()>0,cEstCli:=u,cEstCli)},oPanel,20,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cEstCli")
    TSay():New(49,225,{|| "ICMS:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oAICMS := TGet():New(45,250,{|u| if(PCount()>0,cAICMS:=u,cAICMS)},oPanel,20,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cAICMS")
    TSay():New(49,280,{|| "Cond.Pgto:" },oPanel,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oCondPG := TGet():New(45,325,{|u| if(PCount()>0,cCondPG:=u,cCondPG)},oPanel,70,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cCondPG")
    
    oPlBtn := tPanel():New(03,nRight-120,,oPanel, ,,, ,SetTransparentColor(8421504,120),110, 57, .F., .F.)
    TButton():New( 05, 05, "Liberar",oPlBtn,{|| oDlgCX:End(), U_LIBDESC() }, 45,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 20, 05, "Rejeitar",oPlBtn,{|| oDlgCX:End(), U_REJDESC() }, 45,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 35, 05, "Visualizar",oPlBtn,{|| U_TMKVISUORC() }, 45,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 45, 60, "Sair",oPlBtn,{|| oDlgCX:End()}, 45,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TBitmap():New(05,63,40,40,,"\system\novel75x74px.bmp",.T.,oPlBtn, ,,.F.,.F.,,,.F.,,.T.,,.F.)
    
    oGetDet := MSNewGetDados():New(nTop+50,nLeft+05,nBottom,nRight,1,,"AlwaysTrue",,aCpoEditOrc,0, Len(aOrcam) ,,,, oDlgCX, xHeaderOrc, aOrcam)
    //oGetDet:oBrowse:lUseDefaultColors := .F.
    //oGetDet:oBrowse:SetBlkBackColor({|| fGetColor(@oGetDet) })
    //oGetDet:oBrowse:bLDblClick:={|| fExpandir(oGetDet:aCols[oGetDet:nAt,1], oGetDet:aCols[oGetDet:nAt,2], oGetDet:aCols[oGetDet:nAt,Len(oGetDet:aCols[oGetDet:nAt])-1]) }
    
  Activate MsDialog oDlgCX Centered  

Return                

*Funcao***************************************************************************************************************************************

//Configuração dos MSNewGetDados
Static Function fHeader() 

  Eval({|| aOrcam := {} , xHeaderOrc := {} , aCpoEditOrc := ""})
  aadd(xHeaderOrc, {"ST"            ,"xS01","@BMP",01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeaderOrc, {"Item"          ,"xI01","@!"  ,02,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Produto"       ,"xP01","@!"  ,15,0,"","","C",,,,})
  aadd(xHeaderOrc, {"Quantidade"    ,"xQ01","@E 999,999,999.99",14,2,"","","C",,,,})
  aadd(xHeaderOrc, {"Preco Item"    ,"xI02","@E 9,999,999.9999",14,4,"","","C",,,,})
  aadd(xHeaderOrc, {"Total Item"    ,"xI03","@E 999,999,999.99",14,2,"","","C",,,,})
  aadd(xHeaderOrc, {"Desconto(%)"   ,"xD01","@E 999,999,999.99",14,2,"","","C",,,,})
  aadd(xHeaderOrc, {"Vr Desconto"   ,"xD02","@E 999,999,999.99",14,2,"","","C",,,,})
  aadd(xHeaderOrc, {"Preco Tabela"  ,"xT01","@E 9,999,999.9999",14,4,"","","C",,,,})
  aadd(xHeaderOrc, {"Preco Net"     ,"xP01","@E 9,999,999.9999",14,4,"","","C",,,,})
  aadd(xHeaderOrc, {"Comissao"      ,"xP01","@E 9,999,999.9999",14,4,"","","C",,,,})
  If cExibCampo
    aadd(xHeaderOrc, {"Custo Puro"    ,"xT01","@E 9,999,999.9999",14,4,"","","C",,,,})
    aadd(xHeaderOrc, {"Margem Puro %" ,"xT01","@E 999,999,999.99",14,2,"","","C",,,,})
  EndIf
  aadd(xHeaderOrc, {"Custo Venda"   ,"xT01","@E 9,999,999.9999",14,4,"","","C",,,,})
  aadd(xHeaderOrc, {"Margem Venda %","xT01","@E 999,999,999.99",14,2,"","","C",,,,})
  If cExibCampo
    aadd(xHeaderOrc, {"Margem Refer %","xT01","@E 999,999,999.99",14,2,"","","C",,,,})
  EndIf
  aadd(xHeaderOrc, {"Desc .Produto" ,"xP02","@!"  ,50,0,"","","C",,,,})
  aCpoEditOrc := ""  
  
Return 

*Funcao***************************************************************************************************************************************

//Seleciona os itens do Orcamento e vincula com a tabela de custo (ZZ0)
Static Function fLoadItem() 

  Local cTPVDAZZ0 := ""
  Local nFatorImp := 0
  Local nPecoNet  := 0
  Local nPComiss  := 0
  Local nComissao := 0
  Local nMargPuro := 0
  Local nMargVda  := 0
  Local oFlag := oBran
  
  //Porcentagem de comissão
  nPComiss := (IIF(Left(cVended,1)=="R",posicione("SA3",1,xFilial("SA3")+cVended,"A3_COMIS"),0))/100
  
  //Tipo da Operação em que a tabela de Custo (ZZ0) se encaixa
  cTPVDAZZ0 := IIF(cTpCli $ "F,L","CONS","REVE")
  cTPVDAZZ0 := IIF(Left(cVended,1)=="R",Left("R"+cTPVDAZZ0,4),cTPVDAZZ0)
  cTPVDAZZ0 := IIF(cEstCli == "EX","EXPO",cTPVDAZZ0)
  
  //Informação da tela Tabela + Tipo
  cTabPrc := cTabPrc + " - " + cTPVDAZZ0

  cQuery := ""
  cQuery += "SELECT UB_ITEM, UB_PRODUTO, UB_QUANT, UB_VRUNIT, UB_VLRITEM, UB_DESC, UB_VALDESC, UB_PRCTAB, " + linha
  cQuery += "       YPURO.ZZ0_TPVDA, YPURO.ZZ0_ID, COALESCE(YPURO.ZZ0_CPURO,0) ZZ0_CPURO," + linha
  cQuery += "       YVDA.ZZ0_TPVDA,  YVDA.ZZ0_ID,  COALESCE(YVDA.ZZ0_CVDA,0) ZZ0_CVDA, " + linha
  cQuery += "       YMRG.ZZ0_TPVDA,  YMRG.ZZ0_ID,  COALESCE(YMRG.ZZ0_CPURO,0) ZZ0_YMRG, B1_DESC " + linha
  cQuery += "FROM SUB010 AS SUB " + linha
  cQuery += "INNER JOIN SB1010 AS SB1 ON B1_COD=UB_PRODUTO AND SB1.D_E_L_E_T_!='*' " + linha
  cQuery += "OUTER APPLY (SELECT ZZ0_TPVDA, MAX(ZZ0_ID) ZZ0_ID, ZZ0_PROD FROM ZZ0010 WHERE ZZ0_FILIAL=UB_FILIAL AND ZZ0_TPVDA IN ('PURO') AND ZZ0_PROD=UB_PRODUTO AND ZZ0010.D_E_L_E_T_!='*' GROUP BY ZZ0_TPVDA, ZZ0_PROD) AS XPURO " + linha
  cQuery += "LEFT JOIN ZZ0010 AS YPURO ON YPURO.ZZ0_FILIAL=UB_FILIAL AND YPURO.ZZ0_TPVDA=XPURO.ZZ0_TPVDA AND YPURO.ZZ0_PROD=XPURO.ZZ0_PROD AND YPURO.ZZ0_ID=XPURO.ZZ0_ID  AND YPURO.D_E_L_E_T_!='*' " + linha
  cQuery += "OUTER APPLY (SELECT ZZ0_TPVDA, MAX(ZZ0_ID) ZZ0_ID, ZZ0_PROD FROM ZZ0010 WHERE ZZ0_FILIAL=UB_FILIAL AND ZZ0_TPVDA IN ('"+cTPVDAZZ0+"') AND ZZ0_PROD=UB_PRODUTO AND ZZ0010.D_E_L_E_T_!='*' GROUP BY ZZ0_TPVDA, ZZ0_PROD) AS XVDA " + linha
  cQuery += "LEFT JOIN ZZ0010 AS YVDA ON YVDA.ZZ0_FILIAL=UB_FILIAL AND YVDA.ZZ0_TPVDA=XVDA.ZZ0_TPVDA AND YVDA.ZZ0_PROD=XVDA.ZZ0_PROD AND YVDA.ZZ0_ID=XVDA.ZZ0_ID AND YVDA.D_E_L_E_T_!='*' " + linha
  cQuery += "OUTER APPLY (SELECT ZZ0_TPVDA, MAX(ZZ0_ID) ZZ0_ID, ZZ0_PROD FROM ZZ0010 WHERE ZZ0_FILIAL=UB_FILIAL AND ZZ0_TPVDA IN ('MRGR') AND ZZ0_PROD=UB_PRODUTO AND ZZ0010.D_E_L_E_T_!='*' GROUP BY ZZ0_TPVDA, ZZ0_PROD) AS XMRG " + linha
  cQuery += "LEFT JOIN ZZ0010 AS YMRG ON YMRG.ZZ0_FILIAL=UB_FILIAL AND YMRG.ZZ0_TPVDA=XMRG.ZZ0_TPVDA AND YMRG.ZZ0_PROD=XMRG.ZZ0_PROD AND YMRG.ZZ0_ID=XMRG.ZZ0_ID AND YMRG.D_E_L_E_T_!='*' " + linha
  cQuery += "WHERE UB_FILIAL='"+xFilial("SUB")+"' AND UB_NUM='"+AllTrim(cNum)+"' AND SUB.D_E_L_E_T_!='*' " + linha
  cQuery += "ORDER BY UB_ITEM " + linha
   
  Oqry:TcQry("GA",cQuery,2,.f.)
  
  While ! GA->(EOF())
    nFatorImp := fFatorImp(AllTrim(UB_PRODUTO))
    nPecoNet  := UB_VRUNIT * nFatorImp
    nComissao := UB_VRUNIT * nPComiss
    nMargPuro := (((nPecoNet-nComissao-ZZ0_CPURO) / nPecoNet)*100)
    nMargVda  := (((nPecoNet-nComissao-ZZ0_CVDA) / nPecoNet)*100)
    oFlag := IIF(nMargVda < 0, oVerm, oFlag)
    oFlag := IIF(nMargVda > 0 .and. nMargVda < 20 , oAmar, oFlag)
    oFlag := IIF(nMargVda > 20, oVerd, oFlag)
    
    If cExibCampo
      aadd(aOrcam, {oFlag,UB_ITEM,UB_PRODUTO,UB_QUANT,UB_VRUNIT,UB_VLRITEM,UB_DESC,UB_VALDESC,UB_PRCTAB,nPecoNet,nComissao,ZZ0_CPURO,nMargPuro,ZZ0_CVDA,nMargVda,ZZ0_YMRG,AllTrim(B1_DESC),.F.})
    Else
      aadd(aOrcam, {oFlag,UB_ITEM,UB_PRODUTO,UB_QUANT,UB_VRUNIT,UB_VLRITEM,UB_DESC,UB_VALDESC,UB_PRCTAB,nPecoNet,nComissao,ZZ0_CVDA,nMargVda,AllTrim(B1_DESC),.F.})
    EndIf
    
    nTotNet := nTotNet + (UB_QUANT*nPecoNet)
    nTComis := nTComis + (UB_QUANT*nComissao)
    nMPuro  := nMPuro  + (UB_QUANT*ZZ0_CPURO)
    nMVda   := nMVda   + (UB_QUANT*ZZ0_CVDA)
    
  GA->(dbSkip())  
  EndDo
  GA->(dbCloseArea())
  
  nMPuro  := round(((nTotNet-nTComis-nMPuro)/nTotNet)*100,2)
  nMVda   := round(((nTotNet-nTComis-nMVda)/nTotNet)*100,2)

Return 

*Funcao***************************************************************************************************************************************

//Efetua o calculo do fator de imposto
Static Function fFatorImp(cProd)
  
  Local mvNorte := GetMV("MV_NORTE") 
  Local nAICMS  := IIF(cEstCli == SM0->M0_ESTENT, 18, IIF(cEstCli $ mvNorte, 7, 12))
  Local nAIPI   := IIF(cTpCli $ "F,L" ,posicione("SB1",1,xFilial("SB1")+cProd,"B1_IPI"),0)
  Local nAPIS   := GetMV("MV_TXPIS")
  Local nACOF   := GetMV("MV_TXCOFIN")
  Local nFator  := 0  

  nFator := ((100 - (nAICMS*(1+(nAIPI/100))) - nAPIS - nACOF)/100)
  
  //Informação da tela
  cAICMS := Alltrim(Str(nAICMS)) + " %"
       
Return nFator

*Funcao***************************************************************************************************************************************



