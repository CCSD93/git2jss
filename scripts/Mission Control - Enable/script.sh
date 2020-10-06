#!/bin/bash

username=`/usr/bin/logname`
username=$3
echo "Local user is: $username"

missionControlStatus=$(sudo -u $username defaults read com.apple.dock mcx-expose-disabled)

if [[ $missionControlStatus = 1 ]]; then
	echo "Houston, you have a problem. Mission Control is inaccessible"
    sudo -u $username defaults delete com.apple.dock mcx-expose-disabled
	killall Dock
	dialogResult="Mission Control is now enabled for user $username"
    echo $dialogResult
	runCommand="button returned of (display dialog \"$dialogResult\" with title \"Mission Control Status\" buttons {\"OK\"} default button {\"OK\"})"
    clickedButton=$( /usr/bin/osascript -e "$runCommand" )
else
	dialogResult="Mission Control is already enabled for user $username"
    echo $dialogResult
	runCommand="button returned of (display dialog \"$dialogResult\" with title \"Mission Control Status\" buttons {\"OK\"} default button {\"OK\"})"
    clickedButton=$( /usr/bin/osascript -e "$runCommand" )
fi

dashboardStatus=$(sudo -u $username defaults read com.apple.dashboard mcx-disabled)

if [[ $dashboardStatus = 1 ]]; then
	echo "Dashboard is inaccessible"
    sudo -u $username defaults write com.apple.dashboard mcx-disabled -boolean NO
	killall Dock
	dialogResult="Dashboard is now enabled for user $username"
    echo $dialogResult
	runCommand="button returned of (display dialog \"$dialogResult\" with title \"Dashboard Status\" buttons {\"OK\"} default button {\"OK\"})"
    clickedButton=$( /usr/bin/osascript -e "$runCommand" )
else
	dialogResult="Dashboard is already enabled for user $username"
    echo $dialogResult
	runCommand="button returned of (display dialog \"$dialogResult\" with title \"Dashboard Status\" buttons {\"OK\"} default button {\"OK\"})"
    clickedButton=$( /usr/bin/osascript -e "$runCommand" )
fi