#Include "protheus.ch"
#Include 'parmtype.ch'

#Define ENTRADA "0"
#Define SAIDA   "1"

/*
//Ponto de Entrada para customizacao dos dados do XML e da Danfe da Nota Fiscal Eletronica
*/
User Function PE01NFESEFAZ()
	
Local _aRetorno	:= {}
Local _aProd		:= ParamIXB[ 01 ]
Local _aDest		:= ParamIXB[ 04 ]
Local _aNota		:= ParamIXB[ 05 ] 
Local _aInfoItem	:= ParamIXB[ 06 ]
Local _aDupl		:= ParamIXB[ 07 ]
Local _aTransp		:= ParamIXB[ 08 ]
Local _aEntrega	:= ParamIXB[ 09 ]
Local _aRetirada	:= ParamIXB[ 10 ]
Local _aVeiculo	:= ParamIXB[ 11 ]
Local _aReboque	:= ParamIXB[ 12 ]	
Local _aNfVincRur	:= ParamIXB[ 13 ]	
Local _aEspVol		:= ParamIXB[ 14 ]
Local _aNfVinc		:= ParamIXB[ 15 ]
		
Private cMensCli	:= AllTrim( ParamIXB[ 02 ] )
Private cMensFis	:= AllTrim( ParamIXB[ 03 ] )
			
infAdicionais( _aNota, _aInfoItem )
			
aAdd( _aRetorno, _aProd			)
aAdd( _aRetorno, cMensCli		)
aAdd( _aRetorno, cMensFis		)
aAdd( _aRetorno, _aDest			)
aAdd( _aRetorno, _aNota			)
aAdd( _aRetorno, _aInfoItem	)
aAdd( _aRetorno, _aDupl	  		)
aAdd( _aRetorno, _aTransp		)
aAdd( _aRetorno, _aEntrega		)
aAdd( _aRetorno, _aRetirada	)
aAdd( _aRetorno, _aVeiculo		)
aAdd( _aRetorno, _aReboque		)
aAdd( _aRetorno, _aNfVincRur	)
aAdd( _aRetorno, _aEspVol		)
aAdd( _aRetorno, _aNfVinc		)

Return ( _aRetorno )

/*
// Tratativa das Mensagens Adicionais
*/
Static Function infAdicionais( _aNota, _aInfoItem )

//Local _nCont			:= 00
Local _nAux				:= 01
Local _cCliFor			:= ""
Local _cLoja  			:= ""
//Local _cProduto		:= ""
//Local _cItem			:= ""
Local _cPedTemp		:= ""
Local _cRedespacho	:= ""
//Local _cSerie			:= _aNota[ 01 ]
//Local _cDoc				:= _aNota[ 02 ]
Local _cTipo			:= _aNota[ 04 ]
Local _cTipoNF			:= _aNota[ 05 ]
	
