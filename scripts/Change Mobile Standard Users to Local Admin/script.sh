#!/bin/bash
## Promote standard users to admin
## Get list of users to convert
/bin/echo "Building list of local user accounts for demotion"
userList=$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 >= 501 { print $1; }' | /usr/bin/grep -ve "ccsd93admin" )
exitcode=0

for loggedInUser in $userList; do
    echo "User $loggedInUser is currently a Standard User. Promoting to admin."
    #Get UID
    UserUID=$( dscl . read /Users/$loggedInUser UniqueID | grep UniqueID: | cut -c 11- )

    #Gets the real name of the currently logged in user
    userRealName=$( dscl . -read /Users/$loggedInUser | grep RealName: | cut -c11- )
    if [[ -z $userRealName ]]; then
        userRealName=$( dscl . -read /Users/$loggedInUser | awk '/^RealName:/,/^RecordName:/' | sed -n 2p | cut -c 2- )
    fi

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
#    dscl . -create /Users/"$loggedInUser" UniqueID "$UserUID"
    dscl . -create /Users/"$loggedInUser" PrimaryGroupID 80
    dscl . -create /Users/"$loggedInUser" NFSHomeDirectory /Users/"$loggedInUser"
    
    # Set the user password to "password"
    dscl . -passwd /Users/"$loggedInUser" "password"

    #Makes the user an admin
    dscl . -append /Groups/admin GroupMembership "$loggedInUser"

    #Reset ownership on home directory and append location
    chown -R "$loggedInUser":staff /Users/"$loggedInUser"

    #Delete the user's keychain folder.
    rm -Rf /Users/$loggedInUser/Library/Keychains/*
done

