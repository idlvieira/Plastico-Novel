#INCLUDE "protheus.ch"

User Function MYCTB07()

/*
Myctb07.prw
26/07/2018
* Programa para alterar as contas contabeis da folha (SRV)
*/

Local aArea := Getarea()

Private cDelFunc  := .T.
Private cCadastro := "Ajuste Verbas - CTB x SRV"
Private aRotina := 	{{ "Visualizar" ,"axVisual", 0 , 2},;                  //"Visualizar"
                         { "Alterar"    ,"u_Altera(SRV->(RECNO()))", 0 , 4 }}  //"Alterar

mBrowse(6,1,22,75,"SRV",,,,,,)

Restarea(aArea)

Return(.T.)


User Function Altera(nreg)
/*
Funcao que altera apenas os campos definidos no array aCpos
*/

//Campos que permite edição
Private aCpos   := {"RV_FILIAL","RV_LCTOP","RV_ZZATIVD","RV_ZZATIVC","RV_ZZPASSD","RV_ZZPASSC","RV_ZZADMD","RV_ZZADMC","RV_ZZCMLD","RV_ZZCMLC","RV_ZZCDIRD","RV_ZZCDIRC","RV_ZZCINDD","RV_ZZCINDC"}
//Campos que serao exibidos
Private aVCpos  := {"RV_FILIAL","RV_LCTOP","RV_ZZATIVD","RV_ZZATIVC","RV_ZZPASSD","RV_ZZPASSC","RV_ZZADMD","RV_ZZADMC","RV_ZZCMLD","RV_ZZCMLC","RV_ZZCDIRD","RV_ZZCDIRC","RV_ZZCINDD","RV_ZZCINDC"}

AxAltera("SRV",nreg,2,aVCpos,aCpos)

Return .T.
