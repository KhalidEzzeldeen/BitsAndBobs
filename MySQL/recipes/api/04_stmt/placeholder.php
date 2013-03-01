<?php
# placeholder.php - demonstrate statement processing in PHP
# (with placeholders)

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
{
  print ("Cannot connect to server.\n");
  printf ("Error message: %s\n", $conn->getMessage ());
  exit (1);
}

# Pass data values directly to query()

print ("Execute INSERT statement with do()\n");
#@ _PLACEHOLDER_QUERY_
$result =& $conn->query ("INSERT INTO profile (name,birth,color,foods,cats)
                          VALUES(?,?,?,?,?)",
                         array ("De'Mont","1973-01-12",NULL,"eggroll",4));
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
#@ _PLACEHOLDER_QUERY_
printf ("Number of rows inserted: %d\n", $conn->affectedRows ());

# Prepare a statement, then pass the statement and data values to execute()

print ("Execute INSERT statement with prepare() + execute()\n");
#@ _PLACEHOLDER_PREPARE_EXECUTE_1_
$stmt =& $conn->prepare ("INSERT INTO profile (name,birth,color,foods,cats)
                          VALUES(?,?,?,?,?)");
if (PEAR::isError ($stmt))
  die ("Oops, statement preparation failed");
$result =& $conn->execute ($stmt,
                           array ("De'Mont","1973-01-12",NULL,"eggroll",4));
if (PEAR::isError ($result))
  die ("Oops, statement execution failed");
#@ _PLACEHOLDER_PREPARE_EXECUTE_1_
printf ("Number of rows inserted: %d\n", $conn->affectedRows ());

print ("Select rows using placeholder\n");
#@ _PLACEHOLDER_PREPARE_EXECUTE_2_
$result =& $conn->query ("SELECT * FROM profile WHERE cats > ?", array (2));
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
while ($row =& $result->fetchRow (DB_FETCHMODE_ASSOC))
{
  printf ("id: %s, name: %s, cats: %s\n",
      $row["id"], $row["name"], $row["cats"]);
}
$result->free ();
#@ _PLACEHOLDER_PREPARE_EXECUTE_2_

print ("Construct INSERT statement usinq quoteSmart()\n");
#@ _QUOTESMART_
$stmt = sprintf ("INSERT INTO profile (name,birth,color,foods,cats)
                  VALUES(%s,%s,%s,%s,%s)",
                 $conn->quoteSmart ("De'Mont"),
                 $conn->quoteSmart ("1973-01-12"),
                 $conn->quoteSmart (NULL),
                 $conn->quoteSmart ("eggroll"),
                 $conn->quoteSmart (4));
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die ("Oops, the statement failed");
#@ _QUOTESMART_
print ("Statement:\n$stmt\n");
printf ("Number of rows inserted: %d\n", $conn->affectedRows ());

$conn->disconnect ();
?>

