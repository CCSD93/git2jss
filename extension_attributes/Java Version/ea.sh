#!/bin/sh

if [[ "$(ls -A /Library/Java/JavaVirtualMachines)" ]]; then
    echo "<result>$(java -version 2>&1 | awk '/version/{print $3}' | sed 's/"//g')</result>"
else
    echo "<result>Java not installed</result>"
fi