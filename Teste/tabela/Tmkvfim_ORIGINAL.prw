#include "rwmake.ch"      
#include "Ap5Mail.ch" 
#include "tbiconn.ch"  
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"        

User Function Tmkvfim(C5_NUM) 

DbSelectArea("SUA")
_nOrdem:=INDEXORD()
_nREG  :=Recno()
                     
TMKVFIM2()  

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑณFuno    ณTmkvFim   ณ Autor ณ Marcos L. Santos      ณ Data ณ 15.12.99 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณCampos complementares no televendas                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณEspecifico Sigatmk (Plasticos Novel)                        ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

SetPrvt("CQQCOR,CGRAVA,CFCHGRAVA")
SetPrvt("CSUPLENTE,COBS1,COBS2,COBS3,AITEMS1")
SetPrvt("AITEMS2,AITEMS3,AITEMS4,NCMSUP,CTPCARGA,CCIFATE")
SetPrvt("CPEDCLI,CNATOP,DDTFAT,CPEDVENEXT,_CALIAS,_NORDEM")
SetPrvt("_NREG,CNUMUA,NCOMIS1,NVALITEM,NTOTVAL,NTOTVALCM")



DbSelectArea("SU7")
DbSetOrder(1)
DbSeek(xFilial()+SUA->UA_SUPLENT,.T.)
DbSelectArea("SA3")
DbSetOrder(1)
DbSeek(xFilial()+SUA->UA_VEND,.T.)
nFrt       := 0
nFrt       := SUA->UA_FRETE   
If ALLTRIM(SU7->U7_NREDUZ)<>ALLTRIM(SA3->A3_NREDUZ)
   DbSelectArea("SA3")
   DbSetOrder(1)
   DbGoTop()
   Do while !eof() .and. ALLTRIM(SU7->U7_NREDUZ)<>ALLTRIM(SA3->A3_NREDUZ)
      Skip
   Enddo
   If ALLTRIM(SU7->U7_NREDUZ)=ALLTRIM(SA3->A3_NREDUZ)
      cSuplente  := SA3->A3_COD
   Else
      cSuplente  :=space(6)
   Endif
Else
   cSuplente  :=space(6)
Endif

_cAlias:=ALIAS()
_nOrdem:=INDEXORD()
_nREG  :=Recno()

DbSelectArea("SUB")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial()+SUA->UA_NUM,.T.)
cNumUA    := UB_NUM
nComis1   := 0.00
nValItem  := 0.00
nTotVal   := 0.00
nTotValCM := 0.00            
nTotValCMSP := 0.00            
                                                                     
While  (SUB->UB_NUM==cNumUA)
   nValItem := (SUB->UB_VRUNIT)*(SUB->UB_QUANT) 
   nTotValCM:= nTotValCM + ((SUB->UB_CM/100)*nValItem)
   nTotValCMSP:= nTotValCMSP + ((SUB->UB_CMSUPLE/100)*nValItem)
   nTotVal  := nTotVal + nValItem
   DbSkip()
Enddo

nComis1 := Round( ((nTotValCM/nTotVal)*100), 2 )
nCMSup := Round( ((nTotValCMSP/nTotVal)*100), 2 )
If SUA->UA_VEND="999999"
   nComis1 :=0
Endif
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SUA->UA_CONDPG)
If SE4->E4_PLANO="N"
   nComis1 :=0
   nCMSup  :=0
Endif


Return



Static Function BasicObj()        

SetPrvt("mDtFat,mQqCor,mGrava,mFchGrava,mObs1,mObs2,mObs3,oGET1")
  
  
  dbSelectArea("SUA") 
  DbSetOrder(_nOrdem)
  DbGoTo(_nREG)  
                              
  mDtFat    := SUA->UA_DATFAT
  mQqCor    := SUA->UA_QQCOR
  mGrava    := SUA->UA_GRAVA
  mFchGrava := SUA->UA_FCHGRAV 
  mObs1      := SUA->UA_OBS1 
  mObs2      := SUA->UA_OBS2 
  mObs3      := SUA->UA_OBS3 
  aItems1    := {"   ","Hot","Silk","Vaz","Adesivo"}
  aItems2    := {"       ","Lateral","Testeira","Ambas","Fundo"}
  aItems3    := {"1-Uso ou Consumo   ","2-Ativo Imobilizado   ","3-Industrializacao   ","4-Comercializacao   "}
  aItems4    := {" Completa  ","  Fracionada  ","  Retira  "}
  aItems5    := {"C-CIF","F-FOB"}
  cTpCarga   = " "         
  nFrt       := 0
  nFrt       := SUA->UA_FRETE
  If SUA->UA_TPCARGA = "C"
     cTpCarga  := "  Completa  "    
  ElseIf SUA->UA_TPCARGA = "F" 
     cTpCarga := "  Fracionada  "
  ElseIf SUA->UA_TPCARGA = "R"
     cTpCarga := "  Retirada  "
  Endif    
  cNatOp = " "  
  If SUA->UA_NATOPER = "1"
     cNatOp    := "  1-Uso ou Consumo  " //SUA->UA_NATOPER // " "
  ElseIf SUA->UA_NATOPER = "2"
     cNatOp    := "  2-Ativo Imobilizado  " 
  ElseIf SUA->UA_NATOPER = "3"
     cNatOp    := "  3-Industrializacao  "
  ElseIf SUA->UA_NATOPER = "4"
     cNatOp    := "  4-Comercializacao  "
  Endif
  cCIFAte    := SUA->UA_CIF_ATE 
  cPedCli    := SUA->UA_PEDCLI 
  DEFINE MSDIALOG oDlg1 TITLE "Dados de Complementacao do Pedido" FROM 000,000 TO 350,800 PIXEL
  
   @ 020,015 Say "Aceitar qualquer cor?" Size 100,100 PIXEL OF oDlg1
   @ 020,80 MsGet OGET1 Var mQqCor PICTURE "@!" PIXEL OF oDlg1                    
   @ 020,140 SAY "Data de Faturamento:" Size 100,100 PIXEL OF oDlg1
   @ 020,195 Msget OGET2 var mdtfat PIXEL OF oDlg1 
   @ 035,015 SAY "Gravacao (S/N)?" Size 100,100 PIXEL OF oDlg1
   @ 035,80 mSGET OGET3 vAR mGrava PICTURE "@!" PIXEL OF oDlg1
   @ 035,140  SAY "Ficha Gravacao(S/N)?" Size 100,100 PIXEL OF oDlg1
   @ 035,195 Msget OGET4 VAR mFchGrava PICTURE "@!" PIXEL OF oDlg1   
   
   @ 050,15 Say "Carga Tipo" Size 100,100 PIXEL OF oDlg1       
   @ 050,75 COMBOBOX cTpCarga ITEMS aItems4 PIXEL OF oDlg1
   
   @ 050,140  SAY "Frete CIF Ate?" Size 100,100 PIXEL OF oDlg1
   @ 050,195 Msget OGET5 VAR cCIFAte PICTURE "@!" PIXEL OF oDlg1 
   
   @ 65,15 Say "Num Pedido Cliente:" Size 100,100 PIXEL OF oDlg1       
   @ 65,75 msget OGET6 var cPedCli PICTURE "@!" PIXEL OF oDlg1
   
   @ 65,140  SAY "Natureza de Operacao" Size 100,100 PIXEL OF oDlg1
   @ 65,195  COMBOBOX cNatOp ITEMS aItems3 SIZE 100,100 PIXEL OF oDlg1 
   
   @ 80,15   SAY "Obs.:  " Size 100,100 PIXEL OF oDlg1
   @ 95,30   msget OGET7 var mobs1 PICTURE "@!" PIXEL OF oDlg1
   @ 110,30  msget OGET8 var mobs2 PICTURE "@!" PIXEL OF oDlg1
   @ 125,30  msget OGET9 var mObs3 PICTURE "@!" PIXEL OF oDlg1
 
 
  @ 145,170 BUTTON "Ok" SIZE 35,15 ACTION VCampos() PIXEL OF oDlg1
ACTIVATE DIALOG oDlg1 CENTER
Return


Static Function VCampos()
             
   Reclock("SUA",.F.)
   Replace SUA->UA_GRAVA   With AllTrim(mGrava)
   Replace SUA->UA_TPCARGA With Substr(AllTrim(cTpCarga),1,1)
   Replace SUA->UA_QQCOR   With AllTrim(mQqCor)
   Replace SUA->UA_FCHGRAV With AllTrim(mFchGrava)
   Replace SUA->UA_CIF_ATE With AllTrim(cCIFAte)
   Replace SUA->UA_PEDCLI  With AllTrim(cPedCli)
   Replace SUA->UA_OBS1    With AllTrim(mobs1)
   Replace SUA->UA_OBS2    With AllTrim(mobs2)
   Replace SUA->UA_OBS3    With AllTrim(mObs3)
   Replace SUA->UA_NATOPER With Substr(AllTrim(cNatOp),1,1)
   Replace SUA->UA_DATFAT  With mdtfat
  // Replace SUA->UA_NUM_ANT With cPedVenExt
   MsUnlock()

   Estcli:=AllTrim(SUA->UA_ESTE)
   CidCli:=AllTrim(SUA->UA_MUNE)
   dbSelectArea("SA1")
   dbSeek(xFilial()+SUA->UA_CLIENTE+SUA->UA_LOJA)
   WMicro:=A1_ME
   WNome:=SUBSTR(A1_NOME,1,16)
   
   // VALIDA 21/10/2013
   DbSelectArea("SUB") 
   DbSetOrder(1)
   DbGoTop()
   DbSeek(xFilial()+SUA->UA_NUM,.T.)
   cNumUA    := UB_NUM
   nComis1   := 0.00
   nValItem  := 0.00
   nTotVal   := 0.00
   nTotValCM := 0.00            
   nTotValCMSP := 0.00            
                                                                     
   While  (SUB->UB_NUM==cNumUA)
         nValItem := (SUB->UB_VRUNIT)*(SUB->UB_QUANT) 
         nTotValCM:= nTotValCM + ((SUB->UB_CM/100)*nValItem)
         nTotValCMSP:= nTotValCMSP + ((SUB->UB_CMSUPLE/100)*nValItem)
         nTotVal  := nTotVal + nValItem
         DbSkip()
   Enddo

   nComis1 := Round( ((nTotValCM/nTotVal)*100), 2 )
   nCMSup := Round( ((nTotValCMSP/nTotVal)*100), 2 )

