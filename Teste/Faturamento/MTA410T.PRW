#INCLUDE "rwmake.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³MTA410T   º Autor ³ Elisangela Souza   º Data ³  25/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para gravar a condicao de pagamento na    º±±
±±º          ³ tabela de itens liberados.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function MTA410T()

// Grava a posicao do arquivo, Indice e registro atual
_cAlias := SELECT()
_cOrd   := INDEXORD()
_cReg   := RECNO()                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                
If Upper(FUNNAME())=="MATA440"

	_cCondPag := ""
                           
	dbSelectArea("SC9")
	dbSetOrder(1)	
	                       	
	dbSelectArea("SE4")
	dbSetOrder(1)
	SE4->( DbSeek(xFilial("SE4")+SC5->C5_CONDPAG,.F.) )

	If SE4->( Found() )
		_cCondPag := SE4->E4_DESCRI
	Endif
                           
    SC9->( DbSeek(xFilial()+SC5->C5_NUM,.T.) )
    
	While SC9->( !Eof() ) .And. SC9->C9_PEDIDO = SC5->C5_NUM

		dbSelectArea("SC9")
		RecLock("SC9",.F.)

		SC9->C9_CONDPAG	:= SC5->C5_CONDPAG
		SC9->C9_DESCCP	:= _cCondPag 
		msUnlock()	    
		
    	SC9->( DbSkip() )
    Enddo
    	
Endif
           
// Retorna a posição de arquivo, indice e registro.
DbSelectArea(_cAlias)
DbSetOrder(_cOrd)
DbGoto(_cReg)

Return