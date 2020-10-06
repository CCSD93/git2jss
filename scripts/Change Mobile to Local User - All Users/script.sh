#!/bin/bash

#  Recreate account.sh
#
#  This script is designed to remove a mobile user account and re-create
#  a local account with the same username and the password as useridpassword, eg. 12345678password.
#  It will also give read/write permissions to the user's home folder.

#Gets the short name of the currently logged in user
#loggedInUser=$3

## Get list of users for conversion
/bin/echo "Building list of local user accounts for conversion"
userList=$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 >= 1000 { print $1; }' | /usr/bin/grep -ve "ccsd93admin" | /usr/bin/grep -ve "tempadmin")
echo "User list to convert: " $userList

for loggedInUser in $userList; do

	#Get $loggedInUser UID
	UserUID=$( /usr/bin/dscl . read /Users/"$loggedInUser" UniqueID | grep UniqueID: | cut -c 11- )

	#Gets the real name of $loggedInUser
	userRealName=$( /usr/bin/dscl . -read /Users/$loggedInUser | grep RealName: | cut -c11- )
	if [[ -z $userRealName ]]; then
		userRealName=$( /usr/bin/dscl . -read /Users/$loggedInUser | awk '/^RealName:/,/^RecordName:/' | sed -n 2p | cut -c 2- )
	fi

	if [[ $( /usr/sbin/dseditgroup -o checkmember -m $loggedInUser admin | /usr/bin/awk '{ print $1 }' ) = "yes" ]]; then
		# Set variable for use later if the current user is an admin
        adminUser="yes"
	else
		adminUser="no"
	fi

	#This will delete the $loggedInUser
	/usr/bin/dscl . delete /Users/$loggedInUser
    echo "Deleted: " $loggedInUser

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
	/usr/bin/dscl . -create /Users/"$loggedInUser"
    echo "Created new: " $loggedInUser
	/usr/bin/dscl . -create /Users/"$loggedInUser" UserShell /bin/bash
	/usr/bin/dscl . -create /Users/"$loggedInUser" RealName "$userRealName"
	/usr/bin/dscl . -create /Users/"$loggedInUser" UniqueID "$newid"
	/usr/bin/dscl . -create /Users/"$loggedInUser" PrimaryGroupID 20

	if [[ adminUser = "yes" ]]; then
		#Makes the new user an admin if the old user was
        echo $loggedInUser " was an Administrator"
		/usr/bin/dscl . -append /Groups/admin GroupMembership "$loggedInUser"
	fi

	#Set the user's password to the one entered prior
	loginPassword=$loggedInUser"password"
	/usr/bin/dscl . -passwd /Users/"$loggedInUser" "$loginPassword"
    echo "Set password to: " $loginPassword

	#Reset ownership on home directory and append location
	/usr/sbin/chown -R "$loggedInUser":staff /Users/"$loggedInUser"
	/usr/bin/dscl . -create /Users/"$loggedInUser" NFSHomeDirectory /Users/"$loggedInUser"/
	#chmod -R u+rw /Users/$loggedInUser
	#chflags -R nouchg /Users/$loggedInUser

	#Delete the user's keychain folder.
	rm -Rf /Users/$loggedInUser/Library/Keychains/*

done

echo "Script successful."

sleep 3

ps -Ajc | grep loginwindow | awk '{print $2}' | xargs kill -9
