#include "Protheus.ch"
#include 'Totvs.ch'

static __nTamFilEntidade   := FWTamSX3("AC8_FILENT")[1]
static __nTamEntidade      := FWTamSX3("AC8_ENTIDA")[1]
static __nTamContato       := FWTamSX3("AC8_CODCON")[1]
static __nTamCodEntidade   := FWTamSX3("AC8_CODENT")[1]

user function AC80001()
	local aArea   := FWGetArea()    as array
	local cCod    := ""             as character
	local cTipo   := ""             as character
	local lSucess := .F.            as logical
	local nIndex  := 0              as numeric
	local aFil    := {}             as array

	aFil := {'01','02','03','04','05'}

	cCod := u_AC80002()

	if !empty(cCod)
		dbSelectArea("SA1")//Cadastro de Cliente
		SA1->(dbSetOrder(01))//A1_FILIAL+A1_COD+A1_LOJA

		if SA1->(dbSeek(FwXFilial("SA1")+cCod))
			cTipo := "SA1"
		else
			cTipo := "SUS"
		endif

		for nIndex := 01 to len(aFil)
			dbSelectArea("AC8")//Relação de Contatos x Entidade
			AC8->(dbSetOrder(02))//AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
			if AC8->(dbSeek(PadR(afil[nIndex], __nTamFilEntidade)+cTipo+space(__nTamFilEntidade)+padR(cCod, __nTamCodEntidade)))
				AC8->(DbGoTop())
				//While AC8->(!EOF() .and. PadR(afil[nIndex], __nTamFilEntidade) == AC8->AC8_FILIAL .and. padR(cCod, __nTamCodEntidade) == AC8->AC8_CODENT .and. cTipo == AC8->AC8_ENTIDA)
					if empty(AC8->AC8_CODCON)
						if lSucess := AC8->(recLock("AC8", .F.))
							DbDelete()
							AC8->(msUnlock())
						endif
					endIf
					//AC8->(dbSkip())
				//endDo
			endif
		next nIndex

		if lSucess
			fwAlertSuccess("Registro atualizado.", "Sucesso!")
		endIf

	endIf
	SA2->(DBCloseArea())
	AC8->(DBCloseArea())
	FWRestArea(aArea)
return

user function AC80002()
	local oButton1  := nil      as object
	local oButton2  := nil      as object
	local oGet1     := nil      as object
	local cGet1     := space(6) as character
	local oGet2     := nil      as object
	local cGet2     := space(2) as character
	//local oSay1     := nil      as object
	local oSay2     := nil      as object
	local oSay3     := nil      as object
	local lOK       := .F.      as logical
	local cCod      := ""       as character
	static oDlg     := nil      as object

	DEFINE MSDIALOG oDlg TITLE "Atualizar vinculo Contato X Empresa / Prospect" FROM 000, 000  TO 125, 320 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME

	//@ 007, 010 SAY oSay1 PROMPT "Informe o codigo e loja" SIZE 125, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 012, 010 SAY oSay2 PROMPT "Codigo " SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 012, 085 SAY oSay3 PROMPT "Loja" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 022, 010 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 022, 085 MSGET oGet2 VAR cGet2 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040, 010 BUTTON oButton1 PROMPT "OK" SIZE 037, 010 ACTION {|| lOK := GetVld(cGet1,cGet2), oDlg:End()  }  OF oDlg PIXEL
	@ 040, 100 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 010 ACTION {|| oDlg:End() } OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if lOK
		cCod := cGet1+cGet2
	endif

return cCod

static function GetVld(cGet1,cGet2)
	local lOK := .F.  as logical

	if !empty(cGet1) .and. !empty(cGet1)
		if len(cGet1) == 6 .and. len(cGet2) == 2
			lOK := .T.
		else
			FwAlertInfo("Codigo ou loja invalidos!", "Atenção!")
		endif
	else
		FwAlertInfo("Informe Codigo e loja!", "Atenção!")
	endif

return lOK
