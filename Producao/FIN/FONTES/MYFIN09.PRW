#Include "protheus.ch"
#Include "topconn.ch"
#Include "totvs.ch"

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYFIN09.prw                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 01/11/2019                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina para ajuste de centavos nos impostos retidos no Contas a    |\
/|            Pagar - Tabela SE2                                                 |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */

User Function MYFIN09()

  Local nOpc := 0
  
  Local cPergE2a := "MYFIN09A"
  Local cPergE2b := "MYFIN09B"
  
  Local aDados := {}
  
  Local Oqry    := NVLxFUN():New(.f.)
  Local cQuery  := ""

  nOpc := Aviso("Ajuste arredondamento Imposto Retido","Esta rotina tem po finalidade efetuar ajuste de arredondamento par Nota Fiscal com imposto retido",{"Ajustar","Cancelar"},3,"Novel")
  
  If ! (nOpc <> 1)
    If Pergunte(cPergE2a, .T.)
      cQuery := "SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PIS, E2_COFINS, E2_CSLL, E2_IRRF, E2_ISS, E2_INSS "
      cQuery += "FROM SE2010 "
      cQuery += "WHERE E2_FILIAL='"+xFilial("SE2")+"' AND E2_NUM='"+AllTrim(MV_PAR01)+"' AND E2_PARCELA='"+AllTrim(MV_PAR02)+"' AND "
      cQuery += "E2_NATUREZ='"+AllTrim(MV_PAR03)+"' AND E2_FORNECE='"+AllTrim(MV_PAR04)+"' AND E2_LOJA='"+AllTrim(MV_PAR05)+"' "
      MsAguarde( {|| Oqry:TcQry("xSE2", cQuery,1,.f.) }, "selecionando TITULO")
      While ! EOF()
        aadd(aDados, {E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PIS, E2_COFINS, E2_CSLL, E2_IRRF, E2_ISS, E2_INSS})
      xSE2->(dbSkip())
      EndDo
      xSE2->(dbCloseArea())
      
      For ke:=1 to Len(aDados)
      Pergunte(cPergE2b, .F.)
      Eval({|| MV_PAR01:=aDados[ke,1],  MV_PAR02:=aDados[ke,2],  MV_PAR03:=aDados[ke,3], MV_PAR04:=aDados[ke,4],  MV_PAR05:=aDados[ke,5],  MV_PAR06:=aDados[ke,6] })
      If Pergunte(cPergE2b, .T.)
        Alert("leo")
      EndIf      
      Next
    EndIf
  EndIf

/*
E2_TITPAI
   000116510  NF A0005701                         |
prefixo+nota+parcela+tipo+fornec+loja
*/

Return
