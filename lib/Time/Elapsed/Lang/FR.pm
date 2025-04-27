package Time::Elapsed::Lang::FR;

use strict;
use warnings;
use utf8;

sub singular {
   return qw/
   second  seconde
   minute  minute
   hour    heure
   day     jour
   week    semaine
   month   mois
   year    an
   /
}

sub plural {
   return qw/
   second  secondes
   minute  minutes
   hour    heures
   day     jours
   week    semaines
   month   mois
   year    ans
   /
}

sub other {
   return qw/
   and     et
   /,
   zero => q{zéro seconde},
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Time::Elapsed::Lang::FR - French language file.

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
