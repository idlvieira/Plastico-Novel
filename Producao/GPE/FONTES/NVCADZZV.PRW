#INCLUDE "rwmake.ch"
#INCLUDE 'TOTVS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NVCADZZV บ Autor ณ Cristina Iabuki   บ Data ณ 15/02/2023   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina responsavel pelo Cadastro de dos emails por centro  บฑฑ
ฑฑบ          ณ centro de custo                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 								                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
01/02/2023 - Cristina Iabuki - Criado o campo ZZV_MATR para tratar ou Centro
							   de Custo ou Matricula, criado U_FTudZZV()
/*/
User Function NVCADZZV()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cCadastro 	:= "Cadastro de E-mails responsaveis pelo Ponto Eletronico"
Private aButtons 	:={}
Private aRotina		:={}
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString  := "ZZV"

aAdd( aButtons, { "NOTE", {|| U_FMostraZZV() }	, "Consulta Emails"	, "Consultar Email" } )

aRotina := 			{{"Pesquisar"		,"AxPesqui"		,0,1} ,;
					{"Visualizar"		,"AxVisual"		,0,2} ,;
					{"Incluir"			,"AxInclui('ZZV',,3,,,, 'U_FTudZZV()' )"		,0,3} ,;
					{"Alterar"			,"AxAltera('ZZV',,4,,,,,'U_FTudZZV()',,, aButtons,,,,)"	,0,4} ,;
					{"Excluir"			,"AxDeleta"		,0,5} ,;
					{"Bloquear todos"	,"U_FZZVBloq"	,0,5} ,;
					{"Desbloquear todos","U_FZZVDBloq"	,0,5}}


dbSelectArea("ZZV")
dbSetOrder(1)

aSize := MsAdvSize(.T.)
mBrowse( aSize[1],aSize[2],aSize[3],aSize[4],"ZZV" )

Return


// Bloqueia todos os centros de custos para nao enviar email
User Function FZZVBloq()
Local cQuery:= ""

cQuery := " UPDATE " +RetSqlName("ZZV")			
cQuery += " SET ZZV_MSBLQL = '1' "

If TcSQLExec(cQuery) < 0
	cMsg := TcSQLError()
	MsgStop(cMsg, "VALIDAวรO")
Endif

Return Nil

// Desbloqueia todos os centros de custos para nao enviar email
User Function FZZVDBloq()
Local cQuery:= ""

cQuery := " UPDATE " +RetSqlName("ZZV")			
cQuery += " SET ZZV_MSBLQL = '2' "

If TcSQLExec(cQuery) < 0
	cMsg := TcSQLError()
	MsgStop(cMsg, "VALIDAวรO")
Endif

Return Nil


User Function FMostraZZV()

Local cTexto	:= Alltrim(ZZV->ZZV_EMAIL1)+Alltrim(ZZV->ZZV_EMAIL2)
Local nDe 		:= 0
Local nAte		:= Len(cTexto)
Local nAchou	:= 0      
Local cMostra	:= ""   

While .T.
	nAchou	:= At(";",Substr(cTexto,nDe+1,nAte))
	If	nAchou <= 0
		Exit
	EndIf
	nAchou  := nAchou
	cMostra	+= Substr(cTexto,nDe,nAchou-1) + Chr(13) + chr(10)

	nDe	+= (nAchou+1)
	
EndDo         

Define Font oFont NAME "Arial" SIZE 1, -12 BOLD

Define MsDialog oDlg Title "E-mails" From 3, 0 to 440, 517 PIXEL

@ 5, 5 Get oMemo Var cMostra Memo Size 245, 185 FONT oFont Of oDlg PIXEL
oMemo:bRClicked := { || AllwaysTrue() }
oMemo:oFont     := oFont

Define SButton From 200, 175 Type  1 Action oDlg:End() Enable Of oDlg PIXEL  // Apaga 

Activate MsDialog oDlg Center

Return( Nil )

// Funcao de tudo ok ao salvar os dados
User Function FTudZZV()
Local lRet :=.T.

If 	Empty(M->ZZV_CC) .And. Empty(M->ZZV_MATR)
	Aviso("Atencao","Os campos Centro de Custo ou Matricula devem ser preenchidos. Verifique.",{"Ok"})
	lRet := .F.
EndIf 

If 	!Empty(M->ZZV_CC) .And. !Empty(M->ZZV_MATR)
	Aviso("Atencao","Os campos Centro de Custo e Matricula estใo preenchidos. Verifique.",{"Ok"})
	lRet := .F.
EndIf 

Return lRet 
