#!/bin/sh

# Enable the wireless method you need and
# add the correct variables as needed. The
# wireless network name should not contain spaces.

# Set the WIRELESS variable to the wireless
# network port you want to use. (leave it as
# "AirPort" if you do not know what port to use.)

WIRELESS=AirPort

# Set the SSID variable to your wireless network name
# to set the network name you want to connect to.
# Note: Wireless network name cannot contain spaces.
SSID=CCSD93-WPA

# Set the INDEX variable to the index number you’d like
# it to be assigned to (leave it as "0" if you do not know
# what index number to use.)
INDEX=0

# Set the SECURITY variable to the security type of the
# wireless network (NONE, WEP, WPA, WPA2, WPAE or
# WPA2E) Setting it to NONE means that it's an open
# network with no encryption.
SECURITY=WPA2

# If you've set the SECURITY variable to something other than NONE,
# set the password here. For example, if you are using WPA
# encryption with a password of "thedrisin", set the PASSWORD
# variable to "thedrisin" (no quotes.)
PASSWORD=Uec#ymgz&cSy^T3xsvv$Xn^cJX2EDSA2QF7jeY$#B9DS%n5t5r^Hj38@hhSEv5R

sudo networksetup -addpreferredwirelessnetworkatindex $WIRELESS $SSID $INDEX $SECURITY $PASSWORD
