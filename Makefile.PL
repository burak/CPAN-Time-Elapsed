use ExtUtils::MakeMaker;

WriteMakefile(
   'NAME'         => 'Time::Elapsed',
   'VERSION_FROM' => 'lib/Time/Elapsed.pm',
   'PREREQ_PM'    => {
      'Test::More' => '0.40',
   },
   ($] >= 5.005 ? (
   AUTHOR   => 'Burak Gursoy <burak@cpan.org>',
   ABSTRACT => 'Displays the elapsed time as a human readable string.',
   ) : ()),
   PL_FILES => {},
);
