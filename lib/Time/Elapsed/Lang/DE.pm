package Time::Elapsed::Lang::DE;

use strict;
use warnings;
use utf8;

sub singular {
   return qw/
   second  Sekunde
   minute  Minute
   hour    Stunde
   day     Tag
   week    Woche
   month   Monat
   year    Jahr
   /
}

sub plural {
   return qw/
   second  Sekunden
   minute  Minuten
   hour    Stunden
   day     Tage
   week    Wochen
   month   Monate
   year    Jahre
   /
}

sub other {
   return qw/
   and     und
   ago     vor
   /,
   zero => q{Nullsekunden},
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Time::Elapsed::Lang::DE - German language file.

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
