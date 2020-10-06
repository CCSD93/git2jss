#!/bin/bash
# This script creates the two files needed for the final phase of the Student Purchase Cleanup.
# When editing the studentpurchase.sh section below remember to escape any \$ or \` with the \
# otherwise it won't get saved to the drive properly

# This creates the LaunchDaemon plist that runs the cleanup script at the next boot

cat << EOF > /Library/LaunchDaemons/com.ccsd93.studentpurchase.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.ccsd93.studentpurchase</string>
     <key>Comment</key>
     <string>Must user ProgramArguments and not Program key because it is running a script</string> 
  <key>ProgramArguments</key>
  <array>
    <string>/Library/Scripts/studentpurchase.sh</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>LaunchOnlyOnce</key>
  <true/>
</dict>
</plist>
EOF

# This creates the actual script that will run at boot

cat << EOF > /Library/Scripts/studentpurchase.sh
#!/bin/bash
sleep 5

# Delay the login window by unloading the com.apple.loginwindow LaunchDaemon in /System/Library/LaunchDaemons/
launchctl unload /System/Library/LaunchDaemons/com.apple.loginwindow.plist

#Runn caffeinate to keep the MacBook awake
/usr/bin/caffeinate -u -t 3600 &

if [ \$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '\$2 >= 501 { print \$1; }' | grep -e "ccsd93admin" ) ]; then
	#If the ccsd93admin account still exists, then delete it.
    dscl . delete /Users/ccsd93admin
    rm -Rf /Users/ccsd93admin
fi

softwareupdate --reset-ignored

## Promote Mobile Standard users to Local Admin
## Get list of users to convert
userList=\$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '\$2 >= 501 { print \$1; }' )

for loggedInUser in \$userList; do
    #Get UID
    UserUID=\$( dscl . read /Users/\$loggedInUser UniqueID | grep UniqueID: | cut -c 11- )

    #Gets the real name of the user
    userRealName=\$( dscl . -read /Users/\$loggedInUser | grep RealName: | cut -c11- )
    if [[ -z \$userRealName ]]; then
        userRealName=\$( dscl . -read /Users/\$loggedInUser | awk '/^RealName:/,/^RecordName:/' | sed -n 2p | cut -c 2- )
    fi

    #This will delete the user
    dscl . delete /Users/\$loggedInUser
    sleep 5

    #Gets the current highest user UID between 500 and 1000
    lastID=1
    #Read all UniqueID into an array userids
    IFS=\$'\n' read -r -d '' -a userids < <( dscl . -list /Users UniqueID | awk '{print \$2}' | sort -ug )
	#Set maxid to the last UniqueID in the list
	maxid=\${userids[@]: -\$lastID:1}
    #Mobile users have very large UniqueID, so skip if the UniqueID is larger than 1000, and go to the next UniqueID
	until [ \$maxid -lt 1000 ]; do
	    ((lastID++))
		maxid=\${userids[@]: -\$lastID:1}
	done
    #Set the New UID for the user to be one higher that the maxid found
    newid=\$((maxid+1))
    #If there are no "regular" users, set the newid to 501 whoch should be the first "regular" user
    if [[ \$newid -lt 501 ]]; then
        newid=501
    fi

    #Creating the new user
    dscl . -create /Users/\$loggedInUser
    dscl . -create /Users/\$loggedInUser UserShell /bin/bash
    dscl . -create /Users/\$loggedInUser RealName "\$userRealName"
    dscl . -create /Users/\$loggedInUser UniqueID "\$newid"
    dscl . -create /Users/\$loggedInUser PrimaryGroupID 80
    dscl . -create /Users/\$loggedInUser NFSHomeDirectory /Users/"\$loggedInUser"
    
    # Set the user password to "password"
    dscl . -passwd /Users/\$loggedInUser "password"
    dscl . -create /Users/\$loggedInUser hint "The password changed to password"

    #Makes the user an admin
    dscl . -append /Groups/admin GroupMembership "\$loggedInUser"

    #Reset ownership on home directory and append location
    chown -R \$loggedInUser:staff /Users/"\$loggedInUser"

    #Delete the user's keychain folder.
    rm -Rf /Users/\$loggedInUser/Library/Keychains/*
done

# This should quit Self-Service
killall "Self Service"

#Remove JAMF
sudo /usr/local/bin/jamf removeFramework
sleep 10

#Remove Login window banner
defaults delete /Library/Preferences/com.apple.loginwindow LoginwindowText

# Remove setup LaunchDaemon item
rm /Library/LaunchDaemons/com.ccsd93.studentpurchase.plist

# Remove the loginwindow delay by loading the com.apple.loginwindow LaunchDaemon in /System/Library/LaunchDaemons/
launchctl load /System/Library/LaunchDaemons/com.apple.loginwindow.plist

shutdown -h +1

rm /Library/Scripts/studentpurchase.sh
EOF

chmod +x /Library/Scripts/studentpurchase.sh
