#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYFIS07.PRW                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 07/06/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Exporta os dados Entrada/Ordem Prod/Saida (SD1/SD3/SD2) apresentand|\
/|            partindo como logica produto entrada e periodo, assim monta-se uma |\
/|            logica de dados para definicao de rastreabilidade, pois nao usamos |\
/|            controle de Lote, na Entrada / OP / Saida.                         |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */
//

User Function MYFIS07()

  Local nOpc := 0 , lTela := .T.
  Private Oqry:=NVLxFUN():New(.f.)
  Private cQuery := ""
  Private aXLSDadE := {}
  Private aXLSDad1 := {}
  Private aXLSDad2 := {}
  Private aXLSDadS := {}
  Private aCompNew := {}
  Private aAcabNew := {}
  Private aFormat  := {}
  Private TI := '=T("' , TF := '")'

  While lTela
    nOpc := Aviso("Rastreabilidade por periodo","Rotina para auxilio de rastrabilidade de produção, tendo como base Materia Prima e Periodo",{"Rastro","Sair"},3,"Novel")
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
  Local cPerg := "MYFIS07A"

  If ! Pergunte( cPerg ,.T.)
    Return
  EndIf

  { aXLSDadE := {} , aXLSDad1 := {} , aCompNew := {} , aXLSDad2 := {} , aAcabNew := {} , aXLSDadS := {} }
  
  fEntradas(mv_par01,mv_par02,mv_par03)
  
  f1ProcOP(mv_par01,mv_par02,mv_par03)

  For kk:=1 to Len(aCompNew)
    f2ProcOP(aCompNew[kk],mv_par02,mv_par03)
  Next
  
  For kk:=1 to Len(aAcabNew)
    fSaidas(aAcabNew[kk],mv_par02,mv_par03)
  Next
  
  While lTelaD
    nOpcD := Aviso("Rastreabilidade por periodo","Levantamento de dados realizado. Proximos passo, (1) Exportar dados para excel; (2) Log Rastreabilidade NF Saida",{"Exportar","Log Rast","Sair"},3,"Resultados")
    If nOpcD > 0 .and. nOpcD < 2
      fXLSDados()
    ElseIf nOpcD > 1 .and. nOpcD < 3
      fLogDados()
    ElseIf nOpcD > 2 .and. nOpcD < 4
      lTelaD := .F.
    EndIf
  EndDo
  
Return

*Funcao*********************************************************************************************************************************************  

Static Function fEntradas(MP,DE,ATE)

  cQuery := ""
  cQuery += "SELECT D1_DOC, D1_DTDIGIT, D1_CF, D1_FORNECE, D1_LOJA, A2_CGC, A2_NOME, D1_COD, B1_DESC, SUM(D1_QUANT) D1_QUANT " + linha
  cQuery += "FROM "+RetSQLName("SD1")+" AS D1 " + linha
  cQuery += "INNER JOIN "+RetSQLName("SA2")+" AS A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=D1_FORNECE AND A2_LOJA=D1_LOJA AND A2.D_E_L_E_T_!='*' " + linha
  cQuery += "INNER JOIN "+RetSQLName("SB1")+" AS B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D1_COD AND B1.D_E_L_E_T_!='*' " + linha
  cQuery += "WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_COD='"+AllTrim(MP)+"' AND D1_DTDIGIT BETWEEN '"+DtoS(DE)+"' AND '"+DtoS(ATE)+"' AND D1_QUANT>0 AND D1.D_E_L_E_T_!='*'  " + linha
  cQuery += "GROUP BY D1_DOC, B1_DESC, D1_DTDIGIT, D1_CF, D1_FORNECE, D1_LOJA, A2_CGC, A2_NOME, D1_COD " + linha
  cQuery += "ORDER BY D1_DTDIGIT " + linha
  
  MsAguarde({|| Oqry:TcQry("xPTE", cQuery,1,.f.)}, "Carregando NF Entrada...")
  
  dbSelectArea("xPTE")
  dbGoTop()
  While ! xPTE->(EOF())
    aadd(aXLSDadE, {AllTrim(D1_DOC), StoD(D1_DTDIGIT), AllTrim(D1_CF), D1_FORNECE+"/"+D1_LOJA+" "+AllTrim(A2_NOME), AllTrim(D1_COD), AllTrim(B1_DESC), D1_QUANT})
  xPTE->(dbSkip())
  EndDo
  xPTE->(dbCloseArea())

