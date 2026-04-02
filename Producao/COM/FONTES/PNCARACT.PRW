//Bibliotecas
#Include "Protheus.ch"

User Function PNCARACT()
    Local aArea       := GetArea()
    Local cCampo      := ReadVar()
    Local cConteudo   := &(cCampo)
    //Variavel Local de Controle
    Local aCarc_Esp := {}
    Local nX := 0

    //Imputa os Caracteres Especiais no Array de Controle
    AADD(aCarc_Esp,{"!", "Exclamacao"})
    AADD(aCarc_Esp,{"@", "Arroba"})
    AADD(aCarc_Esp,{"#", "Sustenido"})
    AADD(aCarc_Esp,{"$", "Cifrao"})
    AADD(aCarc_Esp,{"%", "Porcentagem"})
    AADD(aCarc_Esp,{"*", "Asterisco"})
    AADD(aCarc_Esp,{"/", "Barra"})
    AADD(aCarc_Esp,{"(", "Parentese"})
    AADD(aCarc_Esp,{")", "Parentese"})
    AADD(aCarc_Esp,{"+", "Mais"})
    AADD(aCarc_Esp,{"¨", ""})
    AADD(aCarc_Esp,{"=", "Igual"})
    AADD(aCarc_Esp,{"~", "Til"})
    AADD(aCarc_Esp,{"^", "Circunflexo"})
    AADD(aCarc_Esp,{"]", "Chave"})
    AADD(aCarc_Esp,{"[", "Chave"})
    AADD(aCarc_Esp,{"{", "Colchete"})
    AADD(aCarc_Esp,{"}", "Colchete"})
    AADD(aCarc_Esp,{";", "Ponto e Virgula"})
    AADD(aCarc_Esp,{":", "Dois Pontos"})
    AADD(aCarc_Esp,{">", "Maior"})
    AADD(aCarc_Esp,{"<", "Menor"})
    AADD(aCarc_Esp,{"?", "Interrogacao"})
    AADD(aCarc_Esp,{"_", "Underline"})
    AADD(aCarc_Esp,{",", "Virgula"})
    AADD(aCarc_Esp,{" ", "Espaco"})
    AADD(aCarc_Esp,{"‘", "Aspas"})

    //Executa o Laco ate o Tamanho Total do Array
    For nX:= 1 to Len(aCarc_Esp)
        //Verifica se Algum dos Caracteres Especiais foi Digitado
        If At(aCarc_Esp[nX,1], AllTrim(cConteudo)) <> 0
            //Se Sim Emite uma Mensagem
            MsgStop("Caractere não permitido na inclusão ou alteração: " + aCarc_Esp[nX,1] + " (" + aCarc_Esp[nX,2] + ") ")
            //Nao Permite a Saida do Campo, Ate Retirar o Caracter Especial
            Return .F.
        EndIf
    Next                     

    RestArea(aArea)

Return .T.
