#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "ap5mail.ch"       



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYFAT02  ºAutor  ³ NEWTON RECA ALVES  º Data ³  31/10/12   º±±
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


User Function MYFAT02()


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


_nDesc		:= 0


DBSelectarea("SUB")
DBSetOrder(1)
DBSeek(xFilial("SUB")+_nOrcamento)
IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA" 
   

		_nDesc		:= SUB->UB_DESCME
		_nDescA		:= SUB->UB_DESCME
	Else
		_nDesc		:= SUB->UB_DESC
		_nDescA		:= SUB->UB_DESC
EndIf                             


_nCodigo	:= SUB->UB_PRODUTO
_cGrupo		:= Posicione("SB1",1,xFilial("SB1")+_nCodigo,"B1_CTITEM1")

While !eof() .and. SUB->UB_NUM==_nOrcamento 

	_nCodigo	:= SUB->UB_PRODUTO
	_nLocal		:= SUB->UB_LOCAL

    DbSelectArea("SA1")
   	IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA" 
		_nDescA		:= SUB->UB_DESCME
	Else
		_nDescA		:= SUB->UB_DESC
	EndIf
	
   DBSelectarea("SUB") 
	
	//_nPreco		:= Posicione("DA1",1,xFilial("DA1")+_cTabela+aCols[N,_nCodigo],"DA1_PRCVEN") 

 ///   _cGrupo		:= Posicione("SB1",1,xFilial("SB1")+_nCodigo,"B1_SUBGRUP")
    
	//EPI
//	If TRIM(_cGrupo)=="02" .or. TRIM(_cGrupo)=="03"
//		_nDescA	:= _nDescA + 0.74
//	Else
///		_nDescA	:= _nDescA - 0.24
//	EndIf	
    
    If _nDescA >= _nDesc
    	_nDesc	:= _nDescA  
    	_cGrupo		:= Posicione("SB1",1,xFilial("SB1")+_nCodigo,"B1_SUBGRUP")
    EndIf

	
	DBSkip()

	
EndDo



If TRIM(_cGrupo)=="02" .or. TRIM(_cGrupo)=="03"          //+074

    
	If _nDesc >= GetMv("MV_MYLMC06") .and. _nDesc <= GetMv("MV_MYLMC07")
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC01")
		MsUnLock()                
	ElseIf _nDesc > GetMv("MV_MYLMC07") .and. _nDesc <= GetMv("MV_MYLMC08")
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC02")
		MsUnLock()                
	ElseIf _nDesc > GetMv("MV_MYLMC08") .and. _nDesc <= GetMv("MV_MYLMC09")
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC03")
		MsUnLock()                
	ElseIf _nDesc > GetMv("MV_MYLMC09") .and. _nDesc <= GetMv("MV_MYLMC10")
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC04")
		MsUnLock()                
	Else
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC05")
		MsUnLock()                
	EndIf
ELSE     
                                                                // 0.24
	If _nDesc >= GetMv("MV_MYLMC11") .and. _nDesc <= GetMv("MV_MYLMC12")
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC01")
		MsUnLock()                
	ElseIf _nDesc > GetMv("MV_MYLMC12") .and. _nDesc <= GetMv("MV_MYLMC13")
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC02")
		MsUnLock()                
	ElseIf _nDesc > GetMv("MV_MYLMC13") .and. _nDesc <= GetMv("MV_MYLMC14")
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC03")
		MsUnLock()                
	ElseIf _nDesc > GetMv("MV_MYLMC14") .and. _nDesc <= GetMv("MV_MYLMC15")
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC04")
		MsUnLock()                
	Else
		DBSelectarea("SUA")
		RecLock("SUA",.F.)
		SUA->UA_MYAPROV	:= GetMv("MV_MYAPC05")
		MsUnLock()                
	EndIf

endif


DBSelectArea(_cAliasSUB)  // Volta o Alias corrente
DBSetOrder(_nIndexSUB)    // Volta o Indice corrente
DBGoTo(_nRegSUB)         // Volta o Registro corrente
	
DBSelectArea(_cAlias)  // Volta o Alias corrente
DBSetOrder(_nIndex)    // Volta o Indice corrente
DBGoTo(_nReg)         // Volta o Registro corrente



Return 









