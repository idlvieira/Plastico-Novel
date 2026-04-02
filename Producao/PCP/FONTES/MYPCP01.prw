#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYPCP01.prw                | Autor : Leonardo Bergamasco           |\
/|-------------------------------------------------------------------------------|\
/| Data     : 09/01/2019                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Rotina para a exclusão de OP sem apontamento e/ou encerramento OP  |\
/.-------------------------------------------------------------------------------.*/
//                              ALTERACOES                                        */


User Function MYPCP01() 

  Local nOpc := 0
  
  nOpc := Aviso("Encerramento/Exclusão OP","Essa rotina foi customizada para auxiliar o PCP na manutenção da Ordem de Produção, referente ao Encerramento da Ordem de Produção COM apontamento ou na Exclusão da Ordem de Produção SEM apontamento",{"Encerrar","Excluir","Cancelar"},3,"Novel")
 
  If nOpc > 0 .and. nOpc < 2
    ENC_OPVT()    
  ElseIf nOpc > 1 .and. nOpc < 3
    EXC_OPVT()
  EndIf

Return

*Funcao*********************************************************************************************************************************

Static Function ENC_OPVT()

  Local oDtl, oOrig, oDtDe, oDtAte, oOpDe, oOpAte
  Private cOrig:=space(7), dDtDe:=CtoD("  /  /  "), dDtAte:=CtoD("  /  /  "), cOpDe:=space(6), cOpAte:=space(6)
  
  //** Montagem da Tela do usuario (Parametros para exclusao)
  Define MSDialog oDtl Title "Encerramento de OP's (Procedimento automatico)" From 00,00 to 240, 450 Pixel  

    TSay():New(035,025,{||'* Filtro *'},oDtl,, ,,,,.T.,CLR_RED,CLR_WHITE,60,15)
    TSay():New(035,070,{||' * De  *  '},oDtl,, ,,,,.T.,CLR_RED,CLR_WHITE,60,15)
    TSay():New(035,115,{||' * Ate *  '},oDtl,, ,,,,.T.,CLR_RED,CLR_WHITE,60,15)

    oOrig  := TComboBox():New(045,025,{|u|if(PCount()>0,cOrig:=u,cOrig)},{"Emissao","Entrega"},40,13,oDtl,,{||},,,,.T.,,,,,,,,,"cOrig")
    oDtDe  := TGet():New(045,070,{|u|if(PCount()>0,dDtDe :=u,dDtDe )},oDtl,40,10,"@!",,,,,.F.,,.T.,,.F.,{||},.F.,.F.,,.F.,.F.,"   ","dDtDe" )
    oDtAte := TGet():New(045,115,{|u|if(PCount()>0,dDtAte:=u,dDtAte)},oDtl,40,10,"@!",,,,,.F.,,.T.,,.F.,{||},.F.,.F.,,.F.,.F.,"   ","dDtAte")

    TSay():New(064,025,{||'Numero OP:'},oDtl,, ,,,,.T., , ,60,15)
    oOpDe  := TGet():New(060,070,{|u|if(PCount()>0,cOpDe :=u,cOpDe )},oDtl,35,10,"@!",,,,,.F.,,.T.,,.F.,{||},.F.,.F.,,.F.,.F.,"SC2","cOpDe" )
    oOpAte := TGet():New(060,115,{|u|if(PCount()>0,cOpAte:=u,cOpAte)},oDtl,35,10,"@!",,,,,.F.,,.T.,,.F.,{||},.F.,.F.,,.F.,.F.,"SC2","cOpAte")

    TSay():New(095,005,{||'Obs. A rotina encerra as OPs independente dos saldo' },oDtl,, ,,,,.T.,CLR_RED, ,150,30)
        
  Activate MSDialog oDtl Centered on Init EnchoiceBar(oDtl,{|| procEncOP(), oDtl:End() },{|| oDtl:End() },,)

Return

*Funcao*********************************************************************************************************************************

