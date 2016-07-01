#!/bin/bash
# Type : Installation automatique d'une VM
# Date : 25 Juin 2016
# Author : Yan Bourgeois

clear

echo "########################################################################"
echo "########## Evolution-Network :: Virtual Machine Configuration ##########"
echo "############################ Welcome to VMC ############################"
echo -e "########################################################################
"

function ips(){
	read -p "Enter the VM IP : " VMIP
	
	read -p "Enter the Hoster IP : " HOSTIP
	
	read -p "Enter the NameServer : " NSIP
	
	read -p "Enter the NetMask IP : " MSKIP
	
	echo -e "
		Client IP : $VMIP
		Server IP : $HOSTIP
		NameServer : $NSIP
		MaskNet : $MSKIP
	"
	while true; do
	    read -p "Are you sure all information is correct ? [yes / no] : " yn
	    case $yn in
	        [Yy]* ) install; break;;
	        [Nn]* ) clear; ips; break;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
}

function install(){
	rm /etc/network/interfaces
echo "auto lo eth0
iface lo inet loopback
iface eth0 inet static
	address $VMIP
	netmask $MSKIP
	broadcast $VMIP
		post-up route add $HOSTIP dev eth0
		post-up route add default gw $HOSTIP
		pre-down route del $HOSTIP dev eth0
		pre-down route del default gw $HOSTIP
" > /etc/network/interfaces

echo -e "nameserver 8.8.8.8
nameserver $NSIP
" > /etc/resolv.conf

	rm /etc/apt/sources.list
echo -e "deb http://httpredir.debian.org/debian jessie main
deb-src http://httpredir.debian.org/debian jessie main
deb http://httpredir.debian.org/debian jessie-updates main
deb-src http://httpredir.debian.org/debian jessie-updates main
deb http://security.debian.org/ jessie/updates main
deb-src http://security.debian.org/ jessie/updates main
" > /etc/apt/sources.list
	service networking restart
}

function openSSH(){
	apt-get --assume-yes update
	apt-get --assume-yes upgrade
	apt-get --assume-yes install openssh-server
}

function finish(){
	echo -e "Thank you to using Evo-VMC"
	echo -e "You can execute the shell script for setting up firewall"
}

while true; do
    read -p "Do you want to configure Ips immediatly ? [yes / no] : " yn
    case $yn in
        [Yy]* ) ips; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you want to proceed to Update / Upgrade and install OpenSSH-Server ? [yes / no] : " yn
    case $yn in
        [Yy]* ) openSSH; break;;
        [Nn]* ) finish; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
