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
±±º          ³ A tabela ZZZ sao parametrizacoes personalidas Grupo Myers  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MYCFG00()

Private cCadastro 	:= "Tabela de Parametrizações Personalizada"
Private cAlias	  	:= "ZZZ"
Private aRotina   	:= {{"Pesquisar" ,'AxPesqui',0,1},;
						{"Visualizar","AxVisual",0,2},;
		                {"Incluir"   ,"AxInclui",0,3},;
		                {"Alterar"   ,"AxAltera",0,4},;
		                {"Excluir"   ,"AxDeleta",0,5},;
		                {"Legenda"   ,"U_MYCFG00A",0,8}}
Private aCores    	:= {{"ZZZ->ZZZ_MSBLQL=='2'","BR_VERDE"},{"ZZZ->ZZZ_MSBLQL=='1'","BR_VERMELHO"}}
Private aIndex 		:= {}
Private cUser		:=	ALLTRIM(USRRETNAME(RETCODUSR()))
Private cFiltro		:=	""		                
Private bFiltraBrw 	:= { || FilBrowse( cAlias , @aIndex , @cFiltro ) } 

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGotop()   
	
	aIndZZZ   := {}
	cFilZZZ   := ""

               cFilZZZ   := If(Empty(cFilZZZ),".T.",cFilZZZ)
               
               cCondicao := ""
            
          bFiltraBrw := {|| FilBrowse("ZZZ",aIndZZZ,@cCondicao) }
          Eval(bFiltraBrw)
 
     dbSelectArea("ZZZ")
     mBrowse( 7, 4,20,74,"ZZZ",,,,,,)
	
Return(Nil)

User Function MYCFG00A()

Private aLeg := {{"BR_VERDE" , "Ativa"},{"BR_VERMELHO" , "Bloqueada"}}

	BrwLegenda(_cCadastro, "Status", aLeg)
	
Return .T. 
