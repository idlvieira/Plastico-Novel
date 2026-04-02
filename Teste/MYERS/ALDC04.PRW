#Include "topconn.ch"
                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ALDC04   º Autor ³Newton Reca Alves   º Data ³  29/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Listagem dos fontes - abertura                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ADVPL-DOC                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ALDC04()


//DOCUMENTACAO
/*



NOME DOS MENUS:
	SIGACOM
	SIGAEST
	...
	COM_TOTAL
	COM_VISUAL
	EST_TOTAL
	EST_GRAVAR
	EST_MODIFICAR
	
	--> AS INICIAIS DEVEM TER O MESMO CODIGO DO FINAL DO MENU ORIGIAL. EXEMPLO: EST_XXXX == SIGAEST

--> TODOS DEVEM ESTAR NA PASTA SYSTEM




*/







/*

//Cria o arquivo de destino
_nArq			:= FCreate("C:\TEMP\MENUS.TXT",2)

_cTipoMenu		:= ""

//Busca o Id do Usuario
_cLogin	:= ""
aUsu	:= AllUsers(.T.)
For a:=1 To Len(aUsu)
	_cLogin := aUsu[a,1,1] //Login do usuario
	_cNome	:= aUsu[a,1,2] //Nome do usuario
	_cNomeC	:= aUsu[a,1,4] //Nome do usuario

	For b:=1 to Len(aUsu[a][03])
		_cMenu	:= Substr(aUsu[a][03][b],12,50)
		_cAcesso:= aUsu[a][03][b]
        
		_cBufferI	:= _cLogin+";"+_cNome+";"+_cNomeC+";"+_cMenu+";"//+Substr(_cMenu,3,2)+";"
		//FWrite(_nArq,@_cBuffer,Len(_cBuffer))
        
        //alert(aUsu[a][03][3])
		//Busca as rotinas no menu corrente
		_aItens		:= {}
		ADir(Trim(_cMenu),_aItens)
		
		_cNome_func := ""

		//ALERT(_cMenu)
		//If Substr(_cMenu,1,1)<>"S"
		If Substr(_cAcesso,3,1)<>"X" //.AND. (Trim(_cMenu)<>"\SIGACFG.XNU" .OR. Trim(_cMenu)<>"SIGACFG.XNU")
				
			For i:=1 to len(_aItens)
			
				_cDesc		:= ""
				_cCaminho	:= "\system\"
				_cArquivo	:= _cMenu
				_nHdl    	:= FOpen(_cCaminho+_cArquivo,0)
				FT_FUSE(_cCaminho+_cArquivo)
			
				//Descricao
				_lFlag	:= .T.
				FT_FGOTOP()
				Do While !FT_FEOF()
					cBuffer := FT_FREADLN()
					//alert(cBuffer)
					For j:=1 to len(cBuffer)

						//Busca o tipo de menu
						If Substr(cBuffer,j,18)=='<Title lang="pt">&'
							_nTamI	:= j+18
							For k:=_nTamI to len(cBuffer)
								If Substr(cBuffer,K,8)=='</Title>'
									_nTamF	:= K-_nTamI
									exit
								EndIf
							Next
							//_nTam	:= (_nTamF-9)-_nTamI
							_cTipoMenu	:= Substr(cBuffer,_nTamI,_nTamF)
						EndIf
						
						//Busca o Status da funcao
						If Substr(cBuffer,j,18)=='<MenuItem Status="'
							_nTamI	:= j+18
							For k:=_nTamI to len(cBuffer)
								If Substr(cBuffer,K,2)=='">'
									_nTamF	:= K-_nTamI
									exit
								EndIf
							Next
							//_nTam	:= (_nTamF-9)-_nTamI
							_cStatus_func	:= Substr(cBuffer,_nTamI,_nTamF)
						EndIf


						//Busca o Menu
						If Substr(cBuffer,j,9)=='<MenuItem'
							FT_FSKIP()
							cBuffer := FT_FREADLN()
							_nTamI	:= j+18
							For k:=_nTamI to len(cBuffer)
								If Substr(cBuffer,K,8)=='</Title>'
									_nTamF	:= K-_nTamI
									exit
								EndIf
							Next
							//_nTam	:= (_nTamF-9)-_nTamI
							_cDesc_func	:= Substr(cBuffer,_nTamI,_nTamF)
						EndIf


						//Busca o nome da funcao
						If Substr(cBuffer,j,10)=='<Function>'
							_nTamI	:= j+10
							For k:=_nTamI to len(cBuffer)
								If Substr(cBuffer,K,11)=='</Function>'
									_nTamF	:= K-_nTamI
									exit
								EndIf
							Next
							//_nTam	:= (_nTamF-9)-_nTamI
							_cNome_func	:= Substr(cBuffer,_nTamI,_nTamF)
						EndIf


						//Busca o tipo da funcao - do sistema ou customizado
						If Substr(cBuffer,j,6)=='<Type>'
							_nTamI	:= j+6
							For k:=_nTamI to len(cBuffer)
								If Substr(cBuffer,K,7)=='</Type>'
									_nTamF	:= K-_nTamI
									exit
								EndIf
							Next
							//_nTam	:= (_nTamF-9)-_nTamI
							_cTipo_func	:= Substr(cBuffer,_nTamI,_nTamF)

							
							//Prioriza Grupo
							_cGrupoPrio	:= cValToChar(aUsu[a][02][11])
							
							
							//Busca os grupos
							For c:=1 to Len(aUsu[01][01][10])
									_cGrupo	:= Substr(aUsu[a][01][10][c],1,100)

								//GRAVA NO ARQUIVO 
								_cBuffer	:= _cBufferI+_cTipoMenu+";"+_cDesc_func+";"+_cNome_func+";"+_cTipo_func+";"+_cGrupo+";"+_cGrupoPrio+";"+_cStatus_func+CHR(13)+CHR(10)
								FWrite(_nArq,@_cBuffer,Len(_cBuffer))
							Next
								
						EndIf
						

					Next
					FT_FSKIP()
					cBuffer 	:= FT_FREADLN()
				EndDo
				FT_FUSE()
			
			Next

		Else
			FT_FSKIP()
		EndIf
	
	Next

Next



FClose(_nArq)
	    
	




*/


	
///////////////por grupo





