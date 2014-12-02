#Zonemaster Frontend Installation instructions
	1. Copy the whole Zonemaster_Dancer folder to some place.
	2. Run the frontend with the Starman application server (assuming pwd=Zonemaster_Dancer): 
		sudo starman --port=80 bin/app.pl
		or in perlbrew enviromnemnts
		sudo /home/toma/perl5/perlbrew/perls/perl-5.20.0/bin/perl /home/toma/perl5/perlbrew/perls/perl-5.20.0/bin/starman --error-log=/var/log/zonemaster/frontend_starman.log --port=80 bin/app.pl
		