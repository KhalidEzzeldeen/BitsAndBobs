<?php
# null-in-result.php - print undef values as "NULL"

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server\n");

#@ _FETCHLOOP_1_
$result =& $conn->query ("SELECT name, birth, foods FROM profile");
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
while ($row =& $result->fetchRow ())
{
  foreach ($row as $key => $value)
  {
    if ($row[$key] === NULL)
      $row[$key] = "NULL";
  }
  print ("name: $row[0], birth: $row[1], foods: $row[2]\n");
}
$result->free ();
#@ _FETCHLOOP_1_

$conn->disconnect ();
?>
