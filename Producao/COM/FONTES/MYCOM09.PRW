#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYCOM09.prw    | Autor : Leandro Ferreira      | Data : 09/11/2022 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Relatório de Limite de Alçadas		                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 09/11/2022  Leandro Ferreira          Gabriel Ramos   Criação do relatório   

User Function MYCOM09()


	LOCAL wnrel
	LOCAL Tamanho := "G"
	LOCAL cDesc1  := "Limite de Alçadas"	
	LOCAL cDesc2  := " "	
	LOCAL cDesc3  := " "	
	LOCAL cString := "SAL"
	Local aArea     := GetArea()
	PRIVATE aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administração"), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
	PRIVATE nomeprog:= "MYFAT09"
	PRIVATE aLinha  := { }
	PRIVATE Titulo  := OemToAnsi("Limite de Alçada")	
	PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont
	
	//pergunte("SNC076",.F.)
	wnrel := "MYCOM09"
	wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

	SetDefault(aReturn,cString)


	RptStatus({|lEnd| MYCOM09Excel()},titulo)
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
??? Uso      ? MYCOM09                                                    ???
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function MYCOM09Excel()
	Local Oqry  := NVLxFUN():New(.f.) //, cQuery
	Local x 	:= 0
	//-------------------------------//
	// Cria arquivo tempor?rio       //
	// para sex export. p/ Excel     //
	//-------------------------------//
	mat:={}
	//mat[x][1],mat[x][3],mat[x][2]
	//(< cColumn >, < nAlign >, < nFormat >, < lTotal >)
	aadd( mat , {"FILIAL"  				,  1 , 1 , 0 } )
	aadd( mat , {"CODIGO"  				,  1 , 1 , 0 } )
	aadd( mat , {"DESCRICAO"			,  1 , 1 , 0 } )
	aadd( mat , {"COD_APROVADOR"		,  1 , 1 , 0 } )
	aadd( mat , {"APROVADOR"			,  1 , 1 , 0 } )
	aadd( mat , {"NIVEL"  			 	,  1 , 1 , 0 } )
	aadd( mat , {"MIN_APROVADOR"		,  3 , 3 , 2 } )
	aadd( mat , {"MAX_APROVADOR" 		,  3 , 3 , 2 } )
	aadd( mat , {"LIMITE_MENSAL"		,  3 , 3 , 2 } )
	aadd( mat , {"TIPO_APROVACAO" 		,  1 , 1 , 0 } )
	aadd( mat , {"MINIMO_APROV_GRUPO"  	,  3 , 3 , 2 } )
	aadd( mat , {"MAXIMO_APROV_GRUPO"  	,  3 , 3 , 2 } )

	//dbcreate(cNomeArq,mat )
	If Select("TRB")>0
		("TRB")->(DbCloseArea())
	EndIf

	cQuery := "SELECT AL_FILIAL 'FILIAL',AL_COD 'CODIGO',AL_DESC 'DESCRICAO',AK_COD 'COD_APROVADOR',AK_NOME 'APROVADOR',AL_NIVEL 'NIVEL',AK_LIMMIN as 'MIN_APROVADOR', " + linha
	cQuery += "AK_LIMMAX as 'MAX_APROVADOR', " + linha
	cQuery += "AK_LIMITE as 'LIMITE_MENSAL', " + linha
	cQuery += "CASE " + linha
	cQuery += "	WHEN AL_LIBAPR = 'V' THEN 'VISTO' " + linha
	cQuery += "	WHEN AL_LIBAPR = 'A' THEN 'APROVADOR' " + linha 
	cQuery += "END 'TIPO_APROVACAO', " + linha
	cQuery += "--DHL_DESCRI AS 'Perfil', " + linha
	cQuery += "DHL_LIMMIN AS 'MINIMO_APROV_GRUPO',DHL_LIMMAX as 'MAXIMO_APROV_GRUPO' " + linha 
	cQuery += "from " + RetSqlName("SAK") + " (nolock)  " + linha
	cQuery += "inner join " + RetSqlName("SAL") + " (nolock)   " + linha
	cQuery += "on AL_APROV = AK_COD " + linha
	cQuery += "and AL_FILIAL = AK_FILIAL " + linha
	cQuery += "and AL_MSBLQL = '2' " + linha
	cQuery += "--SAL010.AL_USER = SAK010.AK_USER " + linha
	cQuery += "and " + RetSqlName("SAL") + ".D_E_L_E_T_ = ' ' " + linha
	cQuery += "INNER JOIN " + RetSqlName("DHL") + " (nolock)   " + linha
	cQuery += "ON " + linha 
	cQuery += "DHL_FILIAL = AK_FILIAL AND " + linha 
	cQuery += "DHL_COD = AL_PERFIL " + linha
	cQuery += "and DHL_LIMMAX > 0 " + linha
	cQuery += "and " + RetSqlName("DHL") + ".D_E_L_E_T_ = ' ' " + linha
	cQuery += "where " + linha
	cQuery += " " + RetSqlName("SAK") + ".D_E_L_E_T_ = ' ' " + linha 
	cQuery += "order by AL_FILIAL,AL_COD,AL_NIVEL " + linha
	cQuery += " " + linha
	Oqry:TcQry("TRB", cQuery,1,.f.)
	
	Private oExcel := FWMSEXCEL():New()
	oExcel:AddworkSheet("Limite de Alçadas")
	oExcel:AddTable ("Limite de Alçadas","Limite de Alçadas")
	//monta as colunas do relatório de forma dimânica com base o aStru 
	for x:=1 to len(mat)
		                   //(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oExcel:AddColumn("Limite de Alçadas","Limite de Alçadas",mat[x][1],mat[x][3],mat[x][2])
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
		oExcel:AddRow("Limite de Alçadas","Limite de Alçadas",aRet[x])
	next x

	oExcel:Activate()
	cPath := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	cNameFile := cPath + cValToChar(Randomize( 1, 1000 )) + "_MYCOM09.xml"

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
