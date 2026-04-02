#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYCOM11.prw    | Autor : Leandro Ferreira      | Data : 05/11/2023 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Relatório de Lead Time de Compras		                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 05/11/2023  Leandro Ferreira          Jaqueline Chen  Criação do relatório   

User Function MYCOM11()


	LOCAL wnrel
	LOCAL Tamanho := "G"
	LOCAL cDesc1  := "Lead Time compras"	
	LOCAL cDesc2  := " "	
	LOCAL cDesc3  := " "	
	LOCAL cString := "SAL"
	Local aArea     := GetArea()
	PRIVATE aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administração"), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
	PRIVATE nomeprog:= "MYCOM11"
	PRIVATE cPerg   := "MYCOM11"
	PRIVATE aLinha  := { }
	PRIVATE Titulo  := OemToAnsi("Lead Time compras")	
	PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont
	
	//Pergunte("MYCOM11",.F.)
	wnrel := "MYCOM11"
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

	SetDefault(aReturn,cString)


	RptStatus({|lEnd| MYCOM11Excel()},titulo)
	RestArea(aArea)
	//MS_FLUSH()
Return NIL

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
???Fun??o   ? MYCOM09Excel? Autor ? Leandro Ferreira   ? Data ? 09/11/2022???
?????????????????????????????????????????????????????????????????????????????
???Descri??o ? Exportar Excel                                             ???
?????????????????????????????????????????????????????????????????????????????
??? Uso      ? MYCOM11                                                   ???
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function MYCOM11Excel()
	Local Oqry      := NVLxFUN():New(.f.) //, cQuery
	Local x 	    := 0
	Local aUsersAux := ""
	Local nPos		:= 0
	//-------------------------------//
	// Cria arquivo tempor?rio       //
	// para sex export. p/ Excel     //
	//-------------------------------//
	mat:={}
	//mat[x][1],mat[x][3],mat[x][2]
	//aadd( mat , {"MAXIMO_APROV_GRUPO"  	,  3 , 3 , 2 } )
	//(< cColumn >, < nAlign >, < nFormat >, < lTotal >)
	aadd( mat , {"FILIAL"  				,  1 , 1 , 0 } )
	aadd( mat , {"CC"  					,  1 , 1 , 0 } )
	aadd( mat , {"DESC_CC"  			,  1 , 1 , 0 } )	
	aadd( mat , {"NF"  					,  1 , 1 , 0 } )
	aadd( mat , {"SERIE"  				,  1 , 1 , 0 } )
	aadd( mat , {"PROD"  				,  1 , 1 , 0 } )
	aadd( mat , {"ITEM_NF"				,  1 , 1 , 0 } )
	aadd( mat , {"DESC_PED"				,  1 , 1 , 0 } )
	aadd( mat , {"TIPO"					,  1 , 1 , 0 } )
	aadd( mat , {"PEDIDO"  			 	,  1 , 1 , 0 } )
	aadd( mat , {"ITEMPC"				,  1 , 1 , 0 } )
	aadd( mat , {"SC" 					,  1 , 1 , 0 } )
	aadd( mat , {"ITEMSC"				,  1 , 1 , 0 } )
	aadd( mat , {"QUANT_PC" 			,  3 , 3 , 2 } )
	aadd( mat , {"QUJE_PC"  			,  3 , 3 , 2 } )
	aadd( mat , {"QUANT_NF"  			,  3 , 3 , 2 } )
	aadd( mat , {"DT_SC"  				,  1 , 1 , 0 } )
	aadd( mat , {"DT_PC"  				,  1 , 1 , 0 } )
	aadd( mat , {"DT_PREVISTA_PC"  		,  1 , 1 , 0 } )
	aadd( mat , {"EMISSAO_NF"  			,  1 , 1 , 0 } )
	aadd( mat , {"DIGITACAO_NF"  		,  1 , 1 , 0 } )
	aadd( mat , {"COMPRADOR"  			,  1 , 1 , 0 } )
	aadd( mat , {"USR_SC"  				,  1 , 1 , 0 } )
	aadd( mat , {"APRO_SC"  			,  1 , 1 , 0 } )
	aadd( mat , {"DT_PREVISTA_SC" 		,  1 , 1 , 0 } )
	aadd( mat , {"DT_APROV_SC" 			,  1 , 1 , 0 } )
	aadd( mat , {"FORNECEDOR" 			,  1 , 1 , 0 } )
	aadd( mat , {"LOJA" 				,  1 , 1 , 0 } )
	aadd( mat , {"NOME_FORNEDOR" 		,  1 , 1 , 0 } )
	aadd( mat , {"DT_APROV" 			,  1 , 1 , 0 } )
	aadd( mat , {"LEAD_NF_APROV"  		,  3 , 3 , 2 } )
	aadd( mat , {"LEAD_ENTRADA"  		,  3 , 3 , 2 } )
	aadd( mat , {"LEAD_GERAL"  			,  3 , 3 , 2 } )
					


	//dbcreate(cNomeArq,mat )
	If Select("TRB")>0
		("TRB")->(DbCloseArea())
	EndIf

	cQuery := " SELECT D1_FILIAL 'FILIAL',C7_CC 'CC',CTT_DESC01 'DESC_CC',D1_DOC 'NF',D1_SERIE 'SERIE',D1_COD 'PROD',D1_ITEM 'ITEM_NF',C7_DESCRI 'DESC_PED', " + linha
	cQuery += " CASE  " + linha
	cQuery += " 	WHEN C7_TIPO = '1' THEN 'PC'  " + linha	
	cQuery += " 	WHEN C7_TIPO = '2' THEN 'AE'  " + linha
	cQuery += " END 'TIPO'  " + linha
	cQuery += " ,D1_PEDIDO 'PEDIDO',D1_ITEMPC 'ITEMPC',COALESCE(C7_NUMSC,'') 'SC',C7_ITEMSC 'ITEMSC',C7_QUANT 'QUANT_PC',C7_QUJE 'QUJE_PC',D1_QUANT 'QUANT_NF',  " + linha
	cQuery += " COALESCE(C1_EMISSAO,C7_EMISSAO) 'DT_SC',C7_EMISSAO 'DT_PC',C7_DATPRF 'DT_PREVISTA_PC',D1_EMISSAO 'EMISSAO_NF',  " + linha
	cQuery += " D1_DTDIGIT 'DIGITACAO_NF',C7_USER 'COMPRADOR', COALESCE(C1_SOLICIT,'') 'USR_SC',COALESCE(C1_NOMAPRO,'') 'APRO_SC',  " + linha
	cQuery += " COALESCE(C1_DATPRF,C7_DATPRF) 'DT_PREVISTA_SC',COALESCE(C1_ZZDTAPR,'') 'DT_APROV_SC',  " + linha
	cQuery += " C7_FORNECE 'FORNECEDOR',C7_LOJA 'LOJA', A2_NREDUZ 'NOME_FORNEDOR',  " + linha
	cQuery += " (SELECT TOP 1 CR_DATALIB--,CR_USERLIB   " + linha
	cQuery += " 	FROM " + RetSqlName("SCR") + " (NOLOCK)   " + linha
	cQuery += " 	WHERE  " + linha
	cQuery += " 	CR_NUM = C7_NUM  " + linha
	cQuery += " 	AND " + RetSqlName("SCR") + ".D_E_L_E_T_ = ''  " + linha
	cQuery += " 	AND CR_FILIAL = C7_FILIAL  " + linha
	cQuery += " 	AND CR_USERLIB != ''  " + linha
	cQuery += " 	ORDER BY CR_NIVEL DESC) 'DT_APROV'  " + linha
	cQuery += " 	,DATEDIFF(DAY,(SELECT TOP 1 CR_DATALIB--,CR_USERLIB   " + linha
	cQuery += " 	FROM " + RetSqlName("SCR") + " (NOLOCK)   " + linha
	cQuery += " 	WHERE   " + linha 
	cQuery += " 	CR_NUM = C7_NUM   " + linha
	cQuery += " 	AND " + RetSqlName("SCR") + ".D_E_L_E_T_ = ''   " + linha
	cQuery += " 	AND CR_FILIAL = C7_FILIAL   " + linha
	cQuery += " 	AND CR_USERLIB != ''  " + linha
	cQuery += " 			ORDER BY CR_NIVEL DESC),D1_EMISSAO) 'LEAD_NF_APROV'  " + linha
	cQuery += " 		,DATEDIFF(DAY,D1_EMISSAO,D1_DTDIGIT) 'LEAD_ENTRADA'  " + linha
	cQuery += " 		,DATEDIFF(DAY,COALESCE(C1_EMISSAO,C7_EMISSAO),D1_DTDIGIT) 'LEAD_GERAL'  " + linha
	cQuery += " 		  " + linha
	cQuery += " 	FROM  " + RetSqlName("SD1")  + "  " + linha 
	cQuery += " 	INNER JOIN " + RetSqlName("SC7") + "  " + linha
	cQuery += " 	ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND C7_ITEM = D1_ITEMPC AND  " + RetSqlName("SC7") + ".D_E_L_E_T_ = '' " + linha
	cQuery += " 	LEFT JOIN  " + RetSqlName("SC1") + "  " + linha  
	cQuery += " 	ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND  " + RetSqlName("SC1") + ".D_E_L_E_T_ = '' " + linha  
	cQuery += " 	INNER JOIN " + RetSqlName("SA2") + "  " + linha
	cQuery += " 	ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND " + RetSqlName("SA2") + ".D_E_L_E_T_ = '' " + linha  
	cQuery += " 	INNER JOIN " + RetSqlName("CTT") + "  " + linha 
	cQuery += " 	ON CTT_FILIAL = C7_FILIAL AND CTT_CUSTO = C7_CC AND " + RetSqlName("CTT") + ".D_E_L_E_T_ = '' " + linha 
    cQuery += " 	WHERE " + linha 
	cQuery += " 	D1_FILIAL >=      " + mv_par01 + " " + linha 
	cQuery += " 	AND D1_FILIAL <=  " + mv_par02 + " " + linha 
	cQuery += " 	AND D1_EMISSAO >= " + DTOS(mv_par03) + " " + linha 
	cQuery += " 	AND D1_EMISSAO <= " + DTOS(mv_par04) + " " + linha 
    cQuery += " 	AND  " + RetSqlName("SD1")  + ".D_E_L_E_T_ = '' " + linha
	cQuery += " " + linha
	Oqry:TcQry("TRB", cQuery,1,.f.)
	
	TCSetField("TRB","DT_SC","D")
	TCSetField("TRB","DT_PC","D")
	TCSetField("TRB","DT_PREVISTA_PC","D")
	TCSetField("TRB","EMISSAO_NF","D")
	TCSetField("TRB","DIGITACAO_NF","D")
	TCSetField("TRB","DT_PREVISTA_SC","D")
	TCSetField("TRB","DT_APROV_SC","D")
	TCSetField("TRB","DT_APROV","D")

	Private oExcel := FWMSEXCEL():New()
	oExcel:AddworkSheet("Lead Time compras")
	oExcel:AddTable ("Lead Time compras","Lead Time compras")
	//monta as colunas do relatório de forma dimânica com base o aStru 
	for x:=1 to len(mat)
		                   //(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oExcel:AddColumn("Lead Time compras","Lead Time compras",mat[x][1],mat[x][3],mat[x][2])
	next x

	dbSelectArea("TRB")
	dbGoTop()
	//conta quantos registros tem na TempTable para iniciar o array multidimensional
	y:=1
	While !eof()		
		DbSkip()
		y++
	EndDo
	aRet := Array(y,len(mat))
	y:=1
	dbGoTop()
	//distribui os valores da temptable no array montando sua dimensão 
	While !eof()			
		For x:=1 to fcount()
			aRet[y][x] := ("TRB")->&(mat[x][1])
		Next      		
		DbSkip()
		y++
	Enddo

	//grava linha a linha no excel
	dbGoTop()
	for x := 1 to len(aRet)
		aRet[x][22] := UsrFullName(aRet[x][22])
		PswOrder(2) // Ordem de nome
		// Efetuo a pesquisa, definindo se pesquiso usuário ou grupo
		If PswSeek(AllTrim(aRet[x][23]),.T.)
			_aRetUser := PswRet(1)
   			aRet[x][23] :=  _aRetUser[1,4]
		EndIF	
		If PswSeek(AllTrim(aRet[x][24]),.T.)
			_aRetUser := PswRet(1)
    		aRet[x][24] := _aRetUser[1,4]
		EndIf

		oExcel:AddRow("Lead Time compras","Lead Time compras",aRet[x])
	next x

	oExcel:Activate()
	cPath := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	cNameFile := cPath + cValToChar(Randomize( 1, 1000 )) + "_MYCOM11.xml"

	oExcel:GetXMLFile(cNameFile)
	//ShellExecute( "Open",cNameFile, '', '', 1 )

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cNameFile)     //Abre uma planilha
	oExcel:SetVisible(.T.)                 //Visualiza a planilha
	oExcel:Destroy()
	If Select("TRB")>0
		("TRB")->(DbCloseArea())
	EndIf

Return .T.            
