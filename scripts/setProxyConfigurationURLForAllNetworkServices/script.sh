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
proxyURL=""
proxyPort=""

# CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
if [ "$4" != "" ] && [ "$proxyURL" == "" ]; then
    proxyURL=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
if [ "$5" != "" ] && [ "$proxyPort" == "" ]; then
    proxyPort=$5
fi

# Detects all network hardware & creates services for all installed network hardware
/usr/sbin/networksetup -detectnewhardware

IFS=$'\n'

	#Loops through the list of network services
	for i in $(networksetup -listallnetworkservices | tail +2 );
	do
		networksetup -setwebproxy "$i" $proxyURL $proxyPort
		echo "Set proxy for $i to $proxyURL:$proxyPort"
    done
    
echo "Proxies All Present And Correct..."

unset IFS
