#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
use diagnostics;

#array initialization
my @elements;

while (<>) {
	push @elements, split ' ', $_;
}
#print join(" ", @elements),"\n";

print "Unsorted array:\n";
#for (my $i = 0; $i < 10; $i++ ) {
#	$data[$i] = int(rand(100));
#}
print join (" ", @elements),"\n";

sub bubbleSort {
	
	my $array=shift @_;
	my $n=$#{$array}+1;
	until ($n == 0) {
		my $newn = 0;
		for (my $i=1; $i<$n; $i++ ) {
			if ($array->[$i-1] > $array->[$i]) {
			($array->[$i-1],$array->[$i]) = ($array->[$i],$array->[$i-1]);
			$newn=$i;
			}

		}
		$n=$newn;
	}
}

bubbleSort (\@elements);

print "Sorted array:\n";
print join(" ", @elements), "\n";
