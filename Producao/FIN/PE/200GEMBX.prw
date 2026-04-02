#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : 200GEMBX.prw               | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 25/10/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: PONTO DE ENTRADA: Tratará os valores dos títulos na rotina de      |\
/|                             retorno da comunicação bancária.                  |\ 
/|                                                                               |\ 
/|FONTES: FINA740.prx que chama o fonte FINA200.prx                              |\ 
/|                                                                               |\ 
/|OBSERVACAO: USADO O P.E. PARA ALTERAR A DATA DA BAIXA/CREDITO                  |\ 
/|            QUANDO O PARAMETRO (MV_PAR17 - CUSTOMIZADO PELA NOVEL) ESTIVER SIM |\ 
/|            AS VARIAVEIS PRIVATE dBaixa E dDataCred ASSUME A DATA BASE SISTEMA |\ 
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function 200GEMBX()

  Local aReturn := PARAMIXB[1]
  
  If MV_PAR17 <> 2
    dBaixa := dDataBase
    dDataCred:= dDataBase 
  EndIf

Return aReturn
