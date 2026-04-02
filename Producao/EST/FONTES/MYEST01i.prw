#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYEST01i.prw               | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 17/09/2017                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina de Ctrl de Custo - Inclusão de Orcamento                    |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYEST01i() 

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

  Private oDlgIN, oPMIN, oPBIN, oBtEnviar
  Private oID, cID, oDT, cDT, oUser, cUSer, oProd, cProd, oDesc, cDesc, oCli, cCli, oLj, cLj, oRaz, cRaz, oDEnv, cDEnv, oQtMes, nQtMes, oQtAno, cQtAno
  
  Eval({|| cID:=space(6), cDT:=CtoD("  /  /  "), cUSer:=space(30), cProd:=space(15), cCli:=space(6), cLj:=space(2), cDEnv:=CtoD("  /  /  "), nQtMes:=0, cQtAno:=0 })
  
  cID := "000001"
  cDT := Date()
  cUSer := __cUserID + " " + cUserName 

  Define MsDialog oDlgIN Title "Inserir uma solicitação orçamento"  From 0,0 To 230, 700 Of oMainWnd Pixel

    oPMIN := tPanel():New(05,05,,oDlgIN, ,,, ,SetTransparentColor(8421504, 80),345, 22, .F., .F.)
    TSay():New(09,05,{|| "ID.:"  },oPMIN,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oID := TGet():New(05,20,{|u| if(PCount()>0,cID:=u,cID)},oPMIN,35,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cID")
    TSay():New(09,65,{|| "Data:" },oPMIN,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,10)
    oDT := TGet():New(05,85,{|u| if(PCount()>0,cDT:=u,cDT)},oPMIN,40,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cDT")
    TSay():New(09,135,{|| "Solicitante:" },oPMIN,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,nRight,50)
    oUSer := TGet():New(05,180,{|u| if(PCount()>0,cUSer:=u,cUSer)},oPMIN,110,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,     ,"cUSer")

    oPBIN := tPanel():New(03,305,,oPMIN, ,,, ,SetTransparentColor(8421504,120), 35, 17, .F., .F.)
    TBtnBmp2():New(02, 12,26,26,'NOCHECKED',,,,{|| lSalveInc := .F. , oDlgIN:End() },oPBIN,,,.T. )
    TBtnBmp2():New(02, 42,26,26,'CHECKED'  ,,,,{|| lSalveInc := .T. , oDlgIN:End() },oPBIN,,,.T. )

    TSay():New(39,05,{|| "Codigo do Produto Int.:" },oDlgIN,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,nRight,10)
    oProd := TGet():New(35,100,{|u| if(PCount()>0,cProd:=u,cProd)},oDlgIN,75,12,"@!",{|| cDesc := fGetInc("Prod",cProd,@oDesc)},,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,"SB1","cProd")
    oDesc := TSay():New(39,185,{|| "Aguardando seleção" },oDlgIN,,,,,,.T.,CLR_BLACK,CLR_WHITE,nRight,10)
    TSay():New(54,05,{|| "Codigo do Cliente/Loja:" },oDlgIN,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,nRight,10) 
    oCli := TGet():New(50,100,{|u| if(PCount()>0,cCli:=u,cCli)},oDlgIN,40,12,"@!",{|| cRaz := fGetInc("CliL",cCli+cLj,@oRaz) },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,"SA1","cCli")
    oLj := TGet():New(50,145,{|u| if(PCount()>0,cLj:=u,cLj)},oDlgIN,15,12,"@!",{|| fGetInc("CliL",cCli+cLj,@oRaz) },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cLj")
    oRaz := TSay():New(54,185,{|| "Aguardando seleção" },oDlgIN,,,,,,.T.,CLR_BLACK,CLR_WHITE,nRight,10)
    TSay():New(69,05,{|| "Retorno da solicitação:" },oDlgIN,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,nRight,10)
    oDEnv := TGet():New(65,100,{|u| if(PCount()>0,cDEnv:=u,cDEnv)},oDlgIN,40,12,"@!",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cDEnv")
    TSay():New(84,05,{|| "Previsão do Volume mes:" },oDlgIN,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,nRight,10) 
    oQtMes := TGet():New(80,100,{|u| if(PCount()>0,nQtMes:=u,nQtMes)},oDlgIN,40,12,"@E 999,999,999",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"nQtMes")
    TSay():New(99,05,{|| "Previsao do Volume ano:" },oDlgIN,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,nRight,10)  
    oQtAno := TGet():New(95,100,{|u| if(PCount()>0,cQtAno:=u,cQtAno)},oDlgIN,40,12,"@E 999,999,999",{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,     ,"cQtAno")
    TBitmap():New(70,300,80,80,,"\system\novel75x74px.bmp",.T.,oDlgIN, ,,.F.,.F.,,,.F.,,.T.,,.F.)
        
  Activate MsDialog oDlgIN Centered
  
  If lSalveInc
//    oGetDet:aCols := {}
//    aadd(oGetDet:aCols, {oVerm,cID,"teste 1",oTCnz,oTCnz,oTCnz,cProd,cDesc,cCli+cLj,cRaz,cDEnv,nQtMes,cQtAno,.F.})
  EndIf

Return         

*Funcao***************************************************************************************************************************************                      

Static Function fGetInc(cOpcGet,cDadGet,oGet)  

  Local cDadSet 

  If cOpcGet == "Prod"
    cDadSet := AllTrim(Posicione("SB1",1,xFilial("SB1")+cDadGet,"B1_DESC"))
  EndIf
  If cOpcGet == "CliL"
    cDadSet := AllTrim(Posicione("SA1",1,xFilial("SA1")+cDadGet,"A1_NOME"))
  EndIf
  
  oGet:SetText( cDadSet )

Return cDadSet                         

*Funcao***************************************************************************************************************************************                      

