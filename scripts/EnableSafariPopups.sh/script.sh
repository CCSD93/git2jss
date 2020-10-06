#!/bin/bash

user=`/usr/bin/logname`
echo Enabling Safari Popups for User: $user \n

defaults write /Users/$user/Library/Preferences/com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -boolean true
defaults write /Users/$user/Library/Preferences/com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -boolean true

chown $user /Users/$user/Library/Preferences/com.apple.Safari.plist