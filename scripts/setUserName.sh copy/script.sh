#!/bin/sh
# The purpose of the script is to add the user to the Computer's Location, User attribute.
# This way the helpdesk can lookup where our users are sitting based on their username.
# There is no logoff policy as we might find it useful being static until next login.

# Define the variables

jssAPIUsername="apiaccess"
jssAPIPassword="ccsd93apiaccess"

# Enter in the hostname in the quotes here, replacing https://jss.organization.com:8443 without the trailing slash
jssAddress="https://jss-01.ccsd93.com:8443"

# Get Computer Serial Number, for lookup via Casper.
serialNumber=`/usr/sbin/system_profiler SPHardwareDataType | awk '/Serial Number/ { print $4 }'`

# Get the username used for login.
#loggedInUser=`/usr/bin/logname`
loggedInUser="$3"

if [ $loggedInUser -eq  "ccsd93admin" ]
then
    echo "User is: $loggedInUser"
    exit 0
fi

# Do not edit below this line
# -----------------------------------------------------


############################################################
#Start Of Posting Username
#This Grabs the username at login and uses the API to update
#the Username on the computer within casper.
############################################################


## Now that we have the name, we'll basically grab it, put it in a custom xml that will get put into the device's location info
echo "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>
<computer>
<location>
<username>$loggedInUser</username>
</location>
</computer>" > /tmp/deviceFinal.xml

# Then, take that /tmp/deviceFinal.xml and put it in the JSS for the device
function LogUser {
res=`curl -k -s -I -u $jssAPIUsername:$jssAPIPassword $jssAddress/JSSResource/computers/serialnumber/$serialNumber -X PUT -T /tmp/deviceFinal.xml | grep HTTP/1.1 | awk {'print $2'}`
echo "All HTTP Status:\n$res"
res=`echo $res | awk {'print $NF'}`
#echo $res
if [ $res -ne "201" ]
then
echo "Error $res"
fi
}

# Call function to Log user into Casper.
LogUser

# Test or display Results
echo "------------------"
echo "Username: $loggedInUser"
echo "Serial Number: $serialNumber"
echo "XML File: "
cat /tmp/deviceFinal.xml
echo "------------------"

# clean up
rm /tmp/deviceFinal.xml
