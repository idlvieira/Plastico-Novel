#Include "Protheus.ch"
#Include "topconn.ch"
#include "Ap5Mail.ch"

/*
* Funcao		: MT103FIM
* Autor			: DANIEL TORNISIELO
* Data			: 02/08/2016
* Descrição		: O ponto de entrada MT103FIM encontra-se no final da função A103NFISCAL. Após o destravamento de todas as tabelas envolvidas na gravação do documento de entrada, depois de fechar a operação realizada neste, é utilizado para realizar alguma operação após a gravação da NFE.
* Observacoes	: n/a
*/
//25/05/2019 Leonardo Bergamasco 4LD-PB1-3DUS (208) - Incluido a função local fFINaviso para aviso operação financeira

User Function MT103FIM()

	Local aBkpArea := GetArea()
	
	Local nOpcao    := PARAMIXB[1] // Opção escolhida pelo usuário no aRotina
	Local nConfirma := PARAMIXB[2] // Se o usuário confirmou a operação de gravação da NFE

    //DANIEL TORNISIELO - Usado no monitor XML B2F
    //--------------------------------------------------------------------------------------------------\\
	If (nOpcao = 3	.OR. nOpcao = 4) .And. nConfirma = 1 //-Inclusao ou Classificacao da NFe e Confirmou
		U_MONGRVSP(SF1->F1_CHVNFE,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DTDIGIT)
	EndIf

	If nOpcao = 4 .And. nConfirma = 1 // Classificacao da NFe e Confirmou
		U_fManClas(SF1->F1_CHVNFE) // Irá manifestar automaticamente com o evento Confirmação da Operação caso o parametro ZZ_MANCLAS estiver verdadeiro
	EndIf
    //--------------------------------------------------------------------------------------------------\\

    //Leonardo Bergamasco - Bloco de customização da Novel
    If (nOpcao = 3	.OR. nOpcao = 4) .And. nConfirma = 1 //-Inclusao ou Classificacao da NFe e Confirmou
		fFINaviso(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DTDIGIT,SF1->F1_TIPO)
	EndIf
	
	RestArea(aBkpArea)
	
Return

*Funcao*********************************************************************************************************************************************