Return

*Funcao*********************************************************************************************************************************************  

Static Function f1ProcOP(MP,DE,ATE)
  
  cQuery := ""
  cQuery += "SELECT ORG.D3_COD COMP1, B1A.B1_DESC DCOMP1, ORG.D3_CF CF1, SUM(ORG.D3_QUANT) QT_MP, ORG.D3_EMISSAO DT, ORG.D3_OP OP, DST.D3_COD COMP2, B1B.B1_DESC DCOMP2, DST.D3_CF CF2, SUM(DST.D3_QUANT) QT_PADR_MOIDO, B1A.B1_TIPO TPCOMP1, B1B.B1_TIPO TPCOMP2 " + linha
  cQuery += "FROM "+RetSQLName("SD3")+" AS ORG  " + linha
  cQuery += "INNER JOIN "+RetSQLName("SB1")+" AS B1A ON B1A.B1_FILIAL='"+xFilial("SB1")+"' AND B1A.B1_COD=ORG.D3_COD AND B1A.D_E_L_E_T_!='*' " + linha
  cQuery += "INNER JOIN "+RetSQLName("SD3")+" AS DST ON DST.D3_FILIAL='"+xFilial("SD3")+"' AND DST.D3_FILIAL=ORG.D3_FILIAL AND DST.D3_OP=ORG.D3_OP AND DST.D3_EMISSAO=ORG.D3_EMISSAO AND DST.D3_NUMSEQ=ORG.D3_NUMSEQ AND DST.D3_CF='PR0' AND DST.D_E_L_E_T_!='*' " + linha
  cQuery += "INNER JOIN "+RetSQLName("SB1")+" AS B1B ON B1B.B1_FILIAL='"+xFilial("SB1")+"' AND B1B.B1_COD=DST.D3_COD AND B1B.D_E_L_E_T_!='*' " + linha
  cQuery += "WHERE ORG.D3_FILIAL='"+xFilial("SD3")+"' AND ORG.D3_COD='"+AllTrim(MP)+"' AND ORG.D3_EMISSAO BETWEEN '"+DtoS(DE)+"' AND '"+DtoS(ATE)+"' AND ORG.D3_OP!='' AND ORG.D3_CF='RE1' AND ORG.D_E_L_E_T_!='*' " + linha
  cQuery += "GROUP BY ORG.D3_COD, B1A.B1_DESC, ORG.D3_CF, ORG.D3_EMISSAO, ORG.D3_OP, DST.D3_COD, B1B.B1_DESC, DST.D3_CF, B1A.B1_TIPO, B1B.B1_TIPO " + linha
  cQuery += "ORDER BY ORG.D3_EMISSAO, ORG.D3_OP " + linha

  MsAguarde({|| Oqry:TcQry("xPT1", cQuery,1,.f.)}, "Carregando 1o OP...")
  
  dbSelectArea("xPT1")
  dbGoTop()
  While ! xPT1->(EOF())
    If ! TPCOMP2 == "PA"
    aadd(aXLSDad1, {AllTrim(COMP1), TPCOMP1, AllTrim(DCOMP1), CF1, QT_MP, StoD(DT), Alltrim(OP), AllTrim(COMP2), TPCOMP2, Alltrim(DCOMP2), CF2, QT_PADR_MOIDO})
    If ascan(aCompNew, {|z| z==AllTrim(COMP2)}) < 1
      aadd(aCompNew, AllTrim(COMP2))
    EndIf
    Else
    aadd(aXLSDad2, {AllTrim(COMP1), TPCOMP1, AllTrim(DCOMP1), CF1, QT_MP, StoD(DT), Alltrim(OP), AllTrim(COMP2), TPCOMP2, Alltrim(DCOMP2), CF2, QT_PADR_MOIDO})
    If ascan(aAcabNew, {|z| z==AllTrim(COMP2)}) < 1
      aadd(aAcabNew, AllTrim(COMP2))
    EndIf
    EndIf
  dbSkip()  
  EndDo
  xPT1->(dbCloseArea())
  
