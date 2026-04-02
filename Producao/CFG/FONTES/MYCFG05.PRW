#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MYCFG05  ºAutor  ³ Carlos H. de Lima  º Data ³  20/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geração do arquivo TXT para o cadastro de Produtos.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENÉRICO.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MYCFG05()
  Local cNameFil := "cifmdb3.txt"
  Local oFilTXT
  Local cQuery
  Local oFTP
  Local oEmail
  Local cTexto := ""        
  Local cLinha := ""

   
  oFilTXT  := GRVTXT():New( cNameFil )
  If !(oFilTXT:CRIARTXT())
    Return
  Endif       
  
  dbSelectArea("SB1") 
   
  cQuery := " SELECT "
  cQuery += "   B1_COD, B1_CODBAR, B1_POSIPI, B1_IPI, B1_UM, B1_DESC, B1_PRVALID "
  cQuery += " FROM "
  cQuery += "   "+ RetSQLName("SB1") +" "
  cQuery += " WHERE "
  cQuery += "   B1_FILIAL = '"+ xFILIAL("SB1") +"' AND D_E_L_E_T_ = ' ' "
  cQuery += " ORDER BY "
  cQuery += "   B1_COD"
  TcQuery cQuery Alias TSB1 New
  TSB1->(dbGoTop())
  While !(TSB1->(EOF()))

    /* 
	********************************************************************************************************
	** NewAge Sotware S/A | Layout para Importação de Produtos	 						                  **
	********************************************************************************************************
	* Descrição							Obr.TpTam			Observação			
	* Código do Produto NewAge				C 18	001	018	Informar o Código interno usado pela Bandag. Não existindo informar brancos.
	* Código do Fabricante do Produto	Sim	C 30	019	048	Informar o Código existente na Guia Fabricantes ou Código interno usado pelo Fornecedor
	* Código do Produto no Fabricante	Sim	C 50	049	098	Informar o Código do Produto usado pelo Fabricante para identifcar o Produto. O código deve ser único.
	* CNPJ do Fornecedor				Sim	C 18	099	116	Informar o CNPJ do Fornecedor com ou sem máscara
	* Código do Produto no Fornecedor	Sim	C 20	117	136	Informar o Código do Produto usado pelo Fornecedor para identificar o Produto. O código deve ser único.
	* Código EAN (Código Barras)			C 22	137	158	Informar o Código de Barras do Produto usado pelo Fornecedor
	* Código Estruturado do Produto			C 40	159	198	Informar o Código Estruturado do Produto usado pelo Fornecedor
	* Código da Montadora					C 30	199	228	Informar o Código existente na Guia Montadoras ou Código interno usado pelo Fornecedor
	* Código do Produto na Montadora		C 50	229	278	Informar o Código original usado pela Montadora
	* Código da Classificação do ProdutoSim	C 1		279	279	Informar P para Produto ou E para Serviço
	* Código da Família do Produto		Sim	C 30	280	309	Código existente na Guia Família ou Código interno usado pelo Fornecedor
	* NCM do Produto					Sim	C 12	310	321	Informar Nomenclatura Comum do Mercosul
	* IPI do Produto					Sim	N 5,2	322	326	Informar o IPI do Produto no formato: 99.99
	* Classificação ICMS do Produto		Sim	C 5		327	331	Informar 1 para Normal (Tributado) ou 2 para Isento
	* Unidade de Venda ao Usuário Final	Sim	C 6		332	337	Informar a Unidade que o BTS usa para vender o produto para os seus Clientes
	* Unidade de Compra da BTS no Forn.	Sim	C 6		338	343	Informar a Unidade que o Fornecedor usa para vender seus produtos para o BTS
	* Quantidade da Un. de Compra da BTSSim	N 12,2	344	355	Informar o Fator de Conversão entre as Unidades. Se unidades iguais então informar 1. Formato: 999999999.99
	* Descrição do Produto				Sim	C 70	356	425	Informar a descrição do Produto. Deve ser única dentre todas as decrições dos produtos do Fornecedor
	* Descrição Longa do Produto			C 150	426	575	Informar a Descrição detalhada do Produto
	* Observação 1 (Montadora)				C 150	576	725	Informar as Montadoras para as quais o Produto se aplica (se mais de uma separar por vírgula)
	* Observação 2 (Veículo)				C 150	726	875	Veículos para os quais o Produto pode ser aplicado (se mais de um separar por vírgula)
	* Validade em Km (Garantia em km)		N 10	876	885	Validade em Km do Produto
	* Validade em Dias (Garan. em dias)	Sim	N 4		886	889	Validade em dias do Produto. Pelo menos 90 dias (regra de mercado para a Bandag)
	* Desabilitado S/N					Sim	C 1		890	890	Informar N         Se desejar desabilitar um produto enviando anteriormente informar S
	* Homologado S/N					Sim	C 1		891	891	Informar S
	********************************************************************************************************
	* Observações:
	* -Gravar um registro por linha em um arquivo no formato texto
	* -Campos caractere devem ser alinhados à esquerda e devem ser completados com espaços à direita
	* -Campos numéricos devem seguir o formato proposto com ponto separando a parte inteira da parte decimal
	* -Campos devem devem seguir o formado DD/MM/AAAA (Dia/Mês/Ano) ou ser informado em branco                 
	********************************************************************************************************	
    */   

	cLinha := Space(18)                         //Código do Produto NewAge
//	cLinha +=                                   //Código do Fabricante do Produto
//	cLinha +=                                   //Código do Produto no Fabricante
	cLinha += SM0->M0_CGC                       //CNPJ do Fornecedor
	cLinha += TSB1->B1_COD + Space(35)          //Código do Produto no Fornecedor
	cLinha += TSB1->B1_CODBAR + Space(7)        //Código EAN (Código Barras)
	cLinha += Space(40)                         //Código Estruturado do Produto
	cLinha += Space(30)                         //Código da Montadora
	cLinha += Space(50)                         //Código do Produto na Montadora
	cLinha += "P"                               //Código da Classificação do Produto
//  cLinha +=                                   //Código da Família do Produto
	cLinha += TSB1->B1_POSIPI + Space(2)        //NCM do Produto
	cLinha += Transform(TSB1->B1_IPI,"@E 99.99")//IPI do Produto
	cLinha += "1" + Space(4)                    //Classificação ICMS do Produto
	cLinha += TSB1->B1_UM + Space(4)            //Unidade de Venda ao Usuário Final
	cLinha += TSB1->B1_UM + Space(4)            //Unidade de Compra da BTS no Fornecedor
	cLinha += Transform(1,"@E 999999999.99")    //Quantidade da Unidade de Compra da BTS
	cLinha += TSB1->B1_DESC + Space(20)         //Descrição do Produto
	cLinha += Space(150)                        //Descrição Longa do Produto
	cLinha += Space(150)                        //Observação 1 (Montadora)
	cLinha += Space(150)                        //Observação 2 (Veículo)
	cLinha += Space(10)                         //Validade em Km (Garantia em km)
	cLinha += Transform(TSB1->B1_PRVALID,"@E 9999")//Validade em Dias (Garantia em dias)
//	cLinha +=                                   //Desabilitado S/N
	cLinha += "S"                               //Homologado S/N

    oFilTXT:INCLINHA( cLinha )   

    TSB1->(dbSkip())
  Enddo
  TSB1->(dbCloseArea())
  
  If !(oFilTXT:FECHATXT())
    Return
  Endif

RETURN