//FIM VALIDA   
   
   dbselectarea("SC5")
   Reclock("SC5",.F.)
      If SA1->A1_END+SA1->A1_EST<>SUA->UA_ENDENT+SUA->UA_ESTE
         Replace SC5->C5_ENDENT  With AllTrim(SUA->UA_ENDENT)
         Replace SC5->C5_BAIRROE With AllTrim(SUA->UA_BAIRROE)
         Replace SC5->C5_MUNE    With AllTrim(SUA->UA_MUNE)
         Replace SC5->C5_ESTE    With AllTrim(SUA->UA_ESTE)
      Else
         Replace SC5->C5_ENDENT  With SPACE(40)
         Replace SC5->C5_BAIRROE With SPACE(20)
         Replace SC5->C5_MUNE    With SPACE(15)
         Replace SC5->C5_ESTE    With SPACE(02)
      Endif
      Replace SC5->C5_CIDENT  With AllTrim(SUA->UA_MUNE)
      Replace SC5->C5_ESTADO  With AllTrim(SUA->UA_ESTE)
      Replace SC5->C5_GRAVA   With AllTrim(mGrava)
      Replace SC5->C5_TPCARGA With Substr(AllTrim(cTpCarga),1,1)
      Replace SC5->C5_QQCOR   With AllTrim(mQqCor)
      Replace SC5->C5_FCHGRAV With AllTrim(mFchGrava)
      Replace SC5->C5_COMIS1  With nComis1  
      Replace SC5->C5_FRETEII With nFrt 
      Replace SC5->C5_FRETE   With 0 
      Replace SC5->C5_VEND2   With AllTrim(SUA->UA_SUPLENT)
      Replace SC5->C5_COMIS2  With nCmSup
      Replace SC5->C5_CMSUPLE With nCmSup
      Replace SC5->C5_CIF_ATE With AllTrim(cCIFAte)
      Replace SC5->C5_PEDCLI  With AllTrim(cPedCli)
      Replace SC5->C5_OBS1    With AllTrim(mobs1)
      Replace SC5->C5_OBS2    With AllTrim(mobs2)
      Replace SC5->C5_OBS3    With AllTrim(mObs3)
      Replace SC5->C5_NATOPER With Substr(AllTrim(cNatOp),1,1)
//      Replace SC5->C5_NUM_ANT With cPedVenExt
      Replace SC5->C5_TPFRETE With SUA->UA_TPFRETE         
      Replace SC5->C5_NOVORC  With AllTrim(SUA->UA_NUM)     
   MsUnlock()
  
   xVol:=0
   DbSelectArea("SC6")
   DbSetOrder(1)
   DbSeek(xFilial("SC6")+SUA->UA_NUMSC5,.T.)
   If Found()
	  While !EOF() .AND. SUA->UA_FILIAL+SUA->UA_NUMSC5==SC6->C6_FILIAL+SC6->C6_NUM
  	     dbSelectArea("SB1")
	     dbSetOrder(1)     
	     DBSEEK(XFILIAL()+SC6->C6_PRODUTO,.T.)
 	     If  trim(SB1->B1_CLASSE1) = "031" .or. trim(SB1->B1_CLASSE1) = "035" .or. trim(SB1->B1_CLASSE1) = "039"
             xVol:=xVol+((SC6->C6_QTDVEN/SB1->B1_QE)*2)
         Else
             xVol:=xVol+(SC6->C6_QTDVEN/SB1->B1_QE)
         Endif
         DbSelectArea("SC6")
	     Reclock("SC6",.F.)
		 Replace SC6->C6_ENTREG   With mdtfat
//   		 Replace SC6->C6_NUM_ANT  With cPedVenExt
   		 Replace SC6->C6_VEND1    With SC5->C5_VEND1
   		 Replace SC6->C6_VEND2    With SC5->C5_VEND2
   		 Replace SC6->C6_ENCOMED  With "N" 				
   		 Replace SC6->C6_LOCAL    With SB1->B1_LOCPAD
   		 Replace SC6->C6_INIPROD  With Date()
		 MsUnlock()
		 DbSkip()
      End
   EndIf   
	
   RecLock("SC5",.F.)
   SC5->C5_VOLUME1 := xVol
   MsUnlock()
	
   _cEstPad    := getmv("MV_ESTADO")  
   DbSelectArea("SUB")
   DbSetOrder(1)
   DbGoTop()
   DbSeek(xFilial()+SUA->UA_NUM,.T.)
   cNumUA    := UB_NUM
   WMenCap   := space(1)
   While  (SUB->UB_NUM==cNumUA)
      Tes:=SUB->UB_TES
      NatOpe:=Substr(AllTrim(cNatOp),1,1)
      dbSelectArea("SB1")
      dbSetOrder(1)
      dbSeek(xFilial()+SUB->UB_PRODUTO)
      WGrupo:=SB1->B1_GRUPO
      If (SB1->B1_CLASSE1$"031/032/033/035/039/040")
         WMenCap:="028"
      Endif
      WEst:=0
      If (Estcli="AM" .and. (CidCli="MANAUS" .or. CidCli="TABATINGA")) .or. (Estcli="AP" .and. (CidCli="SANTANA" .or. CidCli="MACAPA")) .or.;
         (Estcli="RR" .and. (CidCli="BONFIM" .or. CidCli="PACARAIMA")) .or. (Estcli="RO" .and. CidCli="GUAJARA-MIRIM") .or.;
         (Estcli="AC" .and. (CidCli="CRUZEIRO DO SUL" .or. CidCli="BRASILEIA" .or. CidCli="EPITACIOLANDIA"))
         WEst:=1
      ElseIf (Estcli="AM" .and. CidCli<>"MANAUS" .and. CidCli<>"TABATINGA") .or. (Estcli="AP" .and. CidCli<>"SANTANA" .and. CidCli<>"MACAPA") .or.;
         (Estcli="RR" .and. CidCli<>"BONFIM" .and. CidCli<>"PACARAIMA") .or. (Estcli="RO" .and. CidCli<>"GUAJARA-MIRIM") .or.;
         (Estcli="AC" .and. CidCli<>"CRUZEIRO DO SUL" .and. CidCli<>"BRASILEIA" .and. CidCli<>"EPITACIOLANDIA")
         WEst:=2
      ElseIF WMicro=="S"  .AND. Estcli=="BA"  .AND. SB1->B1_TS<>'529'
         WEst:=4
      Else
         WEst:=3
      Endif
      If SB1->B1_TS="503" .and. WEst<>1 .and. WEst<>4
         Tes:=SB1->B1_TS
      ElseIf SB1->B1_TS="503" .and. WEst=4
         Tes:="504"
      Else
         If NatOpe = "1" .OR. NatOpe = "2"
            If SB1->B1_GRUPO="0001"
               If     WEst=1
                      Tes:="507"
               ElseIf WEst=2
                      Tes:="503"
               ElseIf WEst=3
                      Tes:="502"
               ElseIf WEst=4
                      Tes:="591"
               Endif           
               IF (SB1->B1_GRUPO="0001") .and. SB1->B1_IPI=0 .and. WEst=4
                  Tes:="596"
               endif 
               IF (SB1->B1_GRUPO="0001") .and. SB1->B1_IPI=0 .and. WEst=3
                  Tes:="594"
               endif 
               
            Endif   
            
           If SB1->B1_GRUPO="0006"
               
               If     WEst=1
                      Tes:="507"
               ElseIf WEst=2
                      Tes:="503"
               ElseIf WEst=3
                      Tes:="502"
               ElseIf WEst=4
                      Tes:="591"
               Endif           
               
               IF (SB1->B1_GRUPO="0006") .and. SB1->B1_IPI=0 .and. WEst=4
                  Tes:="596"
               endif 
               IF (SB1->B1_GRUPO="0006") .and. SB1->B1_IPI=0 .and. WEst=3
                  Tes:="594"
               endif 
            
               IF (SB1->B1_GRUPO="0006") .and. SB1->B1_TIPO = "MR"
                   Tes:="608"
               endif
            
               IF (SB1->B1_GRUPO="0006") .and. SB1->B1_TIPO = "MR" .and. SB1->B1_IPI=0
                   Tes:="610"
               endif
            
            
            Endif     
            
            If SB1->B1_GRUPO="0002"
               If     WEst=1
                      Tes:="514"
               ElseIf (WEst=2 .or. WEst=3) .and. WNome<>"MAKRO ATACADISTA"
                      Tes:="511"
               ElseIf (WEst=2 .or. WEst=3) .and. WNome="MAKRO ATACADISTA"
                      Tes:="502"
               ElseIf WEst=4 
                      Tes:="512"
               Endif
            Endif
     
            If SB1->B1_GRUPO="0008"
               Tes:="519"
            Endif
     
         Endif 
                            
         
        If (NatOpe = "1" .OR. NatOpe = "2" .OR. NatOpe = "3" .OR. NatOpe = "4" ) 
            If SB1->B1_GRUPO="0002"
               If     WEst=1
                      Tes:="514"
               ElseIf (WEst=2 .or. WEst=3) .and. WNome<>"MAKRO ATACADISTA"
                      Tes:="511"
               ElseIf (WEst=2 .or. WEst=3) .and. WNome="MAKRO ATACADISTA"
                      Tes:="502"
               ElseIf WEst=4 
                      Tes:="512"
               Endif 
            ENDIF
         endif
         
                  
         
         If (NatOpe = "3" .OR. NatOpe = "4") .and. SB1->B1_TIPO <> "MR"
            If SB1->B1_GRUPO="0001"
               If     WEst=1
                      Tes:="507"
               ElseIf WEst=2
                      Tes:="503"
               ElseIf WEst=3
                      Tes:="501"
               ElseIf WEst=4
                      Tes:="590"
               Endif           
               IF (SB1->B1_GRUPO="0001") .and. SB1->B1_IPI=0 .and. WEst=4
                  Tes:="595"
               endif 
            Endif 
            If SB1->B1_GRUPO="0006"
               If     WEst=1
                      Tes:="507"
               ElseIf WEst=2
                      Tes:="503"
               ElseIf WEst=3
                      Tes:="501"
               ElseIf WEst=4
                      Tes:="590"
               Endif           
               IF (SB1->B1_GRUPO="0006") .and. SB1->B1_IPI=0 .and. WEst=4
                  Tes:="595"
               endif 
            Endif
            If SB1->B1_GRUPO="0002"
               If     WEst=1
                      Tes:="514"
               ElseIf (WEst=2 .or. WEst=3) .and. WNome<>"MAKRO ATACADISTA"
                      Tes:="511"
               ElseIf (WEst=2 .or. WEst=3) .and. WNome="MAKRO ATACADISTA"
                      Tes:="501"
               ElseIf WEst=4
                      Tes:="512"
               Endif
            Endif  
            
            IF (SB1->B1_GRUPO="0006" .OR. SB1->B1_GRUPO="0001") .and. SB1->B1_IPI=0 .and. WEst=3 .and. SB1->B1_TIPO <> "MR"
               Tes:="593"
            endif    
            
         Endif 
         
      Endif 
      DBSELECTAREA("SF4")
	  DBSETORDER(1)
	  DBSEEK(xFilial()+TES)
      If alltrim(EstCli) == alltrim(_cEstPad)
	     WCF  := "5"+substr(SF4->F4_CF,2,3)
      Else
	     WCF  := "6"+substr(SF4->F4_CF,2,3)
      Endif
      Reclock("SUB",.F.)
      Replace SUB->UB_LOCAL With SB1->B1_LOCPAD
