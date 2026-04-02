#Include "RWMAKE.CH"
#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Donizete            º Data ³  03/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Fluxo de  Aprovação do Cadastro do Produto                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada disparado no Ok do Cad.Produtos.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//
//28/01/2019 - Leonardo Bergamasco BV1-E34-SYD8 (325) - Bloco de validações no cadastro


User Function A010TOK()

_cFase		:= ALLTRIM(M->B1_ZZFASE)
_lRet		:= .F.
_cUsuario	:= CUSERNAME
oModelx 	:= FWModelActive()
oModelxDet	:= oModelx:GetModel("SB1MASTER")  

  //28/01/2019 - Leonardo Bergamasco BV1-E34-SYD8 (325) - Bloco de validações no cadastro
  If ! nvlValid()
    Return .F.
  EndIf  


  If AllTrim(SM0->M0_CODFIL) == AllTrim("0101")
    Return .T.
  EndIf


	If M->B1_ZZVOLTA<>"1" .AND. M->B1_ZZFASE $ " 1" .and. Upper(Trim(_cUsuario))$TRIM(U_MYCFG02("COM000003","001","P")) //TRIM(U_MYCFG02("COM000003","001","P"))	 //== Upper(Trim(GETMV("MV_MYFASE1")))

		If &(U_MYCFG02("COM000003","006","V"))			//!EMPTY(M->B1_COD).AND.!EMPTY(M->B1_DESC).AND.!EMPTY(M->B1_ZZDESCI).AND.!EMPTY(M->B1_TIPO).AND.!EMPTY(M->B1_UM).AND.!EMPTY(M->B1_LOCPAD).AND.!EMPTY(M->B1_GRUPO).AND.!EMPTY(M->B1_LOCPAD).AND.!EMPTY(M->B1_ORIGEM).AND.!EMPTY(M->B1_MYSOLIC).AND.!EMPTY(M->B1_CHAVE)
			_lRet	:= .T.
		Else
			Alert(U_MYCFG02("COM000003","006","H"))
		EndIf

	ElseIf M->B1_ZZVOLTA<>"1" .AND. M->B1_ZZFASE == "2" .and. Upper(Trim(_cUsuario))$TRIM(U_MYCFG02("COM000003","002","P"))
		If &(U_MYCFG02("COM000003","007","V"))		//!EMPTY(M->B1_LOCALIZ) .AND. !EMPTY(M->B1_AGREGCU)
			_lRet	:= .T.
		Else
		Alert(U_MYCFG02("COM000003","007","H"))
		EndIf

	ElseIf M->B1_ZZVOLTA<>"1" .AND. M->B1_ZZFASE == "3" .and. Upper(Trim(_cUsuario))$TRIM(U_MYCFG02("COM000003","003","P"))
		If &(U_MYCFG02("COM000003","008","V"))		//!empty(M->B1_ZZCPART) .and. !empty(M->B1_CUSTD)  
			_lRet	:= .T.
		Else
			Alert(U_MYCFG02("COM000003","008","H"))
		EndIf

	ElseIf M->B1_ZZVOLTA<>"1" .AND. M->B1_ZZFASE == "F" .and. Upper(Trim(_cUsuario))$TRIM(U_MYCFG02("COM000003","011","P"))
			_lRet	:= .T.

	ElseIf M->B1_ZZVOLTA=="1"
		If !EMPTY(M->B1_ZZMOTRJ) 
			_lRet	:= .T.
		Else
			Alert("Existem campos obrigatorios para a rejeicao do cadastro como (Motivo da Rejeicao)")
		EndIf

	Else
		Alert("Voce nao esta cadastrado nos parametros para alterar o cadastro de produto ou nao esta na sua fase, favor contatar o departamento de Compliance !")
			_lRet	:= .F.
	EndIf

If M->B1_ZZVOLTA<>"1" .AND. _lRet .and. _cFase=="1"

	oModelxDet:SetValue('B1_ZZFASE','2')	
	oModelxDet:SetValue('B1_MSBLQL' ,'1')
	
ElseIf M->B1_ZZVOLTA<>"1" .AND. _lRet .and. _cFase=="2"
	
	oModelxDet:SetValue('B1_ZZFASE','3')	
	oModelxDet:SetValue('B1_MSBLQL' ,'1')
	
ElseIf M->B1_ZZVOLTA<>"1" .AND. _lRet .and. _cFase=="3"
	
	oModelxDet:SetValue('B1_ZZFASE','F')	
	oModelxDet:SetValue('B1_MSBLQL' ,'1')
	
ElseIf M->B1_ZZVOLTA<>"1" .AND. _lRet .and. _cFase=="F"
	
	oModelxDet:SetValue('B1_ZZFASE','L')	
	
ElseIf M->B1_ZZVOLTA=="1"
	
	oModelxDet:SetValue('B1_ZZFASE','1')	
	oModelxDet:SetValue('B1_MSBLQL' ,'1')
	
EndIf

//manda e-mail
If _lRet
	U_MYCOM04(M->B1_ZZFASE,_cUsuario)
EndIf

oModelxDet:SetValue('B1_ZZVOLTA','2')	

If _lRet
	ConfirmSX8()
EndIf

Return(_lRet)

*Funcao**************************************************************************************************************************************************

Static Function nvlValid()

  Local lValidSB1 := .T.
  Local cValidTIPO := U_MYCFG02("COM000004","001","P")

  //Valida o preenchimento do campo PESO conforme tipo de produto
  If M->B1_TIPO $ cValidTIPO
    If M->B1_PESO <= 0
      lValidSB1 := .F.
      APMsgStop(U_MYCFG02("COM000004","001","H"),"A010TOK")
    EndIf
  EndIf

Return lValidSB1
