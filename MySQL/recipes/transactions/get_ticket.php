<?php
# get_ticket.php - ticket-dispensing methods

# Requires PHP 5 because exceptions are used

# method 1 - simple but incorrect (dispenses ticket even if there are none)
# method 2 - dispense ticket using transaction
# method 3 - dispense ticket using atomic action rather than transaction

require_once "Cookbook.php";

# Create the example table and populate it with a few rows
# (This function is lazy and assumes that all statements succeed)

function init_table ($conn)
{
  $conn->query ("DROP TABLE IF EXISTS meeting");
  $conn->query ("
            CREATE TABLE meeting
            (
              meeting_id  INT UNSIGNED NOT NULL,
              PRIMARY KEY (meeting_id),
              tix_left  INT UNSIGNED NOT NULL
            )
            ENGINE = InnoDB");
  $conn->query ("INSERT INTO meeting (meeting_id, tix_left) VALUES (53, 100)");
  $conn->query ("INSERT INTO meeting (meeting_id, tix_left) VALUES (72, 50)");
  $conn->query ("INSERT INTO meeting (meeting_id, tix_left) VALUES (91, 150)");
  $conn->query ("INSERT INTO meeting (meeting_id, tix_left) VALUES (102, 0)");
}

function get_ticket1 ($conn, $meeting_id)
#@ _GET_TICKET_1_
{
  # return true if the query succeeds
  return (!PEAR::isError ($conn->query (
            "UPDATE meeting SET tix_left = tix_left-1
             WHERE meeting_id = $meeting_id")));
}
#@ _GET_TICKET_1_

function get_ticket2 ($conn, $meeting_id)
#@ _GET_TICKET_2_
{
  $ticket_left = $committed = 0;
  try
  {
    $result =& $conn->autoCommit (FALSE);
    if (PEAR::isError ($result))
      throw new Exception ($result->getMessage ());
    $result =& $conn->query (
                "SELECT tix_left FROM meeting
                 WHERE meeting_id = $meeting_id");
    if (PEAR::isError ($result))
      throw new Exception ($result->getMessage ());
    $row =& $result->fetchRow ();
    $result->free ();
    $ticket_left = ($row[0] > 0);
    if ($ticket_left)
    {
      $result =& $conn->query (
                  "UPDATE meeting SET tix_left = tix_left-1
                   WHERE meeting_id = $meeting_id");
      if (PEAR::isError ($result))
        throw new Exception ($result->getMessage ());
    }
    $result =& $conn->commit ();
    if (PEAR::isError ($result))
      throw new Exception ($result->getMessage ());
    $result =& $conn->autoCommit (TRUE);
    if (PEAR::isError ($result))
      throw new Exception ($result->getMessage ());
  }
  catch (Exception $e)
  {
    $ticket_left = 0; # if an error occurred, no tix available
    # empty exception handler in case rollback fails
    try
    {
      $conn->rollback ();
      $conn->autoCommit (TRUE);
    }
    catch (Exception $e2) { }
  }
  return ($ticket_left);
}
#@ _GET_TICKET_2_

function get_ticket3 ($conn, $meeting_id)
#@ _GET_TICKET_3_
{
  if (PEAR::isError ($conn->query (
              "UPDATE meeting SET tix_left = tix_left-1
               WHERE meeting_id = $meeting_id AND tix_left > 0")))
    return (0);   # query failed
  return ($conn->affectedRows () > 0);
}
#@ _GET_TICKET_3_

$conn = Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage ());

# Try to get tickets for an event that has some (53),
# and an event that has none (102)

init_table ($conn);
$okay = get_ticket1 ($conn, 53);
print ("Method 1: Ticket available for event 53: "
    . ($okay ? "yes" : "no") . "\n");
$okay = get_ticket1 ($conn, 102);
print ("Method 1: Ticket available for event 102: "
    . ($okay ? "yes" : "no") . "\n");

init_table ($conn);
$okay = get_ticket2 ($conn, 53);
print ("Method 2: Ticket available for event 53: "
    . ($okay ? "yes" : "no") . "\n");
$okay = get_ticket2 ($conn, 102);
print ("Method 2: Ticket available for event 102: "
    . ($okay ? "yes" : "no") . "\n");

init_table ($conn);
$okay = get_ticket3 ($conn, 53);
print ("Method 3: Ticket available for event 53: "
    . ($okay ? "yes" : "no") . "\n");
$okay = get_ticket3 ($conn, 102);
print ("Method 3: Ticket available for event 102: "
    . ($okay ? "yes" : "no") . "\n");

$conn->disconnect ();

?>
