#!/usr/bin/osascript

on run
	set user to (do shell script "/usr/bin/logname")
	set newVar to first character of user
	
	set adminName to "ccsd93admin"
	
	if newVar = 1 then
		set adminPassword to "NoKidsShouldHaveThi$"
	else
		set adminPassword to "ccsd93desktop"
	end if
	
	tell application "Finder"
		set NoOfFiles to count of (files in (path to desktop) whose name extension is "pcap")
		set capName to POSIX path of (path to desktop) & "capture-" & NoOfFiles + 1 & ".pcap" as text
	end tell

	# display dialog adminpassword buttons {"Ok"} default button 1

	set displayString to "How many minutes should the capture run?"
	set defaultAnswer to 5
	repeat
		set response to display dialog displayString default answer defaultAnswer
		try
			set timeMinutes to (text returned of response) as number
			exit repeat
		on error errstr
			set displayString to errstr & return & "Please try again."
		end try
	end repeat
	
	display dialog "Start " & timeMinutes & " minute Network Capture to: " & return & capName buttons {"Ok"} default button 1
	
	set the_ips to (do shell script "/usr/sbin/tcpdump -n -w " & capName & " -Z " & user & " &>/dev/null  &" user name adminName password adminPassword with administrator privileges)
	
#	display dialog "Network Capture Running - Click Ok and Start your network activity" buttons {"Ok"} default button 1
	
	set timeSeconds to timeMinutes * 60
	
	delay timeSeconds
	#delay 300 # default 5 minutes
	#delay 10 # 10 seconds for testing
	
	set the_ips to (do shell script "pkill -HUP -f /usr/sbin/tcpdump" user name adminName password adminPassword with administrator privileges)
	
	display dialog "Network Capture Complete" buttons {"Ok"} default button 1
end run
