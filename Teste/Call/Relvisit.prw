#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 01/07/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Relvisit()        // incluido pelo assistente de conversao do AP5 IDE em 01/07/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ Relvisit ³ Autor ³   Marcos L. Santos    ³ Data ³ 01.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de relatorio de Visitas (PNVFT04)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                
Pergunte("TMK04")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel            :=""
tamanho          :="M"
titulo           :="Emissao do Relatorio de Visitas"
cDesc1           :="Emiss„o do Relatorio de Visitas, de acordo com"
cDesc2           :="intervalo informado na op‡„o Parƒmetros."
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :="" //  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="TMK04"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog         :="PNVTM4"
nLastKey         :=0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=132
lRodape          :=.F.
cPictQtd         :=""
wnrel            := "Relvisit"
cString          := "SA1"

wnrel:=SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif


RptStatus({||C730Imp()})
Return

Static Function C730IMP

@ 0,0 PSay AvalImp(limite)

DbSelectArea("SA3")
DbSetOrder(2)
DbSeek(xFilial("SA3")+AllTrim(UPPER(Substr(cUsuario,7,15))),.T.)       
If Found()                                    
   _cVendA3:=AllTrim(SA3->A3_COD)
Else 
   msgstop("Vendedor nao encontrado.")
   Return
Endif
// Seleciona somente os clientes do vendedor logado no momento.
DbSelectArea("SA1")

cFiltro  := "(AllTrim(A1_VEND) == _cVendA3)"

cChave   := "A1_EST+A1_MUN+A1_NREDUZ"
cIndSA1  := CriaTrab(Nil,.F.)
IndRegua("SA1", cIndSA1, cChave, , cFiltro, "Aguarde, Selecionando os Clientes...")

DbSelectArea("SA1")
DbGoTop()
SetRegua(RecCount())

li := 0

While !EOF()
        If SA1->A1_EST = AllTrim(mv_par01) 
                ImpCabec()
                ImpCorpo()
                ImpRodape()
                DbSelectArea("SA1")
                DbSkip()
        Else
                DbSelectArea("SA1")
                DbSkip()
        EndIf

End
// Fechamento do programa

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

RetIndex("SA1")

MS_FLUSH()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Boletim                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PNV001                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec

li := 1
//SetPrc(0,0)
//@ li, 000 PSAY CHR(15)
// @ li, 000 PSAY "PLASTICOS NOVEL DO NORDESTE S/A"
// li := li + 1
// @ li, 001 PSAY "CGC:"
// @ li, 006 PSAY SM0->M0_CGC PICTURE "@R 99.999.999/9999-99"
// @ li, 035 PSAY "Insc.Est.: "+SM0->M0_INSC+"  www.novel.com.br"
// li := li + 1
// @ li, 001 PSAY AllTrim(SM0->M0_ENDCOB)+" - "+SM0->M0_ESTCOB+" 099 -Cx.P. 10 - CEP "+Substr(SM0->M0_CEPCOB,1,5)+"-"+Substr(SM0->M0_CEPCOB,6,3)
// li := li + 1
// @ li, 001 PSAY AllTrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+" Fones: "
// li := li + 1
// @ li, 001 PSAY "e-mail:"
// li := li + 3

@ li, 001 PSAY "NOME: "+SA1->A1_NOME
li := li + 1
@ li, 001 PSAY "ENDERECO: "+SA1->A1_END
li := li + 1
@ li, 001 PSAY "BAIRRO: "+SA1->A1_BAIRRO
li := li + 1
@ li, 001 PSAY "CIDADE: "+SA1->A1_MUN
li := li + 1
@ li, 001 PSAY "TELEFONE: "+SA1->A1_TEL
li := li + 1
@ li, 001 PSAY "CONTATO: "+SA1->A1_CONTATO
li := li + 1
@ li, 001 PSAY "ULTIMA COMPRA: "
@ li, 016 PSAY SA1->A1_ULTCOM
li := li + 1
// @ li, 001 PSAY Replicate("-",limite)
// li := li + 1


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PNV001                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCorpo

@ li, 000 PSAY Replicate ("-",116)
li:=li+1
//              012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456748901234567899012
//                        10        20        30        40        50        60        70        80        90        100       110        120        130
@ li, 000 PSAY "|           PRODUTOS            |      PRECO PRATICADO      |      PRECO ATUAL               |     QUANTIDADE      |"
li:=li+1
DbSelectArea("SZ7")
DbSeek(xFilial()+Alltrim(SA1->A1_ATIVIDA))

While !Eof() .And. Z7_LINHA ==  AllTrim(SA1->A1_ATIVIDA)
  @ li, 000 PSAY Replicate ("-",116)
  li:=li+1
  @ li, 000 PSAY "| "+ALLTRIM(Z7_PRODUTO)
  @ li, 032 PSAY "|"
  @ li, 060 PSAY "|"
  @ li, 093 PSAY "|"
  @ li, 115 PSAY "|"
  li:=li+1
  Dbskip()
End                           

If !Empty(SA1->A1_LINHA2)

 DbSelectArea("SZ7")
 DbSeek(xFilial()+Alltrim(SA1->A1_LINHA2))

 While !Eof() .And. Z7_LINHA ==  AllTrim(SA1->A1_LINHA2)
  @ li, 000 PSAY Replicate ("-",116)
  li:=li+1
  @ li, 000 PSAY "| "+ALLTRIM(Z7_PRODUTO)
  @ li, 032 PSAY "|"
  @ li, 060 PSAY "|"
  @ li, 093 PSAY "|"
  @ li, 115 PSAY "|"
  li:=li+1
  Dbskip()
 End  
                         
Endif

@ li, 000 PSAY Replicate ("-",116)
li:=li+1


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PNV001                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape

li:=li+1
@ li,000 PSAY "OBSERVACOES:"
@ li,012 PSAY Replicate("-",120)
li:=li+2
@ li,000 PSAY Replicate("-",limite)
li:=li+2
@ li,000 PSAY Replicate("-",limite)
li:=li+2
@ li,000 PSAY Replicate("-",limite)
li:=li+2
@ li,000 PSAY Replicate("-",limite)
li:=li+2
@ li,000 PSAY Replicate("-",limite)
li:=li+2
@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY "DATA VISITA         INICIO          TERMINO"
li:=li+1
@ li,000 PSAY "   /   /"+StrZero(Year(Date()),4)+"           :               :   "
li:=li+2

li:=li+(65-li)

@ li,000 PSAY "."
li:=li+1
@ li,000 PSAY CHR(18)
li:=li+1

Return

