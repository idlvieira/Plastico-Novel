#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MYCFG   º Autor ³ Sonia Silva         º Data ³ 07/11/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela da Tabela de Parametrização Personalizada             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Este fonte e a tela de cadastramento da tabela ZZZ         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MYCFG01()

Private	cCadastro 	:= "Tabela de Parametrizações Personalizada"
		cAlias	  	:= "ZZZ"
		aCores    	:= {{"ZZZ->ZZZ_MSBLQL=='2'","BR_VERDE"},{"ZZZ->ZZZ_MSBLQL=='1'","BR_VERMELHO"}}
		aRotina   	:= {{"Pesquisar" ,'AxPesqui',0,1},;
						{"Visualizar","AxVisual",0,2},;
		                {"Incluir"   ,"AxInclui",0,3},;
		                {"Alterar"   ,"AxAltera",0,4},;
		                {"Excluir"   ,"AxDeleta",0,5},;
		                {"Legenda"   ,"U_MYCFG01A",0,8}}
		              
	mBrowse(6, 1, 22, 75, 'ZZZ',,,,,, aCores)
		
Return    

User Function MYCFG01A()

Local aLeg := {{"BR_VERDE" , "Ativa"},{"BR_VERMELHO" , "Bloqueada"}}

	BrwLegenda(_cCadastro, "Status", aLeg)
	
Return .T. 
