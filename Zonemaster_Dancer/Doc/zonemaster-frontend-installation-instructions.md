#Zonemaster Frontend Installation instructions
	1. Copy the whole Zonemaster_Dancer folder to a folder named "zonemaster-gui" (ex: /usr/share/zonemaster_distribution/zonemaster-gui/Zonemaster_Dancer/).
	2. Run: 'perl Makefile.PL' and install the dependencies
	3. Run the frontend with the Starman application server (assuming pwd=Zonemaster_Dancer): 
		sudo starman --port=80 bin/app.pl
		or in perlbrew enviromnemnts
		sudo /home/toma/perl5/perlbrew/perls/perl-5.20.0/bin/perl /home/toma/perl5/perlbrew/perls/perl-5.20.0/bin/starman --error-log=/var/log/zonemaster/frontend_starman.log --port=80 bin/app.pl

# Zonemaster Frontend Installation instructions

The documentation covers the following operating systems:

 * Plateform independant installation instructions
 * Debian 7.8

## Zonemaster Frontend installation

### Plateform independant installation

**Install git**

Whatever is needed on your distribution

**Clone the git repository**

    $ git clone https://github.com/dotse/zonemaster-gui.git

**install the dependencies with perl CPAN**

    $ (sudo if needed) cpan -i Starman Template LWP::UserAgent Time::HiRes Plack::Builder Text::Markdown File::Slurp FindBin HTML::Entities Plack::App::File JSON Test::More YAML Dancer
    
**Create a .tgz package of the software**

    $ cd zonemaster-gui
    $ perl Makefile.PL
    $ make test
    $ make dist
    
**decompress the generated .tgz package in production location or continue directly from the git repository**

**start the frontend using a perl application server (tested with starman)**

    $ cd zonemaster-gui/Zonemaster_Dancer
    $ sudo starman --port=80 bin/app.pl
or in perlbrew enviromnemnts
    $ sudo /home/user/perl5/perlbrew/perls/perl-5.20.0/bin/perl /home/user/perl5/perlbrew/perls/perl-5.20.0/bin/starman --error-log=/var/log/zonemaster/frontend_starman.log --port=80 bin/app.pl

### Instructions for Debian 7.8

**To get the source code**

    $ sudo apt-get install git build-essential
    $ git clone https://github.com/dotse/zonemaster-gui.git

**Install package dependencies**

    $ sudo apt-get install starman libtemplate-perl libplack-perl libtext-markdown-perl libfile-slurp-perl ibhtml-parser-perl libjson-perl libyaml-perl libdancer-perl

**Create a .tgz package of the software**

    $ cd zonemaster-gui
    $ perl Makefile.PL
    $ make test
    $ make dist

**start the frontend using a perl application server (tested with starman)**

    $ cd zonemaster-gui/Zonemaster_Dancer
    $ sudo starman --port=80 bin/app.pl
or in perlbrew enviromnemnts
    $ sudo /home/user/perl5/perlbrew/perls/perl-5.20.0/bin/perl /home/user/perl5/perlbrew/perls/perl-5.20.0/bin/starman --error-log=/var/log/zonemaster/frontend_starman.log --port=80 bin/app.pl
 