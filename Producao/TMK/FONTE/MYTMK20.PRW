#Include "topconn.ch"
#Include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "AP5MAIL.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MYTMK20  ณ Autor ณMichel P. Diniz        ณ Data ณ 23/03/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Exportacao Tabela de Produtos e Custos em formato CSV	   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MP8                                                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO					   ณฑฑ
ฑฑณ              ณ        ณ      ณ                                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MYTMK20()

Private lEnd		:=.f.
Private nPosAtu 	:= 0
Private nEof		:= 0
Private cHoraI		:= time()
Private nHoraI		:= seconds()
Private cHoraF		:= space(08)
Private cTempo		:= space(08)
Private aErro		:= {}                                  
Private	nLastKey	:= 0            
Private cPerg  		:= "EXPTAB"
Private _cFile 		:= Space(40)
Private _nTot		:= 0
Private _cDelimit	:= "" 

cPerg := PADR(cPerg,10)

If !Pergunte(cPerg,.T.)
	ValidPerg()
	If !Pergunte (cPerg, .T.)
		Return
	EndIf
EndIf                                                      

If Empty(MV_PAR02) 
	MsgInfo("Arquivo para exportacao nao Informado. Processo interrompido!!")
	Return
Endif

Processa({||Importa(),,"Importando registros. Aguarde..."})

Return
                                                   

Static Function Importa()

Local _aArray		:= {} 				
Local cQuery		:= ""				
Local aArea 		:= GetArea()
//Local _cDelimit		:= ""
Local _nPrcVen		:= 0
Local _nIPI			:= 0
Local _nPrcIPI		:= 0
Local _nPrcICM		:= 0
Local _nPrcPIS		:= 0
Local _nPrcCOF		:= 0
Local _nPrcLIQ		:= 0
Local _nMargem		:= 0    
Local _nCusto		:= 0  
Local _nPISCOF		:= 0
Local _nPARPIS		:= GetMv("MV_TXPIS")
Local _nPARCOF		:= GetMv("MV_TXCOFIN")


//Abertura de Arquivos Utilizados 
dbSelectArea("SB1")   
SB1->(dbSetOrder(1))
dbSelectArea("SB2")   
SB2->(dbSetOrder(1))
dbSelectArea("SBM")   
SBM->(dbSetOrder(1))

// Selecao de Delimitadores
If MV_PAR04 == 1 
	_cDelimit := ';'
ElseIf MV_PAR04 == 1 
	_cDelimit := ','
Else
	_cDelimit := '|'
Endif	
/* 	QUERY RELACIONANDO SB2	
cQuery := "SELECT DA0.DA0_CODTAB,DA1.DA1_CODTAB,DA1.DA1_CODPRO,DA1.DA1_PRCVEN,DA1.DA1_ESTADO, SB1.B1_COD,  "
cQuery += "SB1.B1_DESC,SB1.B1_GRUPO,SB2.B2_CM1,SB2.B2_LOCAL,SB1.B1_PICM,SB1.B1_IPI,SB1.B1_DESC,SB1.B1_UM,SB1.B1_PPIS,SB1.B1_PCOFINS "
cQuery += "FROM "  + RETSQLNAME("DA0") + " DA0, "  + RETSQLNAME("DA1") + " DA1, "+ RETSQLNAME("SB1") + "  SB1,  " + RETSQLNAME("SB2") + "  SB2  "
cQuery += "WHERE "
cQuery += "DA0.DA0_FILIAL = '" + XFILIAL("DA0") + "' AND DA1.DA1_FILIAL = '" + XFILIAL("DA1") + "'  AND "
cQuery += "SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND SB2.B2_FILIAL = '" + XFILIAL("SB2") + "'  AND "
cQuery += "DA0.D_E_L_E_T_ = ' ' AND DA1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SB2.D_E_L_E_T_ = ' ' AND "
cQuery += "DA0.DA0_CODTAB = DA1.DA1_CODTAB AND "
cQuery += "DA1_CODPRO = SB1.B1_COD AND "
cQuery += "SB1.B1_COD = SB2.B2_COD AND "            
cQuery += "DA0.DA0_CODTAB 	= '" + MV_PAR01 + "'  "
cQuery += "ORDER BY SB1.B1_DESC "
*/

