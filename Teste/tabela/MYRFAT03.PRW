#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE PAD_LEFT	0
#DEFINE PAD_RIGHT	1
#DEFINE PAD_CENTER	2      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³MYRFAT03  ºAutor  ³FSW Totvs IP        º Data ³  05/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pedido de Vendas Grafico                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
&& Dios libre al Usuario/Analista de cambiar una sola linea de este fichero!
*/

User Function MYRFAT03()

	local oPrint   := TMSPrinter():new(funDesc())
	local lPreview := .F.
	local cPerg    := padr("MYRFT3",len(SX1->X1_GRUPO))
	local nOpc     := 3
	local cTitulo  := "Relatorio de Pedido de Vendas - " + SM0->M0_NOME

	SX1->(dbSetOrder(1))
	if !SX1->(dbSeek(cPerg))
		validPerg(@cPerg)
	endif
	
	if !pergunte(cPerg,.T.)
		return
	endif
	
	while nOpc != 4
		nOpc := aviso(funDesc(),cTitulo,{"Visualizar","Imprimir","Configurar","Sair"})
		if nOpc == 3
			oPrint:setup()
		elseif nOpc == 4
			exit
		else
			if nOpc == 1
				lPreview := .T.
			else
				lPreview := .F.
			endif
		
			if R003Sql() > 0
				msgRun("Gerando o Pedido, aguarde...","",{|| cursorWait(),runReport(@cPerg,@lPreview),cursorArrow()})
			else
				aviso(funDesc(),"Não há informações.",{"OK"})
			endif
			
			QRY->(dbCloseArea())
		endif
	enddo

return

