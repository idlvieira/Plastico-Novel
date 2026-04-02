#include "rwmake.ch"
#include "Ap5Mail.ch"   
#include "tbiconn.ch"
/*
Programa			ATUBASE
Descrição			Gera arquivos texto com informações dos cadastros usados na integração, e envia os 
						arquivos para o ftp para que possam ser importados.
Criação				Renata Barreto - agosto/2002						
*/
User Function AtuBase

SetPrvt("ARADIO,NRADIO")
Private cString
Private oGeraTxt                                                                
cArqTXT := "" 
cNome := "" 
//cPerg := "ATUFTP"

//CriaPerg()

aRadio := {"Produtos","Clientes ","Transportadoras","Vendedor","Cond. Pagto.","Faturamento"}
nRadio := 1

@ 200,1 TO 450,395 DIALOG oGeraTxt TITLE OemToAnsi("Geracao de Arquivo Texto")
@ 02,10 TO 120,195
@ 10,018 Say " Este programa tem o objetivo de gerar um arquivo texto confo- "
@ 18,018 Say " me os parametros definidos pelo usuário, além enviar o arquivo"
@ 26,018 Say " gerado para o ftp, para que a base de dados da web seja atualizada."

@ 45,018 Say " Tipo de Arquivo:"
@ 45,065 RADIO aRadio VAR nRadio

@ 100,120 BMPBUTTON TYPE 01 ACTION TipoArq()
@ 100,150 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
//@ 60,148 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered


Return                                                      

Static Function TipoArq

If nRadio==1 // Produtos
   Processa({|| IMPSB1() },"Gerando Arquivo de Produtos...")
ElseIf nRadio = 2 // Clientes
   Processa({|| IMPSA1() },"Gerando Arquivo de Clientes... ")
ElseIf nRadio = 3 // Transportadoras
   Processa({|| IMPSA4() },"Gerando Arquivo de Transportadoras...")
ElseIf nRadio = 4 // Vendedor
   Processa({|| IMPSA3() },"Gerando Arquivo de Vendedores...")
ElseIf nRadio = 5 // Condição de Pagamento
   Processa({|| IMPSE4() },"Gerando Arquivo de Cond. Pagto...")
ElseIf nRadio = 6 // Faturamento
   wEmiIni:=Ctod("  /  /  ")
   wEmiFin:=Ctod("  /  /  ")
   @ 0,0 TO 120,210 DIALOG oDlg5 TITLE "Geraçao Arquivo de Faturamento"
   @ 3,5 TO 35,100
   @ 12,14 SAY "Emissao Inicial : "
   @ 22,14 SAY "Emissao Final   : "
   @ 12,60 GET  wEmiIni   SIZE 40,20 PICTURE X3Picture("F2_Emissao")  VALID NaoVazio()
   @ 22,60 GET  wEmiFin   SIZE 40,20 PICTURE X3Picture("F2_Emissao")  VALID NaoVazio()
   @ 40,40 BMPBUTTON TYPE 1 ACTION OkProc1()// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> @ 105,155 BMPBUTTON TYPE 1 ACTION Execute(OkProc2)
   @ 40,70 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
   ACTIVATE DIALOG oDlg5 CENTER
Endif

Processa({|| EnviaFtp() },"Enviando Arquivo para o FTP...")

Close(oGeraTXT)     

Return      


Static Function ImpSB1
// SB1                                                
cNome := "SB1.TXT"
cArqTxt := AllTrim(GetMv("MV_EXPORT"))+cNome
nHdl    := fCreate(cArqTxt)

cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser criado! Verifique se a pasta "+GetMv("MV_EXPORT")+" existe!","Atencao!")
//  Return
Endif

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop() 
ProcRegua(RecCount()) 