Return

*Funcao*********************************************************************************************************************************************  

Static Function f2ProcOP(MP,DE,ATE)

  cQuery := ""
  cQuery += "SELECT ORG.D3_COD COMP, B1A.B1_DESC DCOMP, ORG.D3_CF CF, SUM(ORG.D3_QUANT) QT_PADR_MOIDO, ORG.D3_EMISSAO DT, ORG.D3_OP OP, DST.D3_COD PA, B1B.B1_DESC DPA, DST.D3_CF CFPA, SUM(DST.D3_QUANT) QT_PA, B1A.B1_TIPO TPCOMP1, B1B.B1_TIPO TPPA " + linha
  cQuery += "FROM "+RetSQLName("SD3")+" AS ORG  " + linha
  cQuery += "INNER JOIN "+RetSQLName("SB1")+" AS B1A ON B1A.B1_FILIAL='"+xFilial("SB1")+"' AND B1A.B1_COD=ORG.D3_COD AND B1A.D_E_L_E_T_!='*' " + linha
  cQuery += "INNER JOIN "+RetSQLName("SD3")+" AS DST ON DST.D3_FILIAL='"+xFilial("SD3")+"' AND DST.D3_FILIAL=ORG.D3_FILIAL AND DST.D3_OP=ORG.D3_OP AND DST.D3_EMISSAO=ORG.D3_EMISSAO AND DST.D3_NUMSEQ=ORG.D3_NUMSEQ AND DST.D3_CF='PR0' AND DST.D_E_L_E_T_!='*' " + linha
  cQuery += "INNER JOIN "+RetSQLName("SB1")+" AS B1B ON B1B.B1_FILIAL='"+xFilial("SB1")+"' AND B1B.B1_COD=DST.D3_COD AND B1B.D_E_L_E_T_!='*' " + linha
  cQuery += "WHERE ORG.D3_FILIAL='"+xFilial("SD3")+"' AND ORG.D3_COD='"+AllTrim(MP)+"' AND ORG.D3_EMISSAO BETWEEN '"+DtoS(DE)+"' AND '"+DtoS(ATE)+"' AND ORG.D3_OP!='' AND ORG.D3_CF='RE1' AND ORG.D_E_L_E_T_!='*' " + linha
  cQuery += "GROUP BY ORG.D3_COD, B1A.B1_DESC, ORG.D3_CF, ORG.D3_EMISSAO, ORG.D3_OP, DST.D3_COD, B1B.B1_DESC, DST.D3_CF, B1A.B1_TIPO, B1B.B1_TIPO " + linha
  cQuery += "ORDER BY ORG.D3_EMISSAO " + linha

  MsAguarde({|| Oqry:TcQry("xPT2", cQuery,1,.f.)}, "Carregando 2o OP...")
  
  dbSelectArea("xPT2")
  dbGoTop()
  While ! xPT2->(EOF())
    aadd(aXLSDad2, {AllTrim(COMP), TPCOMP1, Alltrim(DCOMP), CF, QT_PADR_MOIDO, StoD(DT), AllTrim(OP), AllTrim(PA), TPPA, AllTrim(DPA), CFPA, QT_PA})
    If ascan(aAcabNew, {|z| z==AllTrim(PA)}) < 1
      aadd(aAcabNew, AllTrim(PA))
    EndIf
  dbSkip()  
  EndDo
  xPT2->(dbCloseArea())
  
Return

*Funcao*********************************************************************************************************************************************  

