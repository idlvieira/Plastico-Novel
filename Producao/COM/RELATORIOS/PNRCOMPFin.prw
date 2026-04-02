/* Includes/Defines */
#Include "Protheus.CH"

/*/{Protheus.doc} PNProjPCFin
Projecao financeira de pedidos de compras
@type user function
@version  
@author celso.costa
@since 11/03/2022
@return variant, return_description
/*/
User Function PNRCOMPFin()

/* Variaveis Locais */
Local _cPerg	:= "PNPROJPF"

/* Variaveis Private */
Private oReport	:= Nil
Private oSecCab	:= Nil

/* Valida/cria pergunte */
ValidPerg( _cPerg )

/* Definicoes/preparacao para impressao */
ReportDef( _cPerg )

oReport:PrintDialog()

Return ( Nil )

/*/{Protheus.doc} ReportDef
Definicao da estrutura do relatorio
@type static function
@version  
@author celso
@since 11/03/2022
@param _cPerg, variant, param_description
@return variant, return_description
/*/
Static Function ReportDef( _cPerg )

/* Definicao de Includes */
Local oSection1

/* Definicao oReport */
oReport := TReport():New( "PNPROJPCFIN", "Projecao financeira dos Pedidos de Compras", _cPerg, {|oReport| PrintReport( oReport, _cPerg ) }, "Emissao da projecao financeira dos pedidos de compras." )

oReport:SetLandscape( .T. )
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()
 
/* oSection1 */
oSection1 := TRSection():New( oReport, "Filial", { "QRY" } )
oSection1:SetTotalInLine( .F. )

