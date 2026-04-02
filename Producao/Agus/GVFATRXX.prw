//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function GVFATRXX
	Relatorio cronograma de entrega
	@author Lucas Silva Vieira
	@since 26/08/2025
	@version 1.0
/*/

User Function GVFATRXX()
	Local aArea := FWGetArea()
	Local aPergs   := {}
	Local xPar0 := sToD("20240101")
	Local xPar1 := sToD("20451231")
	Local xPar2 := Space(6)
	Local xPar3 := replicate('Z', tamSx3('C5_CLIENTE')[1])
	Local xPar4 := Space(2)
	Local xPar5 := replicate('Z', tamSx3('C5_LOJACLI')[1])
	Local xPar6 := Space(6)
	Local xPar7 := replicate('Z', tamSx3('C5_NUM')[1])
	Local xPar8 := Space(15)
	Local xPar9 := replicate('Z', tamSx3('B1_COD')[1])
	Local xPar10 := sToD("20240101")
	Local xPar11 := sToD("20451231")
	Local xPar12 := 1
	
	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Data Inicial", xPar0,  "", ".T.", "", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Data Final", xPar1,  "", ".T.", "", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Cliente Inicial", xPar2,  "", ".T.", "SA1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Cliente Final", xPar3,  "", ".T.", "SA1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Loja Inicial", xPar4,  "", ".T.", "", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Loja Final", xPar5,  "", ".T.", "", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Pedido De", xPar6,  "", ".T.", "SC5", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Pedido Até", xPar7,  "", ".T.", "SC5", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Produto de", xPar8,  "", ".T.", "SB1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Produto ate", xPar9,  "", ".T.", "SB1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Prev.Ent.Inicial", xPar10,  "", ".T.", "", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Prev.Ent.Final", xPar11,  "", ".T.", "", ".T.", 80,  .T.})
	aAdd(aPergs, {2, "Imprime Zerado?", xPar12, {"1=Sim", "2=Não"}, 090, ".T.", .T.})
	
	//Se a pergunta for confirmada, chama o preenchimento dos dados do .dot
	If ParamBox(aPergs, 'Informe os parâmetros', /*aRet*/, /*bOk*/, /*aButtons*/, /*lCentered*/, /*nPosx*/, /*nPosy*/, /*oDlgWizard*/, /*cLoad*/, .F., .F.)
		MV_PAR13 := Val(cValToChar(MV_PAR13))
		Processa({|| fGeraExcel()})
	EndIf
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fGeraExcel
Criacao do arquivo Excel na funcao GVFATRXX
@author Lucas Silva Vieira
@since 26/08/2025
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fGeraExcel()
	Local cQryDad  := ""
	Local oFWMsExcel
	Local oExcel
	Local cArquivo    := GetTempPath() + 'GVFATRXX' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.xml'
	Local cWorkSheet := "Plan1"
	Local cTitulo    := "Plan1"
	Local nAtual := 0
	Local nTotal := 0
	Local cTpFrete := ""
	
	//Montando consulta de dados
	cQryDad += " SELECT A1_EST, C6_CLI, C6_LOJA, A1_NOME, C5_EMISSAO, C6_NUM, C6_ITEM, SUBSTRING(C6_PRODUTO,1,14) AS C6_PRODUTO, B1_DESC, ZX_QTDVEN, ZV_QTDVEN, ZV_QTDE, ZV_TQTDV, "		+ CRLF
	cQryDad += " (SC6.C6_QTDVEN - SC6.C6_QTDENT) as SALDO, C6_PRCVEN, ZX_QTDVEN*C6_PRCVEN AS TOTAL, ZX_DTPREV, C6_PEDCLI, C6_NUMPCOM, C6_ITEMPC, A1_ZZSEG, ZZZ_RETORN, C5_TPFRETE, "		+ CRLF
	cQryDad += " (SC6.C6_QTDVEN - SC6.C6_QTDENT) as Saldo, C6_PRCVEN AS PrcUnit, ZX_QTDVEN*C6_PRCVEN AS Total, ZX_DTPREV AS Entrega, C5_TPFRETE, C6_ZVLNET, A3_NOME, C5_ZZTEMGR, "		+ CRLF
	cQryDad += " ISNULL(CAST(CAST(C5_MENNOTA AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS, UA_ZZOBS1, UA_ZZOBS2, A1_MUN "		+ CRLF
	cQryDad += " FROM " +RetSQLName("SC6")+" SC6 																							" + CRLF
	cQryDad += " LEFT JOIN " +RetSQLName("SC5")+" SC5 ON SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.D_E_L_E_T_= ''  									" + CRLF
	cQryDad += " LEFT JOIN " +RetSQLName("SB1")+" SB1 ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_= '' 								" + CRLF
	cQryDad += " LEFT JOIN " +RetSQLName("SA1")+" SA1 ON SA1.A1_COD = SC6.C6_CLI AND SA1.A1_LOJA = SC6.C6_LOJA AND SA1.D_E_L_E_T_= '' 		" + CRLF
	cQryDad += " LEFT JOIN " +RetSQLName("SA3")+" SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SC5.D_E_L_E_T_= '' 									" + CRLF
	cQryDad += " LEFT JOIN " +RetSQLName("SZX")+" SZX ON SC6.C6_NUM = SZX.ZX_NUM AND SC6.C6_ITEM = SZX.ZX_ITEM  AND SZX.ZX_FILIAL = SC6.C6_FILIAL AND SZX.ZX_PRODUTO = SC6.C6_PRODUTO AND SZX.D_E_L_E_T_ = '' " + CRLF
	cQryDad += " LEFT JOIN " +RetSQLName("SUA")+" SUA ON SC5.C5_NUM = SUA.UA_NUMSC5 AND SUA.UA_FILIAL = SC5.C5_FILIAL AND  SUA.D_E_L_E_T_= ''  " + CRLF
	cQryDad += " LEFT JOIN " +RetSQLName("ZZZ")+" ZZZ ON ZZZ.ZZZ_COD='FAT000005' AND SA1.A1_ZZSEG = ZZZ.ZZZ_DESCCO AND SC6.C6_FILIAL = ZZZ.ZZZ_FILIAL  AND  ZZZ.D_E_L_E_T_= ''  " + CRLF
	cQryDad += " LEFT JOIN " +RetSQLName("SZV")+" SZV ON SZV.ZV_NUM = SC6.C6_NUM AND SZV.ZV_FILIAL = SC6.C6_FILIAL AND SZV.ZV_PRODUTO = SC6.C6_PRODUTO AND SZV.ZV_ITEM = SC6.C6_ITEM AND SZV.D_E_L_E_T_ = '' "  + CRLF
	cQryDad += " WHERE SC6.D_E_L_E_T_= '' "		+ CRLF
	cQryDad += " AND C5_BLQ IN ('') "		+ CRLF
	cQryDad += " AND C5_TIPO = 'N' "		+ CRLF
	cQryDad += " AND C5_NUM BETWEEN 	'"+MV_PAR07+"' AND '"+MV_PAR08+"' 				" + CRLF
	cQryDad += " AND C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' 	" + CRLF
	cQryDad += " AND ZX_DTPREV BETWEEN  '"+DtoS(MV_PAR11)+"' AND '"+DtoS(MV_PAR12)+"' 	" + CRLF
	cQryDad += " AND C5_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' 				" + CRLF
	cQryDad += " AND C5_LOJACLI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' 				" + CRLF
	cQryDad += " AND C6_PRODUTO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' 				" + CRLF
	cQryDad += " AND ZX_NUM IS NOT NULL  												" + CRLF
	cQryDad += " AND C5_CONDPAG NOT IN ('003','004','005','006')						" + CRLF
	cQryDad += " AND C5_NOTA = ''" 
	
	//Executando consulta e setando o total da regua
	If '--' $ cQryDad .Or. 'WITH' $ Upper(cQryDad) .Or. 'NOLOCK' $ Upper(cQryDad)
		FWAlertInfo('Alguns comandos (como --, WITH e NOLOCK), não são executados pela PLSQuery devido ao ChangeQuery. Tente migrar da PLSQuery para TCQuery.', 'Atenção')
	EndIf 
	PlsQuery(cQryDad, "QRY_DAD")
	DbSelectArea("QRY_DAD")
	
	//Cria a planilha do excel
	oFWMsExcel := FWMSExcel():New()
	
	//Criando a aba da planilha
	oFWMsExcel:AddworkSheet(cWorkSheet)
	
	//Criando a Tabela e as colunas
	oFWMsExcel:AddTable(cWorkSheet, cTitulo)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'CLIENTE'  			,1,1,.F.)		
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'NOME' 			 	,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'EMISSAO'  			,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'PEDIDO'  			,1,1,.F.)	
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'QUANTIDADE'  		,1,1,.F.)	
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'DIF. SALDO'  		,1,1,.F.)				
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'ITEM PV'  			,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'PRODUTO'  			,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'DESCRICAO'  			,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'PREÇO UNIT.' 		,1,1,.F.) 			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'TOTAL'  				,1,1,.F.)				
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'DT. PREV. ENTREGA'   ,1,1,.F.)	   	
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'DESC. SEGUIMENTO'  	,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'VENDEDOR'  			,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'N° PEDIDO CLIENTE' 	,1,1,.F.)	 		
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'ITEM PEDIDO CLIENTE' ,1,1,.F.)				
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'MENSAGEM '  			,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'MENSAGEM 1' 			,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'MENSAGEM 2' 			,1,1,.F.)			
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'VALOR NET'  			,1,1,.F.)				
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'TIPO DE FRETE'  		,1,1,.F.)				
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'TEM GRAVAÇÃO'  		,1,1,.F.)				
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, 'CIDADE ENTREGA'  	,1,1,.F.)				
	
	//Definindo o tamanho da regua
	Count To nTotal
	ProcRegua(nTotal)
	QRY_DAD->(DbGoTop())
	
	//Percorrendo os dados da query
	While !(QRY_DAD->(EoF()))
		
		//Incrementando a regua
		nAtual++
		IncProc("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")

		if QRY_DAD->C5_TPFRETE == 'C'
			cTpFrete := 'CIF'
		elseIf  QRY_DAD->C5_TPFRETE == 'F'
			cTpFrete := 'FOB'
		elseIf  QRY_DAD->C5_TPFRETE == 'T'
			cTpFrete := 'POR CONTA DE TERCEIROS'
		elseIf  QRY_DAD->C5_TPFRETE == 'D'
			cTpFrete := 'POR CONTA DO DESTINATARIO'
		elseIf  QRY_DAD->C5_TPFRETE == 'S'
			cTpFrete := 'SEM FRETE'		
		endIf			
		
		//Adicionando uma nova linha
		oFWMsExcel:AddRow(cWorkSheet, cTitulo, {;
			QRY_DAD->C6_CLI			,;
			QRY_DAD->A1_NOME  		,;
			QRY_DAD->C5_EMISSAO 	,;
			QRY_DAD->C6_NUM  		,;
			QRY_DAD->ZX_QTDVEN 		,;
			(QRY_DAD->ZV_QTDVEN - QRY_DAD->ZV_TQTDV ),;
			QRY_DAD->C6_ITEM		,;
			QRY_DAD->C6_PRODUTO  	,;
			QRY_DAD->B1_DESC  		,;
			QRY_DAD->C6_PRCVEN  	,;
			QRY_DAD->TOTAL  		,;
			QRY_DAD->ZX_DTPREV 		,;
			QRY_DAD->ZZZ_RETORN  	,;
			QRY_DAD->A3_NOME  		,;
			QRY_DAD->C6_NUMPCOM  	,;
			QRY_DAD->C6_ITEMPC  	,;
			QRY_DAD->OBS 			,;
			QRY_DAD->UA_ZZOBS1		,;
			QRY_DAD->UA_ZZOBS2 		,;
			QRY_DAD->C6_ZVLNET  	,;
			cTpFrete 				,;
			IIF(QRY_DAD->C5_ZZTEMGR == '1', 'SIM', 'NÃO'),;  
			ALLTRIM(QRY_DAD->A1_MUN)+' / '+QRY_DAD->A1_EST;
		})
		
		QRY_DAD->(DbSkip())
	EndDo
	QRY_DAD->(DbCloseArea())
	
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
	
	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open(cArquivo)
	oExcel:SetVisible(.T.)
	oExcel:Destroy()
	
Return
