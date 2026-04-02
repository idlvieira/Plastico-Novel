#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYATF02.PRW                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 12/06/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Exporta os dados Ativo Fixo para XLS, dados SN1, SN2 e SN3         |\
/|                                                                               |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */
//

User Function MYATF02()

  Local nOpc := 0 , lTela := .T.
  Private Oqry:=NVLxFUN():New(.f.)
  Private cQuery := ""
  Private aXLSDadB := {}
  Private aXLSDadI := {}
  Private TI := '=T("' , TF := '")'

  While lTela
    nOpc := Aviso("Dados do Ativo Fixo","Rotina para exportação de dados do Ativo Fixo",{"Avancar","Sair"},3,"Novel")
    If nOpc > 0 .and. nOpc < 2
      fExportarDados()
    ElseIf nOpc > 1 .and. nOpc < 3
      lTela := .F.
    EndIf
  EndDo

Return

*Funcao*********************************************************************************************************************************************  

Static Function fExportarDados()

  Local nOpcD := 0 , lTelaD := .T.
  Local cPerg := "MYATF02"

  If ! Pergunte( cPerg ,.T.)
    Return
  EndIf

  aXLSDadB := {}
  
  MsAguarde({|| fAtivo() }, "Selecionado dados Ativo...")
  MsAguarde({|| fHistCompl()  }, "Descr detalhada Ativo...")
  MsAguarde({|| fUnficacao()  }, "Unificando informação...")
   
  While lTelaD
    nOpcD := Aviso("Dados do Ativo Fixo","Os dados foram selecionados",{"Exportar","Sair"},3,"Resultados")
    If nOpcD > 0 .and. nOpcD < 2
      fXLSDados()
    ElseIf nOpcD > 1 .and. nOpcD < 3
      lTelaD := .F.
    EndIf
  EndDo
  
Return

*Funcao*********************************************************************************************************************************************  

Static Function fAtivo()

  Local histcompl := ""

  cQuery := ""
  cQuery += "SELECT N1_CBASE, N1_NFISCAL, N1_AQUISIC, N1_ITEM, N1_DESCRIC, N1_CHAPA, N1_QUANTD, N1_VLAQUIS, N1_BAIXA, N3_DINDEPR, N3_FIMDEPR, N3_TXDEPR1, N3_VRDMES1, N3_VRDACM1 " + linha
  cQuery += "FROM "+RetSQLName("SN1")+" AS N1 " + linha
  cQuery += "LEFT JOIN "+RetSQLName("SN3")+" AS N3 ON N3_FILIAL=N1_FILIAL AND N3_CBASE=N1_CBASE AND N3_ITEM=N1_ITEM AND N3_TPSALDO='1' AND N3.D_E_L_E_T_!='*' " + linha
  cQuery += "WHERE N1_FILIAL='"+xFilial("SD1")+"' AND N1_CBASE BETWEEN '"+AllTrim(mv_par01)+"' AND '"+AllTrim(mv_par02)+"' AND N1_ITEM BETWEEN '"+AllTrim(mv_par03)+"' AND '"+AllTrim(mv_par04)+"' AND N1.D_E_L_E_T_!='*' " + linha
  cQuery += "ORDER BY N1_CBASE " + linha
  
  Oqry:TcQry("xSN1", cQuery,1,.f.)
  While ! xSN1->(EOF())
    aadd(aXLSDadB, {ti+N1_CBASE+tf, ti+N1_NFISCAL+tf, StoD(N1_AQUISIC), ti+N1_ITEM+tf, N1_DESCRIC, ti+N1_CHAPA+tf, N1_QUANTD, N1_VLAQUIS, StoD(N1_BAIXA), StoD(N3_DINDEPR), StoD(N3_FIMDEPR), N3_TXDEPR1, N3_VRDMES1, N3_VRDACM1, histcompl})
  xSN1->(dbSkip())
  EndDo
  xSN1->(dbCloseArea())

Return

*Funcao*********************************************************************************************************************************************  

Static Function fHistCompl() //fHistCompl(cBase, Item)

  Local cbaseItem := ""  
  
  cQuery := ""
  cQuery += "SELECT N2_CBASE, N2_ITEM, N2_SEQUENC, N2_HISTOR " + linha
  cQuery += "FROM "+RetSQLName("SN2")+" AS D3 " + linha
  cQuery += "WHERE N2_FILIAL='"+xFilial("SD1")+"' AND N2_CBASE BETWEEN '"+AllTrim(mv_par01)+"' AND '"+AllTrim(mv_par02)+"' AND N2_ITEM BETWEEN '"+AllTrim(mv_par03)+"' AND '"+AllTrim(mv_par04)+"' AND D_E_L_E_T_!='*' " + linha
  cQuery += "ORDER BY N2_CBASE, N2_SEQUENC " + linha

  Oqry:TcQry("xSN2", cQuery,1,.f.)  
  While ! xSN2->(EOF())
    If ! cbaseItem == N2_CBASE+N2_ITEM
      aadd(aXLSDadI, {N2_CBASE, N2_ITEM, AllTrim(N2_HISTOR)})
      cbaseItem := N2_CBASE+N2_ITEM
    Else
      aXLSDadI[Len(aXLSDadI),3] := aXLSDadI[Len(aXLSDadI),3] + " " + AllTrim(N2_HISTOR) 
    EndIf
  xSN2->(dbSkip())
  EndDo
  xSN2->(dbCloseArea())
  
Return histcompl

*Funcao*********************************************************************************************************************************************

Static Function fUnficacao()

  Local nPos := 0
  Local ka:=0

  For ka:=1 to Len(aXLSDadI)
    nPos := ascan(aXLSDadB, {|xx| xx[1]==ti+aXLSDadI[ka,1]+tf .and. xx[4]==ti+aXLSDadI[ka,2]+tf})
    If nPos > 0
      aXLSDadB[nPos,15] := aXLSDadI[ka,3]           
    EndIf
  Next

Return

*Funcao*********************************************************************************************************************************************  

Static Function fXLSDados()

  Local cTitulo := ""
  Local aCabec  := {}

  cTitulo := "Ativo Fixo - Dados Ficha"

  aCabec  := {"Cod. Bem", "NF Entrada", "Dt.Aquisição", "Item Bem", "Descr. Resumida", "Num Plaqueta", "Quantidade", "Valor Bem", "Dt.Baixa", "Dt.Inic Deprec", "Dt.Fim Deprec", "Taxa Deprec", "Vr. Deprec Mes", "Vr. Deprec Acum","Historico Complementar"}
  DlgToExcel({ {"ARRAY", cTitulo, aCabec, aXLSDadB} })

Return

