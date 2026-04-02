#Include "protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

//static cCOD 		:= 'TMK000004'
//static cMaxNivel 	:= 'AP3'
//static __cCondi := "REPRESENTANTE"

/*
	Rotina de analise de limite de desconto
*/

User Function MYTMK09()

	local cFiltra 		:= ""
	local aIndexSUA		:= {}
	Private aRotina 	:= {{"Pesquisar",	"AxPesqui"	,0,1} ,;
		{"Analisar",	"U_MYEST01o",0,2}}

	Private bFiltraBrw	:= { || NIL }

	dbSelectArea("SUA")
	dbSetOrder(1)

	// Inicializa o filtro utilizando a funcao FilBrowse
	cFiltra := 'SUA->UA_ZZSTAT2 == "BLO" .and. allTrim(upper(CUSERNAME)) == allTrim(SUA->UA_ZZAPROV)'
	bFiltraBrw := {|| FilBrowse("SUA", @aIndexSUA, @cFiltra)}
	Eval(bFiltraBrw)

	dbGoTop()
	mBrowse(6,1,22,75,"SUA")

	// Deleta o filtro utilizando a funcao FilBrowse
	EndFilBrw( "SUA" , aIndexSUA )

Return .T.

/*/
	updBrownse  ³ Autor  ³ Leandro Ferreira  ³ Data ³ 07/05/2020³±±
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
	LIBDESC     ³ Autor  ³ Fernando Amorim     ³ Data ³ 26/01/10³±±
/*/
user function LIBDESC()
	local aAreaATU		:= getArea()		as array
	local aDados		:= {} 				as array
	local cProxNivel    := ""  				as character
	local cProxNome     := "" 				as character
	local cNomeAprov    := "" 				as character
	local cIdUser		:= ""				as character
	local cMaxNivel		:= ""				as character
	local cNivel		:= SUA->UA_XBNIVEL  as character
	local cAlcada		:= SUA->UA_XALCADA	as character
	local cVend 		:= SUA->UA_VEND		as character
	local cMailVend		:= ""				as character
	local cStatus		:= ""				as character
	local cTexto		:= ""				as character

	cMailVend := alltrim(Posicione("SA3",1 , FwxFilial("SA3")+cVend, "A3_EMAIL"))

	if SUA->(dbSeek(FWxFilial("SUA")+SUA->UA_NUM))
		cMaxNivel := GetMaxNivel(cAlcada)
		if !empty(cAlcada) .and. !empty(cNivel)
			if cNivel == 'AP1'
				cProxNivel := soma1(cNivel)
				aDados := getAlcada(cAlcada, right(cProxNivel,1))

				cIdUser		:= aDados[1]
				cProxNome 	:= aDados[2]
				cStatus 	:= aDados[4]
				cNomeAprov 	:= aDados[5]

				if cStatus == 'A'
					SUA->(dbSetOrder(1))
					if SUA->(dbSeek(FWxFilial("SUA")+SUA->UA_NUM))
						if (!isBlind())
							FwAlertInfo('Proximo aprovador '+ alltrim(capital( cNomeAprov)),'Liberado!')
						endIf

						if RecLock("SUA", .F.)
							SUA->UA_ZZSTAT2	:= "BLO"
							SUA->UA_ZZAPROV	:= alltrim(Upper(cProxNome))
							SUA->UA_ZZNIVEL	:= 00
							SUA->UA_XBDESC  := "Aguardando a liberação de desconto pelo aprovador " + alltrim(capital(cProxNome))
							SUA->UA_XBNIVEL := cProxNivel
							SUA->(MsUnLock())
						endif
						u_fNotPrxAp(cIdUser)
						cTexto := 'Status em Analise.'+ '|' +"Analise realiza por " + ;
							alltrim(Capital(UsrRetName(__cUserId))) +'|'+ "Proximo Aprovador " + alltrim(capital(cNomeAprov))
						u_LibMail(cMailVend, SUA->UA_NUM, 'Liberado', cTexto)

						if (!isBlind())
							updmBrowse()
						endIf
					endif
				else
					if (!isBlind())
						FwAlertInfo('Aprovador ' +cNomeAprov+ ' esta inativo.'+CRLF+'Enviado solcitação para o proximo aprovador!','Status!')
					endIf

					cProxNivel := soma1(cProxNivel)
					aDados := getAlcada(cAlcada, right(cProxNivel,1))

					cIdUser		:= aDados[1]
					cProxNome 	:= aDados[2]
					cStatus 	:= aDados[4]
					cNomeAprov 	:= aDados[5]

					SUA->(dbSetOrder(1))
					if SUA->(dbSeek(FWxFilial("SUA")+SUA->UA_NUM))
						if (!isBlind())
							FwAlertInfo('Proximo aprovador '+ alltrim(capital( cNomeAprov)),'Liberado!' )
						endIf

						if RecLock("SUA", .F.)
							SUA->UA_ZZSTAT2	:= "BLO"
							SUA->UA_ZZAPROV	:= alltrim(Upper(cProxNome))
							SUA->UA_ZZNIVEL	:= 00
							SUA->UA_XBDESC  := "Aguardando a liberação de desconto pelo aprovador " + alltrim(capital(cProxNome))
							SUA->UA_XBNIVEL := cProxNivel
							SUA->(MsUnLock())
						endif
						u_fNotPrxAp(cIdUser)
						cTexto := 'Status em Analise.'+ '|' +"Analise realiza por " + ;
							alltrim(Capital(UsrRetName(__cUserId))) +'|'+ "Proximo Aprovador " + alltrim(capital(cNomeAprov))
						u_LibMail(cMailVend, SUA->UA_NUM, 'Liberado', cTexto)

						if (!isBlind())
							updmBrowse()
						endIf
					endif
				endif
			elseif cNivel == 'AP2'
				cProxNivel := soma1(cNivel)
				aDados := getAlcada(cAlcada, right(cProxNivel,1))

				cIdUser		:= aDados[1]
				cProxNome 	:= aDados[2]
				cStatus 	:= aDados[4]
				cNomeAprov 	:= aDados[5]

				if cStatus == 'A'
					SUA->(dbSetOrder(1))
					if cMaxNivel > '2'
						if SUA->(dbSeek(FWxFilial("SUA")+SUA->UA_NUM))
							if (!isBlind())
								FwAlertInfo('Proximo aprovador '+ alltrim(capital( cNomeAprov)),'Liberado!' )
							endIf

							if RecLock("SUA", .F.)
								SUA->UA_ZZSTAT2	:= "BLO"
								SUA->UA_ZZAPROV	:= alltrim(Upper(cProxNome))
								SUA->UA_ZZNIVEL	:= 00
								SUA->UA_XBDESC  := "Aguardando a liberação de desconto pelo aprovador " + alltrim(capital(cProxNome))
								SUA->UA_XBNIVEL := cProxNivel
								SUA->(MsUnLock())
							endif
							u_fNotPrxAp(cIdUser)
							cTexto := 'Status em Analise.'+ '|' +"Analise realiza por " + ;
								alltrim(Capital(UsrRetName(__cUserId))) +'|'+ "Proximo Aprovador " + alltrim(capital(cNomeAprov))
							u_LibMail(cMailVend, SUA->UA_NUM, 'Liberado', cTexto)

							if (!isBlind())
								updmBrowse()
							endIf
						endif
					elseIf cMaxNivel == '2'
						if SUA->(dbSeek(FWxFilial("SUA")+SUA->UA_NUM))
							if (!isBlind())
								FWAlertSuccess('Orçamento liberado!')
							endIf

							if RecLock("SUA", .F.)
								SUA->UA_ZZSTAT2	:= "LIB"
								SUA->UA_ZZAPROV	:= alltrim(Upper(cProxNome))
								SUA->UA_ZZNIVEL	:= 00
								SUA->UA_XBDESC  := "Orçamento Totalmente Liberado."
								SUA->UA_XBNIVEL := "AP2"
								SUA->UA_ZZUSLI2 := alltrim(Upper(cProxNome))
								SUA->UA_ZZDTDES := date()
								SUA->(MsUnLock())
							endif

							cTexto := 'Status em Analise.'+ '|' +"Analise realiza por " + ;
								alltrim(Capital(UsrRetName(__cUserId))) + '| Orçamento Totalmente Liberado. '
							u_LibMail(cMailVend, SUA->UA_NUM, 'Liberado', cTexto)

							if (!isBlind())
								updmBrowse()
							endIf
						endif
					endif
				else
					if (!isBlind())
						FwAlertInfo('Aprovador nivel 3 esta inativo.'+CRLF+'A solicitação sera liberada!','Status!')
					endIf

					if SUA->(dbSeek(FWxFilial("SUA")+SUA->UA_NUM))
						if (!isBlind())
							FWAlertSuccess('Orçamento liberado!')
						endIf

						if RecLock("SUA", .F.)
							SUA->UA_ZZSTAT2	:= "LIB"
							SUA->UA_ZZAPROV	:= alltrim(Upper(cProxNome))
							SUA->UA_ZZNIVEL	:= 00
							SUA->UA_XBDESC  := "Orçamento Totalmente Liberado."
							SUA->UA_XBNIVEL := "AP2"
							SUA->UA_ZZUSLI2 := alltrim(Upper(cProxNome))
							SUA->UA_ZZDTDES := date()
							SUA->(MsUnLock())
						endif

						cTexto := 'Status em Analise.'+ '|' +"Analise realiza por " + ;
							alltrim(Capital(UsrRetName(__cUserId))) + '| Orçamento Totalmente Liberado. '
						u_LibMail(cMailVend, SUA->UA_NUM, 'Liberado', cTexto)

						if (!isBlind())
							updmBrowse()
						endIf
					endif
				endIf

			elseif cNivel == 'AP3'
				aDados := getAlcada(cAlcada, '3')

				cIdUser		:= aDados[1]
				cProxNome 	:= aDados[2]
				cStatus 	:= aDados[4]
				cNomeAprov 	:= aDados[5]

				if SUA->(dbSeek(FWxFilial("SUA")+SUA->UA_NUM))
					if (!isBlind())
						FWAlertSuccess('Orçamento liberado!')
					endIf

					if RecLock("SUA", .F.)
						SUA->UA_ZZSTAT2	:= "LIB"
						SUA->UA_ZZAPROV	:= alltrim(Upper(cProxNome))
						SUA->UA_ZZNIVEL	:= 00
						SUA->UA_XBDESC  := "Orçamento Totalmente Liberado."
						SUA->UA_XBNIVEL := "AP3"
						SUA->UA_ZZUSLI2 := alltrim(Upper(cProxNome))
						SUA->UA_ZZDTDES := date()
						SUA->(MsUnLock())
					endif

					cTexto := 'Status em Analise.'+ '|' +"Analise realiza por " + ;
						alltrim(Capital(UsrRetName(__cUserId))) + '| Orçamento Totalmente Liberado. '
					u_LibMail(cMailVend, SUA->UA_NUM, 'Liberado', cTexto)


					if (!isBlind())
						updmBrowse()
					endIf
				endif
			endif
		endIf
	endif

	restArea(aAreaATU)

	if (!isBlind())
		updmBrowse()
	endIf
