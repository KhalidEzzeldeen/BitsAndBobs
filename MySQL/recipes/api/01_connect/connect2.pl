#!/usr/bin/perl
# connect2.pl - connect to the MySQL server, showing how to specify
# a port number or Unix domain socket path explicitly.

use strict;
use warnings;
use DBI;

{ # begin scope

#@ _FRAG1_
my $dsn = "DBI:mysql:host=mysql.example.com;database=cookbook"
            . ";port=3307";
#@ _FRAG1_
my $dbh = DBI->connect ($dsn, "cbuser", "cbpass");
if (!$dbh)
{
  warn "Cannot connect to server\n";
}
else
{
  print "Connected\n";
  $dbh->disconnect ();
  print "Disconnected\n";
}

} # end scope

{ # begin scope

#@ _FRAG2_
my $dsn = "DBI:mysql:host=localhost;database=cookbook"
            . ";mysql_socket=/var/tmp/mysql.sock";
#@ _FRAG2_
my $dbh = DBI->connect ($dsn, "cbuser", "cbpass");
if (!$dbh)
{
  warn "Cannot connect to server\n";
}
else
{
  print "Connected\n";
  $dbh->disconnect ();
  print "Disconnected\n";
}

} # end scope
