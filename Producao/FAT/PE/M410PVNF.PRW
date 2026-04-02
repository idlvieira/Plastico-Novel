#Include "protheus.ch"
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

07/03/2023 Leandro Ferreira - incluido validação de database 

*/
USER FUNCTION M410PVNF()

LOCAL LRET      := .T.
LOCAL AAREA     := GETAREA()
LOCAL AAREA_SC5 := SC5->(GETAREA())   
LOCAL _aSA1 := SA1->(getarea())   
Local uTipoPed    := Posicione("ZZZ",1,xFilial("ZZZ")+"FAT000003"+"001","ZZZ_RETORN") //GetMv("MV_MYTPED2")
Local cDtSrv	:= Date()
Local cDtUsr	:= dDatabase
            

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
	
	If cDtUsr <> cDtSrv
		Alert("A data-base de seu sistema difere da data-base do servidor, por isso a NF não poderá ser gerada! Saia do sistema ou ajuste sua data-base! Data-base do Servidor "+DTOC(cDtSrv))
		LRET	:= .F.
	EndIf	
RESTAREA(AAREA_SC5)
RESTAREA(_aSA1)
RESTAREA(AAREA)  


RETURN(LRET)
