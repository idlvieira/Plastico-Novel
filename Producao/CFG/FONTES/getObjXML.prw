#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : getObjXML.prw              | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 01/04/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina para leitura do XML                                         |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */

User Function getObjXML(lEscolhe,nOpc,dirORfile,lExclui)

  Local cError   := ""
  Local cWarning := ""
  Local cFile    := ""
  Local oXml     := NIl 
  Local cMascara  := "*.xml|*.xml"
  Local cTitulo   := "Arquivos (XML)"
  Local nMascpad  := 1 //0 //1
  Local cDirini   := IIF(lEscolhe, dirORfile, "")
  Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
  Local nOpcoes   := IIF(lEscolhe, nOpc, "") 
  Local lArvore   := .T. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/

  //Caso escolhe abre a tela padrão, senão abre o arquivo enviado
  If lEscolhe
    cFile := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes) 
  Else
    cFile := dirORfile
  EndIf 
    
  If Empty(cFile)
    APMsgStop("Não informado o arquivo XML","getObjXML")
    Return NIL
  EndIf

  //Gera o Objeto XML
  oXml := XmlParserFile( cFile, "_", @cError, @cWarning )
  
  If !Empty(cError)
    Aviso("XML",cError,{"OK"},3,"Erro")
    Return NIL
  ElseIf !Empty(cWarning)
    Aviso("XML",cWarning,{"OK"},3,"Alerta")
    Return NIL
  EndIf

  If lExclui
    FERASE(cFile)
  EndIf

Return oXml


