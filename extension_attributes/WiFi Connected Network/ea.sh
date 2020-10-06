#!/bin/bash

WirelessPort=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')

ConnectedNetwork=$( /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | awk -F: '/ SSID:/ {print $2}' | sed -e 's/.*SSID: //' )

echo "<result>$ConnectedNetwork</result>"

exit 0