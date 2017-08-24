package ExchangeRater::Converter;

use strict;
use warnings;

use ExchangeRater::Rates;

sub new {
  my $class = shift;
  my $opts = shift || { };

  return bless {
    rates => ExchangeRater::Rates->new( {
      cache => $opts->{cache},
      on_message => $opts->{on_message},
    } )
  }, $class;
}

sub rates { shift->{rates}->rates }

sub has_symbol {
  my $self = shift;
  my $symbol = shift;

  return exists($self->rates->{$symbol});
}

sub convert {
  my $self = shift;
  my ($amount, $from, $to) = @_;

  return $amount * $self->rates->{$to} / $self->rates->{$from};
}

1;
