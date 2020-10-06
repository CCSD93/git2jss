#!/bin/sh

paramcount=$#
apparray=("$@")

#Parameters 0,1,2 are Jamf defined, so starting at 3
for (( app=3; app<paramcount; app++ )); do
    if [ -z "${apparray[app]}" ]; then 
    	# This parameter is blank so "continue" on to next in the loop
        continue
    fi
    echo "App to delete - ${apparray[app]}"

	if [ -d "/Applications/${apparray[app]}.app" ]; then
    	rm -r "/Applications/${apparray[app]}.app"
 	    echo "Deleting ${apparray[app]}.app"
		if [ -d "/Applications/${apparray[app]}.app" ]; then
	 	   echo "${apparray[app]}.app still exists"
		else
		   echo "${apparray[app]}.app Successfully deleted"
        fi
	else
	    echo "${apparray[app]}.app does not exist"
	fi
done
