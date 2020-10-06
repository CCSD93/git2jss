#!/bin/sh
# This script will check for the existance of a directory passed in variable 4
# To delete something from a User home folder send the variable in this format:
# /Users/homefolder/Google Drive
# replacing the username with the word "homefolder"

# set user to /bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'
# or ls -l /dev/console | cut -d " " -f 4
# or /usr/bin/logname

#Test if exists
#https://linuxize.com/post/bash-check-if-file-exists/

userid=$3

currentuser=$( /bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }' )

echo "The current logged in user is: $currentuser"

paramcount=$#
folderarray=("$@")

#Parameters 0,1,2 are Jamf defined, so starting at 3
for (( foldercount=3; foldercount<paramcount; foldercount++ )); do
    if [ -z "${folderarray[foldercount]}" ]; then 
    	# This parameter is blank so "continue" on to next in the loop
        continue
    fi

	# If the folder contains the phrase "homefolder" replace that with the "curentuser" variable
	folder="${folderarray[foldercount]/homefolder/$userid}"

    echo "Folder to delete - $folder"
    
   	if [[ "$folder" != "${folder/ /}" ]]; then
    	echo "$folder contains spaces"
    #   folder=$(printf %q "$folder")
    	folder=\"$folder\"
    fi
    
    escapedfolder=$(printf %q "$folder")

	echo "Deleting folder $folder"
    
	if $ls $folder 1> /dev/null 2>&1 ; then
		rm -R $folder
    	if ls $folder 1> /dev/null 2>&1; then
	 	   echo "$folder still exists"
		else
		   echo "$folder Successfully deleted"
	    fi
	else
	    echo "$folder does not exist"
    fi
    echo 
    echo 
done
