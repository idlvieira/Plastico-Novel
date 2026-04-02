#include "rwmake.ch"  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³MYTMK18    º AUTOR ³ CASSIUS CARLOS MARTINS DATA ³  22/11/13 ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESCRICAO ³ CALCULA DESCONTO MICRO EMPRESA                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ COMERCIAL                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION MYTMK18()

	vlrretme	:= 0.00
	vlrretme2	:= 0.00
	vlrretme3	:= 0.00 

	nvalor3		:= M->UB_VRUNIT //Valor total UB_VLRITEM
	nvalorOG	:= M->UB_VRUNIT

	micro		:= 0.00
	microt		:= 0.00
	nvlrtot		:= 0.00          
	Myvlrdesc	:= 0.00
	Mydesc		:= 0.00

	DbSelectArea("SA1")
	
	IF SA1->(dbseek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA ))
	
		IF SA1->A1_ZZME == "1" .AND.  SA1->A1_EST = "BA"
			// $ Posicione("ZZZ", 1, xFilial("ZZZ") + "TMK000010" + "001", "ZZZ_RETORN")  //.AND. SB1->B1_TS<>"529"  
	
			nVunit			:=	M->UB_VRUNIT
			nQt				:= acols[n, gdFieldPos("UB_QUANT")]
	
			micro			:= nVunit * 0.1075 //Posicione("ZZZ", 1, xFilial("ZZZ") + "TMK000010" + "002", "ZZZ_RETORN") //(nVunit * 0.1075)
			microt			:= nvunit - micro
			nvlrtot			:= nValor3 * nqt  
	
			Mydesc			:= 100 - ((microt / nVunit) * 100)
			Myvlrdesc		:= (nvunit * (Mydesc / 100)) * nQt
			If Mydesc > 0
				acols[n, gdFieldPos("UB_VALDESC")]	:= Myvlrdesc 
				acols[n, gdFieldPos("UB_DESC")]	:= Mydesc  
			endif         
			acols[n, gdFieldPos("UB_VLRITEM")]		:= microt * nQT
			nvalor3			:= microt   
	
			// calculo percentual de desconto para analise de desconto  14/10/2013
			wtab			:= M->UA_TABELA
			wprodt			:= acols[n, gdFieldPos("UB_PRODUTO")]
	
			DbSelectArea("DA1")
			DbSetOrder(1)
			DbSeek(xFilial("DA1") + wtab + wprodt) // Posiciona no titulo original do da1.
	
			If !eof() 
				wpreco := DA1->DA1_PRCVEN  
				acols[n, gdFieldPos("UB_PRCTAB")] := DA1->DA1_PRCVEN              
			else
				wpreco := 0.00   
			Endif              
	
			vlrretme  := ((nvalorOG / wpreco)-1) * -100 
	
			acols[n, gdFieldPos("UB_ZZDESCM")] := vlrretme 
	
			return(nvalor3)
		ENDIF   
	ENDIF

return nValor3
