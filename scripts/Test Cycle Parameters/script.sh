#!/bin/bash

echo ""
paramcount=$#
paramarray=("$@")
echo "Total defined Parameters - $paramcount"
echo ""

#Parameters 0,1,2 are Jamf defined, so starting at 3
for (( j=3; j<paramcount; j++ )); do
    echo "${paramarray[j]}"
done

echo ""
shift
shift
shift
for var in "$@"
do
    echo "Parameter $var"
done
