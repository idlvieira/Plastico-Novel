
#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValAprov  ºAutor  ³        º Data ³                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Verificar se há mais de um grupo aprovador.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Pedido de Compras                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante      Motivo
// 13/12/2022  Leandro Ferreira          Jaqueline Chen   Envia email para o solicitante
USER FUNCTION MT120OK()
 Local lRet   :=  .T.
 Local nPOSSC := aScan(aHeader, {|x| allTrim(x[2]) == "C7_NUMSC"	})
 Local cSC    := aCols[1][nPOSSC]
 Local cPED   := CA120NUM
 Local nPosDTF := aScan(aHeader, {|x| allTrim(x[2]) == "C7_DATPRF"	}) //Dt. Entrega 
 Local nPosDTZ := aScan(aHeader, {|x| allTrim(x[2]) == "C7_ZZDATPR"	}) //Dt.Prev.Fin.
 Local i      := 0

 lRet := ValAprov()
 
  if !Empty(alltrim(cSC)) .AND. lRet
      notfSol(cPED,cSC)
  EndIf 

  IF lRet
    For i:=1 to Len(aCols)
        aCols[i][nPosDTZ] := aCols[i][nPosDTF]
    Next i
  ENDIF

RETURN(lRet)

STATIC FUNCTION ValAprov()
 Local lRet  :=  .T.
 Local nUsado  := 0
 Local nPosCC  := 0
 Local nPosTab :=  0
 Local nPosCC  := 0
 Local nI   := 0
 Local cCCusto := ''
 Local cGrpAprv := ''
 Local cMsgErro := ''
 Local cAliasCTT := GetNextAlias() 
 
 nUsado := Len(aHeader)
 nPosCC := aScan(aHeader,{|x| AllTrim(x[2])=='C7_CC'})

  // Relaciona os Centros de Custo utilizados no Pedido de Compra
  For nI:=1 to Len(aCols)
   If !(aCols[nI][nPosCC] $ cCCusto) .and. !aCols[nI][nUsado+1]
    cCCusto += If(Empty(cCCusto),'',',') +"'"+AllTrim(aCols[nI][nPosCC])+"'"
   EndIf
     Next nI 
     cCCusto := '%'+cCCusto+'%'
                       
     // Busca Grupo de Aprovação de acordo com os Centro de Custo relacionados         
     BeginSQL Alias cAliasCTT
   SELECT 
       CTT.CTT_CUSTO AS CCUSTO,
       SAL.AL_COD AS APROV
      FROM
    %Table:CTT% CTT
   LEFT JOIN %Table:SAL% SAL
    ON  SAL.AL_FILIAL = %xFilial:SAL% AND SAL.%notdel% AND CTT_ZZAPRO=AL_COD
      WHERE              
    CTT.CTT_FILIAL = %xFilial:CTT% AND 
    CTT.%notdel% AND
    CTT.CTT_CUSTO IN (%Exp:cCCusto%)
   GROUP BY 
    CTT.CTT_CUSTO,SAL.AL_COD
     EndSQL 
                 
     cGrpAprv := ''
     While !(cAliasCTT)->(EOF()) 
      If Empty((cAliasCTT)->APROV)
       cMsgErro += "- O Centro de Custo "+(cAliasCTT)->CCUSTO+" não está amarradao à um Grupo de Aprovadores"  
       lRet:=.F.
      ElseIf Empty(cGrpAprv)
       cGrpAprv := (cAliasCTT)->APROV
      EndIf
      If (cAliasCTT)->APROV != cGrpAprv .AND. !Empty((cAliasCTT)->APROV)
          Alert('Este pedido possui mais de um Grupo Aprovador. Verifique e separe os centros de custo!')
       lRet:=.F.           
    Exit
      EndIf
      (cAliasCTT)->(dbSkip())
     EndDo
     
     If !Empty(cMsgErro)
      Aviso('Pedido não Validado',cMsgErro,{'Ok'},,'PE: MT120OK')
      lRet:=.F.           
  EndIf                   
  (cAliasCTT)->(dbCloseArea())
  
RETURN(lRet)


/*/{Protheus.doc} nomeStaticFunction
  (long_description)
  @type  Static Function
  @author user
  @since date
  @version version
  @param param, param_type, param_descr
  @return return, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
  /*/
 Static Function notfSol(cPED,cSC)
    Local cSolicit  := POSICIONE("SC1",1,xFilial("SC1")+cSC,"C1_USER")
    Local _cEmail   := ""
    Local _aInfo    := ""
    Local _cNomSol  := ""
    Local nPOSDTENT := aScan(aHeader, {|x| allTrim(x[2]) == "C7_DATPRF"	})
    Local _DATPRF   := aCols[1][nPOSDTENT]
    Local _USER     := __CUSERID
    Local _cNomComp := ''
    Private _cBody		:= ""

    If PswSeek( cSolicit, .T. )
			_aInfo		:= PswRet(1)
			_cEmail		:= Alltrim(_aInfo[1,14]) //E-mail do Solicitante
			_cNomSol	:= Alltrim(_aInfo[1,04]) //Nome do Solicitante
		EndIf

    If PswSeek( _USER, .T. )
      _aInfo		:= PswRet(1)
			_cNomComp	:= Alltrim(_aInfo[1,04]) //Nome do Comprador
		EndIf

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
		_cBody	+= "        <p><font size='5' face='Georgia, Times New Roman, Times, serif'><strong>Sr. solicitante o"
		_cBody	+= "          pedido foi gerado.</strong></font></p>"
		_cBody	+= "        </div></td>"
		_cBody	+= "    <td width='16%'><img src='file:///\\server2\p10_oficial/PROTHEUS_DATA/system/lglr01.bmp' width='160' height='41'></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "</table>"
		_cBody	+= "<table width='100%' border='3'>"
		_cBody	+= "  <tr>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Solicita&ccedil;&atilde;o "
		_cBody	+= "      n&ordm;: <font color='#663300'>"+cSC+"</font></font></strong></td>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Pedido "
		_cBody	+= "      n&ordm;: <font color='#663300'>"+cPED+"</font></font></strong></td>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data "
		_cBody	+= "      emiss&atilde;o: <font color='#663300'>"+dtoc(DA120EMIS)+"</font></font></strong></td>"
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Data "
		_cBody	+= "      entrega prev: <font color='#663300'>"+dtoc(_DATPRF)+"</font></font></strong></td>"
    _cBody	+= "  </tr>"
		_cBody	+= "  <tr> "
		_cBody	+= "    <td><strong><font color='#000066' face='Verdana, Arial, Helvetica, sans-serif'>Comprador: "
		_cBody	+= "      <font color='#663300'>"+_cNomComp+"</font> </font></strong></td>"
		_cBody	+= "  </tr>"
		_cBody	+= "</table>"
		_cBody	+= "<p>&nbsp;</p>"
		_cBody	+= "</body>"
		_cBody	+= "</html>"
    fEnviar(cPED,cSC,_cEmail )
Return 

Static Function fEnviar(cPED,cSC,_cEmail )

	/* Variaveis Locais */
	Local _cAssCP	:= "Pedido n:" + cPED + " gerado para a SC:" + cSC

			U_fPNSendMail( /*_cAccount*/, /*_cPassword*/, /*_cServer*/, /*_cFrom*/, _cEmail + Chr( 59 ), _cAssCP, _cBody, /*_cAttach*/, /*lResultSend*/, /*_cLog*/ )

	
Return ( Nil )

