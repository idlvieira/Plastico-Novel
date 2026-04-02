/* Includes / Defines */
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ A120PIDF ³ Autor ³ Messias R. Rodrigues  ³ Data ³ 21.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Evita a utilizacao do Set Filter no procedimento normal    ³±±
±±³          ³ da Microsiga (nao usa query) ao teclar F4 no Pedido de     ³±±
±±³          ³ Compra (MATA121), nao ocasionando assim problema de        ³±±
±±³          ³ performance.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico PAPIRUS - COMPRAS                               ³±±
±±³          ³ Rotina chamada em MATA121                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*/{Protheus.doc} A120PIDF
O Ponto de Entrada está localizado na função A120PID(), responsável pela carga das Solicitações de Compras / Contratos de Parceria (Inteira) para o Pedido de Compras / Autorização de Entrega.
O Ponto de Entrada se encontra no início da função e permite executar um filtro nas tabelas SC1 - Solicitações de Compras.
Sintaxe
A120PIDF - Exclui Filtro nas tabelas SC1 ( ) --> ExpA1
Retorno
ExpA1(vetor)
Retorna o array com o filtro da tabela SC1- Solicitação de Compras customizado. A expressão do filtro a ser retornado deve ser em sintaxe xBase.
@type function
@version 1.00  
@author celso.costa
@since 18/05/2022
@return variant, Filtro
/*/
User Function A120PIDF()

    /* Variaveis Locais */
    Local _aFiltro  := {}
    Local _cFiltro  := 'C1_FILIAL == "'+xFilial('SC1')+'".And. C1_QUJE < C1_QUANT .And. C1_TPOP<>"P" .And. C1_APROV$" ,L" .And.( AllTrim( C1_COTACAO ) == "IMPORT" .Or. C1_COTACAO == "'+Space(Len(SC1->C1_COTACAO))+'" .Or. C1_COTACAO == "'+Replicate("X",Len(SC1->C1_COTACAO))+'")'+IIF(SC1->(FieldPos("C1_FLAGGCT"))>0.And.nTipoPed!=2,' .And. ((SC1->C1_QUJE > 0 .And. SC1->C1_FLAGGCT == " ") .Or. (SC1->C1_QUJE == 0 )) .And. SC1->C1_RESIDUO != "S"','')

    /* Monta filtro */
    _aFiltro := { _cFiltro }

Return( _aFiltro )
