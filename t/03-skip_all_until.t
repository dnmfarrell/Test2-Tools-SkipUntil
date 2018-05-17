#!/usr/bin/perl
use strict;
use warnings;
use Test2::Tools::Basic;
use Test2::Tools::Compare;

plan(2);

my $one_liners = [
  [q(skip_all_until "skip_all", "2037-01-01"; die "did not skip all!"), 0, "2037 - skip all"],
  [q(skip_all_until "skip_all", "1995-01-01"; die "did not skip all!"), 255, "1995 - do not skip all"],
];

for (@$one_liners) {
  my ($program, $expected, $reason) = @$_;

  my $oldout = redirect_output();
  system $^X, '-Ilib', '-MTest2::Tools::SkipUntil','-e', $program;
  restore_output($oldout);

  is $? >> 8, $expected, $reason;
}

sub redirect_output {
  open my $oldout, ">&", \*STDOUT or die "Can't preserve STDOUT $!";
  close STDOUT;
  open STDOUT, ">", '/dev/null' or die "Can't redirect STDOUT $!";
  return $oldout;
}

sub restore_output {
  my ($oldout) = @_;
  open STDOUT, ">&", \*$oldout or die "Can't restore STDOUT $!";
  close $oldout;
}

# NB. tests skip_all_until by running one liners in sub processes
# closes & restores stdout, stderr to avoid TAP parse errors
