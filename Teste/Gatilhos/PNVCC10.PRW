
#include "rwmake.ch"  
                                      


USER FUNCTION PNVCC10()
//----------------------------------------------------------------------------
//|Programa  | PNVCC05     | Autor | Eliene Cerqueira    |Criado| 14.Out.2013|  
//----------------------------------------------------------------------------
//|Descricao | Gatilho do campo UB_VRUNIT - CALCULA DESCONTO CLIENTE MICROEMPRESA |
//----------------------------------------------------------------------------
//|Uso       | SIGATMK                                                       |
//----------------------------------------------------------------------------

vlrretme  := 0.00
vlrretme2 := 0.00
vlrretme3 := 0.00 



nvalor3 := M->UB_VRUNIT //Valor total UB_VLRITEM
nvalorOG :=M->UB_VRUNIT


micro := 0.00
microt := 0.00
nvlrtot := 0.00          
Myvlrdesc := 0.00
Mydesc := 0.00


 
DbSelectArea("SA1")

IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA" .AND. SB1->B1_TS<>"529"  
   nVunit:=M->UB_VRUNIT
   nQt:=acols[n][5]
    
    micro := (nVunit * 0.1075)
    microt := (nvunit - micro) 
    nvlrtot:=nValor3 * nqt  
   
      
  Mydesc := 100-((microt/nVunit)*100)
  Myvlrdesc := (nvunit * (Mydesc/100))*nQt
  If Mydesc > 0
      acols[n][9]:= Myvlrdesc 
      acols[n][8]:= Mydesc  
  endif         
  acols[n][7]:= (microt * nQT)  
  // nvalor3    :=  (nvunit * nqt) - Myvlrdesc 
  nvalor3    := microt   
  
           
  
// calculo percentual de desconto para analise de desconto  14/10/2013

wtab := M->UA_TABELA
wprodt :=acols[n][2]

DbSelectArea("DA1")
DbSetOrder(1)
DbSeek(xFilial()+wtab+wprodt) // Posiciona no titulo original do da1.
If .not. EOF() 
   wpreco := DA1->DA1_PRCVEN  
   acols[n][14]:= DA1->DA1_PRCVEN              
else
   wpreco := 0.00   
Endif              


//vlrretme  := (wpreco - nvalorOG) / wpreco 
//vlrretme2 := vlrretme * 100 
vlrretme  := ((nvalorOG / wpreco)-1) * -100 


acols[n][40] := vlrretme 

//alert(str(nvalorOG))  
//alert(str(wpreco))
//alert(str(vlrretme))
//alert(str(vlrretme2))



/// FIM CALCULO  
  
  return(nvalor3)

ENDIF   

               
return(nValor3)