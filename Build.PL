use strict;
use lib qw( builder );
use Build;

my %opt = do 'SPEC' or die "Can not include PREREQ: $@";
my $mb  = Build->new( %opt );
$mb->change_versions(1);
$mb->create_build_script;
