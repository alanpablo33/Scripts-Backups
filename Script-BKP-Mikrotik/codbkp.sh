#!/bin/bash

########################################
##        Script para Backups         ##
##      de Equipamentos mikrotik      ##
##                                    ##
##                                    ##
########################################

#Local onde a Lista de IPs dos equipamentos vai ficar.
export arquivo="/var/PASTA_A_SEU_CRITERIO/backups/Mikrotik/listaipsmkt.txt" 

#Criação da pasta e Local onde a Pasta de destino dos Componentes vai ficar.
mkdir /var/PASTA_A_SEU_CRITERIO/backups/Mikrotik/rb/`date +%d-%m-%Y`

#Local onde os Backups feitos vão ficar.
export destino="/var/PASTA_A_SEU_CRITERIO/backups/Mikrotik/rb/`date +%d-%m-%Y`"

#Log da hora que o backup inicia

export INICIO=`date +%d-%m-%Y_%H:%M:%S`
echo -e "#####***************Backup iniciado as $INICIO***************#####" >> /var/PASTA_A_SEU_CRITERIO/backups/Mikrotik/logs/mikrotik.log

#Backup com base na lista de ips

for RADIO in `cat $arquivo`; do
nome=`echo $RADIO | cut -d',' -f 1`
ip=`echo $RADIO | cut -d',' -f 2`

#Comando a Ser Executado

sshpass -p 'SENHADOS EQUIPAMENTOS' ssh -p PORTA SSH DOS EQUIPAMENTOS LOGUIN_DOS_EQUIPAMENTOS@$ip -o StrictHostKeyChecking=no 'export' > $destino/$ip-backup-.rsc 2> /dev/null && export FIM=`date +%d-%m-%Y_%H:%M:%S`&& echo -e "O backup de $nome-$ip foi efetuado com sucesso em $FIM" >> /var/PASTA_A_SEU_CRITERIO/backups/Mikrotik/logs/mikrotik.log || echo -e "Ocorreu um erro ao realizar o backup de $nome-$ip as `date +%d-%m-%Y_%H:%M:%S`" >> /var/PASTA_A_SEU_CRITERIO/backups/Mikrotik/logs/mikrotik.lop
done


#Deleta os arquivos que estao com 0k - Backups que foram gerados com erro
find $destino -size 0k | xargs rm -fr *.rsc

#Deletar os arquivos criados a mais de 7 dias
find $destino -ctime +7 -exec rm -r {} \;
