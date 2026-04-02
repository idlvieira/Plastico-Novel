#include "rwmake.ch"        

//----------------------------------------------------------------------------
//|Programa  | PNPT020     | Autor | Eliene Cerqueira    |Criado| 05.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Ponto de entrada no cadastro do SA2                           |
//----------------------------------------------------------------------------

User Function PNPT020()
 
C=" "

Return

/*
User Function M020INC()

MSGBOX("M030INC")

Return
*/
User Function MA020TOK()

   If M->A2_EST <> "EX" .AND. EMPTY(M->A2_CGC)
      MSGBOX("Preencha o CNPJ/CPF","ERRO","ALERT")
      Return .F.
   Endif

Return .T.

User Function MA020ALT()

   If M->A2_EST <> "EX" .AND. EMPTY(M->A2_CGC)
      MSGBOX("Preencha o CNPJ/CPF","ERRO","ALERT")
      Return .F.
   Endif

Return .T.

/*
User Function M030SAO()
//quando copia e clic no ok
MSGBOX("M030SAO")

Return

User Function MA030BUT()

MSGBOX("MA030BUT")

Return

User Function MA030REF()

MSGBOX("MA030REF")

Return

//User Function A415LIOK()
// Quando clica no ok    
//Precisa de parametros
//MSGBOX("A415LIOK")
//
//Return

//User Function A415TDOK()
// Quando clica no ok    
//Precisa de parametros
//MSGBOX("A415TDOK")
//
//Return

User Function MALTCLI()

MSGBOX("MALTCLI")

Return

User Function MA415BUT()
//Quando entra

MSGBOX("MA415BUT")

Return
*/