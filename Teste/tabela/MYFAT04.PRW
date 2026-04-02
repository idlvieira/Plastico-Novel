#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MYFAT04  บ Autor ณ Newton Reca Alves  บ Data ณ  25/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de tabela de preco automatica                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MYFAT04()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local 	cVldAlt		:= ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local 	cVldExc		:= ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Public 	lAltera		:= ".T."
Private cDelFunc	:= ".T."
Public  cString		:= "DA1"
Public  cPerg		:= "MYFT04"
Private cCadastro 	:= "GERACAO TABELA PRECO"
//_cTrava				:= Getmv("MV_ALTRVOR")
//_cAno				:= TRANSFORM(VAL(Getmv("MV_ALANOOR")),"9999")

Private nSeq		:= 0
                                              


//Chama a pergunta da Versao

CriarPerg()

If Pergunte(cPerg,.T.)

	nSeq		:= Val(SubStr(MV_PAR07,2,2))    
    dbSelectArea("SX5")
    SX5->(dbSetOrder(1))
    SX5->(dbSeek(xFilial("SX5")+"ZZ"))
    While X5_FILIAL+X5_TABELA == xFilial("SX5")+"ZZ"
		Processa( {||MYFAT04_P1()},"Aguarde. Criando Tabelas...")
	nSeq++
	SX5->(dbSkip())
	EndDo
EndIf


Return()





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFAT04_P1บAutor  ณ NEWTON RECA ALVES  บ Data ณ  25/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CHAMADA DE MENU                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



Static Function MYFAT04_P1()
                  
local cTabela 	:= SubStr(MV_PAR07,1,1)+StrZero(nSeq,2)
local cDesc		:= "" 

DBSelectArea("SB1")
DbSetOrder(1)


//Busca os funcionarios do Orcamento
_cEmp1	:= "SB1" + substr(CNUMEMP,1,2) + "0"
cQuery	:= " SELECT B1_FILIAL, B1_COD, B1_PRV1, B1_CUSTD FROM "+_cEmp1+" WHERE D_E_L_E_T_<>'*' AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND B1_TIPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND B1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
TCQuery cQuery NEW ALIAS "_query"
TCsqlExec(cQuery)
DBSelectArea("_query")
DBGoTop()

DBSelectArea("DA0")
DBSetOrder(1)
If DBSeek(xFilial("DA0")+cTabela)
	Alert("Tabela ja Existe, escolha outro codigo")
	DBSelectArea("_query")
	DBCloseArea()
	Return 
EndIf

If SubStr(SX5->X5_CHAVE,1,1) == "C"
	cDesc := " Contribuinte "+cValToChar(Val(SubStr(SX5->X5_CHAVE,2,2)))+"%"
Else
	cDesc := " Outros "+cValToChar(Val(SubStr(SX5->X5_CHAVE,2,2)))+"%"
EndIf

RecLock("DA0",.T.)
DA0->DA0_CODTAB	:= cTabela
DA0->DA0_DESCRI	:= rtrim(MV_PAR08)+cDesc
DA0->DA0_DATDE	:= DDATABASE
DA0->DA0_HORADE	:= TIME()
DA0->DA0_DATATE	:= MV_PAR13
DA0->DA0_HORATE	:= TIME()
DA0->DA0_TPHORA	:= "1"
DA0->DA0_ATIVO	:= "1"
DA0->DA0_MYTPTB := Alltrim(SX5->X5_CHAVE)
MsUnLock()

_cEstado	:= ""
_nPreco		:= 0
_nItem		:= 1
_cItem		:= STRZERO(_nItem,4)
_cTaxaInd	:= Substr(DA0->DA0_MYTPTB,2,2)
_nTxICMS	:= SX5->X5_DESCRI


