#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³MYTMK03 ºRevisao ³Sonia Silva          º Data ³  22/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio de e-mail para informar o cliente sobre a confirmacaoº±±
±±º          ³ do pedido.											      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Callcenter e Faturamento                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MYTMK03()// User Function EMCONFPED()

	local oHtml     := nil
	local oEmail    := nil
	local cServidor	:= getMv("MV_RELSERV")
	local cConta	:= getMv("MV_RELACNT")
	local cPassWord	:= getMv("MV_RELPSW")
	local cAutentic	:= getMv("MV_RELAUTH")
	local cPedido   := ""
	local oPedido   := nil
	local cAnexo    := ""
	local cTitulo 	:= ""
	local aCorpo  	:= {}
	local aRodape 	:= {}
	local cAssunto  := " Confirmação do Pedido " + SUA->UA_NUMSC5
	local cPara 	:= space(150)
	local oPara     := nil
	local cImagem 	:= space(150)
	local oImagem   := nil
	local cCC		:= space(150)
	local cCCo		:= space(150)
	local cRemet 	:= getMv("MV_RELACNT")
	local cDrivers	:= "Selecione o Pedido (.PDF) | *.PDF |" + "Imagem Bitmap (.BMP) | *.BMP |" + "Imagem JPEG (.JPG) | *.JPG |"
	local aButtons	:= {}
	local nOpcao	:= 0
	
	cPara := getSUMail()
	
	DEFINE MSDIALOG oDlg TITLE "Pedido - E-mail" FROM 178,181 TO 580,631 PIXEL

	@ 020,002 TO 180,223 LABEL "Informe os dados para o e-mail ser enviado." PIXEL OF oDlg
	
	@ 041,006 MsGet oPara Var cPara Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg
	@ 031,006 Say "Para:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg
	
	@ 063,006 MsGet oCC Var cCC Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg
	@ 053,006 Say "Cc:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg
	
	@ 075,006 Say "Pedido de Venda" Size 086,008 COLOR CLR_BLUE PIXEL OF oDlg
	@ 085,204 Button "..." Size 014,011 When .t. PIXEL OF oDlg Action {|| cPedido:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.t.,GETF_ONLYSERVER/*GETF_localHARD+GETF_NETWORKDRIVE*/)}
	@ 085,006 MsGet oPedido Var cPedido Size 197,009 COLOR CLR_BLACK When .t. Picture "@!" PIXEL OF oDlg  
	
	@ 097,006 Say "Solicitação de Gravação" Size 070,008 COLOR CLR_BLUE PIXEL OF oDlg
	@ 107,204 Button "..." Size 014,011 When .t. PIXEL OF oDlg Action {|| cImagem:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.t.,GETF_ONLYSERVER/*GETF_localHARD+GETF_NETWORKDRIVE*/)}
	@ 107,006 MsGet oImagem Var cImagem Size 197,009 COLOR CLR_BLACK When .t. Picture "@!" PIXEL OF oDlg
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcao:=1,If(!Empty(cPedido) .and. !Empty(cPara) ,oDlg:End(),"")},{|| (nOpcao:=2,oDlg:End())},,aButtons) CENTERED
	
	if nOpcao == 1 
		dbSelectarea("SF2") 

		cAnexo := ""
		cAnexo += allTrim(cPedido)+";"
		cAnexo += allTrim(cImagem)+";"  
		
		aAdd(aCorpo,"Prezado Cliente,")
		aAdd(aCorpo,"")
		aAdd(aCorpo,"Muito obrigado pelo seu pedido! Estamos honrados em servi-lo (a) e faremos o possível para atendê-lo (a) conforme nossa negociação.")
		aAdd(aCorpo,"Informamos que foi gerado em nosso sistema o pedido número " + SUA->UA_NUMSC5 + " conforme anexo,o qual pedimos que analise e caso haja alguma ")
		aAdd(aCorpo,"divergência por favor entre em contato imediatamente através do e-mail: "+ Posicione ("ZZZ",1,xFilial("ZZZ")+"TMK00003"+"001",ZZZ_RETORN)) 
		//aAdd(aCorpo,"divergência por favor entre em contato imediatamente através do e-mail vendasbrasil@myersind.com. ")
		aAdd(aCorpo,"Caso não tenhamos uma resposta imediata,seu pedido será processado conforme o anexo.")
		
		aAdd(aRodape,"")
		aAdd(aRodape,"Obrigado,")
		aAdd(aRodape,"")
		aAdd(aRodape,+ Posicione("ZZZ",1,xFilial("ZZZ")+"TMK00003"+"002",ZZZ_RETORN))	//aAdd(aRodape,"Myers do Brasil")
		aAdd(aRodape,+ Posicione("ZZZ",1,xFilial("ZZZ")+"TMK00003"+"003",ZZZ_RETORN))	//aAdd(aRodape,"Tel: (19) 3847-9999")
		
		
		oHtml := CorpoEmail():new(cTitulo,aCorpo,aRodape)

		oHtml:geraHtml()

		&& enviando e-mail
		oEmail := ConEmail():new(cServidor,cConta,cPassWord,,cAutentic,)
		
		oEmail:emailUsr()
		oEmail:conectar()

		if oEmail:enviar(allTrim(cRemet),allTrim(cPara),allTrim(cCC),allTrim(cCCO),allTrim(cAssunto),oHtml:cHtml,cAnexo)
			lRetorno := .t.

			aviso(funDesc(),"E-mail enviado com SUCESSO.",{"OK"})

			SUA->(recLock("SUA",.f.))
				SUA->UA_ZZMAILP := "1" //SUA->UA_MAILPED := "1"
			SUA->(msUnlock())
		endif

		oEmail:desconec()
	endif

return

&& retorna e-mail
static function getSUMail()

	local cMail := SUA->UA_ZZEMAIL

	if aviso("Informacao","Selecione o destinatario do e-mail.",{"Contato","Cliente"},2,funDesc()) == 1
		if !empty(SUA->UA_CODCONT)
			SU5->(dbSetOrder(1))
			SU5->(dbSeek(xFilial("SU5")+SUA->UA_CODCONT))
			cMail := SU5->U5_EMAIL
		endif
	endif

return cMail