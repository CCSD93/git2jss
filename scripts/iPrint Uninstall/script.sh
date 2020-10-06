#!/bin/bash

if [ -f /Applications/iPrint\ Uninstallation.app/Contents/MacOS/iPrint\ Uninstallation ]; then
	/Applications/iPrint\ Uninstallation.app/Contents/MacOS/iPrint\ Uninstallation
elif [ -f /Applications/iPrint\ Uninstallation.app/Contents/MacOS/applet ]; then
		/Applications/iPrint\ Uninstallation.app/Contents/MacOS/applet
fi