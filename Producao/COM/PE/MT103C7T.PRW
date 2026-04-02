#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MT103C7T.prw    | Autor : Leandro Ferreira     | Data : 15/01/2023 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: TAMANHO DA TELA DE SELEÇÃO DE ITENS DO PEDIDO                      |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 09/11/2022  Leandro Ferreira          Jaqueline Chen  Ficar maior o para ver logo a observação   

User Function MT103C7T()

Local nLinIni := PARAMIXB[1,1] // Posicao inicial da linha da janela default 30
Local nColIni := PARAMIXB[1,2] // Posicao inicial da coluna da janela default 20
Local nLinFim := PARAMIXB[1,3] // Posicao final da linha da janela default 270
Local nColFim := PARAMIXB[1,4] // Posicao final da coluna da janela default 531
Local aRet := {}

	nLinFim := 270
	nColFim := 1300
	aRet := {nLinIni,nColIni,nLinFim,nColFim}

Return aRet
