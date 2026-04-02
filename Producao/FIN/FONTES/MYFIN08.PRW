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
/| Programa : MYFIN08.prw                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 22/07/2019                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina para o controle de Despesas por colaboradores               |\
/|                                                                               |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYFIN08() 

  //** Variaveis de Dimensao da tela **\\
  Local aAdvSize     := MsAdvSize( NIL , .F. )
  Local aInfoAdvSize := {aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0}
  Local aObjCoords   := {{100 , 000 , .T. , .T.}}
  Local aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )
  Private nTop,nLeft,nBottom,nRight, nXY

  Private oFont11 := TFont():New('Arial',,-11,,.T.)
  Private oFont12 := TFont():New('Arial',,-12,,.T.)
  Private oFont16 := TFont():New('Arial',,-16,,.T.)
  
  Private oBran := LoadBitmap( GetResources(), "BR_BRANCO")  //Esfera Branca (Aguardando o analise)
  Private oVerd := LoadBitmap( GetResources(), "BR_VERDE")   //Esfera Verde  (Pago)
  Private oVerm := LoadBitmap( GetResources(), "BR_VERMELHO")//Esfera Vermelha (Pendencia a revisar)
  Private oPret := LoadBitmap( GetResources(), "BR_PRETO")   //Esfera Preta (Rejeitado)

  Private oVtNO := LoadBitmap( GetResources(), "LBNO")       //Visto (Analise)
  Private oVtOK := LoadBitmap( GetResources(), "LBOK")       //Visto (Autorizado)
  Private oVtTK := LoadBitmap( GetResources(), "LBTIK")      //Visto (Restingido conf. Esfera)

  Private Oqry := NVLxFUN():New(.f.), cQuery
  
  Private oPnlI, oPnlC, oPnlF
  Private oGrid, xHeader, aCpoEdit, xColRes, aColab
  Private oStatus, cStatus, aStatus, oDe, cDe, oAte, cAte
  
  //** Carrega as Dimensoes de tela
  nXY     := {aAdvSize[6],aAdvSize[5]} //Tamanho da Tela
  nTop    := aObjSize[1][1]
  nLeft   := aObjSize[1][2]
  nBottom := aObjSize[1][3]
  nRight  := aObjSize[1][4]
  
  fColaborador()
  fHeader()
  fColResumo()
  
  Eval({|| cStatus := "Sem filtro" , aStatus := {"Sem filtro","Não conferido","Não aprovado","Baixado"} , cDe := (Date()-60) , cAte := Date() })  
  
  Define MsDialog oDlgChLt Title "Controle de despesas corporativa"  From 0,0 To nXY[1], nXY[2] Pixel
  
    oPnlI:= tPanel():New(10,10,"Identificação",oDlgChLt,oFont16,,,CLR_RED,CLR_WHITE,280,60, .F., .T.)
      TBitmap():New(15,00,80,80,,"\system\novel75x74px.bmp",.T.,oPnlI, ,,.F.,.F.,,,.F.,,.T.,,.F.)
      TSay():New(20,45,{|| aColab[3]                } ,oPnlI,, oFont16 ,,,,.T.,CLR_BLUE,CLR_WHITE,380,20)
      TSay():New(40,45,{|| aColab[2]+" - "+aColab[1]} ,oPnlI,, oFont16 ,,,,.T.,CLR_BLUE,CLR_WHITE,380,20)
    oPnlF:= tPanel():New(10,300,"Filtros",oDlgChLt,oFont16,,,CLR_RED,CLR_WHITE,280,30, .F., .T.)
      TSay():New(16,10,{|| "Status:"} ,oPnlF,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,80,10)
      oStatus := TComboBox():New(12,35,{|u|if(PCount()>0,cStatus:=u,cStatus)},aStatus,60,15,oPnlF,,{|| },,,,.T.,,,,,,,,,"cStatus")
      TSay():New(16,105,{|| "Periodo:"} ,oPnlF,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,80,10)
      oDe := TGet():New(12,135,{|u| if(PCount()>0,cDe:=u,cDe)},oPnlF,40,12, ,{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cDe")
      oAte:= TGet():New(12,180,{|u| if(PCount()>0,cAte:=u,cAte)},oPnlF,40,12, ,{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cAte")
      TButton():New(12,230,"Pesquisar"  ,oPnlF,{|| oDlgChLt:End() },40,15,, ,.F.,.T.)
    oPnlC:= tPanel():New(40,300,"Controles",oDlgChLt,oFont16,,,CLR_RED,CLR_WHITE,280,30, .F., .T.)
      TButton():New(12, 10,"Incluir" ,oPnlC,{|| fViewRegra("INCLUIR") },40,15,, ,.F.,.T.)
      TButton():New(12, 75,"RH/Finan",oPnlC,{|| fViewRegra("RH/FINAN")},40,15,, ,.F.,.T.)
      TButton():New(12,120,"Conferir",oPnlC,{|| fViewRegra("CONFERIR")},40,15,, ,.F.,.T.)
      TButton():New(12,165,"Aprovar" ,oPnlC,{|| fViewRegra("APROVAR") },40,15,, ,.F.,.T.)
      TButton():New(12,230,"Fechar"  ,oPnlC,{|| oDlgChLt:End() },40,15,, ,.F.,.T.)
    
    oGrid := MSNewGetDados():New(nTop+55,nLeft+15,nBottom-35,nRight-15,3,,"AlwaysTrue",,{},0,1,,,,oDlgChLt,xHeader[1],xColRes)

  Activate MsDialog oDlgChLt Centered     
    
Return

*Funcao*******************************************************************************************************************************************

Static Function fColaborador()

  aColab := {"LEONARDO DELINARDI BERGAMASCO","000243","0201 - PLASTICOS NOVEL DE SÃO PAULO LTDA"}

Return

*Funcao*******************************************************************************************************************************************

Static Function fHeader()

  //** Variaveis de MSNewGetDados **\\
  xHeader  := {{},{}}
  aCpoEdit := {{},{}}

  //MSNewGetDados do Browser
  aadd(xHeader[1], {"ST"        ,"s2a","@BMP"         ,01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeader[1], {"Conferido" ,"s2a","@BMP"         ,01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeader[1], {"Aprovado"  ,"s2a","@BMP"         ,01,0,.T.,"","" ,"","R","","",.F.,"V","","","",""})
  aadd(xHeader[1], {"ID"        ,"pr2","@!"           ,15,0,"","","C",,,,})
  aadd(xHeader[1], {"Data DE"   ,"pr2",""             , 8,0,"","","D",,,,})
  aadd(xHeader[1], {"Data ATE"  ,"pr2",""             , 8,0,"","","D",,,,})
  aadd(xHeader[1], {"Despesa"   ,"bf2","@E 999,999.99",14,6,"","","N",,,,})
  aadd(xHeader[1], {"Observação","pr2","@!"           ,15,0,"","","C",,,,})

  //MSNewGetDados do Formulario
  aadd(xHeader[2], {"Data"          ,"c01",""            ,8,0,"","","C",,,,})
  aadd(xHeader[2], {"KM rodado"     ,"c02","@E 99,999.9" ,8,1,"","","N",,,,})
  aadd(xHeader[2], {"Vr KM"         ,"c03","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Alimentacao"   ,"c04","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Estacionamento","c05","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Taxi"          ,"c06","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Pedagio"       ,"c07","@E 99,999.99",9,2,"","","N",,,,})  
  aadd(xHeader[2], {"Passagem"      ,"c08","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Hospedagem"    ,"c09","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Loc. Veiculo"  ,"c10","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Combustivel"   ,"c11","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Desp. ADM"     ,"c12","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Telefonia"     ,"c13","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Diversos"      ,"c14","@E 99,999.99",9,2,"","","N",,,,})
  aadd(xHeader[2], {"Descr. despesa"    ,"c15","@!"    ,150,0,"","","C",,,,})
  aadd(xHeader[2], {"Pessoas envolvidas","c16","@!"    ,150,0,"","","C",,,,})
  aCpoEdit[2] := {"c04","c05","c06","c07","c11","c12","c13","c14","c15","c16"}
  
Return

*Funcao*******************************************************************************************************************************************

Static Function fColResumo()

  xColRes := {}
  
  aadd(xColRes, {oBran,oVtNO,oVtNO,"ID",date(),date(),100.54,"teste",.F.})


Return

*Funcao*******************************************************************************************************************************************

Static Function fViewRegra(cAcao)
  
  Local cID := ""

  If cAcao == "INCLUIR"
    cID := "1"
    fFormulario(cID, "I")
  ElseIf cAcao == "RH/FINAN"
    cID := Aviso("Informacoes adicionais (RH / Financeiro)","Informações adicionais ao relatorio de despesas e viagem: RH (Hospedagem, Passagem e Locação de veiculos) e FINANCEIRO (Adiantamento)",{"RH","FINANCEIRO","VOLTAR"},3,"Novel")
    If cID > 0 .and. cID < 2
      cID := fBusca("H")
      fFormulario(cID, "H")
    ElseIf cID > 1 .and. cID < 3
      cID := fBusca("F")
      fFormulario(cID, "F")
    EndIf
  ElseIf cAcao == "CONFERIR"
    cID := fBusca("C")
    fFormulario(cID, "C")
  ElseIf cAcao == "APROVAR"
    cID := fBusca("A")
    fFormulario(cID, "A")
  EndIf

Return

*Funcao*******************************************************************************************************************************************

Static Function fBusca(cAcao)

  If cAcao == "H"
  ElseIf cAcao == "F"
  ElseIf cAcao == "C"
  ElseIf cAcao == "A"
  EndIf

Return

*Funcao*******************************************************************************************************************************************

Static Function fFormulario(cID, cAcao)   

  Private oForI, oForC, oForF
  Private oGdFrm, xColFrm
  Private oID, cID, oFDe, cFDe, oFAte, cFAte

  If cAcao == "I"
  ElseIf cAcao == "H"
  ElseIf cAcao == "F"
  ElseIf cAcao == "C"
  ElseIf cAcao == "A"
  EndIf

  Eval({|| cID := "000001" , cFDe := CtoD("  /  /  ") , cFAte := CtoD("  /  /  ") })  
  
  Define MsDialog oDlgForm Title "Relatorio de despesas e viagem"  From 0,0 To nXY[1], nXY[2] Pixel
  
    oForI:= tPanel():New(10,10,"Identificação",oDlgForm,oFont16,,,CLR_RED,CLR_WHITE,280,60, .F., .T.)
      TBitmap():New(15,00,80,80,,"\system\novel75x74px.bmp",.T.,oForI, ,,.F.,.F.,,,.F.,,.T.,,.F.)
      TSay():New(20,45,{|| aColab[3]                } ,oForI,, oFont16 ,,,,.T.,CLR_BLUE,CLR_WHITE,380,20)
      TSay():New(40,45,{|| aColab[2]+" - "+aColab[1]} ,oForI,, oFont16 ,,,,.T.,CLR_BLUE,CLR_WHITE,380,20)
    oForF:= tPanel():New(10,300,"Referencia do formulario",oDlgForm,oFont16,,,CLR_RED,CLR_WHITE,280,30, .F., .T.)
      TSay():New(16,10,{|| "ID:"} ,oForF,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,80,10)
      oID := TGet():New(12,35,{|u| if(PCount()>0,cID:=u,cID)},oForF,40,12, ,{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cID")
      TSay():New(16,105,{|| "Periodo:"} ,oForF,, oFont12 ,,,,.T.,CLR_BLACK,CLR_WHITE,80,10)
      oFDe := TGet():New(12,135,{|u| if(PCount()>0,cFDe:=u,cFDe)},oForF,40,12, ,{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cFDe")
      oFAte:= TGet():New(12,180,{|u| if(PCount()>0,cFAte:=u,cFAte)},oForF,40,12, ,{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cFAte")
      TButton():New(12,230,"ABRIR"  ,oForF,{|| fAbrir() },40,15,, ,.F.,.T.)
    oForC:= tPanel():New(40,300,"Dados adicionais",oDlgForm,oFont16,,,CLR_RED,CLR_WHITE,280,30, .F., .T.)
      TButton():New(12, 10,"Informar KMs",oForC,{|| fViewRegra("INFO.RH") },50,15,, ,.F.,.T.)
      TButton():New(12, 65,"Comprovantes",oForC,{|| fViewRegra("CONFERIR")},50,15,, ,.F.,.T.)
      TButton():New(12,230,"Fechar"  ,oForC,{|| oDlgForm:End() },40,15,, ,.F.,.T.)
    
    oGdFrm := MSNewGetDados():New(nTop+55,nLeft+15,nBottom-35,nRight-15,3,,"AlwaysTrue",,aCpoEdit[2],0,1,,,,oDlgForm,xHeader[2])
    oGdFrm:oBrowse:SetBlkBackColor({|| fSomaFrm() })
    oGdFrm:Disable()

  Activate MsDialog oDlgForm Centered       

Return

*Funcao*******************************************************************************************************************************************

Static Function fAbrir()

  Local dTemp 
  
  If (cFAte < cFDe) .or. Empty(cFDe) .or. Empty(cFAte)
    APMsgStop("Periodo informado é invalido, verifique","MYFIN08")
    Return
  EndIf

  xColFrm := {}
  dTemp := cFDe
  While dTemp <= cFAte
    aadd(xColFrm, {DtoC(dTemp),0,0,0,0,0,0,0,0,0,0,0,0,0,space(150),space(150),.F.})
    dTemp := dTemp+1
  EndDo 
  aadd(xColFrm, {"** TOTAL",0,0,0,0,0,0,0,0,0,0,0,0,0,"","",.F.})
  oGdFrm:Enable()
  oGdFrm:aCols := aClone(xColFrm)

Return

*Funcao*******************************************************************************************************************************************

Static Function fSomaFrm()

  Local aSomaFrm := {"** TOTAL",0,0,0,0,0,0,0,0,0,0,0,0,0,"","",.F.}
  Local nLin := Len(xColFrm)
  Local nCol := Len(aSomaFrm)

  xColFrm := aClone(oGdFrm:aCols)
  For kl:=1 to (nLin-1)
    For kc:=2 to (nCol-3)
      aSomaFrm[kc] += xColFrm[kl,kc]
    Next
  Next
//  xColFrm[nLin] := aClone(aSomaFrm)
  oGdFrm:aCols[nLin] := aClone(aSomaFrm)  
  
//  alert("leo")

Return
