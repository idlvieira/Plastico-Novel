#Include "protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKANDESC  ºAutor  ³Fernando Amorim     º Data ³ 22/01/10    º±±
±±ºPrograma  ³MYTMK09   ºRevisao³Sonia Silva     	 º Data ³ 24/11/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de analise de limite de desconto		              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºContato   ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter						                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//28/09/2020 Leonardo Bergamasco - Ajuste na tela da rejeição
//28/09/2020 Leonardo Bergamasco - Remoção de blocos sem utilização dentro do fonte

User Function MYTMK09()

	local cFiltra 		:= ""
	local aIndexSUA		:= {}
	Private aRotina 	:= {	{"Pesquisar",	"AxPesqui"	,0,1} ,;
								{"Analisar",	"U_MYEST01o",0,2}}
								//{"Liberar",	"U_LIBDESC",0,2} ,;
								//{"Rejeitar",	"U_REJDESC",0,2},;
								//{"Analisar",	"U_TMKVISUORC",0,2}} 

	Private bFiltraBrw	:= { || NIL }

	dbSelectArea("SUA")
	dbSetOrder(1)

	// Inicializa o filtro utilizando a funcao FilBrowse
	//cFiltra := ChkRh("MYTMK09", "SUA", "1")// cFiltra := ChkRh("TKANCRED","SUA","1")
	cFiltra := 'SUA->UA_ZZSTAT2 == "BLO" .and. allTrim(upper(CUSERNAME)) == allTrim(SUA->UA_ZZAPROV) '
	bFiltraBrw := {|| FilBrowse("SUA", @aIndexSUA, @cFiltra)}
	Eval(bFiltraBrw)

	dbGoTop()                                    
	mBrowse(6,1,22,75,"SUA")

	// Deleta o filtro utilizando a funcao FilBrowse
	EndFilBrw( "SUA" , aIndexSUA )

