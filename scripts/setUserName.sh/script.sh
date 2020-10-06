#!/bin/sh
# The purpose of the script is to add the user to the Computer's Location, User attribute.
# This way the helpdesk can lookup where our users are sitting based on their username.
# There is no logoff policy as we might find it useful being static until next login.

# Define the variables

loggedinUser=$(defaults read /Library/Preferences/com.apple.loginwindow lastUserName)

#if [[ $loggedinUser =~ ^(ccsd93admin|adobeinstall|mbsetupuser|train|csstu|clstu|eccstu|ejstu|hlstu|jsstu|rdstu|ststu|wtstu|csstf|clstf|eccstf|ejstf|hlstf|jsstf|rdstf|ststf|wtstf)$ ]]; then 
if [[ $loggedinUser =~ ^(ccsd93admin|adobeinstall|mbsetupuser|xcode|root)$ ]]; then 
    echo "Don't run for generic accounts"
else
    echo "User name checked. Running recon for user $loggedinUser"
    jamf recon -userID $loggedinUser -endUsername $loggedinUser
fi