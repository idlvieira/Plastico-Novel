#Include "rwmake.ch"
#include 'protheus.ch'
#include 'parmtype.ch'
#Include "topconn.ch"
#Include "MsObject.ch"
#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : A650ADCOL.prw    | Autor : Leandro Ferreira    | Data : 29/04/2020 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: PE antes da tela de alteraчуo em Empenho para copiar a quantidade  |\
/|            original da OP (D4_QUANT) para o campo D4_ZZQTORI 				 |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante       Motivo
// 29/04/2020  Leandro Ferreira          Giuliano Olivetti Unificaчуo do apontamento     

User Function A650ADCOL() 
	Local lRet := .T.
	//msgstop("A650ADCOL > "+CNUMOP+CITEMOP+CSEQC2 + " >< " + cValToChar(len(aCols)))//saindo da tela de geraчуo de OP 02 RODA NOVAMENTE APгS O MA650EMP
	n := len(aCols)
	aCols[n][18] = aCols[n][2]
Return Nil
