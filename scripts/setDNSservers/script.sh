#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2011/09/09/how-to-change-the-automatic-proxy-configuration-url-in-system-preferences-via-a-script/
#
# GitRepo: https://github.com/macmule/setAutomaticProxyConfigurationURL
#
# License: http://macmule.com/license/
#
####################################################################################################

# HARDCODED VALUES ARE SET HERE
DNSservers=""
DNSserver4=""
DNSserver5=""
DNSserver6=""
DNSserver7=""
DNSserver8=""

# CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
if [[ "$4" != "" ]];  then
	DNSserver4=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED FOR $5, AND IF SO, ASSIGN IT
if [[ "$5" != "" ]];  then
        DNSserver5=$5
fi      

# CHECK TO SEE IF A VALUE WAS PASSED FOR $6, AND IF SO, ASSIGN IT
if [[ "$6" != "" ]];  then
        DNSserver6=$6
fi      

# CHECK TO SEE IF A VALUE WAS PASSED FOR $7, AND IF SO, ASSIGN IT
if [[ "$7" != "" ]];  then
        DNSserver7=$7
fi      

# CHECK TO SEE IF A VALUE WAS PASSED FOR $8, AND IF SO, ASSIGN IT
if [[ "$8" != "" ]];  then
        DNSserver8=$8
fi 

DNSservers="$DNSserver4 $DNSserver5 $DNSserver6 $DNSserver7 $DNSserver8"
echo $DNSservers

# Detects all network hardware & creates services for all installed network hardware
/usr/sbin/networksetup -detectnewhardware

IFS=$'\n'

	#Loops through the list of network services
	for i in $(networksetup -listallnetworkservices | tail +2 );
	do
	
		# Get a list of all services
		DNSLocal=`/usr/sbin/networksetup -getdnsservers "$i"`
		
		# Echo's the name of any matching services & the autoproxyURL's set
		echo " ------ $i DNS currently set to $DNSLocal ------ "
	
		# If the value returned of $autoProxyURLLocal does not match the value of $autoProxyURL for the interface $i, change it.

		networksetup -setdnsservers "$i" $DNSserver4 $DNSserver5 $DNSserver6 $DNSserver7 $DNSserver8
		echo " ------ Set DNS for $i to $DNSservers ------ "

	done

echo " ------ DNS Servers All Present And Correct... ------ "

unset IFS