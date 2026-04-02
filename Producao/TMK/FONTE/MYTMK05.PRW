#Include "protheus.ch"
#Include "totvs.ch"
#Include "topconn.ch"

/*/{Protheus.doc} MYTMK05
Retorna o aprovador atual do orcamento de venda e Limites de Aprovacao

@type				function
@author				NEWTON RECA ALVES
@since				31/10/2012
@obs				Alterado por Sonia Silva em 22/12/2016
                    Alterado por Leonardo Bergamasco em 30/07/2019 - Inserido bloco de verificacao do aprovador nivel 1 pelo cadastro do vendedor.
/*/
User Function MYTMK05(nOrcamento, nNivel) //User Function MYFAT02()

	//local aAreaATU		:= getArea()
  //Local Oqry := NVLxFUN():New(.f.), cQuery

  Private cAprovador := ""

  cAprovador	:= Posicione ("ZZZ", 1, xFilial("ZZZ") + "TMK000004" + "AP" + cValToChar(nNivel), "ZZZ_RETORN")
	
  // Início Alterado por Leandro Camaçari - Agus Consultoria - Data: 31/01/2024.

	//Verifica o aprovador pelo cadastro de vendedor (campo A3_GEREN)
  /*If cValToChar(nNivel) == "1"
      cQuery := "SELECT UA_VEND, V3.A3_SUPER, V3.A3_GEREN, G3.A3_CODUSR "
      cQuery += "FROM SUA010 AS UA "
      cQuery += "INNER JOIN SA3010 AS V3 ON V3.A3_COD=UA_VEND AND V3.D_E_L_E_T_!='*' "
      cQuery += "INNER JOIN SA3010 AS G3 ON G3.A3_COD=V3.A3_GEREN AND G3.D_E_L_E_T_!='*' "
      cQuery += "WHERE UA_FILIAL='"+xFilial("SUA")+"' AND UA_NUM='"+nOrcamento+"' AND UA.D_E_L_E_T_!='*' "
       
      Oqry:TcQry("xSAU", cQuery,1,.f.)
      While ! EOF()
        cAprovador := AllTrim(UsrRetName(xSAU->A3_CODUSR))
      xSAU->(dbSkip())
      EndDo
      xSAU->(dbCloseArea())
	EndIf
  */

  //Verifica o aprovador pelo cadastro de vendedor (campo A3_SUPER)
  If cValToChar(nNivel) == "1"

      cQuery := "SELECT SUA.UA_VEND, SA3.A3_SUPER, SA3.A3_GEREN "
      cQuery += "FROM SUA010 AS SUA "
      cQuery += "INNER JOIN SA3010 SA3 ON SA3.A3_COD = SUA.UA_VEND AND SA3.D_E_L_E_T_ = ' ' "
      cQuery += "WHERE SUA.UA_FILIAL='"+xFilial("SUA")+"' AND SUA.UA_NUM='"+nOrcamento+"' AND SUA.D_E_L_E_T_!='*' "
       
      TCQuery cQuery Alias "qrySUA" New
      
      If !Empty(qrySUA->A3_SUPER)
          
          If Alltrim(qrySUA->A3_SUPER) == '000011'     // Camila Chaves 
              cAprovador := 'CCHAVES'
          ElseIf Alltrim(qrySUA->A3_SUPER) == '000043' // Gabriel Ramos    
              cAprovador := 'GRAMOS'
          ElseIf Alltrim(qrySUA->A3_SUPER) == '000025' // Ricardo Martins
              cAprovador := 'RMARTINS'
          EndIf

      EndIf
      qrySUA->(DbCloseArea())

  EndIf


  //Verifica o aprovador pelo cadastro de vendedor (campo A3_GEREN)
  If cValToChar(nNivel) == "2"

      cQuery := "SELECT SUA.UA_VEND, SA3.A3_SUPER, SA3.A3_GEREN "
      cQuery += "FROM SUA010 AS SUAFROM SUA010 AS SUA "
      cQuery += "INNER JOIN SA3010 SA3 ON SA3.A3_COD = SUA.UA_VEND AND SA3.D_E_L_E_T_ = ' ' "
      cQuery += "WHERE SUA.UA_FILIAL='"+xFilial("SUA")+"' AND SUA.UA_NUM='"+nOrcamento+"' AND SUA.D_E_L_E_T_!='*' "
       
      TCQuery cQuery Alias "qrySUA" New
      
      If Alltrim(qrySUA->A3_GEREN) == '000011'     // Camila Chaves 
          cAprovador := 'CCHAVES'
      ElseIf Alltrim(qrySUA->A3_GEREN) == '000043' // Gabriel Ramos    
          cAprovador := 'GRAMOS'
      ElseIf Alltrim(qrySUA->A3_GEREN) == '000025' // Ricardo Martins
          cAprovador := 'RMARTINS'
      EndIf

      qrySUA->(DbCloseArea())

	EndIf

	//RestArea(aAreaATU)

  // Fim Alterado por Leandro Camaçari - Agus Consultoria - Data: 31/01/2024.

Return cAprovador
