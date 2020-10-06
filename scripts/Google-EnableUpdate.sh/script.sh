#!/bin/sh

username=`ls -l /dev/console | cut -d " " -f 4`

# Enable Google Auto-Updates
echo "Enable Google Updates"

# Enable Google Auto-Updates
if [ -e /Library/Google/GoogleSoftwareUpdate ]
then
	rm -r /Library/Google/GoogleSoftwareUpdate
	echo "Deleting existing GoogleSoftwareUpdate folder"
fi

if [ -e /Users/$username/Library/Google/GoogleSoftwareUpdate ]
then
	rm -r /Users/$username/Library/Google/GoogleSoftwareUpdate
	echo "Deleting existing GoogleSoftwareUpdate user folder"
fi

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