Static Function fSaidas(MP,DE,ATE)

  cQuery := ""
  cQuery += "SELECT D2_DOC, D2_EMISSAO, D2_CF, D2_CLIENTE, D2_LOJA, A1_CGC, A1_NOME, D2_COD, B1_DESC, SUM(D2_QUANT) D2_QUANT " + linha
  cQuery += "FROM "+RetSQLName("SD2")+" AS D2 " + linha
  cQuery += "INNER JOIN "+RetSQLName("SA1")+" AS A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A1.D_E_L_E_T_!='*' " + linha
  cQuery += "INNER JOIN "+RetSQLName("SB1")+" AS B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_!='*' " + linha
  cQuery += "WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2_EMISSAO BETWEEN '"+DtoS(DE)+"' AND '"+DtoS(ATE)+"' AND D2_COD='"+AllTrim(MP)+"' AND D2_QUANT>0 AND D2.D_E_L_E_T_!='*'  " + linha
  cQuery += "GROUP BY D2_DOC, D2_EMISSAO, D2_CF, D2_CLIENTE, D2_LOJA, A1_CGC, A1_NOME, D2_COD, B1_DESC " + linha
  cQuery += "ORDER BY D2_EMISSAO " + linha
  
  MsAguarde({|| Oqry:TcQry("xPTS", cQuery,1,.f.)}, "Carregando NF Saida...")
  
  dbSelectArea("xPTS")
  dbGoTop()
  While ! xPTS->(EOF())
    aadd(aXLSDadS, {AllTrim(D2_DOC), StoD(D2_EMISSAO), D2_CF, D2_CLIENTE+"/"+D2_LOJA+" "+AllTrim(A1_NOME), AllTrim(D2_COD), AllTrim(B1_DESC), D2_QUANT})
  xPTS->(dbSkip())
  EndDo
  xPTS->(dbCloseArea())

Return

*Funcao*********************************************************************************************************************************************  

Static Function fXLSDados()

  Local cTitulo := ""
  Local aCabec  := {}
  Local aXLSDad := {}

  cTitulo := "Nota Fiscal de Entrada"    
  aCabec  := {"Nota Fiscal","Dt.Entrada","CFOP","Fornecedor","Produto","Descição Produto","Quantidade"}
  aXLSDad := {}
  For kd:=1 to Len(aXLSDadE)
    aadd(aXLSDad, {TI+aXLSDadE[kd,1]+TF, aXLSDadE[kd,2], TI+aXLSDadE[kd,3]+TF, aXLSDadE[kd,4], TI+aXLSDadE[kd,5]+TF, aXLSDadE[kd,6], aXLSDadE[kd,7] })
  Next
  DlgToExcel({ {"ARRAY", cTitulo, aCabec, aXLSDad} })
  
  cTitulo := "Ordem de Producao MP"
  aCabec  := {"Produto","Tipo","Descrição Produto","Proc","Qtde requisitada","Emissão","Ordem producao","Produto","Tipo","Descição Produto","Proc","Qtde Produzida"}
  aXLSDad := {}
  For kd:=1 to Len(aXLSDad1)
    aadd(aXLSDad, {TI+aXLSDad1[kd,1]+TF, aXLSDad1[kd,2], aXLSDad1[kd,3], aXLSDad1[kd,4], aXLSDad1[kd,5], aXLSDad1[kd,6], TI+aXLSDad1[kd,7]+TF, TI+aXLSDad1[kd,8]+TF, aXLSDad1[kd,9], aXLSDad1[kd,10], aXLSDad1[kd,12], aXLSDad1[kd,12] })
  Next
  DlgToExcel({ {"ARRAY", cTitulo, aCabec, aXLSDad} })
  
  cTitulo := "Ordem de Producao PA"    
  aCabec  := {"Produto","Tipo","Descrição Produto","Proc","Qtde requisitada","Emissão","Ordem producao","Produto","Tipo","Descição Produto","Proc","Qtde Produzida"}
  aXLSDad := {}
  For kd:=1 to Len(aXLSDad2)
    aadd(aXLSDad, {TI+aXLSDad2[kd,1]+TF, aXLSDad2[kd,2], aXLSDad2[kd,3], aXLSDad2[kd,4], aXLSDad2[kd,5], aXLSDad2[kd,6], TI+aXLSDad2[kd,7]+TF, TI+aXLSDad2[kd,8]+TF, aXLSDad2[kd,9], aXLSDad2[kd,10], aXLSDad2[kd,11], aXLSDad2[kd,12] })
  Next
  DlgToExcel({ {"ARRAY", cTitulo, aCabec, aXLSDad} })
  
  cTitulo := "Nota Fiscal de Saida"
  aCabec  := {"Nota Fiscal","Dt.Emissão","CFOP","Cliente","Produto","Descrição Produto","Qtde Saida"}
  aXLSDad := {}
  For kd:=1 to Len(aXLSDadS)
    aadd(aXLSDad, {TI+aXLSDadS[kd,1]+TF, aXLSDadS[kd,2], TI+aXLSDadS[kd,3]+TF, aXLSDadS[kd,4], TI+aXLSDadS[kd,5]+TF, aXLSDadS[kd,6], aXLSDadS[kd,7] })
  Next
  DlgToExcel({ {"ARRAY", cTitulo, aCabec, aXLSDad} })

