#INCLUDE "protheus.ch" 
#INCLUDE "msobject.ch" 
#INCLUDE "fileio.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³TIPChkMetaºAutor  ³Fsw Totvs Ip        º Data ³  17/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Classe de meta utilizada no calculo das comissoes.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 10 Ms-Sql Server                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

&& "dummy" function - Uso Interno
User Function _TIPChkMeta; Return && "dummy" function - Uso Interno

&& Definicao da classe
Class TIPChkMeta
	Data Vendedor	as Character
	Data Mes		as Character
	Data Ano		as Character
	Data Meta       as Numeric
	Data VlrTotVd	as Numeric
	Data PercMeta	as Numeric
	Data PercDesc	as Numeric
	Data PercComis	as Numeric

	Method New(cVendedor, cMes, cAno, nVlrTotVd) Constructor
	Method GetComis()
	Method SetVendedor()
	Method SetMes()
	Method SetAno()
	Method SetVlrTotVd()
	Method SetPercDesc()
EndClass

&& Metodo Construtor da Classe
Method New(cVendedor, cMes, cAno, nVlrTotVd) Class TIPChkMeta
	Default cVendedor	:= ""
	Default cMes		:= ""
	Default cAno		:= ""
	Default nVlrTotVd	:= 0
	
	::Vendedor	:= cVendedor
	::Mes		:= cMes
	::Ano		:= cAno
	::VlrTotVd	:= nVlrTotVd
	::PercDesc	:= 0
	::PercComis	:= 0
Return Self

&& Atribui externamente e individualmnete o conteudo da Propriedade
Method SetVendedor(cVendedor) Class TIPChkMeta
	::Vendedor := cVendedor
Return 

&& Atribui externamente e individualmnete o conteudo da Propriedade
Method SetMes(cMes) Class TIPChkMeta
	::Mes := cMes
Return 

&& atribui externamente e individualmnete o conteudo da propriedade
Method SetAno(cAno) Class TIPChkMeta
	::Ano := cAno
Return 

&& atribui externamente e individualmnete o conteudo da propriedade
Method SetVlrTotVd(nVlrTotVd) Class TIPChkMeta
	::VlrTotVd := nVlrTotVd
Return 

&& atribui externamente e individualmnete o conteudo da propriedade
Method SetPercDesc(nPercDesc) Class TIPChkMeta
	::PercDesc := nPercDesc
Return 

&& recupera externamente o conteudo da comissao 
Method GetComis() Class TIPChkMeta
	
	SZ5->(dbSetOrder(1)) && Z5_FILIAL + Z5_CODVEND + Z5_MES + Z5_ANO + Z5_METADE
   	If !SZ5->(dbSeek(xFilial("SZ5") + ::Vendedor +::MES + ::Ano))
		aviso("Atenção","Não existe meta cadastrada para o vendedor "+::Vendedor+" no mês/ano "+::Mes+" - "+::Ano,{"OK"})
	endif
	
	
	::PercMeta	:= (::VlrTotVd / SZ5->Z5_METAVND) * 100
	
	::PercDesc	:= if(::PercDesc<0,0,::PercDesc)
	
	BeginSql alias "TSZ5"
	
		column Z5_COMISSA as Numeric(18,2)
		
		%noparser%
	
		SELECT Z5_METAVND,Z5_COMISSA,Z5_DESCDE,Z5_VLTETO
		FROM %table:SZ5% Z5
		WHERE Z5_FILIAL = %xfilial:SZ5% AND Z5_CODVEND = %Exp:Self:Vendedor% AND
		      Z5_MES = %Exp:Self:Mes% AND Z5_ANO = %Exp:Self:Ano% AND
		      %Exp:Self:PercMeta% BETWEEN Z5_METADE AND Z5_METAATE AND
		      %Exp:Self:PercDesc% BETWEEN Z5_DESCDE AND Z5_DESCATE AND Z5.%notDel%
	EndSql 

	&&memoWrit("MYTIPPedidos05"+::Vendedor+".sql", GetLastQuery()[2])
	&&__copyfile("MYTIPPedidos05"+::Vendedor+".sql","C:\Temp\MYTIPPedidos05"+::Vendedor+".sql")
	
	TSZ5->(dbGoTop())

	::PercComis := ::VlrTotVd * (TSZ5->Z5_COMISSA/100)
	::Meta      :=TSZ5->Z5_METAVND
	if TSZ5->Z5_VLTETO > 0 .and. TSZ5->Z5_DESCDE < ::PercDesc .and. TSZ5->Z5_VLTETO < ::PercComis
		::PercComis := (TSZ5->Z5_VLTETO*100) / ::VlrTotVd
	else
		::PercComis := TSZ5->Z5_COMISSA
	endif	

	TSZ5->(dbCloseArea())

Return ::PercComis