//      Replace SUB->UB_NUM_ANT With cPedVenExt
      Replace SUB->UB_TES With Tes
      Replace SUB->UB_CF  With WCF
      If SE4->E4_PLANO="N"
   	     Replace SUB->UB_CM      With 0
     	 Replace SUB->UB_CMSUPLE With 0
      Endif
      MsUnlock()  
      DbSelectArea("SC6")
      DbSetOrder(1)
      DbSeek(xFilial("SC6")+SUA->UA_NUMSC5+SUB->UB_ITEM,.T.)
      If Found()
         Reclock("SC6",.F.)
  	     Replace SC6->C6_VUNTREA  With SUB->UB_VUNTREA
// 	     Replace SC6->C6_PRCVEN   with SUB->UB_VUNTREA 
         Replace SC6->C6_PRCVEN   with SUB->UB_VRUNIT
 	     Replace SC6->C6_PRUNIT   with SUB->UB_VRUNIT   //BCASAES
 	     ReplacE C6_OBS           With SUB->UB_OBS  
		 Replace C6_TIPO          With SUB->UB_TIPO
		 Replace C6_COR           With SUB->UB_COR  
		 Replace C6_GRAV          With SUB->UB_GRAV 
		 Replace C6_LATERAL       With SUB->UB_LATERAL
//	     Replace C6_ENTREG        With SUB->UB_DTENTRE
	     Replace C6_NRFG          With SUB->UB_NRFG
   	     Replace C6_AMOSTRA       With SUB->UB_AMOSTRA		       
   	     Replace C6_PEDIDO        With SUB->UB_PEDIDO
   	     Replace C6_SERVICO       With SUB->UB_SERVICO
   	     Replace C6_PCM           With SUB->UB_PCM
         Replace C6_TES           With Tes
         Replace C6_CF            With WCF
   	     Replace C6_COMIS1        With SUB->UB_CM
         Replace C6_COMIS2        With SUB->UB_CMSUPLE
         Replace C6_NUMPCOM       With SUB->UB_NUMPCOM
         Replace C6_ITEMPC        With SUB->UB_ITEMPC
         Msunlock()
      Endif    
       
      
        
      DbSelectArea("SUB")
      DbSkip()
   Enddo              
   If WMenCap="028"
      dbSelectArea("SM4")  
      dbSetOrder(1)
      Dbseek(xFilial()+WMenCap)
      RecLock("SC5",.F.)
      SC5->C5_MENPAD  := WMenCap
      SC5->C5_DESCR1  := SM4->M4_DESCR1
      SC5->C5_DESCR2  := SM4->M4_DESCR2
      SC5->C5_DESCR3  := SM4->M4_DESCR3
      SC5->C5_DESCR4  := SM4->M4_DESCR4
      SC5->C5_DESCR5  := SM4->M4_DESCR5
      SC5->C5_DESCR6  := SM4->M4_DESCR6
      SC5->C5_DESCR7  := SM4->M4_DESCR7
      SC5->C5_DESCR8  := SM4->M4_DESCR8
      SC5->C5_DESCR9  := SM4->M4_DESCR9
      SC5->C5_DESCR10 := SM4->M4_DESCR10
   Endif
   Close(oDlg1)
    

Return

                   
//////////////////////////////////// INICIO TMKFIM2////////////20/09/2013////////////////////////////////////////////////////////////////

