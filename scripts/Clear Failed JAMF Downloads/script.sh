#!/bin/bash

echo ""

if [ -d "/Library/Application Support/JAMF/Downloads" ]; then
    if [ "$(ls -A /Library/Application\ Support/JAMF/Downloads)" ]; then
        ls -l /Library/Application\ Support/JAMF/Downloads/
        echo "Clearing the JAMF Downloads folder"
        rm -rv /Library/Application\ Support/JAMF/Downloads/*
    else
        echo "JAMF Downloads folder is empty"
    fi
else
    echo "JAMF Downloads folder is missing"
fi

if [ -d "/Library/Application Support/JAMF/Waiting Room" ]; then
    if [ "$(ls -A /Library/Application\ Support/JAMF/Waiting\ Room)" ]; then
        ls -l /Library/Application\ Support/JAMF/Waiting\ Room/
        echo "Clearing the JAMF Waiting Room folder"
        rm -rv /Library/Application\ Support/JAMF/Waiting\ Room/*
    else
        echo "JAMF Waiting Room folder is empty"
    fi
else
    echo "JAMF Waiting Room folder is missing"
fi
