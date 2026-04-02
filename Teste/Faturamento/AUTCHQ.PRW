#include "rwmake.ch"        

User Function AUTCHQ()       
                                                  
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa ³ AUTCHQ  ³ Autor ³ Eliene Cerqueira       ³ Data ³ 01.02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para emissao de autorizacao de cheques para frete   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento/Expedição                                      ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
SetPrvt("LIBEMP,CCADASTRO,AROTINA,CMARCA,CGET1,CGET2")            

   wNF1   := Space(6)
   wNF2   := Space(6)
   wNF3   := Space(6)
   wNF4   := Space(6)
   wSer   := "UNI"
   WQTD1  := 0
   WQTD2  := 0
   WQTD3  := 0
   WQTD4  := 0
   WQTDTOT:= 0
   WVAL1  := 0
   WVAL2  := 0
   WVAL3  := 0
   WVAL4  := 0
   WVALTOT:= 0
   WNCLI1 := Space(20)
   WNCLI2 := Space(20)
   WNCLI3 := Space(20)
   WNCLI4 := Space(20)
   WMUN1  := Space(25)
   WMUN2  := Space(25)
   WMUN3  := Space(25)
   WMUN4  := Space(25)
   WUF1   := Space(2)
   WUF2   := Space(2)
   WUF3   := Space(2)
   WUF4   := Space(2)
   WTRANS := Space(6)
   WMOT   := Space(40)
   WCGC   := Space(14)
   WPLACA := Space(8)
   WEND   := Space(33)
   WCID   := Space(15)
   WEST   := Space(2)
   WTEL   := Space(15)
   WALT   := 0
   WLARG  := 0
   WCOMP  := 0
   WSOBRA := 0
   WCAIXAS:= 0
   WPRTAB := 0
   WFRTAB := 0
   WFRPAG := 0
   WDIF   := 0
   WQTDVIA:= 0
   WOBS1  := Space(70)
   WOBS2  := Space(70)
   WOBS3  := Space(70)
   
   @ 000,000 TO 200,320 DIALOG oDlg1 TITLE "Autorização de Emissão de Cheques"
   @ 013,010 SAY "NOTAS FISCAIS:"
   @ 013,050 GET wNF1 PICTURE "@!" VALID naovazio()
   @ 013,075 GET wNF2 PICTURE "@!" 
   @ 013,100 GET wNF3 PICTURE "@!" 
   @ 013,125 GET wNF4 PICTURE "@!" 
   @ 060,050 BMPBUTTON TYPE 1 ACTION TSTNF()
   @ 060,100 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

   ACTIVATE DIALOG oDlg1 CENTERED

Return

