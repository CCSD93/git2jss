#!/bin/bash
#New User docutil setup by Shaquir Tannis
/usr/local/bin/dockutil.py --remove all --allhomes --no-restart
/usr/local/bin/dockutil.py --add /Applications/Siri.app --position 1 --allhomes --no-restart '/System/Library/User Template/English.lproj'
/usr/local/bin/dockutil.py --add /Applications/Launchpad.app --position 2 --allhomes --no-restart '/System/Library/User Template/English.lproj'
/usr/local/bin/dockutil.py --add /Applications/Safari.app --position 3 --allhomes --no-restart '/System/Library/User Template/English.lproj'
/usr/local/bin/dockutil.py --add /Applications/Google\ Chrome.app --position 4 --allhomes --no-restart '/System/Library/User Template/English.lproj'
/usr/local/bin/dockutil.py --add /Applications/Firefox.app --position 5 --allhomes --no-restart '/System/Library/User Template/English.lproj'
/usr/local/bin/dockutil.py --add /Applications/Self\ Service.app --position 6 --allhomes --no-restart '/System/Library/User Template/English.lproj'
/usr/local/bin/dockutil.py --add /Applications/System\ Preferences.app --position 7 --allhomes --no-restart '/System/Library/User Template/English.lproj'
/usr/local/bin/dockutil.py --add /Applications/Photos.app --position 8 --allhomes --no-restart '/System/Library/User Template/English.lproj'

/usr/local/bin/dockutil.py --add '/Applications' --view auto --display folder --sort name  --section others --position 1 --allhomes --no-restart '/System/Library/User Template/English.lproj'
/usr/local/bin/dockutil.py --add '~/Downloads' --view auto --display stack --sort dateadded --section others --position end --allhomes --no-restart '/System/Library/User Template/English.lproj'