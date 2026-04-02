#Include "RWMAKE.CH"  
                        
                        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Donizete            º Data ³  03/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este programa válida se a NCM e alíquota de IPI foram      º±±
±±º          ³ informados quando o produto cadastrado possui os tipos     º±±
±±º          ³ PI,PA,MI,RI,RN.                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada disparado no Ok do Cad.Produtos.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºData      ³ Alterações                                                º±±
±±º10/04/07  ³ Alterado por Donizete - Microsiga Campinas                º±±
±±º          ³ - validar a conta contábil de acordo com o tipo de produtoº±±
±±º          ³informado pelo usuário.                                    º±±
±±º          ³                                                           º±±
±±º          ³                                                           º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function A010TOK()

/*

// Variáveis do programa.
Local _lRet := .t.
Local _cCta := ""

// Verifica tipo de produto e faz a validação com a NCM / IPI.
If M->B1_TIPO $ "PI,PA,MI,RI,RN"
	
	If Empty(M->B1_POSIPI)
		Alert("Atenção, produto não pode ficar com campo Pos.IPI/NCM em branco (pasta Impostos)!")
		_lRet := .f.
	Else
		If M->B1_IPI == 0
			_lRet := MsgBox("Alíquota de IPI zerada. Confirma?","Aviso !!!","YESNO")
		EndIf
	Endif
	
ElseIf M->B1_TIPO == "AF" .And. Empty(M->B1_CONTA)
	Alert("Atenção, tipo de produto Ativo Fixo (AF), campo 'Cta Contabil' não pode ficar em branco.!")
	_lRet := .f.

ElseIf M->B1_TIPO $ "MC,GG" .And. (Empty(M->B1_ZZCTAA) .Or. Empty(M->B1_ZZCTAC) .Or. ;
							     Empty(M->B1_ZZCTAD) .Or. Empty(M->B1_ZZCTAI))
	_lRet := MsgBox("Atenção!!! Campo(s) 'Cta.Desp.Adm' ou 'Cta.Desp.Cml' ou 'Cta Custo D' ou 'Cta.Custo I' em branco " + ;
		  "no cadastro do produto. Prosseguir?","Aviso !!!","YESNO")
ElseIf !Empty(M->B1_ZZCTAA) .And. !SubStr(M->B1_ZZCTAA,1,2) $ "32,33"
	_lRet := MsgBox("Atenção!!! Campo 'Cta.Desp.Adm' aceita somente contas iniciadas por '32' ou '33'.","Aviso !!!","YESNO")
ElseIf !Empty(M->B1_ZZCTAC) .And. !SubStr(M->B1_ZZCTAC,1,2) $ "32,33"
	_lRet := MsgBox("Atenção!!! Campo 'Cta.Desp.Cml' aceita somente contas iniciadas por '32' ou '33'.","Aviso !!!","YESNO")
ElseIf !Empty(M->B1_ZZCTAD) .And. !SubStr(M->B1_ZZCTAD,1,2) $ "42"
	Alert("Campo 'Cta.Custo D' aceita somente contas iniciadas por '42'.")
	_lRet := .f.
ElseIf !Empty(M->B1_ZZCTAI) .And. !SubStr(M->B1_ZZCTAI,1,2) $ "43"
	Alert("'Campo Cta.Custo I' aceita somente contas iniciadas por '43'.")
	_lRet := .f.
EndIf

If !Empty(M->B1_TIPO) .And. !_lRet
	_cCta := Tabela("Z@","A4"+M->B1_TIPO+"S",.F.)
	If !Empty(_cCta)
		If Alltrim(_cCta)<>Alltrim(M->B1_CONTA)
			Alert("A conta contábil informada não esta de acordo com o tipo de produto. Conta correta -> "+_cCta)
			_lRet := .f.
		EndIf
	Endif
EndIf

*/

_cFase		:= M->B1_MYFASE
_lRet		:= .F.
_cUsuario	:= cusername

//alert(M->B1_MYVOLTA)

