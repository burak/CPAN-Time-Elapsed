package Time::Elapsed;
use strict;
use utf8;
use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS );
# time constants
use constant SECOND     =>   1;
use constant MINUTE     =>  60 * SECOND;
use constant HOUR       =>  60 * MINUTE;
use constant DAY        =>  24 * HOUR;
use constant WEEK       =>   7 * DAY;
use constant MONTH      =>  30 * DAY;
use constant YEAR       => 365 * DAY;
# elapsed data fields
use constant INDEX      => 0;
use constant MULTIPLIER => 1;
use constant FIXER      => 2;
use Exporter ();
use Carp qw( croak );

$VERSION     = '0.30';
@ISA         = qw( Exporter );
@EXPORT      = qw( elapsed  );
%EXPORT_TAGS = ( all => [ @EXPORT, @EXPORT_OK ] );

# elapsed time formatter keys
my $ELAPSED = {
   # name       index   multiplier   fixer
   second => [  0,      60,          60    ],
   minute => [  1,      60,          60    ],
   hour   => [  2,      60,          24    ],
   day    => [  3,      24,          30    ],
   month  => [  4,      30,          12    ],
   year   => [  5,      12,           1    ],
};

my $ELAPSED_W = {
   # name       index   multiplier   fixer
   second => [  0,      60,          60    ],
   minute => [  1,      60,          60    ],
   hour   => [  2,      60,          24    ],
   day    => [  3,      24,           7    ],
   week   => [  4,       7,           4    ],
   month  => [  5,       4,          12    ],
   year   => [  6,      12,           1    ],
};

# formatters  for _fixer()
my $FIXER   = { map { $_ => $ELAPSED->{$_}[FIXER]   } keys %{ $ELAPSED   } };
my $FIXER_W = { map { $_ => $ELAPSED_W->{$_}[FIXER] } keys %{ $ELAPSED_W } };

my $NAMES = [ sort  { $ELAPSED->{ $a }[INDEX] <=> $ELAPSED->{ $b }[INDEX] }
            keys %{ $ELAPSED } ];

my $NAMES_W = [ sort  { $ELAPSED_W->{ $a }[INDEX] <=> $ELAPSED_W->{ $b }[INDEX] }
              keys %{ $ELAPSED_W } ];

my $LCACHE; # language cache

sub import {
   my $class = shift;
   my @raw   = @_;
   my @exports;
   foreach my $e ( @raw ) {
      _compile_all() && next if $e eq '-compile';
      push @exports, $e;
   }
   $class->export_to_level( 1, $class, @exports );
}

sub elapsed {
   my $sec  = shift;
   return if ! defined $sec;
   my $opt  = shift || {};
      $opt  = { lang => $opt } if ! ref $opt;
      $sec  = 0 if !$sec; # can be empty string
      $sec += 0;          # force number

   my $l  = _get_lang( $opt->{lang} || 'EN' ); # get language keys
   return $l->{other}{zero} if ! $sec;

   my $w  = $opt->{weeks} || 0;
   my @rv = _populate(
               $l,
               _fixer(
                  $w,
                  _parser(
                     $w,
                     _examine( abs($sec), $w )
                  )
               )
            );

   my $last = pop @rv;

   return @rv ? join(', ', @rv) . " $l->{other}{and} $last"
              : $last; # only a single value, no need for template/etc.
}

sub _populate {
   my($l, @parsed) = @_;
   my @buf;
   foreach my $e ( @parsed ) {
      next if ! $e->[MULTIPLIER]; # disable zero values
      my $type = $e->[MULTIPLIER] > 1 ? 'plural' : 'singular';
      push @buf, join(' ', $e->[MULTIPLIER], $l->{ $type }{ $e->[INDEX] } );
   }
   return @buf;
}

sub _fixer {
   # There can be values like "60 seconds". _fixer() corrects this kind of error
   my $weeks = shift;
   my @raw = @_;
   my(@fixed,$default,$add);

   my $f = $weeks ? $FIXER_W   : $FIXER;
   my $e = $weeks ? $ELAPSED_W : $ELAPSED;
   my $n = $weeks ? $NAMES_W   : $NAMES;

   my @top;
   foreach my $i ( reverse 0..$#raw ) {
      my $r = $raw[$i];
      $default = $f->{ $r->[INDEX] };
      if ( $add ) {
         $r->[MULTIPLIER] += $add; # we need a fix
         $add              = 0;    # reset
      }

      # year is the top-most element currently does not have any limits (def=1)
      if ( $r->[MULTIPLIER] >= $default && $r->[INDEX] ne 'year' ) {
         $add = int $r->[MULTIPLIER] / $default;
         $r->[MULTIPLIER] -= $default * $add;
         if ( $i == 0  ) { # we need to add to a non-existent upper level
            my $id = $e->{ $r->[INDEX] }[INDEX];
            my $up = $n->[ $id + 1 ]
                        || die "Can not happen: unable to locate top-level";
            unshift @top, [ $up, $add ];
         }
      }

      unshift @fixed, [ $r->[INDEX], $r->[MULTIPLIER] ];
   }

   unshift @fixed, @top;
   return @fixed;
}

sub _parser { # recursive formatter/parser
   my($weeks, $id, $mul) = @_;
   my $e      = $weeks ? $ELAPSED_W : $ELAPSED;
   my $n      = $weeks ? $NAMES_W   : $NAMES;
   my $xmid   = $e->{ $id }[INDEX];
   my @parsed = [ $id,  $xmid ? int($mul) : sprintf('%.0f', $mul) ];

   if ( $xmid ) {
      push @parsed, _parser(
         $weeks,
         $n->[ $xmid - 1 ],
        ($mul - int $mul) * $e->{$id}[MULTIPLIER]
      );
   }

   return @parsed;
}

