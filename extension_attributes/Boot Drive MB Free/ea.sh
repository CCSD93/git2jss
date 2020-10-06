#!/bin/sh

freeSpace=`df -m / | tail -1 | awk '{print $4}'`

echo "<result>$freeSpace</result>"
