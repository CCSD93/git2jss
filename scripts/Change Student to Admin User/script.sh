#!/bin/sh

## Demote admin users to standard

## Get list of users for demotion
/bin/echo "Building list of local user accounts for promotion"
userList=$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 >= 501 { print $1; }' | /usr/bin/grep -ve "ccsd93admin" )

## Remove admin privs from each user and add them into the _lpadmin group
for i in $userList; do
/usr/sbin/dseditgroup -o edit -a $i -t user admin
done