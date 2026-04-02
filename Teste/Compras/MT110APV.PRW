
User Function MT110APV()

Local lContinua := .T.
   _IdUser  := RetCodUsr()               //Id do usuário ativo       
     PswOrder(1)                          // Ordem de ID 
     PswSeek(SC1->C1_ZZCAPRO,.T.)         //Busca usuaário que com permissao para aprovar a SC
   _aRetUser := PswRet(1)
  
   
   If _IdUser != C1_ZZCAPRO 
      alert("Sem acesso! O usuário atual não está configurado para aprovar esta solicitação de compras.")
     lContinua := .F.
   Endif

Return ( lContinua ) 