Return .T.    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³updBrownse  ³ Autor  ³ Leandro Ferreira  ³ Data ³ 07/05/2020³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Rotina para realizar o Refresh de tela				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Call Center                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function updmBrowse()
	Local oObjBrow
	Eval(bFiltraBrw)
	
	oObjBrow := GetObjBrow()
	oObjBrow:ResetLen()
	oObjBrow:GoTop()
	oObjBrow:Refresh()
	
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³LIBDESC     ³ Autor  ³ Fernando Amorim     ³ Data ³ 26/01/10³±±
±±³Função    ³LIBDESC     ³ Revisao³ Sonia Silva	     ³ Data ³ 24/11/16³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Rotina para liberar o orcamento.						      ³±±
±±³Descrição ³Grava o usuario e data da liberacao do desconto		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Call Center                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LIBDESC()     

	local aAreaATU		:= getArea()
	local nNivel		:= 0
	local nDesc			:= 0
	local nDescA		:= 0
	local nMargemApr	:= 0
	local cAprovador	:= ""
	local cUltAprov		:= ""
	local lContinuar	:= .t.
	local lLibOrc		:= .f.

	// Identifica o maior nível que já liberou para sabedr quem é o próximo
	cQuery	:=	"SELECT "
	cQuery	+=	"	MAX(ZZW_MYNIV) AS ZZW_MYNIV "
	cQuery	+=	"FROM "
	cQuery	+=	"	" + retSqlName("ZZW") + " ZZW "
	cQuery	+=	"WHERE "
	cQuery	+=	"	ZZW_FILIAL  = '" + xFilial("ZZW") + "' AND "
	cQuery	+=	"	ZZW_MYORC   = '" + SUA->UA_NUM + "' AND "
	cQuery	+=	"	ZZW_MYBLO = '' AND ZZW_MYTIP = 'D' AND "
	cQuery	+=	"	ZZW.D_E_L_E_T_ = ' ' "

	TCQUERY cQuery NEW ALIAS "TZZW"

	nNivel	:= TZZW->ZZW_MYNIV
	TZZW->(dbCloseArea())

	// Incrementa o nível para identificar a necessidade de Aprovação
	nNivel ++

	// Identifica o maior desconto informado no orçamento
	SUB->(dbSetOrder(1))
	SUB->(dbSeek(xFilial("SUB") + SUA->UA_NUM))
	do while SUB->(!eof()) .and. SUB->UB_NUM == SUA->UA_NUM 
		nDesc := SUB->UB_DESC

		If nDesc >= nDescA
			nDescA	:= nDesc
		EndIf

		SUB->(dbSkip())		
	endDo

	// Identifica a Margem de aprovação e o Aporvador do nível atual
	nMargemApr	:= U_MYCFG02("TMK000004", "IN" + cValToChar(nNivel), "P",, "N")         
	cAprovador	:= U_MYTMK05(SUA->UA_NUM, nNivel)

	if valType(nMargemApr) == "C"
		nMargemApr	:= 0
	endIf

	// Testa se o desconto está dentro do nível
	if nDescA >= nMargemApr
		// Testa se o usuário logado precisa aprovar no nível atual
		if upper(allTrim(cAprovador)) == upper(allTrim(CUSERNAME))
			// Grava o Log desta liberação por este usuário
			U_MYTMK21("D", "L", "L", CUSERNAME, nNivel)
			cUltAprov := cAprovador
		else
			Alert("Usuário [ " + allTrim(CUSERNAME) + " ] não é o aprovador da vez.")
			lContinuar := .f.
		endIf
	endIf

	if lContinuar
		// Incrementa o nível para testar se tem que ser liberado
		nNivel ++

		// Identifica a Margem de aprovação e o Aporvador do próximo nível, caso tenha
		nMargemApr	:= U_MYCFG02("TMK000004", "IN" + cValToChar(nNivel), "P",, "N")
		if valType(nMargemApr) == "N"
			cAprovador	:= U_MYTMK05(SUA->UA_NUM, nNivel)

			if nDescA >= nMargemApr
				recLock("SUA", .f.)
					SUA->UA_ZZAPROV	:= cAprovador
				SUA->(msUnLock())

				// Manda e-mail para o próximo aprovador, avisando-o da necessidade de sua aprovação
				U_fNotPrxAp(cAprovador)
			else
				lLibOrc := .t.
			endIf
		elseIf valType(nMargemApr) == "C"
			lLibOrc := .t.
		endIf

		if lLibOrc
			// Como não possui mais nível de aprovação, libera o Orçamento
			recLock("SUA", .f.)
				SUA->UA_ZZSTAT2	:= "LIB"
				SUA->UA_ZZDTDES	:= dDataBase
				SUA->UA_ZZUSLI2	:= cUltAprov
				SUA->UA_ZZAPROV	:= cUltAprov
			SUA->(msUnLock())

			MALIBORC("LIB")
		endIf
	endIf

	restArea(aAreaATU)
	updmBrowse()
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³REJDESC     ³ Autor  ³ Fernando Amorim    ³ Data ³ 26/01/10 ³±±
±±³Função    ³REJDESC     ³ Revisao³ Sonia Silva        ³ Data ³ 24/11/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Rotina para liberar o orcamento.						      ³±±
±±³Descrição ³Utilizada quando o orcamento e rejeitado o desconto         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Call Center                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//28/09/2020 Leonardo Bergamasco - Ajuste na tela da rejeição

User Function REJDESC()     

	local cObserv	:= SUA->UA_ZZOBS4 
	local nNivel	:= 0
	local aButtons	:= {}
	local lOk       := .F.
	Local lObserv   := .T.

    While lObserv
	  DEFINE MSDIALOG oDlg TITLE "Descrição do Motivo da Rejeição do Desconto do Orcamento" FROM 000,000 TO 200,359 OF oMainWnd PIXEL
        @ C(025),C(003) Get cObserv MEMO Size C(139),C(047) PIXEL OF oDlg
	  ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| lOk:=.T., oDlg:End()}, {|| lOk:=.F., oDlg:End()} ,,@aButtons) CENTERED
      
      If lOk .and. Empty(cObserv)
        Alert("Obrigatorio informar o motivo","MYTMK09")
      Else
        lObserv := .F.
      EndIF
    EndDo
    
    If lOk
	  U_MYTMK21("D", "R", "R", CUSERNAME, nNivel) 	

	  RecLock("SUA", .f.)
  	    SUA->UA_ZZOBS4  := cObserv
	    SUA->UA_ZZSTAT2	:= "REJ"
	  SUA->(MsUnLock())

	  MALIBORC("REJ")
	EndIf
	
	updmBrowse()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKVISUORCºAutor  ³Leandro Marques     º Data ³  03/01/10   º±±
