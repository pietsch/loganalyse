#!/usr/bin/env perl
use strict;
use warnings;
no warnings 'pack';
use List::Util 'shuffle';
use List::MoreUtils 'any';
use Net::IP::Match;

## create a random mapping onto values like rand(256) but stable for this run:
my @rand256 = List::Util::shuffle(0 .. 255);

## process STDIN:
while (<>) {
  ## parse IPv4 address, and put the rest of the line into $3:
  /^(\d+\.\d+\.\d+)\.(\d+) (.+)$/;
  next unless (defined $1 and length $1);
  next unless (defined $2 and length $2);
  my $prefix = "$1.";
  my $postfix = $2;
  ## do not touch localhost etc.:
  unless (__MATCH_IP("$prefix$postfix", qw{127.0.0.1 129.70.43.0/25})) {  # <-- customize
    $postfix = $rand256[$2];
  }
  print "$prefix$postfix $3\n";
}
