#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"     
   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MYEDISA2  ºAutor  ³ Mario F. Silveira  º Data ³  23/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geração do arquivo TXT para o cadastro de fornecedores.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENÉRICO.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MYEDISA2()
  Local cNameFil := "cifnov2.txt"
  Local oFilTXT
  Local cQuery
  Local oFTP
  Local oEmail
  Local cTexto := ""
  
  Prepare Environment Empresa "01" Filial "01" TABLES "SA2"
  
  oFilTXT  := GRVTXT():New( cNameFil )
  If !(oFilTXT:CRIARTXT())
    Return
  Endif
  
  dbSelectArea("SA2")
  dbSelectArea("SX5")
  
  cQuery := " SELECT "
  cQuery += "   A2.A2_COD , A2.A2_LOJA , LEFT(A2.A2_NOME,40) A2_NOME , LEFT(A2.A2_END,40) A2_END , "
  cQuery += "   A2.A2_MUN , A2.A2_CEP , A2.A2_ZZPAIS , "
  cQuery += "   X5.X5_DESCRI "
  cQuery += " FROM "
  cQuery += "   "+ RetSQLName("SA2") +" A2 INNER JOIN "+ RetSQLName("SX5") +" X5 ON "
  cQuery += "   X5.X5_FILIAL = '"+ xFILIAL("SX5") +"' AND X5.X5_TABELA = '12' AND "
  cQuery += "   X5.X5_CHAVE = A2.A2_EST AND X5.D_E_L_E_T_ = ' ' "
  cQuery += " WHERE "
  cQuery += "   A2.A2_FILIAL = '"+ xFILIAL("SA2") +"' AND A2.D_E_L_E_T_ = ' ' "
  cQuery += " ORDER BY "
  cQuery += "   A2.A2_COD , A2.A2_LOJA "
  TcQuery cQuery Alias TSA2 New
  TSA2->(dbGoTop())
  While !(TSA2->(EOF()))

    /*  
    **************************************************
    **              Layout do TXT                   **
    **************************************************
    ** Customer - Number	Alphanumeric  -    30   **
    ** Name     - Alphanumeric	          -    40   **
    ** Address  - Line 1 Alphanumeric	  -    40   **
    ** Address  - Line 2 Alphanumeric	  -    40   **
    ** Address  - Line 3 Alphanumeric	  -    40   **
    ** Address  - Line 4 Alphanumeric	  -    40   **
    ** City	    - Alphanumeric	          -    40   **
    ** State	- Alphanumeric	          -    40   **
    ** Zip	    - Alphanumeric	          -    20   **
    ** Country  - Alphanumeric	          -    40   **
    **************************************************
    */   
                    
    oFilTXT:INCLINHA( TSA2->A2_COD+TSA2->A2_LOJA+CHR(9) ;
                     +Alltrim(TSA2->A2_NOME)   +CHR(9)  ;
                     +Alltrim(TSA2->A2_END)    +CHR(9)  ;
                     +""                       +CHR(9)  ;
                     +""                       +CHR(9)  ;
                     +""                       +CHR(9)  ;
                     +Alltrim(TSA2->A2_MUN)    +CHR(9)  ;
                     +Alltrim(TSA2->X5_DESCRI) +CHR(9)  ;
                     +Alltrim(TSA2->A2_CEP)    +CHR(9)  ;
                     +Alltrim(TSA2->A2_ZZPAIS) +SPACE((40 - Len(Alltrim(TSA2->A2_ZZPAIS))))  ;
                    )   
  
    TSA2->(dbSkip())
  Enddo
  TSA2->(dbCloseArea())
  
  If !(oFilTXT:FECHATXT())
    Return
  Endif
  
  Conout("Início da transmissão para o FTP: "+ DTOS(dDataBase) + " Hr " + Time())
  //oFTP := CONEXFTP():NEW( "208.178.227.188" , , "cifmdb1" , "mdb1cif" , )  Modidicado em 26/01/07 por Michel
  //oFTP := CONEXFTP():NEW( "67.36.254.44" , , "cifmdb1" , "mdb1cif" , )  
  oFTP := CONEXFTP():NEW( GETMV("MV_ZZEDFTP") , GETMV("MV_ZZPTFTP") , GETMV("MV_ZZUSFTP") , GETMV("MV_ZZPWFTP") , )  
  oFTP:CONECTAR()
  oFTP:MUDARDIR("cifnov2")
  oFTP:DELARQ( cNameFil )
  If oFTP:UPLOAD( "\system\"+cNameFil , cNameFil )
    oEmail := CONEMAIL():NEW( GETMV("MV_RELSERV") , GETMV("MV_RELACNT") , GETMV("MV_RELPSW") )  
    If oEmail:CONECTAR()
      cTexto := " Arquivo do diretório \system\"+ cNameFil +" foi copiado para o ftp: 67.36.254.44/"+ cNameFil +". "+DTOC(dDataBase) + " Hr " + Time()
      oEmail:EnviarMail( GETMV("MV_RELACNT") , GETMV("MV_ZZEMFTP") , , , "Log. de Upload : "+ DTOC(dDatabase) , cTexto)
      oEmail:DESCONEC()
    Endif
  Endif
  oFTP:DESCONEC()
  Conout("Término da transmissão para o FTP: "+ DTOS(dDataBase) + " Hr " + Time())
  
  Reset Environment
RETURN