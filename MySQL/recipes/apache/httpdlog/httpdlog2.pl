#!/usr/bin/perl
# httpdlog2.pl - Log Apache requests to httpdlog2 table

# path to directory containing Cookbook.pm (CHANGE AS NECESSARY)
use lib qw(/usr/local/lib/mcb);
use strict;
use warnings;
use Cookbook;

my $dbh = Cookbook::connect ();
my $sth = $dbh->prepare (qq{
                  INSERT DELAYED INTO httpdlog2
                    (dt,vhost,host,method,url,status,size,referer,agent)
                    VALUES (?,?,?,?,?,?,?,?,?)
                  });

while (<>)  # loop reading input
{
  chomp;
  my ($dt, $vhost, $host, $method, $url, $status, $size, $refer, $agent)
                          = split (/\t/, $_);
  # map "-" to NULL for some columns
  $size = undef if $size eq "-";
  $agent = undef if $agent eq "-";
  $sth->execute ($dt, $vhost, $host, $method, $url,
                 $status, $size, $refer, $agent);
}

$dbh->disconnect ();
