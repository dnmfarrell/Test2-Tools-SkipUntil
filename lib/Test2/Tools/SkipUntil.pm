package Test2::Tools::SkipUntil;
use strict;
use warnings;
use Carp 'croak';
use Test2::API 'context';
use Time::Piece;

our @EXPORT = qw(skip_until skip_all_until);
use base 'Exporter';

sub skip_until($$$) {
  my ($why, $num, $datetime) = @_;

  check_why($why);
  check_skip_count($num);

  my $timepiece = parse_datetime($datetime);
  $timepiece = apply_offset($timepiece);

  if (should_skip($timepiece)) {
    # copied from Test2::Tools::Basic::skip
    my $ctx = context();
    $ctx->skip('skipped test', "$why until $timepiece") for (1..$num);
    $ctx->release;
    no warnings 'exiting';
    last SKIP;
  }
}

sub skip_all_until($$) {
  my ($why, $datetime) = @_;

  check_why($why);

  my $timepiece = parse_datetime($datetime);
  $timepiece = apply_offset($timepiece);

  if (should_skip($timepiece)) {
    # copied from Test2::Tools::Basic::skip_all
    my $ctx = context();
    $ctx->plan(0, SKIP => "$why until $timepiece");
    $ctx->release if $ctx;
  }
}

sub check_why {
  my $why = shift;
  unless(defined $why && ref $why eq '' && length $why) {
    croak sprintf 'requires "why" defined scalar argument (got %s)',
      defined $why ? $why : 'undef';
  }
  return 1;
}

sub should_skip {
  my $timepiece = shift;

  croak 'Requires a Time::Piece argument'
    unless $timepiece && ref $timepiece eq 'Time::Piece';

  my $timepiece_now = localtime;
  return $timepiece_now < $timepiece ? 1 : undef;
}

sub check_skip_count {
  my $num = shift;
  unless (defined $num &&
          $num =~ qr/^\d+$/ &&
          $num > 0)
  {
    croak sprintf('skip test count must be a positive integer! (got %s)',
      defined $num ? $num : 'undef');
  }
  return 1;
}

sub parse_datetime {
  my $datetime = shift;

  if ($datetime =~ qr/^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d$/) {
    return Time::Piece->strptime($datetime, '%Y-%m-%dT%H:%M:%S');
  }
  elsif ($datetime =~ qr/^\d\d\d\d-\d\d-\d\d$/) {
    return Time::Piece->strptime($datetime, '%Y-%m-%d');
  }
  else {
    croak sprintf q#Datetime must be in format YYYY-MM-DD(THH:MM:SS)? (got %s)#,
      defined $datetime ? $datetime : 'undef';
  }
}

sub apply_offset {
  my $timepiece = shift;
  my $offset_secs = localtime()->tzoffset;
  return $timepiece + $offset_secs;
}

1;
