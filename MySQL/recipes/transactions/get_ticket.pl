#!/usr/bin/perl
# get_ticket.pl - ticket-dispensing methods

# method 1 - simple but incorrect (dispenses ticket even if there are none)
# method 2 - dispense ticket using transaction
# method 3 - dispense ticket using atomic action rather than transaction

use strict;
use warnings;
use Cookbook;

my $dbh = Cookbook::connect ();

# Try to get tickets for an event that has some (53),
# and an event that has none (102)

my $okay;

init_table ($dbh);
$okay = get_ticket1 ($dbh, 53);
print "Method 1: Ticket available for event 53: "
    . ($okay ? "yes" : "no") . "\n";
$okay = get_ticket1 ($dbh, 102);
print "Method 1: Ticket available for event 102: "
    . ($okay ? "yes" : "no") . "\n";

init_table ($dbh);
$okay = get_ticket2 ($dbh, 53);
print "Method 2: Ticket available for event 53: "
    . ($okay ? "yes" : "no") . "\n";
$okay = get_ticket2 ($dbh, 102);
print "Method 2: Ticket available for event 102: "
    . ($okay ? "yes" : "no") . "\n";

$okay = get_ticket3 ($dbh, 53);
init_table ($dbh);
print "Method 3: Ticket available for event 53: "
    . ($okay ? "yes" : "no") . "\n";
$okay = get_ticket3 ($dbh, 102);
print "Method 3: Ticket available for event 102: "
    . ($okay ? "yes" : "no") . "\n";

$dbh->disconnect ();

exit (0);

# Create the example table and populate it with a few rows

sub init_table
{
my $dbh = shift;

  $dbh->do ("DROP TABLE IF EXISTS meeting");
  $dbh->do ("
          CREATE TABLE meeting
          (
            meeting_id  INT UNSIGNED NOT NULL,
            PRIMARY KEY (meeting_id),
            tix_left  INT UNSIGNED NOT NULL
          )
          ENGINE = InnoDB");
  $dbh->do ("INSERT INTO meeting (meeting_id, tix_left) VALUES (53, 100)");
  $dbh->do ("INSERT INTO meeting (meeting_id, tix_left) VALUES (72, 50)");
  $dbh->do ("INSERT INTO meeting (meeting_id, tix_left) VALUES (91, 150)");
  $dbh->do ("INSERT INTO meeting (meeting_id, tix_left) VALUES (102, 0)");
}

# Save a database handle's error and commit attributes, and then set
# them to values appropriate for performing transactions.  Return the
# old attribute values in a hashref.

sub transaction_init
{
my $dbh = shift;
my $attr_ref = {};  # create hash in which to save attributes

  $attr_ref->{RaiseError} = $dbh->{RaiseError};
  $attr_ref->{PrintError} = $dbh->{PrintError};
  $attr_ref->{AutoCommit} = $dbh->{AutoCommit};
  $dbh->{RaiseError} = 1; # raise exception if an error occurs
  $dbh->{PrintError} = 0; # don't print an error message
  $dbh->{AutoCommit} = 0; # disable auto-commit
  return ($attr_ref);   # return attributes to caller
}

# Roll back if the transaction failed.  Then restore the error-handling
# and auto-commit attributes.

sub transaction_finish
{
my ($dbh, $attr_ref, $error) = @_;

  if ($error) # an error occurred
  {
    print "Transaction failed, rolling back. Error was:\n$error\n";
    # roll back within eval to prevent rollback
    # failure from terminating the script
    eval { $dbh->rollback (); };
  }
  # restore error-handling and auto-commit attributes
  $dbh->{AutoCommit} = $attr_ref->{AutoCommit};
  $dbh->{PrintError} = $attr_ref->{PrintError};
  $dbh->{RaiseError} = $attr_ref->{RaiseError};
}


sub get_ticket1
#@ _GET_TICKET_1_
{
my ($dbh, $meeting_id) = @_;

  my $count = $dbh->do ("UPDATE meeting SET tix_left = tix_left-1
                        WHERE meeting_id = ?", undef, $meeting_id);
  return ($count);
}
#@ _GET_TICKET_1_

sub get_ticket2
#@ _GET_TICKET_2_
{
my ($dbh, $meeting_id) = @_;

  my $ref = transaction_init ($dbh);
  my $count = 0;
  eval
  {
    # check the current ticket count
    $count = $dbh->selectrow_array (
                "SELECT tix_left FROM meeting
                WHERE meeting_id = ?", undef, $meeting_id);
    # if there are tickets left, decrement the count
    if ($count > 0)
    {
      $dbh->do ("UPDATE meeting SET tix_left = tix_left-1
                WHERE meeting_id = ?", undef, $meeting_id);
    }
    $dbh->commit ();
  };
  $count = 0 if $@; # if an error occurred, no tix available
  transaction_finish ($dbh, $ref, $@);
  return ($count > 0)
}
#@ _GET_TICKET_2_


# Return true if the UPDATE changed a row, indicating that there
# were tickets left.

sub get_ticket3
#@ _GET_TICKET_3_
{
my ($dbh, $meeting_id) = @_;

  my $count = $dbh->do ("UPDATE meeting SET tix_left = tix_left-1
                        WHERE meeting_id = ? AND tix_left > 0",
                        undef, $meeting_id);
  return ($count > 0);
}
#@ _GET_TICKET_3_
