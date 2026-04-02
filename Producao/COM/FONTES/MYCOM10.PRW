#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

#Define linha chr(13)+chr(10)

/*-------------------------------------------------------------------------------.\
/|                                     NOVEL                                     |\
/|-------------------------------------------------------------------------------|\
/| Programa : MYCOM10.prw    | Autor : Leandro Ferreira      | Data : 09/05/2023 |\
/|-------------------------------------------------------------------------------|\
/| Descricao: 										                             |\
/.------------------------------------------------------------------------------.*/
//                              ALTERACOES  
// Data        Colaborador      Chamado  Solicitante     Motivo
//  

User Function MYCOM10()
	Local nVlNet := M->C7_PRECO
	local nICM	 := aScan(aHeader, {|x| allTrim(x[2]) == "C7_PICM"	})
	
		If aCOls[N][nICM]>0
			nVlNet := Round(IF(aCOls[N][nICM]>0,M->C7_PRECO-(M->C7_PRECO*(aCOls[N][nICM]/100))-((M->C7_PRECO-(M->C7_PRECO*(aCOls[N][nICM]/100)))*0.0925),0),2)
		ENDIF
Return nVlNet
