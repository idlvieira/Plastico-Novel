#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#DEFINE CRLF chr(13) + chr(10) 

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Relatorio de Orcamentos - Tabelas SUA e SUB    
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
user function MYTMK01

local oReport
local cPerg  := 'MYTMK01'
local cAlias := getNextAlias()

criaSx1(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cAlias, cPerg)

oReport:printDialog()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatorio de Orcamentos por Vendedor"
local cHelp   := "Permite gerar relatório orcamentos por cliente."
Local aOrdem  := {"Codigo Vendedor", "Nome do Vendendor"}

local oReport
local oSection1
local oSection2
local oBreak1

oReport	:= TReport():New('MYTMK01',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetPortrait()

//Primeira seção
oSection1 := TRSection():New(oReport,"Vendedor",{"SA3"},aOrdem)    

TRCell():New(oSection1,"A3_COD", "SA3", "Cod.Vend.")
TRCell():New(oSection1,"A3_NOME", "SA3", "Nome")   
   

//Segunda seção
oSection2:= TRSection():New(oSection1,"Itens Orcamento",{"SUB"})
        
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,"UB_FILIAL", "SUB", "Filial")
TRCell():New(oSection2,"A3_COD", "SA3", "Cod.Vendedor")
TRCell():New(oSection2,"A3_NOME", "SA3", "Vendedor")    
TRCell():New(oSection2,"UA_CLIENTE", "SUA", "Cliente")   
TRCell():New(oSection2,"UA_LOJA", "SUA", "Loja")
TRCell():New(oSection2,"UA_NUM", "SUA", "Orcamento")   
TRCell():New(oSection2,"UA_EMISSAO", "SUA", "Emissao")  
TRCell():New(oSection2,"UA_OPER", "SUA", "Operacao")
TRCell():New(oSection2,"UB_PRODUTO", "SUB", "Produto")
TRCell():New(oSection2,"B1_DESC", "SB1", "Descricao")
TRCell():New(oSection2,"UB_QUANT", "SUB", "Quant.")
TRCell():New(oSection2,"UB_VRUNIT", "SUB", "Vlr. Unit.")
TRCell():New(oSection2,"UB_VLRITEM", "SUB", "Vlt. Total")


//Totalizador por cliente
oBreak1 := TRBreak():New(oSection2,{|| (cAlias)->(A3_COD) },"Total:",.F.)                   
TRFunction():New(oSection2:Cell("UB_QUANT" ), "TOT1", "SUM", oBreak1,,,, .F., .F.)
TRFunction():New(oSection2:Cell("UB_VLRITEM" ), "TOT2", "SUM", oBreak1,,,, .F., .F.)

Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)

local oSection1b := oReport:Section(1)
local oSection2b := oReport:Section(1):Section(1)  
local cOrdem  

if oReport:Section(1):GetOrder() == 1
	cOrdem := "A3_COD" 
else
	cOrdem := "A3_NOME"
endif
             
oSection1b:BeginQuery()

BeginSQL Alias cAlias
	
	Column UA_EMISSAO as Date
	
	SELECT 	UB_FILIAL, A3_COD, A3_NOME,UA_CLIENTE, UA_LOJA, UA_NUM, UA_EMISSAO, 
	UA_OPER, UB_PRODUTO, B1_DESC, UB_QUANT, UB_VRUNIT, UB_VLRITEM
	FROM %Table:SUA% SUA
	
	INNER JOIN %Table:SUB% SUB
	ON UA_FILIAL = UB_FILIAL
	AND UA_NUM = UB_NUM
	AND SUB.%NotDel%
	
	INNER JOIN %Table:SB1% SB1
	ON B1_FILIAL = %xFilial:SB1%
	AND B1_COD = UB_PRODUTO
	AND SB1.%NotDel%
	
   /*	INNER JOIN %Table:SA1% SA1
    ON A1_FILIAL = %xFilial:SA1%
    AND A1_COD = UA_CLIENTE
	AND A1_LOJA = UA_LOJA
	AND SA1.%NotDel%      */
	
	INNER JOIN %Table:SA3% SA3
	ON A3_FILIAL = %xFilial:SA3%
	AND A3_COD = UA_VEND
	AND SA3.%NotDel%
	
	
	WHERE UA_VEND BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%    
	AND UA_EMISSAO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	AND UB_PRODUTO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	
	ORDER BY %Exp:cOrdem%
EndSQL 

oSection1b:EndQuery()    
oSection2b:SetParentQuery()

oReport:SetMeter((cAlias)->(RecCount()))  

oSection2b:SetParentFilter({|cParam| (cAlias)->A3_COD == cParam}, {|| (cAlias)->A3_COD})

oSection1b:Print()	   

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Vendendor de?'       , '', '', 'mv_ch1', 'C', TAMSX3("A3_COD")[1], 0, 0, 'G', '', 'SA3', '', '', 'mv_par01')
putSx1(cPerg, '02', 'Vendendor até?'      , '', '', 'mv_ch2', 'C', TAMSX3("A3_COD")[1], 0, 0, 'G', '', 'SA3', '', '', 'mv_par02')
putSx1(cPerg, '03', 'Produto de?'         , '', '', 'mv_ch3', 'C', TAMSX3("B1_COD")[1]   , 0, 0, 'G', '', 'SB1', '', '', 'mv_par03')
putSx1(cPerg, '04', 'Produto até?'        , '', '', 'mv_ch4', 'C', TAMSX3("B1_COD")[1]   , 0, 0, 'G', '', 'SB1', '', '', 'mv_par04')
putSx1(cPerg, '05', 'Data de?'            , '', '', 'mv_ch5', 'D', 8                     , 0, 0, 'G', '', ''   , '', '', 'mv_par05')
putSx1(cPerg, '06', 'Data até?'           , '', '', 'mv_ch6', 'D', 8                     , 0, 0, 'G', '', ''   , '', '', 'mv_par06')

return    


   



                   
/*
         
oSection1b:Init()    
  
TRCell():New(oSection1,"MEUCAMPO", "", "TESTE")

while !(cAlias)->(Eof())
	oSection1b:Cell("MEUCAMPO"):SetValue("SONIA")
	oSection1b:PrintLine() 
                   
	oSection2b:Init()
	cCliCod := (cAlias)->A1_COD
	while !(cAlias)->(Eof()) .AND. cCliCod == (cAlias)->A1_COD
		oReport:IncMeter() 	  
		
		oSection2b:PrintLine() 			
		 
		(cAlias)->(DbSkip())
	enddo  
	oSection2b:Finish()
enddo 

oSection1b:Finish()

*/