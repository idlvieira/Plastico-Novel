#include "rwmake.ch"     

User Function MTA450I(cParam)
// Ponto de entrada para gravar a data de liberação de credito C5_NOVULT.
                              
// Grava a posicao do arquivo, Indice e registro atual
_cAlias := SELECT()
_cOrd   := INDEXORD()
_cReg   := RECNO()
                                          
cBlCred := SC9->C9_BLCRED
cBlEst  := SC9->C9_BLEST
If  Empty(cBlCred)
    If Empty(cBlEst)
       RecLock("SC9",.F.)
       SC9->C9_BLEST := "02"
       msUnLock()
       dbSelectArea("SB2")
       DbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL, .T.)
       If Found().AND. B2_COD=SC9->C9_PRODUTO
          Reclock("SB2",.F.)
          B2_RESERVA:=B2_RESERVA-SC9->C9_QTDLIB
          B2_QPEDVEN:=B2_QPEDVEN+SC9->C9_QTDLIB
          Dbunlock()     
       Endif
    Endif 
	cPedido  := SC9->C9_PEDIDO
    dbSelectArea("SC5")
    dbSetOrder(1) 
    dbSeek(xFilial("SC5")+SC9->C9_PEDIDO,.F.)	
    If Found() .and. Empty(SC5->C5_NOVULT)
	   dbSelectArea("SC5")
	   RecLock("SC5",.F.)
	   SC5->C5_NOVULT := dDataBase
	   msUnLock()
       dbSelectArea("SC6")
       dbSetOrder(1) // numero+item+produto
       dbSeek(xFilial("SC6")+SC5->C5_NUM,.T.)
       While !EOF() .and. SC6->C6_NUM = SC5->C5_NUM
          If C6_ENTREG<DATE()
             RecLock("SC6",.F.)
             SC6->C6_ENTREG := DATE()
             msUnLock()
          Endif
          dbSkip()
       Enddo
	Endif
Endif

// Retorna a posição de arquivo, indice e registro.
DbSelectArea(_cAlias)
DbSetOrder(_cOrd)
DbGoto(_cReg)

Return(nil) 