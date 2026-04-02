#INCLUDE "PROTHEUS.CH"
#INCLUDE "report.ch"
#include 'rwmake.ch'
#include 'ap5mail.ch'
#INCLUDE "TOPCONN.CH"
#include "rptdef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MYGPE02  ºAutor  ³Microsiga           º Data ³  15/02/2023   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera planilha 3 planilas - Abono(PONR050), Divergencias     º±±
±±º          ³(PONR040) e Horas Extras(PONR040) e envia email para os     º±±
±±º          ³responsavel conforme cadastro							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico La Rondine                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Alteração
29/09/2021 - Cristina Iabuki - Mostrar tela com Filial DE/Ate e Data De/Ate
24/01/2023 - Cristina Iabuki - Incluido o campo ZZV_MATR para poder enviar por matricula ou centro de custo

*/

User Function MYGPE02()
Local cPath 	:= GetSrvProfString('StartPath','')
Local cQuery	:= ""
Local cEmails	:= ""
Local cPerg		:= "MYGP02"

Private cArq1	:= ""
Private cArq2 	:= ""
Private cArq3 	:= ""

Private 	cCC:= ""

// Private da 040
Private cSit     := " A*F*"	// Situacao
Private cCat     := "M"		// Categoria
Private lCC      := .T.		// Imprime C.C em outra Pagina    
Private dDataIni := CTOD("  /  /  ")
Private dDataFim := CTOD("  /  /  ")
Private dPerIni  := CTOD('  /  /  ')
Private dPerFim  := CTOD('  /  /  ')
Private dInicio  := CTOD('  /  /  ')
Private dFim  	:= CTOD('  /  /  ')

// 040
Private lNMarc   := .T.		// Imprime Mensagem No. Marca‡”es 
Private lHExtr   := .F.		// Imprime Mensagem H. Extra 
Private lInter   := .F.		// Imprime Intervalo 
Private lSitfu   := .T.		// Imprime Situa‡„o do Funcion rio    
Private l040OK	 := .F.		// Se encontrou pelo menos 1 funcionario

// 050
Private lImpAbon := .T.				// Imprimi Abonados
Private nTipo    := 3				// Imprimir Autorizados/Nao Autorizados/Ambo
Private nSinAna  := 2				// Relatorio Sintetico/Analitico  
Private lImpFol	 := .F.				// Quebra pagina por funcionario
Private lImpMot  := .T.				// Imprime motivo abono
Private lImpMar  := .T.				// Imprime marcacoes
Private lPrevisao:= .T.				//.T. - Lista Horario Previsto
Private l050OK	 := .F.				// Se encontrou pelo menos 1 funcionario

//060
Private nTipHoras := 3				// Autorizadas/Nao Autorizadas/Ambas
Private l060OK	 := .F.				// Se encontrou pelo menos 1 funcionario

Private aAnexos		:= {}
Private c050Filial	:= ""

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	Return ( .T. )
EndIf

//dDataIni := StoD("20210617")		// Data Inicial   
//dDataFim := StoD("20210630")		// Data Final
//dInicio  := StoD("20210617")		// Data Inicial   
//dFim 	 := StoD("20210630")		// Data Final
//MV_PAR02 :="06010209"       		//  Centro de Custo      

dDataIni := mv_par05 	// Data Inicial   
dDataFim := mv_par06 	// Data Final
dInicio  := mv_par05 	// Data Inicial   
dFim 	 := mv_par06    // Data Final

cQuery := "SELECT ZZV_FILIAL,ZZV_CC,ZZV_EMAIL1,ZZV_EMAIL2,ZZV_MATR FROM "
cQuery += RetSqlName("ZZV")+" ZZV "
cQuery += "WHERE ZZV.D_E_L_E_T_   = ' '	AND "
cQuery += "ZZV_FILIAL>= '"+mv_par01+"'  AND  "
cQuery += "ZZV_FILIAL<= '"+mv_par02+"'  AND  "
cQuery += "ZZV_CC>= '"+mv_par03+"'  AND  "
cQuery += "ZZV_CC<= '"+mv_par04+"'  AND  "
cQuery += "ZZV_MATR>= '"+mv_par07+"'  AND  "
cQuery += "ZZV_MATR<= '"+mv_par08+"'  AND  "
cQuery += "ZZV_MSBLQL<> '1'  "
cQuery += "ORDER BY ZZV_CC "

TCQUERY cQuery new alias "QZZV"

dbSelectArea("QZZV")
dbGotop()
While !QZZV->(EOF())

	l040OK	 := .F.		
	l050OK	 := .F.		
	l060OK	 := .F.		

	c050Filial	:= QZZV->ZZV_FILIAL
	aAnexos		:= {}
	cEmails		:= Alltrim(QZZV->ZZV_EMAIL1)+" "+Alltrim(QZZV->ZZV_EMAIL2)

	IF 	!Empty(QZZV->ZZV_CC)
		mv_par02	:= QZZV->ZZV_CC
		cCC			:= mv_par02
		mv_par07	:= "      "
		mv_par08 	:= "999999"
	Else
		mv_par02	:= ""
		mv_par07	:= QZZV->ZZV_MATR
		mv_par08 	:= QZZV->ZZV_MATR
		cCC			:= QZZV->ZZV_MATR
	Endif 

	cArq1:= cPath + "DIVERGENCIAS\Diverg_"+Alltrim(cCC)+".htm"
	Processa({||LR040(),,"Gerando divergencias marcacoes. Aguarde..."})

	cArq2:= cPath + "DIVERGENCIAS\Abono_"+Alltrim(cCC)+".htm"
	Processa({||LR050(),,"Gerando dados dos abonos. Aguarde..."})

	cArq3:= cPath+ "DIVERGENCIAS\Autoriz_"+Alltrim(cCC)+".htm"
	Processa({||LR060(),,"Gerando autorizacao das horas extras. Aguarde..."})

	Aadd(aAnexos,cArq1)
	Aadd(aAnexos,cArq2)
	Aadd(aAnexos,cArq3)

	If l040OK  .Or. l050OK .Or. l060OK
		Processa({||NVEmail(cEmails),,"Enviando e-mails. Aguarde..."})
	EndIf

	dbSelectArea("QZZV")	
	dbSkip()
EndDo

Return NIL

// Divergencias Marcacoes
Static Function LR040()
Local	oReport   
Local	aArea 		:= GetArea()
Private nColPro	:= 0

oReport := Report040Def()
oReport:PrintDialog()

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Report040Def  ³ Autor ³ Totvs IP RH        ³ Data ³12/04/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Divergencias nas marcacoes                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PONR040                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PONR040 - Generico                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Report040Def()
Local oReport 
Local oSection1 
Local oSection2 

//-- Criacao dos componentes de impressao
DEFINE REPORT oReport NAME "PONR040" TITLE 'Divergencias nas Marcacoes' ACTION {|oReport| PN040Imp(oReport)} DESCRIPTION OemtoAnsi("Este programa emite Relacao dos Funcionarios com Divergencias de Marcacoes") TOTAL IN COLUMN // 

	oSection1 := TRSection():New( oReport, OemToAnsi("Funcionarios"), {"SRA","CTT","SR6"},,,,,,.F.,.F.,.F.)  

		TRCell():New(oSection1,"RA_FILIAL"	,"SRA")
		TRCell():New(oSection1,"RA_CHAPA"	,"SRA",,,5)
		TRCell():New(oSection1,"RA_MAT"		,"SRA",,,6)
		TRCell():New(oSection1,"RA_NOME"	,"SRA",,,30,,,,.T.)
		TRCell():New(oSection1,"RA_CC"		,"SRA",OemToAnsi("C.Custo"),,9)	 
		TRCell():New(oSection1,"CTT_DESC01"	,"CTT",,,25,,,,.T.)
		TRCell():New(oSection1,"RA_TNOTRAB"	,"SRA",OemToAnsi("Tno"),,3)	 
		TRCell():New(oSection1,"R6_DESC"	,"SR6",,,20,,,,.T.)

	oSection2 := TRSection():New( oSection1, OemToAnsi("Marcações"),,,,,,,.F.,.F.,.F. )	 

		TRCell():New( oSection2, "DATA"			, "" ,OemToAnsi("Data"),,10)		 
		TRCell():New( oSection2, "MARCACOES"	, "" ,OemToAnsi("Marcações"),,80)	 
		TRCell():New( oSection2, "OCORRENCIAS"	, "" ,OemToAnsi("Ocorrencias"),,50)	 

	oReport:nRemoteType := NO_REMOTE
	oReport:nDevice := 5
	oReport:cFile := cArq1
	oReport:nEnvironment = 2
	oReport:SetPreview(.F.)
	
	
	//oReport:cFile := "\divergencias\relatorio.pdf"

	
Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ PN040Imp   ³ Autor ³ Totvs IP RH           ³ Data ³12/04/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Impressao do relatorio em TReport                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PN040Imp(oReport)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oReport                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PONR040 - Generico - Release 4                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PN040Imp(oReport)

Local oSection  := oReport:Section(1)
Local oSection1 := oReport:Section(1):Section(1)
Local cSitQuery	:= ""    
Local cCatQuery	:= ""  
Local nReg		:= 0

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de Acesso do Usuario                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "PONR040" , "SRA" , "2" ) + " } " )

//-- Variaveis Locais
// Caracter
Local cKey       := ''
Local cDet       := ''
Local cOrdem     := ''
Local cTraba     := '' 

// Data
Local dDataOk    := CtoD('  /  /  ')
Local dData      := CtoD('  /  /  ')

// Array
Local aTabPadrao := {}
Local aTabCalend := {}
Local aNewMarc	 := {}
Local aMarcacoes := {}
Local aMotivo    := {}
Local aTurnos    := {}
Local aHENA      := {}
Local aIntervalo := {}
Local aSiglaMarc := {}

// Logico
Local lIntMaior	 := .F.
Local lIntMenor  := .F.

// Numerico
Local nX         := 0
Local nY         := 0
Local nZ         := 0
Local nQuant     := 0   
Local nHrReal	 := 0
Local nIntProg   := 0
Local nIntReal   := 0
Local nPos1E     := 0
Local nW         := 0
Local nLenMarc	 := 0
Local nLenCalend := 0
Local nPosOrdem	 := 0  
Local nTolInt	 := 0

Local oBreakCc
Local oBreakFil
Local oBreakFun

Private cAliasQry 	:= GetNextAlias()

Private cFilAnte   := ''
Private cTnoAnt    := ''

TabMarc('SPJ',@aSiglaMarc)

SP4->(dbSetOrder(1))
SRA->(dbSetOrder(1))

//-- Define o periodo de Apuracao, de acordo com MV_PAPONTA
If !PerAponta(@dPerIni,@dPerFim)
	Return( NIL )
Endif

//-- Limita as datas iniciais e finais entre dPerIni e dPerFim
dDataIni := If(dDataIni<dPerIni,dPerIni,dDataIni)
dDataFim := If(Empty(dDataFim) .OR. dDataFim>dPerFim,dPerFim,dDataFim)

