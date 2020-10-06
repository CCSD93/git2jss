#!/bin/bash

#Remove Kanaka
echo "$( date "+%m%d%Y %T" ) : Removing Kanaka"
rm -v /Library/Preferences/DirectoryService/Kanaka.plist
rm -rv /Library/DirectoryServices/PlugIns/Kanaka.dsplug/
echo "Deleting /Applications/Kanaka"
rm -r /Applications/Kanaka
dscl /Search -delete / CSPSearchPath /Kanaka/Auth
dscl /Search -change / SearchPolicy CSPSearchPath LSPSearchPath

echo "$( date "+%m%d%Y %T" ) : Kanaka removed"
