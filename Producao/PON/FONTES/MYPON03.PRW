#Include "rwmake.ch"
#Include "protheus.ch"
#Include "TOTVS.CH"
#Include "topconn.ch"
#include "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"

#define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYPON03.prw                | Autor: Leonardo Bergamasco            |\
/|-------------------------------------------------------------------------------|\
/| Data     : 24/04/2020                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Workflow de hora extra                                             |\ 
/|-------------------------------------------------------------------------------|\
/| Logica: Workflow sera disparado todos os dias da semana as 16h.               |\
/|         Tem por base a tabela SPC e SPH  controle de horas extras, o campo PDI|\
/|         define se a hora esta autorizada ou não.                              |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                          
//
//

User Function MYPON03()

  Local lIsBlind := IsBlind() .or. Type("__LocalDriver") == "U"

  If ! lIsBlind
	fProcessa(.F.)
  Else
    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0201"
	fProcessa(.T.)
  	Reset Environment
  EndIf
	
Return Nil

*Funcao********************************************************************************************************************************

Static Function fProcessa(lWF)
  
  Private _cFile  := "\Workflow\NVLEMail\HEXTRA.csv"
  Private _idArq  := 0
  Private lWrt    := .T.
  Private Oqry    := NVLxFUN():New(.f.)
  Private cQuery  := ""
  
  Private cRefi   := DtoS(dDataBase-35)
  Private cReff   := DtoS(dDataBase-1)
  Private nDias   := 35

  Private aCabeca := {}
  Private aTitulo := {}
  Private aColuna := {} 
  Private aLinhas := {}
  Private aResumo := {}
  Private aTotal  := {}

  If lWF
    ConOut("                                       ")
    ConOut("----------- Iniciando o Job - HORA EXTRA -----------")
    ConOut("                                       ")
    ConOut(DtoC(Date()))
    ConOut(Time())
    ConOut("")
      fHEsql()   //** Efetua a consulta **\\
      fHEcsv()   //** Montagem dos dados **\\		
	  fHEemail() //** envio do e-mail **\\
    ConOut("                                       ")
    ConOut("----------- Finalizar o Job - HORA EXTRA -----------")
    ConOut("                                       ")
  Else
    If ! Upper(AllTrim(CUSERNAME)) $ Upper(AllTrim(U_MYCFG02("PON000002","001","P")))
      APMsgStop("Usuario sem permissao para essa operacao","MYPON03 - PON000002/001P")
      Return  
    EndIf
    MsAguarde( {|| fHEtela() },"Mapa Hora Extra","Filtrando... (MYPON03)") //** Consulta ponto**\\
  EndIf

Return

*Funcao********************************************************************************************************************************

Static Function fHEtela() 

  Local cPerg  := "MYPON03"
  
  //** Pergunta de Paramtro **\\  
  If ! Pergunte( cPerg ,.T.)
    Return
  EndIf
  
  If mv_par01 < 2
    If Empty(mv_par02) .or. Empty(mv_par03)
      Alert("Não foi preenchido as datas de/ate, operação cancelada.")
      Return
    Else
      cRefi   := DtoS(mv_par02) 
      cReff   := DtoS(mv_par03)
      nDias   := DateDiffDay(mv_par02, mv_par03)
    EndIf
  EndIf

  fHEsql()   //** Efetua a consulta **\\
  fHEcsv()   //** Montagem dos dados **\\		
  fHEemail() //** envio do e-mail **\\

Return

*Funcao********************************************************************************************************************************