//Seleciona as OP's com a Quantidade Produzida diferente de zero, referenciando a Dt.Emissao ou Dt.Prev.Entrega
//Executa o MSExecAuto para o encerramento
Static Function procEncOP()

  Local cQuery   := ""
  Local aVetor   := {}
  Local cMsg     := ""
  Local Oqry:=NVLxFUN():New(.f.)

  If Aviso("Encerramento da(s) ORDEM DE PRODUCAO","Tem certeza que deseja encerrar a(s) OP(s)",{"ENCERRAR","Cancelar"},3,"") <> 1
    Return
  EndIf

  //Seleciona as OPs em aberto
  cQuery += "SELECT C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN " + linha
  cQuery += "FROM SC2010 " + linha
  cQuery += "WHERE C2_FILIAL='"+xFilial("SC2")+"' AND " + linha
  cQuery += "      C2_DATRF=' ' AND " + linha
  cQuery += "      C2_QUJE>0  AND " + linha
  cQuery += "      C2_NUM BETWEEN '"+cOpDe+"' AND '"+cOpAte+"' AND " + linha
  If cOrig == "Emissao"
    cQuery+="      C2_EMISSAO BETWEEN '"+DtoS(dDtDe)+"' AND '"+DtoS(dDtAte)+"' AND " + linha
  ElseIf cOrig == "Entrega"
    cQuery+="      C2_DATPRF  BETWEEN '"+DtoS(dDtDe)+"' AND '"+DtoS(dDtAte)+"' AND " + linha
  EndIf
  cQuery += "      D_E_L_E_T_!='*' " + linha
  cQuery += "ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN " + linha

  MsAguarde( {|| Oqry:TcQry("encOP", cQuery,1,.f.) }, "Selecionando dados (ENC_OPVT)...")
  
  dbSelectarea("encOP")
  dbGotop()
  Do While encOP->( !Eof() )
  	aVetor := {}
  	
  	//Posicio SD3 no Registro selecionado
  	cQuery := "SELECT MAX(R_E_C_N_O_) REC FROM SD3010 WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_OP='"+encOP->C2_NUM+encOP->C2_ITEM+encOP->C2_SEQUEN+"' AND D3_CF='PR0' AND D3_ESTORNO='' AND D_E_L_E_T_!='*' "
  	Oqry:TcQry("D3enc", cQuery,1,.f.)
  	If ! D3enc->(EOF())
	  dbSelectArea("SD3")
	  DbGoto(D3enc->REC)
	
      //Array enviado para o MSExecAuto	
      aVetor := {     {"D3_OP"     , SD3->D3_OP          , Nil}, ;
                      {"D3_TM"     , SD3->D3_TM          , Nil}, ;
                      {"D3_COD"    , SD3->D3_COD         , Nil}, ;
                      {"D3_EMISSAO", SD3->D3_EMISSAO     , Nil}, ;
                      {"D3_DOC"    , SD3->D3_DOC         , Nil}, ;
                      {"D3_NUMSEQ" , SD3->D3_NUMSEQ      , Nil}  } 			    
				    
      cMsg := SD3->D3_OP

      //** Chamada da rotina automatica **\\
      lMsErroAuto := .F.
	  MsAguarde( {|| MSExecAuto({|x, y| mata250(x, y)}, aVetor, 6) }, "Encerrando OP  "+cMsg+" (ENC_OPVT)...")
  	  If lMsErroAuto
	    MostraErro()
  	  Endif	
	EndIf
	D3enc->( dbCloseArea() )
	dbSelectArea("encOP")
	dbSkip()
  EndDo
  encOP->( dbCloseArea() )
  
Return

*Funcao*********************************************************************************************************************************

Static Function EXC_OPVT()

  Local oDtl, oOrig, oDtDe, oDtAte, oOpDe, oOpAte
  Private cOrig:=space(7), dDtDe:=CtoD("  /  /  "), dDtAte:=CtoD("  /  /  "), cOpDe:=space(6), cOpAte:=space(6)
  
  //** Montagem da Tela do usuario (Parametros para exclusao)
  Define MSDialog oDtl Title "Exclusao de OP's" From 00,00 to 240, 450 Pixel  

    TSay():New(035,025,{||'* Filtro *'},oDtl,, ,,,,.T.,CLR_RED,CLR_WHITE,60,15)
    TSay():New(035,070,{||' * De  *  '},oDtl,, ,,,,.T.,CLR_RED,CLR_WHITE,60,15)
    TSay():New(035,115,{||' * Ate *  '},oDtl,, ,,,,.T.,CLR_RED,CLR_WHITE,60,15)

    oOrig  := TComboBox():New(045,025,{|u|if(PCount()>0,cOrig:=u,cOrig)},{"Emissao","Entrega"},40,13,oDtl,,{||},,,,.T.,,,,,,,,,"cOrig")
    oDtDe  := TGet():New(045,070,{|u|if(PCount()>0,dDtDe :=u,dDtDe )},oDtl,40,10,"@!",,,,,.F.,,.T.,,.F.,{||},.F.,.F.,,.F.,.F.,"   ","dDtDe" )
    oDtAte := TGet():New(045,115,{|u|if(PCount()>0,dDtAte:=u,dDtAte)},oDtl,40,10,"@!",,,,,.F.,,.T.,,.F.,{||},.F.,.F.,,.F.,.F.,"   ","dDtAte")

    TSay():New(064,025,{||'Numero OP:'},oDtl,, ,,,,.T., , ,60,15)
    oOpDe  := TGet():New(060,070,{|u|if(PCount()>0,cOpDe :=u,cOpDe )},oDtl,35,10,"@!",,,,,.F.,,.T.,,.F.,{||},.F.,.F.,,.F.,.F.,"SC2","cOpDe" )
    oOpAte := TGet():New(060,115,{|u|if(PCount()>0,cOpAte:=u,cOpAte)},oDtl,35,10,"@!",,,,,.F.,,.T.,,.F.,{||},.F.,.F.,,.F.,.F.,"SC2","cOpAte")

    TSay():New(095,005,{||'Obs. A rotina exclui apenas as OPs sem apontamento' },oDtl,, ,,,,.T.,CLR_RED, ,150,30)
        
  Activate MSDialog oDtl Centered on Init EnchoiceBar(oDtl,{|| procExcOP(), oDtl:End() },{|| oDtl:End() },,)

