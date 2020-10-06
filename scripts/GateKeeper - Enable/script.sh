#!/bin/sh

defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool true
spctl --master-enable
