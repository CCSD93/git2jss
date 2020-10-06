#!/bin/sh

lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`

search=$( mdfind -onlyin /Users/$lastuser/Applications -interpret -name .app )

if [ "$search" != "" ]; then
    echo "<result>Found\n$search</result>"
else
    echo "<result>No User Apps Installed</result>"
fi