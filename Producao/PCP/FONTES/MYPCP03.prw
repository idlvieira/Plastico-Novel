#Include "rwmake.ch"
#include 'protheus.ch'
#include 'parmtype.ch'
#Include "topconn.ch"
#Include "MsObject.ch"
#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYPCP03.prw    | Autor : Leandro Ferreira      | Data : 29/04/2020 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Tela de apontamento modelo Novel	                                 |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante       Motivo
// 29/04/2020  Leandro Ferreira          Giuliano Olivetti Unificação do apontamento      

User Function MYPCP03()
	Local aSize := {}
	Local bOk := {|| lUPD:=.T., iif(vldApont(aCabec),iif(aptMATA681(aCabec),limpaTela(@aCabec,@oDlg),oDlg:End()),lUPD:=.F.)}
	Local bCancel:= {|| lUPD:=.F. , oDlg:End()}
	Local lHasButton := .T.
	Local lUPD := .T.
	Local oEnch    	
	Local aPos 	:= {100,009,009,009}        
	Local aCpoEnch	:= {}	
	Local aAlterGDa := {"OP", "QTDPERDA","MOTPERDA"} 	
	Local aField	:= {} 
	Local aHeader	:= {} 
	Local aCols	:= {} 
	Local nOpc := 3
	Local lMemoria 	:= .T. 
	Local cLinOk := "AllwaysTrue"
	Local cTudoOk := "AllwaysTrue"
	Local cIniCpos := "SEQUEN"
	Local nFreeze := 000
	Local nMax := 999
	Local cFieldOk := "AllwaysTrue"
	Local cSuperDel := ""
	Local cDelOk := "AllwaysFalse"
	Local oFont14 := TFont():New('Arial',,-12,,.T.)
	Local aCabec := {0,date(),time(),date(),time(),"          ","P",date(),"  ",time(),time(),"           ",0,"  " }
	Local cEnvMod := "PCP"
	PRIVATE _AC		:= {}
	aSize := MsAdvSize(.F.)
	dbSelectArea("SH6")
	dbSelectArea("SBC")
	dbSelectArea("SC2")
	dbSelectArea("CYN")

	Define MsDialog oDlg TITLE "Apontamento Novel" STYLE DS_MODALFRAME From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

	//oGroup1:= TGroup():New(085,007,125,450,'Horas Improdutivas',oDlg,,,.T.)
	TSay():New(35,09,{|| "OP" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet12 := TGet():New( 45,09, { | u | If( PCount() == 0, aCabec[12], aCabec[12] := u ) },oDlg, 040, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[12]",,,,lHasButton  )
	oTGet12:cF3 := "SC2TMP"
	TSay():New(35,60,{|| "Quantidade" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet1 := TGet():New( 45,60, { | u | If( PCount() == 0, aCabec[1], aCabec[1] := u ) },oDlg, 040, 010, "@E 999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[1]",,,,lHasButton  )
	TSay():New(60,09,{|| "Data Inicial" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet2 := TGet():New( 70,9, { | u | If( PCount() == 0, aCabec[2], aCabec[2] := u ) },oDlg, 040, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[2]",,,,lHasButton  )
	TSay():New(60,60,{|| "Hora Inicial" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet3 := TGet():New( 70,60, { | u | If( PCount() == 0, aCabec[3], aCabec[3] := u ) },oDlg, 040, 010, "99:99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[3]",,,,lHasButton  )
	TSay():New(60,110,{|| "Data Final" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet4 := TGet():New( 70,110, { | u | If( PCount() == 0, aCabec[4], aCabec[4] := u ) },oDlg, 040, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[4]",,,,lHasButton  )
	TSay():New(60,160,{|| "Hora Final" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet5 := TGet():New( 70,160, { | u | If( PCount() == 0, aCabec[5], aCabec[5] := u ) },oDlg, 040, 010, "99:99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[5]",,,,lHasButton  )
	TSay():New(85,09,{|| "Recurso" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet6 := TGet():New( 95,09, { | u | If( PCount() == 0, aCabec[6], aCabec[6] := u ) },oDlg, 040, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[6]",,,,lHasButton  )
	oTGet6:cF3 := "SH1"
	TSay():New(85,60,{|| "Parc/Total" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet7 := TComboBox():New(95,60,{|u|if(PCount()>0,aCabec[7]:=u,aCabec[7])},{'P','T'},040,10,oDlg,,{||Alert('Mudou item da combo')},,,,.T.,,,,,,,,,"aCabec[7]")
	//oTGet7 := TGet():New( 70,60, { | u | If( PCount() == 0, aCabec[7], aCabec[7] := u ) },oDlg, 040, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[7]",,,,lHasButton  )
	TSay():New(85,100,{|| "Apontamento" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet8 := TGet():New( 95,110, { | u | If( PCount() == 0, aCabec[8], aCabec[8] := u ) },oDlg, 040, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[1][8]",,,,lHasButton  )

	TGroup():New(115,007,155,210,'Perda Produtiva',oDlg,,,.T.)
	TSay():New(125,09,{|| "Quant. Perda" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet13 := TGet():New( 135,9, { | u | If( PCount() == 0, aCabec[13], aCabec[13] := u ) },oDlg, 040, 010, "@E 999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[13]",,,,lHasButton  )
	TSay():New(125,60,{|| "Motivo da perda" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet14 := TGet():New( 135,60, { | u | If( PCount() == 0, aCabec[14], aCabec[14] := u ) },oDlg, 040, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[14]",,,,lHasButton  )
	oTGet14:cF3 := "CYO003"

	TGroup():New(165,007,205,210,'Horas Improdutivas',oDlg,,,.T.)
	TSay():New(175,09,{|| "Hr.Improdutivas" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet9 := TGet():New( 185,09, { | u | If( PCount() == 0, aCabec[9], aCabec[9] := u ) },oDlg, 040, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[9]",,,,lHasButton  )
	oTGet9:cF3 := "CYN004"
	TSay():New(175,60,{|| "Hr. Inicial" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet10 := TGet():New( 185,60, { | u | If( PCount() == 0, aCabec[10], aCabec[10] := u ) },oDlg, 040, 010, "99:99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[10]",,,,lHasButton  )
	TSay():New(175,100,{|| "Hr. Final" },oDlg,,oFont14,,,,.T.,CLR_BLACK,CLR_WHITE,99,10)
	oTGet11 := TGet():New( 185,110, { | u | If( PCount() == 0, aCabec[11], aCabec[11] := u ) },oDlg, 040, 010, "99:99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"aCabec[11]",,,,lHasButton  )

	/*
	AADD(aField,{ "OP", "OP", "@!",11, 0,"AllwaysTrue()","", "C", "", "", "" } )
	AADD(aField,{ "Quant Perda", "QTDPERDA", "@E 999999",6, 0,"AllwaysTrue()","", "N", "", "", "" } )
	AADD(aField,{ "Motivo da Perda", "MOTPERDA", "@!",4, 0,"AllwaysTrue()","", "C", "", "", "" } )
	AADD(aField,{ "Descrição da Perda", "DESMTPER", "@!",50, 0,"AllwaysTrue()","", "C", "", "", "" } )
	aadd(aCols, {"","","","",.T.})
	*/
	/*
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek( "H6_OP" ) 
	AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
	dbSeek( "H6_QTDPROD" ) 
	AADD(aHeader,{ "Quant. Perda", x3_campo, x3_picture,x3_tamanho, x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
	dbSeek( "H6_MOTIVO" ) 
	AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
	aadd(aCols, {"           ",0,"   ",.F.})
	dbSelectArea("SH6")
	dbSetOrder(1)
	oGrid := MSNewGetDados():New(150,009,300,450,3,,"AlwaysTrue",,{"H6_OP","H6_QTDPROD","H6_MOTIVO"},0,999,,,,oDlg, aHeader,aCols)
	*/


	//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| lUPD:=.T., _AC:=oGrid:ACOLS, oDlg:End() } , bCancel) CENTERED
	//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| lUPD:=.T., oDlg:End()} , bCancel) CENTERED
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, bOk , bCancel) CENTERED
/*
	IF lUPD 
		if aCabec[1] < 1
			msgstop("Quantidade apontada não pode ser zerada")
		else

			lRet := aptMATA681(aCabec)
			if aCabec[9] != "" .AND. lRet == .T.
				aptMATA682(aCabec)
			endIf
		endIf
	EndIf 
*/
	//if lRet == .T.
	//RpcClearEnv() 
Return

Static Function vldApont(aCabec)

	If Empty(aCabec[12]) 
		msgBox(OemtoAnsi("Ordem de Producao deve ser informada.","Atencao Operador","INFO"))
		Return(.F.)
	elseIf Empty(aCabec[1]) .Or. aCabec[1] < 1
	 	msgBox(OemtoAnsi("Quantidade produzida deve ser informada.","Atencao Operador","INFO"))
	 	Return(.F.)
	elseIf Empty(aCabec[2]) .Or. Empty(aCabec[4]) .Or. Empty(aCabec[8])
	 	msgBox(OemtoAnsi("Data final,inicial e de apontamento devem ser informadas.","Atencao Operador","INFO"))
	 	Return(.F.)	
	elseIf DateDiffDay(aCabec[4],aCabec[2]) < 0
	 	msgBox(OemtoAnsi("Data final deve ser maior que a inicial.","Atencao Operador","INFO"))
	 	Return(.F.)	
	elseIf Empty(aCabec[3]) .Or. Empty(aCabec[5])
	 	msgBox(OemtoAnsi("Hora final e inicial devem ser informadas.","Atencao Operador","INFO"))
	 	Return(.F.)	
	elseIf SubHoras(aCabec[5],aCabec[3]) <= 0
	 	msgBox(OemtoAnsi("Hora final deve ser maior que a inicial informada.","Atencao Operador","INFO"))
	 	Return(.F.)	
	elseIf Empty(aCabec[6]) .Or. POSICIONE("SG2",4,xFilial("SG2")+aCabec[6],"G2_PRODUTO") == ""
	 	msgBox(OemtoAnsi("O recurso não foi informado ou é inválido.","Atencao Operador","INFO"))
	 	Return(.F.)	
	elseIf (aCabec[13] > 0 .And. Empty(aCabec[14])) .Or. (aCabec[13] == 0 .And. !Empty(aCabec[14]))
	 	msgBox(OemtoAnsi("Os campos da perda devem ser preenchidos por completo","Atencao Operador","INFO"))
	 	Return(.F.)
	elseIf ((Empty(aCabec[10]) .Or. Empty(aCabec[11])) .And. Empty(aCabec[9]));
			.Or. ((!Empty(aCabec[10]) .Or. !Empty(aCabec[11])) .And. Empty(aCabec[9]));
			.Or. ((Empty(aCabec[10]) .Or. Empty(aCabec[11])) .And. !Empty(aCabec[9]));
			.Or. ((!Empty(aCabec[10]) .Or. !Empty(aCabec[11])) .And. Empty(aCabec[9]));
			.Or. (SubHoras(aCabec[11],aCabec[10]) <= 0 .And. !Empty(aCabec[9]))			
	 	msgBox(OemtoAnsi("Os campos de hora improdutiva preenchidos por completo e corretamente","Atencao Operador","INFO"))
	 	Return(.F.)
	EndIf
Return .T.

Static function limpaTela(aCabec,oDlg)
	aCabec := {0,date(),time(),date(),time(),"          ","P",date(),"  ",time(),time(),"           ",0,"  " }
	msgBox(OemtoAnsi("Apontamento realizado com sucesso.","Atencao Operador","INFO"))
	oDlg:Refresh()
Return

Static function aptMATA681(aCabec)

	Local aApont := {}

	Private lMsErroAuto :=.F.
	Private lMsHelpAuto :=.T.

	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "COM" TABLES "SH6"
	//{"H6_PRODUTO", POSICIONE("SC2",1,xFilial("SC2")+oGrid[x][1],"C2_PRODUTO") , NIL},;
	//For x := 1 to len(oGrid)
	aApont := { {"H6_OP", aCabec[12]   , NIL},;	
	{"H6_PRODUTO", POSICIONE("SC2",1,xFilial("SC2")+aCabec[12],"C2_PRODUTO") , NIL},;//{"H6_PRODUTO", "I775706GAT02000" , NIL},;
	{"H6_OPERAC", "01" , NIL},;
	{"H6_RECURSO", aCabec[6] , NIL},;
	{"H6_DTAPONT", aCabec[8] , NIL},;
	{"H6_DTPROD",  aCabec[8] , NIL},;
	{"H6_DATAINI", aCabec[2] , NIL},;
	{"H6_HORAINI", aCabec[3] , NIL},;
	{"H6_DATAFIN", aCabec[4] , NIL},;
	{"H6_HORAFIN", aCabec[5] , NIL},;
	{"H6_PT", iif(aCabec[1]-aCabec[13] < aCabec[1], 'P','T')   , NIL},;
	{"H6_LOCAL", "10"   , NIL},;
	{"H6_QTDPROD", aCabec[1]-aCabec[13] , NIL}}

	// FIM: estorno //
	MSExecAuto({|x| mata681(x)},aApont)

	If (lMsErroAuto ==.T.)
		MostraErro()
		ConOut(Repl("-", 80))
		ConOut(PadC("Teste MATA681 finalizado com erro!", 80))
		ConOut(PadC("Fim: " + Time(), 80))
		ConOut(Repl("-", 80))
		lRet := .F.
	Else
		ConOut(Repl("-", 80))
		ConOut(PadC("Teste MATA681 finalizado com sucesso!", 80))
		ConOut(PadC("Fim: " + Time(), 80))
		ConOut(Repl("-", 80))
		if aCabec[13] > 0 .And. aCabec[14]!="" 
			aptMATA685(aApont,aCabec)  
		EndIf
		If aCabec[9] != "" 
				aptMATA682(aCabec)
		EndIf
		lRet := .T.
	EndIf
	//next
	//RESET ENVIRONMENT
Return lRet

Static function aptMATA685(aApont,aCabec)
	Local nOpc := 3 //3-Inclusão; 4-Alteração ; 6-Exclusão
	Local bCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local cEnvMod := "PCP"
	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "PCP"
	//RpcSetEnv( "01","0201",,,cEnvMod,,,,,,)
	conout ("teste de pcp")
	/*bCabec := {{"BC_OP" ,oGrid[1] ,NIL}}
	aItens := { {"BC_QUANT"   ,oGrid[2]      ,NIL},;
	{"BC_PRODUTO" ,aApont[2][2]  ,NIL},;
	{"BC_LOCORIG" ,aApont[12][2] ,NIL},;
	{"BC_TIPO"    ,"R"           ,NIL},;
	{"BC_DTVALID" ,aApont[5][2]  ,NIL},;
	{"BC_MOTIVO"  ,oGrid[3]      ,NIL}}*/
	bCabec := {{"BC_OP" 	 ,aCabec[12],NIL},;
			   {"BC_RECURSO" ,aCabec[6]	,NIL},;
			   {"BC_OPERAC"  , "01" 	,NIL}}

	aItens := { {"BC_QUANT"   ,aCabec[13]   	,NIL},;
				{"BC_PRODUTO" ,aApont[2][2]  	,NIL},;
				{"BC_LOCORIG" ,aApont[12][2]  	,NIL},;
				{"BC_TIPO"    ,"R"           	,NIL},;
				{"BC_DATA" 	  ,dDatabase  		,NIL},;
				{"BC_CODDEST" ,"103002000010028",NIL},;
				{"BC_LOCAL"	  ,aApont[12][2]	,NIL},;
				{"BC_QTDDEST" ,aCabec[13] 		,NIL},;
				{"BC_RECURSO" ,aCabec[6]		,NIL},;
				{"BC_OPERAC"  , "01"			,NIL},;
				{"BC_MOTIVO"  ,aCabec[14]       ,NIL}}
	AAdd(aLinha ,aItens)
	lMSErroAuto := .F.
	//y:=1
	//z:=1
	dbSelectArea("SBC")
	dbSetOrder(1)
	MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, bCabec, aLinha, 3)
	//MsExecAuto ({|x,y,z|MATA685(x,y,z) },bCabec,aLinha,nOpc)
	If lMSErroAuto
		MostraErro()
		Return .F.
	endif
	//RpcClearEnv()
Return .T.

Static function aptMATA682(aCabec)
	Local aVetor := {}
	lMsErroAuto := .F.
	dbselectarea("SH6")
	SH6->( dbsetorder(2) )
	//if Dbseek (xfilial("SH6")+"MOD000000002   ") 
	aVetor := {{"H6_RECURSO",aCabec[6]	,NIL},;
			   {"H6_DTAPONT",aCabec[8]	,NIL},;
			   {"H6_DATAINI",aCabec[8]	,NIL},;
			   {"H6_DATAFIN",aCabec[8]	,NIL},;
			   {"H6_HORAINI",aCabec[10]	,NIL},;
			   {"H6_HORAFIN",aCabec[11]	,NIL},;
			   {"H6_MOTIVO" ,aCabec[9]	,NIL},;
			   {"INDEX"		,2			,NIL}}
	dbSelectArea("SH6")
	dbSetOrder(1)
	MSExecAuto({|x,y| mata682(x,y)},aVetor,3)
	If lMsErroAuto
		Alert("Erro")
		Mostraerro()
	//Else
	//	Alert("Ok")
	Endif

Return
