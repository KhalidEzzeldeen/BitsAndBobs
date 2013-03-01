#!/usr/bin/perl
# error.pl - demonstrate MySQL error-handling

use strict;
use warnings;
use DBI;
my $dsn = "DBI:mysql:host=localhost;database=cookbook";

{ # begin scope

# connect and check for error (DBI prints a message itself)
#@ _PRINTERROR_ONLY_1_
my %conn_attrs = (AutoCommit => 1);
my $dbh = DBI->connect ($dsn, "cbuser", "cbpass", \%conn_attrs);
#@ _PRINTERROR_ONLY_1_
$dbh->disconnect ();

} # end scope

{ # begin scope

#@ _PRINTERROR_ONLY_2_
my %conn_attrs = (AutoCommit => 1);
my $dbh = DBI->connect ($dsn, "cbuser", "cbpass", \%conn_attrs)
            or exit;
#@ _PRINTERROR_ONLY_2_
$dbh->disconnect ();

} # end scope

{ # begin scope

# connect and let DBI terminate if an error occurs
#@ _RAISEERROR_PRINTERROR_BOTH_
my %conn_attrs = (RaiseError => 1, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, "cbuser", "cbpass", \%conn_attrs);
#@ _RAISEERROR_PRINTERROR_BOTH_
$dbh->disconnect ();

} # end scope

{ # begin scope

# connect and let DBI terminate if an error occurs, but avoid having
# both PrintError and RaiseError generate the same message
#@ _RAISEERROR_ONLY_
my %conn_attrs = (PrintError => 0, RaiseError => 1, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, "cbuser", "cbpass", \%conn_attrs);
#@ _RAISEERROR_ONLY_
$dbh->disconnect ();

} # end scope

{ # begin scope

# connect and check for error (suppress DBI message-printing )
#@ _RAISEERROR_PRINTERROR_NEITHER_
my %conn_attrs = (PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, "cbuser", "cbpass", \%conn_attrs)
            or die "Connection error: "
                   . "$DBI::errstr ($DBI::err/$DBI::state)\n";
#@ _RAISEERROR_PRINTERROR_NEITHER_
$dbh->disconnect ();

} # end scope

#@ _EVAL_BLOCK_
eval
{
  # statements that might fail go here...
};
if ($@)
{
  print "An error occurred: $@\n";
}
#@ _EVAL_BLOCK_

{ # begin scope

# use tracing
my %conn_attrs = (PrintError => 0, RaiseError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, "cbuser", "cbpass", \%conn_attrs);
print "trace level 1\n";
DBI->trace (1);
$dbh->do (qq{ DROP TABLE my_table1 });
# elevate trace level
print "trace level 3\n";
DBI->trace (3);
$dbh->do (qq{ DROP TABLE my_table2 });
# disable tracing
DBI->trace (0);
$dbh->disconnect ();

} # end scope
