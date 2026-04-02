#include "rwmake.ch"
USER FUNCTION PNVCC01()

//----------------------------------------------------------------------------
//|Programa  | PNVCC01     | Autor | Eliene Cerqueira    |Criado| 25.Out.2004|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo UB_VRUNIT - Verifica preço mínimo e grava comissões|
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------

nvalor:=M->UB_VRUNIT  
 // nqtd:=acols[n][7]      
nqtd:=acols[n][5]                    

cEstado	:= GetMV("MV_ESTADO")
cNorte	:= GetMV("MV_NORTE")
Aliq    := 0  
//EMPTY(acols[n][6])
If EMPTY(acols[n][28])
   acols[n][28]:="N"
Endif
Tserv:=acols[n][28]
DbSelectArea("SA1")
If SA1->A1_EST==cEstado .or. Empty(Alltrim(SA1->A1_INSCR))
   Aliq:=GetMV("MV_ICMPAD")
Else
   Aliq:=12
Endif   

DbSelectArea("SB1")
Aliq:=(100-Aliq)/100
PCM:=SB1->B1_PRV2/Aliq
DESC:=0
If SB1->B1_SUBGRUP="01" .OR. SB1->B1_SUBGRUP="02" .OR. SB1->B1_SUBGRUP="03"
   DESC:=0.85
ElseIf (SB1->B1_SUBGRUP="04" .OR. SB1->B1_SUBGRUP="05") .AND. Tserv='N'
   If SB1->B1_SUBGRUP="05" .AND. (SB1->B1_CLASSE1="061" .OR. SB1->B1_CLASSE1="062")
      DESC:=0.5
   Else
      DESC:=0.9
   Endif
ElseIf (SB1->B1_SUBGRUP="04" .OR. SB1->B1_SUBGRUP="05") .AND. Tserv='S'
   DESC:=0.45
Endif
If nValor<(PCM*DESC) .and. SUA->UA_CODLIG<>"SS" .and. SC5->C5_OK<>"SS" // SUA->UA_CODLIG=liberação de preço
   msgBox("Valor do produto inferior ao PCM")
   nValor:=0
Else
 //  acols[n][34]:=SB1->B1_PRV2
   DbSelectArea("SA1")
   IF SA1->A1_ME=="S"  .AND. SA1->A1_EST=="BA"  .AND. SB1->B1_TS<>'529' 
      ndescme:=(nValor *  SA1->A1_DESC/100) * nqtd
      nValor:=nValor-(nValor *  SA1->A1_DESC/100)    
      nvlrtot:=nValor * nqtd  
   ELSE
      nvlrtot:=nValor * nqtd
      ndescme:=0
   ENDIF

   DbSelectArea("SA3")
   If SA3->A3_TIPO=="E"
      nCom:=SA3->A3_COMIS
      If SB1->B1_SUBGRUP="04"
         nCom:=3
      Endif
   ElseIf SA3->A3_COD="999999"
      nCom:=0
   Else
      DbSelectArea("SB1")
      nCom:=SB1->B1_COMIS
   Endif
   If ALLTRIM(SU7->U7_NREDUZ)<>ALLTRIM(SA3->A3_NREDUZ) .and. ! (alltrim(substr(cusuario,7,15)) $ getmv("MV_AMGRAT"))
      nComSP:=SB1->B1_CMSUPLE
   Else
      nComSP:=0
   Endif
   If Date()-SB1->B1_DATREF<120
      nCom:=nCom*2
      nComSP:=nComSP*2
   Endif
   acols[n][24]:=nCom
   acols[n][25]:=nComSP
   acols[n][9]:=ndescme
   acols[n][7]:=nvlrtot
   
ENDIF       

acols[n][14]:=nValor                                

return(nValor)