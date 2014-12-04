use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Zonemaster_Dancer',
    DISTVNAME		=> 'Zonemaster_Dancer',
    AUTHOR              => q{YOUR NAME <youremail@example.com>},
    VERSION_FROM        => 'lib/dnscheck.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Starman' => 0,
        'LWP::UserAgent' => 0,
        'Time::HiRes' => 0,
        'Plack::Builder' => 0,
        'Text::Markdown' => 0,
        'File::Slurp' => 0,
        'FindBin' => 0,
        'HTML::Entities' => 0,
        'Plack::App::File' => 0,
        'JSON' => 0,
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3095,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'dnscheck-*' },
);
