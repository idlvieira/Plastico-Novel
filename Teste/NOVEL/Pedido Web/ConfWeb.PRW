#Include "rwmake.ch"

/*
Programa			CONFWEB
Descrição			Tela para digitação dos parâmetros usados na integração
Criação				Renata Barreto - agosto/2002
*/
User Function ConfWeb
ftp := cBaixaPed := userftp := passftp :=  envia := cGerOrc := cImpPed := cExport :=cFtpOrc:=cExport:=cPathArq :=SPACE(60)
AtuSx6()                                                                       

ftp       := GetMv("MV_FTP")+Space(60) 
cPathArq  := GetMv("MV_PATHARQ")+Space(60)
cBaixaPed := GetMv("MV_BXPED")+Space(60); userftp := GetMv("MV_USERFTP")+Space(60)
passftp   := GetMv("MV_PASSFTP")+Space(60); envia := GetMv("MV_ENVIA")+Space(60)
cGerOrc   := GetMv("MV_GERORC")+Space(60); cImpPed := GetMv("MV_IMPPED")+Space(60)
cFtpOrc   := GetMv("MV_FTPORC") + Space(60) 
cExport   := GetMv("MV_EXPORT") + Space(60)

@ 0,0 TO 500,600 DIALOG oDlg TITLE "Parametros da Integracao Web"
@ 5,5 TO 300,300
@ 20,030 SAY "Endereco do FTP:"          
@ 20,150 GET ftp size 100,800
@ 35,030 SAY "Usuario do FTP:"          
@ 35,150 GET userftp size 100,800
@050,030 SAY "Senha do FTP:"          
@050,150 GET passftp size 100,800
@065,030 SAY "Path do FTP p/ Pedidos:"          
@065,150 GET cBaixaPed size 100,800
@080,030 SAY "Path no AP5 p/ importar Pedidos:"
@080,150 GET cImpPed  size 100,800
@095,030 SAY "Path no AP5 para gerar arq. Orcamento:" 
@095,150 GET cGerOrc size 100,800                                                                                                   
@110,030 SAY "Path no FTP para enviar arq. Orcamento:" 
@110,150 GET cFtpOrc size 100,800                                                                                                   
@125,030 SAY "Path no AP5 para gerar arq. Atualizacao: "
@125,150 GET cExport  size 100,800
@140,030 SAY "Endereco Adicionais "
@155,030 SAY "para envio de mensagens:"         
@155,150 GET envia  size 100,800                                                                
@170,030 SAY "Path no Ftp p/ envio de arq. atualiz.:"
@170,150 GET cPathArq size 100,800 

@ 222,170 BMPBUTTON TYPE 1 ACTION GravaSx6()
@ 222,210 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

// Criacao dos parametros na primeira vez que acessa a rotina

Static Function AtuSX6         


ftp := cBaixaPed := userftp := passftp := envia := cGerOrc := cImpPed := cExport :=cFtpOrc:=cExport:= SPACE(60)

dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_FTPORC")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_FTPORC"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Indica o nome da pasta onde os arquivos que " 
	SX6->X6_DESC1	 := "serao enviados para o ftp serao gravados. " 
	SX6->X6_DESC2 	 := "" 
	SX6->X6_CONTEUD := space(60)//pathap5
	MsUnlock()
Endif


dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_PATHARQ")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_PATHARQ"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Indica o nome da pasta onde os arquivos que " 
	SX6->X6_DESC1	 := "serao baixados do ftp serao gravados. A pasta " 
	SX6->X6_DESC2 	 := "devera estar dentro da estrutura do AP5." 
	SX6->X6_CONTEUD := space(60)//pathap5
	MsUnlock()
Endif



dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_FTP")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_FTP"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Indica o endereco de ftp onde os arquivos texto"
	SX6->X6_DESC1	 := "referentes ao Pedido Web estarao gravadas."
	SX6->X6_DESC2 	 := ""
	SX6->X6_CONTEUD := ftp
	MsUnlock()
EndIf                            

dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_BXPED")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_BXPED"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Indica a pasta onde se encontram os arquivos"
	SX6->X6_DESC1	 := "gerados a partir da inclusao de um pedido na"
	SX6->X6_DESC2 	 := "web"
	SX6->X6_CONTEUD := cBaixaPed
	MsUnlock()
EndIf                                

dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_USERFTP")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_USERFTP"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Nome do usuario de acesso ao ftp."
	SX6->X6_DESC1	 := ""
	SX6->X6_DESC2 	 := ""
	SX6->X6_CONTEUD := userftp
	MsUnlock()
EndIf

dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_PASSFTP")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_PASSFTP"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Senha do usuario de acesso ao ftp."
	SX6->X6_DESC1	 := ""
	SX6->X6_DESC2 	 := ""
	SX6->X6_CONTEUD := passftp
	MsUnlock()
EndIf                                  

dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_ENVIA")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_ENVIA"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Deve ser informados os e-mails que receberao" 
	SX6->X6_DESC1	 := "enviar mensagens, alem dos clientes e "
	SX6->X6_DESC2 	 := "vendedores." 
	SX6->X6_CONTEUD := envia
	MsUnlock()
EndIf                                

dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_GERORC")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_GERORC"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Deve ser informados a pasta onde serao" 
	SX6->X6_DESC1	 := "gravdos os arquivos gerados pela rotina"
	SX6->X6_DESC2 	 := "de orcamentos."
	SX6->X6_CONTEUD := cGerOrc
	MsUnlock()
EndIf                                

dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_IMPPED")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_IMPPED"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Informar a pasta onde serao gravados os arquivos"
	SX6->X6_DESC1	 := "baixados do ftp, referentes a pedidos de venda."
	SX6->X6_DESC2 	 := "" 
	SX6->X6_CONTEUD := cImpPed
	MsUnlock()
EndIf                                

dbSelectArea("SX6")
dbSetOrder(1)
If !dbSeek(xFilial("SX6")+"MV_EXPORT")
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_EXPORT"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Informar a pasta onde serao gravados os arquivos"
	SX6->X6_DESC1	 := "baixados do ftp, referentes a pedidos de venda."
	SX6->X6_DESC2 	 := "" 
	SX6->X6_CONTEUD := cExport
	MsUnlock()
EndIf                                

Return

Static Function GravaSx6

Close(oDlg)

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_FTP")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := ftp
	MsUnlock()
EndIf                            

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_BXPED")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := cBaixaPed
	MsUnlock()
EndIf                                

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_USERFTP")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := userftp
	MsUnlock()
EndIf

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_PASSFTP")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := passftp
	MsUnlock()
EndIf                                  

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_FTPORC")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := cFtpOrc
	MsUnlock()
EndIf                                  

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_ENVIA")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := envia
	MsUnlock()
EndIf                                

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_GERORC")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := cGerOrc
	MsUnlock()
EndIf                                


dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_IMPPED")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := cImpPed
	MsUnlock()
EndIf                                

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_EXPORT")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := cExport
	MsUnlock()
EndIf                                

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_PATHARQ")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := cPathArq
	MsUnlock()
EndIf                                

Return