#INCLUDE "msobject.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#Include "Fileio.ch"


#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : NVLxFUN.PRW                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 12/06/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Metodos e Funçôes para uso geral nos Fontes                        |\
/|-------------------------------------------------------------------------------|\
/|                                                                               |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */
//
// 


Class NVLxFUN

    //*** Variaveis   
	Data nTReg  as Numeric && Total de registros
	Data nConn  as Numeric && Numero conexao top
	Data lVt100 as Logical && Se coletor
	Data lError as Logical && Se houve erro
	Data nArq   as Numeric && Numero do log

    //*** Metodos	
	Method New(lVt100) Constructor
	Method TcQry(cAlias,cQry,nLog,chge)
	Method TcExec(cQry)
	Method Criain(_cValue)
	Method TcLink(cCString,cServer)
	Method Dialog(cCaption)
	Method LogWrite(cBuff,cToFile,lDisplay)
	Method NoAccent(cTexto)
	Method Destroy() &&Inline Super:Destroy()               
	Method GeraZZN(cFil, dEmissao, cCod, cLocal, cNumSeq, cLote, cDoc)
	Method ExcluiZZN(cFil, dEmissao, cCod, cLocal, cNumSeq, cLote, cDoc)
	Method ValidZZN(cFil, dEmissao, cCod, cLocal, cNumSeq, cLote, cDoc)

	Method ValidUser(cFil, dEmissao, cCod, cLocal, cNumSeq, cLote, cDoc)
EndClass

&& Metodo construtor
Method New(lVt100) Class NVLxFUN
	::lVt100 := lVt100
	::nArq   := 1
Return


