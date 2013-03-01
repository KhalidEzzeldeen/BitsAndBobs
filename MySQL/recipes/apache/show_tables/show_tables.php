<?php
# show_tables.php - Display names of tables in cookbook database

require_once "Cookbook.php";

?>

<html>
<head>
<title>Tables in cookbook Database</title>
</head>
<body bgcolor="white">

<p>Tables in cookbook database:</p>

<?php

# Connect to database, display table list, disconnect
$conn =& Cookbook::connect ();
$stmt = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
         WHERE TABLE_SCHEMA = 'cookbook' ORDER BY TABLE_NAME";
$result =& $conn->query ($stmt);
while (list ($tbl_name) = $result->fetchRow ())
  print ($tbl_name . "<br />\n");
$result->free ();
$conn->disconnect ();

?>

</body>
</html>
