#!/bin/sh

file="/Library/Application Support/LanSchool/student.app/Contents/Info.plist"

if [[ -f "$file" ]]; then

  LanschoolVersion=`defaults read "$file" CFBundleVersion`

  if [ "${LanschoolVersion}" != "" ]; then
    echo "<result>${LanschoolVersion}</result>"
  else
    echo "<result>None</result>"
  fi

else 
  echo "<result>Lanschool Student Agent Not Installed</result>"

fi