#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MYFIS10   ºAutor  ³ Sonia Silva        º Data ³ 16-01-17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Conferencia Estorno CIAP                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Departamento Fiscal                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MYFIS10()
 Local oReport
 Private cPerg :=  "MYFIS10"
 ValidPerg(@cPerg)   
 Pergunte(cPerg,.t.)
 oReport:= ReportDef()
 oReport:PrintDialog()
 
Return

Static Function ReportDef()
Local cAlias:= GetNextAlias()
Local cTitle   := "Relacao de Estorno CIAP"
Local oReport 
Local oSection1
Private VLRTOTAL:=0  

oReport := tReport():New(cPerg,cTitle,cPerg,{ |oReport| ReportPrint(@oReport, cAlias) } , cTitle )
oReport:SetPortrait(.t.) // Retrato
//oReport:SetLandscape(.t.) // Paisagem

oSection1:= TRSection():New(oReport,"Relacao de Estorno CIAP",{"SFA"},/*aOrdem*/)
oSection1:SetHeaderPage(.T.)            

TRCell():New(oSection1,"CODIGO"         ,,"CODIGO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"DATAPROP"		,,"DATAPROP",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"VALOR"			,,"VALOR",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"FATOR"			,,"FATOR",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"FAT_PROP"		,,"FAT_PROP",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"TRIBUTADO"		,,"TRIBUTADO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"TOTAL"			,,"TOTAL",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"VLRTOTAL"		,,"VLRTOTAL",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)      

oSection1:Cell("CODIGO"		):SetBlock({ || (cAlias)->CODIGO})
oSection1:Cell("DATAPROP"	):SetBlock({ || (cAlias)->DATAPROP})    
oSection1:Cell("VALOR"		):SetBlock({ || (cAlias)->VALOR})
oSection1:Cell("FATOR"		):SetBlock({ || (cAlias)->FATOR})
oSection1:Cell("FAT_PROP"	):SetBlock({ || (cAlias)->FAT_PROP})
oSection1:Cell("TRIBUTADO"	):SetBlock({ || (cAlias)->TRIBUTADO})
oSection1:Cell("TOTAL"		):SetBlock({ || (cAlias)->TOTAL})
oSection1:Cell("VLRTOTAL"	):SetBlock({ || VLRTOTAL})       


RETURN (oReport)

STATIC FUNCTION ReportPrint(oReport, cAlias)

oReport:Section(1):BeginQuery()

BeginSQL Alias cAlias                                    


SELECT 
	FA_FILIAL,
	FA_CODIGO AS CODIGO, 
	FA_DATA AS DATAPROP, 
	FA_VALOR AS VALOR, 
	FA_FATOR AS FATOR, 
	FA_FATPRO AS FAT_PROP, 
	FA_TOTTRIB AS TRIBUTADO, 
	FA_TOTSAI AS TOTAL
FROM 
	%Table:SFA% SFA
WHERE  
	FA_FILIAL = %xFilial:SFA% AND
	( FA_DATA >= %Exp:Dtos(MV_PAR01)% AND 
	FA_DATA <= %Exp:Dtos(MV_PAR02)% ) AND 
	SFA.%NotDel%
Order by FA_DATA, FA_CODIGO
      
EndSQL  

oReport:Section(1):EndQuery()                                        
TCSETFIELD(cAlias,"DATAPROP","D",8,0)     
                                        
oReport:SetMeter((cAlias)->(LastRec()))
                
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAlias)->(Eof()) 
	oReport:IncMeter()
	If oReport:Cancel()
		Exit
	EndIf  
	
	If Empty((cAlias)->VALOR)
	VLRTOTAL:=0
	else
 	VLRTOTAL:=(((cAlias)->VALOR)/((cAlias)->FATOR))*1
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