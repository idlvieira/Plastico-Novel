#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460FIM  º Autor ³Newton Reca Alves   º Data ³  10/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIA EMAIL PARA FINANCEIRO INFORMANDO SOBRE NF DE UMA TES º±±
±±º          ³ ESPECIFICA                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PONTO DE ENTRADA - EMISSAO DE NF                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//22/02/2019 Leonardo Bergamaco UWB-B6P-ZLEN (199) - Alteração da logica para melhor atender a necessidade

User Function M460FIM()

  Local cEmailAviso := "N"
  Local cHTML,cServer,cAccount,cPassword,cAutentic,cEnvia,cEmail,lResulConn
  
  cEmailAviso := Posicione("SE4",1,xFilial("SE4")+AllTrim(SF2->F2_COND),"E4_ZZEMAIL")

  If cEmailAviso == 'N'
    Return
  EndIf

  cHTML 	:= ""
  cServer	:= GetMv("MV_RELSERV")
  cAccount	:= GetMv("MV_RELACNT")
  cPassword	:= GetMv("MV_RELPSW")
  cAutentic	:= GetMv("MV_RELAUTH")
  cEnvia	:= GetMv("MV_RELACNT")
  cEmail	:= Posicione("ZZZ",1,xFilial("ZZZ")+"FAT000002"+"002","ZZZ_RETORN")

  cHtml	+= "<html>"
  cHtml	+= "<body>"
  cHtml	+= "<b><i><span style='font-size:18.0pt;line-height:115%;color:red'>Emissao de Nota Fiscal com Cond.Pagto especifica</span></i></b></br></br>"
  cHtml	+= "<span style='font-size:16.0pt;line-height:115%;color:black'>Identificação do processo</span></br></br>"
  cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Nota Fiscal: <b>" + AllTrim(SF2->F2_DOC) + "/" + AllTrim(SF2->F2_SERIE) +"</b></span></br>"
  cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Cliente: <b>" + AllTrim(SF2->F2_CLIENTE) + "/" + AllTrim(SF2->F2_LOJA) + "</b></span></br>"
  cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Emissão: <b>" + DtoC(SF2->F2_EMISSAO) + "</b></span></br>"
  cHtml	+= "<span style='font-size:12.0pt;line-height:115%;color:black'>Cond.Pagamento: <b>" + AllTrim(SF2->F2_COND) + "</b></span></br></br>"
  cHtml	+= "<p><b>Atenciosamente,</b></p> "   
  cHtml	+= "<p><b>Tesouraria</b></p> "   
  cHtml	+= "</body>"
  cHtml	+= "</html>"

  //Manda e e-mail
	U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, cEmail + Chr( 59 ), 'FINANCEIRO - Emissao de Nota Fiscal com Cond.Pagto especifica', cHtml, /*_cAttach*/, /*_lMsg*/, /*_cLog*/ )
/*
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
  lResulConn := MailAuth(cAccount, cPassword)
  If lResulConn
    SEND MAIL FROM cAccount TO cEmail SUBJECT 'FINANCEIRO - Emissao de Nota Fiscal com Cond.Pagto especifica' BODY cHtml
  EndIf
*/

Return
