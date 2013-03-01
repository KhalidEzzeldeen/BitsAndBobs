#!/usr/bin/perl
# get_storage_engines.pl - list supported storage engines

use strict;
use warnings;
use Cookbook;

#@ _GET_STORAGE_ENGINES_
sub get_storage_engines
{
my $dbh = shift;
my @engines;

  my $sth = $dbh->prepare ("SHOW ENGINES");
  $sth->execute ();
  while (my @row = $sth->fetchrow_array ())
  {
    # $row[0] = engine name, $row[1] = support
    $row[1] = uc ($row[1]);   # uppercase the "support" value
    push (@engines, $row[0]) if $row[1] eq "YES" || $row[1] eq "DEFAULT";
  }
  return @engines;
}
#@ _GET_STORAGE_ENGINES_

my $dbh = Cookbook::connect ();

my @engines = get_storage_engines ($dbh);
print "Supported storage engines:\n";
print join ("\n", @engines), "\n";

$dbh->disconnect ();