//-- Modifica variaveis para a Query
For nReg:=1 to Len(cSit)
	cSitQuery += "'"+Subs(cSit,nReg,1)+"'"
	If ( nReg+1 ) <= Len(cSit)
		cSitQuery += "," 
	Endif
Next nReg        
cSitQuery := "%" + cSitQuery + "%"

cCatQuery := ""
For nReg:=1 to Len(cCat)
	cCatQuery += "'"+Subs(cCat,nReg,1)+"'"
	If ( nReg+1 ) <= Len(cCat)
		cCatQuery += "," 
	Endif
Next nReg        
cCatQuery := "%" + cCatQuery + "%"

BEGIN REPORT QUERY oSection

cFilSRACTT	:= "%" + FWJoinFilial("SRA", "CTT") + "%"
cFilSRASR6	:= "%" + FWJoinFilial("SRA", "SR6") + "%"	

cOrdem 		:= "%SRA.RA_FILIAL,SRA.RA_CC,SRA.RA_NOME%"
cQryProcesso:= "%(SRA.RA_DEMISSA = '          ' OR (SRA.RA_DEMISSA >= '"+DTOS(dPerIni) + "' AND  SRA.RA_DEMISSA <> '          '))%"

If 	!Empty(mv_par02)
	cQryLR		:= "%"
	cQryLR 		+= "SRA.RA_CC= '"+mv_par02+"' AND SRA.RA_MAT>= '"+mv_par07+"' AND SRA.RA_MAT<='"+mv_par08+"' "
	cQryLR		+= "%"
Else
	cQryLR		:= "%"
	cQryLR		+= "SRA.RA_MAT>= '"+mv_par07+"' AND SRA.RA_MAT<='"+mv_par08+"' "
	cQryLR		+= "%"
EndIf 
	
BeginSql alias cAliasQry
	SELECT SRA.RA_FILIAL, SRA.RA_CC, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_TNOTRAB, SRA.RA_DEMISSA,SRA.RA_ADMISSA,SRA.RA_SITFOLH,SRA.RA_CHAPA,SRA.RA_SEQTURN,
		CTT.CTT_FILIAL, CTT.CTT_CUSTO, CTT.CTT_DESC01,
		SR6.R6_TURNO, SR6.R6_DESC
	FROM %table:SRA% SRA
	INNER JOIN %table:CTT% CTT ON RA_CC = CTT_CUSTO AND CTT.%NotDel% AND %exp:cFilSRACTT%
	INNER JOIN %table:SR6% SR6 ON RA_TNOTRAB = R6_TURNO AND SR6.%NotDel% AND %exp:cFilSRASR6%
	WHERE SRA.RA_SITFOLH	IN	(%exp:Upper(cSitQuery)%) 	AND
		  SRA.RA_CATFUNC	IN	(%exp:Upper(cCatQuery)%)	AND
		  SRA.RA_FILIAL= %exp:c050Filial%  AND 
		  %exp:cQryLR% AND 
	      %exp:cQryProcesso% AND 
 	      SRA.%notDel%   
	ORDER BY %exp:cOrdem%
EndSql

END REPORT QUERY oSection 

DEFINE BREAK oBreakFil OF oSection WHEN {|| (cAliasQry)->RA_FILIAL }  TITLE OemToansi("Divergencias nas Marcacoes") 
oBreakFil:SetPageBreak(.T.)
oBreakFil:SetHeaderBreak(.T.) 

DEFINE BREAK oBreakFun OF oSection WHEN {|| (cAliasQry)->RA_MAT }  TITLE OemToansi("Divergencias nas Marcacoes") 
oBreakFun:SetHeaderBreak(.T.) 
	
//-- Quebra de pagina C.Custo
DEFINE BREAK oBreakCc OF oSection WHEN {|| (cAliasQry)->RA_CC } TITLE OemToansi("Divergencias nas Marcacoes") 
If lCC 
	oBreakCc:SetPageBreak(.T.) 
Endif 
oSection:SetHeaderSection(.T.)
oSection:SetHeaderBreak(.T.) 

oSection:lHeaderPage:=.F. 
oSection1:lHeaderPage:=.F. 

oReport:OnPageBreak( {|| oReport:lOnPageBreak:= .F.,;
							If(oSection1:lPrinting,;
							(oSection:PrintLine(),	oReport:SkipLine());
							,);
					 },.F. )

//-- Carrega Codigos de Hora Extra Nao Autorizada
cKey  := ''
aHENA := {}
If SP4->(dbSeek(fFilFunc('SP4') + Space(Len((cAliasQry)->RA_TNOTRAB)), .F.)) .Or. ;
	SP4->(dbSeek(fFilFunc('SP4') + (cAliasQry)->RA_TNOTRAB, .F.)) .Or. ;
	SP4->(dbSeek(Space(Len((cAliasQry)->RA_FILIAL)) + (cAliasQry)->RA_TNOTRAB, .F.)) .Or. ;
	SP4->(dbSeek(Space(Len((cAliasQry)->RA_FILIAL)) + Space(Len((cAliasQry)->RA_TNOTRAB)), .F.))
	cKey := SP4->P4_FILIAL + SP4->P4_TURNO
	While !SP4->(Eof()) .And. SP4->P4_FILIAL + SP4->P4_TURNO == cKey
		If Len(aHena) == 0 .Or. aScan(aHENA, SP4->P4_CODNAUT) == 0
			aAdd(aHENA, SP4->P4_CODNAUT)
		EndIf	
		SP4->(dbSkip())
	EndDo								
EndIf

cFilAnte	:= (cAliasQry)->RA_FILIAL
cTnoAnt		:= (cAliasQry)->RA_TNOTRAB
nTolInt 	:= __Min2Hrs( ( SuperGetMv("MV_DIVTINT",NIL,0, (cAliasQry)->RA_FILIAL) ) )   //-- Minutos para Tolerancia de Intervalo

//-- Define o total da regua da tela de processamento do relatorio
oReport:SetMeter( 100 )  

//-- Incializa impressao   
oSection:Init(.F.)                                                  

