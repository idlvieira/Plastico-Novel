#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT100LOK  บAutor  ณMarcelo Leme   บ Data ณ  08/08/08        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para verificar se o produto ja 			  บฑฑ
ฑฑ             fora lan็ado na tabela de preco							  บฑฑ
ฑฑ           ณ Se ZZ_DUPPRO = .T. ้ permitido o uso de faixas 			  บฑฑ
ฑฑ             (repeticao de produtos)   								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAOMS - OMS010 ( Tabela de Pre็o )                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function OM010LOK()

Local lDupPro   := getMV("ZZ_DUPPRO")
Local nPosProd  := aScan(aHeader,{|x| AllTrim(x[2])=="DA1_CODPRO"})
Local nPosTab   := aScan(aHeader,{|x| AllTrim(x[2])=="DA1_CODTAB"})
Local nUsado    := Len(aHeader)
Local ni        := 1     
Local ny        := 0
Local lRet      := .T.

If !lDupPro
	For ny := 1 To Len(aCols)
		If ny <> N .And. !aCols[ny][nUsado+1]		
			If ( nPosProd == 0 .Or. aCols[ny][nPosProd] == aCols[N][nPosProd])
               Alert("Produto lan็ado na tabela de pre็o")
			   lRet := .F.
			EndIf
		EndIf
	Next ny
Endif	     
Return lRet
