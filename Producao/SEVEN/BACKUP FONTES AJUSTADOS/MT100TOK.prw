#Include "Protheus.ch"
/*/{Protheus.doc} ACD170VE

EM QUE PONTO : Este P.E. e chamado na funcao A103Tudok()
Pode ser usado para validar a inclusao da NF.

Esse Ponto de Entrada e chamado 2 vezes dentro da rotina A103Tudok(). 
Para o controle do numero de vezes em que ele e chamado foi criada a variavel logica lMT100TOK, que quando for definida como (.F.) 
o ponto de entrada sera chamado somente uma vez.

@type function
@author Celso Costa 
@since 09/03/2022
@version P11,P12
@database MSSQL,Oracle

@history 29/06/2022, Julio Cesar Dias de Oliveira - FSW Seven Consultoria RP, Criacao da validacao da variavel cEspecie
@history 29/06/2022, Julio Cesar Dias de Oliveira - FSW Seven Consultoria RP, Revisao ProtheusDoc
@history 29/06/2022, Julio Cesar Dias de Oliveira - FSW Seven Consultoria RP, Revisao CleanCode

@return lRet, logical - Verdadeiro ou Falso

@see MATA140
@see MATA103
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085400
/*/ 
User Function MT100TOK()
	Local lReadVar			:= .F.
	Local nRecord			:= 00
	Local cTESMsg			:= ""
	Local cBlqTES			:= GetMV( "MV_ZZBLTES" )
	Local lAtvVldEspecie	:= GetNewPar("7V_ATVVLE",.T.)
	Local lRet				:= ParamIXB[ 01 ]
	
	If lRet
		For nRecord := 01 To Len( aCols )
			If !GdDeleted( nRecord, aHeader, aCols )
				If Alltrim( GdFieldGet( "D1_TES", nRecord, lReadVar, aHeader, aCols ) ) $ cBlqTES .And. Empty( GdFieldGet( "D1_OP", nRecord, lReadVar, aHeader, aCols ) )
					cTESMsg += Iif( !Empty( cTESMsg ), "/", "" ) + Alltrim( GdFieldGet( "D1_TES", nRecord, lReadVar, aHeader, aCols ) )
					lRet := .F.
				EndIf
			EndIf
		Next nRecord
		If !lRet
			MsgAlert( "Foram informados tipos de entradas (TES) que obrigam a digitacao da Ordem de Producao, favor verificar." + Chr( 13 ) + Chr( 10 ) + cTESMsg, "MT100TOK" )
		EndIf
	EndIf
	
	If lRet 
		If lAtvVldEspecie
			If Empty(AllTrim(cEspecie))
				MsgAlert("A especie do documento nao podera ser vazia.","PLASTICOS NOVEL")
				lRet := .F.
			Endif
		Endif
	Endif

Return lRet
