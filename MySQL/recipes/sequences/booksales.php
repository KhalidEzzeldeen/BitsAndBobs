<?php
# booksales.php - show how to use LAST_INSERT_ID(expr)

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage ());

$stmt = "INSERT INTO booksales (title,copies)
         VALUES('The Greater Trumps',LAST_INSERT_ID(1))
         ON DUPLICATE KEY UPDATE copies = LAST_INSERT_ID(copies+1)";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die ("Cannot update sales value");
$result =& $conn->query ("SELECT LAST_INSERT_ID()");
if (PEAR::isError ($result))
  die ("Cannot fetch sales value");
list ($count) = $result->fetchRow ();
print ("count: $count\n");

$conn->disconnect ();

?>
