#include "rwmake.ch"    

User Function NovEst04()

SetPrvt("_CGRUPO,_CSUB,_CCLAS1,_CCLAS2,CALIAS,CORD")
SetPrvt("CREG,_CCODANT,_CCOD,_CSEQTEMP,_CSEQ,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NOVEST04 ³ Autor ³ Flavia Sa           ³Criado³ 24.Set.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gatilho para criacao da sequencia de codigo de produto     ³±±
±±³baseado nas tabelas de Grupos/SubGrupo/Classificacao 1 e 2             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAEST E SIGACOM (SB1010)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Atualizado³ 23.SET.2001                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Arquivos Relacionados³ SBM,SZ1,SZ2 E SZ3                               ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
_cGrupo := M->B1_GRUPO
_cSub   := M->B1_SUBGRUP
_cClas1 := M->B1_CLASSE1
_cClas2 := M->B1_CLASSE2

cAlias := Alias()
cOrd   := IndexOrd()
cReg   := Recno()

// Tratar o preenchimento de todos os campos da sequencia do codigo 
If Empty(_cGrupo) .or. Empty(_cSub) .or. Empty(_cClas1) .or. Empty(_cClas2) 

 Msgbox("Favor preencher todos os campos necessarios!")
 Return()

Endif

_cCodAnt := Substr(_cGrupo,4,1) + _cSub + _cClas1 + _cClas2

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial()+_cCodAnt,.T.)

If found()
 
 While substr(SB1->B1_COD,1,8) == _cCodAnt

   _cSeqTemp := substr(SB1->B1_COD,9,3) 

 Dbskip()                   

 End    

Else
 
 _cSeqTemp := "000"

Endif

_cSeq := strzero(val(_cSeqTemp)+1,3)
_cCod := Substr(_cGrupo,4,1) + _cSub + _cClas1 + _cClas2 +_cSeq 
 
Dbselectarea(cAlias)
Dbsetorder(cOrd)

Return(_cCod)