&& gera relatorio grafico
static function runReport(cPerg,lPreview)

	local _cPedido		:= ""
	local _nTotPed		:= 0
	local _cTPFRETE		:= ""
	local _aMenPad 		:= {}
	local _nTMens  		:= 0 
	local _cEndEnt 		:= ""
	local _cTransp 		:= ""
	local _nFrete  		:= ""
	local _nIPI	 		:= 0
	local _nICM    		:= 0
	local _nPesol  		:= 0 
	local _nPBruto 		:= 0
	
	private nTotDup		:= 0
	private nTotSal		:= 0
	
	private nLin    	:= 	3000
	private nPag    	:= 	0
	private nInicio 	:= 	20
	private nLimite 	:= 	3200 &&/2350
	private nPixLin 	:= 	50  &&70
	private nPxLine 	:= 	15  &&20
	private nColAux 	:= 	0
	private cC5Num  	:= 	""
	private cA1Obs  	:= 	""
	private cC5Obs  	:= 	""
	private lBrush  	:= 	Nil
	
	private oPrint    	:= 	TMSPrinter():new(funDesc())
	private oFont10b 	:= 	TFont():new("Arial",08,08,,.T.,,,,.T.,.F.)
	private oFont10  	:= 	TFont():new("Arial",08,08,,.F.,,,,.T.,.F.)
	private oFont12  	:= 	TFont():new("Arial",10,10,,.F.,,,,.T.,.F.)
	private oFont12a 	:= 	TFont():new("Arial",10,10,,.T.,,,,.T.,.F.)
	private oFont14  	:= 	TFont():new("Arial",12,12,,.F.,,,,.T.,.F.)
	private oFont14a 	:= 	TFont():new("Arial",12,12,,.T.,,,,.T.,.F.)
	private oFont16  	:= 	TFont():new("Arial",16,16,,.T.,,,,.T.,.F.)
	private oFontTit 	:= 	TFont():new("Arial",11,11,,.T.,,,,.T.,.T.)
	private oFont12b 	:= 	TFont():new("Arial",12,12,,.T.,,,,.T.,.F.)
	private oFont16n	:=  TFont():new("Courier New",0,16,.T.,.F.,5,.T.,5,.T.,.F.)
	private oFont18 	:=  TFont():new("Courier New",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	private oBrush		:=  TBrush():new(,4)
	
	&&oPrint:setup()
	
	oPrint:setLandScape()
	&&oPrint:setPortrait()
	
	while QRY->(!eof())
		
		if nLin >= 1580 
			cabecalho()
			nLin := 800
		endif		          
		
		dbSelectArea("SA4")
		if dbSeek(xFilial("SA4")+QRY->C5_TRANSP,.F.)
		    _cTransp := SA4->A4_NOME
		else
			_cTransp := space(30)
		endif
		
	    _cPedido := QRY->C5_NUM
	    _nTotPed := 0
	    _cTPFRETE:= QRY->C5_TPFRETE
	    _aMenPad := {}
	    _nTMens  := 0 
	    _cEndEnt := QRY->A1_ENDENT
	    _nFrete  := QRY->C5_FRETE
	    _nIPI	 := 0
	    _nICM    := 0
		_nPesol  := 0 
		_nPBruto := 0
	    
		//_nTMens := mlCount(TRIM(QRY->C5_MENNOTA ,080))
		//aAdd(_aMenPad,memoLine(QRY->C5_MENNOTA,080,1))
		
		_nTMens := mlCount(TRIM(QRY->C5_MENNOTA),080)
		if !empty(memoLine(QRY->C5_MENNOTA,080,1))
			aAdd(_aMenPad,memoLine(QRY->C5_MENNOTA,080,1))
			for _nI:=2 to _nTMens
				if !empty(memoLine(QRY->C5_MENNOTA,080,_nI))
					aAdd(_aMenPad,memoLine(QRY->C5_MENNOTA,080,_nI))
				endif
			next _nI	    	
		endif



		_nTMens := mlCount(TRIM(QRY->C5_ZZMENS),080)
		if !empty(memoLine(QRY->C5_ZZMENS,080,1))
			aAdd(_aMenPad,memoLine(QRY->C5_ZZMENS,080,1))
			for _nI:=2 to _nTMens
				if !empty(memoLine(QRY->C5_ZZMENS,080,_nI))
					aAdd(_aMenPad,memoLine(QRY->C5_ZZMENS,080,_nI))
				endif
			next _nI	    	
		endif
	
		_nTMens := mlCount(QRY->C5_ZZOBSIM ,080)
		if !empty(memoLine(QRY->C5_ZZOBSIM,080,1))
			aAdd(_aMenPad,memoLine(QRY->C5_ZZOBSIM,080,1))
			for _nI:=2 to _nTMens
				if !empty(memoLine(QRY->C5_ZZOBSIM,080,_nI))
					aAdd(_aMenPad,memoLine(QRY->C5_ZZOBSIM,080,_nI))
				endif
			next _nI 
		endif	    	
	
		_nTMens := mlCount(QRY->C5_ZZOBSFI ,080)
		if !empty(memoLine(QRY->C5_ZZOBSFI,080,1))
			aAdd(_aMenPad,memoLine(QRY->C5_ZZOBSFI,080,1))
			for _nI:=2 to _nTMens
				if !empty(memoLine(QRY->C5_ZZOBSFI,080,_nI))
					aAdd(_aMenPad,memoLine(QRY->C5_ZZOBSFI,080,_nI))
				endif
			next _nI 
		endif	    	
	
		_nTMens := mlCount(QRY->C5_ZZOBSET ,080)
		if !empty(memoLine(QRY->C5_ZZOBSET,080,1))
			aAdd(_aMenPad,memoLine(QRY->C5_ZZOBSET,080,1))
			for _nI:=2 to _nTMens
				if !empty(memoLine(QRY->C5_ZZOBSET,080,_nI))
					aAdd(_aMenPad,memoLine(QRY->C5_ZZOBSET,080,_nI))
				endif
			next _nI 
		endif	    	
		
	    while QRY->(!eof()) .and. QRY->C5_NUM == _cPedido
	    			
			if nLin > 1580 
				nLin := 3100
				cabecalho()
				nLin := 800
			endif		
	
	    	oPrint:say(nLin,0020,QRY->C6_ITEM     												,oFont12)
	    	oPrint:say(nLin,0170,QRY->C6_PRODUTO   												,oFont12)
	    	oPrint:say(nLin,0520,substr(QRY->C6_DESCRI,1,42)									,oFont12)
	    	oPrint:say(nLin,1500,QRY->C6_UM		 						   						,oFont12)
	    	oPrint:say(nLin,1540,transform(QRY->C6_QTDVEN,"@E 999,999,999.99")					,oFont12)
	    	//oPrint:say(nLin,1755,QRY->C6_TES													,oFont12)
	    	oPrint:say(nLin,1755,QRY->C6_CF														,oFont12)
	    	oPrint:say(nLin,1900,transform(QRY->C6_PRCVEN,"@E 999,999,999.99")					,oFont12)
	    	oPrint:say(nLin,2110,transform(QRY->C6_VALOR,"@E 999,999,999.99")					,oFont12)
	    	oPrint:say(nLin,2400,transform(QRY->C6_QTDENT,"@E 999,999,999.99")					,oFont12)
	    	oPrint:say(nLin,2600,transform(QRY->C6_QTDVEN-QRY->C6_QTDENT,"@E 999,999,999.99")	,oFont12)
	    	oPrint:say(nLin,2800,Dtoc(QRY->C6_ZZDATEN) 											,oFont12)
	    	oPrint:say(nLin,3000,Posicione("SB1",1,xFilial("SB1")+QRY->C6_PRODUTO,"B1_POSIPI")	,oFont12)
	    	
	    	_nTotPed += QRY->C6_VALOR                  
			_nPesol  += QRY->B1_PESO * QRY->C6_QTDVEN
			_nPBruto += QRY->B1_PESO * QRY->C6_QTDVEN    
			
	     	if QRY->F4_IPI = "S"
	 	   		_nIPI	 += (QRY->B1_IPI/100) * QRY->C6_VALOR
	        endif
	
	    	nLin += 60
	    	
	    	QRY->(dbSkip())
	    enddo
	
		nLin := 1640
	
		oPrint:say(nLin,0300,_cTransp,oFont12)
		nLin += 50                                                           
		oPrint:say(nLin,0330,_cEndEnt,oFont12)                               
		&&oPrint:say(nLin,2950,transform(_nTotPed+_nIPI+_nICM,"@E 99999,999,999.99") ,oFont12)
		
		nLin += 50
		_nLinha := 50
		if len(_aMenPad) > 0
			for _nx := 1 to len(_aMenPad)
				oPrint:say(nLin+_nLinha,0020,_aMenPad[_nx],oFont12)
			    _nLinha += 60
			    if _nx > 7
			    	exit
			    endif
			next _nx 
		
		endif
		&& Peso Liquido B1_PESO * C6_QTDVEN
		&& Peso Bruto
		&&oPrint:say(nLin,2200,transform(_nIPI,"@E 999,999,999.99") ,oFont12)	
		&&oPrint:say(nLin,3000,transform(_nICM,"@E 999,999,999.99") ,oFont12) 
		SC5->(dbSetOrder(1))
		SC5->(dbSeek(xfilial("SC5")+ _cPedido))
		nLin := 1990 && 1640	
		oPrint:say(nLin,2030,transform(_nTotPed,"@E 999,999,999.99")	,oFont12)
		oPrint:say(nLin,2820,If(SC5->C5_ENTPARC == "2", "Sim", "Não")	,oFont12)
		nLin += 50
		oPrint:say(nLin,2030,transform(_nIPI,"@E 999,999,999.99")		,oFont12)
		oPrint:say(nLin,2820,If(SC5->C5_TEMGRAV == "2", "Sim", "Não")	,oFont12)	
		nLin += 50			
		oPrint:say(nLin,2030,transform(_nFrete,"@E 999,999,999.99")	,oFont12)	
		oPrint:say(nLin,2820,transform(_nPBruto,"@E 999,999,999.99") 	,oFont12)	
		nLin += 50
		oPrint:say(nLin,2130,IIF(_cTPFRETE=="C","CIF","FOB")			,oFont12)	        
		oPrint:say(nLin,2820,transform(_nPesol,"@E 999,999,999.99")	,oFont12)
		nLin += 50
			
		impRod(@nLin,@nLimite,@nInicio,@nPag,@PAD_RIGHT)
	
	enddo
	
	if lPreview
		oPrint:preview()
	else
		oPrint:print()
	endif

return

&& imprime cabecalho
static function cabecalho()

	If 	nPag != 1
		oPrint:endPage()
	EndIf
	
	oPrint:StartPage()
	
	nLin := 40
	
	SM0->(dbSeek(cEmpAnt + cFilAnt))
	
	oPrint:say(nLin,nLimite/2,"Myers do Brasil Embalagens Plásticas Ltda.",oFont14,,,,PAD_CENTER)
	nLin +=50
	oPrint:say(nLin,nLimite/2,"Av. Emílio Marconato - Distrito Industrial",oFont14,,,,PAD_CENTER)
	oPrint:say(nLin,2720,"PEDIDO DE VENDA",oFont14)
	nLin +=50
	oPrint:say(nLin,nLimite/2,"Chácara Primavera - CEP: 13.820-000 - Jaguariuna ",oFont14,,,,PAD_CENTER)
	oPrint:sayBitmap(nLin, 010, "LGLR01.BMP", 0450 ,0150,,.T.)  && Logo
	nLin +=50
	oPrint:say(nLin,nLimite/2,"Fone: 19-3847-9999   Fax: 19-3937-4451 ",oFont14,,,,PAD_CENTER)
	oPrint:say(nLin,2720,"N° "+QRY->C5_NUM,oFont14)
	nLin +=50
	oPrint:say(nLin,nLimite/2,"CNPJ: 06.979.521/0001-19 Inscrição Estadual: 395.094.117-111",oFont14,,,,PAD_CENTER)
	nLin +=50
	oPrint:say(nLin,nLimite/2,"www.myersdobrasil.com",oFont14,,,,PAD_CENTER)
	
	nLin +=100
	&& cabecalho  1o. Quadro
	oPrint:box(nLin,0000,(nLin+300),nLimite)
	oPrint:box(nLin,0595,(nLin+300),nLimite)
	oPrint:box(nLin,2520,(nLin+300),nLimite)
	oPrint:say(nLin,0020,"Data do Pedido: "	+ Dtoc(QRY->C5_EMISSAO) ,oFont12a)   
	&& cabecalho 2o. Quadro 
	oPrint:say(nLin,0600,"Cliente: " + QRY->A1_NOME,oFont12a)
	oPrint:say(nLin,1720,"Codigo: " + QRY->A1_COD+"-"+QRY->A1_LOJA	,oFont12a)
	&& cabecalho 3o. Quadro 
	oPrint:say(nLin,2540,"Condições de Pagamento: ",oFont12a)
	
	
	nLin +=50
	oPrint:say(nLin,0020,"Vendedor: "	,oFont12a)
	
	oPrint:say(nLin,0600,"Endereco: "+QRY->A1_END 	,oFont12a)
	oPrint:say(nLin,1720,"Bairro: "	 +QRY->A1_BAIRRO,oFont12a)
	
	oPrint:say(nLin,2540,QRY->E4_DESCRI	,oFont12a)
	
	nLin +=50
	oPrint:say(nLin,0020,substr(QRY->A3_NOME,1,30)	,oFont12a)
	
	oPrint:say(nLin,0600,"Cidade: "+QRY->A1_MUN	,oFont12a)
	oPrint:say(nLin,1720,"Estado: "+QRY->A1_EST	,oFont12a)
	oPrint:say(nLin,2220,"CEP: "+QRY->A1_CEP		,oFont12a)
	
	nLin +=50
	oPrint:say(nLin,0020,"Telefone: "+IIF(!empty(QRY->A3_DDDTEL),"("+QRY->A3_DDDTEL+")","")+QRY->A3_TEL	,oFont12a)
	oPrint:say(nLin,0600,"CNPJ: "+IIF(QRY->A1_PESSOA=="J",transform(QRY->A1_CGC,"@R 99.999.999/9999-99"),transform(QRY->A1_CGC,"@R 999.999.999-99"))	,oFont12a)
	oPrint:say(nLin,1720,"Inscricao Estadual: "+QRY->A1_INSCR 	,oFont12a)
	
	oPrint:say(nLin,2540,"Moeda: "+IIF(QRY->C5_MOEDA==1,"REAL","US$")	,oFont12a)
	
	nLin +=50
	
	&&If len(Alltrim(QRY->A3_EMAIL)) > 17
	&&	oPrint:say(nLin,0020,"email: "+substr(QRY->A3_EMAIL,1,17),oFont12a)
	&&Else
	&&	oPrint:say(nLin,0020,"email: "+QRY->A3_EMAIL,oFont12a)
	&&Endif
	oPrint:say(nLin,0020,"Fax: " + IIF(!empty(QRY->A3_DDDTEL).and.!empty(QRY->A3_FAX),"("+QRY->A3_DDDTEL+")","")+QRY->A3_FAX,oFont12a)
	oPrint:say(nLin,0600,"Contato: " + QRY->A1_CONTATO,oFont12a)
	oPrint:say(nLin,1720,"Telefone: " + IIF(!empty(QRY->A1_DDD),"("+QRY->A1_DDD+")","")+QRY->A1_TEL,oFont12a)
	oPrint:say(nLin,2120,"Fax: " + IIF(!empty(QRY->A1_DDD).and.!empty(QRY->A1_FAX),"("+QRY->A1_DDD+")","")+QRY->A1_FAX,oFont12a)
	
	nLin +=50                     
	&&If len(Alltrim(QRY->A3_EMAIL)) > 17
	&&	oPrint:say(nLin,0020,substr(QRY->A3_EMAIL,18,20),oFont12a)
	&&Endif
	oPrint:say(nLin,0020,"email: "+QRY->A3_EMAIL,oFont10b)
	oPrint:say(nLin,0600,"email: "+QRY->A1_EMAIL,oFont10b)
	nLin +=100
	
	&& 2o. Quadro
	oPrint:box(nLin,0000,(nLin+0900),nLimite)
	oPrint:box(nLin,0150,(nLin+0900),nLimite) &&Item
	oPrint:box(nLin,0500,(nLin+0900),nLimite) && Codigo
	oPrint:box(nLin,1480,(nLin+0900),nLimite) && UM
	oPrint:box(nLin,1570,(nLin+0900),nLimite) && Quantidade
	//oPrint:box(nLin,1740,(nLin+0900),nLimite) && Tes
	oPrint:box(nLin,1750,(nLin+0900),nLimite) && Cfop
	oPrint:box(nLin,1850,(nLin+0900),nLimite) && Valor Unitario
	oPrint:box(nLin,2080,(nLin+0900),nLimite) && Valor Total
	oPrint:box(nLin,2380,(nLin+0900),nLimite) && Data Entrega
	oPrint:box(nLin,2580,(nLin+0900),nLimite) && Qde. Fat.
	oPrint:box(nLin,2780,(nLin+0900),nLimite) && Saldo
	oPrint:box(nLin,2980,(nLin+0900),nLimite) && NCM
	
	oPrint:say(nLin,0020,"Item",oFont12a)
	oPrint:say(nLin,0170,"Código",oFont12a)
	oPrint:say(nLin,0520,"Descrição do Item",oFont12a)
	oPrint:say(nLin,1490,"U.M.",oFont12a)
	oPrint:say(nLin,1590,"Qde.",oFont12a)
	//oPrint:say(nLin,1750,"Tes",oFont12a)
	oPrint:say(nLin,1765,"Cfop",oFont12a)
	oPrint:say(nLin,1870,"Valor Unit.",oFont12a)
	oPrint:say(nLin,2154,"Valor Total",oFont12a)
	oPrint:say(nLin,2400,"Qde. Fat.",oFont12a)
	oPrint:say(nLin,2670,"Saldo",oFont12a)
	oPrint:say(nLin,2800,"Entrega",oFont12a)
	oPrint:say(nLin,3000,"NCM",oFont12a)
	
	nLin += 050                              
	oPrint:box(nLin,0000,(nLin+0850),nLimite)         
	oPrint:box(nLin,0150,(nLin+0850),nLimite) &&Item
	oPrint:box(nLin,0500,(nLin+0850),nLimite) && Codigo
	oPrint:box(nLin,1480,(nLin+0850),nLimite) && UM
	oPrint:box(nLin,1570,(nLin+0850),nLimite) && Quantidade
	//oPrint:box(nLin,1745,(nLin+0850),nLimite) && Tes
	oPrint:box(nLin,1750,(nLin+0850),nLimite) && Cfop
	oPrint:box(nLin,1850,(nLin+0850),nLimite) && Valor Unitario
	oPrint:box(nLin,2080,(nLin+0850),nLimite) && Valor Total
	oPrint:box(nLin,2380,(nLin+0850),nLimite) && Data Entrega
	oPrint:box(nLin,2580,(nLin+0850),nLimite) && Qde. Fat.
	//oPrint:box(nLin,2710,(nLin+0850),nLimite) && Saldo
	
	nLin += 850
	oPrint:box(nLin,0000,(nLin+0550),nLimite) 
	oPrint:box(nLin,0000,(nLin+0050),nLimite) && Total do Pedido
	oPrint:box(nLin,0000,(nLin+0100),nLimite) && Total do Pedido
	oPrint:box(nLin+100,1750,(nLin+0550),nLimite) && Total do Pedido
	oPrint:say(nLin,0020,"Transportadora: " ,oFont12a)
	&&oPrint:say(nLin,2420,"Total do Pedido",oFont12a)
	nLin += 50                                
	&&oPrint:box(nLin,0000,(nLin+0250),nLimite) 
	&&oPrint:box(nLin,1900,(nLin+0250),nLimite) && Local Entrega / Total com Impostos
	oPrint:say(nLin,0020,"Local de Entrega: " ,oFont12a)
	&&oPrint:say(nLin,2420,"Total com Impostos",oFont12a)
	
	nLin += 50
	
	&&oPrint:box(nLin,0000,(nLin+0350),nLimite) 
	&&oPrint:box(nLin,1900,(nLin+0350),nLimite) && Observacoes
	&&oPrint:box(nLin,1900,(nLin+0300),nLimite) && Observacoes
	&&oPrint:box(nLin,2700,(nLin+0300),nLimite) && Impostos
	oPrint:say(nLin,0020,"Observacoes: ",oFont12a)     
	
	&&oPrint:say(nLin,2720,"ICMS: ",oFont12a) 
	oPrint:say(nLin+250,2540,"Entrega Parcial: ",oFont12a)
	oPrint:say(nLin+300,2540,"Tem Gravacao: ",oFont12a)        
	oPrint:say(nLin+250,1760,"Total do Pedido: ",oFont12a)
	oPrint:say(nLin+300,1760,"Total do IPI: ",oFont12a)
	oPrint:say(nLin+350,1760,"Frete: ",oFont12a)
	oPrint:say(nLin+350,2540,"Peso Bruto: ",oFont12a)
	oPrint:say(nLin+400,1760,"Tipo de Frete: ",oFont12a)
	oPrint:say(nLin+400,2540,"Peso Liquido: ",oFont12a)
	&&oPrint:say(nLin+150,2420,"Total Geral: ",oFont12a)
	
	
	nLin += 550
	                                          
	&&oPrint:box(nLin,0000,nLin,1920)               
	oPrint:line(nLin,0000,nLin,1720)               
	_cTeste := ""
	cPassword := Embaralha(QRY->C5_USERLGI,1)
	oPrint:say(nLin,2320,"Solicitante: "  ,oFont12a)
	oPrint:say(nLin,2580,substr(cPassword,1,15) ,oFont12)
	nLin += 30
	oPrint:say(nLin,150,"Separado por                               Conferido por                              Data  ",oFont12a)
	oPrint:say(nLin,2240,"Centro de Custos:",oFont12a)

return

&& imprime rodape
static function impRod(nLin,nLimite,nInicio,nPag,nADir)
	nPag++
	
	nLin := 2680
		
	oPrint:endPage()
return

&& executa comando sql
static function R003Sql()

	local cQry := ""
	local nQry := 0
	
	cQry := "SELECT C5_NUM,C5_EMISSAO,C5_CLIENTE,C5_LOJACLI,C5_MOEDA,A1_COD,A1_LOJA,A1_NOME,A1_CGC,A1_INSCR,A1_INSCRM,A1_DDD,"
	cQry +=	"A1_TEL,A1_END,A1_EST,A1_BAIRRO,C6_VALOR,C6_QTDENT,A1_CONTATO,A1_ENDCOB,A1_BAIRROC,A1_MUNC,A1_CEPC,A1_EMAIL,A3_EMAIL,"
	cQry +=	"A1_ESTC,A1_ENDENT,A1_BAIRROE,A1_CEPE,A1_MUNE,A1_ESTE,A1_OBSERV,C5_MENNOTA,A1_PESSOA,A1_FAX,C6_ITEM,C6_DESCRI,C5_PESOL,"
	cQry +=	"C5_PBRUTO,A1_MUN,A1_CEP,C5_CONDPAG,E4_DESCRI,E4_COND,A3_COD,A3_NOME,A3_DDDTEL,A3_TEL,A3_FAX,F4_CODIGO,F4_ICM,F4_IPI,"
	cQry +=	"C5_TRANSP,C5_USERLGI, C6_TES, C6_CF,C6_PRODUTO,C6_DESCRI,C6_PRCVEN,C6_QTDVEN,C6_QTDLIB,C6_ZZDATEN,C6_VALDESC,A3_COMIS,"
	cQry +=	"C5_TABELA,B1_PESO,B1_QE,C6_UNSVEN, C5_TPFRETE,C5_REDESP,C5_MENPAD,C6_UM,C5_MENNOTA,C5_FRETE,B1_IPI,C5_ZZMENS,C5_ZZOBSIM,"
	cQry +=	"C5_ZZOBSFI, C5_ZZOBSET, C5_ENTPARC, C5_TEMGRAV "
	cQry += "FROM " + retSqlName("SC6") + " C6 "
	cQry += "INNER JOIN " + retSqlName("SC5") + " C5 "
	cQry += "ON C5_FILIAL = '" + xFilial("SC5") + "' AND C5_NUM = C6_NUM AND C5.D_E_L_E_T_ = ' ' "
	cQry += "INNER JOIN " + retSqlName("SA1") + " A1 "
	cQry += "ON A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_ = ' ' "
	cQry += "INNER JOIN " + retSqlName("SE4") + " E4 "
	cQry += "ON E4_FILIAL = '" + xFilial("SE4") + "' AND E4_CODIGO = C5_CONDPAG AND E4.D_E_L_E_T_ = ' ' "
	cQry += "INNER JOIN " + retSqlName("SB1") + " B1 "
	cQry += "ON B1_FILIAL = '" + xFilial("SB1") + "' AND B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ' ' "
	cQry += "INNER JOIN " + retSqlName("SA3") + " A3 "
	cQry += "ON A3_FILIAL = '" + xFilial("SA3") + "' AND A3_COD = C5_VEND1 AND A3.D_E_L_E_T_ = ' ' "
	cQry += "INNER JOIN " + retSqlName("SF4") + " F4 "
	cQry += "ON F4_FILIAL = '" + xFilial("SF4") + "' AND F4_CODIGO = C6_TES AND F4.D_E_L_E_T_ = ' ' "
	cQry += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND "
	cQry += "C6_NUM >= '" + mv_par01 + "' AND C6_NUM <= '" + mv_par02 + "' AND C6.D_E_L_E_T_ = ' '  "		
	cQry += "ORDER BY C6_NUM,C6_ITEM "
	
	TCQUERY cQry NEW ALIAS "QRY"

	TCSetField("QRY","C6_ZZDATEN","D")
	TCSetField("QRY","C5_EMISSAO","D")

	Count to nQry
	QRY->(dbGotop())

return nQry

&& funcao auxiliar criacao de grupo de perguntas
static function validPerg(cPerg)

	local _sAlias := Alias()
	local aRegs := {}
	local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := padr(cPerg,10)
	
	&& Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg,"01","Pedido de   		" ,"Pedido de   " 	,"Pedido de   " ,"mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	aAdd(aRegs, {cPerg,"02","Pedido ate  		" ,"Pedido ate  " 	,"Pedido ate  " ,"mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC5" })
	
	for i:=1 to len(aRegs)
		if !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			for j:=1 to FCount()
				if j <= len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				endif
			next
			MsUnlock()
		endif
	next
	
	dbSelectArea(_sAlias)

return