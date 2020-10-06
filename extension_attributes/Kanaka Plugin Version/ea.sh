#!/bin/sh

file="/Library/DirectoryServices/PlugIns/Kanaka.dsplug/Contents/Info.plist"

if [ -e $file ]; then

  KanakaVersion=`defaults read $file CFBundleVersion`

  if [ "${KanakaVersion}" != "" ]; then
    echo "<result>${KanakaVersion}</result>"
  else
    echo "<result>None</result>"
  fi

else 
  echo "<result>Not Installed</result>"

fi