Return

*Funcao*********************************************************************************************************************************************  

Static Function fLogDados()

  Local nPos := 0, aPos := {}, aPar := {}
  
  // Declaração de variáveis:
  Local cAlias, cArq, cPerg, cTTela, cDescr1, cDescr2, cDescr3           //SetPrint
  Local cTRelat, cCabec1, cCabec2, cPrograma, cTamanho                   //Cabec 
    
  Private aReturn := {"A4", 1, "Administracao", 1, 2, 1, "",1 }          //SetDefault
  Private wrel, m_pag := 1, nLin := 80, lSub := .F.                      //Auxiliar Print 


  //Informando as Configuração Default da impressão
  cAlias  := ""
  cArq    := "MYFIS07"
  cPerg   := "MYFIS07B"
  cTTela  := "Log rastreabilidade de produção"
  cDescr1 := ""
  cDescr2 := "Imprime log de rastreabilidade de"
  cDescr3 := "producao por periodo/produto/NF"

  If ! Pergunte( cPerg ,.T.)
    Return
  EndIf

  wrel := SetPrint(,cArq,cPerg,cTTela,cDescr1,cDescr2,cDescr3,.F.,,.F.,"G")
  
  If nLastKey == 27 //Se pressionar ESC
     Return
  EndIf            

  //** Seleciona os dados **\\
  nPos := ascan(aXLSDadS, {|n| AllTrim(n[1]) == AllTrim(mv_par01)})
  If nPos > 0
    aadd(aPos, {"NFS",nPos})
    aPar := StrTokArr(AllTrim(mv_par02)+";"+AllTrim(mv_par03), ",;" )
    For kk:=1 to Len(aPar)
      nPos := ascan(aXLSDad2, {|op| AllTrim(op[7])==aPar[kk]})
      If nPos > 0
        aadd(aPos, {"OP2",nPos})
      EndIf
    Next
    aPar := StrTokArr(AllTrim(mv_par04)+";"+AllTrim(mv_par05), ",;" )
    For kk:=1 to Len(aPar)
      nPos := ascan(aXLSDad1, {|op| AllTrim(op[7])==aPar[kk]})
      If nPos > 0
        aadd(aPos, {"OP1",nPos})
      EndIf
    Next
    aPar := StrTokArr(AllTrim(mv_par06)+";"+AllTrim(mv_par07), ",;" )
    For kk:=1 to Len(aPar)
      nPos := ascan(aXLSDadE, {|e| AllTrim(e[1])==aPar[kk]})
      If nPos > 0
        aadd(aPos, {"NFE",nPos})
      EndIf
    Next
  Else
    APMsgStop("NF Saida "+AllTrim(mv_par01)+", não localizada","MYFIS07")
    Return
  EndIf

  SetDefault(aReturn,)  //Carrega a Configuração

  //Cabeçalho do Relatorio
  cTRelat   := "Log rastreabilidade de produção"
  cCabec1   := ""
  cCabec2   := ""
  cPrograma := "MYFIS07"
  cTamanho  := "G"
   
  //** Impressao do Relatorio **\\
  nlin := 6
  Cabec(cTRelat,cCabec1,cCabec2,cPrograma,cTamanho)
  //**Imprime o Cabecalho personalizado do relatorio 
  @nlin,003 Psay "LOG DE RASTREABILIDADE DE PRODUÇÃO (Entradas X Ordens Produção x Saidas)"
  nlin++
  nlin++
  @nlin,003 Psay "Identificação da Nota Fiscal de Saida em analise"
  nlin++
  @nlin,003 Psay ".-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------."
  nlin++
  @nlin,003 Psay "| Nota Fiscal | Dt Emissao | CFOP | Cliente                                                      | Produto                                                            |  Quantidade |"
  nlin++
  For pp:=1 to Len(aPos)
    If aPos[pp,1] == "NFS"
      fFormat(aPos[pp,1], aXLSDadS[aPos[pp,2]])
      @nlin,003 Psay "|  "+aFormat[1]+"  | "+aFormat[2]+" | "+aFormat[3]+" | "+aFormat[4]+" | "+aFormat[5]+" | "+aFormat[6]+" |"
      nlin++
    EndIf
  Next
  @nlin,003 Psay ".-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------."
  nlin++
  nlin++
  nlin++
  @nlin,003 Psay "Identificação Ordem de Produção da Produto Acabado"
  nlin++
  @nlin,003 Psay ".-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------."
  nlin++
  @nlin,003 Psay "| Componente utilizado                                               |   Quantidade | Data Refer | Ordem producao | Produto                                                            |   Quantidade |"
  nlin++
  For pp:=1 to Len(aPos)
    If aPos[pp,1] == "OP2"
      fFormat(aPos[pp,1], aXLSDad2[aPos[pp,2]])
      @nlin,003 Psay "| "+aFormat[1]+" | "+aFormat[2]+" | "+aFormat[3]+" |   "+aFormat[4]+"  | "+aFormat[5]+" | "+aFormat[6]+" |"
      nlin++
    EndIf
  Next
  @nlin,003 Psay ".-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------."
  nlin++
  nlin++
  nlin++
  @nlin,003 Psay "Identificação Ordem de Produção da Materia Prima"
  nlin++
  @nlin,003 Psay ".-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------."
  nlin++
  @nlin,003 Psay "| Componente utilizado                                               |   Quantidade | Data Refer | Ordem producao | Produto                                                            |   Quantidade |"
  nlin++
  For pp:=1 to Len(aPos)
    If aPos[pp,1] == "OP1"
      fFormat(aPos[pp,1], aXLSDad1[aPos[pp,2]])
      @nlin,003 Psay "| "+aFormat[1]+" | "+aFormat[2]+" | "+aFormat[3]+" |   "+aFormat[4]+"  | "+aFormat[5]+" | "+aFormat[6]+" |"
      nlin++
    EndIf
  Next
  @nlin,003 Psay ".-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------."
  nlin++
  nlin++
  nlin++
  @nlin,003 Psay "Identificação da Nota Fiscal de Entrada"
  nlin++
  @nlin,003 Psay ".------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------."
  nlin++
  @nlin,003 Psay "| Nota Fiscal | Dt Entrada | CFOP | Fornecedor                                                   | Produto                                                            |   Quantidade |"
  nlin++
  For pp:=1 to Len(aPos)
    If aPos[pp,1] == "NFE"
      fFormat(aPos[pp,1], aXLSDadE[aPos[pp,2]])
      @nlin,003 Psay "|  "+aFormat[1]+"  | "+aFormat[2]+" | "+aFormat[3]+" | "+aFormat[4]+" | "+aFormat[5]+" | "+aFormat[6]+" |"
     nlin++
    EndIf
  Next
  @nlin,003 Psay ".------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------."
  nlin++
  nlin++
  nlin++
  @nlin,000 Psay  __PrtThinLine()

  //Finaliza  
  If aReturn[5] == 1  
    OurSpool( wrel )
  EndIf   

  MS_FLUSH()  

