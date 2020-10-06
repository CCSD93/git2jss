#!/bin/bash

# This script downloads and installs the latest Flash player for compatible Macs
# https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/install_latest_adobe_flash_player

if [ -e "CocoaDialog.app/Contents/MacOS/CocoaDialog" ]; then
	COCOA="CocoaDialog.app/Contents/MacOS/CocoaDialog"
else
	COCOA="/Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog"
fi

# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

# Determine current major version of Adobe Flash for use
# with the fileURL variable

flash_version=`/usr/bin/curl --silent http://fpdownload2.macromedia.com/get/flashplayer/update/current/xml/version_en_mac_pl.xml | sed -n 's/.*update version="\([^"]*\).*/\1/p' | sed 's/,/./g'`

# Specify the complete address of the Adobe Flash Player
# disk image

fileURL="https://fpdownload.adobe.com/get/flashplayer/pdc/"$flash_version"/install_flash_player_osx.dmg"

# Specify name of downloaded disk image

flash_dmg="/tmp/flash.dmg"


echo .
echo "Checking the installed version of Flash Player on this Mac..."
## Get the currently installed version of FlashPlayer
if [[ -e "/Library/Internet Plug-Ins/Flash Player.plugin" ]]; then
    FP_installedVers=$( /usr/bin/defaults read "/Library/Internet Plug-Ins/Flash Player.plugin/Contents/Info" CFBundleShortVersionString )
    echo -e "Installed Flash Player plug-in version is: ${FP_installedVers}"
    echo -e "Available Flash Player plug-in version is: ${flash_version}\n\n"
fi
echo .

 if [[ "${FP_installedVers}" != "${flash_version}" ]]; then

    # Download the latest Adobe Flash Player software disk image

    /usr/bin/curl --output "$flash_dmg" "$fileURL"

    # Specify a /tmp/flashplayer.XXXX mountpoint for the disk image
 
    TMPMOUNT=`/usr/bin/mktemp -d /tmp/flashplayer.XXXX`

    # Mount the latest Flash Player disk image to /tmp/flashplayer.XXXX mountpoint
 
    hdiutil attach "$flash_dmg" -mountpoint "$TMPMOUNT" -nobrowse -noverify -noautoopen
    
    # Install Adobe Flash Player using the installer package. This installer may
    # be stored inside an install application on the disk image, or there may be
    # an installer package available at the root of the mounted disk image.

    if [[ -e "$(/usr/bin/find $TMPMOUNT -maxdepth 1 \( -iname \*Flash*\.pkg -o -iname \*Flash*\.mpkg \))" ]]; then    
      pkg_path="$(/usr/bin/find $TMPMOUNT -maxdepth 1 \( -iname \*Flash*\.pkg -o -iname \*Flash*\.mpkg \))"
    elif [[ -e "$(/usr/bin/find $TMPMOUNT -maxdepth 1 \( -iname \*\.app \))" ]]; then
         adobe_app=`(/usr/bin/find $TMPMOUNT -maxdepth 1 \( -iname \*\.app \))`
        if [[ -e "$(/usr/bin/find "$adobe_app"/Contents/Resources -maxdepth 1 \( -iname \*Flash*\.pkg -o -iname \*Flash*\.mpkg \))" ]]; then
          pkg_path="$(/usr/bin/find "$adobe_app"/Contents/Resources -maxdepth 1 \( -iname \*Flash*\.pkg -o -iname \*Flash*\.mpkg \))"
        fi
    fi

    # Before installation on Mac OS X 10.7.x and later, the installer's
    # developer certificate is checked to see if it has been signed by
    # Adobe's developer certificate. Once the certificate check has been
    # passed, the package is then installed.

    if [[ ${pkg_path} != "" ]]; then
       if [[ ${osvers} -ge 7 ]]; then
         signature_check=`/usr/sbin/pkgutil --check-signature "$pkg_path" | awk /'Developer ID Installer/{ print $5 }'`
         if [[ ${signature_check} = "Adobe" ]]; then
           # Install Adobe Flash Player from the installer package stored inside the disk image
           /usr/sbin/installer -dumplog -verbose -pkg "${pkg_path}" -target "/"
         fi
       fi

    # On Mac OS X 10.6.x, the developer certificate check is not an
    # available option, so the package is just installed.
    
       if [[ ${osvers} -eq 6 ]]; then
           # Install Adobe Flash Player from the installer package stored inside the disk image
           /usr/sbin/installer -dumplog -verbose -pkg "${pkg_path}" -target "/"
       fi
    fi

    echo .
    echo "Checking the installed version of Flash Player on this Mac..."
    ## Get the currently installed version of FlashPlayer
    if [[ -e "/Library/Internet Plug-Ins/Flash Player.plugin" ]]; then
	    FP_installedVers=$( /usr/bin/defaults read "/Library/Internet Plug-Ins/Flash Player.plugin/Contents/Info" CFBundleShortVersionString )
	    echo "Installed Flash Player plug-in version is: ${FP_installedVers}..."
    fi
    echo .

    # Clean-up
    # Unmount the Flash Player disk image from /tmp/flashplayer.XXXX
 
    /usr/bin/hdiutil detach "$TMPMOUNT"
 
    # Remove the /tmp/flashplayer.XXXX mountpoint
 
    /bin/rm -rf "$TMPMOUNT"

    # Remove the downloaded disk image

    /bin/rm -rf "$flash_dmg"
else 
    echo "Adobe Flash is already at the current version"
#    ${COCOA} textbox --title "Adobe Flash Update" --button1 "Okay" --height 150 --text "Adobe Flash is already at the current version"
fi

#Disable Auto Update
directory="/Library/Application Support/Macromedia/"
file="/Library/Application Support/Macromedia/mms.cfg"

if [ -f "$file" ] ; then
    # Flash Player is installed, has been launched and mms.cfg exists
    # let's configure it to not update

    grep -q -r "AutoUpdateDisable" "$file" && sed -i '' 's/AutoUpdateDisable=0|AutoUpdateDisable=1/AutoUpdateDisable=1/g' "$file" || echo 'AutoUpdateDisable=1' >> "$file"
    grep -q -r "SilentAutoUpdateEnable" "$file" && sed -i '' 's/SilentAutoUpdateEnable=0|SilentAutoUpdateEnable=1/SilentAutoUpdateEnable=0/g' "$file" || echo "SilentAutoUpdateEnable=0" >> "$file"
    grep -q -r "DisableAnalytics" "$file" && sed -i '' 's/DisableAnalytics=0|DisableAnalytics=1/DisableAnalytics=1/g' "$file" || echo "DisableAnalytics=1" >> "$file"

    echo "Disabled Auto Update"
else
    # mms.cfg doesn't exsist

    mkdir "${directory}"

    echo "AutoUpdateDisable=1" >> "$file"
    echo "SilentAutoUpdateEnable=0" >> "$file"

    echo "Created and Disabled Auto Update"
fi

exit 0