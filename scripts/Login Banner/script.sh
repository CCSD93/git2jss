#!/bin/bash

 defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "$4"
 echo "Login banner set to: $4"