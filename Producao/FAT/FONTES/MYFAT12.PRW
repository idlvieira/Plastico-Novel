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
/| Programa : MYFAT12.prw    | Autor : Leandro Ferreira      | Data : 10/04/2023 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Retorna valor net         			                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 10/04/2023  Leandro Ferreira          Camila Chaves   Criação do PE   

User Function MYFAT12(TIPO)

        nValUNI := 0
        nQtdVEN := 0
        nValICM := 0
        nBasICM := 0
        nValPIS := 0
        nBasPIS := 0
        nValCOF := 0
        nBasCOF := 0
        nValFRT := 0
        nFRTUNI := 0
        nRetorn := 0
        cIPIBAS := POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_INCIDE")
        cQuery  := ""

		MaFisEnd()	
		
    MaFisIni(SC5->C5_CLIENTE,;                   // 01 - Codigo Cliente/Fornecedor
            SC5->C5_LOJACLI,;                        // 02 - Loja do Cliente/Fornecedor
            Iif(SC5->C5_TIPO $ "D;B", "F", "C"),;    // 03 - C:Cliente , F:Fornecedor
            SC5->C5_TIPO,;                           // 04 - Tipo da NF
            SC5->C5_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
            MaFisRelImp("MT100", {"SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
            NIL,;                                       // 07 - Tipo de complemento
            NIL,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
            NIL,;//"SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
            "MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao
            
			MaFisAdd(	SC6->C6_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
						SC6->C6_TES,;	  	 	// 2-Codigo do TES ( Opcional )
						SC6->C6_QTDVEN,;	   	// 3-Quantidade ( Obrigatorio )
						SC6->C6_PRCVEN,;   		// 4-Preco Unitario ( Obrigatorio )
						SC6->C6_VALDESC,;  		// 5-Valor do Desconto ( Opcional )
						SC6->C6_NFORI,;	   		// 6-Numero da NF Original ( Devolucao/Benef )
						SC6->C6_SERIORI,;		// 7-Serie da NF Original ( Devolucao/Benef )
						0,;	 					// 8-RecNo da NF Original no arq SD1/SD2
						0,;						// 9-Valor do Frete do Item ( Opcional )
						0,;						// 10-Valor da Despesa do item ( Opcional )
						0,;						// 11-Valor do Seguro do item ( Opcional )
						0,;						// 12-Valor do Frete Autonomo ( Opcional )
						SC6->C6_VALOR,;			// 13-Valor da Mercadoria ( Obrigatorio )
						0	)					// 14-Valor da Embalagem ( Opiconal )
            
            nValFRT := SC5->C5_FRETE
            IF  nValFRT > 0
                cQuery := " SELECT sum(C6_VALOR) 'TOTAL' FROM " +RetSQLName('SC6')+" "
                cQuery += " INNER JOIN " +RetSQLName('SC5')+" " 
                cQuery += " ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND " +RetSQLName('SC5')+".D_E_L_E_T_ = '' "
                cQuery += " WHERE "
                cQuery += " C6_NUM = '" + SC5->C5_NUM + "' "
                cQuery += " AND C6_FILIAL = '" + SC5->C5_FILIAL + "' " 
                cQuery += " AND " +RetSQLName('SC5')+".D_E_L_E_T_ = '' "
                TCQuery cQuery New Alias "QRY_SC6"
                QRY_SC6->(DbGoTop())
                nFRTUNI := ((SC6->C6_VALOR/QRY_SC6->TOTAL)*nValFRT)/SC6->C6_QTDVEN
                QRY_SC6->(DbCloseArea())
            ENDIF
            /*ICMS*/
            nBasICM := SC6->C6_VALOR + (nFRTUNI * SC6->C6_QTDVEN) + IIF(cIPIBAS=="S",MaFisRet(1,"IT_VALIPI"),0)
            nValICM := nBasICM * (MaFisRet(1,"IT_ALIQICM")/100)
            /*PIS*/
            nBasPIS := SC6->C6_VALOR + (nFRTUNI * SC6->C6_QTDVEN) - nValICM
            nValPIS := nBasPIS * (MaFisRet(1,"IT_ALIQPIS")/100)
            /*COFINS*/
            nBasCOF := SC6->C6_VALOR + (nFRTUNI * SC6->C6_QTDVEN) - nValICM
            nValCOF := nBasCOF * (MaFisRet(1,"IT_ALIQCOF")/100)
            
            nValUNI := SC6->C6_PRCVEN
            nQtdVEN := SC6->C6_QTDVEN
            nValFRT := SC5->C5_FRETE
            nRetorn := nValUNI - (nValICM/nQtdVEN) - (nValPIS/nQtdVEN) - (nValCOF/nQtdVEN)

            IF TIPO == 'F' .and. nValFRT > 0
                nRetorn := nRetorn + nFRTUNI
            ENDIF
		MaFisEnd()

Return nRetorn
