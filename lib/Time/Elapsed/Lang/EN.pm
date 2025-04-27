package Time::Elapsed::Lang::EN;

use strict;
use warnings;
use utf8;

sub singular {
   return qw/
   second  second
   minute  minute
   hour    hour
   day     day
   week    week
   month   month
   year    year
   /
}

sub plural {
   return qw/
   second  seconds
   minute  minutes
   hour    hours
   day     days
   week    weeks
   month   months
   year    years
   /
}

sub other {
   return qw/
   and     and
   ago     ago
   /,
   zero => q{zero seconds},
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Time::Elapsed::Lang::EN - English language file.

=head1 DEPRECATION NOTICE

This module is B<DEPRECATED>. Please use L<Time::Duration>.

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
