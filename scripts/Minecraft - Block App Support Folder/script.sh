#!/bin/sh
# current user is $3
set -x

# first, lets make the directory if one doesn't exist.
if [ ! -d "/Users/$3/Library/Application Support/minecraft" ]; then 
    mkdir "/Users/$3/Library/Application Support/minecraft" 
fi

cd "/Users/$3/Library/Application Support/"

# Remove the permissions on the folder and everything in it unless they were already set
if [ ! `ls -la | grep minecraft | awk '{print $1}'` == "d---------" ]; then 
     chmod -R 000 "/Users/$3/Library/Application Support/minecraft"
fi 

# Set the owner and group to root : wheel
if [ ! `ls -la | grep minecraft | awk '{print $3}'` == "root" ] && [ ! `ls -la | grep minecraft | awk '{print $4}'` == "wheel" ]; then
     chown -R root:wheel "/Users/$3/Library/Application Support/minecraft"
fi