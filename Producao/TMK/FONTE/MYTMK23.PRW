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
/| Programa : MYTMK23.prw    | Autor : Leandro Ferreira      | Data : 19/04/2023 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Retorna valor net         			                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
// 10/04/2023  Leandro Ferreira          Camila Chaves   Criação do PE   

User Function MYTMK23(TIPO)

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
        nRetorn := SUB->UB_VLRITEM 
        cIPIBAS := POSICIONE("SF4",1,xFilial("SF4")+SUB->UB_TES,"F4_INCIDE")
        cQuery  := ""
        Local _aArea		:= GetArea()
        Local _ICMPAD := GETMV( "MV_ICMPAD" )
        Local _ESTICM := GETMV( "MV_ESTICM" )

        
/*
        If Substr(SUA->UA_CLIENTE,1,1)!= "P" 


		MaFisIni(	SUA->UA_CLIENTE,;// 1-Codigo Cliente/Fornecedor
		            SUA->UA_LOJA,;	// 2-Loja do Cliente/Fornecedor
		            "C",;				// 3-C:Cliente , F:Fornecedor
		            "N",;				// 4-Tipo da NF
		            SUA->UA_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
		            MaFisRelImp("MT100", {"SD2"}),;
		            Nil,;
		            Nil,;
		            Nil,;
		            "MATA461" )

	    Else

		SUS->(dbSeek(xFilial('SUS') + SUA->UA_CLIENTE + SUA->UA_LOJA))


		MaFisIni(	SUA->UA_CLIENTE,;// 1-Codigo Cliente/Fornecedor
		            SUA->UA_LOJA,;	// 2-Loja do Cliente/Fornecedor
		            "C",;				// 3-C:Cliente , F:Fornecedor
		            "N",;				// 4-Tipo da NF  
		            "F",;	        	// 5-Tipo do Cliente/Fornecedor  
		            MaFisRelImp("MTR700",{"SUA","SUB"}),;     // 6-Relacao de Impostos que suportados no arquivo
		            Nil,;   //7
		            Nil,;   //8
		            "SB1",; //9
		            "TMKA271",;   //10    
		            Nil,;        //11
		            Nil,;            //12
		            SUA->UA_CLIENTE,; //13 Codigo e Loja do Prospect
		            SUS->US_GRPTRIB,)    //14 Grupo Cliente

                    
	    Endif

        MaFisAdd(	SUB->UB_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
		            SUB->UB_TES,;	  		// 2-Codigo do TES ( Opcional )
		            SUB->UB_QUANT,;	   	// 3-Quantidade ( Obrigatorio )
		            SUB->UB_VRUNIT,;   	// 4-Preco Unitario ( Obrigatorio )
		            SUB->UB_VALDESC,;  	// 5-Valor do Desconto ( Opcional )
		            "",;	 			  	// 6-Numero da NF Original ( Devolucao/Benef )
		            "",;					// 7-Serie da NF Original ( Devolucao/Benef )
		            0,;	 					// 8-RecNo da NF Original no arq SD1/SD2
		            0,;						// 9-Valor do Frete do Item ( Opcional )
		            0,;						// 10-Valor da Despesa do item ( Opcional )
		            0,;						// 11-Valor do Seguro do item ( Opcional )
		            0,;						// 12-Valor do Frete Autonomo ( Opcional )
		            SUB->UB_VLRITEM,;	// 13-Valor da Mercadoria ( Obrigatorio )
		            0	)					// 14-Valor da Embalagem ( Opiconal )
        
        nValFRT := SUA->UA_FRETE
        IF  nValFRT > 0
                cQuery := " SELECT sum(UB_VLRITEM) 'TOTAL' FROM " +RetSQLName('SUB')+" "
                cQuery += " INNER JOIN " +RetSQLName('SUA')+" " 
                cQuery += " ON UA_FILIAL = UB_FILIAL AND UA_NUM = UB_NUM AND " +RetSQLName('SUA')+".D_E_L_E_T_ = '' "
                cQuery += " WHERE "
                cQuery += " UB_NUM = '" + SUA->UA_NUM + "' "
                cQuery += " AND UB_FILIAL = '" + SUA->UA_FILIAL + "' " 
                cQuery += " AND " +RetSQLName('SUA')+".D_E_L_E_T_ = '' "
                TCQuery cQuery New Alias "QRY_SUB"
                QRY_SUB->(DbGoTop())
                nFRTUNI := ((SUB->UB_VLRITEM/QRY_SUB->TOTAL)*nValFRT)/SUB->UB_QUANT
                QRY_UB->(DbCloseArea())
            ENDIF
            /*ICMS*/
           /* nBasICM := SUB->UB_VLRITEM + (nFRTUNI * SUB->UB_QUANT) + IIF(cIPIBAS=="S",MaFisRet(1,"IT_VALIPI"),0)
            nValICM := nBasICM * (MaFisRet(1,"IT_ALIQICM")/100)
            /*PIS*/
           /* nBasPIS := SUB->UB_VLRITEM + (nFRTUNI * SUB->UB_QUANT) - nValICM
            nValPIS := nBasPIS * (MaFisRet(1,"IT_ALIQPIS")/100)
            /*COFINS*/
           /* nBasCOF := SUB->UB_VLRITEM + (nFRTUNI * SUB->UB_QUANT) - nValICM
            nValCOF := nBasCOF * (MaFisRet(1,"IT_ALIQCOF")/100)
            
            nValUNI := SUB->UB_VRUNIT
            nQtdVEN := SUB->UB_QUANT
            nValFRT := SUA->UA_FRETE
            nRetorn := nValUNI - (nValICM/nQtdVEN) - (nValPIS/nQtdVEN) - (nValCOF/nQtdVEN)

            IF TIPO == 'F' .and. nValFRT > 0
                nRetorn := nRetorn + nFRTUNI
            ENDIF
		MaFisEnd()
        */
        RestArea( _aArea )
Return nRetorn
