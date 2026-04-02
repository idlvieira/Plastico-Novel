#INCLUDE "rwmake.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ MT250EST ³ Autor ³ Eliene Cerqueira    ³Criado³ 06.Mar.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada executado na opção de estorno da movimen- ³±±
±±³          ³ tação interna.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAPCP / SIGAEST                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Arquivos Relacionados³ SB2/SD3                                         ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/                       


User Function MT250EST() 

Return
                         
cAlias := Alias()
nOrd   := dbSetOrder()
nReg   := Recno()
     
If Upper(FUNNAME())=="MATA250" // Apontamento Produção
   cOP      := SD3->D3_OP 
   cEmissao := SD3->D3_EMISSAO
   nPerda   := SD3->D3_PERDAS
   cCodS    := SD3->D3_CODS
   nBorra   := SD3->D3_PERDAB
   cCodB    := SD3->D3_CODB 
   cCod     := SD3->D3_COD 
  // If nPerda > 0 .and. !Empty(cCodS)
      Perda()
  // Endif
Endif
      
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

Return .T.

Static Function Perda()
    
    cNumSeq:=Space(6)
    SB1->( DbSeek(xFilial()+cCod,.T. ) ) 
	PESO := SB1->B1_PESO
	Begin Transaction
  		                                    
	  DbSelectArea("SD3")
	  DbSetOrder(1)                                          
	  SD3->( DbSeek(xFilial()+cOP+cCodS,.T. ) ) 	                 
	  WHILE !EOF() .and. SD3->D3_OP = cOP .and. (SD3->D3_CODS = cCodS .OR. SD3->D3_CODB = cCODB)
        If SD3->D3_EMISSAO = cEmissao .and. SD3->D3_TM = "499" .and. SD3->D3_CF = "DE4"
           cNumSeq:=SD3->D3_NUMSEQ
        Endif
	    SD3->( DbSkip() )
      Enddo   
      
      If cNumSeq <> Space(6)
  	     DbSetOrder(4)
	     SD3->( DbSeek(xFilial()+cNumSeq,.T. ) ) 
         WHILE !EOF() .and. SD3->D3_NUMSEQ = cNumSeq
           If SD3->D3_OCORR = "PERDA" .or. SD3->D3_OCORR = "BORRA"
  	          DbSelectArea("SB2")
	          DbSetOrder(1)
  	          SB2->( DbSeek(xFilial()+SD3->D3_COD,.T. ) ) 
              RecLock("SB2",.F.)
              If SD3->D3_OCORR = "PERDA"
                 If SD3->D3_TM = "499"
                  SB2->B2_QATU := SB2->B2_QATU - SD3->D3_QUANT
                 Else
                    SB2->B2_QATU := SB2->B2_QATU + SD3->D3_QUANT   
                 Endif
              Else
                 If SD3->D3_TM = "499"
                    SB2->B2_QATU := SB2->B2_QATU - SD3->D3_QUANT
                 Else
                   SB2->B2_QATU := SB2->B2_QATU + SD3->D3_QUANT
                Endif
              Endif
              MsUnLock()
	          DbSelectArea("SD3")
		      SD3->(RECLOCK("SD3",.F.))
		      SD3->(DBDELETE())
              SD3->(MSUNLOCK())
           Endif
	       SD3->( DbSkip() )
         Enddo
      Else
       	 MSGBOX("Não foi possível excluir a perda. Contacte o administrador.")
      Endif
	End Transaction
Return