return

/*/
	Utilizada quando o orcamento e rejeitado o desconto
/*/
User Function REJDESC(cMotivo as character)

	local cObserv		:= SUA->UA_ZZOBS4
	local nNivel		:= 0
	local aButtons		:= {}
	local lOk       	:= .F.
	local lObserv   	:= .T.
	local cMailVend		:= ""				as character
	local cVend			:= SUA->UA_VEND

	default cMotivo := ''

	cMailVend := alltrim(Posicione("SA3",1 , FwxFilial("SA3")+cVend, "A3_EMAIL"))

	if (!empty(cMotivo))
		cObserv := cMotivo
		lOk     := .T.
	else
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
	endIf

	If lOk
		U_MYTMK21("D", "R", "R", CUSERNAME, nNivel)

		RecLock("SUA", .f.)
		SUA->UA_ZZOBS4  := cObserv
		SUA->UA_ZZSTAT2	:= "REJ"
		SUA->UA_XBDESC  := "Orçamento rejeitado." 
		SUA->(MsUnLock())

		cTexto := 'Status em Analise.'+ '|' +"Analise realiza por " + ;
			alltrim(Capital(UsrRetName(__cUserId))) + '| Orçamento Rejeitado. ' + '|' + cObserv
		u_LibMail(cMailVend, SUA->UA_NUM, 'Liberado', cTexto)

		u_MALIBORC("REJ")

	EndIf

	if (!isBlind())
		updmBrowse()
	endIf
