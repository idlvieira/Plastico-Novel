#include "rwmake.ch"

USER FUNCTION PCP01()

//----------------------------------------------------------------------------
//|Programa  | PCP01       | Autor | Eliene Cerqueira    |Criado| 21.Fev.2006|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo D3_QUANT - Verifica se maior que saldo da OP |
//----------------------------------------------------------------------------
//|Uso       | SIGAPCP                                                       |
//----------------------------------------------------------------------------

nQt:=M->D3_QUANT
cOP:=M->D3_OP
DbSelectArea("SC2")
Saldo:=C2_QUANT-C2_QUJE-C2_PERDA
If FunName() == "MATA250"
   If nQt > Saldo
   	  If MsgYesNo("Quantidade maior que o saldo! Confirma ?")
   	     IncremOP()
      Else
         nQt := 0
      Endif
   Endif
Endif

Return(nQt) 

// Incrementa a quantidade inicial da OP e dos insumos
Static Function IncremOP()
   QtdIns := nQT - Saldo
   QTDORIOP := SC2->C2_QUANT
   QTDPROP  := SC2->C2_QUJE
   RecLock("SC2",.F.)
   SC2->C2_QUANT := SC2->C2_QUANT + QtdIns
   MsUnLock()
   DbSelectArea("SD4")
   DbSetOrder(2)
   SD4->( DbSeek(xFilial()+cOP,.F. ) ) 
   WHILE !EOF() .and. SD4->D4_OP = cOP
     QTDESTR:=SD4->D4_QTDEORI / QTDORIOP
     RecLock("SD4",.F.)
     SD4->D4_QTDEORI := QTDESTR * SC2->C2_QUANT
     SD4->D4_QUANT   := SD4->D4_QTDEORI - (QTDPROP * QTDESTR)
     MsUnLock()
     SD4->( DbSkip() )
   Enddo
Return