#!/usr/bin/perl
use Test2::Bundle::More;
use Test2::Tools::SkipUntil 'skip_until';

subtest 'skip_until_9999' => sub {
  my $skipped = 1;
  SKIP: {
    skip_until 'Test2::Tools::SkipUntil test', 2, '9999-01-01';
    pass 'foo';
    pass 'bar';
    undef $skipped;
  }
  ok $skipped, 'skipped 2 tests uyntil 9999-01-01';

};

subtest 'skip_until_1997' => sub {
  my $skipped = 1;
  SKIP: {
    skip_until 'Test2::Tools::SkipUntil test', 2, '1997-01-01';
    pass 'foo';
    pass 'bar';
    undef $skipped;
  }
  ok !defined $skipped, 'didn\'t skip tests as 1997 is in the past';
};

done_testing;
