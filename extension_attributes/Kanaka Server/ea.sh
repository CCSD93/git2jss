#!/bin/sh

file="/Library/Preferences/DirectoryService/Kanaka"

if [ -e $file.plist ]; then

  KanakaServer=`defaults read $file | grep 3089`

  if [ "${KanakaServer}" != "" ]; then
    echo "<result>${KanakaServer}</result>"
  else
    echo "<result>None</result>"
  fi

else 
  echo "<result>Not Installed</result>"

fi