Static Function TSTNF()
   DbSelectArea("SF2")  
   DbSetOrder(1)
   Dbseek(xFilial()+WNF1+WSER,.T.)
   
   If SF2->( Found() )
      If F2_TIPO<>"N"
         Msgbox("NF 1 nao é de saída!","Atencao","ALERT")        
         Return                 
      Endif
      WVAL1  := F2_VALBRUT
      WCLI1  := F2_CLIENTE
      WLOJA  := F2_LOJA
      DbSelectArea("SD2")  
      DbSetOrder(3)
      Dbseek(xFilial()+WNF1+WSER,.T.)
      WPED  := D2_PEDIDO            
      WQTD1:=0
      While !eof() .and. D2_DOC=WNF1
         WQTD1 := WQTD1+D2_QUANT
         Dbskip()
      Enddo
	  DbSelectArea("SA1") 
	  DbSetOrder(1)
      DbSeek(xFilial()+WCLI1+WLOJA)
      WNCLI1:=SUBSTR(A1_NREDUZ,1,18)
      WMUN1 :=SUBSTR(A1_MUN,1,14)
      WUF1  :=A1_EST
   Else
      Msgbox("NF 1 nao Existe!","Atencao","ALERT")        
      Return   
   Endif
   If WNF2<>space(6)
      DbSelectArea("SF2")  
      DbSetOrder(1)
      Dbseek(xFilial()+WNF2+WSER,.T.)
   
      If SF2->( Found() )
         If F2_TIPO<>"N"
            Msgbox("NF 2 nao é de saída!","Atencao","ALERT")        
            Return                 
         Endif
         WVAL2  := F2_VALBRUT
         WCLI2  := F2_CLIENTE
         WLOJA  := F2_LOJA
         DbSelectArea("SD2")  
         DbSetOrder(3)
         Dbseek(xFilial()+WNF2+WSER,.T.)
         WPED  := D2_PEDIDO            
         WQTD2:=0
         While !eof() .and. D2_DOC=WNF2
            WQTD2 := WQTD2+D2_QUANT
            Dbskip()
         Enddo
	     DbSelectArea("SA1") 
         DbSetOrder(1)
         DbSeek(xFilial()+WCLI2+WLOJA)
         WNCLI2:=SUBSTR(A1_NREDUZ,1,18)
         WMUN2 :=SUBSTR(A1_MUN,1,14)
         WUF2  :=A1_EST
      Else
         Msgbox("NF 2 nao Existe!","Atencao","ALERT")        
         Return   
      Endif                
   Endif
   If WNF3<>space(6)
      DbSelectArea("SF2")  
      DbSetOrder(1)
      Dbseek(xFilial()+WNF3+WSER,.T.)
   
      If SF2->( Found() )
         If F2_TIPO<>"N"
            Msgbox("NF 3 nao é de saída!","Atencao","ALERT")        
            Return                 
         Endif
         WVAL3  := F2_VALBRUT
         WCLI3  := F2_CLIENTE
         WLOJA  := F2_LOJA
         DbSelectArea("SD2")  
         DbSetOrder(3)
         Dbseek(xFilial()+WNF3+WSER,.T.)
         WPED  := D2_PEDIDO            
         WQTD3:=0
         While !eof() .and. D2_DOC=WNF3
            WQTD3 := WQTD3+D2_QUANT
            Dbskip()
         Enddo
	     DbSelectArea("SA1") 
         DbSetOrder(1)
         DbSeek(xFilial()+WCLI3+WLOJA)
         WNCLI3:=SUBSTR(A1_NREDUZ,1,18)
         WMUN3 :=SUBSTR(A1_MUN,1,14)
         WUF3  :=A1_EST
      Else
         Msgbox("NF 3 nao Existe!","Atencao","ALERT")        
         Return   
      Endif                
   Endif
   If WNF4<>space(6)
      DbSelectArea("SF2")  
      DbSetOrder(1)
      Dbseek(xFilial()+WNF4+WSER,.T.)
   
      If SF2->( Found() )
         If F2_TIPO<>"N"
            Msgbox("NF 4 nao é de saída!","Atencao","ALERT")        
            Return                 
         Endif
         WVAL4  := F2_VALBRUT
         WCLI4  := F2_CLIENTE
         WLOJA  := F2_CLIENTE
         DbSelectArea("SD2")  
         DbSetOrder(3)
         Dbseek(xFilial()+WNF4+WSER,.T.)
         WPED  := D2_PEDIDO            
         WQTD4:=0
         While !eof() .and. D2_DOC=WNF4
            WQTD4 := WQTD4+D2_QUANT
            Dbskip()
         Enddo
	     DbSelectArea("SA1") 
         DbSetOrder(1)
         DbSeek(xFilial()+WCLI4+WLOJA)
         WNCLI4:=SUBSTR(A1_NREDUZ,1,18)
         WMUN4 :=SUBSTR(A1_MUN,1,14)
         WUF4  :=A1_EST
      Else
         Msgbox("NF 4 nao Existe!","Atencao","ALERT")        
         Return   
      Endif                
   Endif
   WQTDTOT:=WQTD1+WQTD2+WQTD3+WQTD4
   WVALTOT:=WVAL1+WVAL2+WVAL3+WVAL4
   DbSelectArea("SC5") 
   DbSetOrder(1)
   DbSeek(xFilial()+WPED)
   WTRANS:= SC5->C5_TRANSP
   DbSelectArea("SA4") 
   DbSetOrder(1)
   DbSeek(xFilial()+WTRANS)
   WPLACA:=A4_PLACA
   WMOT:=A4_NOME
   WCGC:=A4_CGC
   WEND:=SUBSTR(A4_END,1,33)
   WCID:=A4_MUN
   WEST:=A4_EST
   WTEL:=A4_TEL

   @ 000,000 TO 550,550 DIALOG oDlg2 TITLE "Autorização de Emissão de Cheques"
   @ 013,010 SAY "NOTAS FISCAIS:"
   @ 013,060 SAY wNF1 PICTURE "@!"
   @ 013,085 SAY wNF2 PICTURE "@!" 
   @ 013,110 SAY wNF3 PICTURE "@!" 
   @ 013,135 SAY wNF4 PICTURE "@!" 
   @ 023,010 SAY "QTDE TOTAL: " + Transform(WQTDTOT,"@E 99,999.99")
   @ 023,085 SAY "VALOR TOTAL: R$ " + Transform(WVALTOT,"@E 9,999,999.99")
   @ 043,010 SAY "TRANSPORTADOR: "  + WTRANS + " - " + WMOT
   @ 053,010 SAY "CNPJ/CPF: " + WCGC + "           PLACA : " + WPLACA
   @ 063,010 SAY "ENDERECO: " + WEND + "  " + ALLTRIM(WCID) + "/" + WEST + "   FONE: " + WTEL

   @ 083,010 SAY "CUBAGEM"
   @ 093,010 SAY "ALTURA: "
   @ 093,035 GET WALT  PICTURE "@E 999.99"
   @ 093,100 SAY "LARGURA: "
   @ 093,130 GET WLARG PICTURE "@E 999.99"
   @ 093,180 SAY "COMPRIMENTO: "
   @ 093,220 GET WCOMP PICTURE "@E 999.99" VALID CTOTCX()
   @ 113,010 SAY "SOBRAS: "
   @ 113,035 GET WSOBRA PICTURE "@E 999.99" VALID CTOTCX()
   @ 113,100 SAY "TOTAL CAIXAS: "
   @ 113,140 GET WCAIXAS PICTURE "@E 99,999.99" VALID CTOTCX() SIZE 22,20

   @ 133,010 SAY "CALCULO DO FRETE"
   @ 153,010 SAY "PRECO TABELA: "
   @ 153,050 GET WPRTAB PICTURE "@E 99,999.99" VALID CFRTAB()
   @ 163,010 SAY "FRETE TABELA: "
   @ 163,050 GET WFRTAB PICTURE "@E 99,999.99" VALID CFRTAB()
   @ 163,110 SAY "FRETE PAGO: "
   @ 163,145 GET WFRPAG PICTURE "@E 99,999.99" VALID CDIF()
   @ 163,200 SAY "DIF.: "
   @ 163,210 GET WDIF PICTURE "@E 99,999.99" VALID CDIF()

   @ 183,010 SAY "QTD. VIAGENS: "
   @ 183,050 GET WQTDVIA PICTURE "@E 999"

   @ 203,010 SAY "OBS.:"
   @ 203,030 GET WOBS1 SIZE 220,20
   @ 213,030 GET WOBS2 SIZE 220,20
   @ 223,030 GET WOBS3 SIZE 220,20

   @ 250 ,100 BMPBUTTON TYPE 1 ACTION OkProc()
   @ 250 ,150 BMPBUTTON TYPE 2 ACTION Close(oDlg2)

   ACTIVATE DIALOG oDlg2 CENTERED
   Close(oDlg1)

