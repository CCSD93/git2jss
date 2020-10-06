#!/bin/bash

for dir in /Users/*; do
    if [[ -e "${dir}/Library/Preferences/com.apple.Preview.plist" ]]; then
        rm "${dir}/Library/Preferences/com.apple.Preview.plist"
    fi
done