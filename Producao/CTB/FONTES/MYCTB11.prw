#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYCTB11.prw    | Autor : Leonardo Bergamasco   | Data : 22/06/2020 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina customizada Visão Gerencial (Cockpit - Novel)               |\
/|-------------------------------------------------------------------------------|\
/| Processo.: Consulta de calculo de dados                                       |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        


User Function MYCTB11()

  Private cAno  := "2020"
  Private cMes  := "04"
  Private IDRef := "RZ"
  
  Private Oqry   := NVLxFUN():New(.f.)
  Private cQuery := ""

  //fTela_GR()
  u_myctb12()
  
Return

*Funcao***************************************************************************************************************************************

Static Function fTela_GR()

  MsAguarde( {|| fNivel_1() },"Aguarde... ","Processando NIVEL 1 (MYCTB11)")
  MsAguarde( {|| fNivel_2() },"Aguarde... ","Processando NIVEL 2 (MYCTB11)")
  
Return

*Funcao***************************************************************************************************************************************

Static Function fNivel_1()

  cQuery := ""
  cQuery += "SELECT CQ0_FILIAL, CQ0_DATA, CTS_CODPLA, CTS_ORDEM, CTS_CONTAG, CTS_DESCCG, CTS_CTASUP, SUM(CQ0_DEBITO) CQ0_DEBITO, SUM(CQ0_CREDIT) CQ0_CREDIT " + linha
  cQuery += "FROM CTS010 AS CTS " + linha
  cQuery += "INNER JOIN CQ0010 AS CQ0 ON LEFT(CQ0_DATA,6)='"+cAno+cMes+"' AND CQ0_CONTA=CTS_CT1INI AND CQ0.D_E_L_E_T_!='*' " + linha 
  cQuery += "WHERE CTS_CODPLA='GR1' AND CTS_CLASSE='2' AND CTS.D_E_L_E_T_!='*' " + linha 
  cQuery += "GROUP BY CQ0_FILIAL, CQ0_DATA, CTS_ORDEM, CTS_CODPLA, CTS_CONTAG, CTS_DESCCG, CTS_CTASUP " + linha
  cQuery += "ORDER BY CQ0_FILIAL, CTS_ORDEM, CTS_CTASUP, CTS_CONTAG " + linha
 
  Oqry:TcQry("GR",cQuery,2,.f.)
  TcSetField("GR", "GR->DATA","D", 08, 00)
  
  While ! GR->(EOF())
  RecLock("ZGR", .T.) 
    ZGR->ZGR_FILIAL := GR->CQ0_FILIAL
    ZGR->ZGR_ANO    := cAno
    ZGR->ZGR_REF    := "RZ"
    ZGR->ZGR_VERSAO := "00"
    ZGR->ZGR_IDGR   := GR->CTS_CODPLA
    ZGR->ZGR_IDTAG  := GR->CTS_CONTAG
    ZGR->ZGR_M1     := IIF (cMes == "01", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M1)  
    ZGR->ZGR_M2     := IIF (cMes == "02", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M2) 
    ZGR->ZGR_M3     := IIF (cMes == "03", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M3)
    ZGR->ZGR_M4     := IIF (cMes == "04", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M4)
    ZGR->ZGR_M5     := IIF (cMes == "05", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M5)
    ZGR->ZGR_M6     := IIF (cMes == "06", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M6)
    ZGR->ZGR_M7     := IIF (cMes == "07", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M7)
    ZGR->ZGR_M8     := IIF (cMes == "08", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M8)
    ZGR->ZGR_M9     := IIF (cMes == "09", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) , ZGR->ZGR_M9)
    ZGR->ZGR_M10    := IIF (cMes == "10", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) ,ZGR->ZGR_M10)
    ZGR->ZGR_M11    := IIF (cMes == "11", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) ,ZGR->ZGR_M11)
    ZGR->ZGR_M12    := IIF (cMes == "12", (GR->CQ0_DEBITO - GR->CQ0_CREDIT) ,ZGR->ZGR_M12)
    ZGR->ZGR_TOTAL  := ZGR->ZGR_M1+ZGR->ZGR_M2+ZGR->ZGR_M3+ZGR->ZGR_M4+ZGR->ZGR_M5+ZGR->ZGR_M6+ZGR->ZGR_M7+ZGR->ZGR_M8+ZGR->ZGR_M9+ZGR->ZGR_M10+ZGR->ZGR_M11+ZGR->ZGR_M12 
  ZFV->(MsUnlock())
  GR->(dbSkip())  
  EndDo
  GR->(dbCloseArea())


