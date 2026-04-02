#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT103FIN   บAutor  ณLeandro Ferreira   บ Data ณ  25/05/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE VALIDAวรO DA DATA DA DUPLICATA                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User FuncTion MT103FIN()
	Local aLocHead := PARAMIXB[1] // aHeader do getdados apresentado no folter Financeiro.
	Local aLocCols := PARAMIXB[2] // aCols do getdados apresentado no folter Financeiro.
	Local lLocRet  := PARAMIXB[3] // Flag de valida็๕es anteriores padr๕es do sistema.
	// Caso este flag esteja como .T., todas as valida็๕es
	// anteriores foram aceitas com sucesso, no contrแrio, .F.
	// indica que alguma valida็ใo anterior NรO foi aceita.
	//aCols[1][GDFieldPos("D1_TES")] 
	cTes := posicione("SF4",1,xFilial("SF4")+aCols[1][GDFieldPos("D1_TES")],"F4_DUPLIC")
	If aLocCols[1][2] < date() .And. cTes == "S"
		Alert('Somente serแ permitido notas fiscais com datas de vencimento maiores ou iguais เ data atual') 
		lLocRet := .F.
	EndIf
Return(lLocRet)
