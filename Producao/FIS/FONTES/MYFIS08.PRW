#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*/{Protheus.doc} MYFIS08

Rotina de Amarração Compra de FRETE como a Venda Produto 

@type function
@author Leonardo Bergamasco
@since 27/02/2019
@version P12
@database MSSQL

@history 28/07/2022, Júlio César Dias de Oliveira - FSW - Seven Consultoria RP, Tratamento verificar se variável oxml é objeto, evitando errorlog na função nvlFRT()
	
@see SIGAFIS.XNU
/*/

User Function MYFIS08() 
	Local nOpc      := 0
	Local lLoop     := .T.
	Private aDados  := {}
	Private Oqry    := NVLxFUN():New(.f.)
	Private cQuery  := ""

	While lLoop  
		nOpc := Aviso("","Rotina responsavel por vincular o compra de Frete sobre as notas fiscais de saida (ultima atulizacao "+GetMv("ZZ_FIS08B")+")",{"Vincular","Relatorio","Inconistencia","Cancelar"},3,"Novel")
		If nOpc > 0 .and. nOpc < 2
			aDados  := {}
			MsAguarde( {|| nvlFRT() },"Aguarde... ","Selecionando dados... (MYFIS08)")
			MsAguarde( {|| nvlSF2() },"Aguarde... ","Localizando vinculo... (MYFIS08)")
			MsAguarde( {|| nvlCLC() },"Aguarde... ","Calculando rateio... (MYFIS08)")
			MsAguarde( {|| nvlZFV() },"Aguarde... ","Gravando vinculo... (MYFIS08)")
		ElseIf nOpc > 1 .and. nOpc < 3
			MsAguarde( {|| nvlRel() },"Aguarde... ","Emitindo relatorio... (MYFIS08)")
		ElseIf nOpc > 2 .and. nOpc < 4
			MsAguarde( {|| nvlLpz() },"Aguarde... ","Limpando inconsistencia... (MYFIS08)")
		Else
			lLoop := .F.
		EndIf
	EndDo

Return 

/*
	Selecionando dados
*/
Static Function nvlFRT()

  Local cESRef := GetMv("ZZ_FIS08A")
  Local dDTRef := CtoD(GetMv("ZZ_FIS08B"))
  Local nDiaAn := GetMv("ZZ_FIS08C")
  Local cTSRef := GetMv("ZZ_FIS08E")
  Local oXml   := Nil
  Local oDet   := Nil
  Local cTPCTE := ""
  Local nOrige := 0
	Local _nKf	:= 00
  Local cCodChaveXML  := ""
  
  //Seleciona as entradas e referencia no monitor
  cQuery := ""
  cQuery += "SELECT * FROM ("
  cQuery += "SELECT DISTINCT F1_CHVNFE, F1_TIPO, F1.R_E_C_N_O_ F1REC, ZNF_CODOBJ, ZNF.R_E_C_N_O_ ZNFREC, ACB_OBJETO, ACB.R_E_C_N_O_ ACBREC, D1_CUSTO, F1_DTDIGIT, F1_DOC "
  cQuery += "FROM SF1010 AS F1 "
  cQuery += "INNER JOIN SD1010 AS D1 ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND D1_TES IN ("+Oqry:CriaIn(cTSRef)+") AND D1.D_E_L_E_T_!='*' "
  cQuery += "LEFT JOIN ZNF010 AS ZNF ON ZNF_FILIAL=F1_FILIAL AND ZNF_DOC=F1_DOC AND ZNF_SERIE=F1_SERIE AND ZNF_FORNEC=F1_FORNECE AND ZNF_LOJA=F1_LOJA AND ZNF.D_E_L_E_T_!='*' "
  cQuery += "LEFT JOIN ACB010 AS ACB ON ACB_FILIAL=LEFT(F1_FILIAL,2) AND ACB_CODOBJ=ZNF_CODOBJ AND ACB.D_E_L_E_T_!='*' "
  cQuery += "WHERE F1_FILIAL='"+xFilial("SF1")+"' AND F1_ESPECIE IN ("+Oqry:CriaIn(cESRef)+") AND F1_ZZFTVDA='' AND F1_DTDIGIT>='"+DtoS(dDTRef-nDiaAn)+"' AND F1.D_E_L_E_T_!='*' "
  cQuery += ") CTE ORDER BY F1_DTDIGIT, F1_DOC"
  MsAguarde( {|| Oqry:TcQry("xZFV", cQuery,1,.f.) }, "selecionando FRETE")
  
  While ! EOF()
    aadd(aDados, {AllTrim(F1_CHVNFE),F1_TIPO,AllTrim(Str(F1REC)),ZNF_CODOBJ,AllTrim(Str(ZNFREC)),AllTrim(ACB_OBJETO),AllTrim(Str(ACBREC)),D1_CUSTO,0,{},"",""}) 
  xZFV->(dbSkip())
  EndDo
  xZFV->(dbCloseArea())

  //Leitura do XML para pegar dados Notas vinculada no FRETE
  For _nKf:=1 to Len(aDados)
    cCodChaveXML := aDados[_nKf,6]
    oXml := Nil
    If !Empty(cCodChaveXML)
      oXml := u_getObjXML(.F.,2,"\dirdoc\co01\shared\"+aDados[_nKf,6],.F.)

      If ValType(oXml) == "O" .and. oXml:_CTEPROC:_VERSAO:TEXT $ GetMv("ZZ_MYFIS08")
        cTPCTE := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT
      
        If cTPCTE == "0"
          //CT-e Normal
          If Valtype(XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE, "_INFCTENORM") ) <> 'U'
            If Valtype(XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM, "_INFDOC") ) <> 'U'
            If Valtype(XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC, "_INFNFE") ) <> 'U'
              oDet := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE
              nDet := IIF(ValType(oDet) <> "O", Len(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE), 1)   
              For xI:=1 to nDet
                If ValType(oDet) <> "O"  
                  aadd(aDados[_nKf,10], {oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[xI]:_CHAVE:TEXT,"",0,0,0,{}})
                Else
                  aadd(aDados[_nKf,10], {oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT,"",0,0,0,{}})
                EndIf
              Next    
            EndIf
            EndIf
          EndIf
        ElseIf cTPCTE == "1"
          //CT-e Complemento
          If Valtype(XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE, "_INFCTECOMP") ) <> 'U'
            If Valtype(XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP, "_CHCTE") ) <> 'U'
              aDados[_nKf,11] := AllTrim(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP:_CHCTE:TEXT)
              aDados[_nKf,12] := "O"
              //Localiza a saida pelo chave do CT-e Original
              nOrige := ascan(aDados, {|x| x[1] == aDados[_nKf,11]})
              If nOrige > 0
                //Pesquisa no array
                For jj:=1 to Len(aDados[nOrige,10])
                  aadd(aDados[_nKf,10], {aDados[nOrige,10][jj,1],"",0,0,0,{}})
                  aDados[_nKf,12] := ""
                Next
              Else
                //Pesquisa na tabela de controle
                cQuery := ""
                cQuery += "SELECT ZFV_CHVNFE "
                cQuery += "FROM SF1010 AS F1 "
                cQuery += "INNER JOIN ZFV010 AS ZFV ON ZFV_FILIAL=F1_FILIAL AND ZFV_SF1REC=F1.R_E_C_N_O_ "
                cQuery += "WHERE F1_FILIAL='"+xFilial("SE2")+"' AND F1_ESPECIE IN ("+Oqry:CriaIn(cESRef)+") AND F1_ZZFTVDA='' AND F1_DTDIGIT>='"+DtoS(dDTRef-nDiaAn)+"' AND F1_CHVNFE='"+aDados[_nKf,11]+"' AND F1.D_E_L_E_T_!='*' "
                MsAguarde( {|| Oqry:TcQry("xZFV", cQuery,1,.f.) }, "selecionando FRETE")
                While ! EOF()
                  aadd(aDados[_nKf,10], {AllTrim(ZFV_CHVNFE),"",0,0,0,{}})
                  aDados[_nKf,12] := ""
                xZFV->(dbSkip())
                EndDo
                xZFV->(dbCloseArea())        
              EndIf
            EndIf
          EndIf
        EndIf
      Else
        aDados[_nKf,12] := "F"
      EndIf
    Endif
  Next  
  
