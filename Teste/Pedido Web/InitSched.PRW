#INCLUDE "TBICONN.CH"
/*
Programa  : InitSched
Descrição : Este programa tem o objetivo de statar o agendamento de funções. O job é 
		    iniciado e fica verificando se há algum agendamento a ser executado.
Criação	  : Renata Barreto - 31/07/02	           
Observação: Na seção [JOB] do AP6SRV.INI, deve ser feita a configuração para que essa 
			rotina seja executada, da seguinte forma:
			[ONSTART]
			jobs=Schedule609
			[Schedule609]
			Main=U_INITSCHED
			Environment=Environment       
*/

USER FUNCTION INITSCHED()                  

//Prepare Environment Empresa ‘01’ Filial ‘01’ //Tables ‘SA1’,‘SD2’

Local aParams := {"01","01"} //Coloque aqui o código da empresa e filial.
WFScheduler(aParams)                                                                                                            
QOUT('START DO JOB')

Return .T.