Do While !Eof()

	IncProc()
    IF (B1_GRUPO$"0001/0002/0006/0010") .and. SUBSTR(B1_DESC,1,8)<>"NAO USAR"
       nTamLin := 247
	   cLin    := Space(nTamLin) // Variavel para criacao da linha do registros para gravacao

	   cLin :=  PADR(SB1->B1_COD,15)   // Número do Orçamento
	   cLin += PADR(SB1->B1_DESC,40)  // Código do Vendedor
	   cLin += PADR(SB1->B1_TIPO,02)  // Senha do Orçamento
	   cLin += PADR(SB1->B1_UM,02)  // Código do Cliente
	   cLin += PADR(SB1->B1_LOCPAD,02)    // Loja da Cliente
	   cLin += PADR(SB1->B1_CONTA,20) // E-mail do vendedor
	   cLin += PADR(SB1->B1_TS,03) // E-mail do vendedor
	   cLin += PADR(STRZERO((SB1->B1_PRV2*100),14),14) // E-mail do vendedor
	   cLin += PADR(SB1->B1_CODBAR,15) // E-mail do vendedor
	   cLin += PADR(SB1->B1_ORIGEM,1) // E-mail do vendedor
	   cLin += PADR(SB1->B1_GRUPO,4) // E-mail do vendedor
	   cLin += PADR(SB1->B1_SUBGRUP,2) // E-mail do vendedor
	   cLin += PADR(SB1->B1_CLASSE1,3) // E-mail do vendedor
	   cLin += PADR(SB1->B1_CLASSE2,2) // E-mail do vendedor
	   cLin += PADR(SB1->B1_DESCDET,120) // E-mail do vendedor  
	   cLin += cEOL

	   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	      If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Gere o arquivo novamente!","Atencao!")
    	      Exit
	      Endif
	   Endif
    Endif
    dbSkip()
Enddo    
fClose(nHdl)

Return


Static Function EnviaFtp

ProcRegua(3) 

cFtp       := GetMv("MV_FTP")
cUser      := GetMv("MV_USERFTP")
cPassFtp := GetMv("MV_PASSFTP")
cPath     := GetMv("MV_PATHARQ")

IncProc() 
If !FTPConnect(cFtp,21,cUser,cPassFtp)
   MsgStop("Nao foi possivel conectar ao servidor de ftp. Tente novamente.")
   Return
Endif      

IncProc()              

If FTPDirChange(cPath)   
   If !FTPUpload(cArqTxt,cNome)
       MsgStop("Problemas ao copiar o arquivo. Tente novamente.")
   Endif
Endif      

IncProc() 
FTPDisconnect()         

Return

Static Function ImpSA1
// SB1                                                
cNome := "SA1.TXT"
 cArqTxt := GetMv("MV_EXPORT")+cNome
 nHdl    := fCreate(cArqTxt)

 cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser criado! Verifique se a pasta "+GetMv("MV_EXPORT")+" existe!","Atencao!")
//  Return
Endif

dbSelectArea("SA1")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount()) 

Do While !Eof()
    IncProc()
	nTamLin := 571
	cLin    := Space(nTamLin) // Variavel para criacao da linha do registros para gravacao

	cLin :=  PADR(SA1->A1_COD,06)   // Número do Orçamento
	cLin += PADR(SA1->A1_LOJA,02)  // Código do Vendedor
	cLin += PADR(SA1->A1_NOME,50)  // Senha do Orçamento
	cLin += PADR(SA1->A1_NREDUZ,20)  // Código do Cliente
	cLin += PADR(SA1->A1_MARCA,13)    // Loja da Cliente
	cLin += PADR(SA1->A1_TIPO,01) // E-mail do vendedor
	cLin += PADR(SA1->A1_END,30) // E-mail do vendedor
	cLin += PADR(SA1->A1_MUN,25) // E-mail do vendedor
	cLin += PADR(SA1->A1_EST,2) // E-mail do vendedor
	cLin += PADR(SA1->A1_BAIRRO,30) // E-mail do vendedor
	cLin += PADR(SA1->A1_CEP,8) // E-mail do vendedor
	cLin += PADR(SA1->A1_TEL,25) // E-mail do vendedor
	cLin += PADR(SA1->A1_FAX,15) // E-mail do vendedor
	cLin += PADR(SA1->A1_CONTATO,025) // E-mail do vendedor
	cLin += PADR(SA1->A1_CGC,14)   // Número do Orçamento
	cLin += PADR(SA1->A1_INSCR,18)  // Código do Vendedor
	cLin += PADR(SA1->A1_EMAIL,45)  // Senha do Orçamento
	cLin += PADR(SA1->A1_NATUREZ,10)  // Código do Cliente
	cLin += PADR(SA1->A1_ENDCOB,40)    // Loja da Cliente
	cLin += PADR(SA1->A1_BAIRROC,25) // E-mail do vendedor
	cLin += PADR(SA1->A1_CEPC,08) // E-mail do vendedor
	cLin += PADR(SA1->A1_ESTC,2) // E-mail do vendedor
	cLin += PADR(SA1->A1_MUNC,25) // E-mail do vendedor
	cLin += PADR(SA1->A1_VEND,06) // E-mail do vendedor
	cLin += PADR(SA1->A1_CONTA,20) // E-mail do vendedor
	cLin += PADR(SA1->A1_ENDENT,40) // E-mail do vendedor
	cLin += PADR(SA1->A1_BAIRROE,25) // E-mail do vendedor
	cLin += PADR(SA1->A1_CEPE,08) // E-mail do vendedor
	cLin += PADR(SA1->A1_MUNE,15) // E-mail do vendedor	cLin += cEOL
	cLin += PADR(SA1->A1_ESTE,2) // E-mail do vendedor	
	cLin += PADR(SA1->A1_REGIAO,3) // E-mail do vendedor	
	cLin += PADR(SA1->A1_TRANSP,6) // E-mail do vendedor
    cLin += PADR(SA1->A1_COND,3) // E-mail do vendedor
	cLin += PADR(SA1->A1_TPFRET,1) // E-mail do vendedor    
	cLin += PADR(SA1->A1_ME,1)
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Gere o arquivo novamente!","Atencao!")
    	   Exit
	   Endif
	Endif
    dbSkip()
