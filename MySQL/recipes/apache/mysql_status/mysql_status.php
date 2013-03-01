<?php
# mysql_status.php - print some MySQL server status information

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
?>

<html>
<head>
<title>MySQL Server Status</title>
</head>
<body bgcolor="white">

<?php
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
?>

<!-- Display status report -->
<p>Current time: <?php print ($now); ?></p>
<p>Server version: <?php print ($version); ?></p>
<p>Server uptime (seconds): <?php print ($uptime); ?></p>
<!-- #@ _QUERIES_ -->
<p>Queries processed:  <?php print ($queries); ?>
 (<?php print ($q_per_sec); ?> queries/second)</p>
<!-- #@ _QUERIES_ -->

</body>
</html>

