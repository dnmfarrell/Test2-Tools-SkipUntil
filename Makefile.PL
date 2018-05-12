use 5.008005;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME           => 'Test2::Tools::SkipUntil',
  VERSION_FROM   => 'lib/Test2/Tools/SkipUntil.pm',
  PREREQ_PM      => {
    'Test2::Tools::Exception' => 0,
    'Test2::Bundle::More' => 0,
    'Time::Piece' => 0,
    'Test2::API' => 0,
  },
  ABSTRACT_FROM  => 'lib/Test2/Tools/SkipUntil.pm',
  AUTHOR         => 'David Farrell',
  LICENSE        => 'perl',
  (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
      'meta-spec' => { version => 2 },
      TEST_REQUIRES => { 'Test2::Bundle::More' => 0, 'Test2::Tools::Exception' => 0 },
      resources => {
          repository => {
              type => 'git',
              url  => 'https://github.com/dnmfarrell/Test2-Tools-SkipUntil.git',
              web  => 'https://github.com/dnmfarrell/Test2-Tools-SkipUntil',
          },
      }})
   : ()
  ),
);