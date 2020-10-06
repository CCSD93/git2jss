#!/bin/bash

user=`/usr/bin/logname`

echo "Setting Trash permissions for user $user"

chown $user:staff /Users/$user/.Trash