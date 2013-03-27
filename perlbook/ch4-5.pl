#!/usr/bin/perl
#
#

use v5.10.1;
use strict;
use warnings;
use diagnostics;

sub greet {
	state @people;
	if (! defined @people) {
		print "Hi ", $_[0], "! You are the first one here!\n";
	} else {
		print "Hi ", $_[0], "! ", "Also here: ", join(" ",@people), "\n";
	}
	push @people,$_[0];
}

&greet ( "Fred" );
&greet ( "Barney" );
&greet ( "John" );
&greet ("James");