While !(cAliasQry)->( EOF() ) 

	
	//-- Movimenta Regua de Processamento
	oReport:IncMeter( 1 )   

	//-- Verifica se o usuário cancelou a impressão do relatorio
	If oReport:Cancel()
		Exit
	EndIf               

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Posiciona o registro da query na tabela de Funcionarios                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !SRA->(dbSeek( (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT ))
		(cAliasQry)->(DbSkip())
	   	Loop
	Endif

	//-- Processa quebra de Filial.
	If (cAliasQry)->RA_FILIAL != cFilAnte 
	    //--Somente "Zera" as variaveis se jah foi impresso algo para nao pula 
	    //--de pagina na primeira vez

		cFilAnte := (cAliasQry)->RA_FILIAL
   		cTnoAnt := (cAliasQry)->RA_TNOTRAB
		nTolInt := __Min2Hrs( ( SuperGetMv("MV_DIVTINT",NIL,0, (cAliasQry)->RA_FILIAL) ) )   //-- Minutos para Tolerancia de Intervalo
		
		//-- Carrega C¢digos de Hora Extra N„o Autorizada (Filial)
		cKey  := ''
		If SP4->(dbSeek(fFilFunc('SP4') + Space(Len((cAliasQry)->RA_TNOTRAB)), .F.)) .Or. ;
			SP4->(dbSeek(fFilFunc('SP4') + (cAliasQry)->RA_TNOTRAB, .F.)) .Or. ;
			SP4->(dbSeek(Space(Len((cAliasQry)->RA_FILIAL)) + (cAliasQry)->RA_TNOTRAB, .F.)) .Or. ;
			SP4->(dbSeek(Space(Len((cAliasQry)->RA_FILIAL)) + Space(Len((cAliasQry)->RA_TNOTRAB)), .F.))
			cKey := SP4->P4_FILIAL + SP4->P4_TURNO
			While !SP4->(Eof()) .And. SP4->P4_FILIAL + SP4->P4_TURNO == cKey
				If Len(aHena) == 0 .Or. aScan(aHENA, SP4->P4_CODNAUT) == 0
					aAdd(aHENA, SP4->P4_CODNAUT)
				EndIf	
				SP4->(dbSkip())
			EndDo								
		EndIf
	Endif

	If cFilAnte + cTnoAnt <> (cAliasQry)->RA_FILIAL +(cAliasQry)->RA_TNOTRAB
		cFilAnte	:= (cAliasQry)->RA_FILIAL
		cTnoAnt		:= (cAliasQry)->RA_TNOTRAB

		//-- Carrega C¢digos de Hora Extra N„o Autorizada (Turno)
		cKey  := ''
		If SP4->(dbSeek(fFilFunc('SP4') + Space(Len((cAliasQry)->RA_TNOTRAB)), .F.)) .Or. ;
			SP4->(dbSeek(fFilFunc('SP4') + (cAliasQry)->RA_TNOTRAB, .F.)) .Or. ;
			SP4->(dbSeek(Space(Len((cAliasQry)->RA_FILIAL)) + (cAliasQry)->RA_TNOTRAB, .F.)) .Or. ;
			SP4->(dbSeek(Space(Len((cAliasQry)->RA_FILIAL)) + Space(Len((cAliasQry)->RA_TNOTRAB)), .F.))
			cKey := SP4->P4_FILIAL + SP4->P4_TURNO
			While !SP4->(Eof()) .And. SP4->P4_FILIAL + SP4->P4_TURNO == cKey
				If Len(aHena) == 0 .Or. aScan(aHENA, SP4->P4_CODNAUT) == 0
					aAdd(aHENA, SP4->P4_CODNAUT)
				EndIf	
				SP4->(dbSkip())
			EndDo								
		EndIf
	Endif

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Consiste Filiais e Acessos                                             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF !( (cAliasQry)->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
		(cAliasQry)->(DbSkip())
	   	Loop
	EndIF

	//-- Reinicializa Variaveis do Funcionario
	aTabCalend	:= {} 
	aTurnos		:= {}
	aMarcacoes	:= {}

	//-- Carrega as Marcacoes do Periodo
	IF !GetMarcacoes( @aMarcacoes		,;	//Marcacoes dos Funcionarios
					  @aTabCalend		,;	//Calendario de Marcacoes
					  @aTabPadrao		,;	//Tabela Padrao
					  @aTurnos			,;	//Turnos de Trabalho
					  dPerIni 			,;	//Periodo Inicial
					  dPerFim			,;	//Periodo Final
					  (cAliasQry)->RA_FILIAL	,;	//Filial
					  (cAliasQry)->RA_MAT		,;	//Matricula
					  (cAliasQry)->RA_TNOTRAB	,;	//Turno
					  (cAliasQry)->RA_SEQTURN	,;	//Sequencia de Turno
					  (cAliasQry)->RA_CC		,;	//Centro de Custo
					  "SP8"				,;	//Alias para Carga das Marcacoes
					  .F.    			,;	//Se carrega Recno em aMarcacoes
					  .T.      			,;	//Se considera Apenas Ordenadas
				      .T. 				,;	//Se Verifica as Folgas Automaticas
				  	  .F.    			 ;	//Se Grava Evento de Folga Automatica Periodo Anterior
					)
		(cAliasQry)->(dbSkip())
		Loop
    EndIF

	aNewMarc := {}
	nLenMarc := Len( aMarcacoes )
	For nX := 1 To nLenMarc
		IF ( cOrdem := aMarcacoes[ nX , 03 ] ) == "ZZ"
			Loop
		EndIF	
		aAdd( aNewMarc , {} )
		For nY := nX To nLenMarc
			IF aMarcacoes[ nY , 03 ] == cOrdem .and. aMarcacoes[ nY , 03 ] != "ZZ"
				aAdd( aNewMarc[Len(aNewMarc)] , aClone( aMarcacoes[ nY ] ) )
				aMarcacoes[ nY , 03 ] := "ZZ"
			Else
				Exit
			EndIF
		Next nY
	Next nX

	aMarcacoes := aClone( aNewMarc )
	
	//-- Monta o Array aImp com as ocorrˆncias do per¡odo
	aImp := {}
	nLenMarc := Len(aMarcacoes)
	nLenCalend:=Len(aTabCalend)
	
	For nX := 1 to nLenMarc
		dData  := aMarcacoes[nX, 1, 1]
		cOrdem := aMarcacoes[nX, 1, 3]
	    
	    //-- Limita as Marcacoes ao Periodo Solicitado
	    dDataOk := If( ( nPos1E := aScan(aTabCalend, { |x| x[2] == cOrdem .And. x[4] == '1E' }) ) > 0, aTabCalend[nPos1E,1], dData)
	    If Abs(dData - dDataOk) > 2  .OR. ;
	       (Abs(dData - dDataOk) <= 2 .And. dDataOk < dDataIni) .Or. ;
		   (Abs(dData - dDataOk) <= 2 .And. dDataOk > dDataFim)
	       Loop
		EndIf	
		
	  	//--Se Existe Calendario para a Ordem Obtem Numero de Marcacoes Possiveis
	    If nPos1E>0  
		   	        
			//-- Calcula a Quantidade de Marcacoes possiveis de acordo com o 
			//--Calendario do Funcionario
	        nTabMarc:=0
	        For nPosOrdem:=nPos1E to nLenCalend
	           If aTabCalend[nPosOrdem,2] <> cOrdem
	              Exit
	           Endif
	           nTabMarc++
	        Next nPosOrdem
	    Endif
	    
		//-- Procura por Excecoes na Data
		cTraba := ''
		nQuant := 0
		aIntervalo := {}
		If nPos1E > 0
			cTraba := aTabCalend[nPos1E, 6]
		  	//-- Corre Todas as Marcacoes realizadas de acordo com a Ordem
			For nW := nPos1E to nLenCalend
				If aTabCalend[nW,2] <> cOrdem
              		Exit
           		Endif
				nQuant ++                                                
				//-- Se segundo a Tabela Padrao Existir Intervalo
				//-- Armazena-o para posterior verificacao
				If aTabCalend[nW,9] > 0
				   aAdd(aIntervalo, { aTabCalend[nW,9],aTabCalend[nW,4] })
				Endif
			Next nW
		EndIf

		//-- Reinicializa Variaveis
		dDtAfas  := CtoD('  /  /  ')
		dDtRet   := CtoD('  /  /  ')
		cTipAfas := ''
		aMotivo  := {}

		If nPos1E == 0
			aAdd(aMotivo, '** Nao existe Calendario           ' )  
		EndIf	

		//-- MSG n£mero de Marca‡”es
		If lNMarc						
			//-- Marca‡”es Impares
			If Len(aMarcacoes[nX])%2 > 0
				aAdd(aMotivo, '** Numero de Marcacoes Impar       ' )  
			EndIf

			//-- Menos ou Mais marca‡”es que o programado
			If Len(aMarcacoes[nX]) < nQuant
				aAdd(aMotivo, '** Menos Marcacoes que o Programado' )  
			ElseIf Len(aMarcacoes[nX]) > nQuant .And. nQuant > 0
				aAdd(aMotivo, '** Mais Marcacoes que o Programado ' )  
			EndIf	
		EndIf

		//-- MSG Hora Extra n„o autorizada
		If lHExtr .And. Len(aHENA) > 0
			For nY := 1 to Len(aHENA)
				If SPC->(dbSeek(fFilFunc('SPC')+(cAliasQry)->RA_MAT+aHENA[nY]+DtoS(dData), .F.))
					aAdd(aMotivo, '** Hora Extra Nao Autorizada       ' )  
					Exit
				EndIf
			Next nY
		EndIf

		//-- MSG Intervalo
		If lInter
			//-- Intervalo Menor ou Maior que o Programado
			nW := 0
			For nW := 1 To Len(aIntervalo)
				nIntReal := 0
				nIntProg := 0 
				nHrReal	 := 0
				//-- Obtem o numero de horas/minutos de intervalo

				//-- Localiza o numero da posicao da marcacao pela sigla.
				nPosInt := Ascan(aSiglaMarc, { |x| x == aIntervalo[nW,2] })
	
				lIntMaior:=lIntMenor:= .F.		 				
 				If nPosInt+1 <= Len(aMarcacoes[nX])

					If  Empty(nTolInt)
						nIntReal := fDHtoNS(aMarcacoes[nX, nPosInt+1, 1], aMarcacoes[nX, nPosInt+1, 2]) - fDHtoNS(aMarcacoes[nX, nPosInt, 1], aMarcacoes[nX, nPosInt, 2])
						nIntProg := fDhToNs(,aIntervalo[nW,1])
						lIntMenor:= (nIntReal) < (nIntProg)  
						lIntMaior:=	(nIntReal) > (nIntProg)
                    Else 
	               	   
                    	CalcHours(  aMarcacoes[nX, nPosInt+1, 1]		,;	//01 -> Data 1
									aMarcacoes[nX, nPosInt+1, 2]		,;	//02 -> Hora 1
									aMarcacoes[nX, nPosInt, 1]			,;	//03 -> Data 2
									aMarcacoes[nX, nPosInt, 2]			,;	//04 -> Hora 2
									@nHrReal							,;	//05 -> <@>Horas Normais Apontadas
									NIL									,;	//06 -> <@>Horas Noturnas Apontadas
									.F.									;	//07 -> Apontar Horas Noturnas
								 )  
						If nHrReal > SomaHoras(aIntervalo[nW,1],nTolInt)
							lIntMaior:=.T.
						ElseIf aIntervalo[nW,1] > SomaHoras(nHrReal,nTolInt)
	 						lIntMenor:=.T.
						Endif							 
					Endif
						
				Endif

				If lIntMenor
				   	aAdd(aMotivo, '** '+Trim(Str(nW,2))+'o.'+' Intervalo Menor que o Programado')  
				ElseIf   lIntMaior
					aAdd(aMotivo, '** '+Trim(Str(nW,2))+'o.'+' Intervalo Maior que o Programado')  
				EndIf
			Next nW
		EndIf

		//-- MSG Situa‡„o do Funcion rio
		If lSitFu
			//-- Marca‡”es Anteriores a Admiss„o ou Posteriores a Demiss„o
			If !Empty((cAliasQry)->RA_ADMISSA) .And. dData < (cAliasQry)->RA_ADMISSA
				aAdd(aMotivo, '** Marcacoes antes da Admisssao    ' )  
			ElseIf !Empty((cAliasQry)->RA_DEMISSA) .And. dData > (cAliasQry)->RA_DEMISSA
				aAdd(aMotivo, '** Marcacoes apos Demissao         ' )  
			EndIf

			//-- Marca‡”es durante Ferias ou Afastamentos
			If fAfasta( (cAliasQry)->RA_FILIAL,(cAliasQry)->RA_Mat,dData,@dDtafas,@dDtRet,@cTipAfas) .And. aTabCalend[nPos1E,10] # 'E'
				If cTipAfas == 'F'
					aAdd(aMotivo, '** Marcacoes durante as Ferias     ' )  
				Else
					aAdd(aMotivo, '** Marcacoes durante Afastamento   ' )  
					aAdd(aMotivo, '** Marcacoes durante Afastamento   ' )  
				EndIf
			EndIf		
		EndIf

		If Len(aMotivo) > 0
			cDet := Subs(Dtos(dData),7,2)+'/' + Subs(Dtos(dData),5,2) + Space(2)
			For nZ := 1 to Len(aMarcacoes[nX])
				cDet += StrZero(aMarcacoes[nX, nZ, 2], 5, 2) + Space(1)
			Next nZ
			cDet := If(Len(cDet)>=87,Left(cDet,87),cDet+Space(87-Len(cDet)))
			aAdd(aImp, cDet)
			For nZ := 1 to Len(aMotivo)
				If nZ == 1
					aImp[Len(aImp)] += aMotivo[nZ]
				Else	
					aAdd(aImp, Space(87) + aMotivo[nZ])
				EndIf
			Next nZ
		EndIf
	Next nX

	// Verifica se não carregou as marcações e salta para o proximo funcionario
	If Len(aImp) == 0
		(cAliasQry)->(DbSkip())
		Loop
	Endif

	l040OK:= .T.

	oSection:PrintLine()
	oReport:SkipLine()
	oSection1:Init(.F.) 
	oSection1:PrintHeader() 
	
	For nX := 1 to Len( aImp )
		//-- Altera valores da Section
		oSection1:Cell( "DATA"):SetValue(SubStr(aImp[nX],1,5))
		oSection1:Cell( "MARCACOES"):SetValue(SubStr( aImp[nX],8,79))
		oSection1:Cell( "OCORRENCIAS"):SetValue(LTrim(SubStr(aImp[nX],80)))

		//-- Imprime os conteudos da Section
	   	oSection1:PrintLine()
	Next

	oSection1:Finish()
	oReport:ThinLine()
	oReport:SkipLine()		

	(cAliasQry)->(DbSkip())

EndDo

oSection:Finish()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select(cAliasQry) > 0
	(cAliasQry)->(dbCloseArea())
EndIf

Return
///--------------- PONR050
// Relatorio para Abono                                      
Static Function LR050()
Local	oReport   
Local	aArea 		:= GetArea()
Private nColPro	:= 0

oReport := Report050Def()
oReport:PrintDialog()

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Report050Def  ³ Autor ³ Totvs IP RH           ³ Data ³12/04/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio para Abono                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PONR050                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PONR050 - Generico                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Report050Def()
Local oReport 
Local oSection1 
Local oSection2 
Local bBlkFil := { || If ( cCodFilial != (cAliasQry)->RA_FILIAL, Eval( { || fInfo(@aInfo,(cAliasQry)->RA_FILIAL), aInfo[3] } ), aInfo[1] ) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao dos componentes de impressao                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE REPORT oReport NAME "PONR050" TITLE "Relatorio Abono" ACTION {|oReport| PN050Imp(oReport)} DESCRIPTION OemtoAnsi("Este programa emite Relacao dos Funcionarios para Abonos de Horas") TOTAL IN COLUMN  

	oSection1 := TRSection():New( oReport, OemToAnsi("Funcionarios"), {"SRA","CTT","SR6"},,,,,,.F.,.F.,.F.)  


		TRCell():New(oSection1,"RA_FILIAL","SRA",,/*Picture*/,8,/*lPixel*/,{|| 	If(!Empty((cAliasQry)->RA_FILIAL),;
																								cCodFilial:= (cAliasQry)->RA_FILIAL,;
																								NIL),;
																								cCodFilial}	)
		TRCell():New(oSection1,"FILIAL","",OemToAnsi("Desc.Filial"),/*Picture*/,20,/*lPixel*/,{|| Eval( bBlkFil ) })	


		TRCell():New(oSection1,"RA_CHAPA"	,"SRA",,,5)
		TRCell():New(oSection1,"RA_MAT"		,"SRA",,,6)
		TRCell():New(oSection1,"RA_NOME"	,"SRA",,,30,,,,.T.)
		TRCell():New(oSection1,"RA_CC"		,"SRA",OemToAnsi("C.Custo"),,9)	 
		TRCell():New(oSection1,"CTT_DESC01"	,"CTT",,,25,,,,.T.)
		TRCell():New(oSection1,"RA_TNOTRAB"	,"SRA",OemToAnsi("Tno"),,3)	 
		TRCell():New(oSection1,"R6_DESC"	,"SR6",,,20,,,,.T.)

	oSection2 := TRSection():New( oSection1, OemToAnsi("Marcações"),,,,,,,.F.,.F.,.F. )	 
                                                                              
		TRCell():New( oSection2, "PREVISTO"    	, "" ,OemToAnsi("Previsto" ),,24,,,,.T.)  
		TRCell():New( oSection2, "REALIZADO"   	, "" ,OemToAnsi("Realizado" ),,24,,,,.T.) 
		TRCell():New( oSection2, "DATA"     	, "" ,OemToAnsi("Data" ),,5)  

		TRCell():New( oSection2, "ABONO"     	, "" ,OemToAnsi("Abn" ),,3)  
		TRCell():New( oSection2, "DESCABONO"	, "" ,OemToAnsi("Descricao"),,20,,,,.T.)  
		TRCell():New( oSection2, "HORAS"		, "" ,OemToAnsi("Horas"),,6)  
		TRCell():New( oSection2, "JUSTIFICATIVA", "" ,OemToAnsi("Justificativa"),,30)  
		TRCell():New( oSection2, "VISTO"		, "" ,OemToAnsi("Visto"),,20)  

	oReport:nRemoteType := NO_REMOTE
	oReport:nDevice := 5
	oReport:cFile := cArq2

	//oReport:cFile := "\divergencias\relatorio.pdf"

	oReport:nEnvironment = 2
	oReport:SetPreview(.F.)
	


Return(oReport)


Static Function PN050Imp(oReport)

Local oSection  := oReport:Section(1)
Local oSection1 := oReport:Section(1):Section(1)
Local cSitQuery	:= ""    
Local cCatQuery	:= ""  
Local nReg		:= 0
Local cCodAut 	:= "415,416,433,478,480,481,058,418,419" //-- Codigos Autorizados
Local cCodNAut 	:= "050,051,052,053,055,056,057,060,061" //-- Codigos Nao Autorizados

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de Acesso do Usuario                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "PONR050" , "SRA" , "2" ) + " } " )
Local cAcessaSPC 	:= &( " { || " + ChkRH( "PONR050" , "SPC" , "2" ) + " } " )

Local aAutorizado  := {}
Local aJustifica   := {}	//-- retorno Justificativa de abono
Local xQuant       := 0
Local nPos         := 0
Local cPD          := Space(03)
Local nTab	     :=0
Local nPosTab	 :=0
Local nLenCalend :=0
Local aPrevFun   :={}
Local cOrdem	 :=''
Local nLimite    := 0
Local nX		 := 0
Local nFor		 := 0
Local cPrevDet   := ""
Local cRealDet   := ""

Local oBreakCc
Local oBreakFil
Local oBreakFun

Local lHeaderMar	:= .T.

Private aInfo		:= {}
Private cCodFilial	:= "##"
Private cDet	 := ''
Private cDet1  	 := ''
Private cDet2	 := ''
Private cDet3	 := ''
Private nVez	 := 0
Private cItem    := ''
Private lImpLinhas:= '' 

Private aDet       := {}
Private lCabec     := .F.
Private lCabecCC   := .F.
Private lCabecTT   := .F.
Private lPrimeira  := .T.
Private aMarcFun   := {}
Private aTabPadrao := {}
Private aTabCalend := {}
Private aMarcacoes := {}
Private nPosMarc   := 0 
Private nLenMarc   := 0

Private cAliasQry 	:= GetNextAlias()

Private cFilAnte   := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o periodo de Apura‡„o, de acordo com MV_PAPONTA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !PerAponta(@dPerIni,@dPerFim)
	Return( NIL )
Endif


SRA->(dbSetOrder(1))

// Identificadores de Ponto
If nTipo = 1 
	cCodigos := cCodaut
Elseif nTipo = 2
	cCodigos := cCodNAut
ElseIf nTipo = 3
	cCodigos := cCodAut+','+cCodNAut
Endif	

//-- Modifica variaveis para a Query
For nReg:=1 to Len(cSit)
	cSitQuery += "'"+Subs(cSit,nReg,1)+"'"
	If ( nReg+1 ) <= Len(cSit)
		cSitQuery += "," 
	Endif
Next nReg        
cSitQuery := "%" + cSitQuery + "%"

cCatQuery := ""
For nReg:=1 to Len(cCat)
	cCatQuery += "'"+Subs(cCat,nReg,1)+"'"
	If ( nReg+1 ) <= Len(cCat)
		cCatQuery += "," 
	Endif
Next nReg        
cCatQuery := "%" + cCatQuery + "%"

BEGIN REPORT QUERY oSection

cFilSRACTT	:= "%" + FWJoinFilial("SRA", "CTT") + "%"
cFilSRASR6	:= "%" + FWJoinFilial("SRA", "SR6") + "%"	

cOrdem := "%SRA.RA_FILIAL,SRA.RA_CC,SRA.RA_NOME%"
cQryProcesso := "%(SRA.RA_DEMISSA = '          ' OR (SRA.RA_DEMISSA >= '"+DTOS(dPerIni) + "' AND  SRA.RA_DEMISSA <> '          '))%"

If 	!Empty(mv_par02)
	cQryLR		:= "%"
	cQryLR		+= "SRA.RA_CC= '"+mv_par02+"' AND SRA.RA_MAT>= '"+mv_par07+"' AND SRA.RA_MAT<='"+mv_par08+"' "
	cQryLR		+= "%"
Else
	cQryLR		:=	"%"
	cQryLR		+= 	"SRA.RA_MAT>= '"+mv_par07+"' AND SRA.RA_MAT<='"+mv_par08+"' "
	cQryLR		+=	"%"
EndIf 
	
BeginSql alias cAliasQry
	SELECT SRA.RA_FILIAL, SRA.RA_CC, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_TNOTRAB, SRA.RA_DEMISSA,SRA.RA_ADMISSA,SRA.RA_SITFOLH,
			SRA.RA_CHAPA,SRA.RA_SEQTURN,SRA.RA_REGRA,
		CTT.CTT_FILIAL, CTT.CTT_CUSTO, CTT.CTT_DESC01,
		SR6.R6_TURNO, SR6.R6_DESC
	FROM %table:SRA% SRA
	INNER JOIN %table:CTT% CTT ON RA_CC = CTT_CUSTO AND CTT.%NotDel% AND %exp:cFilSRACTT%
	INNER JOIN %table:SR6% SR6 ON RA_TNOTRAB = R6_TURNO AND SR6.%NotDel% AND %exp:cFilSRASR6%
	WHERE SRA.RA_SITFOLH	IN	(%exp:Upper(cSitQuery)%) 	AND
		  SRA.RA_CATFUNC	IN	(%exp:Upper(cCatQuery)%)	AND
		  SRA.RA_FILIAL= %exp:c050Filial%  AND 
	      %exp:cQryProcesso% AND 
		  %exp:cQryLR% AND 
 	      SRA.%notDel%   
	ORDER BY %exp:cOrdem%
EndSql

END REPORT QUERY oSection 

DEFINE BREAK oBreakFil OF oSection WHEN {|| (cAliasQry)->RA_FILIAL }  TITLE OemToansi("Relatorio Abono") 
oBreakFil:SetPageBreak(.T.)
oBreakFil:SetHeaderBreak(.T.) 

DEFINE BREAK oBreakFun OF oSection WHEN {|| (cAliasQry)->RA_MAT }  TITLE OemToansi("Relatorio Abono") 
oBreakFun:SetHeaderBreak(.T.) 
If lImpFol
	oBreakFun:SetPageBreak(.T.) 
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quebra de pagina C.Custo                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE BREAK oBreakCc OF oSection WHEN {|| (cAliasQry)->RA_CC } TITLE OemToansi("Relatorio Abono") 
If lCC 
	oBreakCc:SetPageBreak(.T.) 
	oBreakCc:SetHeaderBreak(.T.) 
Endif 
oSection:SetHeaderSection(.T.)
oSection:SetHeaderBreak(.T.) 

oSection1:SetHeaderSection(.F.)
oSection1:SetHeaderBreak(.F.) 

oSection:lHeaderPage:=.F. 
oSection1:lHeaderPage:=.F. 

// Na quebra de pagina executa: Impressao da Linha do funcionario,pula linha,impressão do cabecalho das marcacoes, pula linha
oReport:OnPageBreak( {|| oReport:lOnPageBreak:= .F.,lHeaderMar := .T.,;
							If((oSection1:lPrinting ),;
								(oSection:PrintLine(),	;
									oReport:SkipLine(),;
									oSection1:SetHeaderSection(.T.),;
									oSection1:PrintHeader(),;
									oSection1:SetHeaderSection(.F.),;
									oReport:SkipLine();
								);
							,);
					 },.F. )

cFilAnte := (cAliasQry)->RA_FILIAL

// Verifica a existencia da tabela de Eventos para classificacao dos Abonos
DbSelectArea("SP9")
dbSetOrder(1)
If !DbSeek(xFilial("SP9",cFilAnte))
	If !DbSeek(Space(FWGETTAMFILIAL))
		(cAliasQry)->(DbSkip())
	   	Return
	Endif
Endif

// Carrega a tabela de Eventos para auxiliar a classificacao dos Abonos
cFilCompara := SP9->P9_FILIAL
aAutorizado := {}
While ! Eof() .AND. SP9->P9_FILIAL == cFilCompara
	If Subs(P9_IDPON,1,3) $ cCodigos
		Aadd(aAutorizado, {Left(P9_CODIGO,3), P9_DESC})
	Endif
	DbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a variavel aInfo com a filial Logada              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fInfo(@aInfo,(cAliasQry)->RA_FILIAL)

//-- Define o total da regua da tela de processamento do relatorio
oReport:SetMeter( 100 )  

//-- Incializa impressao   
oSection:Init(.F.)                                                  

While !(cAliasQry)->( EOF() ) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:IncMeter( 1 )   

	//-- Verifica se o usuário cancelou a impressão do relatorio
	If oReport:Cancel()
		Exit
	EndIf               

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Posiciona o registro da query na tabela de Funcionarios                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !SRA->(dbSeek( (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT ))
		(cAliasQry)->(DbSkip())
	   	Loop
	Endif

	//-- Processa quebra de Filial.
	If (cAliasQry)->RA_FILIAL != cFilAnte 
	    //--Somente "Zera" as variaveis se jah foi impresso algo para nao pula 
	    //--de pagina na primeira vez

		cFilAnte := (cAliasQry)->RA_FILIAL

		// Carrega a tabela de Eventos para auxiliar a classificacao dos Abonos
		DbSelectArea("SP9")
		If !DbSeek(xFilial("SP9",cFilAnte))
			If !DbSeek(Space(FWGETTAMFILIAL))
			   	Exit
			Endif
		Endif

		// Carrega a tabela de Eventos para auxiliar a classificacao dos Abonos
		cFilCompara := SP9->P9_FILIAL
		aAutorizado := {}
		While ! Eof() .AND. SP9->P9_FILIAL == cFilCompara
			If Subs(P9_IDPON,1,3) $ cCodigos
				Aadd(aAutorizado, {Left(P9_CODIGO,3), P9_DESC})
			Endif
			SP9->(DbSkip())
		EndDo
		
		If Len(aAutorizado) == 0
			Exit
		Endif
		
		If !fInfo(@aInfo,(cAliasQry)->RA_FILIAL)
			Exit
		Endif	

	Endif

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Consiste Filiais e Acessos                                             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF !( (cAliasQry)->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
		(cAliasQry)->(DbSkip())
	   	Loop
	EndIF


	//-- Cria Calendario com o periodo completo com Trocas de Turno
	aMarcacoes	:= {}
	aTabCalend	:= {}	
	//-- Carrega as Marcacoes do Periodo
	IF !GetMarcacoes( @aMarcacoes		,;	//01 -> Marcacoes dos Funcionarios
					  @aTabCalend		,;	//02 -> Calendario de Marcacoes
					  @aTabPadrao		,;	//03 -> Tabela Padrao
					  NIL				,;	//04 -> Turnos de Trabalho
					  dPerIni 			,;	//05 -> Periodo Inicial
					  dPerFim			,;	//06 -> Periodo Final
					  (cAliasQry)->RA_FILIAL	,;	//07 -> Filial
					  (cAliasQry)->RA_MAT		,;	//08 -> Matricula
					  (cAliasQry)->RA_TNOTRAB	,;	//09 -> Turno
					  (cAliasQry)->RA_SEQTURN	,;	//10 -> Sequencia de Turno
					  (cAliasQry)->RA_CC		,;	//11 -> Centro de Custo
					  "SP8"				,;	//12 -> Alias para Carga das Marcacoes
					  .F.    			,;	//13 -> Se carrega Recno em aMarcacoes
					  .T.      			,;	//14 -> Se considera Apenas Ordenadas
					  .T.      			,;	//15 -> Se Verifica as Folgas Automaticas
					  .F.      			,;	//16 -> Se Grava Evento de Folga Automatica Periodo Anterior
					  NIL				,;	//17 -> Se Carrega as Marcacoes Automaticas
					  NIL				,;	//18 -> Registros de Marcacoes Automaticas que deverao ser Desprezadas
					  NIL				,;	//19 -> Bloco para avaliar as Marcacoes Automaticas que deverao ser Desprezadas
					  NIL				,;	//20 -> Se Considera o Periodo de Apontamento das Marcacoes
					  .F.				 ;	//21 -> Se Efetua o Sincronismo dos Horarios na Criacao do Calendario
					)
		(cAliasQry)->(dbSkip())
		Loop
    EndIF

	//-- Obtem Qtde de Marcacoes
	nLenMarc:=Len(aMarcacoes)

	aDet := {}

	// 1 - Data
	// 2 - Codigo do Evento
	// 3 - Descricao do Evento
	// 4 - Descricao do Abono
	// 5 - Descricao do Abono
	// 6 - Quantidade de horas Abonadas
	// 7 - Marcacoes

	dbSelectArea( "SPC" )
	If DbSeek((cAliasQry)->RA_FILIAL + (cAliasQry)->RA_Mat )
		While !Eof() .And. SPC->PC_FILIAL+SPC->PC_Mat == (cAliasQry)->RA_FILIAL+(cAliasQry)->RA_Mat

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste controle de acessos e filiais validas               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Eval(cAcessaSPC)
				SPC->(dbSkip())
				Loop
			EndIf

			//-- Verifica o Periodo Solicitado
			If Empty(SPC->PC_DATA) .OR. SPC->PC_DATA < dInicio .OR. SPC->PC_DATA > dFim
				DbSkip()
				Loop
			Endif

			//-- Verifica se Deve Imprimir os Abonados
			If !lImpAbon .And. SPC->PC_QTABONO > 0
				dbSkip()
				Loop
			Endif

			//-- Utiliza o codigo informado qdo houver
			cPD := If(Empty(SPC->PC_PDI),SPC->PC_PD,SPC->PC_PDI)

			//-- Verifica se e um codigo contido na relacao de codigos 
			//-- definidas segundo avariavel cCodigos
			nPos := Ascan(aAutorizado,{ |x| x[1] = cPD })
            //-- Se o Codigo do Evento apontado  eh Valido
			If nPos > 0
				//-- Obtem a quantidade do evento apontando
				xQuant := If(SPC->PC_QUANTI>0,SPC->PC_QUANTI,SPC->PC_QUANTC)
                //-- Posiciona na TabCalend para a Data Lida
                nTab := aScan(aTabCalend, {|x| x[1] == SPC->PC_DATA .And. x[4] == '1E' })
				//-- Se existir calendario para o apontamento
				//-- Obs.: Se um apontamento for digitado pode ocorrer de nao ter
				//--       uma data correspondente na TabCalend ???
				If nTab>0
			  	   //-- Obtem a Ordem para a Data Lida
			  	   cOrdem    := aTabCalend[nTab,2] //-- Ordem		
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Obtem as Previsoes Cadastradas p/a Ordem Lida  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aPrevFun:={}
					If lPrevisao 
					    nLenCalend:=Len(aTabCalend)
					    nPosTab:=nTab
						//-- Corre as Previsoes de mesma Ordem
						While cOrdem == aTabCalend[nPosTab,2]
						    Aadd(aPrevFun,StrTran(StrZero(aTabCalend[nPosTab,3],5,2),'.',':'))
							//-- Obtem novo Horario	          			 
							nPosTab ++                  
							If	nPosTab > nLenCalend
							    Exit
							Endif    
						EndDo	
					Endif                                              
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Obtem as Marcacoes Realizadas para a Ordem Lida³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aMarcFun:={}
					If lImpMar
						//-- A aMarcacoes ‚ setado para a 1a Marca‡„o do dia em quest„o.
						//-- de acordo com a ordem da tabela
						nPosMarc:=Ascan(aMarcacoes,{|x| x[3]==cOrdem})
						//-- Se Existir Marcacao para o Dia
						If !Empty(nPosMarc)
							//--  Corre Todas as marcacoes enquanto a mesma ordem
							While cOrdem == aMarcacoes[nPosMarc,3]
								  //-- Monta o array com as Marcacoes do funcionario para a ordem.
								  Aadd(aMarcFun,StrTran(StrZero(aMarcacoes[nPosMarc,2],5,2),'.',':'))
						 		  nPosMarc++
						 		  //-- Se o contador ultrapassar o total de Marcacoes abandona loop
						 		  If nPosMarc>nLenMarc
						 			 Exit
						 		  Endif   
							EndDo
					    Endif
				    Endif
				Endif

				aJustifica := {}
				If lImpMot
					//-- Verifica se existe abonos e posiciona registro de abono
					fAbonos(SPC->PC_DATA, aAutorizados[nPos,1],,@aJustifica,SPC->PC_TPMARCA,SPC->PC_CC)
        		Endif

				If nSinAna == 1	// Sintetica                  
				    //-- Sintetiza por Evento
					If (nPosDet:=Ascan(aDet,{ |x| x[2] = cPD })) > 0
						aDet[nPosDet,4]:=SomaHoras(aDet[nPosDet,4],xQuant)
						//-- Acumula Abonado somente se Nao for imprimir os motivos do mesmo
						aDet[nPosDet,6]		:=If(Empty(aDet[nPosDet,6]),SomaHoras(aDet[nPosDet,6],SPC->PC_QTABONO),aDet[nPosDet,6])
						aDet[nPosDet,12]	:='A' //Ordem para Obrigar que esse seja o primeiro elemento
												  //apos o Sort do aDet	
				    Endif
 					//-- Acrescenta os motivos de abono para o evento
					If Len(aJustifica) > 0 .And. lImpMot
						For nX := 1 To Len(aJustifica)
							//-- Totaliza cada motivo para o mesmo evento
							If (nPosDet:=Ascan(aDet,{ |x| x[2] = cPD .AND. x[11]==aJustifica[nX,1]})) > 0
								//-- Totaliza Abonos para mesmo motivo
								aDet[nPosDet,6]:=SomaHoras(aDet[nPosDet,6],aJustifica[nX,2])
							Else
								aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,xQuant,;
								PADR(DescAbono(aJustifica[nX,1],'C'),25),;
								aJustifica[nX,2],aMarcFun,aPrevFun,SPC->PC_TPMARCA,SPC->PC_CC,	aJustifica[nX,1],'Z'})
							Endif
						Next nX
					Else
							If nPosDet==0
							   aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,	xQuant,;
						       	SPACE(25),0,aMarcFun,aPrevFun,SPC->PC_TPMARCA,SPC->PC_CC,SPACE(3),'Z'})
						    Endif   	
					Endif
				Else
					If Len(aJustifica) > 0 .And. lImpMot
						For nX := 1 To Len(aJustifica)
		    	    	    aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] , xQuant,;
							PADR(DescAbono(aJustifica[nX,1],'C'),25),aJustifica[nX,2],aMarcFun,aPrevFun,SPC->PC_TPMARCA,SPC->PC_CC,SPACE(3),'A' })
						Next nX
					Else
						aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,	xQuant,;
						SPACE(25),0,aMarcFun,aPrevFun,SPC->PC_TPMARCA,SPC->PC_CC,SPACE(3),'A'  })
					Endif
				Endif
			Endif
			DbSkip()
		EndDo

	Endif

	// Verifica se não carregou as marcações e salta para o proximo funcionario
	If Len(aDet) == 0
		(cAliasQry)->(DbSkip())
		Loop
	Endif

	//-- O Sort para Analitico e por Data e ordem 
	If nSinAna==2
  	   aSort(aDet,,,{|x,y| Dtos(x[1])+x[12] < Dtos(y[1])+y[12]}) //Data+ordem de leitura
	Else 
		//-- O Sorte no Sintetico e por Evento 
		aSort(aDet,,,{|x,y|x[2]+x[12] < y[2]+y[12]}) //Data+ordem de leitura			
	Endif                  

	l050OK:= .T.

	oSection:PrintLine()
	oReport:SkipLine()
	oSection1:Init(.F.) 

	If nSinAna == 2	.Or. lHeaderMar // Imprime cabecalho das marcacoes caso seja analitico
		oSection1:SetHeaderSection(.T.)
		oSection1:PrintHeader() 
		oSection1:SetHeaderSection(.F.)
		lHeaderMar := .F.
	Endif
		
	dDtMarc := CTOD(" / / ")
	For nFor := 1 to Len( aDet )

		cPrevDet := ""
		cRealDet := ""
		
		nLimite := Max(Len(aDet[nFor,7]),Len(aDet[nFor,8]))
		
	    If dDtMarc <> aDet[nFor,1]
		    dDtMarc := aDet[nFor,1]
			//-- Altera valores da Section
			For nX := 1 to nLimite
				If Len(aDet[nFor,8]) >= nX
					cPrevDet += aDet [ nFor , 8 , nX ] + Space(1)
				Endif
				If Len(aDet[nFor,7]) >= nX
					cRealDet += aDet [ nFor , 7 , nX ] + Space(1)
				Endif
			Next
		Endif

		If (lPrevisao  .AND. lImpMar)
			oSection1:Cell( "REALIZADO"):SetValue(cRealDet)
			oSection1:Cell( "PREVISTO"):SetValue(cPrevDet)
			oSection1:Cell( "DATA"):SetValue( SubStr( Dtos(aDet[nFor,1]),7,2) + "/" + SubStr(Dtos(aDet[nFor,1]),5,2) )
		ElseIf (lPrevisao  .AND. !lImpMar)
			oSection1:Cell( "REALIZADO"):SetValue(Space(24))
			oSection1:Cell( "PREVISTO"):SetValue(cPrevDet)
			oSection1:Cell( "DATA"):SetValue( SubStr( Dtos(aDet[nFor,1]),7,2) + "/" + SubStr(Dtos(aDet[nFor,1]),5,2) )
		ElseIf (!lPrevisao .AND.  lImpMar)
			oSection1:Cell( "REALIZADO"):SetValue(cRealDet)
			oSection1:Cell( "PREVISTO"):SetValue(Space(24))
			oSection1:Cell( "DATA"):SetValue( SubStr( Dtos(aDet[nFor,1]),7,2) + "/" + SubStr(Dtos(aDet[nFor,1]),5,2) )
		ElseIf (!lPrevisao  .AND. !lImpMar)
			oSection1:Cell( "PREVISTO"):SetValue(Space(24))
			oSection1:Cell( "REALIZADO"):SetValue(Space(24))
			oSection1:Cell( "DATA"):SetValue(Space(5))
		Endif

		oSection1:Cell( "ABONO"):SetValue(aDet[nFor,2])
		oSection1:Cell( "DESCABONO"):SetValue(aDet[nFor,3])
		oSection1:Cell( "HORAS"):SetValue(STRTRAN(StrZero(aDet[nFor,4],6,2),".",":"))				

		If lImpMot .And. nSinAna == 2	// Imprime Motivo e relatorio for Analitico
			If !Empty(aDet[nFor,5]) //-- Evento Com Abonos a Imprimir na Data Lida
				//-- Motivo do Abono
				oSection1:Cell( "JUSTIFICATIVA"):SetValue(aDet[nFor,5])				
				If aDet[nFor,6] > 0
					oSection1:Cell( "VISTO"):SetValue(STRTRAN(StrZero(aDet[nFor,6],6,2),".",":"))				
				Endif
			Else
				oSection1:Cell( "JUSTIFICATIVA"):SetValue(Repl("_",30))				
				oSection1:Cell( "VISTO"):SetValue(Repl("_",20))				
			Endif
		Else
			oSection1:Cell( "JUSTIFICATIVA"):SetValue(Repl("_",30))				
			oSection1:Cell( "VISTO"):SetValue(Repl("_",20))				
		Endif

		//-- Imprime os conteudos da Section
	   	oSection1:PrintLine()
		oReport:SkipLine()
	Next

	oSection1:Finish()
	oReport:ThinLine()
	oReport:SkipLine()		

	(cAliasQry)->(DbSkip())

