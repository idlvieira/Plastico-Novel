#include "Protheus.ch"
#include "AP5Mail.ch"

static cCOD 		:= 'TMK000004'

/*/
TMKVFIM
Descricao Ponto de Entrada executado na confirmacao do Atendimento no
Televendas para gravacao de Campos nas Tabelas SC5 e SC6.
Uso do departamento Comercial.
Controle da Alcada de Descontos e Geracao de PV

/*/
user function TMKVFIM( _cNumAT, _cNumPV )
	local _cQuery		:= GetNextAlias()
	local _aArea  		:= GetArea()
	local _aAreaSUA		:= SUA->( GetArea() )
	local _aAreaSUS		:= SUS->( GetArea() )
	local _aAreaSUB		:= SUB->( GetArea() )
	local _aAreaSC5		:= SC5->( GetArea() )
	local _aAreaSC6		:= SC6->( GetArea() )
	local _nDesconto	:= 00
	local _nNivel		:= 00
	local cPiperun		:= SUA->UA_PIPERUN
	local nNivelAprov   := 00
	local cNivelAtual   := ""
	local cAprov	    := ""
	local _nDscOrc1		:= U_MYCFG02( "TMK000001", "001", "P",, "N" )
	local _nDscOrc2		:= U_MYCFG02( "TMK000001", "002", "P",, "N" )
	local _cAprovador	:= ""
	local lProspect         := SUA->UA_PROSPEC              as logical

	private _nCom		:= 01
	private _nRevise	:= 00

	if INCLUI .or. ALTERA

		if ALTERA
			GrvDtAltera()
		endif

		if alltrim(SUA->UA_OPER) == "1" //Faturamento                                                  ³

			dbSelectArea( "SA1" )
			SA1->(dbSetOrder(01))

			dbSelectArea( "SC6" )
			SC6->(dbSetOrder(01))

			dbSelectArea( "SC5" )
			SC5->(dbSetOrder(01))

			if SC5->(dbSeek(FWxFilial("SC5")+_cNumPV))

				if SA1->(dbSeek(FWxFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))
					if RecLock("SC5", .F.)
						SC5->C5_CLIENT		:= SUA->UA_ZZCLENT
						SC5->C5_LOJAENT		:= SUA->UA_ZZLJENT
						SC5->C5_FRETE		:= SUA->UA_FRETE
						SC5->C5_MENNOTA		:= SUA->UA_ZZOBS1
						SC5->C5_ZZOBS2		:= SUA->UA_ZZOBS2
						SC5->C5_ZZREVIS		:= SUA->UA_ZZREVIS
						SC5->C5_ZZENTPA		:= SUA->UA_ZZENTPA
						SC5->C5_ZZTEMGR		:= SUA->UA_ZZTEMGR
						SC5->C5_MOEDA		:= SUA->UA_MOEDA
						SC5->C5_ZZCifOB		:= SUA->UA_ZZCifOB
						SC5->C5_ZHORA		:= SubStr( Time(), 01, 05 )
						SC5->C5_ZZUANA1		:= "N"
						SC5->C5_ZZUANA2		:= "N"
						SC5->C5_ZZUANA3		:= ""
						SC5->C5_PIPERUN 	:= cPipeRun
						SC5->(MsUnLock())
					endif

					BeginSQL Alias _cQuery
					Select
						SUB.UB_NUMPV,
						SUB.UB_ITEMPV,
						SUB.UB_local,
						SUB.UB_NUMPCOM,
						SUB.UB_ITEMPC,
						SUB.UB_ZZDATEN,
						SUB.UB_ZZENTPA,
						SUB.UB_ZZTGRAV,
						SUB.UB_VRUNIT,
						SUB.UB_ZZDEFIS
					From
						%Table:SUB% SUB
					Where SUB.UB_NUM = %Exp:alltrim(_cNumAT )%
						And SUB.UB_FILIAL = %FWxFilial:SUB%
						And SUB.%NotDel%
					EndSQL

					While (_cQuery )->(!Eof())
						if SC6->(dbSeek(FWxFilial("SC6")+(_cQuery)->UB_NUMPV+(_cQuery)->UB_ITEMPV))
							if RecLock( "SC6", .F. )
								SC6->C6_ZZDATEN		:= StoD( (_cQuery)->UB_ZZDATEN )
								SC6->C6_local		:= (_cQuery)->UB_local
								SC6->C6_ZZENTPA		:= (_cQuery)->UB_ZZENTPA
								SC6->C6_ZZTGRAV		:= (_cQuery)->UB_ZZTGRAV
								SC6->C6_NUMPCOM		:= (_cQuery)->UB_NUMPCOM
								SC6->C6_ITEMPC		:= (_cQuery)->UB_ITEMPC
								SC6->C6_ZZUQTPR		:= 00
								SC6->C6_ZZUANA2		:= ""

								// Verifica se o Desconto e Fiscal ou Comercial  /Validacao em Vigor a partir de abril/2016
								if alltrim((_cQuery)->UB_ZZDEFIS) != "1"
									SC6->C6_DESCONT	:= 00
									SC6->C6_VALDESC	:= 00
									SC6->C6_PRUNIT	:= (_cQuery)->UB_VRUNIT
								endif
								SC6->(MsUnLock())
							endif
						endif
						(_cQuery)->(dbSkip())
					EndDo

					(_cQuery)->(dbCloseArea())

					MsgInfo( "Pedido de Vendas Numero " + alltrim(_cNumPV ) + " gerado com sucesso.", "TMKFIM" )

					if !empty(cPiperun)
						PipeRun.Deals.u_DealsRequested(cPiperun, _cNumPV, SUA->UA_XFUNIL, SUA->UA_XSTAGE)
					endif

					if RecLock("SUA", .F.)
						SUA->UA_ZZSTAT1 := "LIB"
						SUA->(MsUnLock())
					endif

					// Imprime pedido de vendas em modo grafico
					U_MYTMK02()
				endif
			endif

		Elseif alltrim(M->UA_OPER ) == "2" //Orcamento

			if INCLUI
				_nNivel	:= 00
				U_MYTMK21("O", "B", "I", cUserName, _nNivel)	// Grava aprovador desconto no arquivo dde Log
			endif

			_nRevise	:= SUA->UA_ZZREVIS

			aDadCab	:= {}

			if lMudou
				FwAlertInfo("Esse Orcamento nao gerou pedido e foi para analise de limite de credito")

				if RecLock("SUA", .F.)
					SUA->UA_ZZSTAT1 := "BLO"
					SUA->(MsUnLock())
				endif

				// e-mail para informar o bloqueio do orcamento
				U_MailPed()
				lMudou := .F.
			endif

			// e-mail para informar o vendedor sobre a documentacao
			SA1->(dbSetOrder(01))
			if SA1->(!dbSeek(FWxFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))
				SUS->(dbSetOrder(01))
				if SUS->(dbSeek(FWxFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA))
					if Empty(SUS->US_CODCLI)
						if FWAlertYesNo("Deseja enviar email para o vendedor solicitando a documentacao para cadastrar o cliente? ")
							U_mailPro()
						endif
					endif
				endif
			endif

			// Validacao MicroEmpresa Bahia
			if alltrim(SA1->A1_ZZME) == "S" .and. alltrim(SA1->A1_EST) == "BA" .and. Empty(SUA->UA_ZZSTAT2) .and. alltrim(SA1->A1_ZGRPNV) != '1'
				lBloq = .T.
				lMudou =.F.
			endif

			if lBloq .and. !lMudou
				SUB->(dbSetOrder(01))
				SUB->(dbSeek(FWxFilial("SUB") + SUA->UA_NUM))

				_nDesconto := 00

				While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == FWxFilial("SUB")+SUA->UA_NUM
					// Validacao Microempresa Bahia - 18/10/2013 - analise de desconto
					if alltrim(SA1->A1_ZZME) == "S" .and. alltrim(SA1->A1_EST) == "BA"
						_nDesconto	:= SUB->UB_ZZDESCM
					Else
						if _nDscOrc1 < SUB->UB_DESC
							_nDesconto := SUB->UB_DESC
							Exit
						endif
					endif
					SUB->(dbSkip())
				EndDo

				if _nDesconto > _nDscOrc1 .and. _nDesconto < _nDscOrc2

					_nNivel		:= 01
					_cAprovador	:= U_MYTMK05(SUA->UA_NUM, _nNivel)

					dbSelectArea('ZZZ')
					ZZZ->(DBSetOrder(02)) //ZZZZ_FILIAL+ZZZ_COD+ZZZ_RETORN
					if ZZZ->(dbSeek(FWxFilial('ZZZ')+cCOD+alltrim(Upper(_cAprovador))))
						cNivelAtual := ZZZ->ZZZ_ITEM
					endif

					if RecLock("SUA", .F.)
						SUA->UA_ZZSTAT2	:= "BLO"
						SUA->UA_ZZAPROV	:= alltrim(Upper(_cAprovador))
						SUA->UA_ZZNIVEL	:= 00
						SUA->UA_XBDESC  := "Aguardando a liberação de desconto pelo aprovador " + _cAprovador
						SUA->UA_XBNIVEL := cNivelAtual
						SUA->(MsUnLock())
					endif

					// Grava margem no Orcamento
					U_MYTMK04()

					// Grava aprovador do desconto arquivo de LOG
					_nNivel	:= 00
					U_MYTMK21("D", "B", "A", cUserName, _nNivel)
					FwAlertInfo( "Esse Orcamento foi encaminhado para Analise de Desconto")
					U_fNotPrxAp(_cAprovador)

				Else

					// Validacao Microempresa Bahia
					if alltrim(SA1->A1_ZZME ) == "S" .and. alltrim(SA1->A1_EST ) == "BA" .and. _nDesconto < _nDscOrc1 .and. alltrim(SA1->A1_ZGRPNV ) != '1'

						if RecLock("SUA", .F.)
							SUA->UA_ZZSTAT2	:= "LIB"
							SUA->UA_ZZSTAT1	:= "BLO"
							SUA->(MsUnLock() )
						endif

						FwAlertInfo("Orcamento nao gerou Analise de Desconto, verificar.")

					Else
						_nNivel		:= 01
						_cAprovador	:= U_MYTMK05(SUA->UA_NUM, _nNivel)

						if lProspect
							cSeguiment := alltrim(Posicione("SUA",1,FWxFilial("SUA")+SUA->(UA_CLIENTE+UA_LOJA),"US_XSEGUIM")) 
						else
							cSeguiment := alltrim(Posicione("SA1",1,FWxFilial("SA1")+SUA->(UA_CLIENTE+UA_LOJA),"A1_ZZSEG")) 
						endif

						if inclui
							cNivelAtual := 'AP1'
						endif	

						if RecLock("SUA", .F.)
							SUA->UA_ZZSTAT2	:= "BLO"
							SUA->UA_ZZAPROV	:= alltrim(Upper( _cAprovador))
							SUA->UA_ZZNIVEL	:= 00
							SUA->UA_XBDESC  := "Aguardando a liberação de desconto pelo aprovador " + _cAprovador
							SUA->UA_XBNIVEL := cNivelAtual
							SUA->UA_XSEGUIM := cSeguiment
							SUA->(MsUnLock())
						endif

						// Grava margem no Orcamento
						U_MYTMK04()
						// Grava o aprovador no Orcamento
						U_MYTMK05()
						// Grava aprovador desconto no arquivo LOG
						_nNivel	:= 00
						U_MYTMK21("D", "B", "A", cUserName, _nNivel)
						FwAlertInfo("Esse Orcamento foi encaminhado para Analise de Desconto.")
						U_fNotPrxAp( _cAprovador )
					endif
				endif
			endif
		endif
	endif

	if ALTERA .and. (cOldCli <> alltrim(M->UA_CLIENTE+M->UA_LOJA) )
		DBSelectArea("SUA")

		nNivelAprov	:= 01
		cAprov		:= U_MYTMK05( SUA->UA_NUM, nNivelAprov )

		dbSelectArea('ZZZ')
		ZZZ->(DBSetOrder(02)) //ZZZZ_FILIAL+ZZZ_COD+ZZZ_RETORN
		if ZZZ->(dbSeek(FWxFilial('ZZZ')+cCOD+alltrim(Upper(_cAprovador))))
			cNivelAtual := ZZZ->ZZZ_ITEM
		endif

		SUA->(DBSetOrder(01))//UA_FILIAL+UA_NUM
		if SUA->(MsSeek(FWFWxFilial("SUA")+padr(UA_NUM,FWTamSX3("UA_NUM")[1])))
			if SUA->(recLock( "SUA", .F. ))
				SUA->UA_ZZSTAT1 := "BLO"
				if SUA->UA_ZZSTAT2 == "LIB"
					SUA->UA_ZZSTAT2:= "BLO"
					SUA->UA_ZZAPROV	:= alltrim(Upper(cAprov))
					SUA->UA_ZZNIVEL	:= 00
					SUA->UA_XBDESC  := "Aguardando a liberação de desconto pelo aprovador " + _cAprovador
					SUA->UA_XBNIVEL := cNivelAtual
				endif
				SUA->( MsUnLock() )
			endif
			U_MailPed()
		endif
	endif

	//Envia e-mail para tesouraria quando utilizada condicao de  pagamento especifica
	if alltrim(SUA->UA_CONDPG) $ Posicione("ZZZ", 01, FWxFilial("ZZZ") + "TMK000001" + "005", "ZZZ_RETORN")
		MyCondPag()
	endif

	restArea( _aAreaSC6 )
	restArea( _aAreaSC5 )
	restArea( _aAreaSUB )
	restArea( _aAreaSUS )
	restArea( _aAreaSUA )
	restArea( _aArea )

