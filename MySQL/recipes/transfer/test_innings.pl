#!/usr/bin/perl
# test_innings.pl - test the "innings-pitched" pattern.

# See also the is_innings_pitched() function in Cookbook_Utils.pm.

use strict;
use warnings;

my @val =
(
  "0",    "yes",
  "0.",   "yes",
  "0.0",  "yes",
  ".0",   "yes",
  ".1",   "yes",
  ".2",   "yes",
  ".3",   "no",   # bad fractional digit
  "1",    "yes",
  "1.",   "yes",
  "1.0",  "yes",
  "1.1",  "yes",
  "1.2",  "yes",
  "1.3",  "no",   # bad fractional digit
  "1.00", "no",   # too many fractional digits
);

while (@val)
{
  my $val = shift (@val);   # value to test
  my $result = shift (@val);  # whether it's valid
  my $verdict = ($val =~
#@ _INNINGS_PITCHED_
                  /^(\d+(\.[012]?)?|\.[012])$/
#@ _INNINGS_PITCHED_
                  ? "yes" : "no");
  my $match = ($verdict eq $result ? "" : "(test failed)");
  print "$val: $verdict $match\n";
}