//ALERT(_cFase)
//alert(Upper(Trim(_cUsuario)))
//alert("Fase1"+Upper(Trim(GETMV("MV_MYFASE1"))))
//alert("Fase2"+Upper(Trim(GETMV("MV_MYFASE2"))))
//alert("Fase3"+Upper(Trim(GETMV("MV_MYFASE3"))))
//alert("Fase4"+Upper(Trim(GETMV("MV_MYFASE4"))))

 If M->B1_MYVOLTA<>"1" .AND. M->B1_MYFASE == "1" .and. Upper(Trim(_cUsuario)) == Upper(Trim(GETMV("MV_MYFASE1")))
	If !EMPTY(M->B1_COD) .AND. !EMPTY(M->B1_DESC) .AND. !EMPTY(M->B1_GRUPO).AND. !EMPTY(M->B1_SUBGRUP) .AND. !EMPTY(M->B1_CLASSE1) .AND. !EMPTY(M->B1_CLASSE2) .AND. !EMPTY(M->B1_DESCDET) .AND. !EMPTY(M->B1_TIPO) .AND. !EMPTY(M->B1_UM) .AND. !EMPTY(M->B1_LOCPAD) .AND. !EMPTY(M->B1_PERINV) .AND. !EMPTY(M->B1_USAFEFO) .AND. !EMPTY(M->B1_MYSOLIC) .AND. !EMPTY(M->B1_PESOEMB) .AND. !EMPTY(M->B1_QE) .AND. !EMPTY(M->B1_TPEMB) .AND. !EMPTY(M->B1_PESBRU)
		//alert("entrou 1")
		_lRet	:= .T.
//		_cFase	:= "1"
	Else
		Alert("Existem campos obrigatorios para a fase atual do cadadtro - FASE 1")
	EndIf


ElseIf M->B1_MYVOLTA<>"1" .AND. M->B1_MYFASE == "2" .and. Upper(Trim(_cUsuario)) == Upper(Trim(GETMV("MV_MYFASE2")))
       If  !EMPTY(M->B1_CC) .AND. !EMPTY(M->B1_CONTA) .AND. !EMPTY(M->B1_CTADEV).AND. !EMPTY(M->B1_CTAICMS) .AND. !EMPTY(M->B1_CTAIPI) .AND. !EMPTY(M->B1_CTAIPI2) .AND. !EMPTY(M->B1_CTAPIS) .AND. !EMPTY(M->B1_CTAREC1) .AND. !EMPTY(M->B1_CTAREC2) .AND. !EMPTY(M->B1_CTARES) .AND. !EMPTY(M->B1_CTICMS2) .AND. !EMPTY(M->B1_CTITEM1) .AND. !EMPTY(M->B1_ITEMCC) .AND. !EMPTY(M->B1_CTACOFI)
//		alert("entrou 2")
		_lRet	:= .T.
//		_cFase	:= "2"
	Else
		Alert("Existem campos obrigatorios para a fase atual do cadastro - FASE 2 ")
	EndIf

ElseIf M->B1_MYVOLTA<>"1" .AND. M->B1_MYFASE == "3" .and. Upper(Trim(_cUsuario)) == Upper(Trim(GETMV("MV_MYFASE3")))
	If !EMPTY(M->B1_GRTRIB) .AND. !EMPTY(M->B1_ORIGEM) .AND. !EMPTY(M->B1_POSIPI) .AND. !EMPTY(M->B1_TE)
		//alert("entrou 3")
		_lRet	:= .T.
//		_cFase	:= "3"
	Else       
	   Alert("Existem campos obrigatorios para a fase atual do cadastro - FASE 3 ")
	EndIf

ElseIf M->B1_MYVOLTA<>"1" .AND. M->B1_MYFASE == "4" .and. Upper(Trim(_cUsuario)) == Upper(Trim(GETMV("MV_MYFASE4")))
	If !EMPTY(M->B1_LOCPAD) .AND. !EMPTY(M->B1_MSBLQL) .AND. !EMPTY(M->B1_TIPO) .AND. !EMPTY(M->B1_UM) .AND. !EMPTY(M->B1_TE) .AND. !EMPTY(M->B1_TS)
		//alert("entrou 4")
		_lRet	:= .T.                                                               
//		_cFase	:= "3"
	Else
		Alert("Existem campos obrigatorios para a fase atual do cadastro - FASE 4 ")
	EndIf




	
ElseIf M->B1_MYVOLTA<>"1" .AND. M->B1_MYFASE == "F" .and. Upper(Trim(_cUsuario)) == Upper(Trim(GETMV("MV_MYFASEF")))
		//alert("entrou F")
		_lRet	:= .T.