EndDo

oSection:Finish()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select(cAliasQry) > 0
	(cAliasQry)->(dbCloseArea())
Endif

Return



//---------------- PONR060

//Autorizacao do Pagamento de Horas Extras                   ³±±
Static Function LR060()
Local	oReport   
Local	aArea 		:= GetArea()

oReport := Report060Def()
oReport:PrintDialog()

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Report060Def  ³ Autor ³ Totvs IP RH           ³ Data ³12/04/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Autorizacao do Pagamento de Horas Extras                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PONR060                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PONR060 - Generico                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Report060Def()
Local oReport 
Local oSection1 
Local oSection2 
Local bBlkFil := { || If ( cCodFilial != (cAliasQry)->RA_FILIAL, Eval( { || fInfo(@aInfo,(cAliasQry)->RA_FILIAL), aInfo[3] } ), aInfo[1] ) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao dos componentes de impressao                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE REPORT oReport NAME "PONR060" TITLE 'Relatorio para Autorizacao do Pagamento de Horas Extras' ACTION {|oReport| PN060Imp(oReport)} DESCRIPTION OemtoAnsi("Este programa emite Relatorio para Autorizacao do Pagamento de Horas Extras") TOTAL IN COLUMN // 

	oSection1 := TRSection():New( oReport, OemToAnsi("Funcionarios"), {"SRA","CTT","SR6"}, ,,,,,.F.,.F.,.F.)  

		TRCell():New(oSection1,"RA_FILIAL","SRA",,/*Picture*/,8,/*lPixel*/,{|| 	If(!Empty((cAliasQry)->RA_FILIAL),;
																								cCodFilial:= (cAliasQry)->RA_FILIAL,;
																								NIL),;
																								cCodFilial}	)
		TRCell():New(oSection1,"FILIAL","",OemToAnsi("Desc.Filial"),/*Picture*/,20,/*lPixel*/,{|| Eval( bBlkFil ) })	 

		TRCell():New(oSection1,"RA_CHAPA"	,"SRA",,,5)
		TRCell():New(oSection1,"RA_MAT"		,"SRA",,,6)
		TRCell():New(oSection1,"RA_NOME"	,"SRA",,,30,,,,.T.)
		TRCell():New(oSection1,"RA_CC"		,"SRA",OemToAnsi("C.Custo"),,9)				 
		TRCell():New(oSection1,"CTT_DESC01"	,"CTT",OemToAnsi("Descricao"),,25,,,,.T.) 	 
		TRCell():New(oSection1,"RA_TNOTRAB"	,"SRA",OemToAnsi("Tno"),,3)				 
		TRCell():New(oSection1,"R6_DESC"	,"SR6",,,20,,,,.T.)

	oSection2 := TRSection():New( oSection1, OemToAnsi("Marcações"),,,,,,,.F.,.F.,.F. )	 
                                                                              
		TRCell():New( oSection2, "MARCACOES"   	, "" ,OemToAnsi("Marcações"),,48,,,,.T.) 	
		TRCell():New( oSection2, "DATA"     	, "" ,OemToAnsi("Data"),,5)			
		TRCell():New( oSection2, "CODIGO"     	, "" ,OemToAnsi( "Cod"),,3) 			
		TRCell():New( oSection2, "DESCRICAO"	, "" ,OemToAnsi("Descricao"),,20,,,,.T.) 	 
		TRCell():New( oSection2, "HORAS"		, "" ,OemToAnsi("Horas"),,6) 			 
		TRCell():New( oSection2, "VISTO"		, "" ,OemToAnsi("Visto"),,20) 		

	oReport:nRemoteType := NO_REMOTE
	oReport:nDevice := 5
	oReport:cFile := cArq3

	//oReport:cFile := "\divergencias\relatorio.pdf"

	oReport:nEnvironment = 2
	oReport:SetPreview(.F.)

		
Return(oReport)


Static Function PN060Imp(oReport)

Local oSection  := oReport:Section(1)
Local oSection1 := oReport:Section(1):Section(1)
Local cSitQuery := ""    
Local cCatQuery	:= ""  
Local nReg		:= 0
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de Acesso do Usuario                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "PONR060" , "SRA" , "2" ) + " } " )
Local cAcessaSPC 	:= &( " { || " + ChkRH( "PONR060" , "SPC" , "2" ) + " } " )
Local cCod029A	   	:= ''
Local cCod025A	   	:= ''

