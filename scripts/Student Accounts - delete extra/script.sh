#!/bin/sh

## Demote admin users to standard

## Get list of users for demotion
/bin/echo "Building list of local user accounts"
userList=$( /usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 >= 501 { print $1; }' | /usr/bin/grep -ve "ccsd93admin" | /usr/bin/grep -ve "tempadmin" )
exitcode=0

if [[ ${#userList[@]} == 1 ]]; then
    echo "Only one student account"
else
    echo "ERROR: ${#userList[@]} student accounts"
fi

## Remove admin privs from each user and add them into the _lpadmin group
for i in $userList; do
if [[ ($i == 1* && ${#i} == 6) || ($i == *stu && ${#i} == 5) ]]; then
    /bin/echo "User $i is an appropriate student account"
else
    exitcode=$((exitcode+1))
    echo "ERROR: User $i is not a valid student account"
fi
done

if [[ $exitcode ]]; then
    echo "$exitcode invalid student accounts"
else
    echo "Error: $exitcode invalid student accounts"
fi

exit $exitcode