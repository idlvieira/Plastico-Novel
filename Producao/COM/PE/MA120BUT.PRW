/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MA120BUT.prw               | Autor : Leandro O Ferreira            |\
/|-------------------------------------------------------------------------------|\
/| Data     : 08/11/2020                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Visualização de todos os dados da SCR							     |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 08/11/2020  Leandro Ferreira          Paulo Sobrinho  Inclusão de hora de aprov.  

User Function MA120BUT() 
	Local aButtons := {} 
	// Botoes a adicionar
	aadd(aButtons,{'BUDGETY',{|| U_cMA120BUT()},'Consulta Aprovacao','Aprov Novel'}) 
Return (aButtons )


User Function cMA120BUT() 
	Private _cWHERE	 	:= "CR_NUM =  '" + cValtoChar(CA120NUM) + "' AND CR_FILIAL = '" + cValtoChar(CFILANT) + "' "
	PRIVATE cCadastro := "Aprovadores do Pedido"

	dbSelectArea("SCR")
	DBSETORDER(1)
	DBGOTOP()
	MBROWSE( 6,1,22,75,"SCR",,,,,,,,,,,.F.,,,_cWHERE)
Return
