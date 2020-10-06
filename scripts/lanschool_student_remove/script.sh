#!/bin/sh

username=`/usr/bin/logname`

#echo ${username}

/usr/bin/su -l ${username} -c "/bin/launchctl unload -S Aqua /Library/LaunchAgents/com.lanschool.student.plist"
/usr/bin/su -l ${username} -c "/bin/launchctl unload -S Aqua /Library/LaunchAgents/com.lanschool.lsutil.plist"
launchctl unload /Library/LaunchDaemons/com.lanschool.lsdaemon.plist

/usr/bin/killall student

rm /Library/LaunchAgents/com.lanschool*
rm /Library/LaunchDaemons/com.lanschool*
rm -R /Library/Application\ Support/LanSchool

#Remove Lanschool Configuration Profile
/usr/bin/profiles -R -p com.lanschool.chrome.policy