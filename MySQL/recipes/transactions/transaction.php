<?php
# transaction.php - simple transaction demonstration

# Requires PHP 5 because exceptions are used

# By default, this creates an InnoDB table.  If you specify a storage
# engine on the command line, that will be used instead.  Normally,
# this should be a transaction-safe engine that is supported by your
# server.  However, you can pass a nontransactional storage engine
# to verify that rollback doesn't work properly for such engines.

# The script uses a table named "money" and drops it if necessary.
# Change the name if you have a valuable table with that name. :-)

require_once "Cookbook.php";

# Create the example table and populate it with a couple of rows

function init_table ($conn, $tbl_engine)
{
  (
    !PEAR::isError ($conn->query ("DROP TABLE IF EXISTS money"))
    &&
    !PEAR::isError ($conn->query ("CREATE TABLE money (name CHAR(5), amt INT)
                                   ENGINE = $tbl_engine"))
    &&
    !PEAR::isError ($conn->query ("INSERT INTO money (name, amt)
                                   VALUES('Eve',10)"))
    &&
    !PEAR::isError ($conn->query ("INSERT INTO money (name, amt)
                                   VALUES('Ida',0)"))
  )
  or die ("Cannot initialize test table: " . $conn->getMessage () . "\n");
}

# Display the current contents of the example table

function display_table ($conn)
{
  $result =& $conn->query ("SELECT name, amt FROM money");
  if (PEAR::isError ($result))
  {
    die ("Cannot display contents of test table: "
          . $conn->getMessage () . "\n");
  }
  while ($row =& $result->fetchRow ())
  {
    print ("$row[0] has \$$row[1]\n");
  }
  $result->free ();
}

$tbl_engine = "InnoDB";   # default storage engine
if ($argc > 1)
  $tbl_engine = $argv[1];
print ("Using storage engine $tbl_engine to test transactions\n");

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage () . "\n");

# Run the transaction using statements grouped in a function

print ("----------\n");
print ("This transaction should succeed.\n");
print ("Table contents before transaction:\n");
init_table ($conn, $tbl_engine);
display_table ($conn);

#@ _DO_TRANSACTION_
try
{
  $result =& $conn->autoCommit (FALSE);
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
  $result =& $conn->query (
                "UPDATE money SET amt = amt - 6 WHERE name = 'Eve'");
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
  $result =& $conn->query (
                "UPDATE money SET amt = amt + 6 WHERE name = 'Ida'");
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
  $result =& $conn->commit ();
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
  $result =& $conn->autoCommit (TRUE);
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
}
catch (Exception $e)
{
  print ("Transaction failed: " . $e->getMessage () . ".\n");
  # empty exception handler in case rollback fails
  try
  {
    $conn->rollback ();
    $conn->autoCommit (TRUE);
  }
  catch (Exception $e2) { }
}
#@ _DO_TRANSACTION_

print ("Table contents after transaction:\n");
display_table ($conn);

print ("----------\n");
print ("This transaction should fail.\n");
print ("Table contents before transaction:\n");
init_table ($conn, $tbl_engine);
display_table ($conn);

try
{
  $result =& $conn->autoCommit (FALSE);
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
  $result =& $conn->query (
                "UPDATE money SET amt = amt - 6 WHERE name = 'Eve'");
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
  $result =& $conn->query (
                "UPDATE money SET xamt = xamt + 6 WHERE name = 'Ida'");
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
  $result =& $conn->commit ();
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
  $result =& $conn->autoCommit (TRUE);
  if (PEAR::isError ($result))
    throw new Exception ($result->getMessage ());
}
catch (Exception $e)
{
  print ("Transaction failed: " . $e->getMessage () . ".\n");
  # empty exception handler in case rollback fails
  try
  {
    $conn->rollback ();
    $conn->autoCommit (TRUE);
  }
  catch (Exception $e2) { }
}

print ("Table contents after transaction:\n");
display_table ($conn);

$conn->disconnect ();

?>
