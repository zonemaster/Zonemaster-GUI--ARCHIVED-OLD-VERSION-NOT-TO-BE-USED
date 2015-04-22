package Zonemaster::GUI::Dancer::Frontend;

use 5.14.2;
use warnings;

use Encode qw[decode_utf8];

our $VERSION = '1.0.1';

###
### Fetch the FAQ source documents
###

use Text::Markdown 'markdown';
use HTTP::Tiny;

my $faq_url_base = 'https://raw.githubusercontent.com/dotse/zonemaster/master/docs/documentation/gui-faq-%s.md';
my %faqs;
my $http = HTTP::Tiny->new;
for my $lang ( qw[sv en fr] ) {
    my $r = $http->get( sprintf( $faq_url_base, $lang ) );
    if ( $r->{success} and $r->{headers}{'content-type'} eq 'text/plain; charset=utf-8' ) {
        $faqs{$lang} = markdown( decode_utf8( $r->{content} ) );
        $faqs{$lang} =~ s/<a/<a style="color: white;"/isg;
        $faqs{$lang} =~ s/<h4/<br><h4/isg;
    }
    elsif ( $r->{success} ) {
        $faqs{$lang} = 'Unexpected content-type for FAQ: ' . $r->{headers}{'content-type'};
    }
    else {
        $faqs{$lang} = 'FAQ content missing.';
    }
}

###
### Proceed with Dancer stuff
###

use Dancer ':syntax';
use Zonemaster::GUI::Dancer::Client;

my $url = 'http://localhost:5000';
my $client = Zonemaster::GUI::Dancer::Client->new( { url => $url } );

get '/' => sub {
    template 'index';
};

get '/test/:id' => sub {
    my $lang = request->{'accept_language'};
    $lang =~ s/,.*$//;
    my $result = $client->get_test_results( { params, language => $lang } );
    template 'index',
      { result => to_json( $result ), test_id => param( 'id' ) };
};

get '/parent' => sub {
    my $result = $client->get_data_from_parent_zone( param( 'domain' ) );
    content_type 'application/json';
    return to_json( { result => $result } );
};

get '/version' => sub {
    my $result = $client->version_info( {} );
    content_type 'application/json';
    my $ip = request->address;
    $ip =~ s/::ffff:// if ( $ip =~ /::ffff:/ );
    return to_json( { result => $result . ", IP address: $ip" } );
};

get '/check_syntax' => sub {
    my $data = from_json( param( 'data' ) );
    my $result = $client->validate_syntax( {%$data} );
    content_type 'application/json';
    return to_json( { result => $result } );
};

get '/history' => sub {
    my $data = from_json( param( 'data' ) );
    my $result = $client->get_test_history( { frontend_params => {%$data}, limit => 200, offset => 0 } );
    content_type 'application/json';
    return to_json( { result => $result } );
};

get '/resolve' => sub {
    my $data   = param( 'data' );
    my $result = $client->get_ns_ips( $data );
    content_type 'application/json';
    return to_json( { result => $result } );
};

post '/run' => sub {
    my $data = from_json( param( 'data' ) );
    $data->{client_id}      = 'Zonemaster Dancer Frontend';
    $data->{client_version} = __PACKAGE__->VERSION;
    my $job_id = $client->start_domain_test( {%$data} );
    content_type 'application/json';
    return to_json( { job_id => $job_id } );
};

get '/progress' => sub {
    my $progress = $client->test_progress( param( 'id' ) );
    header( 'Cache-Control' => 'no-store, no-cache, must-revalidate' );
    content_type 'application/json';
    return to_json( { progress => $progress } );
};

get '/result' => sub {
    my $result = $client->get_test_results( {params} );
    content_type 'application/json';
    return to_json( { result => $result } );
};

get '/faq' => sub {
    return to_json( { FAQ_CONTENT => $faqs{ param('lang') } } );
};

true;
