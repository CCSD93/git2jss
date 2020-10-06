#!/bin/bash

#exit 0

echo "Starting autolaunch cleanup"
killall cfprefsd

#i="$(defaults read /Library/Preferences/loginwindow.plist AutoLaunchedApplicationDictionary | grep Path | awk '/\/Applications\/LanSchool/{n++}n==1{print NR-1}')"
#while [[ $i ]]; do
#echo "Deleting entry from loginwindow.plist"
#/usr/libexec/PlistBuddy -c "Delete AutoLaunchedApplicationDictionary:$i" /Library/Preferences/loginwindow.plist
#i="$(defaults read /Library/Preferences/loginwindow.plist AutoLaunchedApplicationDictionary | grep Path | awk '/\/Applications\/LanSchool/{n++}n==1{print NR-1}')"
#done

i="$(defaults read /Library/Preferences/com.apple.loginitems.plist privilegedlist | grep Path | awk '/\/Applications\/LanSchool/{n++}n==1{print NR-1}')"
while [[ $i ]]; do
echo "Deleting entry from com.apple.loginitems.plist"
/usr/libexec/PlistBuddy -c "Delete :privilegedlist:CustomListItems:$i" /Library/Preferences/com.apple.loginitems.plist
killall cfprefsd
sleep 10
i="$(defaults read /Library/Preferences/com.apple.loginitems.plist privilegedlist | grep Path | awk '/\/Applications\/LanSchool/{n++}n==1{print NR-1}')"
done
