#!/usr/bin/perl
##
##

use v5.8.8;
use strict;
use warnings;
use diagnostics;

my $totallines;
my $totalwords;
my $totalchars;

my $stdin = *STDIN;


foreach my $file ($stdin) {
	open (FD, $file) || die "Could not open $file";
	my($chars, $lines,$words);
	while (<FD>) {
		my $line = $_;
		$lines++;
		$chars += length ($line);
		while ($line =~ /\S+/g) {
			$words++;
		}
	}
	printf "%d %d %d %s\n", $lines, $words, $chars, $file;
	$totallines += $lines;
	$totalwords += $words;
	$totalchars += $chars;
	close FD;
}
printf "%d %d %d total\n", $totallines, $totalwords, $totalchars;
