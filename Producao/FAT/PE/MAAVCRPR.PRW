#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MAAVCRPR.prw    | Autor : Leandro Ferreira     | Data : 15/01/2023 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Avaliação complementar de crédito de pedido de vendas              |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 09/11/2022  Leandro Ferreira          Gabriel Ramos   Bloqueio cond pag 50%   


/*
ParamIxb[1]=Código do cliente - 
ParamIxb[2]=Código da filial - 
ParamIxb[3]=Valor da venda - 
ParamIxb[4]=Moeda da venda - 
ParamIxb[5]=Considera acumulados de Pedido de Venda do SA1 - 
ParamIxb[6]=Tipo de crédito (“L” - Código cliente + Filial; “C” - código do cliente) - 
ParamIxb[7]=Indica se o credito será liberado ( Lógico ) - 
ParamIxb[8]=Indica o código de bloqueio do credito ( Caracter )
*/
User Function MAAVCRPR()

Local cClien	:= ParamIxb[1] 
Local cLojaCli 	:= PARAMIXB[2] 
Local lRet		:= PARAMIXB[7] 
Local cGrpNov	:= Posicione("SA1",1,xFilial("SA1")+cClien+cLojaCli,"A1_ZGRPNV")
Local cAntecip	:= ''

	/**libera intercompany**/
	If cGrpNov == '1'
		lRet := .T.
	Else 
		cAntecip := Posicione("SE4",1,xFilial("SE4")+C5_CONDPAG,"E4_ZANT")
		If cAntecip == '1'
			lRet := .F.
			MsgStop("Condição de pagamento antecipada, favor aguardar a liberação do departamento Financeiro", "Pagamento antecipado")
		EndIf
	ENDIF

Return lRet