Enddo  
fClose(nHdl)

Return


Static Function ImpSA3
// SA3                                                
cNome := "SA3.TXT"
 cArqTxt := GetMv("MV_EXPORT")+cNome
 nHdl    := fCreate(cArqTxt)

 cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser criado! Verifique se a pasta "+GetMv("MV_EXPORT")+" existe!","Atencao!")
//  Return
Endif

dbSelectArea("SA3")
dbSetOrder(1)
dbGoTop()  
ProcRegua(RecCount()) 

Do While !Eof()
    IncProc()
	nTamLin := 212
	cLin    := Space(nTamLin) // Variavel para criacao da linha do registros para gravacao

	cLin := PADR(SA3->A3_COD,06)   // Número do Orçamento
	cLin += PADR(SA3->A3_NOME,40)  // Código do Vendedor
	cLin += PADR(SA3->A3_NREDUZ,15)  // Senha do Orçamento
	cLin += PADR(SA3->A3_END,40)  // Código do Cliente
	cLin += PADR(SA3->A3_BAIRRO,20)    // Loja da Cliente
	cLin += PADR(SA3->A3_MUN,15) // E-mail do vendedor
	cLin += PADR(SA3->A3_EST,02) // E-mail do vendedor
	cLin += PADR(SA3->A3_CEP,08) // E-mail do vendedor
	cLin += PADR(SA3->A3_TEL,15) // E-mail do vendedor
	cLin += PADR(SA3->A3_FAX,15) // E-mail do vendedor
	cLin += PADR(SA3->A3_TIPO,1) // E-mail do vendedor
	cLin += PADR(SA3->A3_CGC,14) // E-mail do vendedor
	cLin += PADR(SA3->A3_EMAIL,30) // E-mail do vendedor           
	cLin += PADR(SA3->A3_SENHA,6)
	cLin += PADR(SA3->A3_REGIAO,3)
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Gere o arquivo novamente!","Atencao!")
    	   Exit
	   Endif
	Endif
    dbSkip()
Enddo    
fClose(nHdl)

Return


Static Function ImpSA4
// SA4                                          
cNome := "SA4.TXT"
 cArqTxt := GetMv("MV_EXPORT")+cNome
 nHdl    := fCreate(cArqTxt)

 cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser criado! Verifique se a pasta "+GetMv("MV_EXPORT")+" existe!","Atencao!")
//  Return
Endif

dbSelectArea("SA4")
dbSetOrder(1)
dbGoTop()  
ProcRegua(RecCount()) 

Do While !Eof()
    IncProc()
    nTamLin := 83
	cLin    := Space(nTamLin) // Variavel para criacao da linha do registros para gravacao

	cLin :=  PADR(SA4->A4_COD,06)   // Número do Orçamento
	cLin += PADR(SA4->A4_NOME,40)  // Código do Vendedor
	cLin += PADR(SA4->A4_NREDUZ,15)  // Senha do Orçamento
	cLin += PADR(SA4->A4_VIA,15)  // Senha do Orçamento
	cLin += PADR(SA4->A4_END,40)  // Código do Cliente
	cLin += PADR(SA4->A4_MUN,15) // E-mail do vendedor
	cLin += PADR(SA4->A4_EST,02) // E-mail do vendedor
	cLin += PADR(SA4->A4_CGC,14) // E-mail do vendedor
	cLin += PADR(SA4->A4_TEL,15) // E-mail do vendedor
	cLin += PADR(SA4->A4_CONTATO,15) // E-mail do vendedor
	cLin += PADR(SA4->A4_INSEST,14) // E-mail do vendedor
	cLin += PADR(SA4->A4_EMAIL,30) // E-mail do vendedor
	cLin += PADR(SA4->A4_PLACA,8) // E-mail do vendedor
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Gere o arquivo novamente!","Atencao!")
    	   Exit
	   Endif
	Endif
    dbSkip()