Local aAutorizado  	:= {}
Local xQuant       	:= 0
Local nPos         	:= 0
Local cPD          	:= Space(03)
Local nTab	     	:=0
Local cOrdem	 	:=''
Local nX		 	:= 0
Local nFor		 	:= 0
Local cRealDet   	:= ""

Local cFilSRACTT	:= ""
Local cFilSRASR6	:= ""

Local oBreakCc
Local oBreakFil
Local oBreakFun

Local lHeaderMar	:= .T.

Private aInfo		:= {}
Private cCodFilial	:= "##"

Private aDet       := {}
Private aMarcFun   := {}
Private aTabPadrao := {}
Private aTabCalend := {}
Private aMarcacoes := {}
Private nPosMarc   := 0 
Private nLenMarc   := 0

Private cAliasQry 	:= GetNextAlias()

Private cFilAnte   := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o periodo de Apura‡„o, de acordo com MV_PAPONTA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !PerAponta(@dPerIni,@dPerFim)
	Return( NIL )
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega todas as tabelas de hor rio                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !fTabTurno(aTabPadrao)
	Return
EndIf

//-- Modifica variaveis para a Query
For nReg:=1 to Len(cSit)
	cSitQuery += "'"+Subs(cSit,nReg,1)+"'"
	If ( nReg+1 ) <= Len(cSit)
		cSitQuery += "," 
	Endif
