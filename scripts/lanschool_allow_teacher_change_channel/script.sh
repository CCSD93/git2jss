#!/bin/sh

username=`/usr/bin/logname`

#echo ${username}

# /usr/bin/su -l ${username} -c "/bin/launchctl unload -S Aqua /Library/LaunchAgents/com.lanschool.student.plist"
# /usr/bin/su -l ${username} -c "/bin/launchctl unload -S Aqua /Library/LaunchAgents/com.lanschool.lsutil.plist"
launchctl unload /Library/LaunchDaemons/com.lanschool.lsdaemon.plist

/usr/bin/killall student
/usr/bin/killall Teacher


if [ -f /Library/Preferences/com.lanschool.teacher.settings.plist ];
then
   defaults write /Library/Preferences/com.lanschool.teacher.settings.plist EnableChannelSelect -bool TRUE
   defaults write /Library/Preferences/com.lanschool.teacher.settings.plist OneToOne 1
fi

if [ -f /Library/Preferences/com.lanschool.teacher.plist ];
then
   defaults write /Library/Preferences/com.lanschool.teacher.plist EnableChannelSelect -bool TRUE
   defaults write /Library/Preferences/com.lanschool.teacher.plist OneToOne 1
fi

launchctl load /Library/LaunchDaemons/com.lanschool.lsdaemon.plist
# /usr/bin/su -l ${username} -c "/bin/launchctl load -S Aqua /Library/LaunchAgents/com.lanschool.lsutil.plist"
# /usr/bin/su -l ${username} -c "/bin/launchctl load -S Aqua /Library/LaunchAgents/com.lanschool.student.plist"
