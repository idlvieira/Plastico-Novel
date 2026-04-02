
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³ VLD_COM  ºAutor  ³ Thiago - Totvs IP  º Data ³  25/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validaçao Comissao de vendedores                           º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


user function TKEVALI()

nPosCOD	:= gdFieldPos("UB_PRODUTO")
nPosPRC	:= gdFieldPos("UB_VRUNIT")
nPosDES	:= gdFieldPos("UB_DESC")
nPosCOM	:= gdFieldPos("UB_CM")
nPosCOMS:= gdFieldPos("UB_CMSUPLE")


//_cGrupo			:= Posicione("SB1",1,xFilial("SB1")+aCols[N,nPosCOD],"B1_MYLINHA")
_cGrupo			:= Posicione("SB1",1,xFilial("SB1")+aCols[N,nPosCOD],"B1_SUBGRUP")
_cTpVendedor	:= Posicione("SA3",1,xFilial("SA3")+M->UA_MYVEND2,"A3_MYTIPO")
_cTPFrete		:= M->UA_TPFRETE
//_nFaixa			:= nPosDES
_nFaixa         := acols[N,nPosDes]  
_nComissao		:= 0 
_nComissaos     := 0

//_nComissao		:= aCols[N,nPosPRC] / Posicione("DA1",1,xFilial("DA1")+M->UA_TABELA+aCols[N,nPosCOD],"DA1_PRCVEN") 


//alert(_cTPVendedor)
//alert(_cTPFrete)
//alert(_cGrupo)
//alert(str(_nFaixa))


//EXECUTIVO DE VENDA
If TRIM(_cTpVendedor)=="1"

	//FRETE FOB
	If TRIM(_cTPFrete)=="F"
	
		//AGRICOLA
		If (_cGrupo)=="01"
		
			If _nFaixa<=0
				_nComissao := 1.50  
		        _nComissaos := 0.75 		
			ElseIf _nFaixa<=2
				_nComissao	:= 1.40
				_nComissaos := 0.70
			ElseIf _nFaixa<=5
				_nComissao	:= 1.30
				_nComissaos := 0.65
			Else
				_nComissao	:= 1.30
				_nComissaos := 0.65 
			EndIf
        
		//BEBIDAS
		ElseIf TRIM(_cGrupo)=="04" .or. TRIM(_cGrupo)=="05"
		
			If _nFaixa<=0
				_nComissao := 1.00 
				_nComissaos := 0.50
			ElseIf _nFaixa<=2
				_nComissao	:= 0.90
				_nComissaos := 0.45
			ElseIf _nFaixa<=5
				_nComissao	:= 0.80
				_nComissaos := 0.40
			Else
				_nComissao	:= 0.8 
				_nComissaos := 0.4
			EndIf

		//EPI
		ElseIf TRIM(_cGrupo)=="02" .or. TRIM(_cGrupo)=="03"
		
			If _nFaixa<=0
				_nComissao := 2.2 
				_nComissaos := 1.1
			ElseIf _nFaixa<=2
				_nComissao	:= 2.0
				_nComissaos := 1.0
			ElseIf _nFaixa<=5
				_nComissao	:= 1.8
				_nComissaos := 0.9
			Else
				_nComissao	:= 1.8
				_nComissaos := 0.9
			EndIf

		EndIf	
	                
	// FRETE CIF
	ElseIf TRIM(_cTPFrete)=="C"
	
		//AGRICOLA
		If TRIM(_cGrupo)=="01"
		
			If _nFaixa<=0
				_nComissao := 1.40
				_nComissaos := 0.70
			ElseIf _nFaixa<=2
				_nComissao	:= 1.30
				_nComissaos := 0.65 
			ElseIf _nFaixa<=5
				_nComissao	:= 1.20
				_nComissaos := 0.60 
			Else
				_nComissao	:= 1.20
				_nComissaos := 0.60
			EndIf

		//BEBIDAS
		ElseIf TRIM(_cGrupo)=="04".or. TRIM(_cGrupo)=="05"
		
			If _nFaixa<=0
				_nComissao := 0.9  
				_nComissaos := 0.45
			ElseIf _nFaixa<=2
				_nComissao	:= 0.8 
				_nComissaos := 0.40
			ElseIf _nFaixa<=5
				_nComissao	:= 0.7 
				_nComissaos := 0.35
			Else
				_nComissao	:= 0.7 
				_nComissaos := 0.35
			EndIf


		//EPI
		ElseIf TRIM(_cGrupo)=="02" .or. TRIM(_cGrupo)=="05"
		
			If _nFaixa<=0
				_nComissao := 1.90 
				_nComissaos := 0.95
			ElseIf _nFaixa<=2
				_nComissao	:= 1.80
				_nComissaos := 0.90
			ElseIf _nFaixa<=5
				_nComissao	:= 1.60
				_nComissaos := 0.80 
			Else
				_nComissao	:= 1.60
				_nComissaos := 0.80
			EndIf

		EndIf	

	EndIf