return

/*/
	Descricao ³ Envio de e-mail para informar o vendedor sobre a documentacao que deve ser enviada para o cadastro do cliente.
/*/
user function MailPro()
	local oHtml
	local _cBody		:= ""
	local _cTitulo		:= ""
	local _cAssunto	:= " Documentacao para cadastro do cliente"
	local _cPara		:= Posicione("SA3", 01, FWxFilial("SA3") + SUA->UA_VEND, "A3_EMAIL" )
	local _aCorpo		:= {}
	local _aRodape		:= {}

	if Empty(_cPara )
		FwAlertInfo("O campo de email no cadastro do vendedor esta em branco")
	endif

	dbSelectarea( "SF2" )

	SUS->(dbSetOrder(01))
	SUS->(dbSeek( FWxFilial( "SUS" ) + SUA->UA_CLIENTE + SUA->UA_LOJA))

	aAdd( _aCorpo, "Senhor(a) Vendedor(a)" )
	aAdd( _aCorpo, "" )
	aAdd( _aCorpo, "Favor enviar a Documentacao do prospect " + SUS->US_NOME )
	aAdd( _aCorpo, "" )
	aAdd( _aCorpo, "para efetivar o prospect em cliente. " )

	aAdd( _aRodape, "" )
	aAdd( _aRodape, "Obrigado" )

	oHtml := CorpoEmail():new( _cTitulo, _aCorpo, _aRodape )
	oHtml:GeraHtml()

	_cBody := oHtml:cHtml

	U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, alltrim(_cPara ) + Chr( 59 ), _cAssunto, _cBody, /*Attatch*/, /*lResultSend*/, /*_cLog*/ )

