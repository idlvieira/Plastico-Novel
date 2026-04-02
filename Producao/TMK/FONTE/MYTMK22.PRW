#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"


/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYTMK22.PRW                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 14/06/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Copia a fotos do diretornio mapeado da rede para pasta de fote no  |\
/|            servidor do Protheus, para que seja usado no e-mail do orcamento   |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */
//

User Function MYTMK22()

  Local aAuxArq := {}
  Local cErro   := ""
  Local cPstCli := GetMV("MYTMK22C")
  Local cPstSrv := GetMV("MYTMK22S")

  aAuxArq := Directory(cPstCli+"Protheus\*.JPG", "D")

  If Len(aAuxArq) > 0 
    For kkq:=1 to Len(aAuxArq)
      // Copia arquivos do remote local para o servidor, sem compactar antes de transmitir
      If CpyT2S(cPstCli+"Protheus\"+aAuxArq[kkq,1], cPstSrv, .F. )
        // Copia arquivos do servidor para o remote local, sem compactar antes de transmitir
        If ! CpyS2T(cPstSrv+"\"+aAuxArq[kkq,1], cPstCli+"Fotos", .F. )
          cErro := "Não foi possivel atualizar a pasta Foto na rede de backup"
        EndIf
      Else
        cErro := "Não foi possivel atualizar a pasta Foto no Servidor do Protheus" 
      EndIf
      If Empty(cErro)
        FERASE(cPstCli+"Protheus\"+aAuxArq[kkq,1])
        Aviso("Fotos para Orçamento","Pasta atualizada",{"ok"},1,"Novel")
      Else
        APMsgStop(cErro,"MYTMK22")
      EndIf
    Next
  Else
    APMsgStop("Não foi encontrado a unidade ou arquivo na pasta ("+cPstCli+"Protheus\*.JPG)","MYTMK22")
  EndIf
Return