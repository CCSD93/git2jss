#!/bin/sh
lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`
launchAgents=`ls -1 /Users/$lastUser/Library/LaunchAgents`

echo "<result>$launchAgents</result>"