return

/*/
	Descricao ³ Envio de e-mail para informar o bloqueio do orcamento
/*/
user function MailPed()
	local oHtml
	local _cBody		:= ""
	local _cPara		:= Posicione("ZZZ", 01, FWxFilial( "ZZZ" ) + "TMK000001" + "006", "ZZZ_RETORN" )
	local _cAssunto		:= " Orcamento de numero " + alltrim(SUA->UA_NUM ) + " impedido de gerar o PV para analise de limite de credito"
	local _aCorpo		:= {}
	local _aRodape		:= {}

	dbSelectarea( "SF2" )

	aAdd( _aCorpo, "O Orcamento abaixo:" )
	aAdd( _aCorpo, "" )
	aAdd( _aCorpo, "Numero " + alltrim(SUA->UA_NUM))
	aAdd( _aCorpo, "" )
	aAdd( _aCorpo, "Precisa da liberacao da analise de limite de credito. " )

	aAdd( _aRodape, "" )
	aAdd( _aRodape, "Obrigado" )

	oHtml := CorpoEmail():New( _cTitulo, _aCorpo, _aRodape )
	oHtml:GeraHtml()

	_cBody := oHtml:cHtml

	U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, alltrim(_cPara ) + Chr( 59 ), _cAssunto, _cBody, /*Attatch*/, /*lResultSend*/, /*_cLog*/ )


