package Zonemaster::GUI::Dancer::Export;

use warnings;
use 5.14.2;

use Dancer ':syntax';
use Plack::Builder;
use HTML::Entities;
use Zonemaster::GUI::Dancer::Client;

our $VERSION = '1.0.5';

my $backend_port = 5000;
$backend_port = $ENV{ZONEMASTER_BACKEND_PORT} if ($ENV{ZONEMASTER_BACKEND_PORT});
my $url = "http://localhost:$backend_port";

any [ 'get', 'post' ] => '/export' => sub {
    header( 'Cache-Control' => 'no-store, no-cache, must-revalidate' );
    my %allparams = params;
    no warnings 'uninitialized';

    if ( $allparams{'type'} eq 'HTML' ) {
		my $c              = Zonemaster::GUI::Dancer::Client->new( { url => $url } );
		my $test_result     = $c->get_test_results( { id => $allparams{'test_id'}, language => 'en' } );
		return "HELLO FROm Export";
=coment
		my $backend_params  = $test_result->{params};
		my $previous_module = '';
		my $template_params = params_backend2template( $backend_params );
		my @test_results;
		my $last_module_index = 0;
		my $module_type;
		my %severity = ( INFO => 0, NOTICE => 1, WARNING => 2, ERROR => 3 );

		foreach my $result ( @{ $test_result->{results} } ) {
			if ( $previous_module ne $result->{module} ) {
				push( @test_results, { is_module => 1, message => $result->{module} } );
				$test_results[$last_module_index]->{type} = lc( $module_type );
				$last_module_index                        = $#test_results;
				$previous_module                          = $result->{module};
				undef( $module_type );
			}
			$module_type = $result->{level} if ( $severity{$module_type} < $severity{ $result->{level} } );

			push( @test_results,
				{ is_module => 0, message => $result->{message}, type => lc( $result->{level} ) } );
		}
		$test_results[$last_module_index]->{type} = lc( $module_type );

		$template_params->{test_results}  = \@test_results;
		$template_params->{test_running}  = 0;
		$template_params->{test_id}       = $allparams{'test_id'};
		$template_params->{test_progress} = 100;
		template 'nojs_main_view', $template_params, { layout => undef };
=cut
    }
};

true;