Next nReg        
cSitQuery := "%" + cSitQuery + "%"

cCatQuery := ""
For nReg:=1 to Len(cCat)
	cCatQuery += "'"+Subs(cCat,nReg,1)+"'"
	If ( nReg+1 ) <= Len(cCat)
		cCatQuery += "," 
	Endif
Next nReg        
cCatQuery := "%" + cCatQuery + "%"

	
BEGIN REPORT QUERY oSection

cFilSRACTT	:= "%" + FWJoinFilial("SRA", "CTT") + "%"
cFilSRASR6	:= "%" + FWJoinFilial("SRA", "SR6") + "%"	

cOrdem := "%SRA.RA_FILIAL,SRA.RA_CC,SRA.RA_NOME%"

cQryProcesso := "%(SRA.RA_DEMISSA = '          ' OR (SRA.RA_DEMISSA >= '"+DTOS(dPerIni) + "' AND  SRA.RA_DEMISSA <> '          '))%"

If 	!Empty(mv_par02)
	cQryLR		:= "%"
	cQryLR		+= "SRA.RA_CC= '"+mv_par02+"' AND SRA.RA_MAT>= '"+mv_par07+"' AND SRA.RA_MAT<='"+mv_par08+"' "
	cQryLR		+= "%"
Else
	cQryLR		:= "%"
	cQryLR		+= "SRA.RA_MAT>= '"+mv_par07+"' AND SRA.RA_MAT<='"+mv_par08+"' "
	cQryLR		+= "%"
