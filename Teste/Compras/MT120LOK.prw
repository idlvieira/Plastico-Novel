#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120LOK  ºAutor  ³    º Data ³  1                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. para validação dos itens adicionados com tabela de     º±±
±±º          ³preços se os mesmos estão liberados.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120LOK()
 Local  lRet   := .T.            
 Local aArea  := GetArea()
 Local aAreaCTT := CTT->(GetArea())
 Local  nPosCC  :=  aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CC"})
 Local cCCusto := aCols[n][nPosCC]

 // Valida Centro de custo do Pedido
 If Empty(cCCusto)                  
  Alert('Campo Centro de Custo obrigatório!')
  lRet := .F.
 Else 
  CTT->(dbSetOrder(1))
  If CTT->(dbSeek(xFilial('CTT')+cCCusto))
   If CTT->CTT_BLOQ == '1'
    Alert('Centro de Custo Bloqueado!')  
    lRet := .F.
   EndIf
   If Empty(CTT->CTT_ZZAPRO)
    Alert('Centro de Custo sem aprovador!(CTT)')  
    lRet := .F.
   EndIf   
  Else
   Alert('Centro de Custo informado inválido!')
   lRet := .F.
  EndIf
 EndIf

 RestArea(aAreaCTT)
 RestArea(aArea)
Return lRet