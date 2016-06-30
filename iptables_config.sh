#!/bin/bash
# Type : Installation automatique d'une VM
# Date : 30 Juin 2016
# Author : Yan Bourgeois

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
	-A INPUT --protocol $Protocol --source $Sources --match tcp --destination-port $Ports -j ACCEPT # $Comments
}

clear

echo "########################################################################"
echo "########### Evolution-Network :: Iptables Rules Configuration ##########"
echo "############################ Welcome to IRC ############################"
echo -e "########################################################################
"

while true; do
    read -p "Do you want to add a new rule to iptables ? [yes / no] : " yn
    case $yn in
        [Yy]* ) Port; break;;
        [Nn]* ) clear; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "The information appear to be correct ? [yes / no] : " yn
    case $yn in
        [Yy]* ) echo "The rule has been added to iptables. Thank you to useing EvoNet Tools !"; break;;
        [Nn]* ) clear; Port; break;;
        * ) echo "Please answer yes or no.";;
    esac
done