Static Function fHEsql()

  Local aLoop := {"Horas extras APROVADAS" , "Horas extras NAO APROVADAS"}
  Local cID := ""
  
  aResumo := {}
  For lp:=1 to Len(aLoop)
    fHEarray(aLoop[lp])
    //Consulta
    cQuery := ""
    cQuery += "SELECT FILIAL, MAT, NOME, DESCRIC, DATA, SUM(QUANTC) QUANTC FROM ( " + linha 
    cQuery += " SELECT PC_FILIAL FILIAL, PC_MAT MAT, RA_NOME NOME, QB_DESCRIC DESCRIC, PC_PD PD, PC_DATA DATA, PC_QUANTC QUANTC " + linha 
    cQuery += " FROM SPC010 AS PC " + linha 
    cQuery += " INNER JOIN SRA010 AS RA ON RA_FILIAL=PC_FILIAL AND RA_MAT=PC_MAT AND RA.D_E_L_E_T_!='*' AND RA_HRSMES>0 " + linha 
    cQuery += " LEFT JOIN SQB010  AS QB ON QB_FILIAL='' AND QB_DEPTO=RA_DEPTO AND QB.D_E_L_E_T_!='*' " + linha 
    If lp < 2
      //** Seleciona as horas extras autorizadas **\\
      cQuery += " INNER JOIN SP4010 AS P4 ON P4_FILIAL=PC_FILIAL AND ((P4_CODAUT=PC_PD AND PC_PDI!='') OR P4_CODAUT=PC_PDI) AND P4_TIPO=PC_TIPOHE AND P4.D_E_L_E_T_!='*' " + linha
    Else
      //** Seleciona as horas extras NÃO autorizadas **\\
      cQuery += " INNER JOIN SP4010 AS P4 ON P4_FILIAL=PC_FILIAL AND (P4_CODNAUT=PC_PD OR P4_CODNAUT=PC_PDI OR PC_PDI='') AND P4_TIPO=PC_TIPOHE AND P4.D_E_L_E_T_!='*' " + linha
    EndIf
    cQuery += " WHERE PC_DATA between '"+cRefi+"' AND '"+cReff+"' AND PC.D_E_L_E_T_!='*' " + linha
    cQuery += "UNION ALL " + linha 
    cQuery += " SELECT PH_FILIAL FILIAL, PH_MAT MAT, RA_NOME  NOME, QB_DESCRIC DESCRIC, PH_PD PD, PH_DATA DATA, PH_QUANTC QUANTC " + linha 
    cQuery += " FROM SPH010 AS PH " + linha 
    cQuery += " INNER JOIN SRA010 AS RA ON RA_FILIAL=PH_FILIAL AND RA_MAT=PH_MAT AND RA.D_E_L_E_T_!='*' AND RA_HRSMES>0 " + linha 
    cQuery += " LEFT JOIN SQB010  AS QB ON QB_FILIAL='' AND QB_DEPTO=RA_DEPTO AND QB.D_E_L_E_T_!='*' " + linha 
    If lp < 2    
      //** Seleciona as horas extras autorizadas **\\
      cQuery += " INNER JOIN SP4010 AS P4 ON P4_FILIAL=PH_FILIAL AND ((P4_CODAUT=PH_PD AND PH_PDI!='') OR P4_CODAUT=PH_PDI) AND P4_TIPO=PH_TIPOHE AND P4.D_E_L_E_T_!='*' " + linha 
    Else
      //** Seleciona as horas extras NÃO autorizadas **\\
      cQuery += " INNER JOIN SP4010 AS P4 ON P4_FILIAL=PH_FILIAL AND (P4_CODNAUT=PH_PD OR P4_CODNAUT=PH_PDI OR PH_PDI='') AND P4_TIPO=PH_TIPOHE AND P4.D_E_L_E_T_!='*' " + linha
    EndIf
    cQuery += " WHERE PH_DATA between '"+cRefi+"' AND '"+cReff+"' AND PH.D_E_L_E_T_!='*' " + linha
    cQuery += ") HEXTRA " + linha 
    cQuery += "GROUP BY FILIAL, MAT, NOME, DESCRIC, DATA " + linha 
    cQuery += "ORDER BY FILIAL, NOME, DATA " + linha 
 
    Oqry:TcQry("EH",cQuery,2,.f.)
    TcSetField("EH", "EH->DATA","D", 08, 00)
  
    While ! EH->(EOF())
      If cID !=  EH->FILIAL+EH->MAT
        aadd(aResumo, aclone(aLinhas))
        nLinR := Len(aResumo)
        cID := EH->FILIAL+EH->MAT
        aResumo[nLinR,1] := EH->FILIAL
        aResumo[nLinR,2] := EH->MAT
        aResumo[nLinR,3] := EH->NOME
        aResumo[nLinR,4] := EH->DESCRIC
        aResumo[nLinR,5] := IIF(lp<2,"APROVADA","NAO APROVADA")
      EndIf
      nColR := ascan(aColuna, DtoC(EH->DATA))
      If nColR > 0
        aResumo[nLinR,nColR] :=  EH->QUANTC
        aTotal[nColR] :=  aTotal[nColR] + EH->QUANTC
      EndIf
      aResumo[nLinR,len(aLinhas)] := aResumo[nLinR,len(aLinhas)] + EH->QUANTC
      aTotal[len(aLinhas)] := aTotal[len(aLinhas)] + EH->QUANTC
    EH->(dbSkip())
    EndDo
    EH->(dbCloseArea())
    aadd(aResumo, aclone(aTotal))
  Next
    
