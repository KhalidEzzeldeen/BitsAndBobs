<?php
# error.php - demonstrate MySQL error-handling

require_once "DB.php";

#@ _FRAG_
$dsn = "mysqli://cbuser:cbpass@localhost/cookbook";
$conn =& DB::connect ($dsn);
if (PEAR::isError ($conn))
{
  print ("Cannot connect to server.\n");
  printf ("Error code: %d\n", $conn->getCode ());
  printf ("Error message: %s\n", $conn->getMessage ());
  printf ("Error debug info: %s\n", $conn->getDebugInfo ());
  printf ("Error user info: %s\n", $conn->getUserInfo ());
  exit (1);
}
#@ _FRAG_
print ("Connected\n");
$conn->disconnect ();
print ("Disconnected\n");
?>
