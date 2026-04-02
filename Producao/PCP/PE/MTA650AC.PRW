#Include "rwmake.ch"
#include 'protheus.ch'
#include 'parmtype.ch'
#Include "topconn.ch"
#Include "MsObject.ch"
#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MTA650AC.prw    | Autor : Leandro Ferreira      | Data : 29/04/2020|\
/|-------------------------------------------------------------------------------|\
/| Descricao: PE antes da tela de alteração em Empenho para incluir o campo      |\
/|            D4_ZZQTORI														 |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante       Motivo
// 29/04/2020  Leandro Ferreira          Giuliano Olivetti Unificação do apontamento     

USER FUNCTION MTA650AC ()
	local aArray := {}
	//Alert("MTA650AC")
	aadd(aArray,{"ZZQTORI", "D4_ZZQTORI", "@E 9,999,999.9999", TamSX3("D4_ZZQTORI")[1],TamSX3("D4_ZZQTORI")[2], "", .T., "N", "", " "})
	aadd(aArray,"SD4->D4_ZZQTORI")
RETURN aArray