return

/*/
	Descricao ³ Grava historico dos orcamentos
/*/
user function GrvCabItm( _nNum, _nItem, _nProd, _nDescr, _nQtd, _nVrUnit, _nVlrItm, _nDsc, _nValDesc, _lProd )
	local _nL	:= 01

	Begin Transaction

		if _nCom == 01
			_nRevise += 01
			if RecLock("SUA", .F.)
				SUA->UA_ZZREVIS	:= _nRevise
				SUA->(MsUnLock())
			endif
			_nCom += 01
		endif

		For _nL := 01 To 02
			if RecLock( "ZZY", .T. )
				ZZY->ZZY_MYFILI	:= FWxFilial( "ZZY" )
				ZZY->ZZY_MYREVI	:= alltrim(Str( _nRevise))
				ZZY->ZZY_MYORCA	:= M->UA_NUM
				ZZY->ZZY_MYCODC	:= Iif( _nL == 01, _aDadCab[ 01][ 02 ], M->UA_CLIENTE )
				ZZY->ZZY_MYLOJA	:= Iif( _nL == 01, _aDadCab[ 01][ 03 ], M->UA_LOJA )
				ZZY->ZZY_MYDESC	:= Iif( _nL == 01, _aDadCab[ 01][ 04 ], M->UA_NOME )
				ZZY->ZZY_MYTPFR	:= Iif( _nL == 01, _aDadCab[ 01][ 05 ], M->UA_TPFRETE )
				ZZY->ZZY_MYTEMG	:= Iif( _nL == 01, _aDadCab[ 01][ 06 ], M->UA_ZZTEMGR )
				ZZY->ZZY_MYENTP	:= Iif( _nL == 01, _aDadCab[ 01][ 07 ], M->UA_ZZENTPA )
				ZZY->ZZY_MYITEM	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 01 ], aCols[ _nNum ][ _nItem ] )
				ZZY->ZZY_MYPROD	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 02 ], aCols[ _nNum ][  _nProd ] )
				ZZY->ZZY_MYDESP	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 03 ], aCols[ _nNum ][ _nDescr ] )
				ZZY->ZZY_MYQTD		:= Iif( _nL == 01, _aDadItem[ _nNum ][ 04 ], aCols[ _nNum ][ _nQtd ] )
				ZZY->ZZY_MYVRUN	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 05 ], aCols[ _nNum ][ _nVrUnit ] )
				ZZY->ZZY_MYVLIT	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 06 ], aCols[ _nNum ][ _nVlrItm ] )
				ZZY->ZZY_MYDSC		:= Iif( _nL == 01, _aDadItem[ _nNum ][ 07 ], aCols[ _nNum ][ _nDsc ] )
				ZZY->ZZY_MYVLDE	:= Iif( _nL == 01, _aDadItem[ _nNum ][ 08 ], aCols[ _nNum ][ _nValDesc ] )
				ZZY->ZZY_MYDATA	:= _aDadCab[ 01 ][ 08 ]
				ZZY->ZZY_MYHORA	:= _aDadCab[ 01 ][ 09 ]
				ZZY->ZZY_MYUSER	:= _aDadCab[ 01 ][ 10 ]
				ZZY->ZZY_MYFLAG	:= Iif( _nL == 01, "A", "D" )
				ZZY->ZZY_MYUSNA	:= _aDadCab[ 01 ][ 11 ]
				ZZY->ZZY_MYNEWP	:= Iif( _aDadItem[ _nNum][ 09 ], "Novo Prod Incluido", "" )
				ZZY->ZZY_MYDELE	:= Iif( _aDadItem[ _nNum][ 10 ], "D", "" )
				ZZY->( MsUnlock() )
			endif
		Next _nL
	End Transaction

