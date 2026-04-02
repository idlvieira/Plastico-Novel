#include "rwmake.ch"      

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ MT250TOK ³ Autor ³ Eliene Cerqueira    ³Criado³ 03.Mar.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada executado na opção de incluir da produção ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAPCP / SIGAEST                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Arquivos Relacionados³ SB1/SD3/SD4                                     ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function MT250TOK()  

return 

SetPrvt("_AAREA,_AAREASD3,_aAreaSB1,_aAreaSZA,")          // TESTAR NO PONTO MT250TOK e VER COMO ESTORNAR ESTA PERDA

//--Salva Areas de Trabalho
_aArea    := {}
_aAreaSD3 := {}
_aAreaSB1 := {}
_aAreaSB2 := {}
_aAreaSD4 := {}

_aArea    := GetArea()
_aAreaSB1 := SB1->(GetArea())
_aAreaSB2 := SB2->(GetArea())
_aAreaSD3 := SD3->(GetArea())
_aAreaSD4 := SD4->(GetArea())
lFlag     := .T.

// Internos
If Upper(FUNNAME())=="MATA250" // Apontamento Produção
    DbSelectArea("SC2")
    QTDEOP   := C2_QUANT
	cLote	 := M->D3_LOTECTL
	cOP      := M->D3_OP
	cCC      := M->D3_CC
    cLocal   := M->D3_LOCAL
    cEmissao := M->D3_EMISSAO
	nPerda   := M->D3_PERDAS
	cCodS    := M->D3_CODS
	nBorra   := M->D3_PERDAB
	cCodB    := M->D3_CODB
	cCod     := M->D3_COD
    DbSelectArea("SD3")
    DbSetOrder(4)
    dbGoBottom()
    cNumSeq:=STRZERO(VAL(D3_NUMSEQ)+1,6)
    cIdent:=STRZERO(VAL(D3_NUMSEQ)+2,6)
	If nPerda > 0 .and. !Empty(cCodS)
       Perda()
    Endif
	If nBorra > 0 .and. !Empty(cCodB)
       Borra()
    Endif
Endif
                      
RestArea(_aAreaSB1)
RestArea(_aAreaSB2)
RestArea(_aAreaSD3)
RestArea(_aAreaSD4)
RestArea(_aArea)

Return ()

