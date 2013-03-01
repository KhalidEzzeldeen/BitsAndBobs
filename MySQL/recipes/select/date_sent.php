<?php
# date_sent.php - fetch rows into object, refer to columns by name

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage ());

#@ FRAG
$result =& $conn->query ("SELECT srcuser,
                          DATE_FORMAT(t,'%M %e, %Y') AS date_sent
                          FROM mail");
if (PEAR::isError ($result))
  die ("Oops, the statement failed: " . $result->getMessage ());
while ($row =& $result->fetchRow (DB_FETCHMODE_OBJECT))
  printf ("user: %s, date sent: %s\n", $row->srcuser, $row->date_sent);
$result->free ();
#@ FRAG

$conn->disconnect ();

?>
