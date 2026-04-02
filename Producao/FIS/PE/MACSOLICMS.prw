#include 'protheus.ch'
#include 'parmtype.ch'

User Function MACSOLICMS()

  Local cOperacao := ParamIxb[1] //Tipo de operação Entrada ou Saída
  Local nItem     := ParamIxb[2] //Item
  Local nBaseSol  := ParamIxb[3] //Base de retencao ICMS Solidario
  Local nAliqSol  := ParamIxb[4] //Alíquota Solidário
  Local nValsol   := ParamIxb[5] //Valor do ICMS Solidario

  Local aNewST := {}

  //Regra especifica para Venda para MG
  //cliente - estado

If nItem == 1
nBaseSol := 2744.18 //                                                               nao compilado 30/08/2019
nAliqSol := 18
nValsol := 324.58
EndIf
/*
If nItem == 2
nBaseSol := 36.69 //                                                               nao compilado 30/08/2019
nAliqSol := 17
nValsol := 4.31
EndIf
If nItem == 3
nBaseSol := 24.93 //                                                               nao compilado 30/08/2019
nAliqSol := 17
nValsol := 2.93
EndIf
If nItem == 4
nBaseSol := 21.57 //                                                               nao compilado 30/08/2019
nAliqSol := 17
nValsol := 2.54
EndIf
*/

Return {nBaseSol,nAliqSol,nValsol}