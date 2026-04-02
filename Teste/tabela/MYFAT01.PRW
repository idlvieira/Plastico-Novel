#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "ap5mail.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYFAT01  ºAutor  ³ NEWTON RECA ALVES  º Data ³  31/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o saldo do ultimo fechamento e traz para a tela    º±±
±±º          ³ de orcamento para consulta.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

*/


User Function MYFAT01()


_cAlias		:= Alias()     // Mantem o Alias corrente
_nIndex		:= IndexOrd()  // Mantem o Indice corrente
_nReg		:= RecNo()     // Mantem o Registro corrente   

DBSelectarea("SUB")

_cAliasSUB		:= Alias()     // Mantem o Alias corrente
_nIndexSUB		:= IndexOrd()  // Mantem o Indice corrente
_nRegSUB		:= RecNo()     // Mantem o Registro corrente   


_nOrcamento	:= SUA->UA_NUM

//ALERT(_nOrcamento)
//_nItem		:= SUA->UA_ITEM


DBSelectarea("SUB")
DBSetOrder(1)
DBSeek(xFilial("SUB")+_nOrcamento)
While !eof() .and. SUB->UB_NUM==_nOrcamento 

	//ALERT(STR(RECNO()))

	_nCodigo	:= SUB->UB_PRODUTO
	_nLocal		:= SUB->UB_LOCAL
	_nValor		:= SUB->UB_VRUNIT
	
	//_cTabela	:=  Posicione("SA1",1,xFilial("SA1")+SA1->A1_COD,"A1_TABELA")
	//_nPreco		:= Posicione("DA1",1,xFilial("DA1")+_cTabela+aCols[N,_nCodigo],"DA1_PRCVEN") 
	
	If SA1->A1_EST # ('AC','AL','AM','AP','BA','CE','DF','ES','GO','MA','MS','MT','PA','PB','PE','PI','RN','RO','RR','SE','TO')
		_nValorFim	:=  _nValor * 0.8375
	ElseIf SA1->A1_EST # ('MG','PR','RJ','RS','SC')
		_nValorFim	:=  _nValor * 0.7875
	Else
		_nValorFim	:=  _nValor * 0.7275
	EndIf
	
	//_cLocal		:= UB_LOCAL
	
	
	
	/*
	_cEmpresa	:= "SB9" + substr(CNUMEMP,1,2) + "0"
	cQuery1		:= " SELECT B9_CM1 FROM "+_cEmpresa+" WHERE "+_cEmpresa+".R_E_C_N_O_=  "
	cQuery1		+= " (SELECT MAX(R_E_C_N_O_) FROM "+_cEmpresa+" WHERE "+_cEmpresa+".D_E_L_E_T_<>'*' AND B9_COD='"+_nCodigo+"' AND B9_LOCAL='"+_nLocal+"' AND B9_CM1>0) "
	TCQUERY cQuery1 NEW ALIAS "_query1"
	Tcsqlexec(cQuery1)
	DBSelectArea("_query1")
	//_nSaldo		:= 1 - ( _nValorFim / _query1->B9_CM1 )  
	
	*/
	_ntemp		:= Posicione("SB1",1,xFilial("SB1")+_nCodigo,"B1_CUSTD")
	_nSaldo		:= ( _nValorFim - _ntemp ) / _nValorFim * 100
	
	
	//ALERT(STR(_nValor))
	//ALERT(SA1->A1_EST)
	//ALERT(STR(_query1->B9_CM1))
	//ALERT(STR(_nSaldo))
	
	
	//DBCloseArea()
	
	
	DBSelectarea("SUB")
	RecLock("SUB",.F.)
	SUB->UB_MYMARGE	:= _nSaldo
	MsUnLock()                
	
	DBSkip()

EndDo




DBSelectArea(_cAliasSUB)  // Volta o Alias corrente
DBSetOrder(_nIndexSUB)    // Volta o Indice corrente
DBGoTo(_nRegSUB)         // Volta o Registro corrente
	
DBSelectArea(_cAlias)  // Volta o Alias corrente
DBSetOrder(_nIndex)    // Volta o Indice corrente
DBGoTo(_nReg)         // Volta o Registro corrente






Return 









