<?php
# get_enumorset_info.php - wrapper to demonstrate get_enumorset_info()
# utility routine.

# Usage: php get_enumorset_info.php db_name tbl_name col_name

require_once "Cookbook.php";
require_once "Cookbook_Utils.php";

if ($argc != 4)
  die ("Usage: get_enumorset_info.php db_name tbl_name col_name\n");

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage ());
$info = get_enumorset_info ($conn, $argv[1], $argv[2], $argv[3]);
printf ("Information for %s.%s.%s:\n", $argv[1], $argv[2], $argv[3]);
if (!$info)
  print ("No information available (not an ENUM or SET column?)\n");
else
{
  print ("Name: " . $info["name"] . "\n");
  print ("Type: " . $info["type"] . "\n");
  print ("Legal values: " . join (",", $info["values"]) . "\n");
  print ("Nullable: " . ($info["nullable"] ? "yes" : "no") . "\n");
  printf ("Default value: %s\n",
      ($info["default"] === NULL ? "NULL" : $info["default"]));
}

$conn->disconnect ();
?>
