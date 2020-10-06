#!/bin/sh

#
# Initial setup script for Mac OS X 10.8.x
# Adapted from Rich Trouton, https://github.com/rtrouton/rtrouton_scripts/blob/master/rtrouton_scripts/first_boot/10.8/first_boot.sh
# Adapted from MacInitialSetup.sh

# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)
sw_build=$(sw_vers -buildVersion)

# Set time information
# systemsetup -setnetworktimeserver 10.208.5.1
systemsetup -settimezone America/Chicago

# Populate some default settings in the default user templates
echo "Updating User Templates"
for USER_TEMPLATE in "/System/Library/User Template"/*
	do
		# Disables iCloud pop-up on first login for Macs
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
		# Turn off DS_Store file creation on network volumes
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores true
		# Turn on Finder Status Bar
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.finder ShowStatusBar -bool true
		# Disable Google Auto-Updates
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.google.Keystone.Agent.plist checkInterval 0 
		if [ ! -d "${USER_TEMPLATE}"/Library/Google ]
		then
			mkdir -p "${USER_TEMPLATE}"/Library/Google
		fi
		touch "${USER_TEMPLATE}"/Library/Google/GoogleSoftwareUpdate
		# Set Safari Plugin defaults
		# don't seem to work with newly imaged Mac
#		/usr/libexec/plistbuddy -c "set ManagedPlugInPolicies:com.novell.iprint:PlugInFirstVisitPolicy 'PlugInPolicyAllowNoSecurityRestrictions'" "${USER_TEMPLATE}"/Library/Preferences/com.apple.Safari.plist
#		/usr/libexec/plistbuddy -c "set ManagedPlugInPolicies:com.adobe.acrobat.pdfviewerNPAPI:PlugInFirstVisitPolicy 'PlugInPolicyAllowNoSecurityRestrictions'" "${USER_TEMPLATE}"/Library/Preferences/com.apple.Safari.plist
	done
	
# Checks the existing user folders in /Users for the presence of
# the Library/Preferences directory. If the directory is not found, 
# it is created and then the "Show scroll bars" setting (in System 
# Preferences: General) is set to "Always".

for USER_HOME in /Users/*
	do
		if [ -d "${USER_HOME}" ]; 
		then
			USER_UID=`basename "${USER_HOME}"`
			if [ ! "${USER_UID}" = "Shared" ]
			then
			    echo "Updating User Home- ${USER_HOME}"
				if [ ! -d "${USER_HOME}"/Library/Preferences ]
	 			then
					mkdir -p "${USER_HOME}"/Library/Preferences
					chown "${USER_UID}" "${USER_HOME}"/Library
					chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
				fi
				if [ ! -d "${USER_HOME}"/Library/Preferences/ByHost ]
					then
					mkdir -p "${USER_HOME}"/Library/Preferences/ByHost
					chown "${USER_UID}" "${USER_HOME}"/Library
					chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
					chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/ByHost
		 		fi
				if [ -d "${USER_HOME}"/Library/Preferences ]
				then
					defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
					defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
					defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
					defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
					chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant.plist
				fi
			fi
		fi
	done
	
# Disable Google Auto-Updates
echo "Disabling Google Updates"
if [ ! -d /Library/Google ]
then
	mkdir -p /Library/Google
fi
touch /Library/Google/GoogleSoftwareUpdate
defaults write /Library/Preferences/com.google.Keystone.Agent.plist checkInterval 0
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

touch /Library/LaunchAgents/com.google.keystone.agent.plist
touch /Library/LaunchDaemons/com.google.keystone.daemon.plist
touch /Library/LaunchDaemons/com.google.keystone.daemon4.plist

chmod 444 /Library/LaunchAgents/com.google.keystone.agent.plist
chmod 444 /Library/LaunchDaemons/com.google.keystone.daemon.plist
chmod 444 /Library/LaunchDaemons/com.google.keystone.daemon4.plist

# Set the ability to view additional system info at the Login window
# The following will be reported when you click on the time display
# (click on the time again to proceed to the next item):
#
# Computer name
# Version of OS X installed
# IP address
# This will remain visible for 60 seconds.
defaults write /Library/Preferences/com.apple.loginwindow.plist AdminHostInfo HostName

# Enable full keyboard access for all controls"
# (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable Time Machine's pop-up message whenever an external drive is plugged in
defaults write /Library/Preferences/com.apple.TimeMachine.plist DoNotOfferNewDisksForBackup -bool true

# Add accounts to Hidden User List
defaults write /Library/Preferences/com.apple.loginwindow.plist HiddenUsersList -array-add ccsd93admin

# Prevent DS_Store files from being created on Network shares
defaults write /Library/Preferences/com.apple.desktopservices.plist DSDontWriteNetworkStores true

# Disable external accounts (i.e. accounts stored on drives other than the boot drive.)
defaults write /Library/Preferences/com.apple.loginwindow.plist EnableExternalAccounts -bool false

# Make a symbolic links doesn't work with SIP, including dockfixup

# Set whether you want to send diagnostic info back to
# Apple and/or third party app developers. If you want
# to send diagonostic data to Apple, set the following 
# value for the SUBMIT_DIAGNOSTIC_DATA_TO_APPLE value:
#
# SUBMIT_DIAGNOSTIC_DATA_TO_APPLE=TRUE
# 
# If you want to send data to third party app developers,
# set the following value for the
# SUBMIT_DIAGNOSTIC_DATA_TO_APP_DEVELOPERS value:
#
# SUBMIT_DIAGNOSTIC_DATA_TO_APP_DEVELOPERS=TRUE
# 
# By default, the values in this script are set to 
# send no diagnostic data: 

SUBMIT_DIAGNOSTIC_DATA_TO_APPLE=FALSE
SUBMIT_DIAGNOSTIC_DATA_TO_APP_DEVELOPERS=FALSE

# To change this in your own script, comment out the FALSE
# lines and uncomment the TRUE lines as appropriate.

# Checks first to see if the Mac is running 10.10.0 or higher. 
# If so, the desired diagnostic submission settings are applied.

if [[ ${osvers} -ge 10 ]]; then
    echo "Setting Diagnostic Info"
	CRASHREPORTER_SUPPORT="/Library/Application Support/CrashReporter"
 
	if [ ! -d "${CRASHREPORTER_SUPPORT}" ]; then
		mkdir "${CRASHREPORTER_SUPPORT}"
		chmod 775 "${CRASHREPORTER_SUPPORT}"
		chown root:admin "${CRASHREPORTER_SUPPORT}"
	fi

	defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory AutoSubmit -boolean ${SUBMIT_DIAGNOSTIC_DATA_TO_APPLE}
	defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory AutoSubmitVersion -int 4
	defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory ThirdPartyDataSubmit -boolean ${SUBMIT_DIAGNOSTIC_DATA_TO_APP_DEVELOPERS}
	defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory ThirdPartyDataSubmitVersion -int 4
	chmod a+r "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory.plist
	chown root:admin "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory.plist
fi

# Turn SSH on - Already turned on by enrollment
#systemsetup -setremotelogin on

# Disable Printer Sharing
cupsctl --no-share-printers

#Add Everyone to the LPAdmin group
/usr/sbin/dseditgroup -o edit -t group -a everyone _lpadmin

# Enable Screen sharing for ccsd93admin
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -users ccsd93admin -access -on -privs -all -restart
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -specifiedUsers -restart

# Turn off Gatekeeper - done through separate script

# Set the RSA maximum key size to 32768 bits (32 kilobits) in
# /Library/Preferences/com.apple.security.plist to provide
# future-proofing against larger TLS certificate key sizes.
#
# For more information about this issue, please see the link below:
# http://blog.shiz.me/post/67305143330/8192-bit-rsa-keys-in-os-x

/usr/bin/defaults write /Library/Preferences/com.apple.security RSAMaxKeySize -int 32768

# Enroll in JAMF - done through DEP
# jamf enroll -invitation 10325743967634169523566132306245526221

# Delete JAMF policy history so policies will redeploy if necessary - Should be part of the default enroll settings now
# jamf flushPolicyHistory -verbose >> /Users/jamf-flushPolicyHistory.log

# Update JAMF Management Framework
echo "Updating Jamf Management Framework"
jamf manage -verbose >> /Users/jamf-manage.log

# Update JAMF inventory
echo "Starting Jamf Inventory Update"
jamf recon -verbose >> /Users/jamf-recon.log
sleep 30

# Run JAMF policy to install any updates waiting out there for the 15 minute check
echo "Starting Jamf Policy Update"
jamf policy -verbose >> /Users/jamf-policy.log

#Install any available updates
softwareupdate --install --all

# Make script self-destruct
# rm "$0"