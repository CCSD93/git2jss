#!/bin/sh
## postflight
##
## Not supported for flat packages.

## Lock down the login window 
jamf launchJAMFHelper -path '/Library/Application Support/JAMF/bin/jamfHelper.app'
