#!/bin/bash

#Unmanage Mac
# echo "$(date "+%m%d%Y %T") : Unmanaging the Mac" >> $LOGFILE
apiuser="apiaccess"
apipass="ccsd93apiaccess"
jssURL="https://jss-01.ccsd93.com:8443/JSSResource/computers/macaddress"

MAC=$( /usr/sbin/networksetup -getmacaddress en0 | awk '{print $3}' | sed 's/:/./g' )

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<computer>
<general>
<remote_management>
<managed>false</managed>
</remote_management>
</general>
</computer>" > /private/tmp/unmanage_xml.xml

# echo "$(date "+%m%d%Y %T") : Sending curl command to unmanage $MAC" >> $LOGFILE
curl -fk -u "$apiuser:$apipass" "${jssURL}/${MAC}" -o /var/log/unmanage.log -T /private/tmp/unmanage_xml.xml -X PUT