return

/*/
	Descricao ³ Grava a data de alteracao
/*/
static function GrvDtAltera()

	if RecLock("SUA", .F.)
		SUA->UA_ZZDTALT	:= dDataBase
		SUA->(MsUnLock())
	endif
return
/*/
	±±³Descricao ³ Envia email para a tesouraria informando a utilizacao de uma condicao de paramento especifica (Parametro)
/*/
static function MyCondPag()
	local _cHTML		:= ""
	local _cEmail		:= Posicione("ZZZ", 01, FWxFilial("ZZZ") + "TMK000001" + "007", "ZZZ_RETORN" )

	_cHtml	+= '<html> '
	_cHtml	+= '<head> '
	_cHtml	+= '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"><meta name=Generator content="Microsoft Word 12 (filtered)"> '
	_cHtml	+= '<style> '
	_cHtml	+= '<!-- '
	_cHtml	+= ' /* Font Definitions */ '
	_cHtml	+= ' @font-face '
	_cHtml	+= '	{font-family:"Cambria Math"; '
	_cHtml	+= '	panose-1:2 4 5 3 5 4 6 3 2 4;} '
	_cHtml	+= '@font-face '
	_cHtml	+= '	{font-family:Calibri; '
	_cHtml	+= '	panose-1:2 15 5 2 2 2 4 3 2 4;} '
	_cHtml	+= '@font-face '
	_cHtml	+= '	{font-family:Tahoma; '
	_cHtml	+= '	panose-1:2 11 6 4 3 5 4 4 2 4;} '
	_cHtml	+= ' /* Style Definitions */ '
	_cHtml	+= ' p.MsoNormal, li.MsoNormal, div.MsoNormal '
	_cHtml	+= '	{margin-top:0cm; '
	_cHtml	+= '	margin-right:0cm; '
	_cHtml	+= '	margin-bottom:10.0pt; '
	_cHtml	+= '	margin-left:0cm; '
	_cHtml	+= '	line-height:115%; '
	_cHtml	+= '	font-size:11.0pt; '
	_cHtml	+= '	font-family:"Calibri","sans-serif";} '
	_cHtml	+= 'p.MsoAcetate, li.MsoAcetate, div.MsoAcetate '
	_cHtml	+= '	{mso-style-link:"Texto de balão Char"; '
	_cHtml	+= '	margin:0cm; '
	_cHtml	+= '	margin-bottom:.0001pt; '
	_cHtml	+= '	font-size:8.0pt; '
	_cHtml	+= '	font-family:"Tahoma","sans-serif";} '
	_cHtml	+= 'p.msopapdefault, li.msopapdefault, div.msopapdefault '
	_cHtml	+= '	{mso-style-name:msopapdefault; '
	_cHtml	+= '	margin-right:0cm; '
	_cHtml	+= '	margin-bottom:10.0pt; '
	_cHtml	+= '	margin-left:0cm; '
	_cHtml	+= '	line-height:115%; '
	_cHtml	+= '	font-size:12.0pt; '
	_cHtml	+= '	font-family:"Times New Roman","serif";} '
	_cHtml	+= 'p.msochpdefault, li.msochpdefault, div.msochpdefault '
	_cHtml	+= '	{mso-style-name:msochpdefault; '
	_cHtml	+= '	margin-right:0cm; '
	_cHtml	+= '	margin-left:0cm; '
	_cHtml	+= '	font-size:10.0pt; '
	_cHtml	+= '	font-family:"Times New Roman","serif";} '
	_cHtml	+= 'span.TextodebaloChar '
	_cHtml	+= '	{mso-style-name:"Texto de balão Char"; '
	_cHtml	+= '	mso-style-link:"Texto de balão"; '
	_cHtml	+= '	font-family:"Tahoma","sans-serif";} '
	_cHtml	+= '.MsoChpDefault '
	_cHtml	+= '	{font-size:10.0pt;} '
	_cHtml	+= '@page Section1 '
	_cHtml	+= '	{size:595.3pt 841.9pt; '
	_cHtml	+= '	margin:70.85pt 3.0cm 70.85pt 3.0cm;} '
	_cHtml	+= 'div.Section1 '
	_cHtml	+= '	{page:Section1;} '
	_cHtml	+= '--> '
	_cHtml	+= '</style> '
	_cHtml	+= '</head> '
	_cHtml	+= '<body lang=PT-BR> '
	_cHtml	+= '<div class=Section1> '
	_cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>Orcamento com condicao de Pagamento especifica</span></i></b></p> "
	_cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>&nbsp;</span></i></b></p> "
	_cHtml	+= "<p class=MsoNormal>Foi incluido um Orcamento de vendas do cliente:  <b><i><span "
	_cHtml	+= "style='font-size:12.0pt;line-height:115%'>" + alltrim(SUA->UA_CLIENTE ) + "/" + alltrim(SUA->UA_LOJA ) + " do Orçamento: " + alltrim(SUA->UA_NUM ) + " </span></i></b><span "
	_cHtml	+= ' <p class=MsoNormal style="text-indent:35.4pt"><b><i><spanstyle="font-size:14.0pt;line-height:115%"></span></i></b></p> '
	_cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
	_cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
	_cHtml	+= '<p class=MsoNormal><b><i>Informações Complementares:</i></b></p> '
	_cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
	_cHtml	+= '<p class=MsoNormal>&nbsp;</p> '
	_cHtml	+= '<p class=MsoNormal>Sem mais,</p> '
	_cHtml	+= '<p class=MsoNormal><b><i>' + alltrim(Posicione("ZZZ", 01, FWxFilial("ZZZ") + "TMK000001" + "008", "ZZZ_RETORN")) + '</i></b></p> '
	_cHtml	+= '</div> '
	_cHtml	+= '</body> '
	_cHtml	+= '</html> '


	U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, _cEmail + Chr( 59 ), 'Orcamento com Condicao de Pagamento Especifica', _cHtml, /*_cAttach*/, /*_lMsg*/, /*_cLog*/ )

