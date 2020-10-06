#!/bin/bash

#Remove Firmware Password
if [ -f /Library/Application\ Support/JAMF/bin/setregproptool ]; then
    /Library/Application\ Support/JAMF/bin/setregproptool -c
    if [ $? -eq 0 ]; then
        #Firmware password is set
        /Library/Application\ Support/JAMF/bin/setregproptool -d -o "CC\$D93firmwarepassword"
            if [ $? -eq 0 ]; then
		        echo .
                echo "Removal successful"
		        echo .
                # defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "Firmware password removed"
            else
                echo "ERROR: Firmware password command exited with an error"
            fi
    else
        echo "No firmware password set"
        defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "Firmware password is not set"
    fi
else
        echo "setregproptool firmware password tool not available"
fi
