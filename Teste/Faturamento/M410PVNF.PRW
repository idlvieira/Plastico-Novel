
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executado antes da rotina de geração de NF's a partir do   º±±
±±º          ³ pedido de venda                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M410PVNF()

LOCAL LRET      := .T.
LOCAL AAREA     := GETAREA()
LOCAL AAREA_SC5 := SC5->(GETAREA())   
LOCAL _aSA1 := SA1->(getarea())   
Local uTipoPed    := GetMv("MV_MYTPED2")

            

IF SC5->C5_TIPO$uTipoPed
   dbselectarea("SA1")  //* Verifica se o Cliente esta Bloqueado
   dbsetorder(1)
   if dbseek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI) 
     if SA1->A1_MSBLQL = "1"
         MSGALERT("Cliente ( "+RTRIM(SC5->C5_CLIENTE)+" ),Loja( "+RTRIM(SC5->C5_LOJACLI)+" ) Bloqueado!","Entre em Contato com Financeiro!!!")   
         LRET := .F.  	          
     endif	 
   endif           //Fim Verifica CLiente Bloqueado.            
ENDIF   
	

RESTAREA(AAREA_SC5)
RESTAREA(_aSA1)
RESTAREA(AAREA)  


RETURN(LRET)