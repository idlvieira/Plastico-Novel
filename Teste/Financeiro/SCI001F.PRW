#Include "RwMake.Ch"
#Include "TopConn.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSCI001F   บ Autor ณ Cleiton Campos     บ Data ณ  12/09/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo para pessoa fisica                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณArguto                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Alteracoes                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      ณ Descricao                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER FUNCTION SCI001F(nHdl,_cEol,MV_PAR01,MV_PAR02)

LOCAL _cLin		:= ""
LOCAL _cCpo		:= ""
LOCAL _cQuery	:= ""
Local _lValid   := .F.
Local _cData    := ""

ProcRegua(1)

_cQuery := "SELECT 'F' AS TPREG,"
_cQuery += "       A1_CGC AS CNPJ,"
_cQuery	+= "       '                    ' AS RG,"
_cQuery	+= "       '    ' AS EMISSOR,"
_cQuery += "       REPLACE(SA1.A1_NOME,',','') AS NOME,"
_cQuery += "       'D' AS NTZ_END,"
_cQuery += "       REPLACE(A1_END,',','') AS ENDERECO,"
_cQuery += "       LEFT(A1_MUN,30) AS CIDADE,"
_cQuery += "       A1_EST AS UF,"
_cQuery += "       A1_CEP AS CEP,"
_cQuery += "       LEFT(A1_TEL,2) AS DDD_TEL,"
_cQuery += "       SUBSTR(A1_TEL,3,10) AS TELEFONE,"
_cQuery += "       LEFT(A1_FAX,2) AS DDD_FAX,"
_cQuery += "       SUBSTR(A1_FAX,3,10) AS FAX,"
_cQuery += "       SA1.A1_EMAIL AS EMAIL,"
_cQuery += "       CONCAT(SUBSTR(A1_PRICOM,5,2),SUBSTR(A1_PRICOM,1,4)) AS DATCAD,"
_cQuery += "       REPLACE(CONCAT(SE1.E1_NUM,SE1.E1_PARCELA),',','') AS TITULO,"
_cQuery += "       CASE"
_cQuery += "          WHEN E1_TIPO   =  'NF' THEN 'N'"
_cQuery += "          WHEN E1_TIPO   =  'CH' THEN 'C'"
_cQuery += "          WHEN E1_TIPO   =  'FT' THEN 'F'"
_cQuery += "          WHEN E1_TIPO   =  'DP' THEN 'D'"
_cQuery += "          WHEN E1_NUMBOR <> ''   THEN 'B'"
_cQuery += "       END AS TIPODOC,"
_cQuery += "       'R$  ' AS MOEDA,"
_cQuery += "       SE1.E1_VALOR*100 AS VALOR,"
_cQuery += "       SE1.E1_VALLIQ*100 AS VLRPAGO,"
_cQuery += "       SE1.E1_EMISSAO AS DTVENDA,"
_cQuery += "       SE1.E1_VENCTO AS DTVECTO,"
_cQuery += "       CASE"
_cQuery += "          WHEN SE1.E1_EMISSAO = SE1.E1_VENCTO AND SE1.E1_BAIXA <> '' THEN E1_VENCTO "
_cQuery += "          ELSE SE1.E1_BAIXA "
_cQuery += "       END AS DTBAIXA"
_cQuery += "   FROM SA1010 AS SA1, SE1010 AS SE1 "
_cQuery += " WHERE ((SE1.E1_EMISSAO BETWEEN '"+ DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "') "
_cQuery += " OR    (SE1.E1_BAIXA BETWEEN '"+ DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "')) "
_cQuery += " AND   SE1.E1_FLAGFAT <> 'S' AND SE1.E1_TIPO <> 'NCC'"
_cQuery += " AND   SE1.E1_CLIENTE NOT IN ('001051','001077','001627','000031','003931','000692','000032','001227','001065')"
_cQuery += " AND   SA1.A1_COD  = SE1.E1_CLIENTE AND   SA1.A1_LOJA = SE1.E1_LOJA"
_cQuery += " AND   LENGTH(RTRIM(SA1.A1_CGC)) = 11"
_cQuery += " AND   SA1.D_E_L_E_T_ <> '*'        
_cQuery += " AND   SE1.D_E_L_E_T_ <> '*'        

TcQuery _cQuery New Alias "REGSCIF"