TRCell():New(oSection1, "Filial"						, "QRY", "FILIAL"						, PesqPict( "SC7", "C7_FILIAL" )		, TamSX3( "C7_FILIAL" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Fornecedor"					, "QRY", "FORNECEDOR"					, PesqPict( "SC7", "C7_FORNECE" )	, TamSX3( "C7_FORNECE" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Loja"							, "QRY", "LOJA"							, PesqPict( "SC7", "C7_LOJA" )		, TamSX3( "C7_LOJA" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Nome"							, "QRY", "NOME"							, PesqPict( "SA2", "A2_NOME" )		, TamSX3( "A2_NOME" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Telefone"						, "QRY", "TELEFONE"						, PesqPict( "SA2", "A2_TEL" )	 		, TamSX3( "A2_TEL" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "UF"						    , "QRY", "UF"							, PesqPict( "SA2", "A2_EST" )			, TamSX3( "A2_EST" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Numero_PC"						, "QRY", "NUMERO PC"					, PesqPict( "SC7", "C7_NUM" )			, TamSX3( "C7_NUM" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "CCUSTO"			            , "QRY", "C. CUSTO"		  		        , PesqPict( "SC7", "C7_CC" )		    , TamSX3( "C7_CC" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Tipo_PC"						, "QRY", "TIPO PC"						, PesqPict( "SC7", "C7_TIPO" )		, TamSX3( "C7_TIPO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Item_PC"						, "QRY", "ITEM PC"						, PesqPict( "SC7", "C7_ITEM" )		, TamSX3( "C7_ITEM" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Numero_SC"						, "QRY", "NUMERO SC"					, PesqPict( "SC7", "C7_NUMSC" )		, TamSX3( "C7_NUMSC" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "USUARIO"			            , "QRY", "USUARIO"				        , PesqPict( "SE1", "C1_SOLICIT" )		, TamSX3( "C1_SOLICIT" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Produto"						, "QRY", "PRODUTO"						, PesqPict( "SC7", "C7_PRODUTO" )	, TamSX3( "C7_PRODUTO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Descricao"						, "QRY", "DESCRICAO"					, PesqPict( "SC7", "C7_DESCRI" )		, TamSX3( "C7_DESCRI" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Observacoes"					, "QRY", "OBSERVACOES"					, PesqPict( "SC7", "C7_OBS" )			, TamSX3( "C7_OBS" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Grupo"							, "QRY", "GRUPO"						, PesqPict( "SBM", "BM_GRUPO" )		, TamSX3( "BM_GRUPO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Descricao"						, "QRY", "DESCRICAO"					, PesqPict( "SBM", "BM_DESC" )		, TamSX3( "BM_DESC" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Emissao"						, "QRY", "EMISSAO"						, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Entrega"					, "QRY", "DATA ENTREGA"					, PesqPict( "SC7", "C7_DATPRF" )		, TamSX3( "C7_DATPRF" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Ent_pFin"				    , "QRY", "DATA ENTR FINANC"			    , PesqPict( "SC7", "C7_ZZDATPR" )	, TamSX3( "C7_ZZDATPR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Quantidade"					, "QRY", "QUANTIDADE"					, PesqPict( "SC7", "C7_QUANT" )		, TamSX3( "C7_QUANT" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "UM"						    , "QRY", "UM"							, PesqPict( "SC7", "C7_UM" )			, TamSX3( "C7_UM" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Preco_Unitario"				, "QRY", "PRECO UNITARIO"				, PesqPict( "SC7", "C7_PRECO" )		, TamSX3( "C7_PRECO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Desconto_01"					, "QRY", "DESCONTO 01"					, PesqPict( "SC7", "C7_PRECO" )		, TamSX3( "C7_PRECO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Desconto_02"					, "QRY", "DESCONTO 02"					, PesqPict( "SC7", "C7_PRECO" )		, TamSX3( "C7_PRECO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Desconto_03"					, "QRY", "DESCONTO 03"					, PesqPict( "SC7", "C7_PRECO" )		, TamSX3( "C7_PRECO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Aliquota_IPI"					, "QRY", "ALIQUOTA IPI"					, PesqPict( "SC7", "C7_IPI" )			, TamSX3( "C7_IPI" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_IPI"						, "QRY", "VALOR IPI"					, PesqPict( "SC7", "C7_VALIPI" )		, TamSX3( "C7_VALIPI" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Total_Pedido"					, "QRY", "TOTAL PEDIDO"					, PesqPict( "SC7", "C7_TOTAL" )		, TamSX3( "C7_TOTAL" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Qtd_Entregue"					, "QRY", "QTD. ENTREGUE"				, PesqPict( "SC7", "C7_QUJE" )		, TamSX3( "C7_QUJE" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Qtd_a_Receber"				    , "QRY", "QTD. A RECEBER"				, PesqPict( "SC7", "C7_QUANT" )		, TamSX3( "C7_QUANT" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Saldo_a_Receber_sem_IPI"	    , "QRY", "SALDO A RECEBER SEM IPI"	    , PesqPict( "SC7", "C7_TOTAL" )		, TamSX3( "C7_TOTAL" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Saldo_a_Receber_com_IPI"	    , "QRY", "SALDO A RECEBER COM IPI"	    , PesqPict( "SC7", "C7_TOTAL" )		, TamSX3( "C7_TOTAL" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Residuo"						, "QRY", "RESIDUO"						, PesqPict( "SC7", "C7_RESIDUO" )	, TamSX3( "C7_RESIDUO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Aprovacao"						, "QRY", "APROVACAO"					, PesqPict( "SC7", "C7_CONAPRO" )	, TamSX3( "C7_CONAPRO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Emitido"						, "QRY", "EMITIDO"						, PesqPict( "SC7", "C7_EMITIDO" )	, TamSX3( "C7_EMITIDO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Comprador"						, "QRY", "COMPRADOR"					, PesqPict( "SY1", "Y1_NOME" )		, TamSX3( "Y1_NOME" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Cod_Segmento"					, "QRY", "COD. SEGMENTO"				, PesqPict( "SA2", "A2_ZSEGM" )		, TamSX3( "A2_ZSEGM" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )    //TRCell():new(oSection1, "Segmento"						, "QRY", "SEGMENTO"						, PesqPict( "ZZZ", "ZZZ_RETORN" )	, TamSX3( "ZZZ_RETORN" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ ) 
TRCell():new(oSection1, "Cond_Pagamento"				, "QRY", "COND. PAGAMENTO"				, PesqPict( "SC7", "C7_COND" )		, TamSX3( "C7_COND" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Descricao_Cond"				, "QRY", "DESCRICAO COND."				, PesqPict( "SE4", "E4_DESCRI" )		, TamSX3( "E4_DESCRI" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_01"				, "QRY", "DT. PARCELA 01"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_01"			    , "QRY", "VLR. PARCELA 01"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_02"				, "QRY", "DT. PARCELA 02"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_02"			    , "QRY", "VLR. PARCELA 02"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_03"				, "QRY", "DT. PARCELA 03"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_03"			    , "QRY", "VLR. PARCELA 03"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_04"				, "QRY", "DT. PARCELA 04"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_04"			    , "QRY", "VLR. PARCELA 04"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_05"				, "QRY", "DT. PARCELA 05"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_05"		 	    , "QRY", "VLR. PARCELA 05"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_06"				, "QRY", "DT. PARCELA 06"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_06"			    , "QRY", "VLR. PARCELA 06"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_07"				, "QRY", "DT. PARCELA 07"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_07"			    , "QRY", "VLR. PARCELA 07"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_08"				, "QRY", "DT. PARCELA 08"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_08"			    , "QRY", "VLR. PARCELA 08"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_09"				, "QRY", "DT. PARCELA 09"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_09"			    , "QRY", "VLR. PARCELA 09"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_10"				, "QRY", "DT. PARCELA 10"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_10"			    , "QRY", "VLR. PARCELA 10"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_11"				, "QRY", "DT. PARCELA 11"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_11"			    , "QRY", "VLR. PARCELA 11"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Data_Parcela_12"				, "QRY", "DT. PARCELA 12"				, PesqPict( "SC7", "C7_EMISSAO" )	, TamSX3( "C7_EMISSAO" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "Valor_Parcela_12"			    , "QRY", "VLR. PARCELA 12"				, PesqPict( "SE1", "E1_VALOR" )		, TamSX3( "E1_VALOR" )[ 01 ] + 01, /*lPixel*/,/*{|| code-block de impressao }*/ )
TRCell():new(oSection1, "em_Pre-Nota"					, "QRY", "PRE-NOTA"					    , "@!"										, 20, /*lPixel*/,/*{|| code-block de impressao }*/ )

Return ( Nil )

/*/{Protheus.doc} PrintReport
Emissao do relatorio
@type static function
@version  
@author celso
@since 11/03/2022
@param oReport, object, param_description
@param _cPerg, variant, param_description
@return variant, return_description
/*/
Static Function PrintReport( oReport, _cPerg )

/* Variaveis Locais */
Local _cAliasQRY		:= "QRY"
Local oSection1		:= oReport:Section( 01 )
Local _aParcelas		:= {}
Local _dDataProjecao	:= ""
Local _cInTpPC			:= ""
Local _cWhereQUJE		:= ""
Local _cInBlq			:= ""
Local _cInResiduo		:= ""
Local _cInEmitido		:= ""
Local _cStatus          := ""

/* Executa leitura das perguntas */
Pergunte( _cPerg, .F. )

/* Atualizacao das datas de entrega previsao financeira */
MsAguarde( {|| U_UpdDtPrFin() }, "Verificando previsoes de entregas financeiras ..." )

/* Define formatin das perguntas */
_cInTpPC	:= "% " + FormatIn( Iif( mv_par13 == 03, "1/2", AllTrim( Str( mv_par13 ) ) ), "/" ) + " %"
_cWhereQUJE	:= "% " + Iif( mv_par14 == 01, "SC7.C7_QUANT - SC7.C7_QUJE <= 00", Iif( mv_par14 == 02, "SC7.C7_QUANT - SC7.C7_QUJE > 00", "SC7.C7_QUANT = SC7.C7_QUANT" ) ) + " %"
_cInBlq		:= "% " + FormatIn( Iif( mv_par15 == 03, "B/L/R/ ", IIf( mv_par15 == 01, "L", "B/R" ) ), "/" ) + " %"
_cInResiduo	:= "% " + FormatIn( Iif( mv_par16 == 03, "S/N/ ", Iif( mv_par16 == 01, "S", "N/ " ) ), "/" ) + " %"
_cInEmitido	:= "% " + FormatIn( Iif( mv_par17 == 03, "S/N/ ", Iif( mv_par17 == 01, "S", "N/ " ) ), "/" ) + " %"

/* Seleciona registros */
BeginSql Alias _cAliasQRY
	Select
		SC7.C7_FILIAL As Filial,
		SC7.C7_FORNECE As Fornecedor,
		SC7.C7_LOJA As Loja,
		SA2.A2_NOME As Nome,
		SA2.A2_TEL As Telefone,
		SA2.A2_EST As UF,
		SC7.C7_NUM As Numero_PC,
		SC7.C7_CC As CCUSTO,
		SC1.C1_APROV As STATUS,
		SC7.C7_TIPO As Tipo_PC,
		SC7.C7_ITEM As Item_PC,
		SC7.C7_NUMSC As Numero_SC,
		SC1.C1_SOLICIT As USUARIO,
		SC7.C7_PRODUTO As Produto,
		SC7.C7_DESCRI As Descricao,
		SC7.C7_OBS As Observacoes,
		SBM.BM_GRUPO As Grupo,
		SBM.BM_DESC As Descricao,
		SubString( SC7.C7_EMISSAO, 07, 02 ) + '/' + SubString( SC7.C7_EMISSAO, 05, 02 ) + '/' + SubString( SC7.C7_EMISSAO, 01, 04 ) As Emissao,
		SubString( SC7.C7_DATPRF, 07, 02 ) + '/' + SubString( SC7.C7_DATPRF, 05, 02 ) + '/' + SubString( SC7.C7_DATPRF, 01, 04 ) As Data_Entrega,
		SubString( SC7.C7_ZZDATPR, 07, 02 ) + '/' + SubString( SC7.C7_ZZDATPR, 05, 02 ) + '/' + SubString( SC7.C7_ZZDATPR, 01, 04 ) As Data_Ent_pFin,
		SC7.C7_QUANT As Quantidade,
		SC7.C7_UM As UM,
		SC7.C7_PRECO As Preco_Unitario,
		00 As Desconto_01,
		00 As Desconto_02,
		00 As Desconto_03,
		SC7.C7_IPI As Aliquota_IPI,
		SC7.C7_VALIPI As Valor_IPI,
		SC7.C7_TOTAL + SC7.C7_VALIPI As Total_Pedido,
		SC7.C7_QUJE As Qtd_Entregue,
		Case When SC7.C7_RESIDUO <> 'S' Then SC7.C7_QUANT - SC7.C7_QUJE Else 00 End As Qtd_a_Receber,
		Case When SC7.C7_RESIDUO <> 'S' Then ( SC7.C7_QUANT - SC7.C7_QUJE ) * SC7.C7_PRECO Else 00 End As Saldo_a_Receber_sem_IPI,
		Case When SC7.C7_RESIDUO <> 'S' Then ( ( SC7.C7_QUANT - SC7.C7_QUJE ) * SC7.C7_PRECO ) + ( ( SC7.C7_QUANT - SC7.C7_QUJE ) * ( SC7.C7_VALIPI / SC7.C7_QUANT ) ) Else 00 End As Saldo_a_Receber_com_IPI,
		SC7.C7_RESIDUO As Residuo,
		SC7.C7_EMITIDO As Emitido,
		SY1.Y1_NOME As Comprador,
		SC7.C7_CONAPRO As Aprovacao,
		SA2.A2_ZSEGM As Cod_Segmento, /*ZZZ.ZZZ_RETORN As Segmento,*/
		SC7.C7_COND As Cond_Pagamento,
		SE4.E4_DESCRI As Descricao_Cond
	From 
		%Table:SC7% SC7,
		%Table:SB1% SB1,
		%Table:SBM% SBM,
		%Table:SE4% SE4,
		%Table:SY1% SY1,
		%Table:SA2% SA2,
		%Table:SC1% SC1
	/*Inner Join %Table:ZZZ% ZZZ	
		On ZZZ_COD Like '%FAT000005%'
			And ZZZ_DESC Like '%SEGMENTO DE FORNECEDOR%'
			And ZZZ_DESCCO = SA2.A2_ZSEGM
			And ZZZ.ZZZ_FILIAL = %xFilial:ZZZ%
			And ZZZ.%NotDel% */
	Where SC7.C7_FILIAL BetWeen %Exp:AllTrim( mv_par01 )% And %Exp:AllTrim( mv_par02 )%
		And SC7.C7_PRODUTO BetWeen %Exp:AllTrim( mv_par03 )% And %Exp:AllTrim( mv_par04 )%
		And SC7.C7_FORNECE BetWeen %Exp:AllTrim( mv_par05 )% And %Exp:AllTrim( mv_par06 )%
		And SC7.C7_EMISSAO BetWeen %Exp:DtoS( mv_par07 )% And %Exp:DtoS( mv_par08 )%
		And SC7.C7_DATPRF BetWeen %Exp:DtoS( mv_par09 )% And %Exp:DtoS( mv_par10 )%
		And SC7.C7_ZZDATPR BetWeen %Exp:DtoS( mv_par11 )% And %Exp:DtoS( mv_par12 )%
		And SC7.C7_TIPO In %Exp:_cInTpPC%
		And %Exp:_cWhereQUJE%
		And SC7.C7_CONAPRO In %Exp:_cInBlq%
		And SC7.C7_RESIDUO In %Exp:_cInResiduo%
		And SC7.C7_EMITIDO In %Exp:_cInEmitido%
		And SC7.%NotDel%
		And SA2.A2_COD = SC7.C7_FORNECE
		And SA2.A2_LOJA = SC7.C7_LOJA
		And SA2.A2_FILIAL = %xFilial:SA2%
		And SA2.%NotDel%
		And SB1.B1_COD = SC7.C7_PRODUTO
		And SB1.%NotDel%
		And SBM.BM_GRUPO = SB1.B1_GRUPO
		And SBM.%NotDel%
		And SE4.E4_CODIGO = SC7.C7_COND
		And SE4.%NotDel%
		And SC1.C1_FILIAL = SC7.C7_FILIAL
		And SC1.C1_NUM = SC7.C7_NUMSC
		And SC1.C1_ITEM = SC7.C7_ITEMSC
		And SC1.%NotDel%
		And SY1.Y1_USER = SC7.C7_USER
     	And SY1.Y1_FILIAL = SC7.C7_FILIAL
     	And SY1.%NotDel%
	Order By
		SC7.C7_FILIAL,
		SC7.C7_NUM,
		SC7.C7_ITEM
EndSQL
		
oSection1:Init()
oSection1:SetHeaderSection(.T.)

dbSelectArea( _cAliasQRY )
oReport:SetMeter( QRY->( RecCount() ) )

( _cAliasQRY )->( dbGoTop() )

While ( _cAliasQRY )->( !Eof() )

	_dDataProjecao := Iif( Empty( AllTrim( StrTran( ( _cAliasQRY )->Data_Ent_pFin, "/", "" ) ) ), CtoD( ( _cAliasQRY )->Data_Entrega ), CtoD( ( _cAliasQRY )->Data_Ent_pFin ) ) 
 
	If oReport:Cancel()
		Exit
	EndIf
 
	oReport:IncMeter()
 
	oSection1:Cell( "Filial" ):SetValue( ( _cAliasQRY )->Filial )
	oSection1:Cell( "Filial" ):SetAlign( "CENTER" )

	oSection1:Cell( "Fornecedor" ):SetValue( ( _cAliasQRY )->Fornecedor )
	oSection1:Cell( "Fornecedor" ):SetAlign( "LEFT" )

	oSection1:Cell( "Loja" ):SetValue( ( _cAliasQRY )->Loja )
	oSection1:Cell( "Loja" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Nome" ):SetValue( ( _cAliasQRY )->Nome )
	oSection1:Cell( "Nome" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Telefone" ):SetValue( ( _cAliasQRY )->Telefone )
	oSection1:Cell( "Telefone" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "UF" ):SetValue( ( _cAliasQRY )->UF )
	oSection1:Cell( "UF" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Numero_PC" ):SetValue( ( _cAliasQRY )->Numero_PC )
	oSection1:Cell( "Numero_PC" ):SetAlign( "LEFT" )

	oSection1:Cell( "CCUSTO" ):SetValue( ( _cAliasQRY )->CCUSTO )
	oSection1:Cell( "CCUSTO" ):SetAlign( "LEFT" )

	oSection1:Cell( "Item_PC" ):SetValue( ( _cAliasQRY )->Item_PC )
	oSection1:Cell( "Item_PC" ):SetAlign( "LEFT" )

	oSection1:Cell( "Numero_SC" ):SetValue( ( _cAliasQRY )->Numero_SC )
	oSection1:Cell( "Numero_SC" ):SetAlign( "LEFT" )

	oSection1:Cell( "USUARIO" ):SetValue( ( _cAliasQRY )->USUARIO )
	oSection1:Cell( "USUARIO" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Produto" ):SetValue( ( _cAliasQRY )->Produto )
	oSection1:Cell( "Produto" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Descricao" ):SetValue( ( _cAliasQRY )->Descricao )
	oSection1:Cell( "Descricao" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Observacoes" ):SetValue( ( _cAliasQRY )->Observacoes )
	oSection1:Cell( "Observacoes" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Grupo" ):SetValue( ( _cAliasQRY )->Grupo )
	oSection1:Cell( "Grupo" ):SetAlign( "LEFT" )

	oSection1:Cell( "Descricao" ):SetValue( ( _cAliasQRY )->Descricao )
	oSection1:Cell( "Descricao" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Emissao" ):SetValue( ( _cAliasQRY )->Emissao )
	oSection1:Cell( "Emissao" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Data_Entrega" ):SetValue( ( _cAliasQRY )->Data_Entrega )
	oSection1:Cell( "Data_Entrega" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Data_Ent_pFin" ):SetValue( ( _cAliasQRY )->Data_Ent_pFin )
	oSection1:Cell( "Data_Ent_pFin" ):SetAlign( "LEFT" )

	oSection1:Cell( "Quantidade" ):SetValue( ( _cAliasQRY )->Quantidade )
	oSection1:Cell( "Quantidade" ):SetAlign( "RIGHT" )

	oSection1:Cell( "UM" ):SetValue( ( _cAliasQRY )->UM )
	oSection1:Cell( "UM" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Preco_Unitario" ):SetValue( ( _cAliasQRY )->Preco_Unitario )
	oSection1:Cell( "Preco_Unitario" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Desconto_01" ):SetValue( ( _cAliasQRY )->Desconto_01 )
	oSection1:Cell( "Desconto_01" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Desconto_02" ):SetValue( ( _cAliasQRY )->Desconto_02 )
	oSection1:Cell( "Desconto_02" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Desconto_03" ):SetValue( ( _cAliasQRY )->Desconto_03 )
	oSection1:Cell( "Desconto_03" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Aliquota_IPI" ):SetValue( ( _cAliasQRY )->Aliquota_IPI )
	oSection1:Cell( "Aliquota_IPI" ):SetAlign( "RIGHT" )

	oSection1:Cell( "Valor_IPI" ):SetValue( ( _cAliasQRY )->Valor_IPI )
	oSection1:Cell( "Valor_IPI" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Total_Pedido" ):SetValue( ( _cAliasQRY )->Total_Pedido )
	oSection1:Cell( "Total_Pedido" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Qtd_Entregue" ):SetValue( ( _cAliasQRY )->Qtd_Entregue )
	oSection1:Cell( "Qtd_Entregue" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Qtd_a_Receber" ):SetValue( ( _cAliasQRY )->Qtd_a_Receber )
	oSection1:Cell( "Qtd_a_Receber" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Saldo_a_Receber_sem_IPI" ):SetValue( ( _cAliasQRY )->Saldo_a_Receber_sem_IPI )
	oSection1:Cell( "Saldo_a_Receber_sem_IPI" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Saldo_a_Receber_com_IPI" ):SetValue( ( _cAliasQRY )->Saldo_a_Receber_com_IPI )
	oSection1:Cell( "Saldo_a_Receber_com_IPI" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Residuo" ):SetValue( ( _cAliasQRY )->Residuo )
	oSection1:Cell( "Residuo" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Aprovacao" ):SetValue( ( _cAliasQRY )->Aprovacao )
	oSection1:Cell( "Aprovacao" ):SetAlign( "LEFT" )

	oSection1:Cell( "Emitido" ):SetValue( ( _cAliasQRY )->Emitido )
	oSection1:Cell( "Emitido" ):SetAlign( "LEFT" )

	oSection1:Cell( "Comprador" ):SetValue( ( _cAliasQRY )->Comprador )
	oSection1:Cell( "Comprador" ):SetAlign( "LEFT" )

	oSection1:Cell( "Cod_Segmento" ):SetValue( ( _cAliasQRY )->Cod_Segmento )
	oSection1:Cell( "Cod_Segmento" ):SetAlign( "LEFT" )
	
	/*
	oSection1:Cell( "Segmento" ):SetValue( ( _cAliasQRY )->Segmento )
	oSection1:Cell( "Segmento" ):SetAlign( "LEFT" )
	*/

	oSection1:Cell( "Cond_Pagamento" ):SetValue( ( _cAliasQRY )->Cond_Pagamento )
	oSection1:Cell( "Cond_Pagamento" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Descricao_Cond" ):SetValue( ( _cAliasQRY )->Descricao_Cond )
	oSection1:Cell( "Descricao_Cond" ):SetAlign( "LEFT" )

	_aParcelas := Condicao( ( _cAliasQRY )->Saldo_a_Receber_com_IPI, ( _cAliasQRY )->Cond_Pagamento,, _dDataProjecao )

	oSection1:Cell( "Data_Parcela_01" ):SetValue( Iif( Len( _aParcelas ) >= 01, _aParcelas[ 01 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_01" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Valor_Parcela_01" ):SetValue( Iif( Len( _aParcelas ) >= 01, _aParcelas[ 01 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_01" ):SetAlign( "RIGHT" )

	oSection1:Cell( "Data_Parcela_02" ):SetValue( Iif( Len( _aParcelas ) >= 02, _aParcelas[ 02 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_02" ):SetAlign( "LEFT" )

	oSection1:Cell( "Valor_Parcela_02" ):SetValue( Iif( Len( _aParcelas ) >= 02, _aParcelas[ 02 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_02" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_03" ):SetValue( Iif( Len( _aParcelas ) >= 03, _aParcelas[ 03 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_03" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Valor_Parcela_03" ):SetValue( Iif( Len( _aParcelas ) >= 03, _aParcelas[ 03 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_03" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_04" ):SetValue( Iif( Len( _aParcelas ) >= 04, _aParcelas[ 04 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_04" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Valor_Parcela_04" ):SetValue( Iif( Len( _aParcelas ) >= 04, _aParcelas[ 04 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_04" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_05" ):SetValue( Iif( Len( _aParcelas ) >= 05, _aParcelas[ 05 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_05" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Valor_Parcela_05" ):SetValue( Iif( Len( _aParcelas ) >= 05, _aParcelas[ 05 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_05" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_06" ):SetValue( Iif( Len( _aParcelas ) >= 06, _aParcelas[ 06 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_06" ):SetAlign( "LEFT" )
		
	oSection1:Cell( "Valor_Parcela_06" ):SetValue( Iif( Len( _aParcelas ) >= 06, _aParcelas[ 06 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_06" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_07" ):SetValue( Iif( Len( _aParcelas ) >= 07, _aParcelas[ 07 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_07" ):SetAlign( "LEFT" )
		
	oSection1:Cell( "Valor_Parcela_07" ):SetValue( Iif( Len( _aParcelas ) >= 07, _aParcelas[ 07 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_07" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_08" ):SetValue( Iif( Len( _aParcelas ) >= 08, _aParcelas[ 08 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_08" ):SetAlign( "LEFT" )
		
	oSection1:Cell( "Valor_Parcela_08" ):SetValue( Iif( Len( _aParcelas ) >= 08, _aParcelas[ 08 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_08" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_09" ):SetValue( Iif( Len( _aParcelas ) >= 09, _aParcelas[ 09 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_09" ):SetAlign( "LEFT" )
		
	oSection1:Cell( "Valor_Parcela_09" ):SetValue( Iif( Len( _aParcelas ) >= 09, _aParcelas[ 09 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_09" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_10" ):SetValue( Iif( Len( _aParcelas ) >= 10, _aParcelas[ 10 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_10" ):SetAlign( "LEFT" )
	
	oSection1:Cell( "Valor_Parcela_10" ):SetValue( Iif( Len( _aParcelas ) >= 10, _aParcelas[ 10 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_10" ):SetAlign( "RIGHT" )
	
	oSection1:Cell( "Data_Parcela_11" ):SetValue( Iif( Len( _aParcelas ) >= 11, _aParcelas[ 11 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_11" ):SetAlign( "LEFT" )
		
	oSection1:Cell( "Valor_Parcela_11" ):SetValue( Iif( Len( _aParcelas ) >= 11, _aParcelas[ 11 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_11" ):SetAlign( "RIGHT" )

	oSection1:Cell( "Data_Parcela_12" ):SetValue( Iif( Len( _aParcelas ) >= 12, _aParcelas[ 12 ][ 01 ], "" ) )
	oSection1:Cell( "Data_Parcela_12" ):SetAlign( "LEFT" )
		
	oSection1:Cell( "Valor_Parcela_12" ):SetValue( Iif( Len( _aParcelas ) >= 12, _aParcelas[ 12 ][ 02 ], 00 ) )
	oSection1:Cell( "Valor_Parcela_12" ):SetAlign( "RIGHT" )	
 
	oSection1:Cell( "em_Pre-Nota" ):SetValue( fRetPreNota( ( _cAliasQRY )->Filial, ( _cAliasQRY )->Numero_PC, ( _cAliasQRY )->Fornecedor, ( _cAliasQRY )->Loja ) )
	oSection1:Cell( "em_Pre-Nota" ):SetAlign( "LEFT" )

	oSection1:PrintLine()
 
	( _cAliasQRY )->( dbSkip() )

EndDo

oSection1:Finish()

( _cAliasQRY )->( dbCloseArea() )

Return ( Nil )

/*/{Protheus.doc} fRetPreNota
Retorna se o pedido esta em pre-nota
@type function
@version  
@author Administrator
@since 06/04/2022
@param _cFilial, variant, filial
@param _cPedido, variant, pedido de compras
@param _cFornece, variant, fornecedor
@param _cLoja, variant, loja do fornecedor
@return variant, _cemPreNota
/*/
Static Function fRetPreNota( _cFilial, _cPedido, _cFornece, _cLoja )

/* Variaveis Locais */
Local _aArea		:= GetArea()
Local _cemPreNota	:= ""
Local _cAliasSF1	:= GetNextAlias()

/* Seleciona registros */
BeginSQL Alias _cAliasSF1
	Select 
		SF1.F1_STATUS As EmPreNota
	From
		%Table:SD1% SD1,
		%Table:SF1% SF1
	Where SD1.D1_PEDIDO = %Exp:AllTrim( _cPedido )%
		And SD1.D1_FORNECE = %Exp:AllTrim( _CFornece )%
		And SD1.D1_LOJA = %Exp:AllTrim( _cLoja )%
		And SD1.D1_FILIAL = %Exp:AllTrim( _cFilial )%
		And SD1.%NotDel%
		And SF1.F1_DOC = SD1.D1_DOC
		ANd SF1.F1_SERIE = SD1.D1_SERIE
		And SF1.F1_FORNECE = SD1.D1_FORNECE
		And SF1.F1_LOJA = SD1.D1_LOJA
		And SF1.F1_FILIAL = SD1.D1_FILIAL
		ANd SF1.%NotDel%
EndSQL

If !Empty(( _cAliasSF1 )->EmPreNota)
	_cemPreNota := 'EM DOCUMENTO DE ENTRADA'
ElseIf Empty(( _cAliasSF1 )->EmPreNota)	
	_cemPreNota := 'EM PRÉ-NOTA'
EndIf	

( _cAliasSF1 )->( dbCloseArea() )


If Empty(_cemPreNota)
	_cemPreNota := 'SEM PRÉ-NOTA'
EndIf


RestArea( _aArea )

Return ( _cemPreNota )

/*/{Protheus.doc} UpdDtPrFin
Efetua atualizacao das datas de previsao de entrega financeira
@type function
@version 12.1.33
@author Administrator
@since 07/04/2022
@return variant, Nil
/*/
User Function UpdDtPrFin()

/* Variaveis Locais */
Local _aArea	:= GetArea()
Local _cQryUpd	:= ""

/* Efetua atualizacao */
_cQryUpd	:= "Update "
_cQryUpd	+= RetSQLName( "SC7" ) + " " 
_cQryUpd	+= "Set C7_ZZDATPR = C7_DATPRF " 
_cQryUpd	+= "Where C7_ZZDATPR = '' "
_cQryUpd	+= "And D_E_L_E_T_ = ' ' "

TcSqlExec( _cQryUpd )

/* Restaura ponteiros */
RestArea( _aArea )

Return ( Nil )

/*/{Protheus.doc} ValidPerg
Cria/ajusta perguntas
@type function
@version  
@author celso
@since 11/03/2022
@param _cPerg, variant, param_description
@return variant, return_description
/*/
Static Function ValidPerg( _cPerg )

/* Variaveis Locais */
Local	_aArea	:= GetArea()
Local _aRegs	:= {}
Local i			:= 00
Local j			:= 00

/* Valida/Cria perguntes */
dbSelectArea( "SX1" )
Sx1->( dbSetOrder( 01 ) )

_cPerg := PadR( _cPerg, Len( SX1->X1_GRUPO ) )

aAdd(_aRegs, { _cPerg, "01", "Filial de"					,"" ,"" ,"mv_ch1", "C", 04, 0, 0, "G", "", "mv_par01", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "02", "Filial ate"					,"" ,"" ,"mv_ch2", "C", 04, 0, 0, "G", "", "mv_par02", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "03", "Produto de"					,"" ,"" ,"mv_ch3", "C", 15, 0, 0, "G", "", "mv_par03", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"	} )
aAdd(_aRegs, { _cPerg, "04", "Produto ate"				,"" ,"" ,"mv_ch4", "C", 15, 0, 0, "G", "", "mv_par04", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"	} )
aAdd(_aRegs, { _cPerg, "05", "Fornecedor de"				,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"	} )
aAdd(_aRegs, { _cPerg, "06", "Fornecedor ate"			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"	} )
aAdd(_aRegs, { _cPerg, "07", "Dt. Emissao de"			,"" ,"" ,"mv_ch7", "D", 08, 0, 0, "G", "", "mv_par07", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "08", "Dt. Emissao ate"			,"" ,"" ,"mv_ch8", "D", 08, 0, 0, "G", "", "mv_par08", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "09", "Dt. Entrega de"			,"" ,"" ,"mv_ch9", "D", 08, 0, 0, "G", "", "mv_par09", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "10", "Dt. Entrega ate"			,"" ,"" ,"mv_cha", "D", 08, 0, 0, "G", "", "mv_par10", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "11", "Dt.Entr. prj.Fin. de"	,"" ,"" ,"mv_chb", "D", 08, 0, 0, "G", "", "mv_par11", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "12", "Dt.Entr. prj.Fin. ate"	,"" ,"" ,"mv_chc", "D", 08, 0, 0, "G", "", "mv_par12", ""							, "", "", "", "", ""									, "", "", "", "", ""			, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "13", "Tipo"							,"" ,"" ,"mv_chd", "N", 01, 0, 0, "C", "", "mv_par13", "Ped. Compras"			, "", "", "", "", "Aut. Entregas"				, "", "", "", "", "Ambos"	, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "14", "Saldo a receber"			,"" ,"" ,"mv_che", "N", 01, 0, 0, "C", "", "mv_par14", "MenorIgual Zero"		, "", "", "", "", "Maior que zero"				, "", "", "", "", "Ambos"	, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "15", "Aprovacao do PC/AE"		,"" ,"" ,"mv_chf", "N", 01, 0, 0, "C", "", "mv_par15", "Liberados"				, "", "", "", "", "Bloqueados"					, "", "", "", "", "Ambos"	, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "16", "Eliminado residuo"		,"" ,"" ,"mv_chg", "N", 01, 0, 0, "C", "", "mv_par16", "Sim"						, "", "", "", "", "Nao"								, "", "", "", "", "Ambos"	, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )
aAdd(_aRegs, { _cPerg, "17", "Emitido"						,"" ,"" ,"mv_chh", "N", 01, 0, 0, "C", "", "mv_par17", "Sim"						, "", "", "", "", "Nao"								, "", "", "", "", "Ambos"	, "", "", "", "", "", "", "", "", "", "", "", "", "", ""		} )

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
