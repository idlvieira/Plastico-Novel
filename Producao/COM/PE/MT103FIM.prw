#include "rwmake.ch"
#include "topconn.ch" 
#Include 'Protheus.ch'         
#INCLUDE "ap5mail.ch"
//.==============================================================.
//|                PL�STICOS NOVEL LTDA                          |
//|--------------------------------------------------------------|
//| Programa : MT103FIM.PRW     | Autor: Leandro Ferreira        |
//|--------------------------------------------------------------|
//| Descricao: Ponto de Entrada no documento de entrada          |
//| para envio de e-mail ao comprador e solicitante da SC        |
//|--------------------------------------------------------------|
//| Data criacao  : 14/12/2022 | Ultima alteracao:              |
//|--------------------------------------------------------------|
//| Uso especifico para Microsiga Advanced Protheus              |
//.==============================================================.
//	atualizações:
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante      Motivo
// 14/12/2022  Leandro Ferreira          Jaqueline Chen       
User function MT103FIM()
    Local nOpcao    := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina 
    Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO
    Local cNF       := CNFISCAL
    Local cForne    := CA100FOR
    Local cLJFor    := IIF(EMPTY(CLOJA),CFORANTNFE,CLOJA) 

    if cvaltochar(nOpcao) $ '3#4' .AND. nConfirma == 1 .AND. FunName() == "MATA103"
        BuscaCPSOL(cNF,cForne,cLJFor)
    Endif 
Return (NIL)

