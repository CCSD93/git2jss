#!/bin/bash

WIFIDEVICE=`networksetup -listnetworkserviceorder | awk '/Hardware Port: Wi-Fi/ {print $5}' | sed s/\)//`

# echo $WIFIDEVICE

REMOVERESULT=`networksetup -removepreferredwirelessnetwork $WIFIDEVICE xfinitywifi`

if [[ $REMOVERESULT != *Removed* ]]; then
  echo "xfinitywifi not in WiFi network list"
else
  echo "ERROR: xfinitywifi removed from WiFi network list"
fi

echo $REMOVERESULT