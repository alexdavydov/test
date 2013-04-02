#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
use diagnostics;
#
use List::Util qw {reduce};

my %alarm = ();

while (<>) {
	chomp;
	my @line = split;
	if ($line[7] =~ /(raised|clear)/) {
		$alarm {$line[6]}{status} = $1 ;   
		$alarm {$line[6]}{last_event} = join (" ", @line[0,1,2]) ;  
		$alarm {$line[6]}{count} += 1;
	}
}

sub longest {
	my $max = -1;
	my $max_ref;
	for (@_) {
		if (length > $max) {  # no temp variable, length() twice is faster
		$max = length;
		$max_ref = \$_;   # avoid any copying
    		}
	}
	return length ($$max_ref);
}

my @status = qw (Status);
my @event = qw ('Last timestamp');
my @count = qw (Count);
foreach my $alarmname (keys %alarm) {
	push @status, $alarm {$alarmname}->{status};
	push @event, $alarm {$alarmname}->{last_event};
	push @count, $alarm {$alarmname}->{count};
}

my $alarmw = longest ("Alarm", keys %alarm) + 1;
my $statusw = longest (@status) + 1;
my $eventw = longest (@event) + 1;
my $countw = longest (@count) + 1;

printf "%-${alarmw}s %-${statusw}s %-${eventw}s %-${countw}s\n", "Alarm", "Status", "Last timestamp", "Count";
foreach  my $alarmname (keys %alarm) {
	printf "%-${alarmw}s %-${statusw}s %-${eventw}s %-${countw}s\n", $alarmname, $alarm {$alarmname}->{status}, $alarm {$alarmname}->{last_event}, $alarm{$alarmname}->{count};
}