EndIf 
	
BeginSql alias cAliasQry
	SELECT SRA.RA_FILIAL, SRA.RA_CC, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_TNOTRAB, SRA.RA_DEMISSA,SRA.RA_ADMISSA,SRA.RA_SITFOLH,
			SRA.RA_CHAPA,SRA.RA_SEQTURN,SRA.RA_REGRA,
		CTT.CTT_FILIAL, CTT.CTT_CUSTO, CTT.CTT_DESC01,
		SR6.R6_TURNO, SR6.R6_DESC
	FROM %table:SRA% SRA
	INNER JOIN %table:CTT% CTT ON RA_CC = CTT_CUSTO AND CTT.%NotDel% AND %exp:cFilSRACTT%
	INNER JOIN %table:SR6% SR6 ON RA_TNOTRAB = R6_TURNO AND SR6.%NotDel% AND %exp:cFilSRASR6%
	WHERE SRA.RA_SITFOLH	IN	(%exp:Upper(cSitQuery)%) 	AND
		  SRA.RA_CATFUNC	IN	(%exp:Upper(cCatQuery)%)	AND
		  SRA.RA_FILIAL= %exp:c050Filial%  AND 
	      %exp:cQryProcesso% AND 
		  %exp:cQryLR% AND 
 	      SRA.%notDel%   
	ORDER BY %exp:cOrdem%
EndSql

END REPORT QUERY oSection 

DEFINE BREAK oBreakFil OF oSection WHEN {|| (cAliasQry)->RA_FILIAL }  TITLE OemToansi("Relatorio para Autorizacao do Pagamento de Horas Extras") 
oBreakFil:SetPageBreak(.T.)
oBreakFil:SetHeaderBreak(.T.) 

DEFINE BREAK oBreakFun OF oSection WHEN {|| (cAliasQry)->RA_MAT }  TITLE OemToansi("Relatorio para Autorizacao do Pagamento de Horas Extras") 
oBreakFun:SetHeaderBreak(.T.) 
If lImpFol
	oBreakFun:SetPageBreak(.T.) 
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quebra de pagina C.Custo                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE BREAK oBreakCc OF oSection WHEN {|| (cAliasQry)->RA_CC } TITLE OemToansi("Relatorio para Autorizacao do Pagamento de Horas Extras") 
If lCC 
	oBreakCc:SetPageBreak(.T.) 
	oBreakCc:SetHeaderBreak(.T.) 
Endif 
oSection:SetHeaderSection(.T.)
oSection:SetHeaderBreak(.T.) 

oSection1:SetHeaderSection(.F.)
oSection1:SetHeaderBreak(.F.) 

oSection:lHeaderPage:=.F. 
oSection1:lHeaderPage:=.F. 

// Na quebra de pagina executa: Impressao da Linha do funcionario,pula linha,impressão do cabecalho das marcacoes, pula linha
oReport:OnPageBreak( {|| oReport:lOnPageBreak:= .F.,lHeaderMar := .T.,;
							If((oSection1:lPrinting ),;
								(oSection:PrintLine(),	;
									oReport:SkipLine(),;
									oSection1:SetHeaderSection(.T.),;
									oSection1:PrintHeader(),;
									oSection1:SetHeaderSection(.F.),;
									oReport:SkipLine();
								);
							,);
					 },.F. )

cFilAnte := (cAliasQry)->RA_FILIAL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a variavel aInfo com a filial Logada              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fInfo(@aInfo,(cAliasQry)->RA_FILIAL)

aTabOPadrao  := {}
aTabOrigin   := {}
aTabCalend   := {}

If nSinAna == 1
	osection1:ACELL[1]:cTitle:=space(1)
	osection1:ACELL[2]:cTitle:=space(1)
Endif

//-- Define o total da regua da tela de processamento do relatorio
oReport:SetMeter( 100 )  

//-- Incializa impressao   
oSection:Init(.F.)                                                  

While !(cAliasQry)->( EOF() ) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:IncMeter( 1 )   
	
	//-- Verifica se o usuário cancelou a impressão do relatorio
	If oReport:Cancel()
		Exit
	EndIf               
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Posiciona o registro da query na tabela de Funcionarios                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !SRA->(dbSeek( (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT ))
		(cAliasQry)->(DbSkip())
		Loop
	Endif
	
	//-- Processa quebra de Filial.
	If (cAliasQry)->RA_FILIAL != cFilAnte 
	    //--Somente "Zera" as variaveis se jah foi impresso algo para nao pula 
	    //--de pagina na primeira vez
		
		cFilAnte := (cAliasQry)->RA_FILIAL
		
		If !fInfo(@aInfo,(cAliasQry)->RA_FILIAL)
			Exit
		Endif	
		
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Consiste Filiais e Acessos                                             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF !( (cAliasQry)->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
		(cAliasQry)->(DbSkip())
		Loop
	EndIF
	
	//-- Cria Calendario com o periodo completo com Trocas de Turno
	aTabCalend := {} ; aTurnos   := {} ; aMarcacoes := {}
	
	//-- Carrega as Marcacoes do Periodo
	IF !GetMarcacoes( @aMarcacoes		,;	//Marcacoes dos Funcionarios
					  @aTabCalend		,;	//Calendario de Marcacoes
					  @aTabPadrao		,;	//Tabela Padrao
					  @aTurnos			,;	//Turnos de Trabalho
					  dPerIni 			,;	//Periodo Inicial
					  dPerFim			,;	//Periodo Final
					  SRA->RA_FILIAL	,;	//Filial
					  SRA->RA_MAT		,;	//Matricula
					  SRA->RA_TNOTRAB	,;	//Turno
					  SRA->RA_SEQTURN	,;	//Sequencia de Turno
					  SRA->RA_CC		,;	//Centro de Custo
					  "SP8"				,;	//Alias para Carga das Marcacoes
					  .F.    			,;	//Se carrega Recno em aMarcacoes
					  .T.      			,;	//Se considera Apenas Ordenadas
					  .T.      			,;	//Se Verifica as Folgas Automaticas
					  .F.      			 ;	//Se Grava Evento de Folga Automatica Periodo Anterior
					)
		(cAliasQry)->(dbSkip())
		Loop
    EndIF
	
	//-- Obtem Qtde de Marcacoes
	nLenMarc:=Len(aMarcacoes)
	
	aDet := {}
	
	// 1 - Data
	// 2 - Codigo do Evento
	// 3 - Descricao do Evento
	// 4 - Quantidade de horas Abonadas
	// 5 - Marcacoes
	
	dRef:=CTOD("  /  /  ")
	
	cTiposTurno := TiposTurno(SRA->RA_TNOTRAB,  SRA->RA_FILIAL)
	
	dbSelectArea( "SPC" )
	dbSetOrder(2) // Filial + Matricula + Data
	If SPC->(DbSeek((cAliasQry)->RA_FILIAL + (cAliasQry)->RA_Mat ))
		While SPC->(!Eof()) .And. SPC->(PC_FILIAL + PC_MAT) == (cAliasQry)->(RA_FILIAL + RA_MAT)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste controle de acessos e filiais validas               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SPC->( !Eval(cAcessaSPC) )
				SPC->(dbSkip())
				Loop
			EndIf
			
			//-- Verifica o Periodo Solicitado
			If Empty(SPC->PC_DATA) .OR. SPC->PC_DATA < dInicio .OR. SPC->PC_DATA > dFim
				DbSkip()
				Loop
			Endif
			
			If dRef != SPC->PC_DATA
				dRef := SPC->PC_DATA
				aAutorizado := {}
				If Ascan(aTabCalend,{ |x| DtoS(x[1]) == DtoS(dRef) }) > 0
					If SP4->(dbSeek(cFilSP4 := xFilial('SP4', SRA->RA_FILIAL)))
						While ! SP4->(Eof()) .And. cFilSP4 == SP4->P4_FILIAL 
							If(SP4->P4_TIPO $ cTiposTurno .And. SP4->P4_TURNO != SRA->RA_TNOTRAB)
								SP4->(dbSkip())	
								LOOP
							EndIf
							If nTipHoras == 1
								Aadd(aAutorizado, {SP4->P4_CODAUT, If(SP9->(dbSeek(fFilFunc('SP9') + SP4->P4_CODAUT)), SP9->P9_DESC, Space(20))})
							ElseIf nTipHoras == 2
								Aadd(aAutorizado, {SP4->P4_CODNAUT, If(SP9->(DbSeek(fFilFunc('SP9') + SP4->P4_CODNAUT)), SP9->P9_DESC, Space(20))})
							ElseIf nTipHoras == 3
								Aadd(aAutorizado, {SP4->P4_CODAUT, If(SP9->(dbSeek(fFilFunc('SP9') + SP4->P4_CODAUT)), SP9->P9_DESC, Space(20))})
								Aadd(aAutorizado, {SP4->P4_CODNAUT, If(SP9->(DbSeek(fFilFunc('SP9') + SP4->P4_CODNAUT)), SP9->P9_DESC, Space(20))})
							Endif	 
							SP4->(dbSkip())
						EndDo
					Endif    
					If nTipHoras <> 2
						cCod029A := PosSP9("029A", SRA->RA_FILIAL,"P9_IDPON", 2)
						If !Empty(cCod029A)
							Aadd(aAutorizado, {SP9->P9_CODIGO,SP9->P9_DESC})
						Endif
						cCod025A := PosSP9("025A", SRA->RA_FILIAL, "P9_IDPON", 2)
						If !Empty(cCod025A)
							Aadd(aAutorizado, {SP9->P9_CODIGO, SP9->P9_DESC})
						Endif	
					Endif 
				Endif
			Endif
			
			//-- Quando houver codigo informado, este sera utilizado
			//-- em substituicao ao codigo apontado
			cPD := If(Empty(SPC->PC_PDI),SPC->PC_PD,SPC->PC_PDI)
			
			//-- Verifica se e um codigo contido na relacao de codigos 
			//-- definidas segundo avariavel cCodigos
			nPos := Ascan(aAutorizado,{ |x| x[1] = cPD })
            //-- Se o Codigo do Evento apontado  eh Valido
			If nPos > 0
				//-- Obtem a quantidade do evento apontando
				xQuant := If(SPC->PC_QUANTI>0,SPC->PC_QUANTI,SPC->PC_QUANTC)
                //-- Posiciona na TabCalend para a Data Lida
                nTab := aScan(aTabCalend, {|x| x[1] == SPC->PC_DATA .And. x[4] == '1E' })
				
				//-- Se existir calendario para o apontamento
				//-- Obs.: Se um apontamento for digitado pode ocorrer de nao ter
				//--       uma data correspondente na TabCalend ???
				If nTab>0
			  		//-- Obtem a Ordem para a Data Lida
			  		cOrdem    := aTabCalend[nTab,2] //-- Ordem		
					
					aMarcFun:={}
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Obtem as Marcacoes Realizadas para a Ordem Lida³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lImpMar
						//-- o Arquivo ‚ setado para a 1a Marca‡„o do dia em quest„o.
						//-- de acordo com a ordem da tabela
						nPosMarc:=Ascan(aMarcacoes,{|x| x[3]==cOrdem})
						//-- Se Existir Marcacao para o Dia
						If !Empty(nPosMarc)
							//--  Corre Todas as marcacoes enquanto a mesma ordem
							While cOrdem == aMarcacoes[nPosMarc,3]
								//-- Monta o array com as Marcacoes do funcionario para a ordem.
								Aadd(aMarcFun,StrTran(StrZero(aMarcacoes[nPosMarc,2],5,2),'.',':'))
								nPosMarc++
								//-- Se o contador ultrapassar o total de Marcacoes abandona loop
								If nPosMarc>nLenMarc
									Exit
								Endif   
							EndDo
					    Endif
				   Endif
				Endif
				
				If nSinAna == 1	// Sintetica
					If (nPosDet:=Ascan(aDet,{ |x| x[2] =  cPD })) > 0
						aDet[nPosDet,4]:=SomaHoras(aDet[nPosDet,4],xQuant)
					Else
						aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,	xQuant, aMarcFun })	
					Endif			
				Else
					aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] , xQuant, aMarcFun })	
				Endif
			Endif
			SPC->(DbSkip())
		EndDo
	Endif

	// Verifica se não carregou as marcações e salta para o proximo funcionario
	If Len(aDet) == 0
		(cAliasQry)->(DbSkip())
		Loop
	Endif

	l060OK:= .T.

	//-- O Sort para Analitico e por Data e ordem 
	aSort(aDet,,,{|x,y| x[1] < y[1] })
	
	oSection:PrintLine()
	oReport:SkipLine()
	oSection1:Init(.F.) 

	If nSinAna == 2	.Or. lHeaderMar // Imprime cabecalho das marcacoes caso seja analitico
		oSection1:SetHeaderSection(.T.)
		oSection1:PrintHeader() 
		oSection1:SetHeaderSection(.F.)
		lHeaderMar := .F.
	Endif
		
	dDtMarc := CTOD(" / / ")
	For nFor := 1 to Len( aDet )

		cRealDet := ""
		
		If lImpMar
		    If dDtMarc <> aDet[nFor,1]
			    dDtMarc := aDet[nFor,1]
				//-- Altera valores da Section
				For nX := 1 to Len(aDet [ nFor , 5])
					cRealDet += aDet [ nFor , 5 , nX ] + Space(1)
				Next
			Endif
		Endif
		
		If nSinAna == 1	// Sintetico
			oSection1:Cell( "MARCACOES"):SetValue(Space(48))
			oSection1:Cell( "DATA"):SetValue(Space(5))
		Else
			if lImpMar
				oSection1:Cell( "MARCACOES"):SetValue(cRealDet)
				oSection1:Cell( "DATA"):SetValue( SubStr( Dtos(aDet[nFor,1]),7,2) + "/" + SubStr(Dtos(aDet[nFor,1]),5,2) )
			Endif
		Endif
		
		oSection1:Cell( "CODIGO"):SetValue(aDet[nFor,2])
		oSection1:Cell( "DESCRICAO"):SetValue(aDet[nFor,3])
		oSection1:Cell( "HORAS"):SetValue(STRTRAN(StrZero(aDet[nFor,4],6,2),".",":"))				

		oSection1:Cell( "VISTO"):SetValue(Repl("_",30))

		//-- Imprime os conteudos da Section
	   	oSection1:PrintLine()
		oReport:SkipLine()
	Next

	oSection1:Finish()
	oReport:ThinLine()
	oReport:SkipLine()		

	(cAliasQry)->(DbSkip())

