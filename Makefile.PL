#!/usr/bin/env perl
use strict;
use ExtUtils::MakeMaker;
use lib qw( builder );
use Build::Spec qw( mm_spec );

my %spec = mm_spec;

WriteMakefile(
    NAME         => $spec{module_name},
    VERSION_FROM => $spec{VERSION_FROM},
    PREREQ_PM    => $spec{PREREQ_PM},
    PL_FILES     => {},
    ($] >= 5.005 ? (
    AUTHOR       => $spec{dist_author},
    ABSTRACT     => 'Displays the elapsed time as a human readable string.',
    ) : ()),
);
