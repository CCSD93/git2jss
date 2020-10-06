#!/bin/bash

/usr/local/bin/authchanger -reset

rm /usr/local/bin/authchanger
rm /usr/local/lib/pam/pam_saml.so.2
rm -r /Library/Security/SecurityAgentPlugins/JamfConnectLogin.bundle

rm /Library/Preferences/com.jamf.connect.login.plist