EndDo

oSection:Finish()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select(cAliasQry) > 0
	(cAliasQry)->(dbCloseArea())
Endif

Return


/*/{Protheus.doc} TiposTurno
Busca os tipos de hora extra que tem o turno preenchido
@author Cícero Alves
@since 13/05/2019
/*/
Static Function TiposTurno(cTurnoFunc, cFilialFunc)
	
	Local aArea		:= GetArea()
	Local cAliasSP4 := GetNextAlias()
	Local cTipos 	:= ""
	
	cLastTurno := cTurnoFunc
	cTipos := ""
	
	BeginSQL Alias cAliasSP4
		
		SELECT SP4.P4_TIPO
		FROM %table:SP4% SP4
		WHERE SP4.P4_FILIAL = %Exp:xFilial("SP4", cFilialFunc)% AND
		P4_TURNO = %Exp:cTurnoFunc% AND
		SP4.%NotDel%
		
	EndSQL
	
	While (cAliasSP4)->(! Eof())
		cTipos += (cAliasSP4)->P4_TIPO + "/"
		(cAliasSP4)->(dbSkip())
	End
	
	(cAliasSP4)->(dbCloseArea())
	
	RestArea(aArea)
	
Return cTipos


Static Function NVEmail(cEmails)

    Local cHTML,cServer,cAccount,cPassword,cAutentic,cEnvia,lResulConn
    Local lResulSend:= .T.


    
    cHTML 		:= ""
    cServer		:= GetMv("MV_RELSERV")
    cAccount	:= GetMv("MV_RELACNT")
    cPassword	:= GetMv("MV_RELPSW")
    cAutentic	:= GetMv("MV_RELAUTH")
    cEnvia		:= GetMv("MV_RELACNT")

    cHtml	+= "<html>"
    cHtml	+= "<body>"
	cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'><span style='font-family:" + "Bookman Old Style" + ",serif;'>Prezados, </span></p>
    cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'><span style='font-family:" + "Bookman Old Style" + ",serif;'>Segue anexo relatório de Divergências, Abono e Horas Extras, para as devidas correções. Peço a gentileza que as correções sejam feitas o quanto antes, para não haver atrasos na entrega dos espelhos de ponto, no fechamento da competência no dia 16.</span></p>
    cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'>&nbsp;</p>
    //cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'><strong><span style='font-family:" + "Bookman Old Style" + ",serif;'>IT155-  Controle de Apontamento de Ponto </span></strong>
	//cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'><strong><span style='font-family:" + "Bookman Old Style" + ",serif;'>7. 4. Período de Apontamento. </span></strong>
    //cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'><strong><span style='font-family:" + "Bookman Old Style" + ",serif;'></span></strong><span style='font-family:" + "Bookman Old Style" + ",serif;'>O Período de apontamento manual ou biométrico tem inicio no dia 17 do mês anterior e fechamento no dia 16 do mês atual. Sendo assim, o prazo para entrega do LR320-Justificativa de Falta de Marcação, para os casos onde é necessária correção no apontamento, e entrega do LR229 – Apontamento Manual de Jornada de Trabalho e LR043 - Autorização para Abono e LR240-Requerimento caso haja necessidade de exclusão de marcação impar, é de no máximo 1 dia útil após o fechamento para que haja o processamento no mês atual e pagamento até o 5º dia útil do mês subsequente </span></p>
    cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'><span style='font-family:" + "Bookman Old Style" + ",serif;color:red;'><span style='color: rgb(0, 0, 0); font-family: " + "Bookman Old Style" + ", serif; font-size: 15px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;'>Att,</span></span></p>
    cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'>&nbsp;</p>
    cHtml	+= "<p style='margin:0cm;font-size:15px;font-family:" + "Calibri" + ",sans-serif;'><span style='font-family:" + "Bookman Old Style" + ",serif;color:red;'><span style='color: rgb(0, 0, 0); font-family: " + "Bookman Old Style" + ", serif; font-size: 15px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;'><strong>Grupo Novel</strong></span></span></p>
    cHtml	+= "</body>"
    cHtml	+= "</html>"
 
  //Manda e e-mail
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
  
  lResulConn := MailAuth(cAccount, cPassword)
  If lResulConn

    _cAssunto := 'Relatorio divergencias, abonos e horas extras. Ref. De: ' + DtoC(mv_par05) + ' Ate: '+ DtoC(mv_par06) 
	
    SEND MAIL FROM cAccount TO cEmails SUBJECT _cAssunto  BODY cHtml ATTACHMENT aAnexos[1],aAnexos[2],aAnexos[3] RESULT lResulSend  
    If !lResulSend
	   GET MAIL ERROR cError
	   	Conout("Falha no Envio do e-mail: " + cError)
    EndIf
EndIf

Return


/******************************/
Static Function ValidPerg(cPerg)
Local _sAlias := Alias()
Local aRegs   := {}
Local i, j

dbSelectArea("SX1")
dbSetOrder(1)

cX1Grupo := "SX1->X1_GRUPO" 

cPerg := Padr(cPerg, Len(&(cX1Grupo)))

aAdd(aRegs,{cPerg,"01","Filial De"			,"Filial De"		,"Filial De"		,"mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"02","Filial Até"			,"Filial Até"		,"Filial Até"		,"mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"03","Centro Custo De"	,"Centro Custo De"	,"Centro Custo De"	,"mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
aAdd(aRegs,{cPerg,"04","Centro Custo Ate"	,"Centro Custo Até"	,"Centro Custo Até"	,"mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
aAdd(aRegs,{cPerg,"05","Data De"			,"Data De"			,"Data De"			,"mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Data Ate"			,"Data Ate"			,"Data Ate"			,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Matr De"			,"Matr De"			,"Matr De"			,"mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
aAdd(aRegs,{cPerg,"08","Matr Ate"			,"Matr Até"			,"Matr Até"			,"mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})

For i := 1 to Len(aRegs)
	If 	!dbSeek( cPerg + aRegs[i,2] )
		RecLock("SX1", .T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock("SX1")
	Endif
Next

dbSelectArea(_sAlias)

Return                                                             
