#Include 'Protheus.ch'

User Function MYCOM07()
 Local oReport
 Private cPerg   :=  "MYCOM07"
 ValidPerg(@cPerg)   
 Pergunte(cPerg,.t.)
 oReport:= ReportDef()
 oReport:PrintDialog()
 
      
 
 
Return

Static Function ReportDef()
Local cAlias:= GetNextAlias() // Melhores práticas para não ter problemas de abrir um segundo alias com um nome que já existe, 
Local cTitle   := "Relacao de Solicitação de Compras"
Local oReport 
Local oSection1
Private nDIAS:=0
oReport := tReport():New(cPerg,cTitle,cPerg,{ |oReport| ReportPrint(@oReport, cAlias) } , cTitle )
oReport:SetPortrait(.t.) // Retrato
//oReport:SetLandscape(.t.) // Paisagem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1:= TRSection():New(oReport,"SOLICITAÇÃO DE COMPRAS",{"SC1","SC7"},/*aOrdem*/)
oSection1:SetHeaderPage(.T.)

TRCell():New(oSection1,"NUMSC"    ,,"Num. Solicitação",/*Picture*/,TamSX3("C1_NUM")[1]+4,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DESCRICAO",,"Descrição",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"ITEM",,"Item",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1,"EMISSAOSC",,"Dt. Emissao Solic.",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NECESSIDADE"   ,,"Dt. Necessidade",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NUMPEDIDO"   ,,"Num. Pedido Compra",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"PEDIDO"     ,,"Dt. Pedido Compra",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"nDIAS"     ,,"Dias",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("NUMSC"  ):SetBlock({ || (cAlias)->NUMSC  })
oSection1:Cell("DESCRICAO"  ):SetBlock({ || (cAlias)->DESCRICAO  })    
oSection1:Cell("ITEM"  ):SetBlock({ || (cAlias)->ITEM  })
oSection1:Cell("EMISSAOSC"  ):SetBlock({ || (cAlias)->EMISSAOSC  })
oSection1:Cell("NECESSIDADE"  ):SetBlock({ || (cAlias)->NECESSIDADE  })
oSection1:Cell("NUMPEDIDO"  ):SetBlock({ || (cAlias)->NUMPEDIDO  })
oSection1:Cell("PEDIDO"  ):SetBlock({ || (cAlias)->PEDIDO  })
oSection1:Cell("nDIAS"  ):SetBlock({ || nDIAS  })


// Alinha o Conteudo da celula C1_NUMERO para a direita, como se fosse um valor (R$)
//oSection1:Cell("C1_NUMERO" ):SetHeaderAlign("RIGHT")
RETURN (oReport)

// FUNÇÃO DE IMPRESSÃO DO RELATÓRIO

STATIC FUNCTION ReportPrint(oReport, cAlias)

                // Criar Variavel para armazenar o nome da tabela/Alias da Query SQL


// Indico que a Sessão 1 tem uma query, e inicia a partir daqui
oReport:Section(1):BeginQuery()
// Sintaxe tipo Embedded SQL, novo formato para executar consultas via query no ADVPL 
BeginSQL Alias cAlias // Inicia a Sintaxe SQL para criar um alias guardado na variavel cAlias                                      
SELECT C1_FILIAL,C1_NUM AS NUMSC,C1_DESCRI AS DESCRICAO,C1_ITEM AS ITEM, C1_EMISSAO AS EMISSAOSC,C1_DATPRF AS NECESSIDADE,C1_PEDIDO AS NUMPEDIDO,C7_EMISSAO AS PEDIDO 
                                
      FROM %table:SC1% SC1
      LEFT JOIN %table:SC7% SC7 on // Quando informamos algo entre %% é que o ADVPL irá fazer algo para transformar em SQL, neste table:SD1, ele vai retornar o nome verdadeiro da tabela para qual corresponde na empresa que você logou, ex: SD1010, ou SD1990
      C7_FILIAL = %xFilial:SC7% AND 
      C7_NUMSC = C1_NUM AND
      C7_ITEMSC = C1_ITEM AND
      SC7.%NotDel% // O notdel faz automaticamente a sintaxe usada para eliminar da consulta os registros deletados logicamente, D_E_L_E_T_=' '          
      WHERE C1_FILIAL = %xFilial:SC1% AND // aqui o XFilial:SD1, vai trazer a filial correspondete a tabela SD1
      (C1_NUM >= %Exp:mv_par01% AND // Você deve usar o EXP: sempre que quiser utilizar uma variável que não é da sintaxe SQL
      C1_NUM <= %Exp:mv_par02%) AND // Além de usar uma variavel externa, estamos usando uma função ADVPL para converter Data para String (DtoS)
      (C1_EMISSAO >= %Exp:Dtos(mv_par03)% AND // Você deve usar o EXP: sempre que quiser utilizar uma variável que não é da sintaxe SQL
      C1_EMISSAO <= %Exp:Dtos(mv_par04)%) AND // Além de usar uma variavel externa, estamos usando uma função ADVPL para converter Data para String (DtoS)
      SC1.%NotDel% // O notdel faz automaticamente a sintaxe usada para eliminar da consulta os registros deletados logicamente, D_E_L_E_T_=' '
      Order by C1_NUM, C1_ITEM
      
EndSQL // Finaliza a query Embedded SQL
//GETLASTQUERY()[2]
oReport:Section(1):EndQuery()      // Diz que nossa Sessão já tem sua query finalizada                                         

//Transformamos o campo D1_EMISSAO que no banco de dados é um texto no formado AAAAMMDD para o tipo data no formado DD/MM/AAAA
TCSETFIELD(cAlias,"EMISSAOSC","D") 
TCSETFIELD(cAlias,"NECESSIDADE","D")  
TCSETFIELD(cAlias,"PEDIDO","D")                             
                
oReport:SetMeter((cAlias)->(LastRec()))
                
//Inicializa a impressão da Sessão 1, com os cabeçalhos
oReport:Section(1):Init()
//Estrutura de repetição While
While !oReport:Cancel() .And. !(cAlias)->(Eof()) // Enquanto o Relatório não for cancelado e a Query não for EOF(End of file), ou seja, que ela foi totalmente percorrida 
//Incrementa o medidor de progresso do relatório
	oReport:IncMeter()
	If oReport:Cancel() // Quando o botão cancelar for clicado.
		Exit
	EndIf
	If Empty((cAlias)->PEDIDO)
	nDias:=0
	else
 	nDias:=DateDiffDay((cAlias)->PEDIDO, (cAlias)->EMISSAOSC)   
 	endif            
   oReport:Section(1):PrintLine() // imprime a linha do relatório conforme os blocos de código que criamos para cada celula
 //  oReport:PrintText("Nao ha' solicitações de compra colocado",,oReport:Section(1):Cell("C1_NUM"):ColPos()) // se quiser imprimir um texto qualquer em uma determinada coluna
                               
   (cAlias)->(dbSkip()) //para seguir para a proxima linha da Query
EndDo
                
//Finaliza a sessão 1
oReport:Section(1):Finish()
//Finaliza a Páagina
oReport:EndPage(.T.)
     
// Fecha / Destroi a consulta feita para liberar memória
(cAlias)->(dbCloseArea())       
                
RETURN()


Static Function ValidPerg(cPerg)

 /*
 Parâmetros/Elementos
 Nome  Tipo  Descrição Obrigatório Referência
 cGrupo  Caracter Nome do grupo de pergunta  X
 cOrdem  Caracter Ordem de apresentação das perguntas na tela  X
 cPergunt Caracter Texto da pergunta a ser apresentado na tela  X
 cPergSpa Caracter Texto em espanhol da pergunta a ser apresentado na tela.  X
 cPergEng Caracter Texto em inglês da pergunta a ser apresentado na tela.  X
 cVar  Caracter Variável do item  X
 cTipo  Caracter Tipo do conteúdo de resposta da pergunta.  X
 nTamanho Numérico Tamanho do campo para resposta  X
 nDecimal Numérico Número de casas decimais da resposta, se houver
 nPreSel  Numérico Valor que define qual o item do combo estará selecionado na apresentação da tela. Este parâmetro somente deverá ser preenchido quando o parâmetro cGSC for preenchido com "C".
 cGSC  Caracter Estilo de apresentação da pergunta na tela: - "G" - formato que permite editar o conteúdo da pergunta. - "S" - formato de texto que não permite alteração. - "C" - formato que permite a seleção de dados para a pergunta.  X
 cValid  Caracter Validação do item de pergunta
 cF3   Caracter Nome da consulta F3 que poderá ser acionada pela pergunta.
 cGrpSXG  Caracter Código do grupo de campos relacionado a pergunta.
 cPyme  Caracter Define se a pergunta poderá ser apresentada em aplicações do tipo Express.
 cVar01  Caracter Nome do MV_PAR para a utilização nos programas.  X
 cDef01  Caracter Conteúdo em português do primeiro item do objeto, caso seja do tipo Combo.
 cDefSpa1 Caracter Conteúdo em espanhol do primeiro item do objeto, caso seja do tipo Combo.
 cDefEng1 Caracter Conteúdo em inglês do primeiro item do objeto, caso seja do tipo Combo.
 cCnt01  Caracter Conteúdo padrão da pergunta.
 cDef02  Caracter Conteúdo em português do segundo item do objeto, caso seja do tipo Combo.
 cDefSpa2 Caracter Conteúdo em espanhol do segundo item do objeto, caso seja do tipo Combo.
 cDefEng2 Caracter Conteúdo em inglês do segundo item do objeto, caso seja do tipo Combo.
 cDef03  Caracter Conteúdo em português do terceiro item do objeto, caso seja do tipo Combo.
 cDefSpa3 Caracter Conteúdo em espanhol do terceiro item do objeto, caso seja do tipo Combo.
 cDefEng3 Caracter Conteúdo em inglês do terceiro item do objeto, caso seja do tipo Combo.
 cDef04  Caracter Conteúdo em português do quarto item do objeto, caso seja do tipo Combo.
 cDefSpa4 Caracter Conteúdo em espanhol do quarto item do objeto, caso seja do tipo Combo.
 cDefEng4 Caracter Conteúdo em inglês do quarto item do objeto, caso seja do tipo Combo.
 cDef05  Caracter Conteúdo em português do quinto item do objeto, caso seja do tipo Combo.
 cDefSpa5 Caracter Conteúdo em espanhol do quinto item do objeto, caso seja do tipo Combo.
 cDefEng5 Caracter Conteúdo em inglês do quinto item do objeto, caso seja do tipo Combo.
 aHelpPor Vetor  Help descritivo da pergunta em Português.
 aHelpEng Vetor  Help descritivo da pergunta em Inglês.
 aHelpSpa Vetor  Help descritivo da pergunta em Espanhol.
 cHelp  Caracter Nome do help equivalente, caso já exista um no sistema.
 */

 PutSX1(cPerg/*cGrupo*/,'01'/*cOrdem*/,"Solicitação de?   :"/*cPergunt*/,""/*cPergSpa*/,"?"/*cPergEng*/,"MV_CH01"/*cVar*/,'C'/*cTipo*/,6/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,''/*cValid*/,'SC1'/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR01"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{'Informe o Num da Solicitação.'}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
 PutSX1(cPerg/*cGrupo*/,'02'/*cOrdem*/,"Solicitação até?   :"/*cPergunt*/,""/*cPergSpa*/,"?"/*cPergEng*/,"MV_CH02"/*cVar*/,'C'/*cTipo*/,6/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,''/*cValid*/,'SC1'/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR02"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{'Informe o Num da Solicitação.'}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
 PutSX1(cPerg/*cGrupo*/,'03'/*cOrdem*/,"Data de?  :"/*cPergunt*/,""/*cPergSpa*/,"?"/*cPergEng*/,"MV_CH03"/*cVar*/,'D'/*cTipo*/,8/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,''/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR03"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{'Informe a data da Solicitação.'}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
 PutSX1(cPerg/*cGrupo*/,'04'/*cOrdem*/,"Data até?  :"/*cPergunt*/,""/*cPergSpa*/,"?"/*cPergEng*/,"MV_CH04"/*cVar*/,'D'/*cTipo*/,8/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,''/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR04"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{'Informe a data da Solicitação.'}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )

Return