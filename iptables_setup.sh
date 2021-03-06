#!/bin/bash
# Type : Auto-Config of Iptables !
# Date : 30 Juin 2016
# Author : Yan Bourgeois 

function DROP(){
	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT ACCEPT
	iptables -A INPUT --match state --state RELATED,ESTABLISHED -j ACCEPT
}

function Ping(){
	iptables -A INPUT --protocol icmp --match icmp --icmp-type 8 -j DROP # No Ping
}

function Port(){

	clear

	echo "########################################################################"
	echo "########### Evolution-Network :: Iptables Rules Configuration ##########"
	echo "############################ Welcome to IRC ############################"
	echo -e "########################################################################
	"
	read -p "Enter the port number to make it accessible from the outside (exemple : xx,xx) : " Ports
	read -p "Enter the IP source that can connect to ports (exemple : x.x.x.x,x.x.x.x): " Sources
	read -p "Enter the Protocol name (exemple : tcp) : " Protocol
	read -p "Enter the comment (exemple : SSH) : " Comments
	echo -e "
		Port(s): $Ports
		Source(s) : $Sources
		Protocol : $Protocol
		Comment : $Comments
	"
}

function Rules(){
	iptables -A INPUT --protocol $Protocol --source $Sources -m multiport --dports $Ports -j ACCEPT # $Comments
}

function finish(){
	apt-get --assume-yes install iptables-persistent
	invoke-rc.d iptables-persistent save
	iptables-save > /etc/iptables.rules
}

function setup_inf(){
	rm /etc/rc.local
echo -e "#!/bin/sh -e
iptables-restore < /etc/iptables.rules
exit 0
" > /etc/rc.local
}

clear

echo "########################################################################"
echo "########### Evolution-Network :: Iptables Rules Configuration ##########"
echo "############################ Welcome to IRC ############################"
echo -e "########################################################################
"

while true; do
    read -p "Have you run evo_vmc.sh before? ? [yes / no] : " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) setup_inf; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you want to close all port ? [yes / no] : " yn
    case $yn in
        [Yy]* ) DROP; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you want to block all ping request incoming ? [yes / no] : " yn
    case $yn in
        [Yy]* ) Ping; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you want to add a new rule to iptables ? [yes / no] : " yn
    case $yn in
        [Yy]* ) Port; break;;
        [Nn]* ) clear; finish; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "The information appear to be correct ? [yes / no] : " yn
    case $yn in
        [Yy]* ) Rules; echo "The rule has been added to iptables. Thank you to useing EvoNet Tools !"; exit;;
        [Nn]* ) clear; Port; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
