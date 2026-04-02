#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYATF03.prw                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 18/12/2018                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina para alteração de dados do ativo antes de sofrer DEPRECIACAO|\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYATF03() 

  Local nOpc := 0
  
  nOpc := Aviso("Ajuste no ATIVO","Essa rotina foi customizada para agilizar os ajustes no cadastro do Ativo, antes do mesmo sofrer DEPRECIACAO",{"Continuar","Cancelar"},3,"")
  
  If ! nOpc <> 1
    fUPDativo()
  EndIf

Return

*Funcao*********************************************************************************************************************************

Static Function fUPDativo()

  Local cPerg := "MYATF03A"
  Private Oqry:=NVLxFUN():New(.f.)
  Private cQuery := ""
  
  If ! Pergunte(cPerg,.T.)
    Return
  EndIf 
  
  //Validar se o ativo já teve depreciaçã
  If fSQLdpr(Alltrim(MV_PAR01),AllTrim(MV_PAR02))
    APMsgInfo("O Ativo "+Alltrim(MV_PAR01)+"/"+AllTrim(MV_PAR02)+" já sofreu depreciação, não é permitido efetuar alteração por essa rotina","MYATF03")
    Return
  EndIf
  
  If ! fSQLupd(Alltrim(MV_PAR01),AllTrim(MV_PAR02))
    APMsgInfo("Ativo "+Alltrim(MV_PAR01)+"/"+AllTrim(MV_PAR02)+" não encontrado, verifique o Codigo/Item do Bem","MYATF03")
    Return
  EndIf
  
Return

*Funcao*********************************************************************************************************************************

Static Function fSQLdpr(bem,item)
  
  Local lRet
  
  cQuery := "SELECT COUNT(*) JADEPRECIADO FROM SN3010 WHERE N3_FILIAL='"+xFilial("SN3")+"' AND N3_CBASE='"+bem+"' AND N3_ITEM='"+item+"' AND N3_TPSALDO!='1' AND D_E_L_E_T_!='*' "
  Oqry:TcQry("xDPR",cQuery,2,.f.)
  
  dbSelectArea("xDPR")
  lRet := (xDPR->JADEPRECIADO > 0)
  xDPR->(dbCloseArea())

Return

*Funcao*********************************************************************************************************************************

