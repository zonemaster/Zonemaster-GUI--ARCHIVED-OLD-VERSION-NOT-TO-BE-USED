package Zonemaster::GUI::Dancer::Frontend;

use Dancer ':syntax';
use Plack::Builder;
use Data::Dumper;
use Encode qw[decode_utf8];
use Text::Markdown 'markdown';
use File::Slurp;
use HTTP::Tiny;

use Zonemaster::GUI::Dancer::Client;

our $VERSION = '1.0.1';
#my $url = 'http://zonemaster.rd.nic.fr:5000';
my $url = 'http://localhost:5000';

my $faq_url_base = 'https://raw.githubusercontent.com/dotse/zonemaster/master/docs/documentation/gui-faq-%s.md';
my %faqs;
my $http = HTTP::Tiny->new;
for my $lang (qw[sv en fr]) {
    my $r = $http->get(sprintf($faq_url_base, $lang));
    if ($r->{success} and $r->{headers}{'content-type'} eq 'text/plain; charset=utf-8') {
        $faqs{$lang} = decode_utf8($r->{content});
    }
    elsif ($r->{success}) {
        $faqs{$lang} = 'Unexpected content-type for FAQ: ' . $r->{headers}{'content-type'};
    } else {
        $faqs{$lang} = 'FAQ content missing.';
    }
}

set server_tokens => 0;

get '/' => sub {
  template 'index';
};

get '/ang/:file' => sub {
  template 'ang/'.param('file'),{},{layout => undef};
};

get '/test/:id' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $lang = request->{'accept_language'};
  $lang=~s/,.*$//;
  my $result = $c->get_test_results({ params, language=>$lang });
  template 'index', { result => to_json($result, {allow_blessed => 1, convert_blessed => 1}), test_id => param('id')};
};

get '/parent' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $result = $c->get_data_from_parent_zone( param('domain') );
#  debug Dumper($result);
  content_type 'application/json';
  return to_json ({ result => $result }, {allow_blessed => 1, convert_blessed => 1});
};

get '/version' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $result = $c->version_info({ });
  content_type 'application/json';
  my $ip = request->address;
  $ip =~ s/::ffff:// if ($ip =~ /::ffff:/);
  return to_json ({ result => $result . ", IP address: $ip" }, {allow_blessed => 1, convert_blessed => 1});
};

get '/check_syntax' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $data = from_json(encode_utf8(param('data'))); 
  my $result = $c->validate_syntax({ %$data });
#  debug Dumper($result);
  content_type 'application/json';
  return to_json ({ result => $result }, {allow_blessed => 1, convert_blessed => 1});
};

get '/history' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $data = from_json(encode_utf8(param('data'))); 
  my $result = $c->get_test_history({ frontend_params => { %$data }, limit=>200, offset=>0 });
  content_type 'application/json';
  return to_json ({ result => $result }, {allow_blessed => 1, convert_blessed => 1});
};

get '/resolve' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $data = param('data'); 
  my $result = $c->get_ns_ips( $data );
  content_type 'application/json';
  return to_json ({ result => $result }, {allow_blessed => 1, convert_blessed => 1});
};

post '/run' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $data = from_json(encode_utf8(param('data'))); 
  $data->{client_id} = 'Zonemaster Dancer Frontend';
  $data->{client_version} = $VERSION;
  my $job_id = $c->start_domain_test({ %$data });
  content_type 'application/json';
  return to_json ({ job_id => $job_id }, {allow_blessed => 1, convert_blessed => 1});
};

get '/progress' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $progress = $c->test_progress(param('id'));
  header('Cache-Control' =>  'no-store, no-cache, must-revalidate');
  content_type 'application/json';
  return to_json ({ progress => $progress }, {allow_blessed => 1, convert_blessed => 1});
};

get '/result' => sub {
  my $c = Zonemaster::GUI::Dancer::Client->new({url => $url });
  
  my $result = $c->get_test_results({ params });
  content_type 'application/json';
  return to_json ({ result => $result }, {allow_blessed => 1, convert_blessed => 1});
};

get '/faq' => sub {
	my %allparams = params;
	my $md = $faqs{ $allparams{lang} };
	my $html = markdown($md);
	$html =~ s/<a/<a style="color: white;"/isg;
	$html =~ s/<h4/<br><h4/isg;
	return to_json ({ FAQ_CONTENT => $html }, {allow_blessed => 1, convert_blessed => 1});
};

true;
