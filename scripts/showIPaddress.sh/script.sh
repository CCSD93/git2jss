#!/bin/bash
date
echo " -- Local IP addresses -- "
ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}'
echo " -- Public IP address -- "
curl --silent http://checkip.amazonaws.com/ | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'