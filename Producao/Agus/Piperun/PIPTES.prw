//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function PIPTES
Atualiza o cadastro de TES
@author Lucas
@since 05/08/2024
@version 1
@type function
/*/

User Function PIPTES()
	Local aArea := FWGetArea()
	Local cDirIni := GetTempPath()
	Local cTipArq := 'Arquivos com separações (*.csv) | Arquivos texto (*.txt) | Todas extensões (*.*)'
	Local cTitulo := 'Seleção de Arquivos para Processamento'
	Local lSalvar := .F.
	Local cArqSel := ''
 
	//Se não estiver sendo executado via job
	If ! IsBlind()
 
	    //Chama a função para buscar arquivos
	    cArqSel := tFileDialog(;
	        cTipArq,;  // Filtragem de tipos de arquivos que serão selecionados
	        cTitulo,;  // Título da Janela para seleção dos arquivos
	        ,;         // Compatibilidade
	        cDirIni,;  // Diretório inicial da busca de arquivos
	        lSalvar,;  // Se for .T., será uma Save Dialog, senão será Open Dialog
	        ;          // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
	    )

	    //Se tiver o arquivo selecionado e ele existir
	    If ! Empty(cArqSel) .And. File(cArqSel)
	        Processa({|| fImporta(cArqSel) }, 'Importando...')
	    EndIf
	EndIf
	
	FWRestArea(aArea)
Return
	
/*/{Protheus.doc} fImporta
Função que processa o arquivo e realiza a importação para o sistema
@author Lucas
@since 05/08/2024
@version 1
@type function

/*/

Static Function fImporta(cArqSel)
	Local cDirTmp    := GetTempPath()
	Local cArqLog    := 'importacao_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
	Local nTotLinhas := 0
	Local cLinAtu    := ''
	Local nLinhaAtu  := 0
	Local aLinha     := {}
	Local oArquivo
	Local cLog       := ''
	Local lIgnor01   := FWAlertYesNo('Deseja ignorar a linha 1 do arquivo?', 'Ignorar?')
	Local cChave     := ''
	//Variáveis da Importação
	Private cAliasImp  := 'SF4'
	Private cSeparador := ';'

	//Abre as tabelas que serão usadas
	DbSelectArea(cAliasImp)
	(cAliasImp)->(DbSetOrder(1))
	(cAliasImp)->(DbGoTop())

	//Definindo o arquivo a ser lido
	oArquivo := FWFileReader():New(cArqSel)

	//Se o arquivo pode ser aberto
	If (oArquivo:Open())

		//Se não for fim do arquivo
		If ! (oArquivo:EoF())

			//Definindo o tamanho da régua
			aLinhas := oArquivo:GetAllLines()
			nTotLinhas := Len(aLinhas)
			ProcRegua(nTotLinhas)

			//Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
			oArquivo:Close()
			oArquivo := FWFileReader():New(cArqSel)
			oArquivo:Open()

			//Caso você queira, usar controle de transação, descomente a linha abaixo (e a do End Transaction), mas tem algumas rotinas que podem ser impactadas via ExecAuto
			//Begin Transaction

				//Enquanto tiver linhas
				While (oArquivo:HasLine())

					//Incrementa na tela a mensagem
					nLinhaAtu++
					IncProc('Analisando linha ' + cValToChar(nLinhaAtu) + ' de ' + cValToChar(nTotLinhas) + '...')

					//Pegando a linha atual e transformando em array
					cLinAtu := oArquivo:GetLine()
					aLinha  := Separa(cLinAtu, cSeparador)
					cChave := FWxFilial(cAliasImp) + aLinha[2] //Coloque os campos chave aqui, para que o seek posicione corretamente

					//Se estiver configurado para pular a linha 1, e for a linha 1
					If lIgnor01 .And. nLinhaAtu == 1
						Loop

					//Se houver posições no array
					(cAliasImp)->(dbSetOrder(1))//F4_FILIAL + F4_CODIGO
					ElseIf Len(aLinha) > 0  .And. (cAliasImp)->(MsSeek(cChave)) //Confirme se a chave de pesquisa está correta
						cLog += '+ Processando a linha ' + cValToChar(nLinhaAtu) + ';' + CRLF
						RecLock(cAliasImp, .F.)
							(cAliasImp)->(F4_PIPERUN) := .T.
						(cAliasImp)->(MsUnlock())
					EndIf
				EndDo
			//End Transaction

			//Se tiver log, mostra ele
			If ! Empty(cLog)
				MemoWrite(cDirTmp + cArqLog, cLog)
				ShellExecute('OPEN', cArqLog, '', cDirTmp, 1)
			EndIf

		Else
			FWAlertError('Arquivo não tem conteúdo!', 'Atenção')
		EndIf

		//Fecha o arquivo
		oArquivo:Close()
	Else
		FWAlertError('Arquivo não pode ser aberto!', 'Atenção')
	EndIf

Return