dbSelectArea("REGSCIF")
dbGoTop()
WHILE !EOF()
	
	_cLin		:= SPACE(353)
	
	_lValid := REGSCIF->VALOR > 0 .And.  REGSCIF->DTVECTO < DtoS(M->dDataBase)
	
	If _lValid
		// Campo 01
		_cCpo		:= PADR(REGSCIF->TPREG,01)		           	// Tipo do registro
		_cLin		:= STUFF(_cLin,01,01,_cCpo)
		
		// Campo 02
		_cCpo		:= PADR(REGSCIF->CNPJ,11)		            // CPF
		_cLin		:= STUFF(_cLin,02,12,_cCpo)
		
		// Campo 03
		_cCpo		:= PADR(SPACE(20),13)			            // RG
		_cLin		:= STUFF(_cLin,13,32,_cCpo)
		
		// Campo 04
		_cCpo		:= PADR(SPACE(04),04)		   		        // Orgao emissor
		_cLin		:= STUFF(_cLin,33,36,_cCpo)
		
		// Campo 05
		_cCpo		:= PADR(REGSCIF->NOME,55)					// Nome do consumidor
		_cLin		:= STUFF(_cLin,37,91,_cCpo)
		
		// Campo 06
		_cCpo		:= PADR(REGSCIF->NTZ_END,1)				    // Natureza do endereco
		_cLin		:= STUFF(_cLin,92,92,_cCpo)
		
		// Campo 07
		_cCpo		:= PADR(REGSCIF->ENDERECO,70) 		        // Endereco
		_cLin		:= STUFF(_cLin,93,162,_cCpo)
		
		// Campo 08
		_cCpo		:= PADR(REGSCIF->CIDADE,30)			        // Cidade
		_cLin		:= STUFF(_cLin,163,192,_cCpo)
		
		// Campo 09
		_cCpo		:= PADR(REGSCIF->UF,2)			            // UF
		_cLin		:= STUFF(_cLin,193,194,_cCpo)
		
		// Campo 10
		_cCpo		:= PADR(REGSCIF->CEP,8)			            // CEP
		_cLin		:= STUFF(_cLin,195,202,_cCpo)
		
		// Campo 11
		_cCpo		:= PADR("",4)			        // DDD do telefone
		_cLin		:= STUFF(_cLin,203,206,_cCpo)
		
		// Campo 12
		_cCpo		:= PADR("",10)			    // Numero do telefone
		_cLin		:= STUFF(_cLin,207,216,_cCpo)
		
		// Campo 13
		_cCpo		:= PADR("",4)			        // DDD do fax
		_cLin		:= STUFF(_cLin,217,220,_cCpo)
		
		// Campo 14
		_cCpo		:= PADR("",10)			        // Numero do fax
		_cLin		:= STUFF(_cLin,221,230,_cCpo)
		
		// Campo 15
		_cCpo		:= PADR("",50)			        // E-MAIL
		_cLin		:= STUFF(_cLin,231,280,_cCpo)
		
		// Campo 16
		_cCpo		:= PADR(REGSCIF->DATCAD,6)			        // Cliente desde
		_cLin		:= STUFF(_cLin,281,286,_cCpo)
		
		// Campo 17
		_cCpo		:= PADR(REGSCIF->TITULO,12)			        // Identificador da transacao
		_cLin		:= STUFF(_cLin,287,298,_cCpo)
		
		// Campo 18
		_cCpo		:= PADR(REGSCIF->TIPODOC,1)			        // Tipo de documento da transacao
        If _cCpo = " "
           _cCpo := "O"
        Endif
		_cLin		:= STUFF(_cLin,299,299,_cCpo)
		
		// Campo 19
		_cCpo		:= PADR(REGSCIF->MOEDA,4)			        // Moeda
		_cLin		:= STUFF(_cLin,300,303,_cCpo)
		
		// Campo 20 e 21
		_cCpo		:= PADR(STRZERO(REGSCIF->VALOR,13),13)	    // Valor inteiro da transacao
		_cLin		:= STUFF(_cLin,304,316,_cCpo)
		
		// Campo 22 e 23
		_cCpo		:= PADR(STRZERO(REGSCIF->VLRPAGO,13),13)	// Valor inteiro pago
		_cLin		:= STUFF(_cLin,317,329,_cCpo)
		
		// Campo 24
		_cData      := SubStr(REGSCIF->DTVENDA,7,2) + SubStr(REGSCIF->DTVENDA,5,2) + SubStr(REGSCIF->DTVENDA,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)    // Data da venda
		_cLin		:= STUFF(_cLin,330,337,_cCpo)
		
		// Campo 25
		_cData      := SubStr(REGSCIF->DTVECTO,7,2) + SubStr(REGSCIF->DTVECTO,5,2) + SubStr(REGSCIF->DTVECTO,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)	    // Data do vencimento
		_cLin		:= STUFF(_cLin,338,345,_cCpo)
		
		// Campo 26
		_cData      := SubStr(REGSCIF->DTBAIXA,7,2) + SubStr(REGSCIF->DTBAIXA,5,2) + SubStr(REGSCIF->DTBAIXA,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)	    // Data da baixa
		_cLin		:= STUFF(_cLin,346,353,_cCpo)
		
		_cLin		+= _cEol
		
		IncProc("Gravando registro! "+Alltrim(REGSCIF->TITULO))
		
		IF fWrite(nHdl,_cLin,Len(_cLin)) != LEN(_cLin)
			_cMensagem	:= "Ocorreu um erro na gravacao do arquivo. "
			HELP("",1,PROCNAME(),,_cMensagem,1,0)
		ENDIF
	EndIf
	dbSelectArea("REGSCIF")
	dbSkip()
	
ENDDO

dbCloseArea("REGSCIF")

RETURN
