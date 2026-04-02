#Include 'Protheus.ch'

User Function MYCTBA05()
 Local oReport
 Private cPerg   :=  "MYCTBA05"
 ValidPerg(@cPerg)   
 Pergunte(cPerg,.t.)
 oReport:= ReportDef()
 oReport:PrintDialog()
  
Return

Static Function ReportDef()
Local cAlias:= GetNextAlias() // Melhores práticas para não ter problemas de abrir um segundo alias com um nome que já existe, 
Local cTitle   := "Relacao dos Lancamentos Contabeis"
Local oReport 
Local oSection1   

oReport := tReport():New(cPerg,cTitle,cPerg,{ |oReport| ReportPrint(@oReport, cAlias) } , cTitle )
oReport:SetPortrait(.t.) // Retrato
//oReport:SetLandscape(.t.) // Paisagem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1:= TRSection():New(oReport,"LANCAMENTOS CONTABEIS",{"CT2"},/*aOrdem*/)
oSection1:SetHeaderPage(.T.)

TRCell():New(oSection1,"DATALAN"        ,,"DATALAN",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"LOTE"           ,,"LOTE",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"SBLOTE"         ,,"SBLOTE",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"DOC"            ,,"DOC",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"LINHA"          ,,"LINHA",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"MOEDA"          ,,"MOEDA",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DEBITO"         ,,"DEBITO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"CREDITO"        ,,"CREDITO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"VALOR"          ,,"VALOR",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"HISTORICO"      ,,"HISTORICO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"CCD"            ,,"CCD",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection1,"CCC"            ,,"CCC",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"TPSALDO"        ,,"TPSALDO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)     
TRCell():New(oSection1,"ORIGEM"         ,,"ORIGEM",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"ROTINA"         ,,"ROTINA",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"INCLUSAO"       ,,"INCLUSAO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"ALTERACAO"      ,,"ALTERACAO",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSection1,"LOGINC"         ,,"LOGINC",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"LOGALT"         ,,"LOGALT",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 

oSection1:Cell("DATALAN"    ):SetBlock({ || (cAlias)->DATALAN })
oSection1:Cell("LOTE"       ):SetBlock({ || (cAlias)->LOTE    })    
oSection1:Cell("SBLOTE"     ):SetBlock({ || (cAlias)->SBLOTE  })
oSection1:Cell("DOC"        ):SetBlock({ || (cAlias)->DOC     })
oSection1:Cell("LINHA"      ):SetBlock({ || (cAlias)->LINHA   })
oSection1:Cell("MOEDA"      ):SetBlock({ || (cAlias)->MOEDA   })
oSection1:Cell("DEBITO"     ):SetBlock({ || (cAlias)->DEBITO  })
oSection1:Cell("CREDITO"    ):SetBlock({ || (cAlias)->CREDITO })
oSection1:Cell("VALOR"      ):SetBlock({ || (cAlias)->VALOR   }) 
oSection1:Cell("HISTORICO"  ):SetBlock({ || (cAlias)->HISTORICO})
oSection1:Cell("CCD"        ):SetBlock({ || (cAlias)->CCD     })
oSection1:Cell("CCC"        ):SetBlock({ || (cAlias)->CCC     })
oSection1:Cell("TPSALDO"    ):SetBlock({ || (cAlias)->TPSALDO })
oSection1:Cell("ORIGEM"     ):SetBlock({ || (cAlias)->ORIGEM  })
oSection1:Cell("ROTINA"     ):SetBlock({ || (cAlias)->ROTINA  })
oSection1:Cell("INCLUSAO"   ):SetBlock({ || (cAlias)->INCLUSAO})     
oSection1:Cell("ALTERACAO"  ):SetBlock({ || (cAlias)->ALTERACAO})
oSection1:Cell("LOGINC"     ):SetBlock({ || (cAlias)->LOGINC   })
oSection1:Cell("LOGALT"     ):SetBlock({ || (cAlias)->LOGALT   })  

RETURN (oReport)



STATIC FUNCTION ReportPrint(oReport, cAlias)

oReport:Section(1):BeginQuery()


BeginSQL Alias cAlias                                     
SELECT CT2_FILIAL,
       CT2_DATA AS DATALAN,
       CT2_LOTE AS LOTE,
       CT2_SBLOTE AS SBLOTE, 
       CT2_DOC AS DOC, 
       CT2_LINHA AS LINHA,
       CT2_MOEDLC AS MOEDA,
       CT2_DEBITO AS DEBITO,
       CT2_CREDIT AS CREDITO, 
       CT2_VALOR AS VALOR, 
       CT2_HIST AS HISTORICO, 
       CT2_CCD AS CCD, 
       CT2_CCC AS CCC, 
       CT2_TPSALD AS TPSALDO, 
       CT2_ORIGEM AS ORIGEM, 
       CT2_ROTINA AS ROTINA, 
       CT2_USERGI AS INCLUSAO, 
       CT2_USERGA AS ALTERACAO,     
	  //SUBSTRING(CT2_USERGI, 3, 1) + SUBSTRING(CT2_USERGI, 7, 1) +
		SUBSTRING(CT2_USERGI, 11, 1) + SUBSTRING(CT2_USERGI, 15, 1) +
		SUBSTRING(CT2_USERGI, 2, 1) + SUBSTRING(CT2_USERGI, 6, 1) +
		SUBSTRING(CT2_USERGI, 10, 1) + SUBSTRING(CT2_USERGI, 14, 1) +
		SUBSTRING(CT2_USERGI, 1, 1) + SUBSTRING(CT2_USERGI, 5, 1) +
		SUBSTRING(CT2_USERGI, 9, 1) + SUBSTRING(CT2_USERGI, 13, 1) +
		SUBSTRING(CT2_USERGI, 17, 1) + SUBSTRING(CT2_USERGI, 4, 1) +
		SUBSTRING(CT2_USERGI, 8, 1) as LOGINC,
       //SUBSTRING(CT2_USERGA, 3, 1) + SUBSTRING(CT2_USERGA, 7, 1) +
		SUBSTRING(CT2_USERGA, 11, 1) + SUBSTRING(CT2_USERGA, 15, 1) +
		SUBSTRING(CT2_USERGA, 2, 1) + SUBSTRING(CT2_USERGA, 6, 1) +
		SUBSTRING(CT2_USERGA, 10, 1) + SUBSTRING(CT2_USERGA, 14, 1) +
		SUBSTRING(CT2_USERGA, 1, 1) + SUBSTRING(CT2_USERGA, 5, 1) +
		SUBSTRING(CT2_USERGA, 9, 1) + SUBSTRING(CT2_USERGA, 13, 1) +
		SUBSTRING(CT2_USERGA, 17, 1) + SUBSTRING(CT2_USERGA, 4, 1) +
		SUBSTRING(CT2_USERGA, 8, 1) as LOGALT
                        
       FROM %table:CT2% CT2
             
       WHERE CT2_FILIAL = %xFilial:CT2% AND 
      
       (CT2_DATA >= %Exp:Dtos(mv_par01)% AND 
        CT2_DATA <= %Exp:Dtos(mv_par02)%)AND 
        CT2.%NotDel% 
       Order by CT2_DATA, CT2_LOTE
      
EndSQL 

oReport:Section(1):EndQuery()                                            

TCSETFIELD(cAlias,"DATALAN","D") 
        
oReport:SetMeter((cAlias)->(LastRec()))
                
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAlias)->(Eof()) 

	oReport:IncMeter()
	If oReport:Cancel() 
		Exit
		  
 	endif            
   oReport:Section(1):PrintLine() 

   (cAlias)->(dbSkip()) 
EndDo

oReport:Section(1):Finish()

oReport:EndPage(.T.)
     

(cAlias)->(dbCloseArea())       
                
RETURN()


Static Function ValidPerg(cPerg)

 */
 PutSX1(cPerg/*cGrupo*/,'01'/*cOrdem*/,"Data de?   :"/*cPergunt*/,""/*cPergSpa*/,"?"/*cPergEng*/,"MV_CH02"/*cVar*/,'D'/*cTipo*/,8/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,''/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR01"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{'Informe a data do lancamento.'}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
 PutSX1(cPerg/*cGrupo*/,'02'/*cOrdem*/,"Data até?  :"/*cPergunt*/,""/*cPergSpa*/,"?"/*cPergEng*/,"MV_CH02"/*cVar*/,'D'/*cTipo*/,8/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,''/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR02"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{'Informe a data do lancamento.'}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )

Return