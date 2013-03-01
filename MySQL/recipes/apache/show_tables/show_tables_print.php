<?php
# show_tables_print.php - Display names of tables in cookbook database
# using print() to generate all HTML

require_once "Cookbook.php";

print ("<html>\n");
print ("<head>\n");
print ("<title>Tables in cookbook Database</title>\n");
print ("</head>\n");
print ("<body bgcolor=\"white\">\n");
print ("<p>Tables in cookbook database:</p>\n");

# Connect to database, display table list, disconnect
$conn =& Cookbook::connect ();
$stmt = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
         WHERE TABLE_SCHEMA = 'cookbook' ORDER BY TABLE_NAME";
$result =& $conn->query ($stmt);
while (list ($tbl_name) = $result->fetchRow ())
  print ($tbl_name . "<br />\n");
$result->free ();
$conn->disconnect ();

print ("</body>\n");
print ("</html>\n");
?>