Static Function TMKVFIM2(cNumAT,cNumPV)

	local cQuery   := ""
	local aArea    := getArea()
	local aAreaSUA := SUA->(getArea())
	local aAreaSUB := SUB->(getArea())
	local aAreaSC5 := SC5->(getArea())
	local aAreaSC6 := SC6->(getArea())
	local nDesc    := 0
	local nX       := 0
	local nL       := 0   
   	local nItem    := aScan(aHeader,{|x| allTrim(x[2]) == "UB_ITEM"})
	local nProd    := aScan(aHeader,{|x| allTrim(x[2]) == "UB_PRODUTO"})
	local nDescr   := aScan(aHeader,{|x| allTrim(x[2]) == "UB_DESCRI"})
	local nQtd     := aScan(aHeader,{|x| allTrim(x[2]) == "UB_QUANT"})
	local nVrUnit  := aScan(aHeader,{|x| allTrim(x[2]) == "UB_VRUNIT"})
	local nVlrItm  := aScan(aHeader,{|x| allTrim(x[2]) == "UB_VLRITEM"})
	local nDsc     := aScan(aHeader,{|x| allTrim(x[2]) == "UB_DESC"})
	local nValDesc := aScan(aHeader,{|x| allTrim(x[2]) == "UB_VALDESC"})
	local nDscOrc1 := supergetMv("MV_DESORC1",,17.63)
	local nDscOrc2 := supergetMv("MV_DESORC2",,22.63)
	local lProd    := .F.
	local lDel     := .F.
	
	private nCom    := 1
	private nRevise := 0
	


    //Newton 20121218 ////////////////////////////////////
	_cAlias		:= Alias()     // Mantem o Alias corrente
	_nIndex		:= IndexOrd()  // Mantem o Indice corrente
	_nReg		:= RecNo()     // Mantem o Registro corrente   
	
	
	_cNumero	:= SUB->UB_NUM
	DBSelectArea("SUB")
	DBSetOrder(1)
	DBSeek(xFilial("SUB")+_cNumero)
    //alert(_cNumero)
    //alert(str(Recno()))
	Do While !eof() .and. _cNumero==SUB->UB_NUM
		IF (Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_ORIGEM") == "1") .and. (SUB->UB_MYDATAF<>"1")
			RecLock("SUB",.F.) 
	    	SUB->UB_ZZDATEN := ddatabase + 120
	    	MsUnLock()
		ElseIf (Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_ORIGEM") == "0") .and. (SUB->UB_MYDATAF<>"1") 
			RecLock("SUB",.F.) 
	    	SUB->UB_ZZDATEN := ddatabase + 25
	    	MsUnLock()
	   	EndIf
	
		If SUB->UB_ZZDATEN < DDATABASE
			AVISO('Atencao','Data de entrega anterior a data atual, o Sistema alterou a data automaticamente !!!',{'OK'})
			IF (Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_ORIGEM") == "1") //.and. (SUB->UB_MYDATAF<>"1")
				RecLock("SUB",.F.) 
		    	SUB->UB_ZZDATEN := ddatabase + 120
		    	MsUnLock()
			ElseIf (Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_ORIGEM") == "0") //.and. (SUB->UB_MYDATAF<>"1") 
				RecLock("SUB",.F.) 
		    	SUB->UB_ZZDATEN := ddatabase + 25
		    	MsUnLock()
		   	EndIf
	
		EndIf
		
		DBSkip()
	EndDo

	DBSelectArea(_cAlias)  // Volta o Alias corrente
	DBSetOrder(_nIndex)    // Volta o Indice corrente
	DBGoTo(_nReg)         // Volta o Registro corrente
	
    //////////////////////////////////////////////////////





	if Altera
		grvDtAltera()
	endif
	
   	if INCLUI .or. Altera
	    
		
		
		if M->UA_OPER == "1" && faturamento
		
			/*dbSelectArea("SC5")
			dbSetOrder(1) && C5_FILIAL+C5_NUM

			if dbSeek(xFilial("SC5")+cNumPV)
				
				dbSelectArea("SA1")
				dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA)
				
				dbSelectArea("SC5")
				SC5->(recLock("SC5",.F.))
				//	SC5->C5_ZZNATUR := SUA->UA_ZZNATUR
					SC5->C5_CLIENT  := SUA->UA_ZZCLENT
					SC5->C5_LOJAENT := SUA->UA_ZZLJENT
					SC5->C5_FRETE   := SUA->UA_FRETE
					SC5->C5_MENNOTA := SUA->UA_MENNOTA
				  //	SC5->C5_ZZMENS  := SUA->UA_ZZMENS
					//SC5->C5_ZZMETA  := SUA->UA_ZZMETA
					SC5->C5_REVISE  := SUA->UA_REVISE
					SC5->C5_ENTPARC := SUA->UA_ENTPARC
					SC5->C5_TEMGRAV := SUA->UA_TEMGRAV
				  //	SC5->C5_VEND2	:= SUA->UA_ZZVEND2
				msUnlock()
				
				cQuery := "SELECT UB_NUMPV,UB_ITEMPV,UB_ZZDATEN,UB_ZZCC,UB_LOCAL "
				cQuery += "FROM " + retSqlName("SUB")+" UB "
				cQuery += "WHERE UB_FILIAL  = '"+ xFilial("SUB") +"' AND "
				cQuery += "      UB_NUM     = '"+ cNumAT		 +"' AND "
				cQuery += "      UB.D_E_L_E_T_ = ' ' "
				
				TCQUERY cQuery NEW ALIAS "TSUB"
				
				tcSetField("TSUB","UB_ZZDATEN","D")
				
				if select("TSUB") > 0
					dbSelectArea("TSUB")
					TSUB->(dbGoTop())

				   	while TSUB->(!eof())
						dbSelectArea("SC6")
						dbSetOrder(1)

						if dbSeek(xFilial("SC6")+TSUB->UB_NUMPV+TSUB->UB_ITEMPV)
							SC6->(recLock("SC6",.F.))
							//	SC6->C6_ZZDATEN := TSUB->UB_ZZDATEN
							 //	SC6->C6_ZZCC    := TSUB->UB_ZZCC
								SC6->C6_LOCAL   := TSUB->UB_LOCAL
							SC6->(msUnlock())
						endif

						TSUB->(dbSkip())
				   	enddo     */                     
				   	
				   	
				   	BasicObj()
				   	
				   	msgInfo("PEDIDO DE VENDA  GRAVADO COM SUCESSO !","Aten็ใo") 
				   	
				   	grava_dados = "S"
				   	
				   	
				  //	TSUB->(dbCloseArea())

				   	SUA->(recLock("SUA",.F.))
						SUA->UA_STATU1 := "LIB"
					SUA->(msUnlock())

				//   	U_MYRFAT03()  && imprime pedido de vendas em modo grafico
				   //	U_EMCONFPED() && envia e-mail ao cliente confirmando o pedido
			  //	endif
		//	endif
		elseif M->UA_OPER == "2" && orcamento
		
			nRevise := SUA->UA_REVISE

		   /*	if !INCLUI
				if len(aCols) > 1 
					if len(aDadItem) == len(aCols)
						for nX := 1 to len(aCols)
							if !aCols[nX][len(aHeader) + 1] .and.;
						   (allTrim(str(aDadCab[1][1])	+aDadCab[1][2]		+aDadCab[1][3]		+aDadCab[1][4]			+aDadCab[1][5]			+aDadCab[1][6]			+aDadCab[1][7]) !=;
						    allTrim(str(M->UA_REVISE)	+M->UA_CLIENTE		+M->UA_LOJA			+M->UA_NOME				+M->UA_TPFRETE			+M->UA_TEMGRAV			+M->UA_ENTPARC) .or.;
						    allTrim(aCols[nX][nItem]	+aCols[nX][nProd]	+aCols[nX][nDescr]	+str(aCols[nX][nQtd])	+str(aCols[nX][nVrUnit])+str(aCols[nX][nVlrItm])+str(aCols[nX][nDsc])+str(aCols[nX][nValDesc])) !=;
						    allTrim(aDadItem[nX][1]		+aDadItem[nX][2]	+aDadItem[nX][3]	+str(aDadItem[nX][4])	+str(aDadItem[nX][5])	+str(aDadItem[nX][6])	+str(aDadItem[nX][7])+str(aDadItem[nX][8])))

								lProd := .F.
								lDel  := .F.

								aAdd(aDadItem[nX],lProd)
								aAdd(aDadItem[nX],lDel)
								
								&& gravacao do historico
								grvCabItm(nX,nItem,nProd,nDescr,nQtd,nVrUnit,nVlrItm,nDsc,nValDesc,lProd) 
							
							elseif aCols[nX][len(aHeader) + 1]

								lProd := .F.
								lDel  := .T.
								
								aAdd(aDadItem[nX],lProd)
								aAdd(aDadItem[nX],lDel)

								&& gravacao do historico
								grvCabItm(nX,nItem,nProd,nDescr,nQtd,nVrUnit,nVlrItm,nDsc,nValDesc,lProd)

							endif
						next nX
					else
						&&aDadItem := {} && refazendo o aarray para itens que foram adicionados no acols
						for nA := 1 to len(aCols)
							if aScan(aDadItem,{|x| x[2] == aCols[nA][nProd]}) == 0 .and. !aCols[nA][len(aHeader) + 1]

								lProd := .T.
								lDel  := .F.

								aAdd(aDadItem,{aCols[nA][nItem],aCols[nA][nProd],aCols[nA][nDescr],aCols[nA][nQtd],aCols[nA][nVrUnit],aCols[nA][nVlrItm],aCols[nA][nDsc],aCols[nA][nValDesc],lProd,lDel})
							
							elseif aScan(aDadItem,{|x| x[2] == aCols[nA][nProd]}) != 0 .and. aCols[nA][len(aHeader) + 1]

								lProd := .F.
								lDel  := .T.

							    aAdd(aDadItem[nA],lProd)	
							    aAdd(aDadItem[nA],lDel)

							elseif aScan(aDadItem,{|x| x[2] == aCols[nA][nProd]}) != 0

							   	lProd := .F.
							   	lDel  := .F.

								aAdd(aDadItem[nA],lProd)
								aAdd(aDadItem[nA],lDel)

							endif
						next nA
						
						for nX := 1 to len(aCols)
								if aScan(aDadItem,{|x| x[2] == aCols[nX][nProd]}) != 0 .and.;
								((allTrim(str(aDadCab[1][1])+aDadCab[1][2]		+aDadCab[1][3]		+aDadCab[1][4]			+aDadCab[1][5]			+aDadCab[1][6]			+aDadCab[1][7]) !=;
								  allTrim(str(M->UA_REVISE)	+M->UA_CLIENTE		+M->UA_LOJA			+M->UA_NOME				+M->UA_TPFRETE			+M->UA_TEMGRAV			+M->UA_ENTPARC) .or.;
								  allTrim(aCols[nX][nItem]	+aCols[nX][nProd]	+aCols[nX][nDescr]	+str(aCols[nX][nQtd])	+str(aCols[nX][nVrUnit])+str(aCols[nX][nVlrItm])+str(aCols[nX][nDsc])	+str(aCols[nX][nValDesc])) !=;
								  allTrim(aDadItem[nX][1]	+aDadItem[nX][2]	+aDadItem[nX][3]	+str(aDadItem[nX][4])	+str(aDadItem[nX][5])	+str(aDadItem[nX][6])	+str(aDadItem[nX][7])	+str(aDadItem[nX][8]))) .or.;
								 (aDadItem[nX][9] .or. aDadItem[nX][10]))
								 
									&& gravacao do historico
									grvCabItm(nX,nItem,nProd,nDescr,nQtd,nVrUnit,nVlrItm,nDsc,nValDesc,lProd)

								endif
						next nX
					endif

				elseif !aCols[1][len(aHeader) + 1] .and.;
				(allTrim(str(aDadCab[1][1])	+aDadCab[1][2]	+aDadCab[1][3]		+aDadCab[1][4]		+aDadCab[1][5]			+aDadCab[1][6]			+aDadCab[1][7]) !=; 
				 allTrim(str(M->UA_REVISE)	+M->UA_CLIENTE	+M->UA_LOJA			+M->UA_NOME			+M->UA_TPFRETE			+M->UA_TEMGRAV			+M->UA_ENTPARC) .or.;
				 allTrim(aCols[1][nItem]	+aCols[1][nProd]+aCols[1][nDescr]	+str(aCols[1][nQtd])+str(aCols[1][nVrUnit])	+str(aCols[1][nVlrItm])	+str(aCols[1][nDsc])	+str(aCols[1][nValDesc])) !=;
				 allTrim(aDadItem[1][1]		+aDadItem[1][2]	+aDadItem[1][3]		+str(aDadItem[1][4])+str(aDadItem[1][5])	+str(aDadItem[1][6])	+str(aDadItem[1][7])	+str(aDadItem[1][8])))

					lProd := .F.
					lDel  := .F.

					aAdd(aDadItem[1],lProd)
					aAdd(aDadItem[1],lDel)

					&& gravacao do historico
					grvCabItm(1,nItem,nProd,nDescr,nQtd,nVrUnit,nVlrItm,nDsc,nValDesc,lProd)

				elseif aCols[1][len(aHeader) + 1]

					lProd := .F.
					lDel  := .T.

					aAdd(aDadItem[1],lProd)
					aAdd(aDadItem[1],lDel)

					&& gravacao do historico
					grvCabItm(1,nItem,nProd,nDescr,nQtd,nVrUnit,nVlrItm,nDsc,nValDesc,lProd)

				endif
			endif  
			  */
			if lMudou
				alert("Esse Orcamento nใo gerou pedido e foi para Analise de limite de credito","Aten็ใo")
				SUA->(recLock("SUA",.F.))
					SUA->UA_STATU1 := "BLO"
				SUA->(msUnlock())
				
				U_mailPed() && envio de e-mail para informar o bloqueio do orcamento

				lMudou := .F.
			endif
					
			SA1->(dbSetOrder(1)) && cliente
			if SA1->(!dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))

				SUS->(dbSetOrder(1)) && prospect
				SUS->(dbSeek(xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA))

				if empty(SUS->US_CODCLI)
					if msgYesNo("Deseja enviar email para o vendedor solicitando a documenta็ใo para cadastrar o cliente? ")
						U_mailPro() && e-mail para informar o vendedor sobre a documentacao
					endif
				endif
			endif    
						
			IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA" .AND. SUA->UA_STATU2 = "   " 
	           lBloq = .T.
	           lMudou =.F.
		    ENDIF
			
			        
	        if (lBloq .and. !lMudou) .and. SUA->UA_DESC1 = 0.00
	                
	                                            
                SUB->(dbSetOrder(1)) 
				SUB->(dbSeek(xFilial("SUB")+ SUA->UA_NUM))                                          
                  

				nDesc := 0	
				while SUB->(!eof() .and. UB_FILIAL + UB_NUM == xfilial("SUB") + SUA->UA_NUM)
			    			    
			        
			         //MICROEMPRESA 18/10/2013  - ANALISE DESCONTO
                       DbSelectArea("SA1")
                       IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA" 
                          nDesc	:= SUB->UB_DESCME
                          DBSelectarea("SUB")     
			      	   else
			      	   	   if nDscOrc1 < SUB->UB_DESC
			    		      nDesc := SUB->UB_DESC
			    	          exit
			    	        endif
			    	   endif      
					SUB->(dbSkip())
				enddo    
				
			   If nDesc<0
			      alert("Orcamento nใo gerou Analise de Desconto!!!")
			       // ALTERACAO EM 04/12/2013
			        SUA->(recLock("SUA",.F.))
					SUA->UA_STATU2 := "LIB"
					SUA->UA_STATU1 := "BLO"
			     	SUA->(msUnlock())	  
			      //FIM 	
			   endif
			   
			   If nDesc=0
			      alert("Orcamento nใo gerou Analise de Desconto!!!")
			       // ALTERACAO EM 24/01/2014
			        SUA->(recLock("SUA",.F.))
					SUA->UA_STATU2 := "LIB"
					SUA->UA_STATU1 := "BLO"
			     	SUA->(msUnlock())	  
			      //FIM 	
			   endif
			   	
				   
			   If nDesc>0   // analise de desconto negativo 22/10/2013
			   					
					if (nDesc > nDscOrc1 .and. nDesc < nDscOrc2)  
						SUA->(recLock("SUA",.F.))
				  			SUA->UA_STATU2 := "BLO"
				   		SUA->(msUnlock())
	
			            //GRAVA A MARGEM NO ORCAMENTO
			            U_MYFAT01()        
			        
			            //GRAVA O APROVADOR DO ORCAMENTO
			            U_MYFAT02()
	
				   		alert("Esse Orcamento foi para Analise de Desconto","Aten็ใo")
				   	 	U_WORK(SUA->UA_NUM,1) && workflow para envio de orcamentos bloqueado por desconto
				 	else                     
				 	
				 	   IF SA1->A1_ME=="S" .AND. SA1->A1_EST=="BA"  .AND. nDesc < nDscOrc1  
				 	      alert("Orcamento nใo gerou Analise de Desconto!!!")
				 	      SUA->(recLock("SUA",.F.))
				  		  SUA->UA_STATU2 := "LIB"
				   		  SUA->UA_STATU1 := "BLO"
				   		  SUA->(msUnlock())
				 	    ELSE
				 	      SUA->(recLock("SUA",.F.))
				  		  SUA->UA_STATU2 := "BLO"
				  		  SUA->(msUnlock())
	
			            //GRAVA A MARGEM NO ORCAMENTO
			            U_MYFAT01()        
			        
			            //GRAVA O APROVADOR DO ORCAMENTO
			            U_MYFAT02()
	
				   		alert("Esse Orcamento foi para Analise de Desconto","Aten็ใo")
				   	   	U_WORK(SUA->UA_NUM,2)  && workflow para envio de orcamentos bloqueado por desconto
					
					  endif 
					   
					endif
					
		        endIf    
	        
	        endif	                        
				
		endif
		
		
	endif
	
   	TOpcRel()   
   	
   	//Manda email para a tesouraria quando utiliza uma condicao de pagamento especifica.
	If SUA->UA_CONDPG$Getmv("MV_MYBNDSC")
		MYCONDPAG()
	EndIf 


	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aAreaSUB)
	restArea(aAreaSUA)
	restArea(aArea)

return nil   

&& envio de e-mail para informar o vendedor sobre a documentacao que deve ser enviada para o cadastro do cliente.
user function mailPro()

	local oHtml
	local oEmail
	local cServidor	:=	getMv("MV_RELSERV")
	local cConta	:=	getMv("MV_RELACNT")
	local cPassWord	:=	getMv("MV_RELPSW")
	local cAutentic	:=	getMv("MV_RELAUTH")
	local cAnexo    := ""
	local cTitulo 	:= ""
	local aCorpo  	:= {}
	local aRodape 	:= {}
	local cAssunto  := " Documenta็ใo para cadastro do cliente"
	local cPara 	:= ""
	local cCC		:= ""
	local cCCo		:= ""
	local cRemet 	:= getMv("MV_RELACNT")
	
	cPara := Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL")
	
	if empty(cPara)
		msgAlert("O campo de email no cadastro do vendedor estแ em branco")
	endif
	
	dbSelectarea("SF2")
	
	SUS->(dbSetOrder(1)) && prospect
	SUS->(dbSeek(xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA))
	
	aAdd(aCorpo,"Senhor(a) Vendedor(a)")
	aAdd(aCorpo,"")
	aAdd(aCorpo,"Favor enviar a Documenta็ใo do prospect " + SUS->US_NOME)
	aAdd(aCorpo,"")
	aAdd(aCorpo,"para efetivar o prospect em cliente. ")
	aAdd(aRodape,"")
	aAdd(aRodape,"Obrigado")

	oHtml := CorpoEmail():new(cTitulo,aCorpo,aRodape)
	oHtml:geraHtml()
	
	&& enviando e-mail
	oEmail := ConEmail():new(cServidor,cConta,cPassWord,,cAutentic,)
	oEmail:emailUsr()
	oEmail:conectar()

	if oEmail:enviar(allTrim(cRemet),allTrim(cPara),allTrim(cCC),allTrim(cCCO),allTrim(cAssunto),oHtml:cHtml,cAnexo)
		lRetorno := .T.
		aviso(funDesc(),"E-mail enviado com SUCESSO.",{"OK"})
	endif

	oEmail:desconec()

return

&& envio de e-mail para informar o bloqueio do orcamento.
user function mailPed()

	local oHtml
	local oEmail
	local cServidor	:= getMv("MV_RELSERV")
	local cConta	:= getMv("MV_RELACNT")
	local cPassWord	:= getMv("MV_RELPSW")
	local cAutentic	:= getMv("MV_RELAUTH")
	local cAnexo    := ""
	local cTitulo 	:= ""
	local aCorpo  	:= {}
	local aRodape 	:= {}
	local cAssunto  := " Or็amento de numero "+SUA->UA_NUM+" impedido de gerar o PV para analise de limite de credito"
	local cPara 	:= ""
	local cCC		:= ""
	local cCCo		:= ""
	local cRemet 	:= getMv("MV_RELACNT")
	
	
	SX6->(dbSetOrder(1))
	if SX6->(!dbSeek(xFilial("SX6") + "MV_EMANCRE"))
		SX6->(recLock("SX6",.T.))
			SX6->X6_FIL		:= xFilial("SX6")
			SX6->X6_VAR		:= "MV_EMANCRE"
			SX6->X6_TIPO	:= "C"
			SX6->X6_DESCRIC	:= "Email da analista de credito"
			SX6->X6_DESC1	:= "Email da analista de credito"
			SX6->X6_DESC2	:= "Email da analista de credito"
			SX6->X6_CONTEUD	:= ""
			SX6->X6_PROPRI	:= "U"
			SX6->X6_PYME	:= "S"
		SX6->(msUnlock())
	endif
	
	cPara := getMv("MV_EMANCRE")
	
	if empty(cPara)
		msgAlert("O parametro MV_EMANCRE que informa o email do analista de limite de credito estแ em branco")
	endif
	
	dbSelectarea("SF2")
	
	aAdd(aCorpo,"O Or็amento abaixo:")
	aAdd(aCorpo,"")
	aAdd(aCorpo,"Numero "+SUA->UA_NUM)
	aAdd(aCorpo,"")
	aAdd(aCorpo,"Precisa da libera็ใo da analise de limite de credito. ")
	aAdd(aRodape,"")
	aAdd(aRodape,"Obrigado")
	
	
	oHtml := CorpoEmail():new(cTitulo,aCorpo,aRodape)
	oHtml:geraHtml()

	&& enviando e-mail
	oEmail := ConEmail():new(cServidor,cConta,cPassWord,,cAutentic,)
	oEmail:emailUsr()
	oEmail:conectar()

	if oEmail:Enviar(allTrim(cRemet),allTrim(cPara),allTrim(cCC),allTrim(cCCO),allTrim(cAssunto),oHtml:cHtml,cAnexo)
		lRetorno := .T.
		aviso(funDesc(),"E-mail enviado com SUCESSO.",{"OK"})
	endif

	oEmail:desconec()

return

&& funcao de gravacao do historico dos orcamentos
static function grvCabItm(nNum,nItem,nProd,nDescr,nQtd,nVrUnit,nVlrItm,nDsc,nValDesc,lProd)

	local nL := 1
	
	Begin Transaction

		if nCom == 1
			nRevise := nRevise + 1
			SUA->(recLock("SUA",.F.))
				SUA->UA_REVISE := nRevise
			SUA->(msUnlock())
			nCom := nCom + 1
		endif
	
		&& gravando antes e depois 
		for nL := 1 to 2
			&& gravando tabela de historico
			ZZF->(recLock("ZZF",.T.))	
				ZZF->ZZF_FILIAL := xFilial("ZZF")
				ZZF->ZZF_REVISA := allTrim(str(nRevise))
				ZZF->ZZF_ORCAME := M->UA_NUM
				ZZF->ZZF_CODCLI := IIF(nL == 1,aDadCab[1][2],M->UA_CLIENTE)
				ZZF->ZZF_LOJA   := IIF(nL == 1,aDadCab[1][3],M->UA_LOJA)
				ZZF->ZZF_DESCCL := IIF(nL == 1,aDadCab[1][4],M->UA_NOME)
				ZZF->ZZF_TPFRET := IIF(nL == 1,aDadCab[1][5],M->UA_TPFRETE)
				ZZF->ZZF_TEMGRF := IIF(nL == 1,aDadCab[1][6],M->UA_TEMGRAV)
				ZZF->ZZF_ENTPAR := IIF(nL == 1,aDadCab[1][7],M->UA_ENTPARC)
				ZZF->ZZF_ITEM   := IIF(nL == 1,aDadItem[nNum][1],aCols[nNum][nItem])          
				ZZF->ZZF_PROD   := IIF(nL == 1,aDadItem[nNum][2],aCols[nNum][nProd]) 
				ZZF->ZZF_DESCRI := IIF(nL == 1,aDadItem[nNum][3],aCols[nNum][nDescr])
				ZZF->ZZF_QTD    := IIF(nL == 1,aDadItem[nNum][4],aCols[nNum][nQtd])            
				ZZF->ZZF_VRUNIT := IIF(nL == 1,aDadItem[nNum][5],aCols[nNum][nVrUnit])
				ZZF->ZZF_VLITEN := IIF(nL == 1,aDadItem[nNum][6],aCols[nNum][nVlrItm])
				ZZF->ZZF_DESCON := IIF(nL == 1,aDadItem[nNum][7],aCols[nNum][nDsc])
				ZZF->ZZF_VLDESC := IIF(nL == 1,aDadItem[nNum][8],aCols[nNum][nValDesc])
				ZZF->ZZF_DATA   := aDadCab[1][8]
				ZZF->ZZF_HORA   := aDadCab[1][9]
				ZZF->ZZF_USER   := aDadCab[1][10]
				ZZF->ZZF_FLAG   := IIF(nL == 1,"A","D")
				ZZF->ZZF_USNAME := aDadCab[1][11]
				ZZF->ZZF_NEWPRD := IIF(aDadItem[nNum][9],"Novo Prod Incluido","")
				ZZF->ZZF_DELETE := IIF(aDadItem[nNum][10],"D","")
			ZZF->(msUnlock())
		next nL
                  

	End Transaction

return

&& grava a data de alteracao
static function grvDtAltera()
	SUA->(recLock("SUA",.F.))
		SUA->UA_ZZDTALT := dDataBase
	SUA->(msUnlock())
return
       

//************************************************* ENVIA E-MAIL ORCAMENTO

static Function TOpcRel()
          

	local lOTireP := .F.
	local lOPlasP := .F.
	local lOPlasI := .F.
	local lOPlasE := .F.
	local oOTireP
	local oOPlasP
	local oOPlasI
	local oOPlasE
	local oDlg
	local bGeraRel := { || fGeraRel(lOPlasP,lOPlasI,lOPlasE),oDlg:End()}
	
	private lOK	   := .T. &&Flag para confirmacao de envio de e-mail
	
	DEFINE MSDIALOG oDlg TITLE "Selecione relatorio para visualizacao" FROM 178,181 TO 280,484 PIXEL
	
	&& cria as groups do sistema
	@ 004,004 TO 026,150 LABEL "Or็amento Plastico" PIXEL OF oDlg
	&& cria componentes padroes do sistema
	@ 013,009 CheckBox oOPlasP Var lOPlasP Prompt "Portugues" Size 048,008 PIXEL OF oDlg
	@ 013,059 CheckBox oOPlasI Var lOPlasI Prompt "Ingles" Size 048,008 PIXEL OF oDlg
	@ 013,109 CheckBox oOPlasE Var lOPlasE Prompt "Espanhol" Size 039,008 PIXEL OF oDlg
	@ 033,072 Button "Cancelar" Size 035,010 PIXEL OF oDlg ACTION (oDlg:End())
	@ 033,115 Button "OK" Size 034,011 PIXEL OF oDlg ACTION Eval(bGeraRel)
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
return

&& funcao resposavel gerar os relatorios
Static Function fGeraRel(lOPlasP,lOPlasI,lOPlasE)

	local lImpPlasP := .F. &&Flag Impressao Orcamento Plastico Portugues
	local lImpPlasI := .F. &&Flag Impressao Orcamento Plastico Ingles
	local lImpPlasE := .F. &&Flag Impressao Orcamento Plastico Espanhol
	local cArq		:= ""
	local lEnvia	:= .F.
	
	&&Visualizacao Orcamento Plastico Portugues
	if lOPlasP
		SX1->(dbSetOrder(1)) &&X1_GRUPO+X1_ORDEM
		if SX1->(dbSeek(Padr("MYRPLZ",10)+"01"))
			recLock("SX1",.F.)
			SX1->X1_CNT01 := M->UA_NUM
			SX1->(msUnlock())
		endif
		//U_MYRORCPZ()
		
		//Customizado///////////////////////////////////////////////////////////
		U_MYTM01(UA_NUM)
		
		
		////////////////////////////////////////////////////////////////////////
		lImpPlasP := .T.
	endif
	&&Visualizacao Orcamento Plastico Ingles
	if lOPlasI
		SX1->(dbSetOrder(1)) &&X1_GRUPO+X1_ORDEM
		if SX1->(dbSeek(Padr("MYRPLI",10)+"01"))
			recLock("SX1",.F.)
			SX1->X1_CNT01 := M->UA_NUM
			SX1->(msUnlock())
		endif
		U_MYRORCPI()
		lImpPlasI := .T.
	endif
	&&Visualizacao Orcamento Plastico Espanhol
	if lOPlasE
		SX1->(dbSetOrder(1)) &&X1_GRUPO+X1_ORDEM
		if SX1->(dbSeek(Padr("MYRPLE",10)+"01"))
			recLock("SX1",.F.)
			SX1->X1_CNT01 := M->UA_NUM
			SX1->(msUnlock())
		endif
		U_MYRORCPE()
		lImpPlasE := .T.
	endif
	&&Chama tela para envio de e-mail
	&&if lImpTireP .or. lImpPlasP .or. lImpPlasI .or. lImpPlasE
	if !lBloq
		if lImpPlasP .or. lImpPlasI .or. lImpPlasE
			lEnvia := MSGYESNO("Deseja enviar por e-mail Or็amento ?")
			if lEnvia
				TelaEmail(lImpPlasP,lImpPlasI,lImpPlasE)
			endif
		endif 
	endif
	
	lBloq := .F.

return

&& funcao resposavel de montar tela para usuario anexar os orcamento para enviar por e-mail
Static Function TelaEmail(lImpPlasP,lImpPlasI,lImpPlasE)

	local oPara
	local oCC
	local oCCO
	local oAssunto
	local oEndOTireP
	local oEndOPlasP
	local oEndOPlasI
	local oEndOPlasE
	local oImagem
	local oDlg2						&& DiSalog Principal
	local cDrivers		:= "Selecione Orcamento (.PDF) | *.PDF |" + "Imagem Bitmap (.BMP) | *.BMP |" + "Imagem JPEG (.JPG) | *.JPG |"
	local cEndOPlasP	:= ""       && Endereco arquivo Orcamento Plastico Portugues
	local cEndOPlasI	:= ""       && Endereco arquivo Orcamento Plastico Ingles
	local cEndOPlasE	:= ""       && Endereco arquivo Orcamento Plastico Espanhol  
	local cImagem		:= ""
	local bValEndArq 	:= { || fValEndArq(cEndOPlasP,cEndOPlasI,cEndOPlasE,lImpPlasP,lImpPlasI,lImpPlasE),IIF(lOK ,EnvEmail(oDlg2,cEndOPlasP,cEndOPlasI,cEndOPlasE,lImpPlasP,lImpPlasI,lImpPlasE,cImagem),"")}
	
	private cPara	   	:= Space(100)
	private cCC			:= Space(150)
	private cCCO		:= Space(150)
	private cAssunto 	:= Space(100)
	private cRemet 		:= ""
	
	cAssunto := "Envio de Or็amento Plแstico - " + allTrim(M->UA_NOME)
	
	&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	&&ณAlteracao: Francys W. Soares - 06/04/10                   ณ
	&&ณApresenta mensagem para selecionar e-mail do destinatario.ณ
	&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if Aviso("Informacao","Selecione o destinatario do e-mail.",{"Contato","Cliente"},2,FunDesc()) == 1
		if !Empty(M->UA_CODCONT)
			SU5->(dbSetOrder(1))
			SU5->(dbSeek(xFilial("SU5")+M->UA_CODCONT))
			cPara := SU5->U5_EMAIL
			M->UA_EMAIL := SU5->U5_EMAIL
		endif
	else
		cPara := M->UA_EMAIL
	endif
	
	DEFINE MSDIALOG oDlg2 TITLE "Or็amento - E-mail" FROM 178,181 TO 580,631 PIXEL
	
	&& Cria as Groups do Sistema
	@ 060,002 TO 155,223 LABEL "Selecione Or็amento para ser enviado como anexo no e-mail." PIXEL OF oDlg2
	
	@ 003,029 MsGet oPara Var cPara Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg2
	@ 004,004 Say "Para:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg2
	@ 015,029 MsGet oCC Var cCC Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg2
	@ 016,004 Say "Cc:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg2
	@ 027,029 MsGet oCCO Var cCCO Size 193,009 COLOR CLR_BLACK PIXEL OF oDlg2
	@ 028,004 Say "Cco:" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg2
	@ 039,029 MsGet oAssunto Var cAssunto Size 193,009 When .F. COLOR CLR_BLACK PIXEL OF oDlg2
	@ 040,004 Say "Assunto:" Size 022,008 COLOR CLR_BLACK PIXEL OF oDlg2
	
	if lImpPlasP
		@ 071,006 Say "Orcamento Plastico Portugues" Size 081,008 COLOR CLR_BLUE PIXEL OF oDlg2
		@ 081,204 Button "..." Size 014,011 When lImpPlasP PIXEL OF oDlg2 Action {|| cEndOPlasP:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.T.,GETF_ONLYSERVER/*GETF_LOCALHARD+GETF_NETWORKDRIVE*/)}
		@ 081,006 MsGet oEndOPlasP Var cEndOPlasP Size 197,009 COLOR CLR_BLACK When lImpPlasP Picture "@!" PIXEL OF oDlg2
	elseif lImpPlasI
		@ 071,006 Say "Orcamento Plastico Ingles" Size 070,008 COLOR CLR_BLUE PIXEL OF oDlg2
		@ 081,204 Button "..." Size 014,011 When lImpPlasI PIXEL OF oDlg2 Action {|| cEndOPlasI:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.T.,GETF_ONLYSERVER/*GETF_LOCALHARD+GETF_NETWORKDRIVE*/)}
		@ 081,006 MsGet oEndOPlasI Var cEndOPlasI Size 197,009 COLOR CLR_BLACK When lImpPlasI Picture "@!" PIXEL OF oDlg2
	elseif lImpPlasE
		@ 071,006 Say "Orcamento Plastico Espanhol" Size 072,008 COLOR CLR_BLUE PIXEL OF oDlg2
		@ 081,204 Button "..." Size 014,011 When lImpPlasE PIXEL OF oDlg2 Action {|| cEndOPlasE:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.T.,GETF_ONLYSERVER/*GETF_LOCALHARD+GETF_NETWORKDRIVE*/)}
		@ 081,006 MsGet oEndOPlasE Var cEndOPlasE Size 197,009 COLOR CLR_BLACK When lImpPlasE Picture "@!" PIXEL OF oDlg2  
	endif
	
	@ 097,006 Say "Solicitacao de Gravacao" Size 070,008 COLOR CLR_BLUE PIXEL OF oDlg2
	@ 107,204 Button "..." Size 014,011 When .T. PIXEL OF oDlg2 Action {|| cImagem:=cGetFile(cDrivers,"Selecione o arquivo",1,"C:\",.T.,GETF_ONLYSERVER/*GETF_LOCALHARD+GETF_NETWORKDRIVE*/)}
	@ 107,006 MsGet oImagem Var cImagem Size 197,009 COLOR CLR_BLACK When .T. Picture "@!" PIXEL OF oDlg2
	
	@ 159,143 Button "Cancelar" Size 037,011 PIXEL OF oDlg2 ACTION (oDlg2:End())
	@ 159,184 Button "Enviar" Size 037,011 PIXEL OF oDlg2 ACTION Eval(bValEndArq)
	
	ACTIVATE MSDIALOG oDlg2 CENTERED

return

&& funcao resposavel de validar se os enderecos dos arquivos sao validos
Static Function fValEndArq(cEndOPlasP,cEndOPlasI,cEndOPlasE,lImpPlasP,lImpPlasI,lImpPlasE)

	local cMsg := ""
	
	lOk := .T.
	&&Selecionando e-mail do usuario logado
	cRemet := GetMv("MV_RELACNT")
	if Empty(cRemet)
		cMsg += "E-mail Remetente em branco" + Chr(10)+Chr(13)
		lOK := .F.
	endif
	if Empty(cPara)
		cMsg += "E-mail Destinatario em branco" + Chr(10)+Chr(13)
		lOK := .F.
	endif
	if Empty(cAssunto)
		cMsg += "Assunto em branco" + Chr(10)+Chr(13)
		lOK := .F.
	endif
	
	if lImpPlasP
		if !File(cEndOPlasP)
			cMsg += "Endereco do arquivo Orcamento Plastico Portugues invalido!" + Chr(10)+Chr(13)
			lOK := .F.
		endif
	endif
	if lImpPlasI
		if !File(cEndOPlasI)
			cMsg += "Endereco do arquivo Orcamento Plastico Ingles invalido!" + Chr(10)+Chr(13)
			lOK := .F.
		endif
	endif
	if lImpPlasE
		if !File(cEndOPlasE)
			cMsg += "Endereco do arquivo Orcamento Plastico Espanhol invalido!" + Chr(10)+Chr(13)
			lOK := .F.
		endif
	endif
	if !lOK
		msgInfo(cMsg)
	endif

return lOK

&& funcao resposavel enviar e-mail para o cliente
Static Function EnvEmail(oDlg2,cEndOPlasP,cEndOPlasI,cEndOPlasE,lImpPlasP,lImpPlasI,lImpPlasE,cImagem)

	local oHtml
	local oEmail
	local cServidor	:=	GetMv("MV_RELSERV")
	local cConta	:=	GetMv("MV_RELACNT")
	local cPassWord	:=	GetMv("MV_RELPSW")
	local cAutentic	:=	GetMv("MV_RELAUTH")
	local cAnexo    := ""
	local cTitulo 	:= ""
	local aCorpo  	:= {}
	local aRodape 	:= {}
	
	if lImpPlasP
		cAnexo += allTrim(cEndOPlasP)+";"
		cAnexo += allTrim(cImagem)+";"
	endif
	if lImpPlasI
		cAnexo += allTrim(cEndOPlasI)+";"
		cAnexo += allTrim(cImagem)+";"
	endif
	if lImpPlasE
		cAnexo += allTrim(cEndOPlasE)+";"
		cAnexo += allTrim(cImagem)+";"
	endif
	
	aAdd(aCorpo,"Prezado cliente ")
	aAdd(aCorpo,"")
	aAdd(aCorpo,"Conforme solicitacao,segue em anexo proposta.")
	aAdd(aCorpo,"")
	aAdd(aCorpo,"Caso haja d๚vida,favor entrar em contato.")
	aAdd(aCorpo,"")
	aAdd(aRodape,"Obrigado(a)")
	
	oHtml := CorpoEmail():new(cTitulo,aCorpo,aRodape)
	oHtml:geraHtml()

	&& enviando e-mail
	oEmail := ConEmail():new(cServidor,cConta,cPassWord,,cAutentic,)
	oEmail:emailUsr()
	oEmail:conectar()

	if oEmail:Enviar(allTrim(cRemet),allTrim(cPara),allTrim(cCC),allTrim(cCCO),allTrim(cAssunto),oHtml:cHtml,cAnexo)
		lRetorno := .T.
		aviso(funDesc(),"E-mail enviado com SUCESSO.",{"OK"})
	endif

	oEmail:desconec()
	
	oDlg2:end()

return          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MYENVMAILบAutor  ณ NEWTON RECA ALVES  บ Data ณ  20/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manda email para o responsavel que libera o cliente        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATURAMENTO                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

*/


Static Function MYENVMAIL()



cServer		:= GetMv("MV_RELSERV")
cAccount	:= GetMv("MV_RELACNT")
cPassword	:= GetMv("MV_RELPSW")
cAutentic	:= GetMv("MV_RELAUTH")
cPara		:= GetMV("MV_MYPVREG")
cHtml		:= ""

cHtml	+= '<html> '

cHtml	+= '<head> '
cHtml	+= '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"><meta name=Generator content="Microsoft Word 12 (filtered)"> '
cHtml	+= '<style> '
cHtml	+= '<!-- '
cHtml	+= ' /* Font Definitions */ '
cHtml	+= ' @font-face '
cHtml	+= '	{font-family:"Cambria Math"; '
cHtml	+= '	panose-1:2 4 5 3 5 4 6 3 2 4;} '
cHtml	+= '@font-face '
cHtml	+= '	{font-family:Calibri; '
cHtml	+= '	panose-1:2 15 5 2 2 2 4 3 2 4;} '
cHtml	+= '@font-face '
cHtml	+= '	{font-family:Tahoma; '
cHtml	+= '	panose-1:2 11 6 4 3 5 4 4 2 4;} '
cHtml	+= ' /* Style Definitions */ '
cHtml	+= ' p.MsoNormal, li.MsoNormal, div.MsoNormal '
cHtml	+= '	{margin-top:0cm; '
cHtml	+= '	margin-right:0cm; '
cHtml	+= '	margin-bottom:10.0pt; '
cHtml	+= '	margin-left:0cm; '
cHtml	+= '	line-height:115%; '
cHtml	+= '	font-size:11.0pt; '
cHtml	+= '	font-family:"Calibri","sans-serif";} '
cHtml	+= 'p.MsoAcetate, li.MsoAcetate, div.MsoAcetate '
cHtml	+= '	{mso-style-link:"Texto de balใo Char"; '
cHtml	+= '	margin:0cm; '
cHtml	+= '	margin-bottom:.0001pt; '
cHtml	+= '	font-size:8.0pt; '
cHtml	+= '	font-family:"Tahoma","sans-serif";} '
cHtml	+= 'p.msopapdefault, li.msopapdefault, div.msopapdefault '
cHtml	+= '	{mso-style-name:msopapdefault; '
cHtml	+= '	margin-right:0cm; '
cHtml	+= '	margin-bottom:10.0pt; '
cHtml	+= '	margin-left:0cm; '
cHtml	+= '	line-height:115%; '
cHtml	+= '	font-size:12.0pt; '
cHtml	+= '	font-family:"Times New Roman","serif";} '
cHtml	+= 'p.msochpdefault, li.msochpdefault, div.msochpdefault '
cHtml	+= '	{mso-style-name:msochpdefault; '
cHtml	+= '	margin-right:0cm; '
cHtml	+= '	margin-left:0cm; '
cHtml	+= '	font-size:10.0pt; '
cHtml	+= '	font-family:"Times New Roman","serif";} '
cHtml	+= 'span.TextodebaloChar '
cHtml	+= '	{mso-style-name:"Texto de balใo Char"; '
cHtml	+= '	mso-style-link:"Texto de balใo"; '
cHtml	+= '	font-family:"Tahoma","sans-serif";} '
cHtml	+= '.MsoChpDefault '
cHtml	+= '	{font-size:10.0pt;} '
cHtml	+= '@page Section1 '
cHtml	+= '	{size:595.3pt 841.9pt; '
cHtml	+= '	margin:70.85pt 3.0cm 70.85pt 3.0cm;} '
cHtml	+= 'div.Section1 '
cHtml	+= '	{page:Section1;} '
cHtml	+= '--> '
cHtml	+= '</style> '

cHtml	+= '</head> '

cHtml	+= '<body lang=PT-BR> '

cHtml	+= '<div class=Section1> '

cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>Cliente Bloqueado por Regra de Negocio</span></i></b></p> "

cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>&nbsp;</span></i></b></p> "

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal><b><i>Informa็๕es Complementares:</i></b></p> '

cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Numero: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+SC5->C5_NUM+"</span></i></b></p> "

cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Emissao: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+DtoC(SC5->C5_EMISSAO)+"</span></i></b></p> "

cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Cliente: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+"</span></i></b></p> "

_cNomeCli	:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")

cHtml	+= "<p class=MsoNormal style='text-indent:35.4pt'>Descricao: <b><i><spanstyle='font-size:14.0pt;line-height:115%'>"+_cNomeCli+"</span></i></b></p> "

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>Planta: JAGUARIUNA</p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>Sem mais,</p> '

cHtml	+= '<p class=MsoNormal><b><i>Controladoria</i></b></p> '

cHtml	+= '</div> '

cHtml	+= '</body> '

cHtml	+= '</html> '


//Manda e e-mail
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
lResulConn := MailAuth(cAccount, cPassword)

//email para o responsavel pela fase 1
SEND MAIL FROM cAccount TO cPara SUBJECT 'Cliente bloqueado por regra de negocio' BODY cHtml //Attachment _cCaminho //RESULT lEnviado


Return()
                 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FA080PE  บ Autor ณdaniel Alves Coelho บ Data ณ  11/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ENVIA EMAIL PARA A TESOURARIA INFORMANDO QUE FOI INFORMADO บฑฑ
ฑฑบ          ณ UMA CONDICAO DE PAGTO ESPECIFICA (PARAMETRO)               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INCLUSAO DO ORCAMENTO DE VENDAS                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MYCONDPAG()   


//If MSGBOX("Envia email para libera็ใo de Cr้dito","Liberacao de Cr้dito","YESNO")

//If TRIM(_cNomeC)<>TRIM(getmv("MV_MYLICT1"))



cHTML 		:= ""

cServer		:=	GetMv("MV_RELSERV")
cAccount	:=	GetMv("MV_RELACNT")
cPassword	:=	GetMv("MV_RELPSW")
cAutentic	:=	GetMv("MV_RELAUTH")
cPara		:= "wellington@novel.com.br"
cEnvia		:= "microsiga@novel.com.br"

//_cUsuario	:= Getmv("MV_MYLIDA0")
_cLogin		:= ""
_cNome		:= ""
_cEmail		:= "wellington@novel.com.br"
_cEmail		:= Getmv("MV_MYBNDS")




cHtml	+= '<html> '

cHtml	+= '<head> '
cHtml	+= '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"><meta name=Generator content="Microsoft Word 12 (filtered)"> '
cHtml	+= '<style> '
cHtml	+= '<!-- '
cHtml	+= ' /* Font Definitions */ '
cHtml	+= ' @font-face '
cHtml	+= '	{font-family:"Cambria Math"; '
cHtml	+= '	panose-1:2 4 5 3 5 4 6 3 2 4;} '
cHtml	+= '@font-face '
cHtml	+= '	{font-family:Calibri; '
cHtml	+= '	panose-1:2 15 5 2 2 2 4 3 2 4;} '
cHtml	+= '@font-face '
cHtml	+= '	{font-family:Tahoma; '
cHtml	+= '	panose-1:2 11 6 4 3 5 4 4 2 4;} '
cHtml	+= ' /* Style Definitions */ '
cHtml	+= ' p.MsoNormal, li.MsoNormal, div.MsoNormal '
cHtml	+= '	{margin-top:0cm; '
cHtml	+= '	margin-right:0cm; '
cHtml	+= '	margin-bottom:10.0pt; '
cHtml	+= '	margin-left:0cm; '
cHtml	+= '	line-height:115%; '
cHtml	+= '	font-size:11.0pt; '
cHtml	+= '	font-family:"Calibri","sans-serif";} '
cHtml	+= 'p.MsoAcetate, li.MsoAcetate, div.MsoAcetate '
cHtml	+= '	{mso-style-link:"Texto de balใo Char"; '
cHtml	+= '	margin:0cm; '
cHtml	+= '	margin-bottom:.0001pt; '
cHtml	+= '	font-size:8.0pt; '
cHtml	+= '	font-family:"Tahoma","sans-serif";} '
cHtml	+= 'p.msopapdefault, li.msopapdefault, div.msopapdefault '
cHtml	+= '	{mso-style-name:msopapdefault; '
cHtml	+= '	margin-right:0cm; '
cHtml	+= '	margin-bottom:10.0pt; '
cHtml	+= '	margin-left:0cm; '
cHtml	+= '	line-height:115%; '
cHtml	+= '	font-size:12.0pt; '
cHtml	+= '	font-family:"Times New Roman","serif";} '
cHtml	+= 'p.msochpdefault, li.msochpdefault, div.msochpdefault '
cHtml	+= '	{mso-style-name:msochpdefault; '
cHtml	+= '	margin-right:0cm; '
cHtml	+= '	margin-left:0cm; '
cHtml	+= '	font-size:10.0pt; '
cHtml	+= '	font-family:"Times New Roman","serif";} '
cHtml	+= 'span.TextodebaloChar '
cHtml	+= '	{mso-style-name:"Texto de balใo Char"; '
cHtml	+= '	mso-style-link:"Texto de balใo"; '
cHtml	+= '	font-family:"Tahoma","sans-serif";} '
cHtml	+= '.MsoChpDefault '
cHtml	+= '	{font-size:10.0pt;} '
cHtml	+= '@page Section1 '
cHtml	+= '	{size:595.3pt 841.9pt; '
cHtml	+= '	margin:70.85pt 3.0cm 70.85pt 3.0cm;} '
cHtml	+= 'div.Section1 '
cHtml	+= '	{page:Section1;} '
cHtml	+= '--> '
cHtml	+= '</style> '

cHtml	+= '</head> '

cHtml	+= '<body lang=PT-BR> '

cHtml	+= '<div class=Section1> '

cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>Orcamento com condicao de Pagamento especifica</span></i></b></p> "

cHtml	+= "<p class=MsoNormal><b><i><span style='font-size:16.0pt;line-height:115%;color:red'>&nbsp;</span></i></b></p> "

cHtml	+= "<p class=MsoNormal>Foi incluido um Orcamento de vendas do cliente:  <b><i><span "

cHtml	+= "style='font-size:12.0pt;line-height:115%'>" + SUA->UA_CLIENTE + "/" + SUA->UA_LOJA + " do Or็amento: " + SUA->UA_NUM+ " </span></i></b><span "

cHtml	+= ' <p class=MsoNormal style="text-indent:35.4pt"><b><i><spanstyle="font-size:14.0pt;line-height:115%"></span></i></b></p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal><b><i>Informa็๕es Complementares:</i></b></p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '   

cHtml	+= '<p class=MsoNormal>Planta: BA-LAURO DE FREITAS</p> '

cHtml	+= '<p class=MsoNormal>&nbsp;</p> '

cHtml	+= '<p class=MsoNormal>Sem mais,</p> '

cHtml	+= '<p class=MsoNormal><b><i>Controladoria Grupo Myers do Brasil</i></b></p> '

cHtml	+= '</div> '

cHtml	+= '</body> '

cHtml	+= '</html> '



//Manda e e-mail
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
lResulConn := MailAuth(cAccount, cPassword)

//email para o responsavel pela fase 1
SEND MAIL FROM cAccount TO _cEmail SUBJECT 'Orcamento com condicao de Pagamento especifica' BODY cHtml //Attachment _cCaminho //RESULT lEnviado

//RecLock("SA1",.F.)
//SA1->A1_MSBLQL	:= "1"
//MSUnLock()

//EndIf




Return .t.



                   
                   
