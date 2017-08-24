package ExchangeRater::Rates;

use strict;
use warnings;

use XML::LibXML;
use LWP::UserAgent;
use IO::File;
use File::Temp qw(tempfile);

my $ECB_CURRENT_URL = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml?e9631271aeca7311b46c2f98a7932b06';

sub new {
  my $class = shift;
  my $opts  = shift;

  return bless {
    rates => { },
    on_message => $opts->{on_message} || sub {  },
    cache => $opts->{cache},
    cache_max_age => $opts->{cache_max_age} || 3600*24,
  }, $class;
}

sub on_message { shift->{on_message} = shift }

sub rates {
  my $self = shift;

  $self->_set_rates_from_cache || $self->_set_rates_from_internet
    unless(keys(%{$self->{rates}}));

  return $self->{rates};
}

sub _set_rates_from_cache {
  my $self = shift;
  return unless($self->{cache});
  return if(-z $self->{cache});

  my @stat = stat($self->{cache});
  return if($stat[9] < time() - $self->{cache_max_age});

  my $fh = IO::File->new($self->{cache}, 'r');
  return $self->parse_xml($fh);
}

sub _set_rates_from_internet {
  my $self = shift;
  my $ua = LWP::UserAgent->new();
  my $fh = $self->_get_fh;

  $self->{on_message}->('Refreshing rates...');

  my $rsp = $ua->get($ECB_CURRENT_URL,
    ':content_cb' => sub { $fh->print(shift) }
  );

  unless($rsp->is_success) {
    $self->{on_message}->("Bad response from ECB: " . $self->status_line, 1);
    die "HTTP request failed: " . $self->status_line;
  }

  seek($fh, 0, 0);
  return $self->parse_xml($fh);
}


sub parse_xml {
  my $self = shift;
  my $fh   = shift;

  my $doc = XML::LibXML->load_xml({ IO => $fh });
  my $xpc = XML::LibXML::XPathContext->new($doc);
     $xpc->registerNs(ecb => 'http://www.ecb.int/vocabulary/2002-08-01/eurofxref');

  $xpc->findnodes('//ecb:Cube[@currency]')->map(sub {
    $self->{rates}->{$_->getAttribute('currency')} = $_->getAttribute('rate')
  });
}

sub _get_fh {
  my $self = shift;
  if($self->{cache}) {
    return IO::File->new($self->{cache}, 'w+');
  } else {
    return tempfile( UNLINK => 1 );
  }
}

1;
