#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
use diagnostics;

my %words;
my $word;

while (<>) {
	chomp;
	$words{"$_"} += 1; 
}

foreach $word (keys %words) {
	print "$word was encountered $words{$word} times\n";
}