Enddo   
fClose(nHdl)

Return

Static Function ImpSE4
// SE4                                          
cNome := "SE4.TXT"
 cArqTxt := GetMv("MV_EXPORT")+cNome
 nHdl    := fCreate(cArqTxt)

 cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser criado! Verifique se a pasta "+GetMv("MV_EXPORT")+" existe!","Atencao!")
//  Return
Endif

dbSelectArea("SE4")
dbSetOrder(1)
dbGoTop()  
ProcRegua(RecCount()) 

Do While !Eof()
	IncProc()
	nTamLin := 18
	cLin    := Space(nTamLin) // Variavel para criacao da linha do registros para gravacao

	cLin :=  PADR(SE4->E4_CODIGO,03)   // Número do Orçamento
	cLin += PADR(SE4->E4_DESCRI,15)  // Código do Vendedor
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Gere o arquivo novamente!","Atencao!")
    	   Exit
	   Endif
	Endif
    dbSkip()
Enddo   
fClose(nHdl)

Return

****************
// Substituido pelo assistente de conversao do AP6 IDE em 23/03/04 ==> Function OkProc2
Static Function OkProc1()
****************
   Processa({|| IMPSF2() },"Gerando Arquivo de Faturamento...")
   Close(oDlg5)
Return

Static Function ImpSF2
// SF2 E SD2
cNome := "FAT.TXT"
cArqTxt := AllTrim(GetMv("MV_EXPORT"))+cNome
nHdl    := fCreate(cArqTxt)

cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser criado! Verifique se a pasta "+GetMv("MV_EXPORT")+" existe!","Atencao!")
//  Return
Endif

dbSelectArea("SF2")
dbSetOrder(3)
dbGoTop()   
ProcRegua(RecCount()) 
nTamLin := 183 // 180
DbSeek(xFilial("SF2")+" "+Dtos(WEmiIni),.T.)
While !EOF() .AND. F2_EMISSAO <= WEmiFin

	IncProc()
    If F2_VEND1<>SPACE(6)
       dbSelectArea("SD2")
       dbSetOrder(3)
	   dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
       Do While !Eof() .AND. D2_DOC=SF2->F2_DOC .AND. D2_SERIE=SF2->F2_SERIE
    	  cLin := Space(nTamLin) // Variavel para criacao da linha do registros para gravacao
          cLin := PADR(SF2->F2_DOC,9) //6
          cLin += PADR(SF2->F2_SERIE,3)
          cLin += PADR(SF2->F2_CLIENTE,6)
          cLin += PADR(SF2->F2_LOJA,2)  
          cLin += PADR(DTOS(SF2->F2_EMISSAO),10)
          cLin += PADR(SF2->F2_TIPO,1) 
          cLin += PADR(SF2->F2_VEND1,6)
          cLin += PADR(SD2->D2_COD,15)
          cLin += PADR(STRZERO((SD2->D2_QUANT*10000),15),15)
          cLin += PADR(STRZERO((SD2->D2_PRCVEN*10000),18),18)
          cLin += PADR(STRZERO((SD2->D2_TOTAL*100),16),16)
          cLin += PADR(SD2->D2_LOCAL,2)
          cLin += PADR(SD2->D2_CF,5)
          cLin += PADR(SD2->D2_TES,3)
          cLin += PADR(SD2->D2_PEDIDO,6)
          cLin += PADR(SD2->D2_ITEMPV,2)
          cLin += PADR(STRZERO((SD2->D2_VALIPI*100),16),16)
          cLin += PADR(STRZERO((SD2->D2_VALICM*100),16),16)
          cLin += PADR(STRZERO((SD2->D2_VALISS*100),16),16)
          cLin += PADR(STRZERO((SD2->D2_DESPESA*100),16),16)
          cLin += cEOL
          If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	         If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Gere o arquivo novamente!","Atencao!")
    	        Exit
  	         Endif
	      Endif
          dbSkip()
	   Enddo   
    Endif
    dbSelectArea("SF2")
    dbSkip()
Enddo    
fClose(nHdl)

Return

Static Function CriaPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("ATUFTP",6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Tipo de Arquivo    ?","","","mv_ch1","N",1 ,0,1,"C","","mv_par01","Produtos","","","","","Clientes","","","","","Transportadora","","","","","Vendedor","","","","","Cond. Pagto.","","","","","Faturamento"})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

dbSelectArea(_sAlias)

Return Nil