Static Function Perda()
    
	Begin Transaction      
			
	  DbSetOrder(1)
  	  DbSelectArea("SB1")
	  DbSetOrder(1)
	  SB1->( DbSeek(xFilial()+cCod,.T. ) ) 
	  PESO := SB1->B1_PESO
	  SB1->( DbSeek(xFilial()+cCodS,.T. ) ) 
	  DbSelectArea("SB2")
	  DbSetOrder(1)
	  SB2->( DbSeek(xFilial()+cCodS+SB1->B1_LOCPAD,.T. ) ) 

      RecLock("SD3",.T.)
	  SD3->D3_FILIAL   := xFilial("SD3")
      SD3->D3_TM       := "499"
      SD3->D3_OP       := cOP
      SD3->D3_COD      := cCodS
      SD3->D3_CODS     := cCodS
      SD3->D3_UM       := SB1->B1_UM
      SD3->D3_QUANT    := nPerda * PESO
      SD3->D3_CF       := "DE4"
      //SD3->D3_LOCAL    := cLocal 
      SD3->D3_LOCAL    := SB1->B1_LOCPAD 
      SD3->D3_CONTA    := SB1->B1_CONTA
      SD3->D3_EMISSAO  := cEmissao
      SD3->D3_GRUPO    := SB1->B1_GRUPO
      SD3->D3_CUSTO1   := nPerda * PESO * SB2->B2_CM1
      SD3->D3_CUSTO2   := nPerda * PESO * SB2->B2_CM2
      SD3->D3_CUSTO3   := nPerda * PESO * SB2->B2_CM3
      SD3->D3_CUSTO4   := nPerda * PESO * SB2->B2_CM4
      SD3->D3_CUSTO5   := nPerda * PESO * SB2->B2_CM5
      SD3->D3_CC       := cCC
      SD3->D3_NUMSEQ   := cNumSeq
      SD3->D3_IDENT    := cIdent
      SD3->D3_TIPO     := SB1->B1_TIPO
      SD3->D3_USUARIO  := alltrim(substr(cusuario,7,15))
      SD3->D3_CHAVE    := "R0"
      SD3->D3_OCORR    := "PERDA"
	  MsUnLock()
      DbSelectArea("SB2")
      SB2->( DbSeek(xFilial()+cCodS+SB1->B1_LOCPAD,.T. ) ) 
      RecLock("SB2",.F.)
      SB2->B2_QATU := SB2->B2_QATU + (nPerda * PESO)
      MsUnLock()
                                                     
	  DbSelectArea("SD4")
	  DbSetOrder(2)
	  SD4->( DbSeek(xFilial()+cOP,.F. ) ) 
      WHILE !EOF() .and. SD4->D4_OP = cOP
  	    DbSelectArea("SB1")
	    SB1->( DbSeek(xFilial()+SD4->D4_COD,.T. ) ) 
	    If SB1->B1_TIPO="ME"
	       DbSelectArea("SD4")
		   SD4->( DbSkip() )
	       LOOP
 	    Endif
        QTDINS := (SD4->D4_QTDEORI / QTDEOP) * nPerda
  	    DbSelectArea("SB1")
	    DbSetOrder(1)
	    SB1->( DbSeek(xFilial()+SD4->D4_COD,.T. ) ) 
	    DbSelectArea("SB2")
	    DbSetOrder(1)
	    SB2->( DbSeek(xFilial()+SD4->D4_COD+SB1->B1_LOCPAD,.T. ) ) 
	    RecLock("SD3",.T.)
	    SD3->D3_FILIAL   := xFilial("SD3")
        SD3->D3_TM       := "999"
        SD3->D3_OP       := cOP
        SD3->D3_COD      := SD4->D4_COD
        SD3->D3_UM       := SB1->B1_UM
        SD3->D3_QUANT    := QTDINS
        SD3->D3_CF       := "RE4"
       // SD3->D3_LOCAL    := cLocal
        SD3->D3_LOCAL    := SB1->B1_LOCPAD
        SD3->D3_CONTA    := SB1->B1_CONTA
        SD3->D3_EMISSAO  := cEmissao
        SD3->D3_GRUPO    := SB1->B1_GRUPO
        SD3->D3_CUSTO1   := QTDINS * SB2->B2_CM1
        SD3->D3_CUSTO2   := QTDINS * SB2->B2_CM2
        SD3->D3_CUSTO3   := QTDINS * SB2->B2_CM3
        SD3->D3_CUSTO4   := QTDINS * SB2->B2_CM4
        SD3->D3_CUSTO5   := QTDINS * SB2->B2_CM5
        SD3->D3_CC       := cCC
        SD3->D3_NUMSEQ   := cNumSeq
        SD3->D3_IDENT    := cIdent
        SD3->D3_TIPO     := SB1->B1_TIPO
        SD3->D3_USUARIO  := alltrim(substr(cusuario,7,15))
        SD3->D3_CHAVE    := "E0"
        SD3->D3_OCORR    := "PERDA"
        MsUnLock()
  	    DbSelectArea("SB2")
	    SB2->( DbSeek(xFilial()+SD4->D4_COD+SB1->B1_LOCPAD,.T. ) ) 
	    RecLock("SB2",.F.)
	    SB2->B2_QATU := SB2->B2_QATU - QTDINS
	    MsUnLock()
        DbSelectArea("SD4")
	    SD4->( DbSkip() )
      Enddo
	End Transaction
Return

