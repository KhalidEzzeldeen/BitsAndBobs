<?php
# mysql_status_print.php - print some MySQL server status information
# using print() to generate all HTML

require_once "Cookbook.php";

# Helper function: execute a query, return first result row as an array

function fetch_row ($conn, $stmt)
{
  $result =& $conn->query ($stmt);
  if (PEAR::isError ($result))
    die ("Cannot execute query: "
         . htmlspecialchars ($result->getMessage ()));
  $row = $result->fetchRow ();
  $result->free ();
  return ($row);
}

print ("<html>\n");
print ("<head>\n");
print ("<title>MySQL Server Status</title>\n");
print ("</head>\n");
print ("<body bgcolor=\"white\">\n");

# Connect to database
$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

# Retrieve status information
list ($now, $version) = fetch_row ($conn, "SELECT NOW(), VERSION()");
# SHOW STATUS variable values are in second result column
list ($junk, $queries) =
  fetch_row ($conn, "SHOW /*!50002 GLOBAL */ STATUS LIKE 'Questions'");
list ($junk, $uptime) =
  fetch_row ($conn, "SHOW /*!50002 GLOBAL */ STATUS LIKE 'Uptime'");
$q_per_sec = sprintf ("%.2f", $queries/$uptime);

# Disconnect from database
$conn->disconnect ();

# Display status report
print ("<p>Current time: $now</p>\n");
print ("<p>Server version: $version</p>\n");
print ("<p>Server uptime (seconds): $uptime</p>\n");
#@ _QUERIES_
print ("<p>Queries processed:  $queries ($q_per_sec queries/second)</p>\n");
#@ _QUERIES_

print ("</body>\n");
print ("</html>\n");
?>
