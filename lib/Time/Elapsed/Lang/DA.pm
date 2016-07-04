package Time::Elapsed::Lang::DA;
use strict;
use warnings;
use utf8;
use vars qw( $VERSION );

$VERSION = '0.01';

sub singular {
   return qw/
   second  sekund
   minute  minut
   hour    time
   day     dag
   week    uge
   month   måned
   year    år
   /
}

sub plural {
   return qw/
   second  sekunder
   minute  minutter
   hour    timer
   day     dage
   week    uger
   month   måneder
   year    år
   /
}

sub other {
   return qw/
   and    og
   since  siden
   /,
   zero => q{nul sekunder},
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Time::Elapsed::Lang::DA - Danish language file.

=head1 SYNOPSIS

Private module.

=head1 DESCRIPTION

Private module.

=head1 METHODS

=head2 singular

=head2 plural

=head2 other

=head1 SEE ALSO

L<Time::Elapsed>.

=cut
