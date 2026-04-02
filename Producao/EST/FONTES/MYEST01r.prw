#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYEST01r.prw               | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 05/10/2020                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina de Ctrl de Custo - Listagem Analise de Pedido x Ctrl Custo  |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYEST01r(cPrtRel) 
 
  //** Variavies Geral **\\ 
  Private Oqry    := NVLxFUN():New(.f.)
  Private cQuery  := ""       
  
  If cPrtRel == "PVDA"
    fRelPVDA()
  EndIf         

Return

*Funcao***************************************************************************************************************************************

//Relatorio de Listagem de pedido de venda x custos
Static Function fRelPVDA()

//  Local cPerg := "DTDEATE"
  Local aXLSDad := {}
  Local aCabec := {}
  Local lPrt := .T.
  Local i:='=T("', f:='")'
  
  Local cUlMes := DtoS(GetMV("MV_ULMES"))

  //If ! Pergunte( cPerg ,.T.)
  //  Return
  //EndIf
  
  cQuery := ""  
  cQuery += "SELECT C6_FILIAL, C6_NUM, C5_EMISSAO, C5_TABELA, C6_ZZDATEN, C6_CLI, C6_LOJA, A1_NOME, A1_EST, "
  cQuery += "       C5_TIPOCLI, C5_VEND1, COALESCE(A3_COMIS,0) A3_COMIS, LEFT(CASE WHEN LEFT(C5_VEND1,1)='R' THEN 'R' ELSE '' END + CASE WHEN C5_TIPOCLI IN ('F','L') THEN 'CONS' ELSE 'REVE' END,4) TPOPERACAO, " 
  cQuery += "       C6_ITEM, C6_PRODUTO, C6_CF, C6_QTDVEN, C6_QTDENT, (C6_QTDVEN-C6_QTDENT) C6_SALDO, C6_PRCVEN, "
  cQuery += "       COALESCE(DA1_PRCVEN,0) DA1_PRCVEN, COALESCE(SB9P.B9_CM1,0) B9_CM1P, COALESCE(SB9U.B9_CM1,0) B9_CM1U, " 
  cQuery += "       YPURO.ZZ0_TPVDA, YPURO.ZZ0_ID, COALESCE(YPURO.ZZ0_CPURO,0) ZZ0_CPURO, YVDA.ZZ0_TPVDA, YVDA.ZZ0_ID, COALESCE(YVDA.ZZ0_CVDA,0) ZZ0_CVDA, "
  cQuery += "       B1_DESC, B1_IPI "
  cQuery += "       FROM SC6010 AS SC6 " 
  cQuery += "       INNER JOIN SC5010 AS SC5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5_LOJACLI=C6_LOJA AND SC5.D_E_L_E_T_!='*' "
  cQuery += "       INNER JOIN SF4010 AS SF4 ON F4_CODIGO=C6_TES AND F4_DUPLIC='S' "
  cQuery += "       INNER JOIN SA1010 AS SA1 ON A1_COD=C6_CLI AND A1_LOJA=C6_LOJA AND SA1.D_E_L_E_T_!='*' "
  cQuery += "       INNER JOIN SB1010 AS SB1 ON B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_!='*' "
  cQuery += "       LEFT JOIN DA1010 AS DA1P ON DA1_FILIAL=C6_FILIAL AND DA1_CODTAB=C5_TABELA AND DA1_CODPRO=C6_PRODUTO AND DA1P.D_E_L_E_T_!='*' "
  cQuery += "       LEFT JOIN SB9010 AS SB9P ON SB9P.B9_FILIAL=C6_FILIAL AND SB9P.B9_COD=C6_PRODUTO AND LEFT(SB9P.B9_DATA,6)=LEFT(C5_EMISSAO,6) AND SB9P.B9_LOCAL=C6_LOCAL AND SB9P.D_E_L_E_T_!='*' "
  cQuery += "       LEFT JOIN SB9010 AS SB9U ON SB9U.B9_FILIAL=C6_FILIAL AND SB9U.B9_COD=C6_PRODUTO AND LEFT(SB9U.B9_DATA,6)=LEFT('"+cUlMes+"',6) AND SB9U.B9_LOCAL=C6_LOCAL AND SB9U.D_E_L_E_T_!='*' "
  cQuery += "       LEFT JOIN SA3010 AS SA3 ON A3_COD=C5_VEND1 AND SA3.D_E_L_E_T_!='*' "
  cQuery += "       OUTER APPLY (SELECT ZZ0_TPVDA, MAX(ZZ0_ID) ZZ0_ID, ZZ0_PROD FROM ZZ0010 WHERE ZZ0_FILIAL=C6_FILIAL AND ZZ0_TPVDA IN ('PURO') AND ZZ0_PROD=C6_PRODUTO AND ZZ0010.D_E_L_E_T_!='*' GROUP BY ZZ0_TPVDA, ZZ0_PROD) AS XPURO " 
  cQuery += "       LEFT JOIN ZZ0010 AS YPURO ON YPURO.ZZ0_FILIAL=C6_FILIAL AND YPURO.ZZ0_TPVDA=XPURO.ZZ0_TPVDA AND YPURO.ZZ0_PROD=XPURO.ZZ0_PROD AND YPURO.ZZ0_ID=XPURO.ZZ0_ID  AND YPURO.D_E_L_E_T_!='*' "
  cQuery += "       OUTER APPLY (SELECT ZZ0_TPVDA, MAX(ZZ0_ID) ZZ0_ID, ZZ0_PROD FROM ZZ0010 WHERE ZZ0_FILIAL=C6_FILIAL AND ZZ0_TPVDA IN (LEFT(CASE WHEN LEFT(C5_VEND1,1)='R' THEN 'R' ELSE '' END + CASE WHEN C5_TIPOCLI IN ('F','L') THEN 'CONS' ELSE 'REVE' END,4)) AND ZZ0_PROD=C6_PRODUTO AND ZZ0010.D_E_L_E_T_!='*' GROUP BY ZZ0_TPVDA, ZZ0_PROD) AS XVDA " 
  cQuery += "       LEFT JOIN ZZ0010 AS YVDA ON YVDA.ZZ0_FILIAL=C6_FILIAL AND YVDA.ZZ0_TPVDA=XVDA.ZZ0_TPVDA AND YVDA.ZZ0_PROD=XVDA.ZZ0_PROD AND YVDA.ZZ0_ID=XVDA.ZZ0_ID AND YVDA.D_E_L_E_T_!='*' "
  cQuery += "       WHERE C6_FILIAL='"+xFilial("SF2")+"' AND C6_QTDVEN-C6_QTDENT>0 AND C6_BLQ!='R' AND SC6.D_E_L_E_T_!='*' "

  cQuery += "       ORDER BY C6_NUM, C6_ITEM "
 
  MsAguarde( {|| Oqry:TcQry("xSQL", cQuery,1,.f.) }, "selecionando dados...")
  TCSetField("xSQL","C5_EMISSAO","D")
  TCSetField("xSQL","C6_ZZDATEN","D")
  
  While ! EOF()
    aadd(aXLSDad, {i+C6_FILIAL+f,i+C6_NUM+f,C5_EMISSAO,i+C5_TABELA+f,C6_ZZDATEN,i+C6_CLI+f,i+C6_LOJA+f,;
                   i+AllTrim(A1_NOME)+f,A1_EST,i+C5_TIPOCLI+f,i+C5_VEND1+f,A3_COMIS,fFatorImp(C5_TIPOCLI,A1_EST,B1_IPI),;
                   i+C6_ITEM+f,i+C6_PRODUTO+f,i+C6_CF+f,C6_QTDVEN,C6_QTDENT,C6_SALDO,C6_PRCVEN,;
                   DA1_PRCVEN,B9_CM1P,B9_CM1U,ZZ0_CPURO,i+TPOPERACAO+f,ZZ0_CVDA,i+AllTrim(B1_DESC)+f})
  xSQL->(dbSkip())
  EndDo
  xSQL->(dbCloseArea())  

  aCabec := {"Filial","Pedido","Dt.Emissao","Tab.Prc.PVda","Dt.Prev.Entr","CLiente","Loja",;
             "Nome","Estado","Tipo Vda","Cod.Vendedor","% Comissao","Fator Imposto",;
             "Item","Cod.Produto","CFOP","Qtde PVda","Qtde Entregue","Qtde a Entregar","Preço PVda",;
             "Preço Tab.PVda","C.Medio PVda","Ult.C.Medio","Ult.C.Puro","Tab.Custo","Ult.C.Vda","Desc.Produto"}
  
  If ! Empty(aXLSDad)
    While lPrt  
      DlgToExcel({ {"ARRAY", "Relação Pedidos de Venda x Ctrl de Custo", aCabec, aXLSDad} })
      lPrt := IIF(Aviso("Envio para excel","Relatorio enviado para excel, deseja efetuar novo envio?",{"Sim","Nao"},3,"Confirmação") == 1, .T., .F.)
    EndDo  
  EndIf

Return

*Funcao***************************************************************************************************************************************

//Efetua o calculo do fator de imposto
Static Function fFatorImp(cTpCli, cEstCli, nIPI)
  
  Local mvNorte := GetMV("MV_NORTE") 
  Local nAICMS  := IIF(cEstCli == SM0->M0_ESTENT, 18, IIF(cEstCli $ mvNorte, 7, 12))
  Local nAIPI   := IIF(cTpCli $ "F,L" ,nIPI,0)
  Local nAPIS   := GetMV("MV_TXPIS")
  Local nACOF   := GetMV("MV_TXCOFIN")
  Local nFator  := 0  

  nFator := ((100 - (nAICMS*(1+(nAIPI/100))) - nAPIS - nACOF)/100)
       
Return nFator

*Funcao***************************************************************************************************************************************

