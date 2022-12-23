#!/bin/bash

#Colores
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m'

#Variables
nmap=$(which nmap)
dir=""
dirmk=""
segmentoentrada=""
echo
########################################## EJEMPLO DE USO ##########################################
if [ "$1" == "" ]; then
	echo 
	echo "Example: `basename $0` 192.168.0.0/24" && echo ""
	exit 0
fi

########################################## INTERRUPCION DEL SCRIPT ######################################
function ctrl_c(){
	echo
	echo -e "${YELLOW}[-] $(tput setaf 7)Saliendo del script madafaker >:c"
	sleep 1
	exit 1
} 

trap ctrl_c INT		#LLAMADA A LA FUNCION DEL INTERRUPCION


########################################## INICIO DEL SCRIPT ######################################

segmentoentrada=$1
segmento=$(echo $segmentoentrada |grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.')



echo -e "${GREEN}[*] Barrido ICMP en el segmento $segmentoentrada"

for ips in {1..254}
	do timeout 2  ping -c 1 $segmento$ips >/dev/null&& echo -e "${BLUE}[+] $(tput setaf 7) Se tuvo respuesta de la IP $segmento$ips" && echo $segmento$ips >> icmp_ips
	echo $segmento$ips 
	sleep 2


done

echo -e "${GREEN}[*] Iniciando scaneo SMB en $segmentoentrada"
crackmapexec -t 1 smb $segmentoentrada >> smb_ips


cat icmp_ips smb_ips | grep -a -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'  | sort -u >> ips_encontradas