Return

*Funcao*********************************************************************************************************************************************  

Static Function fFormat(cRel, aDados)

  aFormat := {}
  If cRel == "NFS"
    aadd(aFormat, Right(space(9)+aDados[1],9))
    aadd(aFormat, Right(space(10)+DtoC(aDados[2]),10))
    aadd(aFormat, Right(space(4)+aDados[3],4))
    aadd(aFormat, Left(aDados[4]+space(60),60))
    aadd(aFormat, Left(aDados[5]+" "+aDados[6]+space(66),66))
    aadd(aFormat, Transform(aDados[7],"@E 999,999,999"))
  ElseIf cRel == "OP2"
    aadd(aFormat, Left(aDados[1]+" "+aDados[3]+space(66),66))
    aadd(aFormat, Transform(aDados[5],"@E 999,999.9999"))
    aadd(aFormat, Right(space(10)+DtoC(aDados[6]),10))
    aadd(aFormat, Right(space(11)+aDados[7],11))
    aadd(aFormat, Left(aDados[8]+" "+aDados[10]+space(66),66))
    aadd(aFormat, Transform(aDados[12],"@E 999,999.9999"))
  ElseIf cRel == "OP1"
    aadd(aFormat, Left(aDados[1]+" "+aDados[3]+space(66),66))
    aadd(aFormat, Transform(aDados[5],"@E 999,999.9999"))
    aadd(aFormat, Right(space(10)+DtoC(aDados[6]),10))
    aadd(aFormat, Right(space(11)+aDados[7],11))
    aadd(aFormat, Left(aDados[8]+" "+aDados[10]+space(66),66))
    aadd(aFormat, Transform(aDados[12],"@E 999,999.9999"))
  ElseIf cRel == "NFE"
    aadd(aFormat, Right(space(9)+aDados[1],9))
    aadd(aFormat, Right(space(10)+DtoC(aDados[2]),10))
    aadd(aFormat, Right(space(4)+aDados[3],4))
    aadd(aFormat, Left(aDados[4]+space(60),60))
    aadd(aFormat, Left(aDados[5]+" "+aDados[6]+space(66),66))
    aadd(aFormat, Transform(aDados[7],"@E 999,999.9999"))
  EndIf
    
