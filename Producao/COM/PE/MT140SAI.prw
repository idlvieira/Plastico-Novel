#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} MT140SAI
    Descrição:
    LOCALIZAÇÃO : Function A140NFiscal() - Responsável por controlar a interface de um pre-documento de entrada.

    EM QUE PONTO : Ponto de entrada disparado antes do retorno da rotina ao browse.
    Dessa forma, a tabela SF1 pode ser reposicionada antes do retorno ao browse.

    Programa Fonte
    MATA140.PRW

    @type function
    @version 1.0
    @author Marcos Bortoluci
    @since 09/03/2021
/*/
USER FUNCTION MT140SAI()
    Local nOper     := PARAMIXB[1] // Numero da operação - ( 2-Visualização, 3-Inclusão, 4-Alteração, 5-Exclusão )
    Local cNumDoc   := PARAMIXB[2] // Número da nota
    Local cNumSerie := PARAMIXB[3] // Série da nota
    Local cFornece  := PARAMIXB[4] // Fornecedor
    Local cLoja     := PARAMIXB[5] // Loja
    Local cTipoNF   := PARAMIXB[6] // Tipo da Nota
    Local nOpcSel   := PARAMIXB[7] // Opção de Confirmação (1 = Confirma pré-nota; 0 = Não Confirma pré-nota)

    Local cFiltro   := ""
    Local lProcessa := .F.
    Local _aArea    := GetArea()

    If nOper == 3 .And. Upper( AllTrim( FunName() ) ) != "MATA140"  // Inclusão da Pré Nota
        if nOpcSel == 1 // Confirmou a tela
            SF1->(dbSetOrder(1))   

            if SF1->(MsSeek(xFilial("SF1") + cNumDoc + cNumSerie + cFornece + cLoja ) )
                MATR170( "SF1", SF1->( Recno() ), nOper )
            endIF
        endIf
    EndIf
    
RestArea( _aArea )

Return( NIL )
