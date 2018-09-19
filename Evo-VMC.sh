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
	
	echo -e "
		Virtual Machine IP : $VMIP
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
		netmask 255.255.255.255
		broadcast 192.99.37.254
		gateway $VMIP
		post-up route add 192.99.37.254 dev eth0
		post-up route add default gw 192.99.37.254
		pre-down route del 192.99.37.254 dev eth0
		pre-down route del default gw 192.99.37.254
	" > /etc/network/interfaces

	echo -e "nameserver 8.8.8.8 # Google DNS Server
	nameserver 213.186.33.99 # OVH DNS Server
	" > /etc/resolv.conf

	rm /etc/apt/sources.list
	
	echo -e "# Debian Jessie, dépôt principal + paquets non libres
	deb http://deb.debian.org/debian/ jessie main contrib non-free
	# Debian Jessie, mises à jour de sécurité + paquets non libres
	deb http://security.debian.org/ jessie/updates main contrib non-free
	# Debian Jessie, mises à jour "volatiles" + paquets non libres
	deb http://deb.debian.org/debian/ jessie-updates main contrib non-free
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
}

while true; do
    read -p "Do you want to proceed to Update / Upgrade and install OpenSSH-Server ? [yes / no] : " yn
    case $yn in
        [Yy]* ) openSSH; break;;
        [Nn]* ) finish; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
