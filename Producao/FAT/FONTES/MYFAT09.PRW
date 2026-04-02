#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYFAT09.prw    | Autor : Leandro Ferreira      | Data : 30/10/2020 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Relatório de Conferência de Entradas                               |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 30/10/2020  Leandro Ferreira          Tais Bueno      Criação do relatório   

User Function MYFAT09()


	LOCAL wnrel
	LOCAL Tamanho := "G"
	LOCAL cDesc1  := "Analise de clientes"	
	LOCAL cDesc2  := " "	
	LOCAL cDesc3  := " "	
	LOCAL cString := "SA1"
	Local aArea     := GetArea()
	PRIVATE aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administração"), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
	PRIVATE nomeprog:= "MYFAT09"
	PRIVATE aLinha  := { }
	//PRIVATE cPerg   := "MYFAT09"
	PRIVATE Titulo  := OemToAnsi("Analise de clientes")	
	PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont

/*	If !MsgYesNo("Deseja emitir o relatório de Analise de Clientes", "Confirma?")
		Return NIL
	EndIf*/
	
	pergunte("SNC076",.F.)
	wnrel := "MYFAT09"
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

	SetDefault(aReturn,cString)


	RptStatus({|lEnd| fat09Excel()},titulo)
	RestArea(aArea)
	//MS_FLUSH()
