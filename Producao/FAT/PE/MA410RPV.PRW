/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MA410RPV.prw               | Autor : Leandro O Ferreira            |\
/|-------------------------------------------------------------------------------|\
/| Data     : 09/11/2022                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Inibe valores de rentabilidade de pedido 						     |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 09/11/2022  Leandro Ferreira          Gabriel Ramos   Camila solicitou a remoção dos valores  

User Function MA410RPV() 
	Local aValores  := PARAMIXB
	Local x 		:= 0

	For x := 1 to len(PARAMIXB)
		aValores[x][2] := 0
		aValores[x][3] := 0
		aValores[x][4] := 0
		aValores[x][5] := 0
		aValores[x][6] := 0
	Next x
Return aValores


