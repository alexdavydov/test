#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
use diagnostics;

my @strings;

chomp(my $len = <STDIN>);
shift @ARGV;

while (<>) {
	chomp;
	push @strings, $_;
}

for (my $i=1; $i<=$len; $i++) {
	print $i % 10;
}
print "\n";

foreach my $string (@strings) {
	printf "%${len}s\n", $string;
}
