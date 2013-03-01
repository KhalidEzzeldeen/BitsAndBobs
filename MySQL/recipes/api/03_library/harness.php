<?php
# harness.php - test harness for Cookbook.php library

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage () . "\n");
print ("Connected\n");
$conn->disconnect ();
print ("Disconnected\n");

?>
