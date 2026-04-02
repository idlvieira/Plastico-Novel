#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MTASF2.prw                 | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 17/12/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: PONTO DE ENTRADA: Geração de registros em SF2, logo apos a gravação|\
/|                                                                               |\ 
/|FONTES: MATA460.prx que chama o fonte MTASF2.prx                               |\ 
/|                                                                               |\ 
/|OBSERVACAO: USADO O P.E. PARA ALTERAR A CONDICAO DE PAGAMENTO QUANDO UTILIZADO |\ 
/|            CONDICAO POR FAIXA DE PERIODO, CODIGO INICIADO COM "F" REGRA CUSTO-|\ 
/|            MIZADA PARA ATENDER AS NECESSIDADES DE ALGUNS CLIENTES ESPECIFICO. |\ 
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MTASF2()

  Local _aArea  := GetArea()
  
  If Left(SF2->F2_COND,1) == "F"
      SF2->F2_COND := CPgto_NVL(SF2->F2_COND, SF2->F2_EMISSAO)
  EndIf

  RestArea(_aArea)
Return

*Funcao****************************************************************************************************************************************

Static Function CPgto_NVL(cdpg, emi)

  Local Oqry:=NVLxFUN():New(.f.)
  Local cQuery := ""
  Local cRetCPgto := ""
  Local cUltCPgto := ""
    
  cQuery += "SELECT EC_ZZDE, EC_ZZATE, EC_ZZCOND FROM "+RetSQLName("SEC")+" WHERE EC_CODIGO='"+cdpg+"' AND D_E_L_E_T_!='*' ORDER BY EC_ITEM "
  Oqry:TcQry("xSEC",cQuery,2,.f.)
  
  dbSelectArea("xSEC")
  While ! xSEC->(EOF())
    cUltCPgto := EC_ZZCOND
    If DAY(emi) >= Val(EC_ZZDE) .and. DAY(emi) <= Val(EC_ZZATE)
      cRetCPgto := EC_ZZCOND
    EndIf
  xSEC->(dbSkip())
  EndDo
  xSEC->(dbCloseArea())
  
  If Empty(cRetCPgto)
    Aviso("CONDICAO PAGAMENTO","A condicao de pagamento "+cdpg+" possui uma regra de faixa de periodo, e a data do faturamento esta fora desta regra. Sendo assim será utilizado a ultima condição registrada na regra. "+;
                               "Verifique com os departamentos envolvidos Comercial/Financeiro em caso de duvidas no procedimento.",{"CIENTE"},2,"ALERTA IMPORTANTE")
    cRetCPgto := cUltCPgto
  EndIf

Return cRetCPgto

