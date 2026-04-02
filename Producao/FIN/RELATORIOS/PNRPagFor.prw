//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Includes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#Include "Protheus.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PNRPagFor ³ Autor ³ Celso Costa - TI9     ³ Data ³20.05.2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao para conferencia de pagamentos                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PNRPagFor()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cPerg	:= "PNRPAGFO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Private                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oReport	:= Nil
Private oSecCab	:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida/Cria Perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg( _cPerg )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes/preparacao para impressao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReportDef( _cPerg )

oReport:PrintDialog()

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Celso Costa - TI9     ³ Data ³20.05.2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Definicao da estrutura do relatorio                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef( _cPerg )

oReport := TReport():New( "PNRPAGFOR", "Conferencia de pagamentos/aprovacoesidos", _cPerg, {|oReport| PrintReport( oReport, _cPerg ) }, "Emissao da relacao de impostos retidos." )
oReport:SetLandscape( .T. )

oSecCab := TRSection():New( oReport , "ImpPagamentos", { "QRY" } )

TRCell():New( oSecCab, "Filial"						, "QRY" )
TRCell():New( oSecCab, "Prefixo"					, "QRY" )
TRCell():New( oSecCab, "Titulo"						, "QRY" )
TRCell():New( oSecCab, "Parcela"					, "QRY" )
TRCell():New( oSecCab, "Tipo"						, "QRY" )
TRCell():New( oSecCab, "Natureza"					, "QRY" )
TRCell():New( oSecCab, "Descricao"					, "QRY" )
TRCell():New( oSecCab, "Portador"					, "QRY" )
TRCell():New( oSecCab, "Fornecedor"					, "QRY" )
TRCell():New( oSecCab, "Loja"						, "QRY" )
TRCell():New( oSecCab, "Nome"						, "QRY" )
TRCell():New( oSecCab, "CNPJ"						, "QRY" )
TRCell():New( oSecCab, "Emissao"					, "QRY" )
TRCell():New( oSecCab, "Vencimento"					, "QRY" )
TRCell():New( oSecCab, "Vencto_Real"				, "QRY" )
TRCell():New( oSecCab, "Valor"		 				, "QRY" )
TRCell():New( oSecCab, "Moeda"		 				, "QRY" )
TRCell():New( oSecCab, "Saldo"						, "QRY" )
TRCell():New( oSecCab, "Dt_Baixa"					, "QRY" )
TRCell():New( oSecCab, "Historico"		 			, "QRY" )
TRCell():New( oSecCab, "Bordero"					, "QRY" )
TRCell():New( oSecCab, "Banco_de_Pagamento"			, "QRY" )
TRCell():New( oSecCab, "Cod_Banco_de_Pagamento"		, "QRY" )
TRCell():New( oSecCab, "Conta_de_Pagamento"			, "QRY" )
TRCell():New( oSecCab, "Banco_Fornecedor"			, "QRY" )
TRCell():New( oSecCab, "Agencia_Fornecedor"			, "QRY" )
TRCell():New( oSecCab, "DV_Agencia_Forn"			, "QRY" )
TRCell():New( oSecCab, "Conta_Fornecedor"			, "QRY" )
TRCell():New( oSecCab, "DV_Conta_Forn"				, "QRY" )
TRCell():New( oSecCab, "Data_Bordero"				, "QRY" )
TRCell():New( oSecCab, "Historico_Baixa"			, "QRY" )
TRCell():New( oSecCab, "Compensado_Por"				, "QRY" )
TRCell():New( oSecCab, "NumeroPC"					, "QRY" )
TRCell():New( oSecCab, "Emissao_PC"		 			, "QRY" )
TRCell():New( oSecCab, "ItemPC"		 				, "QRY" )
TRCell():New( oSecCab, "Produto"		 			, "QRY" )
TRCell():New( oSecCab, "Descricao"					, "QRY" )
TRCell():New( oSecCab, "Quantidade_PC"				, "QRY" )
TRCell():New( oSecCab, "Preco_Unitario_PC"			, "QRY" )
TRCell():New( oSecCab, "Total_PC"  					, "QRY" )
TRCell():New( oSecCab, "Qtde_Entregue_PC"			, "QRY" )
TRCell():New( oSecCab, "Saldo_PC"					, "QRY" )
TRCell():New( oSecCab, "Tipo_Frete_PC"				, "QRY" )
TRCell():New( oSecCab, "Observacao_PC"				, "QRY" )
TRCell():New( oSecCab, "Solicitacao_de_Compras"		, "QRY" )
TRCell():New( oSecCab, "Item_SC"					, "QRY" )
TRCell():New( oSecCab, "Condicao_de_Aprovacao"		, "QRY" )
TRCell():New( oSecCab, "Grupo_Aprovacao"			, "QRY" )
TRCell():New( oSecCab, "Comprador"					, "QRY" )
TRCell():New( oSecCab, "Nome_Comprador"				, "QRY" )
TRCell():New( oSecCab, "Aprovador"					, "QRY" )
TRCell():New( oSecCab, "Nome_Aprovador"				, "QRY" )
TRCell():New( oSecCab, "Data_Aprovacao"				, "QRY" )
TRCell():New( oSecCab, "Status"		  				, "QRY" )
TRCell():New( oSecCab, "Documento"					, "QRY" )
TRCell():New( oSecCab, "Serie"						, "QRY" )
TRCell():New( oSecCab, "Total_Frete"				, "QRY" )
TRCell():New( oSecCab, "Quantidade_NF"				, "QRY" )
TRCell():New( oSecCab, "Valor_Unitario_NF"			, "QRY" )
TRCell():New( oSecCab, "Total_NF"					, "QRY" )
TRCell():New( oSecCab, "IPI"						, "QRY" )
TRCell():New( oSecCab, "ICMS"						, "QRY" )
TRCell():New( oSecCab, "PIS"						, "QRY" )
TRCell():New( oSecCab, "COFINS"						, "QRY" )
TRCell():New( oSecCab, "ISS"						, "QRY" )
TRCell():New( oSecCab, "IRRF"						, "QRY" )
TRCell():New( oSecCab, "INSS"						, "QRY" )
TRCell():New( oSecCab, "CSLL"						, "QRY" )
		
Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PrintReport³ Autor ³ Celso Costa - TI9    ³ Data ³20.05.2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao do relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintReport( oReport, _cPerg )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cAliasQRY	:= "QRY"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa leitura das perguntas                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte( _cPerg, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona registros                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSecCab:BeginQuery()

BeginSql Alias _cAliasQRY
	Select 
		SE2.E2_FILIAL As Filial,
		SE2.E2_PREFIXO As Prefixo,
		SE2.E2_NUM As Titulo,
		SE2.E2_PARCELA As Parcela,
		SE2.E2_TIPO As Tipo,
		SE2.E2_NATUREZ As Natureza,
		SED.ED_DESCRIC As Descricao,
		SE2.E2_PORTADO As Portador,
		SE2.E2_FORNECE As Fornecedor,
		SE2.E2_LOJA As Loja,
		SA2.A2_NOME As Nome,
		SubString( SA2.A2_CGC, 01, 02 ) + '.' + SubString( SA2.A2_CGC, 03, 03 ) + '.' + SubString( SA2.A2_CGC, 06, 03 ) + '/' + SubString( SA2.A2_CGC, 09, 04 ) + '-' + SubString( SA2.A2_CGC, 13, 02 ) As CNPJ,
		SubString( SE2.E2_EMISSAO, 07, 02 ) + '/' + SubString( SE2.E2_EMISSAO, 05, 02 ) + '/' + SubString( SE2.E2_EMISSAO, 01, 04 ) As Emissao,
		SubString( SE2.E2_VENCTO, 07, 02 ) + '/' + SubString( SE2.E2_VENCTO, 05, 02 ) + '/' + SubString( SE2.E2_VENCTO, 01, 04 ) As Vencimento,
		SubString( SE2.E2_VENCREA, 07, 02 ) + '/' + SubString( SE2.E2_VENCREA, 05, 02 ) + '/' + SubString( SE2.E2_VENCREA, 01, 04 ) As Vencto_Real,
		SE2.E2_VALOR As Valor,
		Case
			When SE2.E2_MOEDA = '1' Then 'R$'
			When SE2.E2_MOEDA = '2' Then 'US$'
			When SE2.E2_MOEDA = '3' Then 'UFIR'
			When SE2.E2_MOEDA = '4' Then 'EURO'
			When SE2.E2_MOEDA = '5' Then 'IENE'
		Else ''
		End As Moeda,
		SE2.E2_SALDO As Saldo,
		SubString( SE2.E2_BAIXA, 07, 02 ) + '/' + SubString( SE2.E2_BAIXA, 05, 02 ) + '/' + SubString( SE2.E2_BAIXA, 01, 04 ) As Dt_Baixa,
		SE2.E2_HIST As Historico,
		SE2.E2_NUMBOR As Bordero,
		IsNull( SA6.A6_NREDUZ, '' ) As Banco_de_Pagamento,
		IsNull( SEA.EA_PORTADO, '' ) As Cod_Banco_de_Pagamento,
		IsNull( SA6.A6_NUMCON, '' ) As Conta_de_Pagamento,
		IsNull( SE2.E2_FORBCO, '' ) As Banco_Fornecedor, 
		IsNull( SE2.E2_FORAGE, '' ) As Agencia_Fornecedor,
		IsNull( SE2.E2_FAGEDV, '' ) As DV_Agencia_Forn,
		IsNull( SE2.E2_FORCTA, '' ) As Conta_Fornecedor,
		IsNull( SE2.E2_FCTADV, '' ) As DV_Conta_Forn,
		IsNull( SubString( SEA.EA_DATABOR, 07, 02 ) + '/' + SubString( SEA.EA_DATABOR, 05, 02 ) + '/' + SubString( SEA.EA_DATABOR, 01, 04 ), '' ) As Data_Bordero,
		IsNull( (	Select Top 01
							SE5.E5_HISTOR
						From
							%Table:SE5% SE5
						Where SE5.E5_TIPO = SE2.E2_TIPO
							And SE5.E5_PREFIXO = SE2.E2_PREFIXO
							And SE5.E5_NUMERO = SE2.E2_NUM
							And SE5.E5_PARCELA = SE2.E2_PARCELA
							And SE5.E5_CLIFOR = SE2.E2_FORNECE
							And SE5.E5_LOJA = SE2.E2_LOJA
							And SE5.E5_FILIAL = SE2.E2_FILIAL
							And SE5.%NotDel%
						Order By
							SE5.R_E_C_N_O_ Desc ), '' ) As Historico_Baixa,
		IsNull( (	Select Top 01
							'Tipo: ' + SE2a.E2_TIPO + ' ' +
							'Prefixo: ' + SE2a.E2_PREFIXO + ' ' +
							'Numero: ' + SE2a.E2_NUM + ' ' + 
							'Parcela: ' + SE2a.E2_PARCELA + ', ' +
							'emitido em: ' + SubString( SE2a.E2_EMISSAO, 07, 02 ) + '/' + SubString( SE2a.E2_EMISSAO, 05, 02 ) + '/' + SubString( SE2a.E2_EMISSAO, 01, 04 ) + ' ' +
							'no valor de: ' + Cast( SE2a.E2_VALOR As VarChar( 10 ) ) + ' ' +
							'com vencimento em: ' + SubString( SE2a.E2_VENCTO, 07, 02 ) + '/' + SubString( SE2a.E2_VENCTO, 05, 02 ) + '/' + SubString( SE2a.E2_VENCTO, 01, 04 ) + ' '
						From 
							%Table:SE2% SE2a,
							%Table:SE5% SE5
						Where SE5.E5_TIPO = SE2.E2_TIPO
							And SE5.E5_PREFIXO = SE2.E2_PREFIXO
							And SE5.E5_NUMERO = SE2.E2_NUM
							And SE5.E5_PARCELA = SE2.E2_PARCELA
							And SE5.E5_CLIFOR = SE2.E2_FORNECE
							And SE5.E5_LOJA = SE2.E2_LOJA
							And SE5.E5_FILIAL = SE2.E2_FILIAL
							And SE5.%NotDel%
							And SE2a.E2_PREFIXO + SE2a.E2_NUM + SE2a.E2_PARCELA + SE2a.E2_TIPO + SE2a.E2_FORNECE + SE2a.E2_LOJA = SE5.E5_DOCUMEN
							And SE2a.E2_FILIAL = SE5.E5_FILIAL
							And SE2a.%NotDel%
						Order By
							SE5.R_E_C_N_O_ Desc ), '' ) As Compensado_Por,
		IsNull( SC7.C7_NUM, '' ) As NumeroPC,
		IsNull( SubString( SC7.C7_EMISSAO, 07, 02 ) + '/' + SubString( SC7.C7_EMISSAO, 05, 02 ) + '/' + SubString( SC7.C7_EMISSAO, 01, 04 ), '' ) As Emissao_PC,
		IsNull( SC7.C7_ITEM, '' ) As ItemPC,
		IsNull( SC7.C7_PRODUTO, '' ) As Produto,
		IsNull( SC7.C7_DESCRI, '' ) As Descricao,
		IsNull( SC7.C7_QUANT, 00 ) As Quantidade_PC,
		IsNull( SC7.C7_PRECO, 00 ) As Preco_Unitario_PC,
		IsNull( SC7.C7_TOTAL, 00 ) As Total_PC,
		IsNull( SC7.C7_QUJE, 00 ) As Qtde_Entregue_PC,
		IsNull( SC7.C7_QUANT - SC7.C7_QUJE, 00 ) Saldo_PC,
		IsNull( Case
						When SC7.C7_TPFRETE = 'C' Then 'CIF'
						When SC7.C7_TPFRETE = 'F' Then 'FOB'
						When SC7.C7_TPFRETE Not In ( 'C', 'F' ) Then  ''
					End, '' ) As Tipo_Frete_PC,
		IsNull( SC7.C7_OBS, '' ) As Observacao_PC,
		IsNull( SC7.C7_NUMSC, '' ) As Solicitacao_de_Compras,
		IsNull( SC7.C7_ITEMSC, '' ) As Item_SC,
		IsNull(	Case 
						When SC7.C7_CONAPRO = 'L' Then 'Liberado'
						When SC7.C7_CONAPRO = 'B' Then 'Bloqueado'
						When SC7.C7_CONAPRO Not In ( 'L', 'B' ) Then SC7.C7_CONAPRO
					End, '' ) As Condicao_de_Aprovacao,
		IsNull( SC7.C7_GRUPCOM, '' ) As Grupo_Aprovacao, 
		IsNull( SC7.C7_USER, '' ) As Comprador,
		IsNull( (	Select 
							Y1_NOME 
						From 
							%Table:SY1% SY1 
						Where SY1.Y1_USER = SC7.C7_USER 
							And SY1.Y1_GRUPCOM = SC7.C7_GRUPCOM
							And SY1.Y1_FILIAL = SC7.C7_FILIAL 
							And SY1.%NotDel% ), '' ) As Nome_Comprador,
		IsNull( (	Select Top 01
							SCR.CR_LIBAPRO
						From
							%Table:SCR% SCR
						Where SCR.CR_NUM = SC7.C7_NUM
							And SCR.CR_FILIAL = SC7.C7_FILIAL
							And SCR.%NotDel%
						Order By
							SCR.R_E_C_N_O_ Desc ), '' ) As Aprovador,
		IsNull( (	Select Top 01
							SAK.AK_NOME
						From
							%Table:SCR% SCR,
							%Table:SAK% SAK
						Where SCR.CR_NUM = SC7.C7_NUM
							And SCR.CR_FILIAL = SC7.C7_FILIAL
							And SCR.%NotDel%
							And SAK.AK_USER = SCR.CR_USER
							And SAK.AK_FILIAL = SC7.C7_FILIAL
							And SAK.%NotDel%
						Order By
							SCR.R_E_C_N_O_ Desc ), '' ) As Nome_Aprovador,
		IsNull( (	Select Top 01
							SubString( SCR.CR_DATALIB, 07, 02 ) + '/' + SubString( SCR.CR_DATALIB, 05, 02 ) + '/' + SubString( SCR.CR_DATALIB, 01, 04 )
						From
							%Table:SCR% SCR
						Where SCR.CR_NUM = SC7.C7_NUM
							And SCR.CR_FILIAL = SC7.C7_FILIAL
							And SCR.%NotDel%
						Order By
							SCR.R_E_C_N_O_ Desc ), '' ) As Data_Aprovacao,
		IsNull( (	Select Top 01 
							Case 
								When SCR.CR_STATUS = '01' Then 'Pendente em niveis anteriores'
								When SCR.CR_STATUS = '02' Then 'Pendente'
								When SCR.CR_STATUS = '03' Then 'Aprovado'
								When SCR.CR_STATUS = '04' Then 'Bloqueado'
								When SCR.CR_STATUS = '05' Then 'Aprovado/rejeitado pelo nivel'
								When SCR.CR_STATUS = '06' Then 'Rejeitado'
							End
						From
							%Table:SCR% SCR
						Where SCR.CR_NUM = SC7.C7_NUM
							And SCR.CR_FILIAL = SC7.C7_FILIAL
							And SCR.%NotDel%
						Order By
							SCR.R_E_C_N_O_ Desc ), '' ) As Status,
		IsNull( SD1.D1_DOC, '' ) As Documento,
		IsNull( SD1.D1_SERIE,'' ) As Serie,
		IsNull( SF1.F1_FRETE, '' ) As Total_Frete,	
		IsNull( SD1.D1_QUANT, '' ) As Quantidade_NF,
		IsNull( SD1.D1_VUNIT, '' ) As Valor_Unitario_NF,
		IsNull( SD1.D1_TOTAL, '' ) As Total_NF,
		IsNull( SD1.D1_VALIPI, '' ) As IPI,
		IsNull( SD1.D1_VALICM, '' ) As ICMS,
		SE2.E2_PIS As PIS,
		SE2.E2_COFINS As COFINS,
		SE2.E2_ISS As ISS,
		SE2.E2_IRRF As IRRF,
		SE2.E2_INSS As INSS,
		SE2.E2_CSLL As CSLL
	From
		%Table:SA2% SA2,
		%Table:SED% SED,
		%Table:SE2% SE2
	Left Join
		%Table:SF1% SF1 On SF1.F1_DUPL = SE2.E2_NUM
			And SF1.F1_FORNECE = SE2.E2_FORNECE
			And SF1.F1_LOJA = SE2.E2_LOJA
			And SF1.F1_FILIAL = SE2.E2_FILIAL
			And SF1.%NotDel%
	Left Join
		%Table:SD1% SD1 On SD1.D1_DOC = SF1.F1_DOC
			And SD1.D1_SERIE = SF1.F1_SERIE
			And SD1.D1_FORNECE = SF1.F1_FORNECE
			And SD1.D1_LOJA = SF1.F1_LOJA
			And SD1.D1_FILIAL = SF1.F1_FILIAL
			And SD1.%NotDel%
	Left Join
		%Table:SC7% SC7 On SC7.C7_NUM = SD1.D1_PEDIDO
			And SC7.C7_ITEM = SD1.D1_ITEMPC
			And SC7.C7_PRODUTO = SD1.D1_COD
			And SC7.C7_FORNECE = SD1.D1_FORNECE
			And SC7.C7_LOJA = SD1.D1_LOJA
			And SC7.C7_FILIAL = SD1.D1_FILIAL
			And SC7.%NotDel%
	Left Join
		%Table:SEA% SEA On SEA.EA_NUMBOR = SE2.E2_NUMBOR
			And SEA.EA_PREFIXO = SE2.E2_PREFIXO
			And SEA.EA_NUM = SE2.E2_NUM
			And SEA.EA_PARCELA = SE2.E2_PARCELA
			And SEA.EA_TIPO = SE2.E2_TIPO
			And SEA.EA_FORNECE = SE2.E2_FORNECE
			And SEA.EA_LOJA = SE2.E2_LOJA
			And SEA.EA_FILIAL = SE2.E2_FILIAL
			And SEA.%NotDel%
	Left Join
		%Table:SA6% SA6 On SA6.A6_COD = SEA.EA_PORTADO
		And SA6.A6_AGENCIA = SEA.EA_AGEDEP
		And SA6.A6_FILIAL = SEA.EA_FILIAL
		And SA6.%NotDel%
	Where SE2.E2_EMISSAO BetWeen %Exp:DtoS( mv_par01 )% And %Exp:DtoS( mv_par02 )%
		And SE2.E2_VENCTO BetWeen %Exp:DtoS( mv_par03 )% And %Exp:DtoS( mv_par04 )%
		And SE2.E2_VENCREA BetWeen %Exp:DtoS( mv_par05 )% And %Exp:DtoS( mv_par06 )%
		And SE2.E2_FILIAL BetWeen %Exp:AllTrim( mv_par07 )% And %Exp:AllTrim( mv_par08 )%
		And SE2.%NotDel%
		And SED.ED_CODIGO = SE2.E2_NATUREZ
		And SED.%NotDel%
		And SA2.A2_COD = SE2.E2_FORNECE
		And SA2.A2_LOJA = SE2.E2_LOJA
		And SA2.%NotDel%
	Order By
		SE2.E2_FILIAL
EndSQL
   
oSecCab:EndQuery()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua impressao                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSecCab:Print()

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ AjustaSX1  ³ Autor ³ Celso Costa - TI9   ³ Data ³20.05.2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria/Ajusta perguntas                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg( _cPerg )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	_aArea	:= GetArea()
Local _aRegs	:= {}
Local i			:= 00
Local j			:= 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida/Cria perguntes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SX1" )
Sx1->( dbSetOrder( 01 ) )

_cPerg := PadR( _cPerg, Len( SX1->X1_GRUPO ) )

aAdd(_aRegs, { _cPerg, "01", "Emissao Titulo de"			,"" ,"" ,"mv_ch1", "D", 08, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	} )
aAdd(_aRegs, { _cPerg, "02", "Emissao Titulo ate"			,"" ,"" ,"mv_ch2", "D", 08, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	} )
aAdd(_aRegs, { _cPerg, "03", "Vencto. Titulo de"			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	} )
aAdd(_aRegs, { _cPerg, "04", "Vencto. Titulo ate"			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	} )
aAdd(_aRegs, { _cPerg, "05", "Vencto. Real Titulo de"		,"" ,"" ,"mv_ch5", "D", 08, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	} )
aAdd(_aRegs, { _cPerg, "06", "Vencto. Real Titulo ate"	,"" ,"" ,"mv_ch6", "D", 08, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	} )
aAdd(_aRegs, { _cPerg, "07", "Filial de"						,"" ,"" ,"mv_ch7", "C", 04, 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	} )
aAdd(_aRegs, { _cPerg, "08", "Filial ate"						,"" ,"" ,"mv_ch8", "C", 04, 0, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	} )

For i := 01 To Len( _aRegs )

	If !dbSeek( _cPerg + _aRegs[ i ][ 02 ] )

		RecLock( "SX1", .T. )
		For j := 01 To FCount()
			If j <= Len( _aRegs[ i ] )
				FieldPut( j, _aRegs[ i ][ j ] )
			Endif
		Next
		SX1->( MsUnlock() )

	EndIf

Next i

RestArea( _aArea )

Return ( Nil )
