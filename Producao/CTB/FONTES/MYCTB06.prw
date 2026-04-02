#Include "Protheus.ch"
#Include "PRTOPDEF.CH"
#INCLUDE "TOPCONN.CH"

//Funcao para trazer as linhas de apuração do IPI para contabilizacao da diferença do imposto
//Chamada pela LP 720 e 721
//02/05/2018 - Claudio Iabuki

User Function MYCTB06(cOpc)

  Local nRet   := 0		//Valor da apuracao a retornar
  Local nRet08 := 0		//Valor da apuracao da linha 008
  Local nRet13 := 0		//Valor da apuracao da linha 013
  Local aArea1 := Getarea()
  Local cQuery1           

  cQuery1 := "SELECT TOP 2 CDP_VALOR, CDP_LINHA "
  cQuery1 += "FROM " + RetSqlName("CDP") + " AS CDP "
  cQuery1 += "		WHERE CDP.D_E_L_E_T_ = ' ' AND CDP_FILIAL = '"+xfilial("CDP")+"' AND CDP_VALOR > 0 AND CDP_LINHA IN ('008','013') AND CDP_SEQUEN = '001' "
  cQuery1 += "ORDER BY CDP_DTINI DESC "

  CQUERY1 := CHANGEQUERY(CQUERY1)
  TCQUERY CQUERY1 NEW ALIAS "TCDP"

  DbSelectArea("TCDP")
  TCDP->(DbGoTOP())
  DO WHILE !EOF()
    IF TCDP->CDP_LINHA = '008'  //Linha que volta o valor de Credito
      nRet08 := TCDP->CDP_VALOR
    Endif
    IF TCDP->CDP_LINHA = '013'  //LInha que volta o valor de Debito
      nRet13 := TCDP->CDP_VALOR
    Endif
  TCDP->(dbskip())
  ENDDO

  TCDP->(dbCloseArea())

  RestArea(aArea1)                    

  IF cOpc = 1 //Volta a linha 008
    nRet := nRet08
  Endif
  
  IF cOpc = 2 //Volta a linha 013
    nRet := nRet13
  Endif

Return nRet