/* 	QUERY SEM RELACIONAMENTO SB2	*/
cQuery := "SELECT DA0.DA0_CODTAB,DA1.DA1_CODTAB,DA1.DA1_CODPRO,DA1.DA1_PRCVEN,DA1.DA1_ESTADO, SB1.B1_COD,  "
cQuery += "SB1.B1_DESC,SB1.B1_GRUPO,SB1.B1_PICM,SB1.B1_IPI,SB1.B1_DESC,SB1.B1_LOCPAD,SB1.B1_UM,SB1.B1_PPIS,SB1.B1_PCOFINS "
cQuery += "FROM "  + RETSQLNAME("DA0") + " DA0, "  + RETSQLNAME("DA1") + " DA1, "+ RETSQLNAME("SB1") + "  SB1 "
cQuery += "WHERE "
cQuery += "DA0.DA0_FILIAL = '" + XFILIAL("DA0") + "' AND DA1.DA1_FILIAL = '" + XFILIAL("DA1") + "'  AND "
cQuery += "SB1.B1_FILIAL = '" + XFILIAL("SB1") + "'   AND "
cQuery += "DA0.D_E_L_E_T_ = ' ' AND DA1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "DA0.DA0_CODTAB = DA1.DA1_CODTAB AND "
cQuery += "DA1_CODPRO = SB1.B1_COD AND "
cQuery += "DA0.DA0_CODTAB 	= '" + MV_PAR01 + "'  "
cQuery += "ORDER BY SB1.B1_DESC "



TcQuery cQuery New Alias "TDA0"

Count to _nCount
TDA0->(dbGoTop())
ProcRegua(_nCount)

While TDA0->(!Eof())

    IncProc("Selecionando Registros. Aguarde!")		
    
	dbSelectArea("SB2")
	If SB2->(dbSeek(xFilial("SB2")+TDA0->B1_COD+TDA0->B1_LOCPAD,.f.))
		_nCusto	:= Round(SB2->B2_CM1,4)
	Else
		_nCusto	:= 0.0000
	Endif

	_nPrcIPI		:= TDA0->DA1_PRCVEN * ( (TDA0->B1_IPI / 100) + 1)
	_nPrcICM		:= _nPrcIPI *  (Iif(TDA0->B1_PICM > 0, TDA0->B1_PICM/100,18/100) )
	//_nPrcPIS		:= TDA0->DA1_PRCVEN *  (TDA0->B1_PPIS / 100) 
	//_nPrcCOF		:= TDA0->DA1_PRCVEN *  (TDA0->B1_PCOFINS / 100)
	_nPISCOF		:= TDA0->DA1_PRCVEN * ( (_nPARPIS+_nPARCOF)/100)
	_nPrcLIQ		:= TDA0->DA1_PRCVEN - (_nPrcICM + _nPISCOF )
	_nMargem		:= ( ( _nPrcLIQ - _nCusto ) / _nPrcLIQ ) * 100
	
	
    /*  Modificado em 13/09/07 conf. solicitacao Rafael Destro da Bandag - Por Michel
    AaDD( _aArray, {Alltrim(TDA0->B1_COD)+_cDelimit, Alltrim(TDA0->B1_GRUPO)+_cDelimit, Substr(TDA0->B1_DESC,1,30)+_cDelimit,;
    				Alltrim(TDA0->B1_UM)+_cDelimit,Transform(TDA0->DA1_PRCVEN,"@E 9,999,999.99")+_cDelimit,;
    				Transform(TDA0->B1_IPI,"@E 9,999,999.99")+_cDelimit, Transform(_nPrcIPI,"@E 9,999,999.99")+_cDelimit,;
    				Transform(_nPrcICM,"@E 9,999,999.99")+_cDelimit,Transform(_nPISCOF,"@E 9,999,999.99")+_cDelimit,;
    				Transform(_nPrcLIQ,"@E 9,999,999.99")+_cDelimit,;
    				Transform(_nCusto,"@E 9,999,999.9999")+_cDelimit,Transform(_nMargem,"@E 9,999,999.99")+_cDelimit})
    */

    AaDD( _aArray, {Alltrim(TDA0->B1_COD)+_cDelimit, Alltrim(TDA0->B1_GRUPO)+_cDelimit, Substr(TDA0->B1_DESC,1,30)+_cDelimit,;
    				Alltrim(TDA0->B1_UM)+_cDelimit,Alltrim(Str(TDA0->DA1_PRCVEN))+_cDelimit,;
    				Alltrim(Str(TDA0->B1_IPI))+_cDelimit, Alltrim(Str(_nPrcIPI))+_cDelimit,;
    				Alltrim(Str(_nPrcICM))+_cDelimit,Alltrim(Str(_nPISCOF,))+_cDelimit,;
    				Alltrim(Str(_nPrcLIQ))+_cDelimit,;
    				Alltrim(Str(_nCusto))+_cDelimit,Alltrim(Str(_nMargem))+_cDelimit})
    
    TDA0->(dbSkip())
    
