#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
use diagnostics;

my @names = qw (fred betty barney dino wilma pebbles bamm-bamm);
my $i;
my @input = <>;
foreach $i (@input){
	print $names[$i-1]," ";
}
print "\n";	
