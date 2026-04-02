#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"
//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas


#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYFAT11.prw    | Autor : Leandro Ferreira      | Data : 06/02/2023 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Programação de entrega PCP			                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 06/02/2023  Leandro Ferreira          Camila Chaves   Criação do relatório   
// 29/08/2023  Leandro Ferreira          Totvs           Adequação banco 

User Function MYFAT11()

    Local cLinok 	:= "Allwaystrue"
    Local cTudook 	:= "Allwaystrue"
    Local nOpce 	:= 4 	//define modo de alteração para a enchoice
    Local nOpcg 	:= 4 	//define modo de alteração para o grid
    Local cFieldok 	:= "Allwaystrue"
    Local lRet 		:= .T.
    //Local cMensagem := ""
    Local lVirtual  := .T. 	//Mostra campos virtuais se houver
    Local nFreeze	:= 0	
    Local nAlturaEnc:= 400	//Altura da Enchoice

    Private cCadastro	:= "Pedido de Venda"	
    Private aCols 		:= {}
    Private aHeader 	:= {}
    Private aCpoEnchoice:= {}
    Private aAltEnchoice:= {} //{"C5_CONDPAG","C5_TPFRETE","C5_MENNOTA","C5_ZZPVCL","C5_ZZBOX","C5_ZZEQUIP","C5_ZZMOD1","C5_ZZMOD2","C5_ZZCAIXA"}
    Private cTitulo
    Private cAlias1 	:= "SC5"
    Private cAlias2 	:= "SC6"
    
    // Verifica se o pedido já está liberado
    If SC5->C5_ZZUANA1	!= "S"
        MsgStop("Este não esta liberado ainda")
    Else
        RegToMemory("SC5",.F.)
        RegToMemory("SC6",.F.)
    
        DefineCabec()
        DefineaCols(nOpcg)
        
        lRet:=Modelo3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,nOpcg,cFieldok,lVirtual,,aAltenchoice,nFreeze,,,nAlturaEnc)
        
        //retornará como true se clicar no botao confirmar
        if lRet

            if MsgYesNo("CONFIRMA ALTERAÇÃO DOS DADOS ?", cCadastro)
                Processa({||Gravar()},cCadastro,"Alterando os dados, aguarde...")
            endif
        else
            RollbackSx8()
        endif

    Endif

