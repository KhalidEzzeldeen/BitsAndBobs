<?php
# connect.php - connect to the MySQL server

require_once "DB.php";

#@ _FRAG_
$dsn = "mysqli://cbuser:cbpass@localhost/cookbook";
$conn =& DB::connect ($dsn);
if (PEAR::isError ($conn))
  die ("Cannot connect to server\n");
print ("Connected\n");
#@ _FRAG_
$conn->disconnect ();
print ("Disconnected\n");
?>