//Rotina para avisar via e-mail ao Depto Financeiro das operações de Entrada que necessita de atenção especial
Static Function fFINaviso(_DOC,_SER,_FOR,_LJA,_DTD,_TIP)

  Local kk  := 00
  Local cQuery := ""
  Local aSE2   := {}
  Local cTipos := GetMv("ZZ_MT103_A")
  Local cHTML,cServer,cAccount,cPassword,cAutentic,cEnvia,cEmail //,lResulConn
  Local Oqry:=NVLxFUN():New(.f.)

  If ! _TIP $ "DB"  
    cQuery := "SELECT E2_EMISSAO, E2_PREFIXO, E2_NUM, E2_TIPO, E2_VALOR FROM SE2010 WHERE E2_FILIAL='"+xFilial("SE2")+"' AND E2_TIPO IN ("+Oqry:CriaIn(cTipos)+") AND E2_FORNECE='"+_FOR+"' AND E2_SALDO>0 AND D_E_L_E_T_!='*'"
    MsAguarde( {|| Oqry:TcQry("xSE2", cQuery,1,.f.) }, "Verificando Financeiro (Novel)")
    TCSetField("xSE2","E2_EMISSAO","D")
  
    While ! EOF()
      aadd(aSE2, {DtoC(xSE2->E2_EMISSAO), xSE2->E2_PREFIXO, xSE2->E2_NUM, xSE2->E2_TIPO, Transform(xSE2->E2_VALOR, "@E 999,999,999.99")}) 
      xSE2->(dbSkip())
    EndDo
    xSE2->(dbCloseArea())
  
    If Empty(aSE2)
      Return
    EndIf
  EndIf

  cHTML 	:= ""
  cServer	:= GetMv("MV_RELSERV")
  cAccount	:= GetMv("MV_RELACNT")
  cPassword	:= GetMv("MV_RELPSW")
  cAutentic	:= GetMv("MV_RELAUTH")
  cEnvia	:= GetMv("MV_RELACNT")
  cEmail	:= Posicione("ZZZ",1,xFilial("ZZZ")+"FAT000002"+"002","ZZZ_RETORN")

  If _TIP == "D"
  //Notas de Devolução
    cHtml	+= "<html>"
    cHtml	+= "<body>"
    cHtml	+= "<b><i><span style='font-size:18.0pt;line-height:115%;color:red'>Entrada de Nota Fiscal de DEVOLUÇÃO</span></i></b></br></br>"
    cHtml	+= "<span style='font-size:16.0pt;line-height:115%;color:black'>Identificação do processo</span></br></br>"
    cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Nota Fiscal: <b>" + AllTrim(_DOC) + "/" + AllTrim(_SER) +"</b></span></br>"
    cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Cliente: <b>" + AllTrim(_FOR) + "/" + AllTrim(_LJA) + "</b></span></br>"
    cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Data de Entrada: <b>" + DtoC(_DTD) + "</b></span></br></br>"
    cHtml	+= "<p><b>Atenciosamente,</b></p> "   
    cHtml	+= "<p><b>Tesouraria</b></p> "   
    cHtml	+= "</body>"
    cHtml	+= "</html>"
  ElseIf ! _TIP $ "DB"
  //Outras operações diferente Devolução ou Beneficiamento, se teve operação financeiro será verificado se existe PA em aberto para compensação do fornecedor.
    cHtml	+= "<html>"
    cHtml	+= "<body>"
    cHtml	+= "<b><i><span style='font-size:18.0pt;line-height:115%;color:red'>Entrada de Nota Fiscal com PA/NDF a ser COMPENSADO</span></i></b></br></br>"
    cHtml	+= "<span style='font-size:16.0pt;line-height:115%;color:black'>Identificação do processo</span></br></br>"
    cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Nota Fiscal: <b>" + AllTrim(_DOC) + "/" + AllTrim(_SER) +"</b></span></br>"
    cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Fornecedor: <b>" + AllTrim(_FOR) + "/" + AllTrim(_LJA) + "</b></span></br>"
    cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Data de Entrada: <b>" + DtoC(_DTD) + "</b></span></br></br>"
    cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:blue'><b>Titulos de PA/NDF em aberto</b></span></br>"
    cHtml	+= "<TABLE WIDTH='40%' BORDER='1' CELLPADDING='2' CELLSPACING='2'>
    cHtml	+= "<TR>"
    cHtml	+= "<TD WIDTH=20% Align='center'><DIV class=s1><b>Dt. Titulo</b></DIV></TD>"
    cHtml	+= "<TD WIDTH=20% Align='center'><DIV class=s1><b>Prefixo</b></DIV></TD>"
    cHtml	+= "<TD WIDTH=20% Align='center'><DIV class=s1><b>Numero</b></DIV></TD>"
    cHtml	+= "<TD WIDTH=10% Align='center'><DIV class=s1><b>Tipo</b></DIV></TD>"
    cHtml	+= "<TD WIDTH=30% Align='center'><DIV class=s1><b>Valor</b></DIV></TD>"
    cHtml	+= "</TR>"
    For kk:=1 to Len(aSE2)
      cHtml	+= "<TR>"
      cHtml	+= "<TD WIDTH=20% Align='center'><DIV class=s1>"+aSE2[kk,1]+"</DIV></TD>"
      cHtml	+= "<TD WIDTH=20% Align='center'><DIV class=s1>"+aSE2[kk,2]+"</DIV></TD>"
      cHtml	+= "<TD WIDTH=20% Align='center'><DIV class=s1>"+aSE2[kk,3]+"</DIV></TD>"
      cHtml	+= "<TD WIDTH=10% Align='center'><DIV class=s1>"+aSE2[kk,4]+"</DIV></TD>"
      cHtml	+= "<TD WIDTH=30% Align='right'><DIV class=s1>"+aSE2[kk,5]+"</DIV></TD>"
      cHtml	+= "</TR>"
    Next
    cHtml	+= "</TABLE></br></br></br>"
    cHtml	+= "<p><b>Atenciosamente,</b></p> "   
    cHtml	+= "<p><b>Tesouraria</b></p> "   
    cHtml	+= "</body>"
    cHtml	+= "</html>"
  EndIf 

  //Manda e e-mail
  If ! Empty(cHtml)
		
		U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cEmail + Chr( 59 ), 'FINANCEIRO - Entrada de Nota Fiscal situação especifica', cHtml, /*_cAttach*/, /*_lMsg*/, /*_cLog*/ )

/*
    CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
    lResulConn := MailAuth(cAccount, cPassword)
    If lResulConn
      SEND MAIL FROM cAccount TO cEmail SUBJECT 'FINANCEIRO - Entrada de Nota Fiscal situação especifica' BODY cHtml
    EndIf
*/
  EndIf

Return