Return

*Funcao*********************************************************************************************************************************************  

/*      10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       180       190       200       210
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

LOG DE RASTREABILIDADE DE PRODUÇÃO (Entradas X Ordens Produção x Saidas)

Identificação da Nota Fiscal de Saida em analise
.-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
| Nota Fiscal | Dt Emissao | CFOP | Cliente                                                      | Produto                                                            |  Quantidade |
|  999999999  | 99/99/9999 | XXXX | XXXXXX/XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX50 | XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX50 | 999.999.999 |
.-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

Identificação Ordem de Produção da Produto Acabado
.----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
| Componente utilizado                                               |   Quantidade | Data Refer | Ordem producao | Produto                                                            |  Quantidade |                 
| XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX50 | 999.999,9999 | 99/99/9999 |   99999999999  | XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX50 | 999.999.999 |
.----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

Identificação Ordem de Produção da Materia Prima
.----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
| Componente utilizado                                               |   Quantidade | Data Refer | Ordem producao | Produto                                                            |  Quantidade |                 
| XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX50 | 999.999,9999 | 99/99/9999 |   99999999999  | XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX50 | 999.999.999 |
.----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

Identificação da Nota Fiscal de Entrada
.------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ----------.
| Nota Fiscal | Dt Entrada | CFOP | Fornecedor                                                  | Produto                                                            |   Quantidade |                 
|  999999999  | 99/99/9999 | XXXX | XXXXXX/XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX50 | XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX50 | 999,999.9999 |
.-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

*/