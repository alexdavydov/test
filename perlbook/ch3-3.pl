#!/usr/bin/perl
#
#

use v5.8.8;
use strict;
use warnings;
use diagnostics;

chomp(my @input = <>);
print join (" ", sort @input),"\n";
