#!/bin/bash

# Enable Fast User Switching
defaults write /Library/Preferences/.GlobalPreferences.plist MultipleSessionEnabled -bool true

# Switch to username / password fields instead of user bubbles for login window
# defaults write /Library/Preferences/com.apple.loginwindow.plist SHOWFULLNAME -bool true