Return

*Funcao********************************************************************************************************************************

Static Function fHEarray(cTitulo)

  Local dtAux := StoD(cRefi)
  aCabeca := {}
  aTitulo := {}
  aColuna := {}
  aSepara := {}
  aLinhas := {}
  aTotal  := {}
   
  Eval({|| aadd(aSepara, "") })
  Eval({|| aadd(aCabeca, "HORA EXTRA") , aadd(aCabeca, "") , aadd(aCabeca, "Listagem executada em: "+DtoC(date())) })
  Eval({|| aadd(aTitulo, "") , aadd(aTitulo, "") ,  aadd(aTitulo, cTitulo) , aadd(aCabeca, "") })
  Eval({|| aadd(aColuna, "Filial") , aadd(aColuna, "Matricula") , aadd(aColuna, "Colaborador") , aadd(aColuna, "Departamento") , aadd(aColuna, "Situação") })
  Eval({|| aadd(aLinhas, "")       , aadd(aLinhas, "")          , aadd(aLinhas, "")            , aadd(aLinhas, "")             , aadd(aLinhas, "") })
  Eval({|| aadd(aTotal, "Total")   , aadd(aTotal, "")           , aadd(aTotal, "")             , aadd(aTotal, "")              , aadd(aTotal, "") })
  For k:=1 to nDias
    aadd(aColuna, DtoC(dtAux))
    aadd(aLinhas, 0)
    aadd(aTotal, 0)
    dtAux := dtAux+1
  Next
  Eval({|| aadd(aColuna, "Total") , aadd(aLinhas, 0) ,aadd(aTotal, 0) })
  aadd(aResumo, aclone(aSepara))
  aadd(aResumo, aclone(aCabeca))
  aadd(aResumo, aclone(aSepara))
  aadd(aResumo, aclone(aTitulo))
  aadd(aResumo, aclone(aColuna))
   
Return

*Funcao********************************************************************************************************************************

Static Function fHEcsv()

  //Apresenta a tela para selecao do nome e caminho do diretorio 
  fErase(_cFile)
  If (_idArq := FCreate(_cFile)) == -1
    lWrt := .F.
  Else
    lWrt := .T.
    For ln:=1 to len(aResumo)
      cCSV := ""
      For cl:=1 to len(aResumo[ln])
        cCSV := cCSV + IIF(Empty(cCSv),"",";") + IIF(Valtype(aResumo[ln,cl])=="N", Transform(aResumo[ln,cl], "@E 999.99"), '=T("'+aResumo[ln,cl]+'")')
      Next
      FWrite(_idArq, cCSV)
      FWrite(_idArq, chr(13)+chr(10))
    Next
  EndIf

  If lWrt
    FClose(_idArq)  
  EndIf
  
Return

*Funcao********************************************************************************************************************************

Static Function fHEemail()

  Local cHTML,cServer,cAccount,cPassword,cAutentic,cEnvia,cEmail,lResulConn

  cHTML 	:= ""
  cServer	:= GetMv("MV_RELSERV")
  cAccount	:= GetMv("MV_RELACNT")
  cPassword	:= GetMv("MV_RELPSW")
  cAutentic	:= GetMv("MV_RELAUTH")
  cEnvia	:= GetMv("MV_RELACNT")
  cEmail	:= AllTrim(U_MYCFG02("PON000001","001","P"))
  cEmail	:= cEmail + ";" + AllTrim(U_MYCFG02("PON000001","002","P"))

  cHtml	+= "<html>"
  cHtml	+= "<body>"
  cHtml	+= "<b><i><span style='font-size:18.0pt;line-height:115%;color:red'>Workflow de acompanhamento de Hora Extra</span></i></b><br><br>"
  cHtml	+= "<span style='font-size:16.0pt;line-height:115%;color:black'>Relatorio executada em: "+DtoC(date())+"</span><br><br>"
  cHtml	+= "</body>"
  cHtml	+= "</html>"

  //Manda e e-mail
	U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cEmail + Chr( 59 ), 'Workflow RH - Hora Extra', cHtml, _cFile, /*_lMsg*/, /*_cLog*/ )

/*
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
  lResulConn := MailAuth(cAccount, cPassword)
  If lResulConn
    SEND MAIL FROM cAccount TO cEmail SUBJECT 'Workflow RH - Hora Extra' BODY cHtml ATTACHMENT _cFile
  EndIf
*/

Return