If _cTipo == ENTRADA
		
	_cCliFor	:= SF1->F1_FORNECE
	_cLoja	:= SF1->F1_LOJA
		                 
	If _cTipoNF $ "BD"

		dbSelectArea( "SA1" )
		SA1->( dbSetOrder( 01 ) )
		SA1->( dbSeek( xFilial( "SA1" ) + SF1->F1_FORNECE + SF1->F1_LOJA ) )

	Else

		dbSelectArea( "SA2" )
		SA2->( dbSetOrder( 01 ) )
		SA2->( dbSeek( xFilial( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA ) )

	EndIf
		
	dbSelectArea( "ZZX" )
	ZZX->( dbSetorder( 01 ) )

	If dbSeek( xFilial( "ZZX" ) + "E" + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )

		While	ZZX->( !( Eof() ) ) .And. ZZX->ZZX_MYTDOC == "E" .And.;
				ZZX->ZZX_MYDOC == SF1->F1_DOC .And. ZZX->ZZX_MYSERI == SF1->F1_SERIE .And.;
				ZZX->ZZX_MYCLIF == SF1->F1_FORNECE .And. ZZX->ZZX_MYLOJA == SF1->F1_LOJA

			cMensCli := PutMsg( cMensCli, AllTrim( ZZX->ZZX_MYTEXT ) )

			ZZX->( dbSkip() )

		EndDo
		
	EndIf
	
ElseIf _cTipo == SAIDA

	_cCliFor	:= SF2->F2_CLIENTE
	_cLoja	:= SF2->F2_LOJA
	
	dbSelectArea( "ZZX" )
	ZZX->( dbSetorder( 01 ) )

	If ZZX->( dbSeek( xFilial( "ZZX" ) + "S" + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )

		While	ZZX->( !( Eof() ) ) .And. ZZX->ZZX_MYTDOC == "S" .And.;
				ZZX->ZZX_MYDOC == SF2->F2_DOC .And. ZZX->ZZX_MYSERI == SF2->F2_SERIE .And.;
				ZZX->ZZX_MYCLIF == SF2->F2_CLIENTE .And. ZZX->ZZX_MYLOJA == SF2->F2_LOJA				

				cMensCli := PutMsg( cMensCli, AllTrim( ZZX->ZZX_MYTEXT ) )

				ZZX->( dbSkip() )

		EndDo

	EndIf
	
	dbSelectArea( "SC5" )
	SC5->( dbSetOrder( 01 ) )
	
	_cRedespacho := ""
	
	If SC5->( dbSeek( xFilial( "SC5" ) + _aInfoItem[ _nAux ][ 01 ] ) )
	
		If !Empty( SC5->C5_REDESP )

			dbSelectArea( "SA4" )
			SA4->( dbSetOrder( 01 ) )
			
			If SA4->( dbSeek( xFilial( "SA4" ) + SC5->C5_REDESP ) )
				_cRedespacho := AllTrim( SA4->A4_NOME )						
			EndIf
			
		Else
			
			If !Empty( SC5->C5_ZZREDES )
				_cRedespacho := AllTrim( SC5->C5_ZZREDES )
			EndIf
			
		EndIf
			
	EndIf
	
	If !Empty( _cRedespacho )
		_cRedespacho := "Frete Seccionado: 1o.Trecho por conta do Emitente/2o.Trecho por conta do Destinatario - Transportadora " + AllTrim( _cRedespacho ) 
	EndIf
	
	dbSelectArea( "SC6" )
	SC6->( dbSetOrder( 01 ) )

	For _nAux := 01 To Len( _aInfoItem )

		If SC6->( dbSeek( xFilial( "SC6" ) + _aInfoItem[ _nAux ][ 01 ] + _aInfoItem[ _nAux ][ 02 ] + _aInfoItem[ _nAux ][ 03 ] + _aInfoItem[ _nAux ][ 04 ] ) )

			If !( AllTrim( SC6->C6_NUMPCOM ) $ _cPedTemp )
				_cPedTemp += Space( 01 ) + SC6->C6_NUMPCOM + If( Empty( SC6->C6_ITEMPC ), "", "/" + AllTrim( SC6->C6_ITEMPC ) )
			EndIf

		EndIf

	Next _nAux

	If !Empty( _cPedTemp )
		cMensCli += "Pedido do Cliente: " + _cPedTemp
	EndIf
	
	If !Empty( _cRedespacho )
		cMensCli += Iif( !Empty( cMensCli ), " ", "" ) + _cRedespacho
	EndIf
	
EndIf

Return

/*
// Concatena as Mensagens Adicionais
*/
Static Function PutMsg( _cMens, _cNewStr )
	
Local _cNewMens	:= Upper( AllTrim( _cNewStr ) )
Local _cRet			:= _cMens
	
If !Empty( _cNewMens ) .And. !( Upper( _cNewMens ) $ Upper( AllTrim( cMensCli ) ) )

	If Right( _cRet, 01 ) != "."
		_cRet += "."	
	EndIf
		
	If !Empty( _cMens )
		_cMens += " "
	EndIf		

	_cRet := _cMens + _cNewMens

EndIf
	
Return( _cRet )

/*
 * Informações da placa do veiculo
*/

/* SSILVA 20180112
static function infVeiculos (cTipo,aVeic)

	Local	aRet	:=	aVeic
	
	if cTipo == ENTRADA
		if Len(aRet)==0 .and. !Empty(SF1->F1_ZZPLACA)
			aAdd(aRet,SF1->F1_ZZPLACA)
			aAdd(aRet,"") //Uf da Placa
			aAdd(aRet,"") //RNTC
		endif
	endif
		
	if cTipo == SAIDA
		if Len(aRet)==0 .and. !Empty(SF2->F2_ZZPLACA)
			aAdd(aRet,SF2->F2_ZZPLACA)
			aAdd(aRet,"") //Uf da Placa
			aAdd(aRet,"") //RNTC
		endif
	endif
	
return(aRet) 
*/
