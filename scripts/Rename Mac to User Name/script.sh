#!/bin/bash

userID=$(/usr/bin/logname)
echo "UserDI is: $userID"
echo "Sent login name is: $3"

# This command searches LDAP for the users full name, removes spaces, converts commas to dashes, converts to upper case and returns the first 16 characters
fullUserName=$(ldapsearch -b ou=Users,o=CCSD93 -h login-01.ccsd93.com -D cn=ldapuser,ou=Users,o=ccsd93 -w ldapuser cn=$3 fullName | grep ^fullName | cut -f2- -d ' ' | sed 's/ //g' | sed 's/,/-/g' | tr '[a-z]' '[A-Z]' | cut -c 1-16)

echo "Setting the computer name for $userID to: $fullUserName"

if [[ -n "$fullUserName" ]]
then
    scutil --set HostName "$fullUserName"
    scutil --set LocalHostName "$fullUserName"
    scutil --set ComputerName "$fullUserName"
else
    echo "Cannot set the computer name since the Full Name of this user is blank"
fi