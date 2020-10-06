#!/bin/bash

# hw.model returns something like "hw.model: MacBookAir7,2"
# The rest of the commands remove the first 10 and last 3 characters, removes spaces (for "Mac Mini"), and changes MacBook to MB

namePrefix=$( sysctl hw.model | cut -c 11- | rev | cut -c 4- | rev | sed 's/ //g' | sed 's/MacBook/MB/g' )
serial=$( ioreg -l | awk '/IOPlatformSerialNumber/ { print substr($4,6,4);}' )

jamf setComputerName -name $namePrefix-$serial
