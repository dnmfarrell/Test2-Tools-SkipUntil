#!/usr/bin/perl
use strict;
use warnings;
use Test2::Bundle::More;

system $^X, '-Ilib', '-MTest2::Tools::SkipUntil','-e',
   'skip_all_until "skip_all_until", "9999-01-01"; die "did not skip_all!"';

is $?, 0, 'script skipped all and exited 0';

system $^X, '-Ilib', '-MTest2::Tools::SkipUntil','-e',
   'skip_all_until "skip_all_until", "1995-01-01"; die "did not skip_all!"';

is $? >> 8, 255, 'script did not skip all and exited 255';

done_testing;
