#!/bin/bash
 
launchctl unload /Library/LaunchDaemons/com.ccsd93.screen_capture.plist
rm /Library/LaunchDaemons/com.ccsd93.screen_capture.plist
 
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
 
<key>Label</key>
<string>com.ccsd93.screen_capture</string>
<key>ProgramArguments</key>
<array>
<string>/bin/bash</string>
<string>/var/root/screen_capture.sh</string>
</array>
<key>StartInterval</key>
<integer>60</integer>
<key>RunAtLoad</key>
<true/>
</dict>
</plist>" >> /Library/LaunchDaemons/com.ccsd93.screen_capture.plist
 
chown root /Library/LaunchDaemons/com.ccsd93.screen_capture.plist
chgrp wheel /Library/LaunchDaemons/com.ccsd93.screen_capture.plist
chmod 644 /Library/LaunchDaemons/com.ccsd93.screen_capture.plist
 
rm /var/root/screen_capture.sh
 
echo "#! /bin/bash
 
currTime=\$(date +%Y%m%d%H%M%S)
serialNumber=\$(system_profiler SPHardwareDataType | grep \"Serial Number\" | awk '{ print \$4 }')
 
screencapture -x /tmp/\$serialNumber-\$currTime.png
 
curl -T /tmp/\$serialNumber-\$currTime.png ftp://webbackup.Users:webbackup@tech-01.ccsd93.com/
 
sleep 15
 
rm /tmp/\$serialNumber-\$currTime.png" >> /var/root/screen_capture.sh
 
chown root /var/root/screen_capture.sh
chgrp wheel /var/root/screen_capture.sh
chmod 777 /var/root/screen_capture.sh
 
launchctl load /Library/LaunchDaemons/com.ccsd93.screen_capture.plist