DBSelectArea("_query")
While _query->(!eof())

		
	If Substr(Alltrim(SX5->X5_CHAVE),1,1)=="O"

		_nIndiceProd	:= Posicione("SB1",1,xFilial("SB1")+_QUERY->B1_COD,"B1_IPI")
		_nTxIPI			:= 1
        
		If Substr(Alltrim(SX5->X5_CHAVE),2,2)=="07" .and. _nIndiceProd == 5
			_nTxIPI	:= 1.004196
		ElseIf Substr(Alltrim(SX5->X5_CHAVE),2,2)=="07" .and. _nIndiceProd == 10
			_nTxIPI	:= 1.008429
		ElseIf Substr(Alltrim(SX5->X5_CHAVE),2,2)=="07" .and. _nIndiceProd == 15
			_nTxIPI	:= 1.01272
		ElseIf Substr(Alltrim(SX5->X5_CHAVE),2,2)=="12" .and. _nIndiceProd == 5
			_nTxIPI	:= 1.007678
		ElseIf Substr(Alltrim(SX5->X5_CHAVE),2,2)=="12" .and. _nIndiceProd == 10
			_nTxIPI	:= 1.015474
		ElseIf Substr(Alltrim(SX5->X5_CHAVE),2,2)=="12" .and. _nIndiceProd == 15
			_nTxIPI	:= 1.023392
		ElseIf Substr(Alltrim(SX5->X5_CHAVE),2,2)=="18" .and. _nIndiceProd == 5
			_nTxIPI	:= 1.012526
		ElseIf Substr(Alltrim(SX5->X5_CHAVE),2,2)=="18" .and. _nIndiceProd == 10
			_nTxIPI	:= 1.02537
		ElseIf Substr(Alltrim(SX5->X5_CHAVE),2,2)=="18" .and. _nIndiceProd == 15
			_nTxIPI	:= 1.038544
		EndIf

		//_nNCMProd	:= Posicione("SB1",1,xFilial("SB1")+_QUERY->BB1_COD,"B1_POSIPI")
		_nPreco	:= (_query->B1_CUSTD * (1+(MV_PAR12/100))*(1+(MV_PAR14/100)) *  (Val(_nTxICMS)) * _nTxIPI)

		DBSelectArea("DA1")
		RecLock("DA1",.T.)
		DA1->DA1_ITEM	:= _cItem
		DA1->DA1_CODTAB	:= cTabela
		DA1->DA1_CODPRO	:= _QUERY->B1_COD
		DA1->DA1_PRCVEN	:= _nPreco
		DA1->DA1_ATIVO	:= "1"
		DA1->DA1_FRETE	:= 0
		//DA1->DA1_ESTADO	:= "1" //MV_PAR11
		DA1->DA1_TPOPER	:= "4" //MV_PAR10
		DA1->DA1_MOEDA	:= 1 
		DA1->DA1_DATVIG	:= MV_PAR09
		DA1->DA1_QTDLOT	:= 9999
		MsUnLock()
		
	Else

		_nIndiceProd	:= Posicione("SB1",1,xFilial("SB1")+_QUERY->B1_COD,"B1_IPI")
		_nTxIPI			:= 1
	
		//_nNCMProd	:= Posicione("SB1",1,xFilial("SB1")+_QUERY->BB1_COD,"B1_POSIPI")
		_nPreco	:= (_query->B1_CUSTD * (1+(MV_PAR12/100))*(1+(MV_PAR14/100)) *  (Val(_nTxICMS)) * _nTxIPI)
		
		DBSelectArea("DA1")
		RecLock("DA1",.T.)
		DA1->DA1_ITEM	:= _cItem
		DA1->DA1_CODTAB	:= cTabela
		DA1->DA1_CODPRO	:= _QUERY->B1_COD
		DA1->DA1_PRCVEN	:= _nPreco
		DA1->DA1_ATIVO	:= "1"
		DA1->DA1_FRETE	:= 0
		//DA1->DA1_ESTADO	:= "1" //MV_PAR11
		DA1->DA1_TPOPER	:= "4" //MV_PAR10
		DA1->DA1_MOEDA	:= 1 
		DA1->DA1_DATVIG	:= MV_PAR09
		DA1->DA1_QTDLOT	:= 9999
		MsUnLock()

	EndIf

		
	_QUERY->(DBSkip())
	_nItem++
	_cItem	:= strzero(_nItem,4)
	
EndDo


DBSelectArea("_query")
DBCloseArea()


Return 








/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ CriaPerg บAutor  ณ Newton Reca Alves  บ Data ณ  10/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Criar Pergunta no SX1.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriarPerg()


aRegs :={}
cPerg := PADR(cPerg,6)

_aMV_PAR01 := {}
_aMV_PAR02 := {}
_aMV_PAR03 := {}
_aMV_PAR04 := {}
_aMV_PAR05 := {}
_aMV_PAR06 := {}
_aMV_PAR07 := {}
_aMV_PAR08 := {}
_aMV_PAR09 := {}
_aMV_PAR10 := {}
_aMV_PAR11 := {} 
_aMV_PAR12 := {} 
_aMV_PAR13 := {}
_aMV_PAR14 := {}

