#!/usr/bin/perl -w

use strict;

my $AVAILABLEUPDATES="";

$AVAILABLEUPDATES=`/usr/sbin/softwareupdate --list`;
chomp $AVAILABLEUPDATES;

printf "	Available updates is: %s \n\n", "$AVAILABLEUPDATES";

# If available updates contains * there are updates available

if ($AVAILABLEUPDATES=~/\*/){
	printf "	There are updates available\n";
	
	if ($AVAILABLEUPDATES=~/(restart)|(shut\sdown)/){
		printf "	Updates need a restart\n";
		
		my $LOGGEDINUSER='';
		$LOGGEDINUSER=`/usr/bin/who | /usr/bin/grep console | /usr/bin/cut -d " " -f 1`;
		chomp $LOGGEDINUSER;
		printf "	Value of logged in user is: $LOGGEDINUSER\n";
		
		if ($LOGGEDINUSER=~/[a-zA-Z]/) {
			printf "as there is a logged in user checking whether ok to restart\n";
			my $RESPONSE = "";
			$RESPONSE=system '\'/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper\' -startlaunchd -windowType utility -icon \'/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/Resources/Message.png\' -heading "Software Updates are available" -description "Your computer will need to restart in a few minutes, would you like to install the updates now? Please wait for the next message before restarting. You can run updates at anytime by using Self Service in your Applications Folder." -button1 "Yes" -button2 "Cancel" -cancelButton "2"';

			if ($RESPONSE eq "0") {
				printf "\n	User said YES to Updates\n";
				system "jamf policy -trigger runsoftwareupdate";
				exit 0;

			} else {
				printf "\n	User said NO to Updates\n";
				exit 0;
			}

		} else {
			printf "	No logged in user so ok to run updates\n";
			system "jamf policy -trigger runsoftwareupdate";
			exit 0;
		}

	} else {
		printf "	No restart required\n";
		system "jamf policy -trigger runsoftwareupdate";
		exit 0;
	}
	
} else {
	printf "	There are no updates available\n";
	exit 0;
}

exit 0;