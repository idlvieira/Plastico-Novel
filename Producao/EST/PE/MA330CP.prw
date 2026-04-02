#Include "Protheus.ch"

/*/{Protheus.doc} MA330CP
Localizado nas rotinas de processamento de custo em partes.
O Recalculo do custo medio possibilita dividir o custo de produtos fabricados em mais de uma parte,
facilitando a visualização da composição de custos dos produtos acabados.
O sistema permite dividir o custo de produtos fabricados em até 99 partes diferentes, cada parte 
nas 5 moedas padroes. Atraves deste ponto de entrada, pode-se definir as regras que irao
classificar cada materia-prima em uma parte do custo. O numero de partes e sempre acrescido
de mais uma parte que contempla os materiais que nao se encontram em nenhuma regra.
Essa funcao e responsavel pela montagem do mBrowse e suas opcoes
Programa Fonte: MATA330.PRX
Sintaxe: MA330CP - Define regras para classificacao de materia-prima ( ) --> aRegrasCP
@type		user function
@author  	TI9 Celso Costa
@version 	P12
@since   	17/12/2021
@return		aRegrasCP
/*/
User Function MA330CP()

// Variaveis Locais
Local aRegraCP := {}

// Definicao das regras de separacao
aAdd( aRegraCP, "SB1->B1_SCTPPAR == 'MPE'" )
aAdd( aRegraCP, "SB1->B1_SCTPPAR == 'MPI'" )
aAdd( aRegraCP, "SB1->B1_SCTPPAR == 'MEB'" )
aAdd( aRegraCP, "SB1->B1_SCTPPAR == 'MOD'" )
aAdd( aRegraCP, "SB1->B1_SCTPPAR == 'MOI'" )
aAdd( aRegraCP, "SB1->B1_SCTPPAR == 'GGF'" )
aAdd( aRegraCP, "SB1->B1_SCTPPAR == 'DPR'" )

Return ( aRegraCP )