Static Function fSQLupd(bem,item)

  Local lRet, lUPD, nRecno, aSN3 := {}
  
  Local bOk := {|| lUPD:=.T. , oDlgCX:End() }
  Local bCancel:= {|| lUPD:=.F. , oDlgCX:End() }
  
  Local oFont14 := TFont():New('Arial',,-14,,.T.)
    
  cQuery := "SELECT N3_CCONTAB,N3_CUSTBEM,N3_CDEPREC,N3_CCUSTO,N3_CCDEPR,N3_CDESP,N3_CCORREC,N3_VORIG1,N3_TXDEPR1,N3_VORIG2,N3_TXDEPR2, "
  cQuery += "       N3_VORIG3,N3_TXDEPR3,N3_VORIG4,N3_TXDEPR4,N3_VORIG5,N3_TXDEPR5,N3_CCDESP,N3_CCCDEP,N3_CCCDES,N3_CCCORR,R_E_C_N_O_ "
  cQuery += "FROM SN3010 WHERE N3_FILIAL='"+xFilial("SN3")+"' AND N3_CBASE='"+bem+"' AND N3_ITEM='"+item+"' AND N3_TPSALDO='1' AND D_E_L_E_T_!='*' "
  Oqry:TcQry("xSN3",cQuery,2,.f.)
  
  dbSelectArea("xSN3")
  If ! xSN3->(EOF())
    lRet := .T.
    nRecno := AllTrim(Str(xSN3->R_E_C_N_O_))
    aadd(aSN3, {"Conta       ",xSN3->N3_CCONTAB,xSN3->N3_CCONTAB,"@!","CT1"})
    aadd(aSN3, {"Cta Desp Dep",xSN3->N3_CDEPREC,xSN3->N3_CDEPREC,"@!","CT1"})
    aadd(aSN3, {"Cta Dep Acum",xSN3->N3_CCDEPR ,xSN3->N3_CCDEPR ,"@!","CT1"})
    aadd(aSN3, {"C Custo Bem ",xSN3->N3_CUSTBEM,xSN3->N3_CUSTBEM,"@!","CTT"})
    aadd(aSN3, {"Val Orig M1 ",xSN3->N3_VORIG1 ,xSN3->N3_VORIG1 ,"@E 999,999,999.99",""})
    aadd(aSN3, {"Tx.An.Depr.1",xSN3->N3_TXDEPR1,xSN3->N3_TXDEPR1,"@E 999.99",""})
  Else
    lRet := .F.
  EndIf
  xSN3->(dbCloseArea())
  
  If lRet
    Define MsDialog oDlgCX Title "Ajuste do Ativo antes da Depreciacao" From 0,0 To 400, 450 Of oMainWnd Pixel
      nLinha := 39
      TSay():New(nLinha+0,05 ,{|| "Campo referencia" },oDlgCX,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,99,10)
      TSay():New(nLinha+0,80 ,{|| "Conteudo atual"   },oDlgCX,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,99,10)
      TSay():New(nLinha+0,145,{|| "Novo conteudo"    },oDlgCX,,oFont14,,,,.T.,CLR_RED,CLR_WHITE,99,10)
      nLinha := nLinha + 10
      TPanel():New(nLinha+0,05,"",oDlgCX, ,.T.,,CLR_YELLOW,CLR_BLUE,200,02)
      nLinha := nLinha + 10
      TSay():New(nLinha+4,05 ,{|| aSN3[1,1]  },oDlgCX,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,99,10)
      TGet():New(nLinha+0,80 ,{|u| if(PCount()>0,aSN3[1,2]:=u,aSN3[1,2])},oDlgCX,55,10,aSN3[1,4],{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,aSN3[1,5],"aSN3[1,2]")
      TGet():New(nLinha+0,145,{|u| if(PCount()>0,aSN3[1,3]:=u,aSN3[1,3])},oDlgCX,55,10,aSN3[1,4],{|| CTB105CTA(aSN3[1,3]) },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,aSN3[1,5],"aSN3[1,3]")
      nLinha := nLinha + 20      
      TSay():New(nLinha+4,05 ,{|| aSN3[2,1]  },oDlgCX,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,99,10)
      TGet():New(nLinha+0,80 ,{|u| if(PCount()>0,aSN3[2,2]:=u,aSN3[2,2])},oDlgCX,55,10,aSN3[2,4],{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,aSN3[2,5],"aSN3[2,2]")
      TGet():New(nLinha+0,145,{|u| if(PCount()>0,aSN3[2,3]:=u,aSN3[2,3])},oDlgCX,55,10,aSN3[2,4],{|| CTB105CTA(aSN3[2,3]) },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,aSN3[2,5],"aSN3[2,3]")
      nLinha := nLinha + 20      
      TSay():New(nLinha+4,05 ,{|| aSN3[3,1]  },oDlgCX,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,99,10)
      TGet():New(nLinha+0,80 ,{|u| if(PCount()>0,aSN3[3,2]:=u,aSN3[3,2])},oDlgCX,55,10,aSN3[3,4],{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,aSN3[3,5],"aSN3[3,2]")
      TGet():New(nLinha+0,145,{|u| if(PCount()>0,aSN3[3,3]:=u,aSN3[3,3])},oDlgCX,55,10,aSN3[3,4],{|| CTB105CTA(aSN3[3,3]) },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,aSN3[3,5],"aSN3[3,3]")
      nLinha := nLinha + 20      
      TSay():New(nLinha+4,05 ,{|| aSN3[4,1]  },oDlgCX,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,99,10)
      TGet():New(nLinha+0,80 ,{|u| if(PCount()>0,aSN3[4,2]:=u,aSN3[4,2])},oDlgCX,55,10,aSN3[4,4],{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,aSN3[4,5],"aSN3[4,2]")
      TGet():New(nLinha+0,145,{|u| if(PCount()>0,aSN3[4,3]:=u,aSN3[4,3])},oDlgCX,55,10,aSN3[4,4],{|| Ctb105CC(aSN3[4,3]) },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,aSN3[4,5],"aSN3[4,3]")
      nLinha := nLinha + 20      
      TSay():New(nLinha+4,05 ,{|| aSN3[5,1]  },oDlgCX,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,99,10)
      TGet():New(nLinha+0,80 ,{|u| if(PCount()>0,aSN3[5,2]:=u,aSN3[5,2])},oDlgCX,55,10,aSN3[5,4],{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,aSN3[5,5],"aSN3[5,2]")
      TGet():New(nLinha+0,145,{|u| if(PCount()>0,aSN3[5,3]:=u,aSN3[5,3])},oDlgCX,55,10,aSN3[5,4],{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,aSN3[5,5],"aSN3[5,3]")
      nLinha := nLinha + 20      
      TSay():New(nLinha+4,05 ,{|| aSN3[6,1]  },oDlgCX,,oFont14,,,,.T.,CLR_BLUE,CLR_WHITE,99,10)
      TGet():New(nLinha+0,80 ,{|u| if(PCount()>0,aSN3[6,2]:=u,aSN3[6,2])},oDlgCX,55,10,aSN3[6,4],{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.T.,.F.,aSN3[6,5],"aSN3[6,2]")
      TGet():New(nLinha+0,145,{|u| if(PCount()>0,aSN3[6,3]:=u,aSN3[6,3])},oDlgCX,55,10,aSN3[6,4],{|| },,,,.F.,,.T.,,.F.,{||},.F.,.F., ,.F.,.F.,aSN3[6,5],"aSN3[6,3]")
    Activate MsDialog oDlgCX On Init EnchoiceBar(oDlgCX, bOk , bCancel) Centered 
  EndIf
  
  If lUPD
    If aSN3[1,2] <> aSN3[1,3]
      TcSqlExec("UPDATE SN3010 SET N3_CCONTAB="+AllTrim(aSN3[1,3])+" WHERE R_E_C_N_O_="+nRecno)

      TcSqlExec("UPDATE SN4010 SET N4_CONTA="+AllTrim(aSN3[1,3])+" WHERE N4_FILIAL='"+xFilial("SN4")+"' AND N4_CBASE='"+bem+"' AND N4_ITEM='"+item+"' AND N4_TIPOCNT='1' AND D_E_L_E_T_!='*'")
    EndIf

    If aSN3[2,2] <> aSN3[2,3]
      TcSqlExec("UPDATE SN3010 SET N3_CDEPREC="+AllTrim(aSN3[2,3])+" WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_CDESP="+AllTrim(aSN3[2,3])+"   WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_CCORREC="+AllTrim(aSN3[2,3])+" WHERE R_E_C_N_O_="+nRecno)
    EndIf
    
    If aSN3[3,2] <> aSN3[3,3]
      TcSqlExec("UPDATE SN3010 SET N3_CCDEPR="+aSN3[3,3]+" WHERE R_E_C_N_O_="+nRecno)
    EndIf
    
    If aSN3[4,2] <> aSN3[4,3]
      TcSqlExec("UPDATE SN3010 SET N3_CUSTBEM="+AllTrim(aSN3[4,3])+" WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_CCUSTO="+AllTrim(aSN3[4,3])+"  WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_CCDESP="+AllTrim(aSN3[4,3])+"  WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_CCCDEP="+AllTrim(aSN3[4,3])+"  WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_CCCDES="+AllTrim(aSN3[4,3])+"  WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_CCCORR="+AllTrim(aSN3[4,3])+"  WHERE R_E_C_N_O_="+nRecno)
    EndIf
    
    If aSN3[5,2] <> aSN3[5,3]
      TcSqlExec("UPDATE SN3010 SET N3_VORIG1=("+AllTrim(Str(aSN3[5,3]))+") WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_VORIG2=ROUND("+AllTrim(Str(aSN3[5,3]))+"*(N3_VORIG2/"+AllTrim(Str(aSN3[5,2]))+"),6) WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_VORIG3=ROUND("+AllTrim(Str(aSN3[5,3]))+"*(N3_VORIG3/"+AllTrim(Str(aSN3[5,2]))+"),6) WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_VORIG4=ROUND("+AllTrim(Str(aSN3[5,3]))+"*(N3_VORIG4/"+AllTrim(Str(aSN3[5,2]))+"),6) WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_VORIG5=ROUND("+AllTrim(Str(aSN3[5,3]))+"*(N3_VORIG5/"+AllTrim(Str(aSN3[5,2]))+"),6) WHERE R_E_C_N_O_="+nRecno)

      TcSqlExec("UPDATE SN4010 SET N4_VLROC1=("+AllTrim(Str(aSN3[5,3]))+") WHERE N4_FILIAL='"+xFilial("SN4")+"' AND N4_CBASE='"+bem+"' AND N4_ITEM='"+item+"' AND N4_TIPOCNT='1' AND D_E_L_E_T_!='*'")
      TcSqlExec("UPDATE SN4010 SET N4_VLROC2=ROUND("+AllTrim(Str(aSN3[5,3]))+"*(N4_VLROC2/"+AllTrim(Str(aSN3[5,2]))+"),6) WHERE N4_FILIAL='"+xFilial("SN4")+"' AND N4_CBASE='"+bem+"' AND N4_ITEM='"+item+"' AND N4_TIPOCNT='1' AND D_E_L_E_T_!='*'")
      TcSqlExec("UPDATE SN4010 SET N4_VLROC3=ROUND("+AllTrim(Str(aSN3[5,3]))+"*(N4_VLROC3/"+AllTrim(Str(aSN3[5,2]))+"),6) WHERE N4_FILIAL='"+xFilial("SN4")+"' AND N4_CBASE='"+bem+"' AND N4_ITEM='"+item+"' AND N4_TIPOCNT='1' AND D_E_L_E_T_!='*'")
      TcSqlExec("UPDATE SN4010 SET N4_VLROC4=ROUND("+AllTrim(Str(aSN3[5,3]))+"*(N4_VLROC4/"+AllTrim(Str(aSN3[5,2]))+"),6) WHERE N4_FILIAL='"+xFilial("SN4")+"' AND N4_CBASE='"+bem+"' AND N4_ITEM='"+item+"' AND N4_TIPOCNT='1' AND D_E_L_E_T_!='*'")
      TcSqlExec("UPDATE SN4010 SET N4_VLROC5=ROUND("+AllTrim(Str(aSN3[5,3]))+"*(N4_VLROC5/"+AllTrim(Str(aSN3[5,2]))+"),6) WHERE N4_FILIAL='"+xFilial("SN4")+"' AND N4_CBASE='"+bem+"' AND N4_ITEM='"+item+"' AND N4_TIPOCNT='1' AND D_E_L_E_T_!='*'")
    EndIf
      
    If aSN3[6,2] <> aSN3[6,3]
      TcSqlExec("UPDATE SN3010 SET N3_TXDEPR1="+AllTrim(Str(aSN3[6,3]))+" WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_TXDEPR2="+AllTrim(Str(aSN3[6,3]))+" WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_TXDEPR3="+AllTrim(Str(aSN3[6,3]))+" WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_TXDEPR4="+AllTrim(Str(aSN3[6,3]))+" WHERE R_E_C_N_O_="+nRecno)
      TcSqlExec("UPDATE SN3010 SET N3_TXDEPR5="+AllTrim(Str(aSN3[6,3]))+" WHERE R_E_C_N_O_="+nRecno)
      
      TcSqlExec("UPDATE SN4010 SET N4_TXDEPR="+AllTrim(Str(aSN3[6,3]))+" WHERE N4_FILIAL='"+xFilial("SN4")+"' AND N4_CBASE='"+bem+"' AND N4_ITEM='"+item+"' AND N4_TIPOCNT='1' AND D_E_L_E_T_!='*'")
    EndIf
    APMsgInfo("Alteração realizada","MYATF03")
  EndIf

Return lRet


                  