Return

/*
	Localizando vinculos
*/
Static Function nvlSF2()

  Local dDTRef := CtoD(GetMv("ZZ_FIS08B"))
  Local nDiaAn := GetMv("ZZ_FIS08D")

  //Localiza a nota fiscal de saida
  For _nKf:=1 to Len(aDados)
    For ki:=1 to Len(aDados[_nKf,10])
      cQuery := ""
      cQuery += "SELECT F2.R_E_C_N_O_ SF2REC, F2_VALBRUT, D2.R_E_C_N_O_ SD2REC, (D2_TOTAL+D2_VALIPI+D2_VALFRE+D2_DESPESA+D2_SEGURO-D2_DESC) D2_TOTAL "
      cQuery += "FROM SF2010 AS F2 "
      cQuery += "INNER JOIN SD2010 AS D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_EMISSAO=F2_EMISSAO AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2.D_E_L_E_T_!='*' "
      cQuery += "WHERE F2_FILIAL='"+xFilial("SF2")+"' AND F2_CHVNFE='"+aDados[_nKf,10][ki,1]+"' AND F2_EMISSAO>='"+DtoS(dDTRef-nDiaAn)+"' AND F2.D_E_L_E_T_!='*' "
      MsAguarde( {|| Oqry:TcQry("xZFV", cQuery,1,.f.) }, "selecionando FRETE")
  
      If ! EOF()
        aDados[_nKf,9] := aDados[_nKf,9] + F2_VALBRUT
        aDados[_nKf,10][ki,2] := AllTrim(Str(SF2REC))
        aDados[_nKf,10][ki,3] := F2_VALBRUT
        While ! EOF()
          aadd(aDados[_nKf,10][ki,6], {AllTrim(Str(SD2REC)),D2_TOTAL,0,0})
        xZFV->(dbSkip())
        EndDo
      EndIf  
      xZFV->(dbCloseArea())
    Next
  Next  

