#!/bin/bash

find -s /Applications -maxdepth 1 -mindepth 1 -type d -not -name "Self Service.app"  -exec rm -rfv {} \;

find -s / -maxdepth 1 -mindepth 1 -type d -not -name "Applications" -not -name "Users" -not -name "Volumes" -exec rm -rfv {} \;

shutdown -h now
