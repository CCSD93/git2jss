#!/bin/bash

defaults write /Library/Preferences/com.google.Chrome.plist BrowserSignin -int 2
defaults write /Library/Preferences/com.google.Chrome.plist RestrictSigninToPattern "*@ccsd93.*"
defaults write /Library/Preferences/com.google.Chrome.plist DisablePrintPreview -bool TRUE
