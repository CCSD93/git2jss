#!/bin/bash

sudo defaults write /Library/Preferences/com.jamf.connect.login.plist OIDCProvider -string "GoogleID"
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist OIDCClientID 460638211905-9qbr4nspe9sp15rpvv3sq7iuhj3m98u7.apps.googleusercontent.com
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist OIDCClientSecret C97MRGPTVsfnioZzJNIT5UW3
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist OIDCRedirectURI -string "https://127.0.0.1/jamfconnect"
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist OIDCNewPassword -bool TRUE

sudo defaults write /Library/Preferences/com.jamf.connect.login.plist CreateAdminUser -bool FALSE
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist OIDCIgnoreAdmin -bool TRUE

# Seem to get a "400 error" at the initial Google login if IgnoreCookies is set to True
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist OIDCIgnoreCookies -bool FALSE

sudo defaults write /Library/Preferences/com.jamf.connect.login.plist DemobilizeUsers -bool TRUE
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist Migrate -bool TRUE
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist MigrateUsersHide -array ccsd93admin xcode test tempadmin
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist DenyLocal -bool TRUE
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist DenyLocalExcluded -array ccsd93admin xcode test tempadmin
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist LocalFallback -bool TRUE
sudo defaults write /Library/Preferences/com.jamf.connect.login.plist AllowNetworkSelection -bool TRUE

sudo defaults write /Library/Preferences/com.jamf.connect.login.plist HelpURL -string "https://drive.google.com/file/d/1wqnyAQOl_AYevJJdMYb3K0dQWRalEOcE/view?usp=sharing"
