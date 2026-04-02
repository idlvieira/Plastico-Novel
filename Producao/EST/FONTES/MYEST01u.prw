#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYEST01u.prw               | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 05/10/2020                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina de Ctrl de Custo - UPLOAD carga de dados                    |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYEST01u() 
 
  //** Variavies Geral **\\ 
  Private Oqry    := NVLxFUN():New(.f.)
  Private cQuery  := ""       
  
  fUPD_ZZ0()

Return

*Funcao***************************************************************************************************************************************

//Efetua a carga de dados do TXT para a tabela ZZ0
Static Function fUPD_ZZ0()

  Local nOPC := 0
  Local k:= 00
  Local aDados := {}

  nOPC := Aviso("** FILIAL: "+xFilial("ZZ0")+" **","Tarefa responsavel pela carga de dados da tabela de CUSTO PURO, CUSTO VENDA e MARGEM DE REFERENCIA por tipo de venda.",{"IMPORTAR","SAIR"},3,"*** ID.: "+DtoS(date())+" ***")
  If nOPC < 1 .or. nOPC > 1
    Return
  EndIf
  
  aDados := u_ImportCSV("TPVDA;PRODUTO;CUSTO")
  
  If Empty(aDados)
    Return
  EndIf

  For k:=2 to Len(aDados)
  TcSqlExec("DELETE FROM ZZ0010 where ZZ0_FILIAL='"+xFilial("ZZ0")+"' AND ZZ0_ID='"+DtoS(date())+"' AND ZZ0_TPVDA='"+aDados[k,1]+"' AND ZZ0_PROD='"+aDados[k,2]+"'")
  dbSelectArea("ZZ0")
    RecLock("ZZ0",.T.)
      ZZ0->ZZ0_FILIAL := xFilial("ZZ0")
      ZZ0->ZZ0_ID     := DtoS(date())
      ZZ0->ZZ0_TPVDA  := aDados[k,1]
      ZZ0->ZZ0_PROD   := aDados[k,2]
      ZZ0->ZZ0_CPURO  := IIF(aDados[k,1] $ "PURO#MRGR", Val(aDados[k,3]), 0)
      ZZ0->ZZ0_CVDA   := IIF(aDados[k,1] $ "PURO#MRGR", 0, Val(aDados[k,3]))
    MsUnLock()
  Next
  
  APMsgInfo("UPLOAD CONCLUIDO"+linha+linha+;
            "Filial.: "+xFilial("ZZ0")+linha+linha+;
            "ID.: "+DtoS(date())+linha+linha+;
            "Total de registros: "+AllTrim(STR(k-2)))  
  
 Return

*Funcao***************************************************************************************************************************************


*Funcao***************************************************************************************************************************************
