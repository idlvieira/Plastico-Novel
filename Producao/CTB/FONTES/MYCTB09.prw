#Include "protheus.ch"

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYCTB09.prw    | Autor : Leonardo Bergamasco   | Data : 12/01/2016 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina customizada controle de Journal                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        


User Function MYCTB09()

  Local nOpc := 0
  Local lLoop := .T.
  
  While lLoop
    nOpc := Aviso("Controle de lançamento manual","Essa rotina gerencia o processo de lançamento manual em diversos processos. 1) Lançamento Manual; 2)",{"1","2","3","4"},3,"Novel")
    If nOpc > 0 .and. nOpc < 5
      If nOpc > 0 .and. nOpc < 2
        u_MYCTB10()
      ElseIf nOpc > 1 .and. nOpc < 3
        ALERT("2")      
      ElseIf nOpc > 2 .and. nOpc < 4
        ALERT("3") 
      ElseIf nOpc > 3 .and. nOpc < 5
        lLoop := .F.
      EndIf
    EndIf  
  EndDo

Return

