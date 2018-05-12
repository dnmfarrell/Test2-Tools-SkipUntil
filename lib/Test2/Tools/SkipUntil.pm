package Test2::Tools::SkipUntil;
use strict;
use warnings;
use Carp 'croak';
use Test2::API 'context';
use Time::Piece;

our $VERSION = 0.01;
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
  return $timepiece_now < $timepiece;
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
=head1 NAME

Test2::Tools::SkipUntil - skip tests until a date is reached

=head1 SYNOPSIS

  use Test2::Bundle::More
  use Test2::Tools::SkipUntil;

  SKIP: {
    skip_until "known fail see issue #213", 3, '2018-06-01';
    ...
  }

  ...

  done_testing;

=head1 DESCRIPTION

Exports two functions for skipping tests until a datetime is reached. Dates are
evaluated in C<localtime>.

=head1 FUNCTIONS

=head2 skip_until ($why, $num, $datetime)

Skips all tests in a C<SKIP> block, registering C<$num> skipped tests until
C<localtime> is greater than or equal to C<$datetime>.

C<$datetime> must be a scalar string in one of the following formats:

=over 4

=item *

  YYYY-MM-DDTHH:MM:SS - e.g. "2017-05-01T13:24:58"

=item *

  YYYY-MM-DD - e.g. "2017-05-01"

=back

=head2 skip_all_until ($why, $datetime)

Skips all tests by setting the test plan to zero, and exiting succesfully
unless C<localtime> is greater than or equal to C<$datetime>.

See L<#skip_all> for accepted C<$datetime> formats.

=head1 SOURCE

The source code repository for Test2-Tools-SkipUntil can be found on L<GitHub|https://github.com/dnmfarrell/Test2-Tools-SkipUntil>.

=head1 AUTHORS

David Farrell <dfarrell@cpan.org>

=head1 COPYRIGHT

Copyright 2018 David Farrell <dfarrell@cpan.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See L<licenses|http://dev.perl.org/licenses/>.

=cut
