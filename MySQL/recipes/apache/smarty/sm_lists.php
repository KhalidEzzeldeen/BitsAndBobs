<?php
# sm_lists.php - generate HTML lists

require_once "Smarty.class.php";
require_once "Cookbook.php";

$title = "Query Output Display - Lists";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

# Fetch items for ordered, unordered lists
# (create an array of scalar values)

$stmt = "SELECT item FROM ingredient ORDER BY id";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
$list = array ();
while (list ($item) = $result->fetchRow ())
  $list[] = $item;
$result->free ();

# Fetch terms and definitions for a definition list
# (create an array of associative arrays)

$stmt = "SELECT note, mnemonic FROM doremi ORDER BY id";
$defn_list =& $conn->getAll ($stmt, array (), DB_FETCHMODE_ASSOC);
if (PEAR::isError ($defn_list))
  die (htmlspecialchars ($result->getMessage ()));

$conn->disconnect ();

$smarty = new Smarty ();
$smarty->assign ("title", $title);
$smarty->assign ("list", $list);
$smarty->assign ("defn_list", $defn_list);
$smarty->display ("sm_lists.tmpl");

?>
