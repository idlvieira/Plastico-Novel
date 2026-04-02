#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYPCP02.prw                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 03/07/2019                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina para trava da abertura de OP para produto sem Estutura      |\
/|                                                                               |\
/| OBSERVACA: Rotina executada a partir do gatilho C2_PRODUTO seq. 001           |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYPCP02() 

  Local prod := AllTrim(M->C2_PRODUTO)
  Local ATIVO := GetMv("ZZ_MYPCP02")
  Local MO := GetMv("ZZ_TP_MOD")
  Local MP := GetMv("ZZ_TP_MPS")
  Local lMOD := .F.
  Local lMPS := .F.
  Local Oqry := NVLxFUN():New(.f.)
  Local cQuery := ""
  Local nOpc := 0           
  Local __aArea := GetArea()
  
  //Trava desativada
  If ! ATIVO
    Return .T.
  EndIf

  cQuery += "SELECT G1_COD, G1_COMP, G1_INI, G1_FIM, B1_TIPO "
  cQuery += "FROM SG1010 AS G1 "
  cQuery += "INNER JOIN SB1010 AS B1 ON B1_COD=G1_COMP AND B1.D_E_L_E_T_!='*' "
  cQuery += "WHERE G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD='"+prod+"' AND G1_INI<='"+DtoS(date())+"' AND G1_FIM>='"+DtoS(date())+"' AND G1.D_E_L_E_T_!='*' "
  cQuery += "ORDER BY G1_COD, G1_COMP "
  Oqry:TcQry("xSG1", cQuery,1,.f.)
    
  While ! EOF()
    lMOD := IIF(AllTrim(B1_TIPO) $ MO, .T., lMOD)
    lMPS := IIF(AllTrim(B1_TIPO) $ MP, .T., lMPS)
  xSG1->(dbSkip())
  EndDo
  xSG1->(dbCloseArea())

  If ! (lMOD .and. lMPS)                
    nOpc := Aviso("ESTRUTURA DE PRODUTO","O sistema identificou inconsistência na estrutura para este produto ("+prod+"), a Ordem de Producao não será aberta",{"Entendido"},1,"Controle interno Novel")
      Return .F.
  EndIf
  
  RestArea(__aArea)
  
Return .T.