Return

/*
	Funcao para visualizacao do orcamento que espera retorno da avaliacao de desconto
*/
User Function TMKVISUORC()

	SUA->(DbSetOrder(1))//SUA_FILIAL + SUA_NUM
	SUA->(DbSeek(xFilial("SUA") + SUA->UA_NUM))
	TK271CallCenter("SUA",Recno(),2)

Return

/*
	Funcao responsal por mandar a notificacao(email) para o responsavel pela aprovacao ou rejeicao da analise do desconto
*/
user function MALIBORC(cPos)
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
	local cCC			:= ""
	local cCCo			:= ""
	local cRemet 		:= GetMv("MV_RELACNT")
	local cDtHrEmiss	:= strZero(day(dDataBase), 02) + "/" + strZero(month(dDataBase), 02) + "/" + cValToChar(year(dDataBase)) + " - " + time()
	local cMyEmpFil		:= SM0->M0_CODIGO + "/" + allTrim(SM0->M0_FILIAL)

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
		lRetorno	:=	.T.
		Aviso(FunDesc(),"E-mail enviado com SUCESSO.",{"OK"})
	EndIf
	oEmail:Desconec()

return
user function LibMail(cPara, cNum, cTipo, cTexto)
	Local cMsg 			 := "" 												as character
	Local cMensagem 	 := "" 												as character
	Local cAssunto 	 	 := "Analise de desconto N° " +SUA->UA_NUM			as character
	Local cCopia 	 	 := ""												as character
	Local oServer 		 := nil 											as object
	local oMessage		 := nil 											as object
	Local lMailAuth		 := SuperGetMv("MV_RELAUTH",,.F.) 					as logical
	Local nPorta 		 := 587												as numeric
	Local aMsg			 := ""												as character
	Local nIndex		 := 0												as numeric
	Local xRet
	Private cMailConta	 := NIL
	Private cMailSenha	 := NIL
	Private nTimeout 	 := 120

	//cPara 	:= "idweb@outlook.com"
	cCopia 	:= ""
	aMsg    := strToArray(cTexto, '|')

	cMensagem  :='<!doctype html>'
	cMensagem  +='<html lang="pt_br">'
	cMensagem  +='<head>'
	cMensagem  +='<meta charset="utf-8">'
	cMensagem  +='<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">'
	cMensagem  +='<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">'
	cMensagem  +='</head>'
	cMensagem  +='<body>'
	cMensagem  +='<div class="container">'
	cMensagem  +='<div class="row">'
	cMensagem  +='<div class="jumbotron bg-light">'
	cMensagem +='<p class="lead">Empresa / Filial'+SM0->M0_CODIGO + " / " + alltrim(SM0->M0_FILIAL )+'</p>'
	cMensagem +='<p class="lead">' + cAssunto + '</p>'
	if len(aMsg) > 0
		for nIndex := 01 to len(aMsg)
			cMensagem +='<p class="lead">' + aMsg[nIndex] + '</p>'
		next nIndex
	else
		cMensagem +='<p class="lead">' + cTexto + '</p>'
	endIf
	cMensagem +='<hr class="my-4">'
	cMensagem +='<p class="lead">'+"Data e hora de envio: " +Alltrim(DtoC(Date())) + " - " + Alltrim(Time())+'</p>'
	cMensagem +='</div>'//jumbotron
	cMensagem +='</div>'//row
	cMensagem +='</div>'//container
	cMensagem +='<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>'
	cMensagem +='<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>'
	cMensagem +='<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>'
	cMensagem +='</body>'
	cMensagem +='</html>'

	cMailConta :=If(cMailConta == NIL,GETMV("MV_RELACNT"),cMailConta)
	cMailServer:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)
	cMailSenha :=If(cMailSenha == NIL,GETMV("MV_RELPSW"),cMailSenha)

	oMessage:= TMailMessage():New()
	oMessage:Clear()

	oMessage:cDate	 := cValToChar(Date())
	oMessage:cFrom 	 := cMailConta
	oMessage:cTo 	 := cPara
	oMessage:cCc 	 := cCopia
	oMessage:cSubject:= cAssunto
	oMessage:cBody 	 := cMensagem
	oMessage:MsgBodyType( "text/html" )

	cMailServer := Iif(':' $ cMailServer, SubStr(cMailServer, 1, At(':', cMailServer)-1), cMailServer)
	oServer := tMailManager():New()
	oServer:SetUseTLS( .T. )

	xRet := oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0, nPorta )
	if xRet != 0
		if (!isBlind())
			FWAlertError("O servidor SMTP não foi inicializado: " + oServer:GetErrorString( xRet ) )
		else
			conOut("O servidor SMTP não foi inicializado: " + oServer:GetErrorString( xRet ))
		endif
		return
	endif

	xRet := oServer:SetSMTPTimeout( 60 )
	if xRet != 0
		if (!isBlind())
			FWAlertError("Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout ))
		else
			conOut("Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout ))
		endif
	endif

	xRet := oServer:SMTPConnect()
	if xRet <> 0
		if (!isBlind())
			FWAlertError("Não foi possível conectar ao servidor SMTP: " + oServer:GetErrorString( xRet ))
		else
			conOut("Não foi possível conectar ao servidor SMTP: " + oServer:GetErrorString( xRet ))
		endif
		return
	endif

	if lMailAuth
		xRet := oServer:SmtpAuth( cMailConta, cMailSenha )
		if xRet <> 0
			cMsg := "Não foi possível conectar ao servidor SMTP: Erro de Login. " + oServer:GetErrorString( xRet )
			if (!isBlind())
				FWAlertError( cMsg )
			else
				conOut(cMsg)
			endif
			oServer:SMTPDisconnect()
			return .F.
		endif
	Endif

	xRet := oMessage:Send( oServer )
	if xRet <> 0
		if (!isBlind())
			FWAlertError("Não foi possível enviar mensagem: " + oServer:GetErrorString( xRet ))
		else
			conOut("Não foi possível enviar mensagem: " + oServer:GetErrorString( xRet ))
		endif
	endif

	xRet := oServer:SMTPDisconnect()
	if xRet <> 0
		if (!isBlind())
			FWAlertError("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
		else
			conOut("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
		endif
	endif
return


static function getAlcada(cCod, cNivel)
	local cTemp			    := ""	                        as character
	local cQuery 		    := ""	                        as character
	local aDados		    := {}							as array
	local oStatement 	    := nil	                        as object

	cQuery := "SELECT ZZ7_USER, ZZ7_NOME, ZZ7_NIVEL, ZZ7_STATUS, ZZ7_XNOME "
	cQuery += " FROM " + RetSqlName('ZZ7')
	cQuery += " WHERE D_E_L_E_T_ = '' "
	cQuery += " AND ZZ7_CODIGO = ? "
	cQuery += " AND ZZ7_NIVEL = ? "

	oStatement := FWPreparedStatement():New()
	oStatement:SetQuery(cQuery)
	oStatement:SetString(1, cCod)
	oStatement:SetString(2, cNivel)

	cQuery := oStatement:GetFixQuery()
	cTemp := mpsysopenquery(cQuery)

	aAdd(aDados, (cTemp)->ZZ7_USER)
	aAdd(aDados, alltrim(upper((cTemp)->ZZ7_NOME)))
	aAdd(aDados, (cTemp)->ZZ7_NIVEL)
	aAdd(aDados, (cTemp)->ZZ7_STATUS)
	aAdd(aDados, (cTemp)->ZZ7_XNOME)

	(cTemp)->(dbCloseArea())

return aDados

static function GetMaxNivel(cCod)
	local cTemp			    := ""	                        as character
	local cQuery 		    := ""	                        as character
	local cMaxNivel		    := ""							as character
	local oStatement 	    := nil	                        as object

	cQuery := "SELECT MAX(ZZ7_NIVEL) AS MAXNIVEL "
	cQuery += " FROM " + RetSqlName('ZZ7')
	cQuery += " WHERE D_E_L_E_T_ = '' "
	cQuery += " AND ZZ7_CODIGO = ? "

	oStatement := FWPreparedStatement():New()
	oStatement:SetQuery(cQuery)
	oStatement:SetString(1, cCod)

	cQuery := oStatement:GetFixQuery()
	cTemp := mpsysopenquery(cQuery)

	cMaxNivel := (cTemp)->MAXNIVEL

	(cTemp)->(dbCloseArea())

return cMaxNivel
