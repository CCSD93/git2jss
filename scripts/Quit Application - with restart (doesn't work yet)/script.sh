#!/bin/bash

# PROCESS="${@}"   # This was for a shell script
PROCESS="$4"
USERNAME=`/usr/bin/logname`

echo "Restarting $PROCESS"

PIDS=`ps cax | grep "$PROCESS" | grep -o '^[ ]*[0-9]*'`
if [ ! -d "/Applications/$PROCESS.app" ]; then
	echo "$PROCESS.app does not exist"
elif [ -z "$PIDS" ]; then
	echo "$PROCESS is not running." 1>&2
else
    echo "$PROCESS running at PID $PIDS"
	for PID in $PIDS; do
		echo "Killing $PROCESS PID $PID"
		kill $PID
		while ps -p $PID
		do 
			sleep 1
		done
		echo "$PROCESS is no longer running"
		sleep 10
		if [ -d "/Applications/$PROCESS.app" ]; then
			echo "Restarting $PROCESS as $3"
			until sudo -u $3 open "/Applications/$PROCESS.app"
			do
			    echo "$PROCESS did not start successfully. Will try again in 15 seconds"
			    sleep 15
		    done
		    echo "$PROCESS started successfully"
		fi
	done
fi

