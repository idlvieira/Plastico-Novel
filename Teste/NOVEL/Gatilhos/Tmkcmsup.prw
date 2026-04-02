#include "rwmake.ch"
USER FUNCTION TMKCMSUP()

//----------------------------------------------------------------------------
//|Programa  | TMKCMSUP    | Autor | Eliene Cerqueira    |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo UB_PRODUTO - Pega % comissao do suplente     |
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------

DbSelectArea("SB1")
If ALLTRIM(SU7->U7_NREDUZ)<>ALLTRIM(SA3->A3_NREDUZ) .and. ! (alltrim(substr(cusuario,7,15)) $ getmv("MV_AMGRAT"))
//   nValor:=SB1->B1_CMSUPLE -> alteração feita no dia 01/03/05 pois Barbara será a única suplente e com comissão total
//   nValor:=SB1->B1_COMIS -> alteração feita no dia 30/01/06 pois Barbara deixou de receber comissao total, pois passou a ser executiva de vendas
   nValor:=SB1->B1_CMSUPLE
   If Date()-SB1->B1_DATREF<120
      nValor:=SB1->B1_COMIS*2
   Endif            
Else
   nValor:=0
Endif

return(nValor)