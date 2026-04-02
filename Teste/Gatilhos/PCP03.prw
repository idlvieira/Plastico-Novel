 #include "rwmake.ch"

USER FUNCTION PCP03()

//----------------------------------------------------------------------------
//|Programa  | PCP01       | Autor | Eliene Cerqueira    |Criado| 21.Fev.2006|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo D3_QUANT - Verifica se maior que saldo da OP |
//----------------------------------------------------------------------------
//|Uso       | SIGAPCP                                                       |
//----------------------------------------------------------------------------

mQt:=M->D3_QUANT
mcOP:=M->D3_OP  

DbSelectArea("SC2")
mSaldo:=C2_QUANT-C2_QUJE-C2_PERDA
If FunName() == "MATA250"
   IncremOP2()
Endif

Return(mQt) 

Static Function IncremOP2()
   QTDPROP  := SC2->C2_QUANT - SC2->C2_QUJE   
   RecLock("SC2",.F.)
   MsUnLock()
   DbSelectArea("SD4")
   DbSetOrder(2)
   SD4->( DbSeek(xFilial()+mcOP,.F. ) ) 
   WHILE !EOF() .and. SD4->D4_OP = mcOP
     RecLock("SD4",.F.)
     qtdnece := (mqt*sd4->d4_quant)/QTDPROP
     MsUnLock() 
     DbSelectArea("SB2")
	 DbSetOrder(1)
	 SB2->( DbSeek(xFilial()+SD4->D4_COD+SD4->D4_LOCAL,.T. ) )      
     IF SB2->B2_QATU < qtdnece .and. substring(sd4->d4_cod,1,3) <> "MOD"
         mdispcod := sd4->d4_cod
         mdispsaldo := sb2->b2_qatu
         mdispnece := qtdnece 
         dispdif := mdispsaldo - mdispnece
         Mostra1()
         mQt := 0 
     endif
     SD4->( DbSkip() )
   Enddo
Return                 


Static Function Mostra1()
*********************

@ 0,0 TO 190,430 DIALOG oDlg5 TITLE "Saldos em Estoque"
@ 3,5 TO 80,210
@ 15,10 say "Produto          :  " + mdispcod
@ 25,10 SAY "Saldo Disponivel : " + Transform(mdispsaldo,"@E 999,999.99")
@ 35,10 SAY "Saldo Necessario : " + Transform(mdispnece,"@E 999,999.99")
@ 45,10 SAY "Diferença        : " + Transform(dispdif,"@E 999,999.99")  
@ 60,20 SAY "CANCELE ESTA OPERAÇÃO, E ACERTE O SALDO DO PRODUTO!!!"
@ 80,100 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5 CENTER

Return