<?php
# sm_mysql_status.php - print some MySQL server status information

require_once "Smarty.class.php";
require_once "Cookbook.php";

$title = "MySQL Server Status";

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

$smarty = new Smarty ();
$smarty->assign ("title", $title);
$smarty->assign ("now", $now);
$smarty->assign ("version", $version);
$smarty->assign ("uptime", $uptime);
$smarty->assign ("q_per_sec", $q_per_sec);
$smarty->display ("sm_mysql_status.tmpl");
?>
