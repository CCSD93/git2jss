#!/bin/bash

# From https://www.jamf.com/jamf-nation/discussions/26615/xcode-9-2-deployment#responseChild158119

# Accept EULA so there is no prompt
if [[ -e "/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild" ]]; then
  echo "$(date)- Accepting EULA"
  "/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild" -license accept
fi

# Just in case the xcodebuild command above fails to accept the EULA, set the license acceptance info 
# in /Library/Preferences/com.apple.dt.Xcode.plist. For more details on this, see Tim Sutton's post: 
# http://macops.ca/deploying-xcode-the-trick-with-accepting-license-agreements/
if [[ -e "/Applications/Xcode.app/Contents/Resources/LicenseInfo.plist" ]]; then
   echo "$(date)-Manually setting license acceptance in com.apple.dt.Xcode.plist"
   xcode_version_number=`/usr/bin/defaults read "/Applications/Xcode.app/Contents/"Info CFBundleShortVersionString`
   xcode_build_number=`/usr/bin/defaults read "/Applications/Xcode.app/Contents/Resources/"LicenseInfo licenseID`
   xcode_license_type=`/usr/bin/defaults read "/Applications/Xcode.app/Contents/Resources/"LicenseInfo licenseType`

   if [[ "${xcode_license_type}" == "GM" ]]; then
       /usr/bin/defaults write "/Library/Preferences/"com.apple.dt.Xcode IDEXcodeVersionForAgreedToGMLicense "$xcode_version_number"
       /usr/bin/defaults write "/Library/Preferences/"com.apple.dt.Xcode IDELastGMLicenseAgreedTo "$xcode_build_number"
    else
       /usr/bin/defaults write "/Library/Preferences/"com.apple.dt.Xcode IDEXcodeVersionForAgreedToBetaLicense "$xcode_version_number"
       /usr/bin/defaults write "/Library/Preferences/"com.apple.dt.Xcode IDELastBetaLicenseAgreedTo "$xcode_build_number"
   fi       
fi

# DevToolsSecurity tool to change the authorization policies, such that a user who is a
# member of either the admin group or the _developer group does not need to enter an additional
# password to use the Apple-code-signed debugger or performance analysis tools.
echo "$(date)-Enabling DevToolsSecurity"
/usr/sbin/DevToolsSecurity -enable

# Add all users to developer group, if they're not admins
echo "$(date)-Adding everyone to the _developer group"
/usr/sbin/dseditgroup -o edit -a everyone -t group _developer

# Bypass Gatekeeper verification for Xcode, which can take hours.
if [[ -e "/Applications/Xcode.app" ]]; then 
	echo "$(date)-Bypassing Gatekeeper verification for Xcode"
	xattr -dr com.apple.quarantine /Applications/Xcode.app
fi

# Install Mobile Device Packages so there are no prompts
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg" ]]; then
  echo "$(date)-Installing MobileDevice.pkg"
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg" -target /
fi

if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg" ]]; then
  echo "$(date)-Installing MobileDeviceDevelopment.pkg"
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg" -target /
fi

# Install XcodeExtensionSupport.pkg
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/XcodeExtensionSupport.pkg" ]]; then
  echo "$(date)-Installing XcodeExtensionsSupport.pkg"
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/XcodeExtensionSupport.pkg" -target /
fi

# Install XcodeSystemResources.pkg
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/XcodeSystemResources.pkg" ]]; then
  echo "$(date)-Installing Xcode System Resources.pkg"
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/XcodeSystemResources.pkg" -target /
fi

# Install Command Line Tools.
if [[ /usr/bin/xcode-select ]]; then
    echo "$(date)- Installing xcode-select command line tools"
    /usr/bin/xcode-select --install
fi

# If you have multiple versions of Xcode installed, specify which one you want to be current.
echo "$(date)- Setting Xcode app to use"
/usr/bin/xcode-select --switch /Applications/Xcode.app

# Allow any member of _developer to install Apple-provided software.
# be sure you really want to do this.
echo "$(date)- Allow any member of _developer to install Apple-provided software"
/usr/bin/security authorizationdb write system.install.apple-software authenticate-developer

echo "$(date)- Xcode Post Install script complete"