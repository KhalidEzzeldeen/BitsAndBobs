<?php
# stmt.php - demonstrate statement processing in PHP
# (without placeholders)

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
{
  print ("Cannot connect to server.\n");
  printf ("Error message: %s\n", $conn->getMessage ());
  exit (1);
}

print ("Fetch using ordered array\n");
#@ _FETCHLOOP_1_
$result =& $conn->query ("SELECT id, name, cats FROM profile");
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
while ($row =& $result->fetchRow (DB_FETCHMODE_ORDERED))
  print ("id: $row[0], name: $row[1], cats: $row[2]\n");
printf ("Number of rows returned: %d\n", $result->numRows ());
$result->free ();
#@ _FETCHLOOP_1_

print ("Fetch using associative array\n");
#@ _FETCHLOOP_2_
$result =& $conn->query ("SELECT id, name, cats FROM profile");
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
while ($row =& $result->fetchRow (DB_FETCHMODE_ASSOC))
{
  printf ("id: %s, name: %s, cats: %s\n",
      $row["id"], $row["name"], $row["cats"]);
}
printf ("Number of rows returned: %d\n", $result->numRows ());
$result->free ();
#@ _FETCHLOOP_2_

print ("Fetch using object\n");
#@ _FETCHLOOP_3_
$result =& $conn->query ("SELECT id, name, cats FROM profile");
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
while ($row =& $result->fetchRow (DB_FETCHMODE_OBJECT))
  print ("id: $row->id, name: $row->name, cats: $row->cats\n");
printf ("Number of rows returned: %d\n", $result->numRows ());
$result->free ();
#@ _FETCHLOOP_3_

print ("Fetch using default fetch mode\n");
#@ _SET_FETCH_MODE_
$conn->setFetchMode (DB_FETCHMODE_ASSOC);
#@ _SET_FETCH_MODE_
#@ _FETCHLOOP_4_
$result =& $conn->query ("SELECT id, name, cats FROM profile");
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
while ($row =& $result->fetchRow ())
{
  printf ("id: %s, name: %s, cats: %s\n",
      $row["id"], $row["name"], $row["cats"]);
}
printf ("Number of rows returned: %d\n", $result->numRows ());
$result->free ();
#@ _FETCHLOOP_4_

print ("Update rows\n");
#@ _UPDATE_
$result =& $conn->query ("UPDATE profile SET cats = cats+1
                          WHERE name = 'Fred'");
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
printf ("Number of rows updated: %d\n", $conn->affectedRows ());
#@ _UPDATE_

$conn->disconnect ();
?>
