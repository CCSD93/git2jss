#!/bin/bash

# get the total amount of disk space the current user's trash has

currentUser=$(ls -l /dev/console | awk '{ print $3 }')
echo "Checking trash size for ${currentUser} - \n"

trashSpace=$(du -m -c /Users/${currentUser}/.Trash/ | awk '/total/ { print $1 }')

# set the emptry trash message for the end user

question="System maintenance has determined your trash is starting to fill up. Please select Yes to empty the trash. WARNING: This will permanently empty all the contents of the your trash. If you Cancel, you may be prompted again tomorrow."

# determine if it is Megabytes or Gigabytes

if [[ ${trashSpace} -gt 5120 ]]
	then size='gigs' && echo "Trash is ${trashSpace}MB"
	else echo "Trash is only ${trashSpace}MB"
fi

# yesNo function

yesNo () {

# prompt user for yes|no answers

theAnswer==$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -startlaunchd -windowType utility -icon '/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/Resources/Message.png' -heading "CCSD 93 System Maintenance" -description "${question}" -button1 "Yes" -button2 "Cancel" -cancelButton "2")

if [[ ${theAnswer} == "0" ]]
	then theAnswer="yes"
	else theAnswer="no"
fi
}

# if the size is in greater than 5GB, prompt to empty trash

if [[ ${size} == 'gigs' ]]
	then yesNo
fi

if [[ ${theAnswer} == 'yes' ]]
	then echo "Emptying the Trash" && rm -rf /Users/${currentUser}/.Trash/
	else echo "User chose to keep trash"
fi

exit 0