Return

 
Static Function DefineCabec()
    Local aSUB		:= {"C6_ITEM","C6_PRODUTO","C6_DESCRI","C6_QTDVEN","C6_ZZDATEN";
                        ,"C6_ZDTPRG1","C6_ZQTPRG1","C6_ZDTPRG2","C6_ZQTPRG2";
                        ,"C6_ZDTPRG3","C6_ZQTPRG3","C6_ZDTPRG4","C6_ZQTPRG4"}
    Local nUsado
    Local nX
    Local i 		:= 0
    LOCAL _aCpoSX3
    aHeader		:= {}
    aCpoEnchoice:= {}

    nUsado:=0
    
    //Monta a enchoice
    /*DbSelectArea("SX3")
    SX3->(DbSetOrder(1))
    dbseek(cAlias1)
    while SX3->(!eof()) .AND. X3_ARQUIVO == cAlias1
        IF X3USO(X3_USADO) .AND. CNIVEL >= X3_NIVEL
            AADD(ACPOENCHOICE,X3_CAMPO)
        endif
        dbskip()
    enddo*/
    _aCpoSX3 	:= FwSX3Util():GetAllFields(cAlias1)
    For i := 1 To Len(_aCpoSX3)

	    If( X3Uso(GetSx3Cache(_aCpoSX3[i], 'X3_USADO'))  )

            AADD(ACPOENCHOICE, AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')) )

        Endif

    Next i
    //AADD(ACPOENCHOICE,"C5_NUM")
    //AADD(ACPOENCHOICE,"C5_CLIENTE")

    //Monta o aHeader do grid conforme os campos definidos no array aSC6 (apenas os campos que deseja)
    //Caso contrário, se quiser todos os campos é necessário trocar o "For" por While, para que este faça a leitura de toda a tabela
    /*DbSelectArea("SX3")
    SX3->(DbSetOrder(2))
    aHeader:={}
    For nX := 1 to Len(aSUB)
        If SX3->(DbSeek(aSUB[nX]))
            If X3USO(X3_USADO).And.cNivel>=X3_NIVEL 
                nUsado:=nUsado+1
                Aadd(aHeader, {TRIM(X3_TITULO), X3_CAMPO , X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID, X3_USADO  , X3_TIPO   , X3_ARQUIVO, X3_CONTEXT})
            Endif
        Endif
    Next nX*/
    _aCpoSX3 	:= FwSX3Util():GetAllFields(cAlias2)
    For nX := 1 to Len(aSUB)
        For i := 1 To Len(_aCpoSX3)

	        If( AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')) $ aSUB[nX])

                AADD(aHeader, {AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_TITULO')),;
                        AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_PICTURE'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_TAMANHO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_DECIMAL'),;
                         ,;
                        GetSx3Cache(_aCpoSX3[i], 'X3_USADO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_TIPO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_F3'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_CONTEXT'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_CBOX'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_RELACAO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_WHEN'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_VISUAL'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_VLDUSER'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_PICTVAR'),;
                        If(GetSx3Cache(_aCpoSX3[i], 'X3_OBRIGAT') == "€", .T., .F.)}  )

            Endif

        Next i
 	Next nX 
 	 
Return
 
//Insere o conteudo no aCols do grid
Static function DefineaCols(nOpc)
    Local nQtdcpo 	:= 0
    Local i			:= 0
    Local nCols 	:= 0
    nQtdcpo 		:= len(aHeader)
    aCols			:= {}
    
    dbselectarea(cAlias2)
    dbsetorder(1)
    dbseek(xfilial(cAlias2)+(cAlias1)->C5_NUM)
    while .not. eof() .and. (cAlias2)->C6_FILIAL == xfilial(cAlias2) .and. (cAlias2)->C6_NUM==(cAlias1)->C5_NUM
        aAdd(aCols,array(nQtdcpo+1))
        nCols++
        for i:= 1 to nQtdcpo
            if aHeader[i,10] != "V"
                aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))
            else
                aCols[nCols,i] := Criavar(aHeader[i,2],.T.)
            endif
        next i
        aCols[nCols,nQtdcpo+1] := .F.
        dbselectarea(cAlias2)
        dbskip()
    enddo
Return
 

//Gravar o conteudo dos campos
Static Function Gravar()
    //Local bcampo := { |nfield| field(nfield) }
    //Local i:= 0
    //Local y:= 0
    //Local nitem //:= 0
    Local nItem 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ITEM"})
    Local nProduto 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRODUTO"})
    Local nPosCpo
    Local nCpo
    Local nI
    //Local cCamposSUA	:= "" 
    Local cCamposSUB	:= "C6_ZDTPRG1|C6_ZQTPRG1|C6_ZDTPRG2|C6_ZQTPRG2|C6_ZDTPRG3|C6_ZQTPRG3|C6_ZDTPRG4|C6_ZQTPRG4" 

    Begin Transaction
    
        //Gravando dados da enchoice
        /*dbselectarea(cAlias1)
        Reclock(cAlias1,.F.)	 
        for i:= 1 to fcount()
            incproc()
            if "FILIAL" $ FIELDNAME(i)
                Fieldput(i,xfilial(cAlias1))
            else
                //Grava apenas os campos contidos na variavel cCamposSC5
                If ( FieldName(i) $ cCamposSC5 )
                    Fieldput(i,M->(EVAL(bcampo,i)))
                Endif
            endif
        next i		 
        Msunlock()*/
    
        //Gravando dados do grid
        dbSelectArea("SC6")
        SC6->(dbSetOrder(1))	
        For nI := 1 To Len(aCols)
            If !(aCols[nI, Len(aHeader)+1])
                If SC6->(dbSeek( xFilial("SC6")+M->C5_NUM+aCols[nI,nItem]+aCols[nI,nProduto] ))
                    RecLock("SC6",.F.)
                    For nCpo := 1 to fCount()
                        //Grava apenas os campos contidos na variavel $cCamposSC6
                        If (FieldName(nCpo)$cCamposSUB)
                            nPosCpo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(FieldName(nCpo))})
                            If nPosCpo > 0
                                FieldPut(nCpo,aCols[nI,nPosCpo])
                            EndIf
                        Endif
                    Next nCpo
                    SC6->(MsUnLock())
                Endif
            Endif
        Next nI
        
    End Transaction
Return
