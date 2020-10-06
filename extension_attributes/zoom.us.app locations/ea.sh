#!/bin/sh

search=$( mdfind "kind:app zoom.us.app" )

if [ "$search" = "" ]; then
	search=$( find / -name zoom.us.app 2> /dev/null )
fi

if [ "$search" != "" ]; then
    echo "<result>Found\n$search</result>"
else
    echo "<result>Zoom not installed</result>"
fi