Return NIL

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
???Fun??o    ? ctb11Excel? Autor ? Leandro Ferreira   ? Data ? 18/03/2020 ???
?????????????????????????????????????????????????????????????????????????????
???Descri??o ? Exportar Excel                                             ???
?????????????????????????????????????????????????????????????????????????????
??? Uso      ? MYCTB11                                                    ???
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function fat09Excel()
	Local Oqry := NVLxFUN():New(.f.), cQuery

	//-------------------------------//
	// Cria arquivo tempor?rio       //
	// para sex export. p/ Excel     //
	//-------------------------------//
	mat:={}
	//mat[x][1],mat[x][3],mat[x][2]
	//(< cColumn >, < nAlign >, < nFormat >, < lTotal >)
	aadd( mat , {"COD"    				,  1 , 1 , 0 } )
	aadd( mat , {"LOJA"   				,  1 , 1 , 0 } )
	aadd( mat , {"NOME"   				,  1 , 1 , 0 } )
	aadd( mat , {"BLOQUEADO"			,  1 , 1 , 0 } )
	aadd( mat , {"DT_CADASTRO"			,  4 , 2 , 0 } )
	aadd( mat , {"VENC_LIMITE_CRED"   	,  4 , 2 , 0 } )
	aadd( mat , {"PRIMEIRO_FATURAMENTO"	,  4 , 2 , 0 } )
	aadd( mat , {"ULTIMO_FATURAMENTO"   ,  4 , 2 , 0 } )
	aadd( mat , {"PENULTIMO_FATURAMENTO",  4 , 2 , 0 } )
	aadd( mat , {"QDTE_FATURAMENTOS" 	,  1 , 2 , 0 } )
	aadd( mat , {"MAIOR_FATURAMENTO"   	,  3 , 3 , 2 } )
	aadd( mat , {"FIL_ULT_PEDIDO"		,  1 , 1 , 0 } )
	aadd( mat , {"DT_EMIS_ULT_PED_FAT"  ,  4 , 2 , 0 } )
	aadd( mat , {"NUM_ULT_PEDIDO_FAT"   ,  1 , 1 , 0 } )
	aadd( mat , {"VL_ULT_PEDIDO_FAT"    ,  3 , 3 , 2 } )
	aadd( mat , {"QUANT_PED_ABERTO" 	,  1 , 1 , 0 } )
	aadd( mat , {"SALDO_PED_ABERTO"     ,  3 , 3 , 2 } )

	//dbcreate(cNomeArq,mat )
	If Select("TRB")>0
		("TRB")->(DbCloseArea())
	EndIf
	cQuery := "SELECT DISTINCT   " + linha
	cQuery += "COD,LOJA,NOME,BLOQUEADO,CAST(DTCAD AS NVARCHAR(8)) 'DT_CADASTRO',CAST(VENCLC AS NVARCHAR(8)) 'VENC_LIMITE_CRED' " + linha
	cQuery += ",CAST(COALESCE(PRICOM,'') AS NVARCHAR(8)) 'PRIMEIRO_FATURAMENTO',CAST(ULTCOM AS NVARCHAR(8)) 'ULTIMO_FATURAMENTO', " + linha
	cQuery += "CAST(COALESCE(SUM(CASE WHEN PEN_FAT > 0 THEN PEN_FAT END) OVER (PARTITION BY COD+LOJA),'') AS NVARCHAR(8)) 'PENULTIMO_FATURAMENTO', " + linha
	cQuery += "COALESCE(SUM(NROCOM) OVER (PARTITION BY COD+LOJA),'') 'QDTE_FATURAMENTOS',COALESCE(SUM(MCOMPRA) OVER (PARTITION BY COD+LOJA),'') 'MAIOR_FATURAMENTO', " + linha
	cQuery += "COALESCE(SUM(FIL_PED) OVER (PARTITION BY COD+LOJA),'') 'FIL_ULT_PEDIDO',CAST(COALESCE(MAX(EMISSAO) OVER (PARTITION BY COD+LOJA),'') AS NVARCHAR(8)) 'DT_EMIS_ULT_PED_FAT', " + linha
	cQuery += "COALESCE(SUM(PED) OVER (PARTITION BY COD+LOJA),'') 'NUM_ULT_PEDIDO_FAT',COALESCE(SUM(VALOR_ULT_COMPRA) OVER (PARTITION BY COD+LOJA),'') 'VL_ULT_PEDIDO_FAT', " + linha
	cQuery += "COALESCE(SUM(PEDIDOS_EM_ABERTO) OVER (PARTITION BY COD+LOJA),'') 'QUANT_PED_ABERTO', " + linha
	cQuery += "COALESCE(SUM(SALDO_PEDIDOS) OVER (PARTITION BY COD+LOJA),'') 'SALDO_PED_ABERTO' " + linha
	cQuery += "FROM  " + linha
	cQuery += "( " + linha
	cQuery += "/**PEDIDOS EM ABERTO**/ " + linha
	cQuery += "/***************/ " + linha
	cQuery += "SELECT DISTINCT  " + linha
	cQuery += "CASE " + linha
	cQuery += "WHEN A1_MSBLQL = '1' THEN 'SIM' " + linha
	cQuery += "WHEN A1_MSBLQL = '2' THEN 'NÃO' " + linha
	cQuery += "END 'BLOQUEADO', " + linha
	cQuery += "A1_COD 'COD',A1_LOJA 'LOJA',A1_NOME 'NOME',A1_VENCLC 'VENCLC',A1_PRICOM 'PRICOM',A1_ULTCOM 'ULTCOM',0 'NROCOM',0 'MCOMPRA',0 'SALPED',A1_DTCAD 'DTCAD',0 'FIL_PED',0 'EMISSAO', " + linha
	cQuery += "0 'PED',0 'VALOR_ULT_COMPRA',COALESCE(SUM(C6_VALOR) OVER (PARTITION BY A1_COD+A1_LOJA),'') 'SALDO_PEDIDOS',0 'PEDIDOS_EM_ABERTO','' 'PEN_FAT' " + linha
	cQuery += "FROM " + RetSqlName("SA1") + " (nolock) " + linha
	cQuery += "INNER JOIN " + RetSqlName("SC5") + " (nolock) " + linha
	cQuery += "ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND " + RetSqlName("SC5") + ".D_E_L_E_T_  = '' AND " + linha
	cQuery += "C5_NOTA = '  ' AND C5_BLQ = '  '  " + linha
	cQuery += "INNER JOIN " + RetSqlName("SC6") + " (nolock) " + linha
	cQuery += "ON C6_FILIAL = C5_FILIAL AND C6_CLI = C5_CLIENTE AND C6_NUM = C5_NUM AND " + RetSqlName("SC6") + ".D_E_L_E_T_ = '' " + linha
	cQuery += "WHERE  " + linha
	cQuery += " " + RetSqlName("SA1") + ".D_E_L_E_T_  = ''  " + linha
	cQuery += "/***************/ " + linha
	cQuery += "UNION ALL  " + linha
	cQuery += "/****COUNT PC ABERTO******/ " + linha
	cQuery += "/***************/ " + linha
	cQuery += "SELECT DISTINCT  " + linha
	cQuery += "CASE " + linha
	cQuery += "WHEN A1_MSBLQL = '1' THEN 'SIM' " + linha
	cQuery += "WHEN A1_MSBLQL = '2' THEN 'NÃO' " + linha
	cQuery += "END 'BLOQUEADO', " + linha
	cQuery += "A1_COD 'COD',A1_LOJA 'LOJA',A1_NOME 'NOME',A1_VENCLC 'VENCLC',A1_PRICOM 'PRICOM',A1_ULTCOM 'ULTCOM',0 'NROCOM',0 'MCOMPRA',0 'SALPED',A1_DTCAD 'DTCAD', " + linha
	cQuery += "0 'FIL_PED',0 'EMISSAO',0 'PED',0 'VALOR_ULT_COMPRA',0 'SALDO_PEDIDOS',COALESCE(COUNT(C5_NUM) OVER (PARTITION BY C5_CLIENTE+C5_LOJACLI),'') 'PEDIDOS_EM_ABERTO',0 'PEN_FAT' " + linha
	cQuery += "FROM " + RetSqlName("SA1") + " (nolock) " + linha
	cQuery += "INNER JOIN " + RetSqlName("SC5") + " (nolock) " + linha
	cQuery += "ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND " + RetSqlName("SC5") + ".D_E_L_E_T_  = '' AND " + linha
	cQuery += "C5_NOTA = '  ' AND C5_BLQ = '  '  " + linha
	cQuery += "WHERE  " + linha
	cQuery += " " + RetSqlName("SA1") + ".D_E_L_E_T_  = ''  " + linha
	cQuery += "/****************/ " + linha
	cQuery += "UNION ALL " + linha
	cQuery += "/***************/ " + linha
	cQuery += "/**ULTIMO FATURAMENTO**/ " + linha
	cQuery += "/***************/ " + linha
	cQuery += "SELECT DISTINCT  " + linha
	cQuery += "CASE " + linha
	cQuery += "WHEN A1_MSBLQL = '1' THEN 'SIM' " + linha
	cQuery += "WHEN A1_MSBLQL = '2' THEN 'NÃO' " + linha
	cQuery += "END 'BLOQUEADO', " + linha
	cQuery += "A1_COD 'COD',A1_LOJA 'LOJA',A1_NOME 'NOME',A1_VENCLC 'VENCLC',A1_PRICOM 'PRICOM',A1_ULTCOM 'ULTCOM' " + linha
	cQuery += ",A1_NROCOM 'NROCOM',A1_MCOMPRA 'MCOMPRA',A1_SALPED 'SALPED',A1_DTCAD 'DTCAD',COALESCE(C5_FILIAL,'') 'FIL_PED', " + linha
	cQuery += "COALESCE(MAX(C5_EMISSAO) OVER (PARTITION BY A1_COD+A1_LOJA),'') 'EMISSAO', " + linha
	cQuery += "C5_NUM 'PED',COALESCE(SUM(C6_VALOR) OVER (PARTITION BY A1_COD+A1_LOJA+C6_NUM),'') 'VALOR_ULT_COMPRA',0 'SALDO_PEDIDOS',0 'PEDIDOS_EM_ABERTO',0 'PEN_FAT' " + linha
	cQuery += "FROM " + RetSqlName("SA1") + " (nolock) " + linha
	cQuery += "INNER JOIN " + RetSqlName("SC5") + " (nolock) " + linha
	cQuery += "ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND " + RetSqlName("SC5") + ".D_E_L_E_T_  = '' AND " + linha
	cQuery += "LTRIM(RTRIM(C5_CLIENTE))+LTRIM(RTRIM(C5_LOJACLI))+LTRIM(RTRIM(C5_FILIAL))+C5_EMISSAO IN ( " + linha
	cQuery += "SELECT  " + linha
	cQuery += "A1_COD + A1_LOJA + C5_FILIAL + MAX(C5_EMISSAO) OVER (PARTITION BY A1_COD+A1_LOJA)  " + linha
	cQuery += "FROM " + RetSqlName("SA1") + " (nolock) " + linha
	cQuery += "INNER JOIN " + RetSqlName("SC5") + " (nolock) " + linha
	cQuery += "ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND " + RetSqlName("SC5") + ".D_E_L_E_T_  = '' AND len(ltrim(rtrim(C5_NOTA))) > 0  " + linha
	cQuery += "WHERE  " + linha
	cQuery += " " + RetSqlName("SA1") + ".D_E_L_E_T_  = '' " + linha
	cQuery += ")   " + linha
	cQuery += "INNER JOIN " + RetSqlName("SC6") + " (nolock) " + linha
	cQuery += "ON C6_FILIAL = C5_FILIAL AND C6_CLI = C5_CLIENTE AND C6_NUM = C5_NUM AND " + RetSqlName("SC6") + ".D_E_L_E_T_ = '' " + linha
	cQuery += "WHERE  " + linha
	cQuery += "" + RetSqlName("SA1") + ".D_E_L_E_T_  = '' " + linha
	cQuery += "/***************/ " + linha
	cQuery += "/*******PEGO O PENULTIMO FATURAMENTO******/ " + linha
	cQuery += "UNION ALL " + linha
	cQuery += "/***************/ " + linha
	cQuery += "SELECT DISTINCT  " + linha
	cQuery += "CASE " + linha
	cQuery += "WHEN A1_MSBLQL = '1' THEN 'SIM' " + linha
	cQuery += "WHEN A1_MSBLQL = '2' THEN 'NÃO' " + linha
	cQuery += "END 'BLOQUEADO', " + linha
	cQuery += "A1_COD 'COD',A1_LOJA 'LOJA',A1_NOME 'NOME',A1_VENCLC 'VENCLC',A1_PRICOM 'PRICOM',A1_ULTCOM 'ULTCOM',0 'NROCOM',0 'MCOMPRA',0 'SALPED',A1_DTCAD 'DTCAD', " + linha
	cQuery += "0 'FIL_PED',0 'EMISSAO',0 'PED',0 'VALOR_ULT_COMPRA',0 'SALDO_PEDIDOS',0 'PEDIDOS_EM_ABERTO', " + linha
	cQuery += "COALESCE(MAX(F2_EMISSAO) OVER (PARTITION BY A1_COD+A1_LOJA),'') 'PEN_FAT' " + linha
	cQuery += "FROM " + RetSqlName("SA1") + " (nolock) " + linha
	cQuery += "INNER JOIN " + RetSqlName("SF2") + " (nolock) " + linha
	cQuery += "ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND " + RetSqlName("SF2") + ".D_E_L_E_T_  = '' AND LEN(F2_DUPL) >0 " + linha
	cQuery += "AND LTRIM(RTRIM(F2_CLIENTE))+LTRIM(RTRIM(F2_LOJA))+LTRIM(RTRIM(F2_FILIAL)) + F2_EMISSAO NOT IN ( " + linha
	cQuery += "SELECT DISTINCT  " + linha
	cQuery += "A1_COD +A1_LOJA + F2_FILIAL + MAX(F2_EMISSAO) OVER (PARTITION BY A1_COD+A1_LOJA)  " + linha
	cQuery += "FROM " + RetSqlName("SA1") + " (nolock) " + linha
	cQuery += "INNER JOIN " + RetSqlName("SF2") + " (nolock) " + linha
	cQuery += "ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND " + RetSqlName("SF2") + ".D_E_L_E_T_  = '' AND LEN(F2_DUPL) >0 " + linha
	cQuery += "WHERE " + RetSqlName("SA1") + ".D_E_L_E_T_  = '' " + linha
	cQuery += ")   " + linha
	cQuery += "WHERE " + RetSqlName("SA1") + ".D_E_L_E_T_  = '' " + linha
	cQuery += ") AS A " + linha
	cQuery += "ORDER BY COD,LOJA " + linha
	cQuery += " " + linha
	cQuery += " " + linha
	Oqry:TcQry("TRB", cQuery,1,.f.)
	

	TCSetField("TRB","DT_CADASTRO","D")
	TCSetField("TRB","VENC_LIMITE_CRED","D")
	TCSetField("TRB","PRIMEIRO_FATURAMENTO","D")
	TCSetField("TRB","ULTIMO_FATURAMENTO","D")
	TCSetField("TRB","PENULTIMO_FATURAMENTO","D")
	TCSetField("TRB","DT_EMIS_ULT_PED_FAT","D")

	Private oExcel := FWMSEXCEL():New()
	oExcel:AddworkSheet("Analise_Clientes")
	oExcel:AddTable ("Analise_Clientes","Analise_Clientes")
	//monta as colunas do relatório de forma dimânica com base o aStru 
	for x:=1 to len(mat)
		                   //(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oExcel:AddColumn("Analise_Clientes","Analise_Clientes",mat[x][1],mat[x][3],mat[x][2])
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
		oExcel:AddRow("Analise_Clientes","Analise_Clientes",aRet[x])
	next x

	oExcel:Activate()
	cPath := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	cNameFile := cPath + cValToChar(Randomize( 1, 1000 )) + "_MYFAT09.xml"

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