#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบClasse    ณMyComX001 บAutor  ณWinston D. de Castroบ Data ณ  23/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณClasse responsavel pela validacao do preenchimento obrigato-บฑฑ
ฑฑบ          ณrio do campo centro de custos quando tratar-se de despesas. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 10 Ms-Sql Server                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
&& Dios libre al Usuario/Analista de cambiar una sola linea de este fichero!
*/

// 'dummy' function - uso interno do protheus
//User Function MyComX001()

Class MyComX001

	Data cProduto as Character
	Data cCCusto  as Character
	Data cTes     as Character
	Data lContem  as Logical
	
	Method new() Constructor
	Method setProduto()
	Method getProduto()
	Method setCCusto()
	Method getCCusto()
	Method setTes()
	Method getTes()
	Method setContem()
	Method getContem()
	Method vldCCusto()
	Method vldTes()
	Method destroy()

endclass

&& Metodo : new()
&& Descric: Metodo Construtor.
&& Param  : nenhum
&& Retorno: nil
Method new(cProduto,cCCusto,cTes) Class MyComX001
	::setProduto(cProduto)
	::setCCusto(cCCusto)
	::setTes(cTes)
	
	::setContem()
return

&& Metodo : vldCCusto()
&& Descric: 
&& Param  : 
&& Retorno: 
Method vldCCusto() Class MyComX001

	local lValid := ::getContem()
	local cCusto := ::getCCusto()
	local lRet   := .T.
	local cMsg   := "Produto do grupo de Despesas, favor preencher o Centro de Custos."
	
	if lValid .and. empty(cCusto)
		aviso(funDesc(),cMsg,{"OK"})
		lRet := .F.
	endif

return lRet

&& Metodo : vldTes()
&& Descric: 
&& Param  : 
&& Retorno: 
Method vldTes() Class MyComX001

	local lValid   := ::getContem()
	local cTes     := ::getTes()
	local cEstoque := allTrim(posicione("SF4",1,xFilial("SF4")+cTes,"F4_ESTOQUE"))
	local lRet     := .T.
	local cMsg     := "Produto de despesa nใo poderแ movimentar estoque, por favor altere a TES."
	
	if lValid .and. cEstoque == "S"
		aviso(funDesc(),cMsg,{"OK"})
		lRet := .F.
	endif

return lRet

&& Metodo : setContem()
&& Descric: 
&& Param  : 
&& Retorno: 
Method setContem() Class MyComX001

	local cProd  := ::getProduto()
	local cB1Grp := allTrim(posicione("SB1",1,xFilial("SB1")+cProd,"B1_GRUPO"))
	local cMVGrp := getMv("MY_GRPDESP")
	
	if cB1Grp $ cMVGrp
		::lContem := .T.
	else
		::lContem := .F.
	endif

return

&& Metodo : getContem()
&& Descric: 
&& Param  : 
&& Retorno: 
Method getContem() Class MyComX001
return ::lContem

&& Metodo : setProduto()
&& Descric: 
&& Param  : 
&& Retorno: 
Method setProduto(cProduto) Class MyComX001
	if cProduto != nil
		::cProduto := cProduto
	else
		::cProduto := ""
	endif
return

&& Metodo : getProduto()
&& Descric: 
&& Param  : 
&& Retorno: 
Method getProduto() Class MyComX001
return ::cProduto

&& Metodo : setCCusto()
&& Descric: 
&& Param  : 
&& Retorno: 
Method setCCusto(cCCusto) Class MyComX001
	if cCCusto != nil
		::cCCusto := cCCusto
	else
		::cCCusto := ""
	endif
return

&& Metodo : getCCusto()
&& Descric: 
&& Param  : 
&& Retorno: 
Method getCCusto() Class MyComX001
return ::cCCusto

&& Metodo : setTes()
&& Descric: 
&& Param  : 
&& Retorno: 
Method setTes(cTes) Class MyComX001
	if cTes != nil
		::cTes := cTes
	else
		::cTes := ""
	endif
return

&& Metodo : getTes()
&& Descric: 
&& Param  : 
&& Retorno: 
Method getTes() Class MyComX001
return ::cTes

&& destroi objeto
Method destroy() Class MyComX001
return