Return

/*
	Calculando rateio
*/
Static Function nvlCLC()

  //Efetua o Calculos e gravações
  For _nKf:=1 to Len(aDados)
    For ki:=1 to Len(aDados[_nKf,10])
      aDados[_nKf,10][ki,4] := Round(aDados[_nKf,10][ki,3] / aDados[_nKf,9],4)
      aDados[_nKf,10][ki,5] := Round(aDados[_nKf,8] * aDados[_nKf,10][ki,4],2)
      For ky:=1 to Len(aDados[_nKf,10][ki,6])
        aDados[_nKf,10][ki,6][ky,3] := Round(aDados[_nKf,10][ki,6][ky,2] / aDados[_nKf,10][ki,3],4)
        aDados[_nKf,10][ki,6][ky,4] := Round(aDados[_nKf,10][ki,5] * aDados[_nKf,10][ki,6][ky,3],4)
      Next
    Next    
  Next   

Return

/*
	Gravando vinculos
*/
Static Function nvlZFV()
  
  dbSelectArea("ZFV")
  For _nKf:=1 to Len(aDados)
    For ki:=1 to Len(aDados[_nKf,10])
      For ky:=1 to Len(aDados[_nKf,10][ki,6])
        RecLock("ZFV", .T.) 
          ZFV->ZFV_FILIAL := xFilial("ZFV")
          ZFV->ZFV_DTFLAG := date()
          ZFV->ZFV_SF1REC := aDados[_nKf,3]
          ZFV->ZFV_TPCTE  := aDados[_nKf,2]
          ZFV->ZFV_ZNFREC := aDados[_nKf,5]
          ZFV->ZFV_ACBREC := aDados[_nKf,7]
          ZFV->ZFV_CHVNFE := aDados[_nKf,10][ki,1]
          ZFV->ZFV_SF2REC := aDados[_nKf,10][ki,2]
          ZFV->ZFV_SD2REC := aDados[_nKf,10][ki,6][ky,1]
          ZFV->ZFV_OCORRE := "-"
          If ! Empty(aDados[_nKf,11])
            If ! aDados[_nKf,2]=='C'
              ZFV->ZFV_OCORRE := "T"
            EndIf
          EndIf
          ZFV->ZFV_VRFRET := aDados[_nKf,8]
          ZFV->ZFV_VRSAID := aDados[_nKf,10][ki,3]
          ZFV->ZFV_VRITEM := aDados[_nKf,10][ki,6][ky,2]
          ZFV->ZFV_RATNFE := aDados[_nKf,10][ki,5]
          ZFV->ZFV_RATITM := aDados[_nKf,10][ki,6][ky,4]
          ZFV->ZFV_CTEORG := aDados[_nKf,11]
        ZFV->(MsUnlock())
      Next
    Next
    If ! Empty(aDados[_nKf,12])
        RecLock("ZFV", .T.) 
          ZFV->ZFV_FILIAL := xFilial("ZFV")
          ZFV->ZFV_DTFLAG := date()
          ZFV->ZFV_SF1REC := aDados[_nKf,3]
          ZFV->ZFV_TPCTE  := aDados[_nKf,2]
          ZFV->ZFV_ZNFREC := aDados[_nKf,5]
          ZFV->ZFV_ACBREC := aDados[_nKf,7]
          ZFV->ZFV_VRFRET := aDados[_nKf,8]
          ZFV->ZFV_CTEORG := aDados[_nKf,11]
          ZFV->ZFV_OCORRE := aDados[_nKf,12]
        ZFV->(MsUnlock())
    EndIf
  TcSqlExec("UPDATE SF1010 SET F1_ZZFTVDA='X' WHERE R_E_C_N_O_="+aDados[_nKf,3] )

  Next
  
  PUTMV("ZZ_FIS08B",DtoC(date())) 
  
  APMsgInfo("Atualização realizada ("+GetMv("ZZ_FIS08B")+")")
  

