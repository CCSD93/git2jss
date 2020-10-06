#!/bin/sh
everyoneGroup=`/usr/bin/dscl . read /Groups/everyone GeneratedUID | sed 's/GeneratedUID: //g'`
result=`/usr/bin/dscl . read /Groups/lpadmin | grep $everyoneGroup`

if [ "$result" == "" ]; then
echo "<result>Fail (Admin authentication required.)</result>"
else
echo "<result>Pass (Users can add printers)</result>"
fi
	