#!/bin/bash
#Parameters 1 through 3 are predefined as mount point, computer name, and username

DIR=/Users/$3/Library/Application\ Support/Google/DriveFS

if [ -d "$DIR" ]
then
	echo "$DIR directory exists!"
    rm -r "$DIR"
else
	echo "$DIR directory not found!"
fi
