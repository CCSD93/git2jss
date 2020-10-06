#!/bin/sh

username=`ls -l /dev/console | cut -d " " -f 4`

# Disable Google Auto-Updates
if [ ! -d /Library/Google ]
then
	mkdir -p /Library/Google
fi
if [ -d /Library/Google/GoogleSoftwareUpdate ]
then
    /Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/Resources/install.py --uninstall
	rm -r /Library/Google/GoogleSoftwareUpdate
	echo "Deleting existing GoogleSoftwareUpdate folder"
fi
touch /Library/Google/GoogleSoftwareUpdate
echo "Making blank GoogleSoftwareUpdate file"
defaults write /Library/Preferences/com.google.Keystone.Agent.plist checkInterval 0

if [ ! -d /Users/$username/Library/Google ]
then
	mkdir -p /Users/$username/Library/Google
fi
if [ -d /Users/$username/Library/Google/GoogleSoftwareUpdate ]
then
    /Users/$username/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/Resources/install.py --uninstall
	rm -r /Users/$username/Library/Google/GoogleSoftwareUpdate
	echo "Deleting existing GoogleSoftwareUpdate user folder"
fi
touch /Users/$username/Library/Google/GoogleSoftwareUpdate
echo "Making blank GoogleSoftwareUpdate user file"


if [ -f /Library/LaunchAgents/com.google.keystone.agent.plist ]
then
	rm /Library/LaunchAgents/com.google.keystone.agent.plist
fi
if [ -f /Library/LaunchDaemons/com.google.keystone.daemon.plist ]
then
	rm /Library/LaunchDaemons/com.google.keystone.daemon.plist
fi
if [ -f /Library/LaunchDaemons/com.google.keystone.daemon4.plist ]
then
	rm /Library/LaunchDaemons/com.google.keystone.daemon4.plist
fi

echo "Exiting Script"