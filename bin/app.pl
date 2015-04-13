#!/usr/bin/env perl
use Dancer;
use Plack::Builder;
use Plack::App::File;
use FindBin qw($RealScript $Script $RealBin $Bin);;

##################################################################
my $PROJECT_NAME = "zonemaster-gui";

my $SCRITP_DIR = __FILE__;
$SCRITP_DIR = $Bin unless ($SCRITP_DIR =~ /^\//);

my ($PROD_DIR) = ($SCRITP_DIR =~ /(.*?\/)$PROJECT_NAME/);

my $PROJECT_BASE_DIR = $PROD_DIR.$PROJECT_NAME."/";
unshift(@INC, $PROJECT_BASE_DIR);
##################################################################

unshift(@INC, $PROD_DIR."lib") unless $INC{$PROD_DIR."lib"};
require Zonemaster::GUI::Dancer::Frontend;
require Zonemaster::GUI::Dancer::NoJsFrontend;


my $app = sub {
    my $env = shift;
    my $request = Dancer::Request->new( env => $env );
    Dancer->dance($request);
};

builder {
    mount "/" => builder {$app};
};
