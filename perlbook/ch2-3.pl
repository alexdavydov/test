#!/usr/bin/perl
#
#

use v5.8.8;
use strict; 
use warnings;
use diagnostics;

use constant PI=>3.141592654;
my $l;

chomp (my $r = <STDIN>);
if ($r < 0){
$r=0
}
$l = 2 * PI * $r;


print $l,"\n";
