#include 'protheus.ch'

/*/ {Protheus.doc} A650ADCOL

O ponto de entrada 'A650ADCOL' é executado após a inclusão de cada linha do aCols (usado para gerar  empenhos e SC's), permitindo executar qualquer processamento, ou até fazer a manipulação do conteúdo do aCols que acabou de ser incluido.
PE antes da tela de alteração em Empenho para copiar a quantidade original da OP (D4_QUANT) para o campo D4_ZZQTORI 

@type function
@author Leandro Ferreira
@since 29/04/2020
@version P11,P12
@database MSSQL,Oracle

@history 09/06/2022, Júlio César Dias de Oliveira - FSW - Seven Consultoria RP, Revisão ProtheusDoc
@history 09/06/2022, Júlio César Dias de Oliveira - FSW - Seven Consultoria RP, Criação da função podeExecutar()

@obs 
	Contexto:
	If lExistePE
		ExecBlock("A650ADCOL",.F.,.F.,{cProduto,nQuantPai,cOpcionais,cRevisao,SC2->C2_DATPRI})
	EndIf
/*/   

User Function A650ADCOL() 
	Local nPosD4_ZZQTORI 	:= 0
	Local nPosD4_QUANT	 	:= 0
	Local nRecord			:= 0
	
	If podeExecutar()

		nPosD4_ZZQTORI	:= aScan(aHeader,{|x|rTrim(x[2])=="D4_ZZQTORI"})
		nPosD4_QUANT 	:= aScan(aHeader,{|x|rTrim(x[2])=="D4_QUANT"})

		For nRecord := 1 To Len(aCols)
			aCols[nRecord][nPosD4_ZZQTORI] := aCols[nRecord][nPosD4_QUANT]
		Next
	Endif

Return 

/*
	Verifica se pode Executar
*/
Static Function podeExecutar()
	Local lRet := .F.

	Begin Sequence

		lRet := .F.

		If Len(aHeader) == 0
			Break
		Endif

		If Len(aCols) == 0
			Break
		Endif

		If !( existField("D4_ZZQTORI") ) 
			Break
		Endif

		If !( existField("D4_QUANT") ) 
			Break
		Endif

		lRet := .T.

	End Sequence

Return lRet

/*
	Verifica se existe o campo
*/
Static Function existField(cField)
	Local lRet := .F.

	If aScan(aHeader,{|x|rTrim(x[2])==cField})  > 0
		lRet := .T.
	Endif

Return lRet
