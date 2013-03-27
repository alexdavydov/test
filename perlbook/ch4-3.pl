#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
use diagnostics;

sub total {
	my $sum=0;
	foreach (@_) {
		$sum += $_;
	}
	return $sum;
}

sub aboveAverage {
	my $mean = &total(@_) / ($#_+1);
	my @above;
	foreach (@_){
		if ($_ > $mean){
		push @above,$_
		}
	}
	return @above;
}

my @fred = aboveAverage(1..10);
print "\@fred is @fred\n";
print "(Should be 6 7 8 9 10)\n";
my @barney = aboveAverage(100, 1..10);
print "\@barney is @barney\n";
print "(Should be just 100)\n";
