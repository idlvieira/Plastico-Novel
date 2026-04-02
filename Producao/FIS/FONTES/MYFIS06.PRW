#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MYFIS06   ºAutor  ³ Sonia Silva        º Data ³ 17-01-17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Conferencia CIAP                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Departamento Fiscal                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MYFIS06()
 Local oReport
 Private cPerg :=  "MYFIS06"
 ValidPerg(@cPerg)   
 Pergunte(cPerg,.t.)
 oReport:= ReportDef()
 oReport:PrintDialog()
 
Return

Static Function ReportDef()
Local cAlias:= GetNextAlias()
Local cTitle   := "Relacao de Conferencia CIAP"
Local oReport 
Local oSection1
Private SALDO:=0  

oReport := tReport():New(cPerg,cTitle,cPerg,{ |oReport| ReportPrint(@oReport, cAlias) } , cTitle )
oReport:SetPortrait(.t.) // Retrato
//oReport:SetLandscape(.t.) // Paisagem

oSection1:= TRSection():New(oReport,"Relacao de Conferencia CIAP",{"SF9"},/*aOrdem*/)
oSection1:SetHeaderPage(.T.)            

TRCell():New(oSection1,"DATADIG"        ,,"DATADIG",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"CODIGO"			,,"CODIGO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DESCRI"			,,"DESCRI",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"FORNECE"		,,"FORNECE",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"LOJAFOR"		,,"LOJAFOR",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DOCNFE"			,,"DOCNFE",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"SERINFE"		,,"SERINFE",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"PROPRIO"		,,"PROPRIO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"DATANFE"		,,"DATANFE",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CLIENTE"		,,"CLIENTE",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"LOJACLI"		,,"LOJACLI",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"DOCNFS"			,,"DOCNFS",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"SERINFS"		,,"SERINFS",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"DATANFS"		,,"DATANFS",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"MOTIVO"			,,"MOTIVO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"VALICMS"		,,"VALICMS",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"CFOP"			,,"CFOP",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
//TRCell():New(oSection1,"ICMS"			,,"ICMS",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"ICMIMOB"		,,"ICMIMOB",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"ESTORNO"		,,"ESTORNO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"SALDO"			,,"SALDO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"BAIXADO"		,,"BAIXADO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"FATOR"			,,"FATOR",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"PARCELAS"		,,"PARCELAS",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"SLDPARCELA"		,,"SLDPARCELA",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"BXPARCIAL"		,,"BXPARCIAL",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"FUNCAO"			,,"FUNCAO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"TIPO"			,,"TIPO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"PRINCIPAL"		,,"PRINCIPAL",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"ICMCOMP"		,,"ICMCOMP",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"ICMST"			,,"ICMST",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"ICMFRT"			,,"ICMFRT",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"ICMPROP"		,,"ICMPROP",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"DATAINI"		,,"DATAINI",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"DEBATIVO"		,,"DEBATIVO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 

oSection1:Cell("DATADIG"	):SetBlock({ || (cAlias)->DATADIG})
oSection1:Cell("CODIGO"		):SetBlock({ || (cAlias)->CODIGO})    
oSection1:Cell("DESCRI"		):SetBlock({ || (cAlias)->DESCRI})
oSection1:Cell("FORNECE"	):SetBlock({ || (cAlias)->FORNECE})
oSection1:Cell("LOJAFOR"	):SetBlock({ || (cAlias)->LOJAFOR})
oSection1:Cell("DOCNFE"		):SetBlock({ || (cAlias)->DOCNFE})
oSection1:Cell("SERINFE"	):SetBlock({ || (cAlias)->SERINFE})
oSection1:Cell("PROPRIO"	):SetBlock({ || (cAlias)->PROPRIO})
oSection1:Cell("DATANFE"	):SetBlock({ || (cAlias)->DATANFE})
oSection1:Cell("CLIENTE"	):SetBlock({ || (cAlias)->CLIENTE})
oSection1:Cell("LOJACLI"	):SetBlock({ || (cAlias)->LOJACLI})
oSection1:Cell("DOCNFS"		):SetBlock({ || (cAlias)->DOCNFS})
oSection1:Cell("SERINFS"	):SetBlock({ || (cAlias)->SERINFS})
oSection1:Cell("DATANFS"	):SetBlock({ || (cAlias)->DATANFS})
oSection1:Cell("MOTIVO"		):SetBlock({ || (cAlias)->MOTIVO})
oSection1:Cell("VALICMS"	):SetBlock({ || (cAlias)->VALICMS})
oSection1:Cell("CFOP"		):SetBlock({ || (cAlias)->CFOP})
//oSection1:Cell("ICMS"		):SetBlock({ || (cAlias)->ICMS})
oSection1:Cell("ICMIMOB"	):SetBlock({ || (cAlias)->ICMIMOB})
oSection1:Cell("ESTORNO"	):SetBlock({ || (cAlias)->ESTORNO})
oSection1:Cell("SALDO"		):SetBlock({ || SALDO})
oSection1:Cell("BAIXADO"	):SetBlock({ || (cAlias)->BAIXADO})
oSection1:Cell("FATOR"		):SetBlock({ || (cAlias)->FATOR})
oSection1:Cell("PARCELAS"	):SetBlock({ || (cAlias)->PARCELAS})
oSection1:Cell("SLDPARCELA"	):SetBlock({ || (cAlias)->SLDPARCELA})
oSection1:Cell("BXPARCIAL"	):SetBlock({ || (cAlias)->BXPARCIAL})
oSection1:Cell("FUNCAO"		):SetBlock({ || (cAlias)->FUNCAO})
oSection1:Cell("TIPO"		):SetBlock({ || (cAlias)->TIPO})
oSection1:Cell("PRINCIPAL"	):SetBlock({ || (cAlias)->PRINCIPAL})
oSection1:Cell("ICMCOMP"	):SetBlock({ || (cAlias)->ICMCOMP})
oSection1:Cell("ICMST"		):SetBlock({ || (cAlias)->ICMST})
oSection1:Cell("ICMFRT"		):SetBlock({ || (cAlias)->ICMFRT})
oSection1:Cell("ICMPROP"	):SetBlock({ || (cAlias)->ICMPROP})
oSection1:Cell("DATAINI"	):SetBlock({ || (cAlias)->DATAINI})
oSection1:Cell("DEBATIVO"	):SetBlock({ || (cAlias)->DEBATIVO})

RETURN (oReport)

STATIC FUNCTION ReportPrint(oReport, cAlias)

oReport:Section(1):BeginQuery()

BeginSQL Alias cAlias                                   

SELECT 
	F9_FILIAL,
	F9_DTENTNE AS DATADIG,
	F9_CODIGO AS CODIGO, 
	F9_DESCRI AS DESCRI, 
	F9_FORNECE AS FORNECE, 
	F9_LOJAFOR AS LOJAFOR, 
	F9_DOCNFE AS DOCNFE, 
	F9_SERNFE AS SERINFE, 
	F9_PROPRIO AS PROPRIO, 
	F9_DTEMINE AS DATANFE,
	F9_CLIENTE AS CLIENTE,
	F9_LOJACLI AS LOJACLI,
	F9_DOCNFS AS DOCNFS,
	F9_SERNFS AS SERINFS,
	F9_DTEMINS AS DATANFS,
	F9_MOTIVO AS MOTIVO,
	F9_VALICMS AS VALICMS,
	F9_CFOENT AS CFOP,
	F9_PICM AS ICMS,
	F9_ICMIMOB AS ICMIMOB,
	F9_VLESTOR AS ESTORNO,
	F9_BXICMS AS BAIXADO,
	F9_FCA AS FATOR,
	F9_QTDPARC AS PARCELAS,
	F9_SLDPARC AS SLDPARCELA,
	F9_BAIXAPR AS BXPARCIAL,
	F9_FUNCIT AS FUNCAO,
	F9_TIPO AS TIPO,
	F9_CODBAIX AS PRINCIPAL,
	F9_VALICCO AS ICMCOMP,
	F9_VALICST AS ICMST,
	F9_VALFRET AS ICMFRT,
	F9_VALICMP AS ICMPROP,
	F9_DTINIUT AS DATAINI,
	F9_VLDBATV AS DEBATIVO
	
FROM 
	%Table:SF9% SF9
WHERE  
	F9_FILIAL = %xFilial:SF9% AND
	( F9_DTENTNE >= %Exp:Dtos(MV_PAR01)% AND 
	F9_DTENTNE <= %Exp:Dtos(MV_PAR02)% ) AND 
	SF9.%NotDel%
Order by F9_DTENTNE, F9_CODIGO
      
EndSQL  

oReport:Section(1):EndQuery()                                        
TCSETFIELD(cAlias,"DATADIG","D",8,0)    
TCSETFIELD(cAlias,"DATANFE","D",8,0)
TCSETFIELD(cAlias,"DATANFS","D",8,0) 
TCSETFIELD(cAlias,"DATAINI","D",8,0) 
                                        
oReport:SetMeter((cAlias)->(LastRec()))
                
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAlias)->(Eof()) 
	oReport:IncMeter()
	If oReport:Cancel()
		Exit
	EndIf  
	
	If Empty((cAlias)->VALICMS)
	SALDO:=0 
	else
 	SALDO:=((((cAlias)->VALICMS)/((cAlias)->PARCELAS))*((cAlias)->SLDPARCELA))-((cAlias)->BAIXADO)
 	
 	endif            
   
   	oReport:Section(1):PrintLine() 
                                   
   	(cAlias)->(dbSkip()) 
EndDo  
                
oReport:Section(1):Finish()

oReport:EndPage(.T.)
     
(cAlias)->(dbCloseArea())       
                
RETURN()

Static Function ValidPerg(cPerg)

 PutSX1(cPerg/*cGrupo*/,'01'/*cOrdem*/,"Data de?  :"/*cPergunt*/,""/*cPergSpa*/,"?"/*cPergEng*/,"MV_CH01"/*cVar*/,'D'/*cTipo*/,8/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,''/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR01"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{'Informe a Data.'}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
 PutSX1(cPerg/*cGrupo*/,'02'/*cOrdem*/,"Data ate?  :"/*cPergunt*/,""/*cPergSpa*/,"?"/*cPergEng*/,"MV_CH02"/*cVar*/,'D'/*cTipo*/,8/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,''/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR02"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{'Informe a Data.'}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )

Return