#!/usr/bin/env perl
use Dancer;
use Plack::Builder;
use Plack::App::File;

use Zonemaster::GUI::Dancer::Frontend;
use Zonemaster::GUI::Dancer::NoJsFrontend;


my $app = sub {
    my $env = shift;
    my $request = Dancer::Request->new( env => $env );
    Dancer->dance($request);
};

builder {
    mount "/" => builder {$app};
};