Static Function Borra()
    
	Begin Transaction
	  DbSetOrder(1)
  	  DbSelectArea("SB1")
	  DbSetOrder(1)
	  SB1->( DbSeek(xFilial()+cCod,.T. ) ) 
	  PESO := SB1->B1_PESO
	  SB1->( DbSeek(xFilial()+cCodB,.T. ) ) 
	  DbSelectArea("SB2")
	  DbSetOrder(1)
	  SB2->( DbSeek(xFilial()+cCodB+SB1->B1_LOCPAD,.T. ) ) 

      RecLock("SD3",.T.)
	  SD3->D3_FILIAL   := xFilial("SD3")
      SD3->D3_TM       := "499"
      SD3->D3_OP       := cOP
      SD3->D3_COD      := cCodB
      SD3->D3_CODB     := cCodB
      SD3->D3_UM       := SB1->B1_UM
      SD3->D3_QUANT    := nBorra
      SD3->D3_CF       := "DE4"
      // SD3->D3_LOCAL    := cLocal
      SD3->D3_LOCAL    := SB1->B1_LOCPAD
      SD3->D3_CONTA    := SB1->B1_CONTA
      SD3->D3_EMISSAO  := cEmissao
      SD3->D3_GRUPO    := SB1->B1_GRUPO
      SD3->D3_CUSTO1   := nBorra * PESO * SB2->B2_CM1
      SD3->D3_CUSTO2   := nBorra * PESO * SB2->B2_CM2
      SD3->D3_CUSTO3   := nBorra * PESO * SB2->B2_CM3
      SD3->D3_CUSTO4   := nBorra * PESO * SB2->B2_CM4
      SD3->D3_CUSTO5   := nBorra * PESO * SB2->B2_CM5
      SD3->D3_CC       := cCC
      SD3->D3_NUMSEQ   := cNumSeq
      SD3->D3_IDENT    := cIdent
      SD3->D3_TIPO     := SB1->B1_TIPO
      SD3->D3_USUARIO  := alltrim(substr(cusuario,7,15))
      SD3->D3_CHAVE    := "R0"
      SD3->D3_OCORR    := "BORRA"
	  MsUnLock()
      DbSelectArea("SB2")
      SB2->( DbSeek(xFilial()+cCodB+SB1->B1_LOCPAD,.T. ) ) 
      RecLock("SB2",.F.)
      SB2->B2_QATU := SB2->B2_QATU + nBorra
      MsUnLock()
                                                     
	  DbSelectArea("SD4")
	  DbSetOrder(2)
	  SD4->( DbSeek(xFilial()+cOP,.F. ) ) 
      WHILE !EOF() .and. SD4->D4_OP = cOP
  	    DbSelectArea("SB1")
	    SB1->( DbSeek(xFilial()+SD4->D4_COD,.T. ) ) 
	    If SB1->B1_TIPO="ME"
	       DbSelectArea("SD4")
		   SD4->( DbSkip() )
	       LOOP
 	    Endif
        QTDINS := (SD4->D4_QTDEORI / QTDEOP) * (nBorra / PESO)
  	    DbSelectArea("SB1")
	    DbSetOrder(1)
	    SB1->( DbSeek(xFilial()+SD4->D4_COD,.T. ) ) 
	    DbSelectArea("SB2")
	    DbSetOrder(1)
	    SB2->( DbSeek(xFilial()+SD4->D4_COD+SB1->B1_LOCPAD,.T. ) ) 
	    RecLock("SD3",.T.)
	    SD3->D3_FILIAL   := xFilial("SD3")
        SD3->D3_TM       := "999"
        SD3->D3_OP       := cOP
        SD3->D3_COD      := SD4->D4_COD
        SD3->D3_UM       := SB1->B1_UM
        SD3->D3_QUANT    := QTDINS
        SD3->D3_CF       := "RE4"
       // SD3->D3_LOCAL    := cLocal
        SD3->D3_LOCAL    := SB1->B1_LOCPAD
        SD3->D3_CONTA    := SB1->B1_CONTA
        SD3->D3_EMISSAO  := cEmissao
        SD3->D3_GRUPO    := SB1->B1_GRUPO
        SD3->D3_CUSTO1   := QTDINS * SB2->B2_CM1
        SD3->D3_CUSTO2   := QTDINS * SB2->B2_CM2
        SD3->D3_CUSTO3   := QTDINS * SB2->B2_CM3
        SD3->D3_CUSTO4   := QTDINS * SB2->B2_CM4
        SD3->D3_CUSTO5   := QTDINS * SB2->B2_CM5
        SD3->D3_CC       := cCC
        SD3->D3_NUMSEQ   := cNumSeq
        SD3->D3_IDENT    := cIdent
        SD3->D3_TIPO     := SB1->B1_TIPO
        SD3->D3_USUARIO  := alltrim(substr(cusuario,7,15))
        SD3->D3_CHAVE    := "E0"
        SD3->D3_OCORR    := "BORRA"
        MsUnLock()
  	    DbSelectArea("SB2")
	    SB2->( DbSeek(xFilial()+SD4->D4_COD+SB1->B1_LOCPAD,.T. ) ) 
	    RecLock("SB2",.F.)
	    SB2->B2_QATU := SB2->B2_QATU - QTDINS
	    MsUnLock()
        DbSelectArea("SD4")
	    SD4->( DbSkip() )
      Enddo
	End Transaction
Return

