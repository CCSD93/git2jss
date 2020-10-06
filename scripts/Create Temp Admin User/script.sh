#!/bin/bash

#Gets the current highest user UID
maxid=$( dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1 )

#New UID for the user
newid=$((maxid+1))

serial=$( ioreg -l | awk '/IOPlatformSerialNumber/ { print substr($4,6,4);}' )
loginPassword=$serial"admin"

dscl . -create /Users/tempadmin
echo "Created new tempadmin user"
dscl . -create /Users/tempadmin UserShell /bin/bash
dscl . -create /Users/tempadmin RealName "Temporary MacBook Administrator"
dscl . -create /Users/tempadmin UniqueID "$newid"
dscl . -create /Users/tempadmin PrimaryGroupID 80
dscl . -append /Groups/admin GroupMembership tempadmin

#Set the user's password to the middle 4 characters of the serial number followed by "admin"
dscl . -passwd /Users/tempadmin "$loginPassword"
echo "Set password to: " $loginPassword

dscl . -create /Users/tempadmin NFSHomeDirectory /Users/tempadmin/

createhomedir -u tempadmin

defaults write /Library/Preferences/com.apple.loginwindow.plist HiddenUsersList -array-add tempadmin