Aadd(_aMV_PAR01, "Informe o produto inical da consulta   ")
Aadd(_aMV_PAR02, "Informe o produto final da consulta    ")
Aadd(_aMV_PAR03, "Informe o tipo inicial da consulta     ")
Aadd(_aMV_PAR04, "Informe o tipo final da consulta       ")
Aadd(_aMV_PAR05, "Informe o grupo inicial da consulta    ")
Aadd(_aMV_PAR06, "Informe o grupo final da consulta      ")
Aadd(_aMV_PAR07, "Informe um Codigo para a Tabela        ")
Aadd(_aMV_PAR08, "Informe uma Descricao para a Tabela    ")
Aadd(_aMV_PAR09, "Informe a Data de Vigencia para Tabela ")
Aadd(_aMV_PAR10, "Informe o tipo de operacao da Tabela   ")
Aadd(_aMV_PAR11, "Informe o Estado ou '*' para todos     ")
Aadd(_aMV_PAR12, "Informe a Margem de Lucro.     ") 
Aadd(_aMV_PAR13, "Informe a Data Final da tab. pre็o.     ")
Aadd(_aMV_PAR14, "Informe O Perc de Desp. ADM e Vendas    ")       

//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(cPerg,"01","Produto de?         ","Produto de?         ","Produto de?         ","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","",_aMV_PAR01)
PutSx1(cPerg,"02","Produto Ate?        ","Produto Ate?        ","Produto Ate?        ","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","",_aMV_PAR02)
PutSx1(cPerg,"03","Tipo de?            ","Tipo de?            ","Tipo de?            ","mv_ch3","C",02,0,0,"G","","02","","","mv_par03","","","","","","","","","","","","","","","","",_aMV_PAR03)
PutSx1(cPerg,"04","Tipo ate?           ","Tipo ate?           ","Tipo ate?           ","mv_ch4","C",02,0,0,"G","","02","","","mv_par04","","","","","","","","","","","","","","","","",_aMV_PAR04)
PutSx1(cPerg,"05","Grupo de            ","Grupo de            ","Grupo de            ","mv_ch5","C",04,0,0,"G","","03","","","mv_par05","","","","","","","","","","","","","","","","",_aMV_PAR05)
PutSx1(cPerg,"06","Grupo ate           ","Grupo ate           ","Grupo ate           ","mv_ch6","C",04,0,0,"G","","03","","","mv_par06","","","","","","","","","","","","","","","","",_aMV_PAR06)
PutSx1(cPerg,"07","Codigo da Tabela?   ","Codigo da Tabela?   ","Codigo da Tabela?   ","mv_ch7","C",03,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",_aMV_PAR07)
PutSx1(cPerg,"08","Descricao Tabela?   ","Descricao Tabela?   ","Descricao Tabela?   ","mv_ch8","C",50,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",_aMV_PAR08)
PutSx1(cPerg,"09","Vigencia?           ","Vigencia?           ","Vigencia?           ","mv_ch9","D",08,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",_aMV_PAR09)
PutSx1(cPerg,"10","Tipo Operacao?      ","Tipo Operacao?      ","Tipo Operacao?      ","mv_cha","C",02,0,0,"C","","","","","mv_par10","1","1","1","","2","2","2","3","3","3","4","4","4","","","",_aMV_PAR10)
PutSx1(cPerg,"11","Estados?            ","Estados?            ","Estados?            ","mv_chb","C",02,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","",_aMV_PAR11) 
PutSx1(cPerg,"12","Margem %?          ","Margem %?            ","Margem %?            ","mv_chc","N",05,2,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",_aMV_PAR12)
PutSx1(cPerg,"13","Data Limite?           ","Data Limite?           ","Data Limite?           ","mv_chd","D",08,0,0,"G","","","","","mv_par13","","","","","","","","","","","","","","","","",_aMV_PAR13)
PutSx1(cPerg,"14","Desp ADM e Vendas? ","Desp ADM e Vendas?   ","Desp ADM e Vendas?  ","mv_chd","N",05,2,0,"G","","","","","mv_par14","","","","","","","","","","","","","","","","",_aMV_PAR14)

Return()