//		_cFase	:= "4"


EndIf



If M->B1_MYVOLTA<>"1" .AND. _lRet .and. _cFase=="1"
	M->B1_MYFASE	:= "2"
	M->B1_MSBLQL	:= "1"
	M->B1_MYFASE1	:= _cUsuario
ElseIf M->B1_MYVOLTA<>"1" .AND. _lRet .and. _cFase=="2"
	M->B1_MYFASE	:= "3"
	M->B1_MSBLQL	:= "1"
	M->B1_MYFASE2	:= _cUsuario
ElseIf M->B1_MYVOLTA<>"1" .AND. _lRet .and. _cFase=="3"
	M->B1_MYFASE	:= "4"
	M->B1_MSBLQL	:= "1"
	M->B1_MYFASE3	:= _cUsuario
ElseIf M->B1_MYVOLTA<>"1" .AND. _lRet .and. _cFase=="4"
	M->B1_MYFASE	:= "F"
	M->B1_MSBLQL	:= "2"
	M->B1_MYFASE4	:= _cUsuario


ElseIf M->B1_MYVOLTA=="1"
	M->B1_MYFASE	:= "1"
	M->B1_MSBLQL	:= "1"
	//M->B1_MYFASE4	:= Upper(Trim(GETMV("MV_MYFASE1")))
EndIf


//manda e-mail
If _lRet
	U_MYES01(M->B1_MYFASE,_cUsuario)
EndIf



If _lRet

	_cUsuAtual	:= _cUsuario
	
	DBSelectArea("ZZJ")
	DBSetOrder(1)
	RecLock("ZZJ",.T.)
	ZZJ->ZZJ_FILIAL	:= Substr(CNUMEMP,3,2)
	ZZJ->ZZJ_DATA	:= DDATABASE
	ZZJ->ZZJ_ORIGEM	:= "FASE " + _cFase
	ZZJ->ZZJ_DESTIN	:= "FASE " + M->B1_MYFASE

	If M->B1_MYVOLTA<>"1" .and. _cFase=="1" .and. Empty(M->B1_MYMOTRJ)
		ZZJ->ZZJ_OBS	:= M->B1_DESC+"PROCESSO INICIAL"
	ElseIf M->B1_MYVOLTA<>"1" .and. _cFase=="1" .and. !Empty(M->B1_MYMOTRJ)
		ZZJ->ZZJ_OBS	:= M->B1_DESC+"REPROCESSO INICIAL POR REJEICAO"
	ElseIf M->B1_MYVOLTA=="1"
		ZZJ->ZZJ_OBS	:= M->B1_DESC+"PRODUTO REJEITADO = " + Substr(M->B1_MYMOTRJ,1,50)
	ElseIf M->B1_MYFASE=="F"
		ZZJ->ZZJ_OBS	:= M->B1_DESC+"PROCESSO FINALIZADO"
	Else
		ZZJ->ZZJ_OBS	:= M->B1_DESC+"TROCA NORMAL DE FASE"
	EndIf
                     


	ZZJ->ZZJ_TEXTO	:= SUBSTR(CNUMEMP,3,2)+M->B1_COD+upper(_cUsuAtual)

	If M->B1_MYVOLTA<>"1" .and. _cFase=="1" .and. Empty(M->B1_MYMOTRJ)
		ZZJ->ZZJ_TIPO	:= "I"
	ElseIf M->B1_MYVOLTA<>"1" .and. _cFase=="1" .and. !Empty(M->B1_MYMOTRJ)
		ZZJ->ZZJ_TIPO	:= "J"
	ElseIf M->B1_MYVOLTA=="1"
		ZZJ->ZZJ_TIPO	:= "R"
	ElseIf M->B1_MYFASE=="F"
		ZZJ->ZZJ_TIPO	:= "F"
	Else
		ZZJ->ZZJ_TIPO	:= "P"
	EndIf

	ZZJ->ZZJ_HORA	:= TIME()
	ZZJ->ZZJ_CHAVE	:= M->B1_CHAVE

	
	MsUnLock()
	
	//legenda
	// S=Solicitante
	// I=inicio
	// P=Processo normal
	// R=Rejeicao
	// F=Processo finalizado
	// J=inicio por rejeicao

	
EndIf


//retira o flag de devolucao
M->B1_MYVOLTA:="2"



Return(_lRet)

