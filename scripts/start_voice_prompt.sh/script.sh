#!/bin/bash
 
if [ -e /Library/LaunchAgents/com.ccsd93.voice_prompt.plist ]; then 
	launchctl unload /Library/LaunchAgents/com.ccsd93.voice_prompt.plist
	rm /Library/LaunchAgents/com.ccsd93.voice_prompt.plist
fi
 
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
 
<key>Label</key>
<string>com.ccsd93.voice_prompt</string>
<key>ProgramArguments</key>
<array>
<string>/usr/bin/open</string>
<string>/Applications/VoicePrompt.app</string>
</array>
<key>StartInterval</key>
<integer>30</integer>
<key>RunAtLoad</key>
<true/>
</dict>
</plist>" >> /Library/LaunchAgents/com.ccsd93.voice_prompt.plist
 
chown root /Library/LaunchAgents/com.ccsd93.voice_prompt.plist
chgrp wheel /Library/LaunchAgents/com.ccsd93.voice_prompt.plist
chmod 644 /Library/LaunchAgents/com.ccsd93.voice_prompt.plist
 
launchctl load /Library/LaunchAgents/com.ccsd93.voice_prompt.plist