Static Function BuscaCPSOL(cNF,cForne,cLJFor) 

    Local cQuery    := ""  
    //Local aDados    := {}
    //Local cMensagem := "" 
    //Local cQuery 	:= "" 
    Local cEmail    := ""
    Local cUsers    := ""
    Local cAssunto  := ""
    Local _cBody    := ""

    cQuery    :=  "SELECT D1_FILIAL,D1_COD,D1_ITEM,C7_DESCRI, "
    cQuery    +=  "CASE "
    cQuery    +=  "	WHEN C7_TIPO = '1' THEN 'PC' "
    cQuery    +=  "	WHEN C7_TIPO = '2' THEN 'AE' "
    cQuery    +=  "END 'TIPO' "
    cQuery    +=  ",D1_PEDIDO,D1_ITEMPC,COALESCE(C7_NUMSC,'') 'SC',C7_ITEMSC,C7_QUANT,C7_QUJE,D1_QUANT, "
    cQuery    +=  "COALESCE(C1_EMISSAO,C7_EMISSAO) 'DT_SC',C7_EMISSAO,C7_DATPRF,D1_EMISSAO,D1_DTDIGIT,C7_USER, COALESCE(C1_USER,'') 'USR_SC',COALESCE(C1_ZZCAPRO,'') 'APRO_SC' "
    cQuery    +=  "FROM " + retSqlName("SD1") + " "
    cQuery    +=  "INNER JOIN " + retSqlName("SC7") + " "
    cQuery    +=  "ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND C7_ITEM = D1_ITEMPC AND " + retSqlName("SC7") + ".D_E_L_E_T_ = '' "
    cQuery    +=  "LEFT JOIN " + retSqlName("SC1") + " "
    cQuery    +=  "ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND " + retSqlName("SC1") + ".D_E_L_E_T_ = '' "
    cQuery    +=  "WHERE  " 
    cQuery    +=  "D1_DOC ='" + cNF + "' "
    cQuery    +=  "AND D1_FORNECE ='" + cForne + "' "
    cQuery    +=  "AND D1_LOJA ='" + cLJFor + "' "
    cQuery    +=  "AND " + retSqlName("SD1") + ".D_E_L_E_T_ = '' "

 	TCQUERY cQuery NEW ALIAS "_query"
	Tcsqlexec(cQuery)

    TCSETFIELD("_query","DT_SC","D",08,00)
    TCSETFIELD("_query","C7_EMISSAO","D",08,00)
    TCSETFIELD("_query","C7_DATPRF","D",08,00)
    TCSETFIELD("_query","D1_EMISSAO","D",08,00)
    TCSETFIELD("_query","D1_DTDIGIT","D",08,00)

	DBSelectArea("_query")
	DBGoTop()
    _cBody	:= "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
	_cBody	+= "<html>"
	_cBody	+= "<head>"
	_cBody	+= "<title>Documento sem t&iacute;tulo</title>"
	_cBody	+= "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	_cBody	+= "</head>"

	_cBody	+= "<body>"
	_cBody	+= "<table width='100%' border='3'>"
	_cBody	+= "  <tr>"
	_cBody	+= "    <td width='84%'><div align='center'>"
	_cBody	+= "        <p><font size='5' face='Georgia, Times New Roman, Times, serif'><strong>Nota fiscal: "
	_cBody	+= "         " + cNF + " incluida para os pedidos abaixo </strong></font></p>"
	_cBody	+= "        </div></td>"
	_cBody	+= "    <td width='16%'><img src='file:///\\server2\p10_oficial/PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
	_cBody	+= "  </tr>"
	_cBody	+= "</table>"

	_cBody	+= "<p>&nbsp;</p>"
    _cBody	+= "<p>&nbsp;</p>"
    
	_cBody	+= "<table width='100%' border='3'>"
    _cBody	+= "  <tr>"
    _cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Filial</font></strong></td>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Produto</font></strong></td>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Item NF</font></strong></td>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Descri</font></strong></td>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Tipo</font></strong></td>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Pedido/AE</font></strong></td>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Item PC</font></strong></td>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>SC/Contrato</font></strong></td>"
	_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Item SC/Contrato</font></strong></td>"
	//_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Quant PC</font></strong></td>"
    //_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Saldo PC</font></strong></td>"
    //_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Quant NF</font></strong></td>"
    _cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data SC</font></strong></td>"
    _cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data PC</font></strong></td>"
    _cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data Prevista</font></strong></td>"
    _cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Emis. NF.</font></strong></td>"
    _cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data Digit.</font></strong></td>"
    _cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Comprador</font></strong></td>"
    _cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Solicitante</font></strong></td>"
	_cBody	+= "  </tr>"

    WHILE _QUERY->(!Eof())
        IF !(_QUERY->C7_USER $ cUsers )
            cUsers += '#' + _QUERY->C7_USER
            IF cEmail == ""
                cEmail := UsrRetMail(_QUERY->C7_USER)
            ELSE
                cEmail +=  ';' + UsrRetMail(_QUERY->C7_USER) 
            ENDIF
        ENDIF
        IF !(_QUERY->USR_SC $ cUsers) .AND. _QUERY->USR_SC != ''
            cUsers += '#' + _QUERY->USR_SC
            IF cEmail == ""
                cEmail := UsrRetMail(_QUERY->USR_SC)
            ELSE
                cEmail +=  ';' + UsrRetMail(_QUERY->USR_SC) 
            ENDIF
        ENDIF 
        IF !(_QUERY->APRO_SC $ cUsers) .AND. _QUERY->APRO_SC != ''
            cUsers += '#' + _QUERY->APRO_SC
            IF cEmail == ""
                cEmail := UsrRetMail(_QUERY->APRO_SC)
            ELSE
                cEmail +=  ';' + UsrRetMail(_QUERY->APRO_SC) 
            ENDIF
        ENDIF 
        
        _cBody	+= "  <tr>"
        _cBody	+= "    <td>" + _QUERY->D1_FILIAL + " </td>
        _cBody	+= "    <td>" + _QUERY->D1_COD + " </td>
        _cBody	+= "    <td>" + _QUERY->D1_ITEM + " </td>
        _cBody	+= "    <td>" + _QUERY->C7_DESCRI + " </td>
        _cBody	+= "    <td>" + _QUERY->TIPO + " </td>
        _cBody	+= "    <td>" + _QUERY->D1_PEDIDO + " </td>
        _cBody	+= "    <td>" + _QUERY->D1_ITEMPC + " </td>
        _cBody	+= "    <td>" + _QUERY->SC + " </td>
        _cBody	+= "    <td>" + _QUERY->C7_ITEMSC + " </td>
        //_cBody	+= "    <td>" + cValToChar(_QUERY->C7_QUANT) + " </td>
        //_cBody	+= "    <td>" + cValToChar(_QUERY->C7_QUANT - _QUERY->C7_QUJE) + " </td>
        //_cBody	+= "    <td>" + cValToChar(_QUERY->D1_QUANT) + " </td>
        _cBody	+= "    <td>" + (DTOC(_QUERY->DT_SC)) + " </td>
        _cBody	+= "    <td>" + (DTOC(_QUERY->C7_EMISSAO)) + " </td>
        _cBody	+= "    <td>" + (DTOC(_QUERY->C7_DATPRF)) + " </td>
        _cBody	+= "    <td>" + (DTOC(_QUERY->D1_EMISSAO)) + " </td>
        _cBody	+= "    <td>" + (DTOC(_QUERY->D1_DTDIGIT)) + " </td>
        _cBody	+= "    <td>" + UsrFullName(_QUERY->C7_USER) + " </td>
        _cBody	+= "    <td>" + IIF(_QUERY->USR_SC != '',UsrFullName(_QUERY->USR_SC), "") + " </td>
        _cBody	+= "  </tr>"
        DbSkip()
    END
    _QUERY->(dbCloseArea())
    _cBody	+= "</table>"
	_cBody	+= "<p>&nbsp;</p>"
	_cBody	+= "</body>"
	_cBody	+= "</html>"

	cAssunto	:= "Seu pedido foi entregue na NF: " + cNF

    U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cEmail + Chr( 59 ), cAssunto, _cBody, /*_cAttach*/, /*lResultSend*/, /*_cLog*/ )

Return 
