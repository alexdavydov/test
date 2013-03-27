#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
use diagnostics;

my %names = (
	alex=>'davydov',
	didier=>'tremblay',
	anton=>'timofeiev'
);

while (<>) {
	chomp;
	if ($names{$_}) {
	print $names{$_},"\n";
	} else {
	print "I don't know such a person\n";
	}
}
