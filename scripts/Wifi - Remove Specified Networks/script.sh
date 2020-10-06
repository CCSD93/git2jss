#!/bin/bash

WIFIDEVICE=$( networksetup -listnetworkserviceorder | awk '/Hardware Port: Wi-Fi/ {print $5}' | sed s/\)// )

# echo $WIFIDEVICE

if [[ $4 != "" ]]; then
	REMOVERESULT=$( networksetup -removepreferredwirelessnetwork $WIFIDEVICE "$4" )
	echo $REMOVERESULT
	if [[ $REMOVERESULT != *Removed* ]]; then
		echo "$4 not in WiFi network list"
	else
		echo "Success: $4 removed from WiFi network list"
	fi

	echo $REMOVERESULT
fi

if [[ $5 != "" ]]; then
	REMOVERESULT=$( networksetup -removepreferredwirelessnetwork $WIFIDEVICE "$5" )
	echo $REMOVERESULT
	if [[ $REMOVERESULT != *Removed* ]]; then
		echo "$5 not in WiFi network list"
	else
		echo "Success: $5 removed from WiFi network list"
	fi

	echo $REMOVERESULT
fi

if [[ $6 != "" ]]; then
	REMOVERESULT=$( networksetup -removepreferredwirelessnetwork $WIFIDEVICE "$6" )
	echo $REMOVERESULT
	if [[ $REMOVERESULT != *Removed* ]]; then
		echo "$6 not in WiFi network list"
	else
		echo "Success: $6 removed from WiFi network list"
	fi

	echo $REMOVERESULT
fi