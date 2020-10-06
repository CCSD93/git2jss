#!/bin/sh

## Demote admin users to standard

## Get list of users for demotion
/bin/echo "Building list of local user accounts for demotion"
userList=$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 >= 501 { print $1; }' | /usr/bin/grep -ve "ccsd93admin" | /usr/bin/grep -ve "tempadmin")
exitcode=0

## Remove admin privs from each user and add them into the _lpadmin group
for i in $userList; do
if [[ `/usr/sbin/dseditgroup -o checkmember -m $i admin | /usr/bin/awk '{ print $1 }'` = "yes" ]]; then
    /bin/echo "Error: User $i is currently an admin. Converting into Standard User"
    /usr/sbin/dseditgroup -o edit -d $i -t user admin
    exitcode=$((exitcode+1))
    ## /bin/echo "Adding $i into _lpadmin group"
    ## /usr/sbin/dseditgroup -o edit -a $i -t user _lpadmin
else
    echo "User $i is currently a Standard User. Leaving as is."
fi
done

if [[ $exitcode ]]; then
    echo "$exitcode users converted back to Standard user"
else
    echo "Error: $exitcode users converted back to Standard user"
fi

exit $exitcode