&& Metodo para executar consultas sql
&& cAlias - Alias de retorno das informacoes
&& cQry   - Consulta a ser executada
&& nLog   - Gera arquivo com consulta executada
//Method TcQry(cAlias,cQry,nLog,lchange) Class NVLxFUN
Method TcQry(cAlias,cQry,nLog,chge) Class NVLxFUN

	::nTReg := 0
	cQry:=upper(cQry)
	If nLog == 1
		MemoWrit("\Query_Temp\"+funname()+"_"+AllTrim(Str(::nArq))+".sql",cQry)
		::nArq++
	EndIf
	chge:=iif(chge=nil,.t.,chge)
	if chge
		cQry:=ChangeQuery(cQry)
	endif
	if select(cAlias) > 0
		(cAlias)->(dbclosearea())
	endif	
	Tcquery cQry New Alias &cAlias
	count to ::nTReg
	(cAlias)->(dbGotop())
Return

&& Metodo para executar comandos sql
&& cQry - Comando sql a ser executado
Method TcExec(cQry) Class NVLxFUN

	If TCSQLExec(cQry) < 0	  
		If ::lVt100
			VTAlert(TCSQLERROR())
			Conout(FunDesc()+" - "+TCSQLERROR())
		Else
			Aviso(FunDesc(),TCSQLERROR(),{"OK"})
		EndIf
		::lError := .T.		
	Else	
		::lError := .F.
	EndIf

Return

&& Metodo para conectar em base de dados
&& cCString - String de conexao
&& cServer  - Servidor a ser conectado
Method TcLink(cCString,cServer) Class NVLxFUN

	::nConn := TCLink(cCString,cServer)

	If ::nConn < 0
		If ::lVt100
			VTAlert("N?o foi poss?vel conectar ao servidor " + cServer)
			Conout(FunDesc() + " - " + "N?o foi poss?vel conectar ao servidor " + cServer)
		Else
			Aviso(FunDesc(),"N?o foi poss?vel conectar ao servidor " + cServer,{"OK"})
		EndIf
		::lError := .T.		
	Else	
		::lError := .F.
	EndIf

Return

&& Metodo para pegar parametro do tipo data
&& cCaption - Pergunta a ser feita
Method Dialog(cCaption) Class NVLxFUN
Local oDlg,oGet1,oButton,dData

	dData := CtoD(Space(08))

	DEFINE MSDIALOG oDlg FROM 0,0 TO 060,280 PIXEL TITLE cCaption
	@ 010,010 MSGET oGet1 VAR dData SIZE 040,011 OF oDlg PIXEL VALID dData != CtoD(Space(08))
	@ 010,055 BUTTON oButton PROMPT "OK" OF oDlg PIXEL ACTION oDlg:End()
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return dData

&& Metodo para gravar arquivo de log
&& cBuff    - Conteudo a ser gravado no log
&& cToFile  - Nome do arquivo de log
&& lDisplay - Mostra log no notepad
Method LogWrite(cBuff,cToFile,lDisplay) Class NVLxFUN
Local nHdl  := -1

	If File(cToFile)
		nHdl := FOpen(cToFile,1)
		If nHdl >= 0
			FSeek(nHdl,0,2)
		EndIf
	Else
		nHdl := FCreate(cToFile)
	EndIf
	
	If nHdl >= 0
		FWrite(nHdl,cBuff,Len(cBuff))
	EndIf
	
	FClose(nHdl)
	
	If lDisplay
		&& Chumbado pq eh para ser usado so em testes...
		WinExec("Notepad.exe \protheus_data\system\" + cToFile)
	Endif

Return

&& Metodo para retirar acentos do texto enviado
&& cTexto - Texto cujo acentos devem ser retirados
Method NoAccent(cTexto) Class NVLxFUN
	cTexto := StrTran(cTexto,"?","a")
	cTexto := StrTran(cTexto,"?","a") 
	cTexto := StrTran(cTexto,"?","a")
	cTexto := StrTran(cTexto,"?","a")
	cTexto := StrTran(cTexto,"?","a")
	cTexto := StrTran(cTexto,"?","a") 
	cTexto := StrTran(cTexto,"?","a")
	cTexto := StrTran(cTexto,"?","a")
	cTexto := StrTran(cTexto,"?","o")
	cTexto := StrTran(cTexto,"?","o") 
	cTexto := StrTran(cTexto,"?","o")
	cTexto := StrTran(cTexto,"?","o")
	cTexto := StrTran(cTexto,"?","o")
	cTexto := StrTran(cTexto,"?","o") 
	cTexto := StrTran(cTexto,"?","u")
	cTexto := StrTran(cTexto,"?","u")
	cTexto := StrTran(cTexto,"?","u")
	cTexto := StrTran(cTexto,"?","u") 
	cTexto := StrTran(cTexto,"?","i")
	cTexto := StrTran(cTexto,"?","i")
	cTexto := StrTran(cTexto,"?","c")
	cTexto := StrTran(cTexto,"?","c") 
	cTexto := StrTran(cTexto,"?","e")
	cTexto := StrTran(cTexto,"?","e")
	cTexto := StrTran(cTexto,"?","e")
	cTexto := StrTran(cTexto,"?","e") 
	cTexto := StrTran(cTexto,","," ")
	cTexto := StrTran(cTexto,"."," ")
	cTexto := StrTran(cTexto,"?"," ")
	cTexto := StrTran(cTexto,"!"," ") 
	cTexto := StrTran(cTexto,"?"," ")
	cTexto := StrTran(cTexto,"?"," ")
	cTexto := StrTran(cTexto,"*"," ")
	cTexto := StrTran(cTexto,"/"," ") 
	cTexto := StrTran(cTexto,"\"," ")
	cTexto := StrTran(cTexto,"'"," ")
	cTexto := StrTran(cTexto,'"'," ")
Return cTexto

&& Destroi objeto
Method Destroy() Class NVLxFUN
	//Super:Destroy()
Return


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?CRIAIN    ? Autor ? F?bio Jord?o       ? Data ?  04/07/06   ???
????????????????????????????????????????????????????????????????????????????
???Descricao ?Prepara String para ser passada na instrucao In de SQL      ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Geral                                                      ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

Method criain(_cValue, _cManter) class NVLxFUN
Local i:=0
Local _cIn      :=""
Local _nCount   :=1
Local _nlen		:=0
Local _cval     :=""
Local _aResult  :={} 
Local _cManter  := IIF(ValType("_cManter") == "U","",_cManter)
Local _ltype:= valtype(_cValue)== "C"


if _ltype
	_cValue:=Upper(_cValue)
	_nlen:=Len(alltrim(_cValue))
	For i:=1 To _nlen
		_cval:=substring(alltrim(_cValue),i,1)
		if !((_cval >="0" .and. _cval <="9") .or. (_cval >="A" .and. _cval <="Z") .or. _cval==_cManter )
			if (i-_nCount) > 0
				aadd(_aResult,{substring(alltrim(_cValue),_nCount,(i-_nCount))})
			endif
			_nCount:=i+1
		elseif i ==_nlen
			aadd(_aResult,{substring(alltrim(_cValue),_nCount,_nlen)})
		endif
	Next i
	For i:=1 to len(_aResult)
		if (len(_aResult)  == 1) .or. (i==len(_aResult))
			_cIn+="'"+_aResult[i,1]+"'"
			
		elseif len(_aResult) > 1
			_cIn+="'"+_aResult[i,1]+"',"
		endif
	Next i
	If (_nlen < 1)
	  _cIn := "''"
	EndIf
else
	_cIn := "''"
endif    

return _cIn

// Gera os registros na tabela do Armazém Virtual ZZN.
METHOD GeraZZN(cFil, dEmissao, cCod, cLocal, cNumSeq, cLote, cDoc, cRotina) Class NVLxFUN
//GetMV("ZZ_ARMZVIR")

If cLocal $ GetMV("ZZ_ARMZVIR")

  dbSelectArea("ZZN")
  RecLock("ZZN",.T.)
    Replace ZZN->ZZN_FILIAL  With cFilial
    Replace ZZN->ZZN_DATA    With dEmissao
    Replace ZZN->ZZN_COD     With cCod
    Replace ZZN->ZZN_LOCAL   With cLocal
    Replace ZZN->ZZN_NUMSEQ  With cNumSeq
    Replace ZZN->ZZN_LOTECT  With cLote
    Replace ZZN->ZZN_DOC     With cDoc
    Replace ZZN->ZZN_ROTINA  With cRotina
  MsUnlock()

EndIF
   
Return

// Gera os registros na tabela do Armazém Virtual ZZN.
METHOD ExcluiZZN(cFil, dEmissao, cCod, cLocal, cNumSeq, cLote, cDoc, cRotina) Class NVLxFUN
//GetMV("ZZ_ARMZVIR")
//aDirTemp := Separa(GetMv("ZZ_ESTFU02"),"#",.T.)

Local cQuery	:= ""

If cLocal $ GetMV("ZZ_ARMZVIR")
	cQuery	:= " UPDATE "+ RetSqlName("ZZN") +" SET ZZN_ESTORN='S'      "
	cQuery	+= " WHERE D_E_L_E_T_='' AND  ZZN_DATA = '" + DtoS(dEmissao) + "' AND ZZN_COD = '" +cCod+ "' AND "
	cQuery	+= " 	   ZZN_LOCAL ='"+ cLocal +"' AND ZZN_NUMSEQ ='"+cNumSeq+"' AND ZZN_LOTECT = '"+cLote+"'  AND ZZN_DOC = '"+cDoc+"'; "
	
	If TcSQLExec(cQuery) < 0
		Alert("Error : "+ TcSQLError())
	Endif
EndIf
   
Return


// Gera os registros na tabela do Armazém Virtual ZZN.
METHOD ValidZZN(cFil, dEmissao, cCod, cLocal, cNumSeq, cLote, cDoc, cRotina) Class NVLxFUN

  Local __aArea := GetArea()
  Local lValid  	:= .T.

  If cLocal $ (GetMV("ZZ_ARMZVIR"))

	lValid := .F.
	
	cQuery	:= " SELECT COUNT(ZS_LOCAL) QUANT "
	cQuery	+= " FROM "+ RetSqlName("SZS") +" ZS INNER JOIN "+ RetSqlName("SB1") +" B1 ON ZS.D_E_L_E_T_='' AND B1.D_E_L_E_T_='' AND B1.B1_COD = '" + cCod + "'    "
	cQuery	+= " WHERE 	(ZS.ZS_LOCAL ='"+ cLocal +"' OR ZS.ZS_LOCAL ='') AND  "
	cQuery	+= " 		(ZS.ZS_TIPO = B1.B1_TIPO OR ZS.ZS_TIPO ='') AND  "
	cQuery	+= "  	  	('"+ Dtos(DdataBase) +"' <= ZS.ZS_MSBLQD OR ZS.ZS_MSBLQD = '') AND ZS.ZS_MSBLQL != '1' AND "
	cQuery	+= " 	   	(ZS.ZS_GRUPO = B1.B1_ZZPRT1 OR ZS.ZS_GRUPO ='' ) AND ltrim(rtrim(ZS_ROTINA)) = '" +cRotina+ "' AND ZS_USER ='" + Alltrim(__cUserID) + "'; "
	
	cQuery := changeQuery(cQuery)	
	TCQUERY cQuery NEW ALIAS "QZS"
	QZS->(DbGoTop())                      
	
	_Local := ""			
	IF QZS->(!Eof()) .and. QZS->QUANT > 0
		lValid := .T.
	Else 
		lValid := .F.
		Alert("Usuario nao autorizado para efetuar movimentações para o Arm "+cLocal +" através da rotina "+ cRotina +" !!! ")
	EndIf
	If Select("QZS") > 0 
		QZS->(DbCloseArea())
	EndIf
  EndIf
  RestArea(__aArea)     
Return lValid

// Gera os registros na tabela do Armazém Virtual ZZN.
METHOD ValidUser(cFil, dEmissao, cCod, cLocal, cNumSeq, cLote, cDoc, cRotina) Class NVLxFUN

  Local __aArea := GetArea()
  Local lValid  	:= .T.  

  If cLocal $ (GetMV("ZZ_ARMZVAL"))

	lValid := .F.
	
	cQuery	:= " SELECT COUNT(ZS_LOCAL) QUANT "
	cQuery	+= " FROM "+ RetSqlName("SZS") +" ZS "
	If ! Empty(cCod)
  	  cQuery+= " INNER JOIN "+ RetSqlName("SB1") +" B1 ON B1.D_E_L_E_T_='' AND B1.B1_COD = '" + cCod + "'    "
  	  cQuery+= " WHERE "
	  cQuery+= " 	  (ZS.ZS_GRUPO = B1.B1_ZZPRT1 			 OR ZS.ZS_GRUPO ='' ) AND " 
	  cQuery+= " 	  (ZS.ZS_TIPO = B1.B1_TIPO 				 OR ZS.ZS_TIPO ='')   AND"
	Else
  	  cQuery+= " WHERE "
	EndIf
	cQuery	+= "       ZS.D_E_L_E_T_='' AND  "
	cQuery	+= "      (ZS.ZS_LOCAL ='"+ cLocal +"' 			 OR ZS.ZS_LOCAL ='') AND  "
	cQuery	+= "  	  ('"+ Dtos(DdataBase) +"' <= ZS.ZS_MSBLQD OR ZS.ZS_MSBLQD = '') AND ZS.ZS_MSBLQL != '1' AND "
	cQuery	+= " 	  ltrim(rtrim(ZS_ROTINA)) = '" +cRotina+ "' AND ZS_USER ='" + Alltrim(__cUserID) + "' "
	
	cQuery := changeQuery(cQuery)	
	TCQUERY cQuery NEW ALIAS "QZS"
	QZS->(DbGoTop())                      

	_Local := ""			
	IF QZS->(!Eof()) .and. QZS->QUANT > 0
		lValid := .T.
	Else 
		lValid := .F.
		Alert("Usuário não autorizado para efetuar movimentações para o Arm "+cLocal +" através da rotina "+ cRotina +" !!! ")
	EndIf
	If Select("QZS") > 0 
		QZS->(DbCloseArea())
	EndIf
  EndIf

  RestArea(__aArea)     
Return lValid


*Funcao*************************************************************************************************

User function xascan(_aArray,_aExp)
local _nPos:=0
local _nPosAtual
local _aReturn:={}

while (_nPos:= Ascan(_aArray,_aExp,_nPosAtual)) > 0
	aadd(_aReturn,_nPos)
	if (_nPosAtual:=++_nPos)>len(_aArray)
		exit
	endif
EndDo
return(_aReturn)



//24/08/2011 Leonardo Bergamasco
//Funçao que apresenta os Usuario para escolha com f_Opcoes, ordenado por Nome do usuario
//l1Elem = .T. Apenas 1 seleção / .F. Multipla seleção
//cVarRet = referencia variavel de retorno (não utilizada quando chamado a função a partir do Pergunte() [PutSX1])
User Function nvlRetUser(l1Elem, cVarRet)

local aSit
local _aArea:=Getarea()
local MvPar

	_aUsers := ALLUSERS()
	_aUsers := aSort(_aUsers,,,{|x,y| x[1][4] < y[1][4]})
	
	cTitulo := "Usuários"
	MvParDef:= ""
	for i:=1 to len(_aUsers)
		if i > 1
			if !_aUsers[i][1][17]
				if aSit != nil
					aadd(aSit,Left(_aUsers[i][1][2],20)+" "+_aUsers[i][1][4])
					MvParDef+=_aUsers[i][1][1]
				else
					aSit:={Left(_aUsers[i][1][2],20)+" "+_aUsers[i][1][4]}
					MvParDef+=_aUsers[i][1][1]
				endif
			endif
		endif
	Next i

	Restarea(_aArea)
	
    If cVarRet = nil 
	  MvPar:=&(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	  mvRet:=Alltrim(ReadVar())			// Iguala Nome da Variavel ao Nome variavel de Retorno
	  If f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem,6)  			// Chama funcao f_Opcoes
	 	&mvret := mvpar					// Devolve Resultado
	  EndIf
	Else
	  f_Opcoes(@cVarRet,cTitulo,aSit,MvParDef,12,49,l1Elem,6,Len(cVarRet))  // Chama funcao f_Opcoes
	EndIf

return(mvpar)

*Funcão************************************************************************************

//24/08/2011 - Leonardo Bergamasco
//Função para facilitar o Tratamento retorno f_Opcoes, filtra a string retorno inserindo o delimitador
//cTexto   = Texto a ser tratado
//cCritica = Texto de critica (normalmento * é retorno nulo do f_Opecoes)
//cDelim   = Delimitador que vai ser incluido entre as criticas
//lAlltrim = Remove espaços em branco
User Function retFOpcao(cTexto, cCritica, cDelim, lAlltrim)

  Local cRetur := ""
  Local nLen   := Len(cCritica)

  cTexto := StrTran(cTexto, cDelim, "") //Remove o delimitador 
  
  If lAllTrim //Remove os espaços em branco caso indicado no parametro
    cTexto := AllTrim(cTexto)
  EndIf

  //Efetua o tratamento conforme o tamanho indicado cCritica e inclui o delimitador indicado cDelim
  For kkx:=1 to Len(cTexto) STEP nLen
    If ! Substr(cTexto,kkx,nLen) == cCritica
      cRetur += Substr(cTexto,kkx,nLen) + cDelim
    EndIf
  Next
  
  //Grava o resultado na variavel (referenciada)
  cTexto := cRetur

Return
	
*Funcão************************************************************************************

//10/06/2011 - Leonardo Bergamasco
//Função facilidade de preenchimento dos Parametros de Pergunta (SX1)
User Function SX1RELAT(nPar, lReplic, cDefault)
  //nPar     = Numero do Parametro Atual, sera aplicado para o proximo parametro
  //lReplic  = Flag de replicação, replica o conteudo (qualquer tipo) ou 'Z' (para Tipo='C')
  //cDefault = Caso o Flag lReplic for Falso, e parametro nPar+1 (proximo) estiver vazio sera aplicado o valor Default

  Local lRet := .T.
  Local _ParAtu := StrZero( (nPar) ,2,0)
  Local _ParPrx := StrZero((nPar+1),2,0)
  
  //Case seja replicador seja True
  If lReplic
    //Verifica o parametro anterior (De)
    If ! Empty(MV_PAR&_ParAtu)
      //Caso seja preenchido e mesmo tipo parametro, replica o conteudo para o parametro atual (Ate)
      If ValType(MV_PAR&_ParAtu) == ValType(MV_PAR&_ParPrx)
        MV_PAR&_ParPrx := MV_PAR&_ParAtu
      EndIf
    Else
      //Caso seja Branco e parametro atual for tipo Caracter, completa o campo atual com "Z"
      If ValType(MV_PAR&_ParPrx) == "C"
        MV_PAR&_ParPrx := Replicate("Z", Len(MV_PAR&_ParPrx))
      EndIf
    EndIf
  Else
    If Empty(MV_PAR&_ParPrx) .and. (! Empty(cDefault))
      MV_PAR&_ParPrx := cDefault
    EndIf
  EndIf
  
Return lRet

*Funcao*******************************************************************************************

//Rotina de Leitura CSV para atualizacao de tabelas
//26/08/2011 - Leonardo Bergamasco
User Function ImportCSV(cColuna)

  //*** Array's de dados ***\\ 
  Local arqCSV  := ""       //Recebe o nome do arquivo a ser lido
  Local nHandle := 0        //Handle do arquivo dados pelo FOpen() 
  Local cString := ""       //String recebido pelo FReadStr()
  Local aDados  := {}       //Array de Dados a importar
  Local nAtuCSV := 0        //Posicao atual do arquivo
  Local nLemCSV := 0        //Posicao final do arquivo
  Local CEXTENS := "*.csv"  //Extensao do arquivo a ser selecionado
   
  //Apresenta a tela para selecao do nome e caminho do diretorio 
  arqCSV := UPPER(cGetFile(cExtens, "Nome do Arquivo",,"C:\", .T., GETF_LOCALHARD))
  
  //Abre o arquivo para a leitura
  nHandle := FOpen(arqCSV, FC_NORMAL)  
  If FError() != 0
    APMsgStop("Erro no abrir o arquivo " + arqCSV)
    Return aDados
  EndIf
  
  //Cria o nome do arquivo de log de erro
  arqErr := StrTran(arqCSV, ".CSV", "erro.CSV")

  //Posiciona no ultimo Bit para guardar o numero de caracter do arquivo, posiciona no inicio do mesmo
  nLemCSV := FSeek(nHandle, 0, FS_END)
  nAtuCSV := FSeek(nHandle, 0, FS_SET)

  //Inicia a leito dos caracter  
  For k:=0 to nLemCSV
    cChar := FReadStr(nHandle, 1)
    //Usa CRLF para determinar o final da linha
    If (cChar <> chr(13))
      If (cChar <> chr(10))
        cString += cChar
      Else
        //Compara a prima linha lida do arquivo, a mesma tem que bater com o layout de coluna
        If Empty(aDados) .and. (!(cColuna == cString))
          APMsgStop("Layout nao confere")
          FClose(nHandle)
          Return aDados
        EndIf
        aadd(aDados, filtCol(cString))   //Registra os dados, guardando as linha na matriz
        cString := ""
      EndIf
    EndIf
  Next
  If ! Empty(cString)
    aadd(aDados, filtCol(cString))       //Registra os dados, guardando as linha na matriz
  EndIf

  //Fecha o arquivo
  FClose(nHandle)

Return aDados

*Funcao*******************************************************************************************

//Filtra a String recebido do arquivo CSV separando as colunas pelo delimitador ";"
//26/08/2011 - Leonardo Bergamasco - Usada na rotina importCSV
Static Function filtCol(cColuna)
  
  Local xAux    := ""
  Local aColuna := {}

  For cl:=1 to Len(cColuna)
    If subStr(cColuna,cl,1) == ";" .or. cl == Len(cColuna)
      If cl == Len(cColuna)
        xAux += subStr(cColuna,cl,1)
      EndIf
      aadd(aColuna, xAux)
      xAux := ""
    Else
      xAux += subStr(cColuna,cl,1)
    EndIf
  Next   
  
Return aColuna

*Funcao*******************************************************************************************

//07/07/2014 - Leonardo Bergamasco - Funcao usada para conectar ao FTP, baixar arquivo, enviar arquivo, excluir arquivo e mover arquivo de pasta
//********** NAO TESTADO *********
User Function FTPUpLoad(cSRV, cUSR, cPWD, cORG, cDST, cFUN, cARQ, cExt, lDEL)

  Local cServidor := cSRV  //Endereço do servidor de FTP
  Local cLogin    := cUSR  //Usuario
  Local cUsuario  := cPWD  //Senha
  Local cOrigem   := cORG  //Pasta Origem
  Local cDestino  := cDST  //Pasta Destino
  Local cFuncao   := cFUN  //Funcao a ser realizada (UpLoad, DowLoad)
  Local cArquivo  := cARQ  //Nome do arquivo (caso esteja * sera considerado todos os arquivo da pasta)
  Local cExtensao := cExt  //Extenção do(s) arquivo(s) a ser pesquisado na pasta    - DownLoad
  Local lDeleta   := lDEL  //Deleta o arquivo (caso .T. Delata o arquivo da Origem) - DownLoad
  Local lRet      := .T.   //Retorno da Função
  Local aArqs     := {}    //Retorna as informações (Diretorio e arquivo)
  Local nPosArq   := 0

  FTPDisconnect()
  
  //Testa a Conexão com o servidor, logando a sessão
  If ! FTPConnect( cServidor, ,cLogin, cArquivo )
   APMsgInfo( 'Falha na conexão!' )
   lRet := .F.
  EndIf
  
  //Funcão DOWNLOAD
  If lRet .and. cFuncao == "DOWNLOAD"
    //Entrar no diretorio de Origem para o Dowload
    If FTPDirChange(cOrigem)
      //Seleciona todos os arquivos que estiver na pasta com a extenção informada
      aArqs := FTPDIRECTORY( cExtensao, , .T. )
      //Verifica se foi localizado o arquivo informado esta na listagem
      If ! cArquivo == "*"
        nPosArq := ascan(aArqs, {|x| Altrim(x[1]) == cArquivo})
      Else
        nPosArq := Len(aArqs)
      EndIf
      If nPosArq <= 0
         APMsgStop("Não foi localizado o(s) arquivo(s) na pasta "+AllTrim(cOrigem),"NVLxFUN - FTPUpLoad")
         lRet := .F.
      EndIf
      If lRet
        For nkup := IIF(cArquivo == "*",1,nPosArq) to nPosArq
           //Efetua o DowLoad do arquivo
           If ! FTPDOWNLOAD(cDestino + aArqs[nkup,1], aArqs[nkup,1] )
             APMsgStop("Problemas ao COPIAR o arquivo " + AllTrim(aArqs[nkup,1]) + " para destino "+AllTrim(cDestino),"NVLxFUN - FTPUpLoad")
           ElseIf lDEL
             If ! FTPERASE( aArqs[nkup,1] )
               APMsgStop("Problemas ao APAGAR o arquivo " + AllTrim(aArqs[nkup,1]) + " da origem "+AllTrim(cOrigem),"NVLxFUN - FTPUpLoad")
             EndIf
           EndIf
         Next
      EndIf     
    Else
      APMsgStop("Não foi localizado a pasta "+AllTrim(cOrigem),"NVLxFUN - FTPUpLoad")
      lRet := .F.
    EndIf
  EndIf

  //Funcão UPLOAD
  If lRet .and. cFuncao == "UPLOAD"
    //Entrar no diretorio de Origem para o UpLoad
    If FTPDirChange(cDestino)
      //Efetua o DowLoad do arquivo
      If ! FTPUPLOAD(cOrigem + cArquivo, cDestino + cArquivo )
        APMsgStop("Problemas ao COPIAR o arquivo " + AllTrim(aArqs[nkup,1]) + " para destino "+AllTrim(cDestino),"NVLxFUN - FTPUpLoad")
      EndIf
    Else
      APMsgStop("Não foi localizado a pasta "+AllTrim(cDestino),"NVLxFUN - FTPUpLoad")
      lRet := .F.
    EndIf
  EndIf

  FTPDisconnect()

Return lRet


*******************************************************************************************************
/*
Documentacao dos parametro f_Opcoes

	f_Opcoes(
	uVarRet 		,;	//Variavel de Retorno
	cTitulo			,;	//Titulo da Coluna com as opcoes
	aOpcoes			,;	//Opcoes de Escolha (Array de Opcoes)
	cOpcoes			,;	//String de Opcoes para Retorno
	nLin1			,;	//Nao Utilizado
	nCol1			,;	//Nao Utilizado
	l1Elem			,;	//Se a Selecao sera de apenas 1 Elemento por vez
	nTam			,;	//Tamanho da Chave
	nElemRet		,;	//No maximo de elementos na variavel de retorno
	lMultSelect		,;	//Inclui Botoes para Selecao de Multiplos Itens
	lComboBox		,;	//Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
	cCampo			,;	//Qual o Campo para a Montagem do aOpcoes
	lNotOrdena		,;	//Nao Permite a Ordenacao
	lNotPesq		,;	//Nao Permite a Pesquisa
	lForceRetArr    ,;	//Forca o Retorno Como Array
	cF3				 ;	//Consulta F3  )

*/
