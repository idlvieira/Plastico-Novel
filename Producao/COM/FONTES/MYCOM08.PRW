#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYFAT09.prw    | Autor : Leandro Ferreira      | Data : 30/10/2020 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Relatório de Projeção Financeira de Pedidos                        |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo

User Function MYCOM08()


	LOCAL wnrel
	LOCAL Tamanho := "G"
	LOCAL cDesc1  := "Projeção Financeira de Pedidos de Compras"	
	LOCAL cDesc2  := " "	
	LOCAL cDesc3  := " "	
	LOCAL cString := "SC7"
	Local aArea     := GetArea()
    Local aParc     := {}
	PRIVATE aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administração"), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
	PRIVATE nomeprog:= "MYCOM08"
	PRIVATE aLinha  := { }
	PRIVATE cPerg   := "MYCOM08"
	PRIVATE Titulo  := OemToAnsi("Projeção Financeira de Pedidos de Compras")	
	PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont

/*	If !MsgYesNo("Deseja emitir o relatório de Analise de Clientes", "Confirma?")
		Return NIL
	EndIf
	aParc := CONDICAO(900,"031",,DATE())
	//pergunte("MYCOM08",.F.)
    MSGSTOP("oi")
    return NIL
 */   
	wnrel := "MYCOM08"
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

	SetDefault(aReturn,cString)


	RptStatus({|lEnd| com08Excel()},titulo)
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
Static Function com08Excel()
	Local Oqry := NVLxFUN():New(.f.), cQuery
    Local x    := 0
    Local z    := 0 
	//-------------------------------//
	// Cria arquivo tempor?rio       //
	// para sex export. p/ Excel     //
	//-------------------------------//
	mat:={}
	//mat[x][1],mat[x][3],mat[x][2]
	//(< cColumn >, < nAlign >, < nFormat >, < lTotal >)
	aadd( mat , {"FILIAL"  				,  1 , 1 , 0 } )
	aadd( mat , {"FORNECE" 				,  1 , 1 , 0 } )
	aadd( mat , {"LOJA"   				,  1 , 1 , 0 } )
	aadd( mat , {"NOME"		        	,  1 , 1 , 0 } )
	aadd( mat , {"TEL"	        		,  1 , 1 , 0 } )
	aadd( mat , {"EST"              	,  1 , 1 , 0 } )
    aadd( mat , {"PC"               	,  1 , 1 , 0 } )
	aadd( mat , {"ITEM_PC"          	,  1 , 1 , 0 } )
	aadd( mat , {"NUMSC"                ,  1 , 1 , 0 } )
	aadd( mat , {"PRODUTO"              ,  1 , 1 , 0 } )
	aadd( mat , {"DESCRI"           	,  1 , 1 , 0 } )
	aadd( mat , {"OBS"                 	,  1 , 1 , 0 } )
	aadd( mat , {"GRUPO"               	,  1 , 1 , 0 } )
	aadd( mat , {"DESC"         		,  1 , 1 , 0 } )
	aadd( mat , {"EMISSAO"              ,  4 , 2 , 0 } )
	aadd( mat , {"DAT_ENTREGA"          ,  4 , 2 , 0 } )
	aadd( mat , {"QUANT"                ,  1 , 1 , 0 } )
	aadd( mat , {"UM"                	,  1 , 1 , 0 } )
	aadd( mat , {"PR_UNIT"              ,  3 , 3 , 2 } )
	aadd( mat , {"DESCONTO_1"           ,  3 , 3 , 2 } )
	aadd( mat , {"DESCONTO_2"           ,  3 , 3 , 2 } )
    aadd( mat , {"DESCONTO_3"           ,  3 , 3 , 2 } )
    aadd( mat , {"ALIQ_IPI"             ,  1 , 1 , 0 } )
	aadd( mat , {"VAL_IPI"              ,  3 , 3 , 2 } )
	aadd( mat , {"TOTAL_PEDIDO"         ,  3 , 3 , 2 } )
    aadd( mat , {"QTD_ENTREGUE"         ,  1 , 1 , 0 } )
    aadd( mat , {"QTD_A_RECEBER"        ,  1 , 1 , 0 } )
    aadd( mat , {"SALDO_A_RECEBER_S_IPI",  3 , 3 , 2 } )
    aadd( mat , {"SALDO_A_RECEBER_C_IPI",  3 , 3 , 2 } )
	aadd( mat , {"RESIDUO"             	,  1 , 1 , 0 } )
	aadd( mat , {"COD_SEGMENTO"        	,  1 , 1 , 0 } )
	aadd( mat , {"SEGMENTO"            	,  1 , 1 , 0 } )
    aadd( mat , {"COND"                	,  1 , 1 , 0 } )
    aadd( mat , {"DESCR_COND"          	,  1 , 1 , 0 } )
    aadd( mat , {"DT_01_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_01_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_02_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_02_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_03_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_03_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_04_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_04_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_05_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_05_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_06_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_06_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_07_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_07_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_08_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_08_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_09_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_09_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_10_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_10_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_11_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_11_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"DT_12_PARCELA"       	,  1 , 1 , 0 } )
    aadd( mat , {"VL_12_PARCELA"       	,  1 , 1 , 0 } )

	//dbcreate(cNomeArq,mat )
	If Select("TRB")>0
		("TRB")->(DbCloseArea())
	EndIf
	cQuery := "SELECT " + linha
	cQuery += "C7_FILIAL 'FILIAL',C7_FORNECE 'FORNECE',C7_LOJA 'LOJA', " + linha
	cQuery += "A2_NOME 'NOME',A2_TEL 'TEL',A2_EST 'EST',C7_NUM 'PC', " + linha
	cQuery += "C7_ITEM 'ITEM_PC',C7_NUMSC 'NUMSC',C7_PRODUTO 'PRODUTO',C7_DESCRI 'DESCRI',C7_OBS 'OBS', " + linha
	cQuery += "B1_GRUPO 'GRUPO',BM_DESC 'DESC',C7_EMISSAO 'EMISSAO',C7_DATPRF 'DAT_ENTREGA', " + linha
	cQuery += "C7_QUANT 'QUANT',C7_UM 'UM',C7_PRECO 'PR_UNIT',C7_DESC1 'DESCONTO_1',C7_DESC2 'DESCONTO_2',C7_DESC3 'DESCONTO_3', " + linha
	cQuery += "C7_IPI 'ALIQ_IPI',C7_VALIPI 'VAL_IPI',C7_TOTAL+C7_VALIPI 'TOTAL_PEDIDO',C7_QUJE 'QTD_ENTREGUE',C7_QUANT-C7_QUJE 'QTD_A_RECEBER', " + linha
	cQuery += "(C7_QUANT-C7_QUJE)*C7_PRECO 'SALDO_A_RECEBER_S_IPI',((C7_QUANT-C7_QUJE)*C7_PRECO) * (1+C7_IPI)'SALDO_A_RECEBER_C_IPI', " + linha
	cQuery += "C7_RESIDUO 'RESIDUO',A2_ZSEGM 'COD_SEGMENTO',ZZZ_RETORN 'SEGMENTO',C7_COND 'COND',E4_DESCRI 'DESCR_COND' " + linha
	cQuery += "FROM " + RetSqlName("SC7") + " (nolock) " + linha
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " (nolock) " + linha
	cQuery += "ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND " + RetSqlName("SA2") + ".D_E_L_E_T_  = '' " + linha
	cQuery += "INNER JOIN " + RetSqlName("SB1") + " (nolock) " + linha
	cQuery += "ON B1_COD = C7_PRODUTO AND " + RetSqlName("SB1") + ".D_E_L_E_T_ = '' " + linha
    cQuery += "INNER JOIN " + RetSqlName("SBM") + " (nolock) " + linha
	cQuery += "ON BM_GRUPO = B1_GRUPO AND " + RetSqlName("SBM") + ".D_E_L_E_T_ = '' " + linha
    cQuery += "INNER JOIN " + RetSqlName("ZZZ") + " (nolock) " + linha
	cQuery += "ON ZZZ_FILIAL = C7_FILIAL AND ZZZ_COD = 'FAT000005' AND ZZZ_DESCCO =  A2_ZSEGM AND " + RetSqlName("ZZZ") + ".D_E_L_E_T_ = '' " + linha
    cQuery += "INNER JOIN " + RetSqlName("SE4") + " (nolock) " + linha
	cQuery += "ON E4_CODIGO = C7_COND AND " + RetSqlName("SE4") + ".D_E_L_E_T_ = '' " + linha
	cQuery += "WHERE  " + linha
    cQuery += "C7_PRODUTO >=     '" + mv_par01	        + "' AND C7_PRODUTO <= '" + mv_par02	    + "' " + linha
    cQuery += "AND C7_EMISSAO >= '" + DtoS(mv_par03)	+ "' AND C7_EMISSAO <= '" + DtoS(mv_par04)	+ "' " + linha
    cQuery += "AND C7_DATPRF  >= '" + DtoS(mv_par05)	+ "' AND C7_DATPRF <= '"  + DtoS(mv_par06)	+ "' " + linha
    iF mv_par07 == 2
        cQuery += "AND C7_RESIDUO = '' AND C7_QUJE = 0 " + linha
    elseif  mv_par07 == 3
        cQuery += "AND C7_RESIDUO = '' " + linha
    elseif  mv_par07 == 4
        cQuery += "AND C7_RESIDUO = '' AND C7_QUANT-C7_QUJE <= 0 " + linha
    elseif  mv_par07 == 5
        cQuery += "AND C7_RESIDUO = '' AND C7_QUANT-C7_QUJE > 0 "  + linha 
    EndIf  
    cQuery += "AND C7_NUM >= '"       + mv_par08	    + "' AND C7_NUM <= '"   + 	mv_par09    + "' " + linha 
    iF mv_par10 == 1
        cQuery += "AND C7_TIPO = 1  " + linha
    elseif  mv_par10 == 2
        cQuery += "AND C7_TIPO = 2  " + linha
    EndIf  
    cQuery += "AND C7_FORNECE >= '"  + mv_par11	        + "' AND C7_FORNECE <= '"  + mv_par12	    + "' " + linha
	//cQuery += "C7_FILIAL = '0201' " + linha
    //cQuery += "AND C7_NUM = '029295' " + linha
	//cQuery += "AND C7_EMISSAO BETWEEN '20210101' AND '20211231' " + linha

	cQuery += " " + linha
	cQuery += " " + linha
	Oqry:TcQry("TRB", cQuery,1,.f.)
	

	TCSetField("TRB","EMISSAO","D")
	TCSetField("TRB","DAT_ENTREGA","D")

	Private oExcel := FWMSEXCEL():New()
	oExcel:AddworkSheet("Projeção de Pedidos")
	oExcel:AddTable ("Projeção de Pedidos","Projeção de Pedidos")
	//monta as colunas do relatório de forma dimânica com base o aStru 
	for x:=1 to len(mat)
		                   //(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oExcel:AddColumn("Projeção de Pedidos","Projeção de Pedidos",mat[x][1],mat[x][3],mat[x][2])
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
        if !Empty(aRet[x][25]) .And. !Empty(aRet[x][33]) .AND. !Empty(aRet[x][16])
		aParc := CONDICAO(aRet[x][25],cValToChar(aRet[x][33]),,aRet[x][16])
            for y := 1 to len(aParc)
                aRet[x][y+34]   := aParc[y][1]
                aRet[x][y+35]   := aParc[y][2]
            next y
        EndIf
	next x
	for x := 1 to len(aRet)
		oExcel:AddRow("Projeção de Pedidos","Projeção de Pedidos",aRet[x])
	next x

	oExcel:Activate()
	cPath := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	cNameFile := cPath + cValToChar(Randomize( 1, 1000 )) + "_MYCOM08.xml"

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
