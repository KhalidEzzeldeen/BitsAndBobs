<?php
# get_rs_meta.php - run a statement and display its result set metadata

# The program runs a default statement, which can be overridden by supplying
# a statement as an argument on the command line.

require_once "Cookbook.php";

#@ _DEFAULT_STATEMENT_
$stmt = "SELECT name, foods FROM profile";
#@ _DEFAULT_STATEMENT_
# override statement with command line argument if one was given
if ($argc > 1)
  $stmt = $argv[1];

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server\n");

#@ _DISPLAY_METADATA_
print ("Statement: $stmt\n");
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die ("Statement failed\n");
# metadata information becomes available at this point ...
if (is_a ($result, "DB_result"))  # statement generates a result set
{
  $nrows = $result->numRows ();
  $ncols = $result->numCols ();
  $info =& $conn->tableInfo ($result);
}
else                              # statement generates no result set
{
  $nrows = 0;
  $ncols = 0;
}
print ("Number of rows: $nrows\n");
print ("Number of columns: $ncols\n");
if ($ncols == 0)
  print ("Note: statement has no result set\n");
for ($i = 0; $i < $ncols; $i++)
{
  $col_info = $info[$i];
  printf ("--- Column %d (%s) ---\n", $i, $col_info["name"]);
  printf ("type:         %s\n", $col_info["type"]);
  printf ("len:          %s\n", $col_info["len"]);
  printf ("flags:        %s\n", $col_info["flags"]);
}
if ($ncols > 0)   # dispose of result set, if there is one
  $result->free ();
#@ _DISPLAY_METADATA_

$conn->disconnect ();
?>