±±ºPrograma  ³TMKVISUORCºAutor  ³Sonia Silva         º Data ³  24/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para visualizacao do orcamento que espera retorno    º±±
±±º          ³da avaliacao de desconto                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Callcenter                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKVISUORC()

	SUA->(DbSetOrder(1))//SUA_FILIAL + SUA_NUM  
	SUA->(DbSeek(xFilial("SUA") + SUA->UA_NUM))
	TK271CallCenter("SUA",Recno(),2)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |MALIBORC  ºAutor  ³Leandro Marques     º Data ³  03/03/10   º±±
±±ºPrograma  |MALIBORC  ºRevisao³Sonia Silva         º Data ³  24/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsal por mandar a notificacao(email) para o res-º±±
±±º          ³ponsavel pela aprovacao ou rejeicao da analise do desconto  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Callcenter                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function MALIBORC(cPos)

	local oHtml
	local oEmail
	local cServidor		:=	GetMv("MV_RELSERV")
	local cConta		:=	GetMv("MV_RELACNT")
	local cPassWord		:=	GetMv("MV_RELPSW")
	local cAutentic		:=	GetMv("MV_RELAUTH")
	local cAnexo		:= '' 	
	local cTitulo 		:= ""
	local cAprovRej		:= ""
	local aCorpo	  	:= {}
	local aRodape 		:= {} 
	local cAssunto  	:= Iif(cPos == "LIB"," Orçamento de numero "+SUA->UA_NUM+" está liberado para incluir o pedido"," Orçamento de numero "+SUA->UA_NUM+" Foi rejeitado" )
	local cPara 		:= trim(Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK000006"+"001","ZZZ_RETORN")) + ";" + Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_ZZEMAIL") + ";" + Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL")
	//local cPara 		:= "lbergamasco@novel.com.br"
	local cCC			:= ""
	local cCCo			:= ""  
	local cRemet 		:= GetMv("MV_RELACNT")
	local cDtHrEmiss	:= strZero(day(dDataBase), 02) + "/" + strZero(month(dDataBase), 02) + "/" + cValToChar(year(dDataBase)) + " - " + time()
	local cMyEmpFil		:= SM0->M0_CODIGO + "/" + allTrim(SM0->M0_FILIAL)

	//cRemet := EMAILUSR()

	DbSelectarea("SF2")  

	If cPos == "LIB"
		cAprovRej	:= "Liberado"
	Else
		cAprovRej	:= "Rejeitado"
	EndIf

	aAdd(aCorpo, "O Orçamento abaixo: ")
	aAdd(aCorpo, " ")
	aAdd(aCorpo, "Número: " + SUA->UA_NUM)
	aAdd(aCorpo, " ")
	aAdd(aCorpo, "Da Empresa: " + cMyEmpFil + ",")
	aAdd(aCorpo, " ")
	aAdd(aCorpo, "Foi " + cAprovRej + " em: " + cDtHrEmiss + " pela análise de desconto. ")
	aAdd(aRodape, " ")
	If cPos == "REJ"
  	  aAdd(aCorpo, "MOTIVO: " + SUA->UA_ZZOBS4)
	  aAdd(aRodape, " ")
	EndIf
	aAdd(aRodape, "Obrigado(a)!")

	oHtml:= CorpoEmail():New(cTitulo, aCorpo, aRodape)
	oHtml:GeraHtml()	
	//Enviando E-mail		
	oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
	oEmail:EmailUsr()
	oEmail:Conectar()    
	If oEmail:Enviar(allTrim(cRemet), allTrim(cPara), allTrim(cCC), allTrim(cCCO), allTrim(cAssunto), oHtml:cHtml, cAnexo)
		lRetorno	:=	.t.
		Aviso(FunDesc(),"E-mail enviado com SUCESSO.",{"OK"})
	EndIf
	oEmail:Desconec()    

return