//Cria o arquivo de destino
_nArq			:= FCreate("C:\TEMP\MENUS_GRP.TXT",2)
_cTipoMenu		:= ""

//Busca o Id do Usuario
_cLogin	:= ""
aUsu	:= AllUsers(.T.)
//aGrp	:= AllGroups(.T.)
For a:=1 To Len(aUsu)
	_cLogin := aUsu[a,1,1] //Login do usuario
	_cNome	:= aUsu[a,1,2] //Nome do usuario
	_cNomeC	:= aUsu[a,1,4] //Nome do usuario

    //_cDescGrupo	:= aGrp[a,1,3]  //Descricao Grupo
    _cCargo		:= aUsu[a,1,13] //Cargo
    _cDeparta	:= aUsu[a,1,12] //Departamento
    //_cAcessosU	:= aUsu[a,2,5] //ACESSOS DO USUARIO


	//Prioriza Grupo
	_cGrupoPrio	:= cValToChar(aUsu[a][02][11])
	
	//alert(_cLogin)
	//alert(cValToChar(aUsu[a][02][11]))

	//Menus por Grupo
	If aUsu[a][02][11] == .T.
	
        //alert("entrou no grupo")
        
		For d:=1 to len(aUsu[a][01][10])
			_cGrupo		:= aUsu[a][01][10][d]
			_aMenus		:= FWGrpMenu(_cGrupo)
			_lAchou		:= .F.
			_cAcessosU	:= ""
			aGrp		:= AllGroups()
			cCodGrp		:= _cGrupo

			//Busca o codigo e nome do grupo
            For Ngr:=1 to len(aGrp)
            	//alert(_cGrupo)
            	//alert(aGrp[Ngr,1,1])
            	If Trim(_cGrupo)==Trim(aGrp[Ngr,1,1])
            		_cCod_Grupo := Trim(aGrp[Ngr,1,2])
            		_cDes_Grupo	:= aGrp[Ngr,1,3]
            		Exit
            	Endif
            Next
            
            //aGrp		:= AllGroups()
			//cCodGrp		:= _cGrupo

			//Busca os acessos de rotina
			aGAL		:= GetAccessList()
			//For Gr:=1 to Len(aGAL)
				//If rtrim(ltrim(_cGrupo)) == rtrim(ltrim(aGrp[Gr,1,1]))
					//alert(_cGrupo)
					//alert(aGrp[Gr,1,1])
					//alert(aGAL[Gr,1])
					//alert(aGAL[Gr,2])
					//alert(aGAL[Gr,3])
					//_cAcessosU	:= aGrp[Gr,1,10] //ACESSOS DO GRUPO
					_lAchou		:= .T.
				//EndIf
				//If _lAchou
				//	Exit
				//Endif
			//Next
	
			_cMODULOSIMP:= space(3)
			_cMenuSIMP	:= space(1)

			_aItens		:= {}
			For b:=1 to Len(_aMenus)
		

				//alert(_aMenus[b])
				
				//CODIGO MODULO
				If upper(Trim(Substr(_aMenus[b],12,3)))=="MDB"
					_cMODULOSIMP := Substr(_aMenus[b],26,3)
				Else
					_cMODULOSIMP := Substr(_aMenus[b],16,3) 
				EndIf
                
				//NUMERO DO MODULO
				If upper(Trim(Substr(_aMenus[b],12,3)))=="MDB"
					_cMenuSIMP := Substr(_aMenus[b],30,1)
				Else
					_cMenuSIMP := "T" //Substr(_aMenus[b],5,1)
				EndIf
				
				If upper(Trim(Substr(_aMenus[b],12,3)))=="MDB"
					_cMenu	:= Substr(_aMenus[b],26,50)
				Else
					_cMenu	:= Substr(_aMenus[b],12,50)
				Endif
				_cAcesso		:= Substr(_aMenus[b],1,100)
				_cAcessosMenu	:= ""
		        
				_cBufferI	:= _cLogin+";"+_cNome+";"+_cNomeC+";"+_cMenu+";"+_cCargo+";"+_cDeparta+";"+_cMODULOSIMP+";"+_cMenuSIMP+";"//+Substr(_cMenu,3,2)+";"
				//FWrite(_nArq,@_cBuffer,Len(_cBuffer))
		        
		        //alert(aUsu[a][03][3])
				//Busca as rotinas no menu corrente
				//_aItens		:= {}
				ADir(Trim(_cMenu),_aItens)
				
				_cNome_func := ""
		        
				//alert(_cGrupo)
				//ALERT(_cAcesso)
				//alert(_cMenu)

				//If Substr(_cMenu,1,1)<>"S"
				If Substr(_cAcesso,3,1)<>"X" //.AND. (Trim(_cMenu)<>"\SIGACFG.XNU" .OR. Trim(_cMenu)<>"SIGACFG.XNU")
						
					//alert(_aItens[1],[1])
					//For i:=1 to len(_aItens)

						//alert("entrou_2")
					                 
						_cDesc		:= ""
						If upper(Trim(Substr(_cAcesso,12,3)))=="MDB"
							_cCaminho	:= "\system\MDB_Menus\MDB\"
						Else
							_cCaminho	:= "\system\"
						EndIf
						_cArquivo	:= _cMenu
						//alert(_cCaminho+_cArquivo)
						//alert(_cBufferI)
						//alert(_cGrupo)
						
						_nHdl    	:= FOpen(_cCaminho+_cArquivo,0)
						FT_FUSE(_cCaminho+_cArquivo)
					
						//Descricao
						_lFlag	:= .T.
						FT_FGOTOP()
						Do While !FT_FEOF()
							_nTamcBuffer	:= len(cBuffer)
							cBuffer := FT_FREADLN()
							//alert(cBuffer)
							For j:=1 to len(cBuffer)
		
								//Busca o tipo de menu
								If Substr(cBuffer,j,18)=='<Title lang="pt">&'
									_nTamI	:= j+18
									For k:=_nTamI to len(cBuffer)
										If Substr(cBuffer,K,8)=='</Title>'
											_nTamF	:= K-_nTamI
											exit
										EndIf
									Next
									//_nTam	:= (_nTamF-9)-_nTamI
									_cTipoMenu	:= Substr(cBuffer,_nTamI,_nTamF)
								EndIf
								
								//Busca o Status da funcao
								If Substr(cBuffer,j,18)=='<MenuItem Status="'
									_nTamI	:= j+18
									For k:=_nTamI to len(cBuffer)
										If Substr(cBuffer,K,2)=='">'
											_nTamF	:= K-_nTamI
											exit
										EndIf
									Next
									//_nTam	:= (_nTamF-9)-_nTamI
									_cStatus_func	:= Substr(cBuffer,_nTamI,_nTamF)
								EndIf
		

								//Busca os acessos
								If Substr(cBuffer,j,8)=='<Access>'
									_nTamI	:= j+8
									For k:=_nTamI to len(cBuffer)
										If Substr(cBuffer,K,9)=='</Access>'
											_nTamF	:= K-_nTamI
											exit
										EndIf
									Next
									//_nTam	:= (_nTamF-9)-_nTamI
									_cAcessosMenu	:= Substr(cBuffer,_nTamI,_nTamF)
								EndIf

		
								//Busca o Menu
								If Substr(cBuffer,j,9)=='<MenuItem'
									FT_FSKIP()
									cBuffer := FT_FREADLN()
									_nTamI	:= j+18
									For k:=_nTamI to len(cBuffer)
										If Substr(cBuffer,K,8)=='</Title>'
											_nTamF	:= K-_nTamI
											exit
										EndIf
									Next
									//_nTam	:= (_nTamF-9)-_nTamI
									_cDesc_func	:= Substr(cBuffer,_nTamI,_nTamF)
								EndIf
		
		
								//Busca o nome da funcao
								If Substr(cBuffer,j,10)=='<Function>'
									_nTamI	:= j+10
									For k:=_nTamI to len(cBuffer)
										If Substr(cBuffer,K,11)=='</Function>'
											_nTamF	:= K-_nTamI
											exit
										EndIf
									Next
									//_nTam	:= (_nTamF-9)-_nTamI
									_cNome_func	:= Substr(cBuffer,_nTamI,_nTamF)
								EndIf
		
		
								//Busca o tipo da funcao - do sistema ou customizado
								If Substr(cBuffer,j,6)=='<Type>'
									_nTamI	:= j+6
									For k:=_nTamI to len(cBuffer)
										If Substr(cBuffer,K,7)=='</Type>'
											_nTamF	:= K-_nTamI
											exit
										EndIf
									Next
									//_nTam	:= (_nTamF-9)-_nTamI
									_cTipo_func	:= Substr(cBuffer,_nTamI,_nTamF)
		
									
									
									
									
									////Busca os grupos
									//For c:=1 to Len(aUsu[01][01][10])
									//	_cGrupo	:= Substr(aUsu[a][01][10][c],1,100)
											
		
										//GRAVA NO ARQUIVO 
										_cBuffer	:= _cBufferI+_cTipoMenu+";"+_cDesc_func+";"+_cNome_func+";"+_cTipo_func+";"+_cGrupo+";"+_cGrupoPrio+";"+_cStatus_func+";"+_cAcessosMenu+";"+_cCod_Grupo+";"+_cDes_Grupo+CHR(13)+CHR(10)
										FWrite(_nArq,@_cBuffer,Len(_cBuffer))
		
										
								EndIf
								
		
							Next
							FT_FSKIP()
							cBuffer 	:= FT_FREADLN()
						EndDo
						FT_FUSE()
					
					//Next
		
				Else
					FT_FSKIP()
				EndIf
			
			Next
		
	
		Next


	
	
	
	//Menus por usuario
	Else
	
        //alert("entrou no usuario")
        
		_cGrupo		:= ""

		For b:=1 to Len(aUsu[a][03])

			//CODIGO MODULO
			If UPPER(substr((Substr(aUsu[a][03][b],12,50)),1,4)) == "SIGA"
				_cMODULOSIMP := Substr(Substr(aUsu[a][03][b],12,50),5,3)
			Else
				_cMODULOSIMP := Substr(Substr(aUsu[a][03][b],12,50),1,3) 
			EndIf

			//NUMERO MODULO
			If UPPER(substr((Substr(aUsu[a][03][b],12,50)),1,4)) == "SIGA"
				_cMenuSIMP := "T"
			Else
				_cMenuSIMP := Substr(Substr(aUsu[a][03][b],12,50),5,1)
			EndIf
	
	        _cCod_Grupo	:= ""
    	    _cDes_Grupo	:= ""
			_cMenu		:= Substr(aUsu[a][03][b],12,50)
			_cAcesso	:= aUsu[a][03][b]
			_cAcessosMenu	:= ""
			_cAcessosU	:= aUsu[a,2,5] //ACESSOS DO USUARIO
			_cBufferI	:= _cLogin+";"+_cNome+";"+_cNomeC+";"+_cMenu+";"+_cCargo+";"+_cDeparta+";"+_cMODULOSIMP+";"+_cMenuSIMP+";"//+Substr(_cMenu,3,2)+";"
			//FWrite(_nArq,@_cBuffer,Len(_cBuffer))
	        
	        //alert(aUsu[a][03][3])
			//Busca as rotinas no menu corrente
			_aItens		:= {}
			ADir(Trim(_cMenu),_aItens)
			
			_cNome_func := ""
	
			//ALERT(_cMenu)
			//If Substr(_cMenu,1,1)<>"S"
			If Substr(_cAcesso,3,1)<>"X" //.AND. (Trim(_cMenu)<>"\SIGACFG.XNU" .OR. Trim(_cMenu)<>"SIGACFG.XNU")
					
				For i:=1 to len(_aItens)
				
					_cDesc		:= ""
					If upper(Trim(Substr(_cAcesso,12,3)))=="MDB"
						_cCaminho	:= "\system\MDB_Menus\MDB\"
					Else
						_cCaminho	:= "\system\"
					EndIf
					_cArquivo	:= _cMenu
					_nHdl    	:= FOpen(_cCaminho+_cArquivo,0)
					FT_FUSE(_cCaminho+_cArquivo)
				
					//Descricao
					_lFlag	:= .T.
					FT_FGOTOP()
					Do While !FT_FEOF()
						cBuffer := FT_FREADLN()
						//alert(cBuffer)
						_nTamcBuffer	:= len(cBuffer)
						For j:=1 to len(cBuffer)
	
							//Busca o tipo de menu
							If Substr(cBuffer,j,18)=='<Title lang="pt">&'
								_nTamI	:= j+18
								For k:=_nTamI to len(cBuffer)
									If Substr(cBuffer,K,8)=='</Title>'
										_nTamF	:= K-_nTamI
										exit
									EndIf
								Next
								//_nTam	:= (_nTamF-9)-_nTamI
								_cTipoMenu	:= Substr(cBuffer,_nTamI,_nTamF)
							EndIf
							
							//Busca o Status da funcao
							If Substr(cBuffer,j,18)=='<MenuItem Status="'
								_nTamI	:= j+18
								For k:=_nTamI to len(cBuffer)
									If Substr(cBuffer,K,2)=='">'
										_nTamF	:= K-_nTamI
										exit
									EndIf
								Next
								//_nTam	:= (_nTamF-9)-_nTamI
								_cStatus_func	:= Substr(cBuffer,_nTamI,_nTamF)
							EndIf
	

							//Busca os acessos
							If Substr(cBuffer,j,8)=='<Access>'
								_nTamI	:= j+8
								For k:=_nTamI to len(cBuffer)
									If Substr(cBuffer,K,9)=='</Access>'
										_nTamF	:= K-_nTamI
										exit
									EndIf
								Next
								//_nTam	:= (_nTamF-9)-_nTamI
								_cAcessosMenu	:= Substr(cBuffer,_nTamI,_nTamF)
							EndIf

	
							//Busca o Menu
							If Substr(cBuffer,j,9)=='<MenuItem'
								FT_FSKIP()
								cBuffer := FT_FREADLN()
								_nTamI	:= j+18
								For k:=_nTamI to len(cBuffer)
									If Substr(cBuffer,K,8)=='</Title>'
										_nTamF	:= K-_nTamI
										exit
									EndIf
								Next
								//_nTam	:= (_nTamF-9)-_nTamI
								_cDesc_func	:= Substr(cBuffer,_nTamI,_nTamF)
							EndIf
	
	
							//Busca o nome da funcao
							If Substr(cBuffer,j,10)=='<Function>'
								_nTamI	:= j+10
								For k:=_nTamI to len(cBuffer)
									If Substr(cBuffer,K,11)=='</Function>'
										_nTamF	:= K-_nTamI
										exit
									EndIf
								Next
								//_nTam	:= (_nTamF-9)-_nTamI
								_cNome_func	:= Substr(cBuffer,_nTamI,_nTamF)
							EndIf
	
	
							//Busca o tipo da funcao - do sistema ou customizado
							If Substr(cBuffer,j,6)=='<Type>'
								_nTamI	:= j+6
								For k:=_nTamI to len(cBuffer)
									If Substr(cBuffer,K,7)=='</Type>'
										_nTamF	:= K-_nTamI
										exit
									EndIf
								Next
								//_nTam	:= (_nTamF-9)-_nTamI
								_cTipo_func	:= Substr(cBuffer,_nTamI,_nTamF)
	
								
								
								
								
								////Busca os grupos
								//For c:=1 to Len(aUsu[01][01][10])
								//	_cGrupo	:= Substr(aUsu[a][01][10][c],1,100)
										
	
									
							//GRAVA NO ARQUIVO 
									_cBuffer	:= _cBufferI+_cTipoMenu+";"+_cDesc_func+";"+_cNome_func+";"+_cTipo_func+";"+_cGrupo+";"+_cGrupoPrio+";"+_cStatus_func+";"+_cAcessosMenu+";"+_cCod_Grupo+";"+_cDes_Grupo+CHR(13)+CHR(10)
									FWrite(_nArq,@_cBuffer,Len(_cBuffer))
	
									
							EndIf
							
	
						Next
						FT_FSKIP()
						cBuffer 	:= FT_FREADLN()
					EndDo
					FT_FUSE()
				
				Next
	
			Else
				FT_FSKIP()
			EndIf
		
		Next
	

	
	
	
	
	

	EndIf







Next



FClose(_nArq)
	    

	







Return()