#!/usr/bin/env perl -w
BEGIN {
   # to test under legacy perl
   $INC{'utf8.pm'} = 1 if $] < 5.006;
}
use strict;
use utf8;
use Test::More    qw( no_plan );
use Time::Elapsed qw( elapsed ); 

eval q{ binmode Test::More->builder->output, ':utf8'; } if $] >= 5.008;

# WEEK: 612886

# ---[ NORMAL ]--- #
ok( elapsed(1868405) eq elapsed(1868405, 'EN') , qq{Test1 equals Test2} );

test( 1868405, __ => "21 days, 15 hours and 5 seconds"    );
test( 1868405, EN => "21 days, 15 hours and 5 seconds"    );
test( 1868405, TR => "21 gün, 15 saat ve 5 saniye"        );
test( 1868405, DE => "21 Tage, 15 Stunden und 5 Sekunden" );

test( 1868401, __ => "21 days, 15 hours and 1 second"    );
test( 1868401, EN => "21 days, 15 hours and 1 second"    );
test( 1868401, TR => "21 gün, 15 saat ve 1 saniye"        );
test( 1868401, DE => "21 Tage, 15 Stunden und 1 Sekunde" );

# ---[ UNDEF ]--- #
ok( ! defined( elapsed()      ), qq{Parameter is undef} );
ok( ! defined( elapsed(undef) ), qq{Parameter is undef} );

# ---[ FALSE ]--- #
_false( EN => "zero seconds" );
_false( TR => "sıfır saniye" );
_false( DE => "Nullsekunden" );

sub _false {
   my $lang   = shift || 'EN';
   my $expect = shift;
   test( 0 , $lang, $expect );
   test( '', $lang, $expect );
     ok( elapsed(0, $lang) eq elapsed('', $lang) , qq{Test1 equals Test2} );
}

sub test {
   my $num  = shift;
   my $lang = shift;
   my $want = shift;
   my $t    = elapsed( $num , $lang ne '__' ? $lang : undef );
   ok( $t eq $want, qq{"$t" eq "$want"} );
}