Return  

/*
	Limpando inconsistencia
*/
Static Function nvlLpz()

  Local nOInc := 0
  Local aRecno:= {}

  MsAguarde( {|| aRecno := nvlInc() },"Aguarde... ","Verificando inconsistencia... (MYFIS08)")
  nOInc := Aviso("Limpar registro","Esse processo vai limpar as ocorrencia registrada sendo necessario executar novo vinculo",{"Sim","Nao"},3,"")
  If nOInc > 0 .and. nOInc < 2
    For nk:=1 to Len(aRecno)
      If nk < 2
        PUTMV("ZZ_FIS08B",DtoC(aRecno[nk,3]))
      EndIf
      TcSqlExec("UPDATE SF1010 SET F1_ZZFTVDA='' WHERE R_E_C_N_O_="+aRecno[nk,1] )  
      TcSqlExec("DELETE FROM ZFV010 WHERE R_E_C_N_O_="+aRecno[nk,2] )                 
    Next
  EndIf

Return  

/*
	Verificando inconsistencia
*/
Static Function nvlInc()

  Local aXLSInc := {}
  Local aCabecI := {}
  Local lPrt := .T.
  Local i:='=T("', f:='")'
  Local cOcorre := ""
  Local nOInc := 0
  Local aRecno := {}

  cQuery := ""
  cQuery += "SELECT ZFV_DTFLAG, ZFV_OCORRE, "
  cQuery += "       COALESCE(F1_DOC,'') F1_DOC, COALESCE(F1_EMISSAO,'') F1_EMISSAO, COALESCE(F1_DTDIGIT,'') F1_DTDIGIT, "
  cQuery += "       COALESCE(F2_DOC,'') F2_DOC, COALESCE(F2_EMISSAO,'') F2_EMISSAO, ZFV_SF1REC, ZFV010.R_E_C_N_O_ ZFVREC "
  cQuery += "FROM ZFV010 "
  cQuery += "LEFT JOIN SF1010 AS SF1 ON F1_FILIAL=ZFV_FILIAL AND SF1.R_E_C_N_O_=ZFV_SF1REC AND SF1.D_E_L_E_T_!='*' "
  cQuery += "LEFT JOIN SF2010 AS SF2 ON F2_FILIAL=ZFV_FILIAL AND SF2.R_E_C_N_O_=ZFV_SF2REC AND SF2.D_E_L_E_T_!='*' "
  cQuery += "WHERE ZFV_FILIAL='"+xFilial("ZFV")+"' AND ZFV_OCORRE!='-' "
  cQuery += "ORDER BY F1_DTDIGIT,ZFV_DTFLAG "
 
  MsAguarde( {|| Oqry:TcQry("xZFV", cQuery,1,.f.) }, "selecionando dados...")
  TCSetField("xZFV","ZFV_DTFLAG","D")
  TCSetField("xZFV","F2_EMISSAO","D")
  TCSetField("xZFV","F1_EMISSAO","D")
  TCSetField("xZFV","F1_DTDIGIT","D")
  
  While ! EOF()
    cOcorre := ""
    cOcorre := IIF(ZFV_OCORRE == "F","XML não localizado", cOcorre)
    cOcorre := IIF(ZFV_OCORRE == "T","Tipo CT-e lancado errado", cOcorre)
    cOcorre := IIF(ZFV_OCORRE == "O","CT-e Origem não localizado", cOcorre)
    aadd(aXLSInc, {ZFV_DTFLAG,cOcorre,i+F1_DOC+f,F1_EMISSAO,F1_DTDIGIT,i+F2_DOC+f,F2_EMISSAO})
    aadd(aRecno,  {ZFV_SF1REC,AllTrim(Str(ZFVREC)),F1_DTDIGIT})
  xZFV->(dbSkip())
  EndDo
  xZFV->(dbCloseArea())  

  aCabecI := {"Data Log","Ocorrencia","CT-e Entr","Emissao CT-e","Entrada CT-e","NF Saida","Dt.Emissao"}
  
  If ! Empty(aXLSInc)
    nOInc := Aviso("Inconsistencia","Foi encontrado inconsistencia, deseja listar?",{"Sim","Nao"},3,"")
    If nOInc > 0 .and. nOInc < 2
      While lPrt  
        DlgToExcel({ {"ARRAY", "Ocorrencias registrada", aCabecI, aXLSInc} })
        lPrt := IIF(Aviso("Envio para excel","Relatorio de inconsistencia enviado para excel, deseja efetuar novo envio?",{"Sim","Nao"},3,"Confirmação") == 1, .T., .F.)
      EndDo
    EndIf
  EndIf
  
