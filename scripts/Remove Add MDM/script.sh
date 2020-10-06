#!/bin/sh

# Set the WIFIDEVICE variable to the wireless
# network port you want to use. 

WIFIDEVICE=`networksetup -listnetworkserviceorder | awk '/Hardware Port: Wi-Fi/ {print $5}' | sed s/\)//`

# Set the SSID variable to your wireless network name
# to set the network name you want to connect to.
# Note: Wireless network name cannot contain spaces.
SSID=CCSD93-WPA

# If you've set the SECURITY variable to something other than NONE,
# set the password here. For example, if you are using WPA
# encryption with a password of "thedrisin", set the PASSWORD
# variable to "thedrisin" (no quotes.)
PASSWORD=eDOG0Zo5FerEkvlg8QPCyq7Z7RhUIVaABsG5woV31jLJbJcVbIt5Y8McSSp1DS7

# --------------------------

echo "Removing JAMF MDM Profile"
jamf removeMDMProfile
if [ $? -eq 0 ]; then
    echo OK
else
    echo FAIL
fi

echo "Directly connecting to the CCSD93-WPA Network"
networksetup -setairportnetwork $WIFIDEVICE $SSID $PASSWORD
if [ $? -eq 0 ]; then
    echo OK
else
    echo FAIL
fi

INTERNET_STATUS="UNKNOWN"
until [ $INTERNET_STATUS == "UP" ]
do
	ping -c 1 -W 0.5 jss-01.ccsd93.com > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
        echo "Network connection: Established";
        INTERNET_STATUS="UP"
    else
        echo "Network connection: Down";
        INTERNET_STATUS="DOWN"
    fi
    sleep 1
done;

echo "Adding JAMF MDM Profile"
jamf mdm
if [ $? -eq 0 ]; then
    echo OK
else
    echo FAIL
fi