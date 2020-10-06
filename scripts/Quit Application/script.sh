#!/bin/bash

# PROCESS="${@}"   # This was for a shell script
PROCESS="$4"
USERNAME=`/usr/bin/logname`

echo "Kiling $PROCESS"

PIDS=$( pgrep -x "$PROCESS" )
if [ -z "$PIDS" ]; then
	echo "$PROCESS is not running." 1>&2
else
    echo "$PROCESS running at PID $PIDS"
	for PID in $PIDS; do
		echo "Killing $PROCESS PID $PID"
		kill $PID
		while pgrep -x "$PROCESS"
		do 
			sleep 1
		done
		echo "$PROCESS is no longer running"
	done
fi

