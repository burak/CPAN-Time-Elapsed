package Time::Elapsed::Lang::DE;
use strict;
use utf8;
use vars qw( $VERSION );

$VERSION = '0.10';

sub singular {
   qw/
   second  Sekunde
   minute  Minute
   hour    Stunde
   day     Tag
   month   Monat
   year    Jahr
   /
}

sub plural {
   qw/
   second  Sekunden
   minute  Minuten
   hour    Stunden
   day     Tage
   month   Monate
   year    Jahre
   /
}

sub other {
   qw/
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

=head1 SYNOPSIS

Private module.

=head1 DESCRIPTION

Private module.

=head1 SEE ALSO

L<Time::Elapsed>.

=head1 AUTHOR

Burak Gürsoy, E<lt>burakE<64>cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2007-2008 Burak Gürsoy. All rights reserved.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify 
it under the same terms as Perl itself, either Perl version 5.8.8 or, 
at your option, any later version of Perl 5 you may have available.

=cut
