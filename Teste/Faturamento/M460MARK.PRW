
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MARK  ºAutor Rui Ronaldo Scandiuzziº Data ³  03/03/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na marcacao dos pedidos liberados         º±±
±±º          ³ para gerar nota fiscal                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M460MARK()

LOCAL LRET      := .T.
LOCAL AAREA     := GETAREA()
LOCAL AAREA_SC9 := SC9->(GETAREA())
LOCAL AAREA_SUA := SUA->(GETAREA())  
LOCAL AAREA_SC6 := SC6->(GETAREA())  
LOCAL AAREA_SF4 := SF4->(GETAREA())
LOCAL AAREA_SB2 := SB2->(GETAREA())    
LOCAL AAREA_SA1 := SA1->(GETAREA())   
LOCAL AAREA_SC5 := SC5->(GETAREA())
LOCAL _bLOQCLI      := .F.          
Local uTipoPed    := GetMv("MV_MYTPED2")



DBSELECTAREA("SUA")
DBSETORDER(8)
DBSELECTAREA("SC9")
DBGOTOP()
WHILE !EOF()
	IF PARAMIXB[2]
		IF SC9->C9_OK <> PARAMIXB[1]
			DBSELECTAREA("SUA")
			IF DBSEEK(SC9->C9_FILIAL+SC9->C9_PEDIDO)
				IF SUA->UA_AUTENT == "N" .AND. DTOS(DATE()) < DTOS(SUA->UA_DATFAT)
					ALERT("Data de entrega maior que a data atual ! Pedido: "+SC9->C9_PEDIDO)
					LRET := .F.
					EXIT
				ENDIF
			ENDIF 
			DBSELECTAREA("SC5")
            DBSETORDER(1)
            DBSEEK(SC9->C9_FILIAL+SC9->C9_PEDIDO, .T.)  
            IF C5_TIPO$uTipoPed
		    	dbselectarea("SA1")  //* Verifica se o Cliente esta Bloqueado
                dbsetorder(1)
                if dbseek(xFilial()+SC9->C9_CLIENTE+SC9->C9_LOJA)
                	if SA1->A1_MSBLQL = "1"
                     _bLOQCLI := .T.   
	                 LRET := .F.	          
                	endif	
                endif           //Fim Verifica CLiente Bloqueado.  
            ENDIF          
            
            
		ENDIF
	ELSE
		IF SC9->C9_OK == PARAMIXB[1] 		
			DBSELECTAREA("SUA")
			IF DBSEEK(SC9->C9_FILIAL+SC9->C9_PEDIDO)
				IF SUA->UA_AUTENT == "N" .AND. DTOS(DATE()) < DTOS(SUA->UA_DATFAT)
					ALERT("Data de entrega maior que a data atual ! Pedido: "+SC9->C9_PEDIDO)
					LRET := .F.
					EXIT
				ENDIF
			ENDIF  
						
			DBSELECTAREA("SC6")
            DBSETORDER(1)
            DBSEEK(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM, .T.)
            DBSELECTAREA("SF4")
            DBSEEK(xFilial()+SC6->C6_TES)
            IF SC9->C9_OK == PARAMIXB[1]
            	IF SF4->F4_ESTOQUE == "S"
	            	DBSELECTAREA("SB2")
	                DBSEEK(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL, .T.)              
	                IF SB2->B2_QATU - SC9->C9_QTDLIB < 0      	
	                	MSGALERT("SALDO INSUFICIENTE NO PRODUTO ( "+RTRIM(SC9->C9_PRODUTO)+" ).","ATENCAO!!!")   
	                	LRET := .F.	              
	                ENDIF
            	ENDIF
             ENDIF 
            DBSELECTAREA("SC5")
            DBSETORDER(1)
            DBSEEK(SC9->C9_FILIAL+SC9->C9_PEDIDO, .T.)  
            IF C5_TIPO$uTipoPed
               dbselectarea("SA1")  //* Verifica se o Cliente esta Bloqueado
               dbsetorder(1)
               if dbseek(xFilial()+SC9->C9_CLIENTE+SC9->C9_LOJA)
                	if SA1->A1_MSBLQL = "1"
                      _bLOQCLI := .T.   
	                  LRET := .F.	          
                	endif	
               endif           //Fim Verifica CLiente Bloqueado.     
            ENDIF   
             
             
		ENDIF                                                       
	ENDIF
	DBSELECTAREA("SC9")
	DBSKIP()
ENDDO 

IF _bLOQCLI   //* Exibe alerta se o Clienet estiver Bloqueado.
  MSGALERT("Existe Cliente Bloqueado no(s) Pedido(s) marcado(s)!","Verificar com Financeiro!!!")    
ENDIF   
 

RESTAREA(AAREA_SC6)
RESTAREA(AAREA_SF4)
RESTAREA(AAREA_SB2) 
RESTAREA(AAREA_SC5)

RESTAREA(AAREA_SC9)
RESTAREA(AAREA_SUA)
RESTAREA(AAREA)  
RESTAREA(AAREA_SA1) 

 


RETURN(LRET)