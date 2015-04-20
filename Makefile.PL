use strict;
use warnings;
use ExtUtils::MakeMaker;

sub MY::install {
    "install ::\n\t\$(info This makefile only supports the 'make dist', target)"
}

WriteMakefile(
    NAME                => 'Zonemaster_Dancer',
    DISTVNAME		=> 'Zonemaster_Dancer',
    AUTHOR              => q{Michal TOMA <toma@nic.fr>},
    VERSION_FROM        => 'lib/Zonemaster/GUI/Dancer/Frontend.pm',
    ABSTRACT            => 'The Zonemaster project Web Frontend',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Starman' => 0,
        'Template' => 0,
        'LWP::UserAgent' => 0,
        'Time::HiRes' => 0,
        'Plack::Builder' => 0,
        'Text::Markdown' => 0,
        'File::Slurp' => 0,
        'HTML::Entities' => 0,
        'JSON' => 0,
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3095,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Zonemaster_Dancer-*' },
);
