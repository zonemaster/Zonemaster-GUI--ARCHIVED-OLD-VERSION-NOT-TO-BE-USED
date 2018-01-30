use strict;
use warnings;
use inc::Module::Install;

name 'Zonemaster-GUI';
all_from 'lib/Zonemaster/GUI.pm';
repository 'https://github.com/dotse/zonemaster-gui';
bugtracker 'https://github.com/dotse/zonemaster-gui/issues';

makemaker_args(
    PL_FILES  => {},
    PREREQ_PM => {
        'Starman'        => 0,
        'Template'       => 0,
        'LWP::UserAgent' => 0,
        'Time::HiRes'    => 0,
        'Plack::Builder' => 0,
        'Text::Markdown' => 0,
        'HTML::Entities' => 0,
        'JSON'           => 0,
        'Test::More'     => 0,
        'YAML'           => 0,
        'Dancer'         => 1.3095,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Zonemaster_Dancer-*' },
);

install_share 'zm_app';

WriteAll;
