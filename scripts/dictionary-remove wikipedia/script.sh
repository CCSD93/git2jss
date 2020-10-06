#!/bin/bash

if [ -d /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework/Versions/A/Resources/Wikipedia.wikipediadictionary ]; then
    echo "Wikipedia lookup exists"
    if [ -d /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework/Versions/A/Resources/Wikipedia.wikipediadictionarybackup ]; then
        echo "Backup already exists, so deleting Wikipedia Framework"
        rm -r /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework/Versions/A/Resources/Wikipedia.wikipediadictionary
    else
        echo "Backup does not exist, moving Wikipedia Framework to backup folder"
        mv /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework/Versions/A/Resources/Wikipedia.wikipediadictionary /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework/Versions/A/Resources/Wikipedia.wikipediadictionarybackup
    fi
else
    echo "Wikipedia Framework already removed"
fi