#!/usr/bin/perl
# nulltest.pl - show correct/incorrect way to write comparisons for
# values that might represent NULL.

use strict;
use warnings;
use Cookbook;

my $dbh = Cookbook::connect ();
my $sth;
my $id;
my $operator;

# This example uses = for the comparison operator, which will fail if
# $id is undef.

$id = undef;

#@ _INCORRECT_
$sth = $dbh->prepare ("SELECT * FROM taxpayer WHERE id = ?");
$sth->execute ($id);
#@ _INCORRECT_
print "Method 1\n";
while (my $ref = $sth->fetchrow_hashref ())
{
  printf "name: %s\n", $ref->{name}
}

#@ _CORRECT_
$operator = (defined ($id) ? "=" : "IS");
$sth = $dbh->prepare ("SELECT * FROM taxpayer WHERE id $operator ?");
$sth->execute ($id);
#@ _CORRECT_
print "Method 2\n";
while (my $ref = $sth->fetchrow_hashref ())
{
  printf "name: %s\n", $ref->{name}
}

# This is how you'd construct the operator for a not-equal test

#@ _NOT_EQUAL_
$operator = (defined ($id) ? "!=" : "IS NOT");
#@ _NOT_EQUAL_

$dbh->disconnect ();