Return aRecno

/*
	Emitindo relatório
*/
Static Function nvlRel()

  Local cLTRef := GetMv("ZZ_FIS08F")
  Local cCTRef := GetMv("ZZ_FIS08G")
  Local cPerg := "DTDEATE"
  Local aXLSDad := {}
  Local aCabec := {}
  Local lPrt := .T.
  Local i:='=T("', f:='")'

  If ! Pergunte( cPerg ,.T.)
    Return
  EndIf
  
  MsAguarde( {|| nvlInc() },"Aguarde... ","Verificando inconsistencia... (MYFIS08)")

  cQuery := ""  
  cQuery += "SELECT D2_DOC, D2_CF, D2_EMISSAO, F2_FRETE, F2_VALBRUT, F2_TIPO, F2_TPFRETE, D2_ITEM, D2_COD, D2_QUANT, (D2_TOTAL+D2_VALIPI+D2_VALFRE+D2_DESPESA+D2_SEGURO-D2_DESC) D2_TOTAL, "
  cQuery += "      COALESCE(F1_DOC,'') F1_DOC, COALESCE(D1_CF,'') D1_CF, COALESCE(F1_EMISSAO,'') F1_EMISSAO, COALESCE(F1_DTDIGIT,'') F1_DTDIGIT, "
  cQuery += "      COALESCE(ZFV_VRFRET,0) ZFV_VRFRET, COALESCE(ZFV_RATNFE,0) ZFV_RATNFE, COALESCE(ZFV_RATITM,0) ZFV_RATITM, COALESCE(ZFV_TPCTE,'') ZFV_TPCTE, F1_TPCTE, "
  cQuery += "      COALESCE(CT2_LOTE,'') CT2_LOTE, COALESCE(CT2_SBLOTE,'') CT2_SBLOTE, COALESCE(CT2_DOC,'') CT2_DOC, COALESCE(CT2_LINHA,'') CT2_LINHA, COALESCE(CT2_DEBITO,'') CT2_DEBITO, COALESCE(CT2_VALOR,0) CT2_VALOR "
  cQuery += "FROM SF2010 AS SF2 "
  cQuery += "INNER JOIN SD2010 AS SD2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_EMISSAO=F2_EMISSAO AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND SD2.D_E_L_E_T_!='*' "
  cQuery += "LEFT JOIN ZFV010 AS ZFV ON ZFV_FILIAL=D2_FILIAL AND ZFV_SD2REC=SD2.R_E_C_N_O_ AND ZFV.D_E_L_E_T_!='*' "
  cQuery += "LEFT JOIN SF1010 AS SF1 ON F1_FILIAL=ZFV_FILIAL AND SF1.R_E_C_N_O_=ZFV_SF1REC AND SF1.D_E_L_E_T_!='*' "
  cQuery += "LEFT JOIN SD1010 AS SD1 ON F1_FILIAL=D1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND SD1.D_E_L_E_T_!='*' "
  cQuery += "LEFT JOIN CT2010 AS CT2 ON CT2_FILIAL=F1_FILIAL AND CT2_LOTE IN ("+Oqry:CriaIn(cLTRef)+") AND CT2_DEBITO IN ("+Oqry:CriaIn(cCTRef)+") AND CT2_DATA=F1_DTDIGIT AND LEFT(CT2_KEY,24)=F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA AND CT2.D_E_L_E_T_!='*' "
  cQuery += "WHERE F2_FILIAL='"+xFilial("SF2")+"' AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND SF2.D_E_L_E_T_!='*' "
  cQuery += "ORDER BY F2_FILIAL, D2_EMISSAO, D2_DOC, D2_ITEM "
 
  MsAguarde( {|| Oqry:TcQry("xZFV", cQuery,1,.f.) }, "selecionando dados...")
  TCSetField("xZFV","D2_EMISSAO","D")
  TCSetField("xZFV","F1_EMISSAO","D")
  TCSetField("xZFV","F1_DTDIGIT","D")
  
  While ! EOF()
    aadd(aXLSDad, {i+D2_DOC+f,i+D2_CF+f,D2_EMISSAO,F2_FRETE,F2_VALBRUT,F2_TIPO,F2_TPFRETE,i+D2_ITEM+f,i+D2_COD+f,D2_QUANT,D2_TOTAL,i+F1_DOC+f,ZFV_TPCTE,F1_TPCTE,D1_CF,F1_EMISSAO,F1_DTDIGIT,ZFV_VRFRET,ZFV_RATNFE,ZFV_RATITM,i+CT2_LOTE+f,i+CT2_SBLOTE+f,i+CT2_DOC+f,i+CT2_LINHA+f,i+CT2_DEBITO+f,CT2_VALOR})
  xZFV->(dbSkip())
  EndDo
  xZFV->(dbCloseArea())  

  aCabec := {"NF Saida","CFOP Saida","Dt.Emissao","Vr.Frete NF","Vr.Nota Saida","Tipo Nota","Tipo Frete","Item","Cod.Produto","Quant.NF Saida","Vr.Total Item","CT-e Entr","Tipo","CT-e","CFOP CT-e","Emissao CT-e","Entrada CT-e","Vr.Liq.CT-e","Vr.Rateio NF","Vr.Rateio Item","Lote","Sublote","Documento","Linha","Conta","Vr.Contabil"}
  
  If ! Empty(aXLSDad)
    While lPrt  
      DlgToExcel({ {"ARRAY", "Relação Notas Fiscais x Compra Frete", aCabec, aXLSDad} })
      lPrt := IIF(Aviso("Envio para excel","Relatorio frete x saida enviado para excel, deseja efetuar novo envio?",{"Sim","Nao"},3,"Confirmação") == 1, .T., .F.)
    EndDo  
  EndIf
  
Return
