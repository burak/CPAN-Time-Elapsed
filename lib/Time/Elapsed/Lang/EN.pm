package Time::Elapsed::Lang::EN;
use strict;
use utf8;
use vars qw( $VERSION );

$VERSION = '0.13';

sub singular {
   qw/
   second  second
   minute  minute
   hour    hour
   day     day
   month   month
   year    year
   /
}

sub plural {
   qw/
   second  seconds
   minute  minutes
   hour    hours
   day     days
   month   months
   year    years
   /
}

sub other {
   qw/
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

=head1 AUTHOR

Burak Gürsoy, E<lt>burakE<64>cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2007-2008 Burak Gürsoy. All rights reserved.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify 
it under the same terms as Perl itself, either Perl version 5.8.8 or, 
at your option, any later version of Perl 5 you may have available.

=cut
