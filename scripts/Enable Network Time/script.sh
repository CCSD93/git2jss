#!/bin/bash

systemsetup -setusingnetworktime on
systemsetup -settimezone America/Chicago
systemsetup -setnetworktimeserver time.apple.com
ntpdate -u time.apple.com
