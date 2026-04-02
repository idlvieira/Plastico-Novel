#include "rwmake.ch"                                
                                      

USER FUNCTION PNVCC06()
//----------------------------------------------------------------------------
//|Programa  | PNVCC06     |                              |Criado| 25.Out.2004|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo UB_VRUNIT - calcula COMISSOES                |
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------

nPosCOD	:= gdFieldPos("UB_PRODUTO")
nPosPRC	:= gdFieldPos("UB_VRUNIT")
nPosDES	:= gdFieldPos("UB_DESC")
nPosCOM	:= gdFieldPos("UB_CM")
nPosCOMS:= gdFieldPos("UB_CMSUPLE")
nPosSub := M->UA_SUPLENT                                        

DbSelectArea("SA1")
IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA"    
   nPosDES	:= gdFieldPos("UB_DESCME")
ENDIF            
DbSelectArea("SUB")


//_cGrupo			:= Posicione("SB1",1,xFilial("SB1")+aCols[N,nPosCOD],"B1_MYLINHA")
_cGrupo			:= Posicione("SB1",1,xFilial("SB1")+aCols[N,nPosCOD],"B1_CTITEM1")
_cTpVendedor	:= Posicione("SA3",1,xFilial("SA3")+M->UA_MYVEND2,"A3_MYTIPO")
_cTPFrete		:= M->UA_TPFRETE
//_nFaixa			:= nPosDES
_nFaixa         := acols[N,nPosDes]  
_nComissao		:= 0 
_nComsup     := 0

//_nComissao		:= aCols[N,nPosPRC] / Posicione("DA1",1,xFilial("DA1")+M->UA_TABELA+aCols[N,nPosCOD],"DA1_PRCVEN") 
      





//EXECUTIVO DE VENDA
If TRIM(_cTpVendedor)=="1"

	//FRETE FOB
	If TRIM(_cTPFrete)=="F"
	
		//AGRICOLA
		If (_cGrupo)=="01"
		
			If _nFaixa<=0
				_nComissao := 1.50  
		        _nComsup := 0.75 		
			ElseIf _nFaixa<=2
				_nComissao	:= 1.40
				_nComsup := 0.70
			ElseIf _nFaixa<=5
				_nComissao	:= 1.30
				_nComsup := 0.65
			Else
				_nComissao	:= 1.30
				_nComsup := 0.65 
			EndIf
        
		//BEBIDAS
		ElseIf TRIM(_cGrupo)=="04" .or. TRIM(_cGrupo)=="05"
		
			If _nFaixa<=0
				_nComissao := 1.00 
				_nComsup := 0.50
			ElseIf _nFaixa<=2
				_nComissao	:= 0.90
				_nComsup := 0.45
			ElseIf _nFaixa<=5
				_nComissao	:= 0.80
				_nComsup := 0.40
			Else
				_nComissao	:= 0.8 
				_nComsup := 0.4
			EndIf

		//EPI
		ElseIf TRIM(_cGrupo)=="02" .or. TRIM(_cGrupo)=="03"
		
			If _nFaixa<=0
				_nComissao := 2.2 
				_nComsup := 1.1
			ElseIf _nFaixa<=2
				_nComissao	:= 2.0
				_nComsup := 1.0
			ElseIf _nFaixa<=5
				_nComissao	:= 1.8
				_nComsup := 0.9
			Else
				_nComissao	:= 1.8
				_nComsup := 0.9
			EndIf

		EndIf	
	                
	// FRETE CIF
	Elseif TRIM(_cTPFrete)=="C"
	
		//AGRICOLA
		If TRIM(_cGrupo)=="01"
		
			If _nFaixa<=0
				_nComissao := 1.40
				_nComsup := 0.70
			ElseIf _nFaixa<=2
				_nComissao	:= 1.30
				_nComsup := 0.65 
			ElseIf _nFaixa<=5
				_nComissao	:= 1.20
				_nComsup := 0.60 
			Else
				_nComissao	:= 1.20
				_nComsup := 0.60
			EndIf

		//BEBIDAS
		ElseIf TRIM(_cGrupo)=="04".or. TRIM(_cGrupo)=="05"
		
			If _nFaixa<=0
				_nComissao := 0.9  
				_nComsup := 0.45
			ElseIf _nFaixa<=2
				_nComissao	:= 0.8 
				_nComsup := 0.40
			ElseIf _nFaixa<=5
				_nComissao	:= 0.7 
				_nComsup := 0.35
			Else
				_nComissao	:= 0.7 
				_nComsup := 0.35
			EndIf


		//EPI
		ElseIf TRIM(_cGrupo)=="02" .or. TRIM(_cGrupo)=="05"
		
			If _nFaixa<=0
				_nComissao := 1.90 
				_nComsup := 0.95
			ElseIf _nFaixa<=2
				_nComissao	:= 1.80
				_nComsup := 0.90
			ElseIf _nFaixa<=5
				_nComissao	:= 1.60
				_nComsup := 0.80 
			Else
				_nComissao	:= 1.60
				_nComsup := 0.80
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



if nPosSub <> space(3)
   aCols[N,nPosCOMS] := _nComsup
endif


//alert(str(_nComissao))


// Return lRet    
return(_nComissao)







               
