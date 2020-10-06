#!/bin/sh

username=`/usr/bin/logname`

#echo ${username}

/usr/bin/su -l ${username} -c "/bin/launchctl unload -S Aqua /Library/LaunchAgents/com.lanschool.student.plist"
/usr/bin/su -l ${username} -c "/bin/launchctl unload -S Aqua /Library/LaunchAgents/com.lanschool.lsutil.plist"
launchctl unload /Library/LaunchDaemons/com.lanschool.lsdaemon.plist

/usr/bin/killall student

defaults write /Library/Preferences/com.lanschool.student.settings.plist $4 "$5"

launchctl load /Library/LaunchDaemons/com.lanschool.lsdaemon.plist
/usr/bin/su -l ${username} -c "/bin/launchctl load -S Aqua /Library/LaunchAgents/com.lanschool.lsutil.plist"
/usr/bin/su -l ${username} -c "/bin/launchctl load -S Aqua /Library/LaunchAgents/com.lanschool.student.plist"
