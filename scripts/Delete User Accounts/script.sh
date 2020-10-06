#!/bin/sh

## Delete every user account

## Get list of users for deletion
/bin/echo "Building list of local user accounts for deletion"
userList=$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 >= 501 { print $1; }' | /usr/bin/grep -ve "ccsd93admin" )

## delete all created accounts
for i in $userList; do
    /usr/bin/dscl . -delete /Users/$i
    rm -r /Users/$i
done