Enddo
           
TDA0->(dbCloseArea())

If Len(_aArray) > 0
	// Geracao de Arquivo Texto
	Processa({|| SCALOG(_aArray),"Aguarde, Gerando Arquivo ..." })
Endif


Return(.t.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSCALOG    บ Autor ณ Michel P. Diniz    บ Data ณ  23/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGeracao de arquivo .TXT									  บฑฑ
ฑฑบ          ณ													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8	                                                      บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ 
ฑฑณ           ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL            ณฑฑ 
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ 
ฑฑณ Programador    ณ  Data  ณ Motivo da Alteracao                         ณฑฑ 
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ 
ฑฑณ				   ณ        ณ  									          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function SCALOG(_aProc)
Local cNomeArq	:= Alltrim(MV_PAR02)
Local _nTamV1	:= 0
nHanErr			:= 0        

If Len(_aProc) >0 
    ProcRegua(Len(_aProc))
	cTexto := ""
	//GeraTexto( cTexto , cNomeArq )		

	cTexto := 	"Codigo"+_cDelimit+"Linha"+_cDelimit+"Descricao"+_cDelimit+"UM"+_cDelimit+"Preco R$"+_cDelimit+;
				"% IPI"+_cDelimit+"Preco c/ IPI"+_cDelimit+"ICMS"+_cDelimit+"PIS/COFINS"+_cDelimit+;
				"Preco Liquido"+_cDelimit+"Custo"+_cDelimit+"% Margem"

	GeraTexto( cTexto , cNomeArq )	

	//cTexto := ""
	//GeraTexto( cTexto , cNomeArq )	

	For nc:= 1 to Len(_aProc)
		
	    IncProc("Gerando arquivo. Aguarde!")

		cTexto := ""
		For n2 := 1 to 12
		
			cTexto 	+= Alltrim(_aProc[nc,n2])
	    
	    Next n2
	    
		GeraTexto( cTexto , cNomeArq )
		
	Next nc

Endif

If 	nHanErr > 0
	fClose(nHanErr)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraTexto บ Autor ณ Michel P. Diniz    บ Data ณ  23/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGeracao de arquivo .TXT 									  บฑฑ
ฑฑบ          ณ													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8	                                                      บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ 
ฑฑณ           ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL            ณฑฑ 
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ 
ฑฑณ Programador    ณ  Data  ณ Motivo da Alteracao                         ณฑฑ 
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ 
ฑฑณ				   ณ        ณ  									          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function GeraTexto(cTxt,cNum)
Local cDirFil 	:= 	Alltrim(MV_PAR03) + cNum + ".CSV"

if 	nHanErr	==	0
	nHanErr	:=	fCreate(cDirFil)
	if 	nHanErr	<=	0
		Alert("Nao foi possivel gerar o arquivo " + cDirFil + " ! Verifique....")
	endif
endif

If 	nHanErr	>	0
	fWrite( nHanErr , cTxt + Chr(13) + Chr(10) , Len(cTxt) + 2 )
endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ  Michel P. Diniz   บ Data ณ  22/03/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Tabela de Precos	","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DA0","","","",""})
aAdd(aRegs,{cPerg,"02","Nome do Arquivo		","","","mv_ch2","C",30,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Local para gravacao	","","","mv_ch3","C",30,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Delimitador			","","","mv_ch4","N",01,0,0,"C","","mv_par04",";",";",";","","",",",",",",","","","|","|","|","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return Nil   