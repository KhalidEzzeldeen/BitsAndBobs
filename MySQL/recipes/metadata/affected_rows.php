<?php
# affected_rows.php

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($result))
  die ("Cannot connect to server: " . $conn->getMessage ());

$stmt = "UPDATE profile SET cats = cats+1 WHERE name = 'Fred'";
#@ _FRAG_
$result =& $conn->query ($stmt);
# report 0 rows if the statement failed
$count = (PEAR::isError ($result) ? 0 : $conn->affectedRows ());
print ("Number of rows affected: $count\n");
#@ _FRAG_

$conn->disconnect ();
?>
