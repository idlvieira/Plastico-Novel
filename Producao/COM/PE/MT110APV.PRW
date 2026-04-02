/* Includes/Defines */
#Include "Protheus.CH"

/*/{Protheus.doc} MT110APV
Verifica se usuario pode aprovar/rejeitar Solicitacoes de Compras
@type function
@version 12.1.33  
@author administrator
@since 11/05/2022
@return variant, _lContinua
/*/
User Function MT110APV()

  /* Variaveis Locais */
  Local _lContinua  := .T.
  Local _cComprador := ""
  Local _cBLQ       := ""
  Local _cCPR       := ""
  Local _cIdUser    := RetCodUsr()
  Local _aRetUser   := {}

  /* Informacoes do usuario */
  PswOrder( 01 )
  PswSeek( SC1->C1_ZZCAPRO, .T. )

  _aRetUser := PswRet( 01 )

  _cBLQ := Posicione( "SY1", 03, xFilial( "SY1" ) + _cIdUser, "Y1_MSBLQL" )
  _cCPR := Posicione( "SY1", 03, xFilial( "SY1" ) + _cIdUser, "Y1_USER" )

  /* Validacao */
  _cComprador := Iif( AllTrim( _cBLQ ) != "1" .And. !Empty( _cCPR ), _cCPR, _cComprador )

  If AllTrim( _cIdUser ) != AlLTrim( SC1->C1_ZZCAPRO ) 

    If AllTrim( _cComprador ) != AllTrim( _cIdUser )
      MsgAlert( "Sem acesso! Usuário atual não configurado para aprovar/rejeitar esta Solicitação de Compras." )
      _lContinua  := .F.
    EndIf

  EndIf

Return ( _lContinua )
