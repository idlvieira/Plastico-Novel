#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#Include "Protheus.CH"
 
User Function PNCOM01()
    Local oDlg, oPanel, btnEnviar
    Local nCont
    Local cPerg		:= FunName()
    Local aSize		:= MsAdvSize(.F.)
    Local nMSEsq   	:= aSize[7]		//Margem Superior Esquerda
    Local nMIEsq   	:= 0			//Margem Inferior Esquerda
    Local nMIDir 	:= aSize[6]		//Margem Superior Direita
    Local nMSDir  	:= aSize[5]  	//Margem Inferior Direita
    Local nWidth	:= 0
    Local bConfirma	:= {|| }
    Local bAct001
    Local bAct002
    Private cProduto:= Space(TamSx3("C6_PRODUTO")[1])
    Private cCnpj	:= Space(TamSx3("A1_CGC")[1])
    Private aCampos	:= {}, aColunas := {}, aBrowse	:= {}, aFields := {}, aSeek := {}, aFiltro := {}
    Private aDados	:= {}
    Private lEditar	:= .T.
    Private lItemPC := .T.
    Private oItemPC := Nil
    Private oBrowse	:= FWBrowse():New()
    Private oProduto, oCnpj, btnConfirma
    
    //AjustaSX1(cPerg)
    //Pergunte(cPerg,.F.)
    cCnpj := ""
    
    /* Definição de campos que serão exibidos na visualização. */
    aCampos:= {"C6_NUM", "C6_NUMORC", "C6_ITEM", "C6_PRODUTO", "C6_DESCRI", "C6_LOCAL", "C6_QTDVEN", "C6_TES", "C6_PRCVEN","C6_ITEMPC","C6_NUMPCOM","C6_UM","C6_PEDCLI","C6_ZZDTREC","C6_ZZPRIPI"}
    
    Define MsDialog oDlg Title "Analise de KT" From nMSEsq,nMIEsq To nMIDir,nMSDir Of oMainWnd Pixel STYLE nOR( WS_VISIBLE, WS_POPUP )
    oDlg:lMaximized := .T.
 
    //SetKey(VK_F5, SuaFuncao() ) //Criando tecla de atalho 
    
    /* Parte superior */
    For nCont := 1 To Len(aCampos)
        dbSelectArea("SX3")
        SX3->(dbSetOrder(2))
        SX3->(dbSeek(aCampos[nCont]))
        
        aAdd( aColunas , MontaColunas("{|| aDados[oBrowse:nAt,"+cValToChar(nCont)+"] }",aDados) )
        
        If SX3->X3_CONTEXT == "V" // Apenas campos REAIS
            aAdd(aFields, { ;
                SX3->X3_CAMPO  , ;
                X3Titulo()     , ;
                SX3->X3_TIPO   , ;
                SX3->X3_TAMANHO, ;
                SX3->X3_DECIMAL, ;
                PesqPict(SX3->X3_ARQUIVO, SX3->X3_CAMPO, ), ;
                AllTrim(X3CBox()), ;
                SX3->X3_F3, ;
                {|| .T. }, ;
                Nil ;
                })
            //Montar filtro de pesquisa de determinados campos
            If Alltrim(SX3->X3_CAMPO)$"C6_NUM|C6_NUMORC|C6_PRODUTO|C6_TES|C6_PEDCLI"
                Aadd(aFiltro, {SX3->X3_CAMPO, X3Titulo(), SX3->X3_TIPO, SX3->X3_TAMANHO, 5, PesqPict(SX3->X3_ARQUIVO, SX3->X3_CAMPO, )})
                Aadd(aSeek  , {X3Titulo(), {{"",SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_TAMANHO, 5, SX3->X3_CAMPO}} } )
            Endif
            
        EndIf
        
    Next nCont
    
    /*Browse*/
    oBrowse:SetOwner(oDlg)
    oBrowse:SetDescription("Analise de KT")
    oBrowse:SetDataArray()
    oBrowse:SetColumns(aColunas)
    oBrowse:SetArray(aDados)
    oBrowse:lHeaderClick:=.F.
    oBrowse:SetLocate() // Habilita a Localização de registros
    oBrowse:SetSeek(nil,aSeek)
    oBrowse:SetFieldFilter(aFiltro)
    oBrowse:SetEditCell( .T. ) 				// indica que o grid é editavel
    oBrowse:acolumns[10]:ledit	 := lEditar //Habilita a coluna 10 como editável
    oBrowse:acolumns[10]:cReadVar:= 'aDados[oBrowse:nat,10]' //Cria variavel de memoria
    oBrowse:bValidEdit  := {|| MFAT024E(aCampos,cProduto,cCNPJ) } // valida e move o valor para o array
    oBrowse:Activate()
    
    /*Parte inferior*/
    oPanel	 := tPanel():New(0, 0, "", oDlg,,,,,16777215,100,26)
    oProduto := tGet():New( 003, 005,{|u| if(PCount()==0,cProduto:=u,cProduto)},oPanel,080,010,PesqPict("SC6","C6_PRODUTO"),{ || },,,,,,.T.,,, {|| .T. } ,,,{||  },.F.,/*lPassword*/,"SB1","cProduto",,,,.T.,,,"Produto: ",1,,,"Produto")
    oCnpj	 := TGet():New( 003, 095,{|u| if(PCount()==0,cCNPJ:=u,cCNPJ)}	  ,oPanel,080,010,PesqPict("SA1","A1_CGC")	  ,{ || },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SA1CNP","cCNPJ",,,,.T.,,,"CNPJ Cliente: ",1,,,"CNPJ")
    btnEnviar:= TButton():New( 010, 185, "Procurar",oPanel,Nil, 060, 012,,,.F.,.T.,.F.,,.F.,,,.F. )
    btnEnviar:bAction := {|| MsgRun("Montando estrutura...","Processando",{|| MFAT024C(aCampos,cProduto,cCNPJ) }), SalvaSX1(cPerg,cCNPJ) }
 
    oItemPC:= TCheckBox():New(012, 255,"Confirmar alteração após informar Num.Ped.Cliente",{|u| If(PCount()==0,lItemPC:=u,lItemPC)},oPanel,200, 008,,{||  },,{|| },CLR_RED,CLR_WHITE,,.T.,"",,{|| } )
    
    nWidth	   := (nMSDir/2)
    btnConfirma:= TButton():New( 005, nWidth-060, "Confirmar (F5)",oPanel,Nil, 060, 017,,,.F.,.T.,.F.,,.F.,,,.F. )
    btnConfirma:bAction := bConfirma
    btnConfirma:Disable()
    
    oBrowse:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
    oPanel:Align:= CONTROL_ALIGN_BOTTOM
    
    Activate MsDialog oDlg CENTERED
    
    SetKey(VK_F5,{||})
Return
 

//Validação do campo editável
Static Function MFAT024E(aCampos,cProduto,cCNPJ)
    Local lRet		:= .T.
    Local cItemPC 	:= iif(!Empty(aDados[oBrowse:nAt,10]),aDados[oBrowse:nAt,10],Space(TamSx3("C6_ITEMPC")[1]))  // ItemPC
    oBrowse:setArray(aDados)	// Forço o Browse a ler os novos valores informados.
    oBrowse:Refresh()			// Refresh do Grid
Return ( lRet )

Static Function MFAT024C(aCampos,cProduto,cCNPJ)
    Local cPedCli	:= ""
    Local cQuery	:= ""
    Local nCont		:= 0
    
    If Len(aCampos) == 0
        Aviso("Atenção","Não há campos configuradors para exibição de grade!"+CRLF+CRLF+;
            "Entre em contato com o Administrador.",{"Fechar"},1)
        Return
    Endif
    
    If Empty(cCNPJ)
        Alert("Para iniciar a pesquisa é necessário informar o CNPJ!")
        oCNPJ:SetFocus()
        Return
    Endif
    
    Begin Sequence
        
        cQuery:= "SELECT "
        
        For nCont:= 1 To Len(aCampos)
            If nCont == 1
                cQuery += ", "
            EndIf
            cQuery += aCampos[nCont]
        Next
        
        cQuery += " FROM " + RetSqlName("SC6") + " SC6 " + CRLF
        cQuery += " WHERE D_E_L_E_T_= '' " + CRLF
        cQuery += " AND C6_FILIAL 	= '" + xFilial("SC6") + "'" + CRLF
        if !Empty(cProduto)
            cQuery += " AND C6_PRODUTO	= '" + Alltrim(cProduto) + "'" + CRLF
        Endif
        cQuery += " AND C6_CLI + C6_LOJA IN (SELECT A1_COD+A1_LOJA AS 'CLIENTE' FROM " + RetSqlName("SA1") + " SA1  WHERE SA1.D_E_L_E_T_='' AND A1_FILIAL = '" + xFilial("SA1") + "' AND A1_CGC = '"+cCNPJ+"')" + CRLF
        cQuery += " AND C6_QTDVEN == C6_QTDENT" + CRLF
        cQuery += " AND C6_LOCAL = 'KT'" + CRLF
        cQuery += " AND C6_NUMPCOM=''" + CRLF
        cQuery += " ORDER BY C6_NUM, C6_ITEM, C6_PRODUTO"
        
        If ( SELECT("TRB") ) == 0
            dbSelectArea("TRB")
            TRB->(dbCloseArea())
        EndIf
        
        TcQuery cQuery Alias "TRB" New
        
        TRB->(DBGoTop())
        aDados := {}
        While TRB->(!Eof())
            cPedCli := Posicione("SC5",1,xFilial("SC5")+TRB->C6_NUM,"C5_ZZPVCL")
            AAdd(aDados, { TRB->C6_NUM, TRB->C6_NUMORC, TRB->C6_ITEM, TRB->C6_PRODUTO, TRB->C6_DESCRI, TRB->C6_LOCAL, TRB->C6_QTDVEN, TRB->C6_TES, TRB->C6_PRCVEN, TRB->C6_ITEMPC, TRB->C6_NUMPCOM, TRB->C6_UM, cPedCli, STOD(TRB->C6_ZZDTREC), TRB->C6_ZZPRIPI })
            TRB->(DBSkip())
        EndDo
        
        //Popula o array do browse		
        oBrowse:SetArray(aDados)
        btnConfirma:Enable()
        oBrowse:Refresh()
        oBrowse:SetFocus()
        
        TRB->(DBCloseArea())
        
    End Sequence
    
Return

Static Function MontaColunas(cDados,aBrowse)
    Local oCol
    
    oCol := FWBrwColumn():New()														//Cria objeto
    oCol:SetTitle( AllTrim(X3Titulo()) )											//Define titulo
    oCol:SetData( &(cDados))														//Define valor
    oCol:SetType( SX3->X3_TIPO )													//Define tipo
    oCol:SetPicture( SX3->X3_PICTURE ) 												//Define picture
    oCol:SetAlign( If(SX3->X3_TIPO == "N",CONTROL_ALIGN_RIGHT,CONTROL_ALIGN_LEFT) )	//Define alinhamento
    oCol:SetSize( SX3->X3_TAMANHO + SX3->X3_DECIMAL )								//Define tamanho
    oCol:SetEdit( .F. )																//Indica se é editavel
    
Return oCol

