#!/bin/sh

## Get list of users
/bin/echo "Building list of local user folders, except ccsd93admin"

folderList=$( ls -1 /Users | /usr/bin/grep -v -e "ccsd93admin" -e ".localized" -e "Shared" -e "jamf" -e "adobeinstall" -e "Guest" -e "_spotlight" )

echo "User Folder list: $folderList"

## fix all home directory ownership rights
for i in $folderList; do
    echo "Fixing $i"
    chown -R $i /Users/$i
    chmod -R u+rw /Users/$i
    chflags -R nouchg /Users/$i
done

## Get list of users
/bin/echo "Building list of local user accounts, except ccsd93admin"
userList=$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 >= 501 { print $1; }' | /usr/bin/grep -ve "ccsd93admin" )

echo "\n User list: $userList"

## fix all home directory ownership rights
for i in $userList; do
    if [ -d "/Users/$i" ]; then
        # If the user has a home folder in the /Users directory, fix the permissions
        echo "Fixing $i"
        chown -R $i /Users/$i
        chmod -R u+rw /Users/$i
        chflags -R nouchg /Users/$i
    else
    	echo "$i doesn't have a home folder"
    fi
done
