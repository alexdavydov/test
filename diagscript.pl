#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
#use diagnostics;

my %alarm = ();

while (<>) {
	chomp;
	my @line = split;
	if ($line[7] =~ /(raised|clear)/) {
		$alarm {$line[6]}{status} = $1 ;   
		$alarm {$line[6]}{last_event} = join (" ", @line[0,1,2]) ;  
		$alarm {$line[6]}{count} += 1;
	}

#my $time = join (" ",@line[0,1,2]);
	
#	my $hostname = @line[3];
#	my $severity = @line[5];
#	my $alarm = @line[6];
#	my $status = @line [7];



#	print join(" ", @line), "\n";
}

foreach my $alarmname (keys %alarm) {
		print $alarmname, " ", $alarm {$alarmname}->{status}, " ", $alarm {$alarmname}->{last_event}, " ", $alarm{$alarmname}{count}, "\n";
}
