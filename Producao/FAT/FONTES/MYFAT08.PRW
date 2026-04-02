#include "rwmake.ch"
//#include "protheus.ch"
#include "topconn.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVFAT09   ºAutor  ³Kleverson          º Data ³  21/03/14   º±±
±±ºPrograma  ³MYFAT08    ºRevisao³Sonia Silva        º Data ³  27/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retornar Pedido Venda Liberado para Fase Expedicao         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MYFAT08() //User Function NOVFAT09()      

SetPrvt("WCONTINUA")
WCONTINUA:=.T.
WHILE WCONTINUA
   TLPED()
ENDDO
REturn

Static Function TLPED()
wPED:=Space(6)
@ 00,00  TO 180,400 DIALOG oDlg1 TITLE "Retorna Pedido Liberado para Fase Expedicao"
@ 03,05  TO 50,200           
@ 15,10  say "Pedido :"    
@ 15,50  GET  wPED SIZE  50,20 PICTURE "999999" VALID NaoVazio()    
      
@ 60,080 BMPBUTTON TYPE 1 ACTION nseqOk1()
@ 60,110 BMPBUTTON TYPE 2 ACTION nseqCan1()
ACTIVATE DIALOG oDlg1 CENTER
Return

Static Function nseqOk1()
************************

        dbselectarea("SC5")
		dbsetorder(1)
		if dbseek(xFilial()+wPED) 
			reclock("SC5",.f.)                                            
			SC5->C5_ZZUANA3 := "N" //SC5->C5_UANA3 := "N"
			msunlock()  
			MSGALERT("Pedido Retornado para Fase Expedicao!")
			
			MAILEXP()
			
		else
		    Msgbox("Pedido nao cadastrado!")
            Return
		endif

  Close(oDlg1)

Return

Static Function nseqCan1()
*************************
WCONTINUA:=.F.
Close(oDlg1)
Return


Static Function MAILEXP()

// SSILVA 20170103 - FUNCAO QUE ENVIA EMAIL PARA A EXPEDICAO AVISANDO DO RETORNO DO FATURAMENTO

Local oHtml
Local oEmail
Local cServidor	:=	GetMv("MV_RELSERV")
Local cConta	:=	GetMv("MV_RELACNT")
Local cPassWord	:=	GetMv("MV_RELPSW")
Local cAutentic	:=	GetMv("MV_RELAUTH")
Local cAnexo    := ''
Local cTitulo 	:= ""
Local aCorpo  	:= {}
Local aRodape 	:= {}
Local cAssunto  := " O Pedido de Numero "+SC5->C5_NUM+" Foi retornado para o PCP!"
Local cPara 	:= Posicione ("ZZZ",1,xFilial("ZZZ")+"FAT000010"+"001","ZZZ_RETORN")	
Local cCC		:= ""
Local cCCo		:= ""
Local cRemet 	:= GetMv("MV_RELACNT")

aAdd(aCorpo, 'O Pedido abaixo:')
aAdd(aCorpo, '')
aAdd(aCorpo, 'Numero '+SC5->C5_NUM )
aAdd(aCorpo, '')
aAdd(aCorpo, 'Foi retornardo da expedicao para o PCP! ')
aAdd(aRodape, '')
aAdd(aRodape, 'Obrigado')

oHtml:= CorpoEmail():New(cTitulo, aCorpo, aRodape)
oHtml:GeraHtml()
&&Enviando E-mail
oEmail:=ConEmail():New(cServidor, cConta, cPassWord, ,cAutentic, )
oEmail:EmailUsr()
oEmail:Conectar()
If oEmail:Enviar(AllTrim(cRemet), AllTrim(cPara), AllTrim(cCC), AllTrim(cCCO), AllTrim(cAssunto), oHtml:cHtml, cAnexo)
	lRetorno	:=	.t.
	Aviso(FunDesc(),"E-mail enviado com SUCESSO.",{"OK"})
Endif
oEmail:Desconec()

Return
