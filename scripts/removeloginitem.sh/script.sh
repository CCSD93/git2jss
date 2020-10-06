#!/bin/sh
#theApp="LanSchool Teacher"
#nl=`echo "x" | tr 'x' '\34'`     # what is the proper way to set ascii to a variable?
#aaa=`defaults read /Library/Preferences/com.apple.loginitems.plist privilegedlist`
#bbb=`echo -n "$aaa" | sed "s/^[()]$//;s/},/}$nl/" | tr '\n\34' '\00\n'| grep -va "$theApp" | tr '\n\00' ',\n' | sed 's/^,$//'`
#echo $aaa
#echo $bbb
#defaults write /Library/Preferences/com.apple.loginitems.plist privilegedlist "($bbb)"

rm /Library/Preferences/com.apple.loginitems.plist