return  ( .T. )

/*/
	Descricao ³ Envia email para a aprovador desconto do Orcamento
/*/
user function fNotPrxAp( _cAprovador )
	local oHtml			:= Nil
	local _cBody		:= ""
	local _cTitulo 		:= ""
	local _cAssunto		:= " Aprovação de Desconto do Orçamento: " + alltrim(SUA->UA_NUM ) + " [ pendente ] "
	local _cDtHrEmiss	:= StrZero( Day( dDataBase ), 02 ) + "/" + StrZero( Month( dDataBase ), 02 ) + "/" + cValToChar( Year( dDataBase)) + " - " + Time()
	local _cMyEmpFil	:= SM0->M0_CODIGO + "/" + alltrim(SM0->M0_FILIAL )
	local _cPara		:= 'idweb@outook.com'//alltrim(UsrRetMail(_cAprovador))
	local _aCorpo		:= {}
	local _aRodape		:= {}

	aAdd( _aCorpo, "O Orçamento abaixo: " )
	aAdd( _aCorpo, " " )
	aAdd( _aCorpo, "Enviado em: " + _cDtHrEmiss + ", de Número: " + alltrim(SUA->UA_NUM))
	aAdd( _aCorpo, " " )
	aAdd( _aCorpo, "da empresa " + _cMyEmpFil + ",")
	aAdd( _aCorpo, " ")
	aAdd( _aCorpo, "de sua alçada, encontra-se pendente de aprovação. " )

	aAdd( _aRodape, " " )
	aAdd( _aRodape, " " + alltrim(Posicione("SU7", 01, FWxFilial("SU7") + SUA->UA_OPERADO, "U7_NOME")) + " " )
	aAdd( _aRodape, "Depto de Vendas" )

	oHtml := CorpoEmail():New( _cTitulo, _aCorpo, _aRodape )
	oHtml:GeraHtml()

	_cBody := oHtml:cHtml

	U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, alltrim(_cPara ) + Chr( 59 ), _cAssunto, _cBody, /*Attatch*/, /*lResultSend*/, /*_cLog*/ )

return

/*/
	Descricao ³ Retorna conta de email do aprovador
/*/
static function fGetEmail( _cAprovador )
	local _nI	:= 00
	local _cRet	:= ""
	local _aUsu	:= AllUsers()

	For _nI := 01 To len( _aUsu )

		if Upper( alltrim(_aUsu[ _nI, 01, 02 ])) == Upper( alltrim(_cAprovador))
			_cRet	:= alltrim(_aUsu[ _nI, 01, 14 ] )
			Exit
		endif

	Next _nI
return _cRet
