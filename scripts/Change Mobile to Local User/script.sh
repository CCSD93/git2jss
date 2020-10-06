#!/bin/bash

#  Recreate account.sh
#
#  This script is designed to remove a mobile user account and re-create
#  a local account with the same username and the password from user-input.
#  It will also give read/write permissions to the user's home folder.

#Gets the short name of the currently logged in user
loggedInUser=$3

#Get loggedInUser UID
UserUID=`dscl . read /Users/"$loggedInUser" UniqueID | grep UniqueID: | cut -c 11-`

#Exit if UID is under 1000 (local account)
if [[ $UserUID -lt 1000 ]]; then
	echo "Not a mobile account, exiting"
	exit 2
else

#Gets the real name of the currently logged in user
userRealName=`dscl . -read /Users/$loggedInUser | grep RealName: | cut -c11-`
if [[ -z $userRealName ]]; then
	userRealName=`dscl . -read /Users/$loggedInUser | awk '/^RealName:/,/^RecordName:/' | sed -n 2p | cut -c 2-`
fi

if [[ `/usr/sbin/dseditgroup -o checkmember -m $loggedInUser admin | /usr/bin/awk '{ print $1 }'` = "yes" ]]; then
	adminUser="yes"
else
	adminUser="no"
fi

#Prompts user to enter their login password
loginPassword=`/usr/bin/osascript <<EOT
tell application "System Events"
activate
set myReply to text returned of (display dialog "Please enter your login password." ¬
default answer "" ¬
with title "CCSD93 IT" ¬
buttons {"Continue"} ¬
default button 1 ¬
with hidden answer)
end tell
EOT`

#Confirm password.
confirmPassword=`/usr/bin/osascript <<EOT
tell application "System Events"
activate
set myReply to text returned of (display dialog "Please confirm your password" ¬
default answer "" ¬
with title "CCSD93 IT" ¬
buttons {"Continue"} ¬
default button 1 ¬
with hidden answer)
end tell
EOT`

defaultPasswordAttempts=1

#Checks to make sure passwords match, if they don't displays an error and prompts again.
while [ $loginPassword != $confirmPassword ] || [ -z $loginPassword ]; do
`/usr/bin/osascript <<EOT
tell application "System Events"
activate
display dialog "Passwords do not match. Please try again." ¬
with title "Ruyton IT" ¬
buttons {"Continue"} ¬
default button 1
end tell
EOT`

loginPassword=`/usr/bin/osascript <<EOT
tell application "System Events"
activate
set myReply to text returned of (display dialog "Please enter your login password." ¬
default answer "" ¬
with title "CCSD93 IT" ¬
buttons {"Continue"} ¬
default button 1 ¬
with hidden answer)
end tell
EOT`

confirmPassword=`/usr/bin/osascript <<EOT
tell application "System Events"
activate
set myReply to text returned of (display dialog "Please confirm your password" ¬
default answer "" ¬
with title "CCSD93 IT" ¬
buttons {"Continue"} ¬
default button 1 ¬
with hidden answer)
end tell
EOT`

defaultPasswordAttempts=$((defaultPasswordAttempts+1))

if [[ $defaultPasswordAttempts -ge 5 ]]; then
`/usr/bin/osascript <<EOT
tell application "System Events"
activate
display dialog "You have entered mis-matching passwords five times. Please come to the IT desk for assistance." ¬
with title "CCSD93 IT" ¬
buttons {"Continue"} ¬
default button 1
end tell
EOT`
echo "Entered mis-matching passwords too many times."
exit 1
fi

done

#This will delete the currently logged in user
dscl . delete /Users/$loggedInUser

    #Gets the current highest user UID between 500 and 1000
    lastID=1
    #Read all UniqueID into an array userids
    IFS=$'\n' read -r -d '' -a userids < <( dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug )
	#Set maxid to the last UniqueID in the list
	maxid=${userids[@]: -$lastID:1}
    #Mobile users have very large UniqueID, so skip if the UniqueID is larger than 1000, and go to the next UniqueID
	until [ $maxid -lt 1000 ]; do
	    ((lastID++))
		maxid=${userids[@]: -$lastID:1}
	done
    #Set the New UID for the user to be one higher that the maxid found
    newid=$((maxid+1))
    #If there are no "regular" users, set the newid to 501 whoch should be the first "regular" user
    if [[ $newid -lt 501 ]]; then
        newid=501
    fi

#Creating the new user
dscl . -create /Users/"$loggedInUser"
dscl . -create /Users/"$loggedInUser" UserShell /bin/bash
dscl . -create /Users/"$loggedInUser" RealName "$userRealName"
dscl . -create /Users/"$loggedInUser" UniqueID "$newid"
dscl . -create /Users/"$loggedInUser" PrimaryGroupID 20

if [[ adminUser = "yes" ]]; then
	#Makes the user an admin
	dscl . -create /Users/"$loggedInUser" PrimaryGroupID 80
	dscl . -append /Groups/admin GroupMembership "$loggedInUser"
fi

#Set the user's password to the one entered prior
dscl . -passwd /Users/"$loggedInUser" "$loginPassword"

#Reset ownership on home directory and append location
chown -R "$loggedInUser":staff /Users/"$loggedInUser"
dscl . -create /Users/"$loggedInUser" NFSHomeDirectory /Users/"$loggedInUser"/
#chmod -R u+rw /Users/$loggedInUser
#chflags -R nouchg /Users/$loggedInUser

#Delete the user's keychain folder.
rm -Rf /Users/$loggedInUser/Library/Keychains/*

echo "Script successful."

fi

sleep 3

ps -Ajc | grep loginwindow | awk '{print $2}' | xargs kill -9