Return     

Static Function CTOTCX()   
   WCAIXAS:=(WALT*WLARG*WCOMP)+WSOBRA
Return 

Static Function CFRTAB()
   WFRTAB:=WQTDTOT*WPRTAB
Return 

Static Function CDIF()
   WDIF:=WFRPAG-WFRTAB
Return 

Static Function OkProc()
   wnrel  	:= "AUTCHQ"    
   titulo 	:= "AUTORIZACAO DE EMISSAO DE CHEQUES"
   cDesc1 	:= ""
   cDesc2 	:= ""
   cDesc3 	:= ""
   tamanho	:= "P"
   limite 	:= 80
   cString := "SC6"
   lEnd    := .F.
   cabec1 	:= "" 
   cabec2 	:= ""
   lContinua  := .T.
   LI       := 80
   m_pag      := 1
   nLastKey := 0
   PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"

   wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

   If nLastKey == 27
      Close(oDlg1)
      Set Filter to
      Return
   Endif

   SetDefault(aReturn,cString)

   If nLastKey==27
      Close(oDlg1)
	  Set Filter to
	  Return
   Endif
   VEZ:=1
   LI := 80
   Limite:=80
   Tamanho:="P"
   @ 0,0 PSay AvalImp(limite)
   LI:=1
   WHILE VEZ < 3  
     @ LI,000 PSAY Replicate("-",limite+2)
     LI := LI + 1
     @ LI,000 Psay "|                      AUTORIZAÇÃO DE EMISSÃO DE CHEQUES                  "
     If Vez = 1
        @ LI,pcol() Psay "1ª Via |"
     Else
        @ LI,pcol() Psay "2ª Via |"
     Endif
     LI := LI + 1
     @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
     LI := LI + 1
     @ LI,000 Psay "| PLACA: " + WPLACA + "               N.REGISTRO: " + WTRANS + "           DATA: " + DTOC(dDataBase) + "      |"
     LI := LI + 1
     @ LI,000 Psay "| MOTORISTA: " + WMOT + "        CPF: " + WCGC + " |"   
     LI := LI + 1
     @ LI,000 Psay "| ENDERECO: " + WEND + "  " + ALLTRIM(WCID) + "/" + WEST + "  FONE: " + SUBSTR(WTEL,1,15) + "|"
     LI := LI + 1
     @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
     LI := LI + 1
     If Vez = 1
        @ LI,000 PSAY "|                                 CUBAGEM                                        |"
        LI := LI + 1
        @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
        LI := LI + 1
        @ LI,000 PSAY "|               ALTURA     : " + Transform(WALT,"@E 999.99") + "     LARGURA    : " + Transform(WLARG,"@E 999.99") + "                      |"
        LI := LI + 1
        @ LI,000 PSAY "|               COMPRIMENTO: " + Transform(WCOMP,"@E 999.99")+ "     SOBRAS     : " + Transform(WSOBRA,"@E 999.99")+ "                      |"
        LI := LI + 1
        @ LI,000 Psay "|--------------------------------------------------------------------------------|"
        LI := LI + 1
        @ LI,000 PSAY "|      TOTAL DE CAIXAS : " + Transform(WCAIXAS,"@E 99,999") + "                    FRETE PAGO  : R$ " + Transform(WFRPAG,"@E 9,999.99") + "     |"
     Else
        @ LI,000 PSAY "|             CUBAGEM             |               CÁLCULO DO FRETE               |"
        LI := LI + 1
        @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
        LI := LI + 1
        @ LI,000 PSAY "|       ALTURA     : " + Transform(WALT,"@E 999.99") + "       |          PREÇO TABELA: R$ " + Transform(WPRTAB,"@E 9,999.99") + "           |"
        LI := LI + 1
        @ LI,000 PSAY "|       LARGURA    : " + Transform(WLARG,"@E 999.99") + "       |          FRETE TABELA: R$ " + Transform(WFRTAB,"@E 9,999.99") + "           |"
        LI := LI + 1
        @ LI,000 PSAY "|       COMPRIMENTO: " + Transform(WCOMP,"@E 999.99") + "       |          DIFERENÇA   : R$ " + Transform(WDIF,"@E 9,999.99") + "           |"
        LI := LI + 1
        @ LI,000 PSAY "|       SOBRAS     : " + Transform(WSOBRA,"@E 999.99") + "       |          QTD. VIAGENS: " + Transform(WQTDVIA,"@E 999") + "                   |"
        LI := LI + 1
        @ LI,000 Psay "|---------------------------------|----------------------------------------------|"
        LI := LI + 1
        @ LI,000 PSAY "|       TOTAL DE CAIXAS : " + Transform(WCAIXAS,"@E 99,999") + "  |          FRETE PAGO  : R$ " + Transform(WFRPAG,"@E 9,999.99") + "           |"
     Endif
     LI := LI + 1
     @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
     LI := LI + 1
     @ LI,000 Psay "|                             DADOS DA CARGA                                     |"   
     LI := LI + 1
     @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
     LI := LI + 1
     @ LI,000 PSAY "| NF " + WNF1 + "  QTD: " + Transform(WQTD1,"@E 9,999") + " R$ " + Transform(WVAL1,"@E 999,999.99") + " CLIENTE: " + ALLTRIM(WNCLI1)+"/"+ALLTRIM(WMUN1)+"-"+WUF1
     @ LI,081 PSAY "|"
     LI := LI + 1
     If WNF2 <> SPACE(6)
        @ LI,000 PSAY "| NF " + WNF2 + "  QTD: " + Transform(WQTD2,"@E 9,999") + " R$ " + Transform(WVAL2,"@E 999,999.99") + " CLIENTE: " + ALLTRIM(WNCLI2)+"/"+ALLTRIM(WMUN2)+"-"+WUF2
        @ LI,081 PSAY "|"
        LI := LI + 1
     Endif
     If WNF3 <> SPACE(6)
        @ LI,000 PSAY "| NF " + WNF3 + "  QTD: " + Transform(WQTD3,"@E 9,999") + " R$ " + Transform(WVAL3,"@E 999,999.99") + " CLIENTE: " + ALLTRIM(WNCLI3)+"/"+ALLTRIM(WMUN3)+"-"+WUF3
        @ LI,081 PSAY "|"
        LI := LI + 1
     Endif
     If WNF4 <> SPACE(6)
        @ LI,000 PSAY "| NF " + WNF4 + "  QTD: " + Transform(WQTD4,"@E 9,999") + " R$ " + Transform(WVAL4,"@E 999,999.99") + " CLIENTE: " + ALLTRIM(WNCLI4)+"/"+ALLTRIM(WMUN4)+"-"+WUF4
        @ LI,081 PSAY "|"
        LI := LI + 1
     Endif
     @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
     LI := LI + 1
     @ LI,000 Psay "|                                 RECIBO                                         |"   
     LI := LI + 1
     @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
     LI := LI + 1
     @ LI,000 Psay "| Recebi da PLÁSTICOS NOVEL DO NORDESTE CNPJ 13.926.910/0001-41 o valor do frete |"   
     LI := LI + 1
     @ LI,000 Psay "| R$ " + Transform(WFRPAG,"@E 9,999.99") + " bem como as respectivas notas fiscais e mercadorias cujos volumes  |"   
     LI := LI + 1
     @ LI,000 Psay "| foram conferidos por mim e serão entregues no destinatário.                    |"   
     LI := LI + 1
     @ LI,000 Psay "| OBS.: Sr. motorista, eventuais atrasos para cargas e descargas não serão de    |"
     LI := LI + 1
     @ LI,000 Psay "|       responsabilidade da Novel.                                               |"
     LI := LI + 1
     @ LI,000 Psay "|                                                                                |"
     LI := LI + 1
     @ LI,000 Psay "| ______________________     ______________________    ______________________    |"
     LI := LI + 1
     @ LI,000 Psay "|      Motorista                   Logística                 Tesouraria          |"
     LI := LI + 1
     @ LI,000 PSAY "|"+Replicate("-",limite)+"|"
     LI := LI + 1
     @ LI,000 Psay "|OBS.: " + WOBS1 + "    |"
     LI := LI + 1
     @ LI,000 Psay "|      " + WOBS2 + "    |"
     LI := LI + 1
     @ LI,000 Psay "|      " + WOBS3 + "    |"
     LI := LI + 1
     @ LI,000 PSAY Replicate("-",limite+2)
     LI := LI + 1
     @ LI,01 PSAY "."
     VEZ:=VEZ + 1
     If LI > 32
        LI:=0
     Endif
   ENDDO
   SET DEVICE TO SCREEN

   If aReturn[5]==1
      dbCommitAll()
      SET PRINTER TO
	   OurSpool(wnrel)
   Endif

   MS_FLUSH()
   Close(oDlg2)
Return      


