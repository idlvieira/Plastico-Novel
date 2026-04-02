#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MA330TRB.prw               | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 07/11/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: PONTO DE ENTRADA: Manipulação deste arquivo antes do processamento |\
/|                                                                               |\ 
/|OBSERVACAO: Efetuado ordenação conform necessidade logica                      |\ 
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */

User Function MA330TRB()

  Local _aAreaAtu := GetArea()
  Local _aAreaTRB := TRB->(GetArea())
  Local _aAreaSB1 := SB1->(GetArea())

  MsAguarde( {|| AjusNiv() },"MA330TRB","Ajustando os níveis regras Novel")

  RestArea(_aAreaSB1)
  RestArea(_aAreaTRB)
  RestArea(_aAreaAtu)
	
Return()

*Funcao******************************************************************************************************************************

Static Function AjusNiv()

  Local cOrdNovel, cNvlNovel, cND3Novel, lOrdNovel

  DbSelectArea("TRB")
  DbSetOrder(0)
  DbGoTop()
  
  While TRB->(!Eof())
    ProcRegua(LastRec())
		
    lOrdNovel := .F.  
    cOrdNovel := TRB->TRB_ORDEM
    cNvlNovel := TRB->TRB_NIVEL
    cND3Novel := TRB->TRB_NIVSD3

	If substr(TRB->TRB_CF,1,3) = "DE0"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "300" })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE1"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "300" })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE2"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "300" })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE3"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "300" })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE4"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "300" })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE5"
      Eval({ || lOrdNovel := .F. })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE6"
      Eval({ || lOrdNovel := .F. })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE7"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "300" })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE8"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "300" })
	ElseIf substr(TRB->TRB_CF,1,3) = "DE9"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "300" })
	EndIf
	
	If substr(TRB->TRB_CF,1,3) = "RE0"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "301" })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE1"
      Eval({ || lOrdNovel := .F. })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE2"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "301" })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE3"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "301" })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE4"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "310" })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE5"
      Eval({ || lOrdNovel := .F. })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE6"
      Eval({ || lOrdNovel := .F. })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE7"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "310" })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE8"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "301" })
    ElseIf substr(TRB->TRB_CF,1,3) = "RE9"
      Eval({ || lOrdNovel := .T. , cOrdNovel := "301" })
	EndIf
	
	If substr(TRB->TRB_CF,1,3) = "PR0" 
            Eval({ || lOrdNovel := .F. })
	EndIf

	If lOrdNovel
      Reclock("TRB",.F.)
        REPLACE TRB->TRB_ORDEM WITH cOrdNovel
        REPLACE TRB->TRB_NIVEL WITH cNvlNovel
        REPLACE TRB->TRB_NIVSD3 WITH cND3Novel
      MSUnlock()		
	EndIf  
		
  dbSelectArea('TRB')
  DbSkip()	
  EndDo
   
Return