sub _examine {
   my($sec, $weeks) = @_;
   return
     $sec >= YEAR           ? ( year   => $sec / YEAR   )
   : $sec >= MONTH          ? ( month  => $sec / MONTH  )
   : $sec >= WEEK && $weeks ? ( week   => $sec / WEEK   )
   : $sec >= DAY            ? ( day    => $sec / DAY    )
   : $sec >= HOUR           ? ( hour   => $sec / HOUR   )
   : $sec >= MINUTE         ? ( minute => $sec / MINUTE )
   :                          ( second => $sec          )
   ;
}

sub _get_lang {
   my $lang = shift || croak "_get_lang(): Language ID is missing";
      $lang = uc $lang;
   if ( ! exists $LCACHE->{ $lang } ) {
      if ( $lang =~ m{[^a-z_A-Z_0-9]}xmso || $lang =~ m{ \A [0-9] }xmso) {
         die "Bad language identifier: $lang";
      }
      _set_lang_cache( $lang );
   }
   return $LCACHE->{ $lang };
}

sub _set_lang_cache {
   my($lang) = @_;
   my $class = join '::', __PACKAGE__, 'Lang', $lang;
   my $file  = join('/', split /::/, $class ) . '.pm';
   require $file;
   $LCACHE->{ $lang } = {
      singular => { $class->singular },
      plural   => { $class->plural   },
      other    => { $class->other    },
   };
   return;
}

sub _compile_all {
   require File::Spec;
   local *LDIR;
   my($test, %lang);

   # search lib paths
   foreach my $lib ( @INC ) {
      $test = File::Spec->catfile( $lib, qw/ Time Elapsed Lang /);
      next if not -d $test;
      opendir LDIR, $test or die "opendir($test): $!";

      while ( my $file = readdir LDIR ) {
         next if -d $file;
         if ( $file =~ m{ \A (.+?) \. pm \z }xms ) {
            $lang{ uc $1 }++;
         }
      }

      closedir LDIR;
   }

   # compile language data
   foreach my $id ( keys %lang ) {
      _get_lang( $id );
   }

   return 1;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Time::Elapsed - Displays the elapsed time as a human readable string.

=head1 SYNOPSIS

   use Time::Elapsed qw( elapsed );
   $t = 1868401;
   print elapsed( $t );

prints:

   21 days, 15 hours and 1 second

If you set the language to turkish:

   print elapsed( $t, 'TR' );

prints:

   21 gün, 15 saat ve 1 saniye

=head1 DESCRIPTION

This module transforms the elapsed seconds into a human readable string.
It can be used for (for example) rendering C<uptime> values into
a human readable form. The resulting string will be an approximation.
See the L</CAVEATS> section for more information.

=head1 IMPORT PARAMETERS

This module does not export anything by default. You have to
specify import parameters. C<:all> key does not include
C<import commands>.

=head2 FUNCTIONS

   elapsed

=head2 KEYS

   :all

=head2 COMMANDS

   Parameter   Description
   ---------   -----------
   -compile    All available language data will immediately be compiled
               and placed into an internal cache.

=head1 FUNCTIONS

=head2 elapsed SECONDS [, OPTIONS ]

=over 4

=item *

C<SECONDS> must be a number representing the elapsed seconds.
If it is false, C<0> (zero) will be used. If it is not defined, C<undef>
will be returned.

=item *

The optional argument C<OPTIONS> is a either a string containing the language
id or a hashref containing several options. These two codes are equal:

   elapsed $secs, 'DE';
   elapsed $secs, { lang => 'DE' };

The hashref is used to pass extra options.

=back

=head3 OPTIONS

=head4 lang

The optional argument language id, represents the language to use when
converting the data to a string. The language section is really a
standalone module in the C<Time::Elapsed::Lang::> namespace, so it is
possible to extend the language support on your own. Currently
supported languages are:

   Parameter  Description
   ---------  -----------------
      EN      English (default)
      TR      Turkish
      DE      German

Language ids are case-insensitive. These are all same: C<en>, C<EN>, C<eN>.

=head4 weeks

If this option is present and set to a treu value, then you'll get "weeks"
instead of "days" in the output if the output has a days value between 29 days
and 7 days.

=head1 CAVEATS

=over 4

=item *

The calculation of the elapsed time is only an approximation, since these
values are used internally:

   1 Day   =  24 Hour
   1 Month =  30 Day
   1 Year  = 365 Day

See
L<"How Datetime Math is Done" in DateTime|DateTime/How Datetime Math is Done>
for more information on this subject. Also see C<in_units()> method in
L<DateTime::Duration>.

=item *

This module' s source file is UTF-8 encoded (without a BOM) and it returns
UTF-8 values whenever possible.

=item *

Currently, the module won't work with any perl older than 5.6 because of
the UTF-8 encoding and the usage of L<utf8> pragma. However, the pragma
limitation can be by-passed with a C<%INC> trick under 5.005_04 (tested)
and can be used with english language (default behavior), but any other
language will probably need unicode support.

=back

=head1 SEE ALSO

L<PTools::Time::Elapsed>, L<DateTime>, L<DateTime::Format::Duration>,
L<Time::Duration>.

=cut
