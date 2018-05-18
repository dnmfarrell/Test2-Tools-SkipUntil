#!/usr/bin/perl
use strict;
use warnings;
use Test2::Tools::SkipUntil;
use Test2::Bundle::More;

my $skipped = 1;
skip_all_until 'test2-tools-skipuntil-test', '1995-01-01';
$skipped = 0;
pass 'did not skip all';
done_testing;

END { die 'should not have skipped tests' if $skipped }
