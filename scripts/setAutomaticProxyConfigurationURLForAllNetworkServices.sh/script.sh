#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2011/09/09/how-to-change-the-automatic-proxy-configuration-url-in-system-preferences-via-a-script/
# https://macmule.com/2014/12/07/how-to-change-the-automatic-proxy-configuration-url-in-system-preferences-via-a-script/
#
# GitRepo: https://github.com/macmule/setAutomaticProxyConfigurationURL
#
# License: http://macmule.com/license/
#
####################################################################################################

# HARDCODED VALUES ARE SET HERE
autoProxyURL="off"

# CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
if [ "$4" != "" ] && [ "$autoProxyURL" == "" ]; then
    autoProxyURL=$4
fi

# Detects all network hardware & creates services for all installed network hardware
/usr/sbin/networksetup -detectnewhardware

IFS=$'\n'

#Loops through the list of network services
for i in $(networksetup -listallnetworkservices | tail +2 );
do
    # Get current setting of autoProxyURL
	autoProxyURLLocal=`/usr/sbin/networksetup -getautoproxyurl "$i" | head -1 | cut -c 6-`
	# Echo's the name of any matching services & the autoproxyURL's set
	echo "$i proxy currently set to $autoProxyURLLocal"

    if [[ $autoProxyURL = "off" ]]; then
	    # Turn off auto proxy
    	/usr/sbin/networksetup -setautoproxystate "$i" off
    	echo "$i proxy turned off"
    else
	    networksetup -setautoproxyurl $i $autoProxyURL
	    echo "$i proxy now set to $autoProxyURL"
    fi
done

echo "Proxies All Present And Correct..."

unset IFS