Return 

*Funcao***************************************************************************************************************************************

Static Function fNivel_2()

  cQuery := ""
  cQuery += "SELECT ZGR_FILIAL,ZGR_ANO,ZGR_REF,ZGR_VERSAO,ZGR_IDGR,CVF_CTASUP, " + linha
  cQuery += "       SUM(ZGR_M1) ZGR_M1, SUM(ZGR_M2) ZGR_M2, SUM(ZGR_M3) ZGR_M3, SUM(ZGR_M4) ZGR_M4, SUM(ZGR_M5) ZGR_M5, SUM(ZGR_M6) ZGR_M6, " + linha
  cQuery += "	   SUM(ZGR_M7) ZGR_M7, SUM(ZGR_M8) ZGR_M8, SUM(ZGR_M9) ZGR_M9, SUM(ZGR_M10)ZGR_M10,SUM(ZGR_M11)ZGR_M11,SUM(ZGR_M12)ZGR_M12, SUM(ZGR_TOTAL) ZGR_TOTAL " + linha
  cQuery += "FROM ZGR010 ZGR " + linha
  cQuery += "INNER JOIN CVF010 AS CVF ON CVF_CODIGO=ZGR_IDGR AND CVF_CONTAG=ZGR_IDTAG AND CVF.D_E_L_E_T_!='*' " + linha 
  cQuery += "WHERE ZGR_ANO='2020' AND ZGR_REF='RZ' AND ZGR_VERSAO='00' AND ZGR_IDGR='GR1' AND ZGR.D_E_L_E_T_!='*' " + linha 
  cQuery += "GROUP BY ZGR_FILIAL,ZGR_ANO,ZGR_REF,ZGR_VERSAO,ZGR_IDGR,CVF_CTASUP " + linha
  cQuery += "ORDER BY ZGR_FILIAL,ZGR_ANO,ZGR_REF,ZGR_VERSAO,ZGR_IDGR,CVF_CTASUP " + linha
 
  Oqry:TcQry("GR",cQuery,2,.f.)
  TcSetField("GR", "GR->DATA","D", 08, 00)
  
  While ! GR->(EOF())
  RecLock("ZGR", .T.) 
    ZGR->ZGR_FILIAL := GR->ZGR_FILIAL
    ZGR->ZGR_ANO    := GR->ZGR_ANO
    ZGR->ZGR_REF    := GR->ZGR_REF
    ZGR->ZGR_VERSAO := GR->ZGR_VERSAO
    ZGR->ZGR_IDGR   := GR->ZGR_IDGR
    ZGR->ZGR_IDTAG  := GR->CVF_CTASUP
    ZGR->ZGR_M1     := IIF (cMes == "01", (GR->ZGR_M1) , ZGR->ZGR_M1)  
    ZGR->ZGR_M2     := IIF (cMes == "02", (GR->ZGR_M2) , ZGR->ZGR_M2) 
    ZGR->ZGR_M3     := IIF (cMes == "03", (GR->ZGR_M3) , ZGR->ZGR_M3)
    ZGR->ZGR_M4     := IIF (cMes == "04", (GR->ZGR_M4) , ZGR->ZGR_M4)
    ZGR->ZGR_M5     := IIF (cMes == "05", (GR->ZGR_M5) , ZGR->ZGR_M5)
    ZGR->ZGR_M6     := IIF (cMes == "06", (GR->ZGR_M6) , ZGR->ZGR_M6)
    ZGR->ZGR_M7     := IIF (cMes == "07", (GR->ZGR_M7) , ZGR->ZGR_M7)
    ZGR->ZGR_M8     := IIF (cMes == "08", (GR->ZGR_M8) , ZGR->ZGR_M8)
    ZGR->ZGR_M9     := IIF (cMes == "09", (GR->ZGR_M9) , ZGR->ZGR_M9)
    ZGR->ZGR_M10    := IIF (cMes == "10", (GR->ZGR_M10),ZGR->ZGR_M10)
    ZGR->ZGR_M11    := IIF (cMes == "11", (GR->ZGR_M11),ZGR->ZGR_M11)
    ZGR->ZGR_M12    := IIF (cMes == "12", (GR->ZGR_M12),ZGR->ZGR_M12)
    ZGR->ZGR_TOTAL  := GR->ZGR_TOTAL 
  ZFV->(MsUnlock())
  GR->(dbSkip())  
  EndDo
  GR->(dbCloseArea())

Return