//REPRESENTANTE
ElseIf TRIM(_cTpVendedor)=="2"


	//FRETE FOB
	If TRIM(_cTPFrete)=="F"
	
		//AGRICOLA
		If TRIM(_cGrupo)=="01"
		
			If _nFaixa<=0
				_nComissao := 4.80
			ElseIf _nFaixa<=2
				_nComissao	:= 4.50
			ElseIf _nFaixa<=5
				_nComissao	:= 4.00
			ElseIf _nFaixa<=8
				_nComissao	:= 4.00
			ElseIf _nFaixa<=10
				_nComissao	:= 3.40
			ElseIf _nFaixa>10
				_nComissao	:= 2.00
			EndIf

		//BEBIDAS
		ElseIf TRIM(_cGrupo)=="04" .or. TRIM(_cGrupo)=="05"
		
			If _nFaixa<=0
				_nComissao := 3.5
			ElseIf _nFaixa<=2
				_nComissao	:= 3.40
			ElseIf _nFaixa<=5
				_nComissao	:= 3.00
			ElseIf _nFaixa<=8
				_nComissao	:= 3.00
			ElseIf _nFaixa<=10
				_nComissao	:= 2.50
			ElseIf _nFaixa>10
				_nComissao	:= 1.50
			EndIf

		//EPI
		ElseIf TRIM(_cGrupo)=="02" .or. TRIM(_cGrupo)=="03"
		
			If _nFaixa<=0
				_nComissao := 6.00
			ElseIf _nFaixa<=2
				_nComissao	:= 5.50
			ElseIf _nFaixa<=5
				_nComissao	:= 5.00
			ElseIf _nFaixa<=8
				_nComissao	:= 5.00
			ElseIf _nFaixa<=10
				_nComissao	:= 4.20
			ElseIf _nFaixa>10
				_nComissao	:= 2.50                 
				
				
			EndIf

		EndIf	
	                
	// FRETE CIF
	ElseIf TRIM(_cTPFrete)=="C"
	
		//AGRICOLA
		If TRIM(_cGrupo)=="01"
		
			If _nFaixa<=0
				_nComissao := 4.30
			ElseIf _nFaixa<=2
				_nComissao	:= 4.00
			ElseIf _nFaixa<=5
				_nComissao	:= 3.60
			ElseIf _nFaixa<=8
				_nComissao	:= 3.60
			ElseIf _nFaixa<=10
				_nComissao	:= 3.00
			ElseIf _nFaixa>10
				_nComissao	:= 1.80
			EndIf

		//BEBIDAS
		ElseIf TRIM(_cGrupo)=="04" .or. TRIM(_cGrupo)=="05"
		
			If _nFaixa<=0
				_nComissao := 3.10
			ElseIf _nFaixa<=2
				_nComissao	:= 3.00
			ElseIf _nFaixa<=5
				_nComissao	:= 2.70
			ElseIf _nFaixa<=8
				_nComissao	:= 2.70
			ElseIf _nFaixa<=10
				_nComissao	:= 2.30
			ElseIf _nFaixa>10
				_nComissao	:= 1.40
			EndIf

		//EPI
		ElseIf TRIM(_cGrupo)=="02" .or. TRIM(_cGrupo)=="03"
		
			If _nFaixa<=0
				_nComissao := 5.4
			ElseIf _nFaixa<=2
				_nComissao	:= 5.0
			ElseIf _nFaixa<=5
				_nComissao	:= 4.50
			ElseIf _nFaixa<=8
				_nComissao	:= 4.50
			ElseIf _nFaixa<=10 '
				_nComissao	:= 3.80
			ElseIf _nFaixa>10
				_nComissao	:= 2.30
			EndIf

		EndIf	

    
    EndIf

EndIf



aCols[N,nPosCOM]	:= _nComissao  

if SUA->UA_SUPLENT <> "  "
   aCols[N,nPosCOMS] := _nComissaos
endif


//alert(str(_nComissao))


// Return lRet    
return(.t.)



