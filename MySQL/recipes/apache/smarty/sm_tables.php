<?php
# smtables.php - generate HTML tables

require_once "Smarty.class.php";
require_once "Cookbook.php";

$title = "Query Output Display - Tables";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

# Fetch items for table

$stmt = "SELECT year, artist, title FROM cd ORDER BY artist, year";
$rows =& $conn->getAll ($stmt, array (), DB_FETCHMODE_ASSOC);
if (PEAR::isError ($rows))
  die (htmlspecialchars ($result->getMessage ()));

$conn->disconnect ();

$smarty = new Smarty ();
$smarty->assign ("title", $title);
$smarty->assign ("rows", $rows);
$smarty->display ("sm_tables.tmpl");

?>
