<?php
# clicksort.php - display query result as HTML table with "click to sort"
# column headings

# Rows from the database table are displayed as an HTML table.
# Column headings are presented as hyperlinks that reinvoke the
# script to redisplay the table sorted by the corresponding column.
# The display is limited to 50 rows in case the table is large.

require_once "Cookbook.php";
require_once "Cookbook_Webutils.php";

$title = "Table Display with Click-To-Sort Column Headings";

?>

<html>
<head>
<title><?php print ($title); ?></title>
</head>
<body bgcolor="white">

<?php
# ----------------------------------------------------------------------

# names for database and table and default sort column; change as desired
$db_name = "cookbook";
$tbl_name = "mail";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

print ("<p>" . htmlspecialchars ("Table: $db_name.$tbl_name") . "</p>\n");
print ("<p>Click on a column name to sort by that column.</p>\n");

# Get the name of the column to sort by: If missing, use the first column.

$sort_col = get_param_val ("sort");
if (!isset ($sort_col))
{
  $stmt = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
           AND ORDINAL_POSITION = 1";
  $result =& $conn->query ($stmt, array ($db_name, $tbl_name));
  if (PEAR::isError ($result))
    die (htmlspecialchars ($result->getMessage ()));
  if (!(list ($sort_col) = $result->fetchRow ()))
    die (htmlspecialchars ($result->getMessage ()));
  $result->free ();
}

# Construct query to select records from the table, sorting by the
# named column.  (The column name comes from the environment, so quote
# it to avoid an SQL injection attack.)
# Limit output to 50 rows to avoid dumping entire contents of large tables.

$stmt = "SELECT * FROM $db_name.$tbl_name";
$stmt .= " ORDER BY " . $conn->quoteIdentifier ($sort_col);
$stmt .= " LIMIT 50";

$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));

# Display query results as HTML table.  Use query metadata to get column
# names, and display names in first row of table as hyperlinks that cause
# the table to be redisplayed, sorted by the corresponding table column.

print ("<table border=\"1\">\n");
#@ _HEADER_ROW_
$self_path = get_self_path ();
print ("<tr>\n");
$info =& $conn->tableInfo ($result, NULL);
if (PEAR::isError ($info))
  die (htmlspecialchars ($result->getMessage ()));
for ($i = 0; $i < $result->numCols (); $i++)
{
  $col_name = $info[$i]["name"];
  printf ("<th><a href=\"%s?sort=%s\">%s</a></th>\n",
          $self_path,
          urlencode ($col_name),
          htmlspecialchars ($col_name));
}
print ("</tr>\n");
#@ _HEADER_ROW_
while ($row =& $result->fetchRow ())
{
  print ("<tr>\n");
  for ($i = 0; $i < $result->numCols (); $i++)
  {
    # encode values, using &nbsp; for empty cells
    $val = $row[$i];
    if (isset ($val) && $val != "")
      $val = htmlspecialchars ($val);
    else
      $val = "&nbsp;";
    printf ("<td>%s</td>\n", $val);
  }
  print ("</tr>\n");
}
$result->free ();
print ("</table>\n");

$conn->disconnect ();

?>

</body>
</html>