Return

*Funcao*********************************************************************************************************************************

//Seleciona as OP's sem Data Encerramento e Quantidade Produzida zero, referenciando a Dt.Emissao ou Dt.Prev.Entrega p/Produtos iniciado no parametro "ZZ_EXCOPAM"
//Executa o MSExecAuto para a exclusao
Static Function procExcOP()

  Local cQuery   := ""
  Local aVetor   := {}
  Local cMsg     := ""
  Local Oqry:=NVLxFUN():New(.f.)

  If Aviso("Exclusão da(s) ORDEM DE PRODUCAO","Tem certeza que deseja excluir a(s) OP(s)",{"EXCLUIR","Cancelar"},3,"") <> 1
    Return
  EndIf

  //Seleciona as OPs em aberto
  cQuery += "SELECT C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN " + linha
  cQuery += "FROM SC2010 " + linha
  cQuery += "WHERE C2_FILIAL='"+xFilial("SC2")+"' AND " + linha
  cQuery += "      C2_DATRF=' ' AND " + linha
  cQuery += "      C2_QUJE=0  AND " + linha
  cQuery += "      C2_NUM BETWEEN '"+cOpDe+"' AND '"+cOpAte+"' AND " + linha
  If cOrig == "Emissao"
    cQuery+="      C2_EMISSAO BETWEEN '"+DtoS(dDtDe)+"' AND '"+DtoS(dDtAte)+"' AND " + linha
  ElseIf cOrig == "Entrega"
    cQuery+="      C2_DATPRF  BETWEEN '"+DtoS(dDtDe)+"' AND '"+DtoS(dDtAte)+"' AND " + linha
  EndIf
  cQuery += "      D_E_L_E_T_!='*' " + linha
  cQuery += "ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN " + linha

  MsAguarde( {|| Oqry:TcQry("excOP", cQuery,1,.f.) }, "Selecionando dados (EXC_OPVT)...")
  
  dbSelectarea("excOP")
  dbGotop()
  Do While excOP->( !Eof() )
  	aVetor := {}
  	
  	//Posicio SC2 no Registro selecionado
	dbSelectArea("SC2")
	dbSetOrder(1)
	If SC2->( dbSeek (xfilial("SC2")+excOP->C2_NUM+excOP->C2_ITEM+excOP->C2_SEQUEN+" ") )

      //Array enviado para o MSExecAuto	
	  aVetor := {	{"C2_FILIAL", SC2->C2_FILIAL ,NIL},;
	  				{"C2_NUM"   , SC2->C2_NUM    ,NIL},;
				    {"C2_ITEM"  , SC2->C2_ITEM   ,NIL},;
				    {"C2_SEQUEN", SC2->C2_SEQUEN ,NIL} }
				    
      cMsg := SC2->C2_NUM+"-"+SC2->C2_ITEM+"/"+SC2->C2_SEQUEN

      //** Chamada da rotina automatica **\\
      lMsErroAuto := .F.
	  MsAguarde( {|| MSExecAuto({|x,y| mata650(x,y)},aVetor,5) }, "Excluindo OP "+cMsg+" (EXC_OPVT)...")
  	  If lMsErroAuto
	    MostraErro()
  	  Endif	
	EndIf
	
	dbSelectArea("excOP")
	dbSkip()
  EndDo
  excOP->( dbCloseArea() )
  
Return
