#!/bin/bash

WIFIDEVICE=`networksetup -listnetworkserviceorder | awk '/Hardware Port: Wi-Fi/ {print $5}' | sed s/\)//`

# echo $WIFIDEVICE

REMOVERESULT=`networksetup -removepreferredwirelessnetwork $WIFIDEVICE CCSD93`

if [[ $REMOVERESULT != *Removed* ]]; then
  echo "CCSD93 not in WiFi network list"
else
  echo "ERROR: CCSD93 removed from WiFi network list"
fi

echo $REMOVERESULT