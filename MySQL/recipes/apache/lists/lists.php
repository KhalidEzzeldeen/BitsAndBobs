<?php
# lists.php - generate HTML lists

require_once "Cookbook.php";
require_once "Cookbook_Webutils.php";

$title = "Query Output Display - Lists";

?>

<html>
<head>
<title><?php print ($title); ?></title>
</head>
<body bgcolor="white">

<?php
# ----------------------------------------------------------------------

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

# Display some lists "manually", printing tags as items are fetched

print ("<p>Ordered list:</p>\n");

#@ _ORDERED_LIST_INTERTWINED_
$stmt = "SELECT item FROM ingredient ORDER BY id";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
print ("<ol>\n");
while (list ($item) = $result->fetchRow ())
  print ("<li>" . htmlspecialchars ($item) . "</li>\n");
$result->free ();
print ("</ol>\n");
#@ _ORDERED_LIST_INTERTWINED_

print ("<p>Unordered list:</p>\n");

#@ _UNORDERED_LIST_INTERTWINED_
$stmt = "SELECT item FROM ingredient ORDER BY id";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
print ("<ul>\n");
while (list ($item) = $result->fetchRow ())
  print ("<li>" . htmlspecialchars ($item) . "</li>\n");
$result->free ();
print ("</ul>\n");
#@ _UNORDERED_LIST_INTERTWINED_

print ("<p>Definition list:</p>\n");

#@ _DEFINITION_LIST_INTERTWINED_
$stmt = "SELECT note, mnemonic FROM doremi ORDER BY id";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
print ("<dl>\n");
while (list ($note, $mnemonic) = $result->fetchRow ())
{
  print ("<dt>" . htmlspecialchars ($note) . "</dt>\n");
  print ("<dd>" . htmlspecialchars ($mnemonic) . "</dd>\n");
}
$result->free ();
print ("</dl>\n");
#@ _DEFINITION_LIST_INTERTWINED_

# Display some lists using utility functions.

# Fetch items for use with ordered/unordered list functions

#@ _FETCH_ITEM_LIST_
# fetch items for list
$stmt = "SELECT item FROM ingredient ORDER BY id";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
$items = array ();
while (list ($item) = $result->fetchRow ())
  $items[] = $item;
$result->free ();
#@ _FETCH_ITEM_LIST_

print ("<p>Ordered list:</p>\n");

#@ _ORDERED_LIST_FUNCTION_
# generate HTML list
print (make_ordered_list ($items));
#@ _ORDERED_LIST_FUNCTION_

print ("<p>Unordered list:</p>\n");

#@ _UNORDERED_LIST_FUNCTION_
# generate HTML list
print (make_unordered_list ($items));
#@ _UNORDERED_LIST_FUNCTION_

# Fetch terms and definitions for a definition list

#@ _FETCH_DEFINITION_LIST_
# fetch items for list
$stmt = "SELECT note, mnemonic FROM doremi ORDER BY id";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
$terms = array ();
$defs = array ();
while (list ($note, $mnemonic) = $result->fetchRow ())
{
  $terms[] = $note;
  $defs[] = $mnemonic;
}
$result->free ();
#@ _FETCH_DEFINITION_LIST_

print ("<p>Definition list:</p>\n");

#@ _DEFINITION_LIST_FUNCTION_
# generate HTML list
print (make_definition_list ($terms, $defs));
#@ _DEFINITION_LIST_FUNCTION_

$conn->disconnect ();

print ("<p>Ordered and unordered lists from non-database source:</p>\n");

#@ _NON_DB_DATA_SOURCE_
# create items for list
$items = array (
  "Little Jack Horner,",
  "Sat in a corner,",
  "Eating a Christmas pie.",
  "He stuck in his thumb,",
  "And pulled out a plum,",
  "And said, \"What a good boy am I.\""
);
#@ _NON_DB_DATA_SOURCE_

print (make_ordered_list ($items));
print (make_unordered_list ($items));

?>

</body>
</html>
