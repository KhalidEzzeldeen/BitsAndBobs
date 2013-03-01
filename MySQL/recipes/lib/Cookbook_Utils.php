<?php
# Cookbook_Utils.php - MySQL Cookbook utilities

# Given database and table names, return an array containing the
# names of the table's columns, in table definition order.
# Return FALSE if an error occurs.

#@ _GET_COLUMN_NAMES_
function get_column_names ($conn, $db_name, $tbl_name)
{
  $stmt = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
           ORDER BY ORDINAL_POSITION";
  $result =& $conn->query ($stmt, array ($db_name, $tbl_name));
  if (PEAR::isError ($result))
    return (FALSE);
  $names = array();
  while (list ($col_name) = $result->fetchRow ())
    $names[] = $col_name;
  $result->free ();
  return ($names);
}
#@ _GET_COLUMN_NAMES_

# Given database and table names, return information about the table columns.
# Return value is an array keyed by column name. Each array element is
# an array keyed by name of column in the INFORMATION_SCHEMA.COLUMNS table.
# Return FALSE if an error occurs.

#@ _GET_COLUMN_INFO_
function get_column_info ($conn, $db_name, $tbl_name)
{
  $stmt = "SELECT * FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?";
  $result =& $conn->query ($stmt, array ($db_name, $tbl_name));
  if (PEAR::isError ($result))
    return (FALSE);
  $col_info = array();
  while ($row =& $result->fetchRow (DB_FETCHMODE_ASSOC))
    $col_info[$row["COLUMN_NAME"]] = $row;
  $result->free ();
  return ($col_info);
}
#@ _GET_COLUMN_INFO_

# get_enumorset_info() - get metadata for an ENUM or SET column.
# Take a connection identifier and database, table, and column names.
# Return an associative array with name, type, values, default,
# and nullable elements.  Return FALSE if no info available or
# an error occurs.

#@ _GET_ENUMORSET_INFO_
function get_enumorset_info ($conn, $db_name, $tbl_name, $col_name)
{
  $stmt = "SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
           FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND COLUMN_NAME = ?";
  $result =& $conn->query ($stmt, array ($db_name, $tbl_name, $col_name));
  if (PEAR::isError ($result))
    return (FALSE);
  if (!($row =& $result->fetchRow ()))
    return (FALSE);
  $result->free ();
  $info = array ("name" => $row[0]);
  if (!preg_match ("/^(ENUM|SET)\((.*)\)$/i", $row[1], $match))
    return (FALSE);
  $info["type"] = $match[1];
  # split value list at commas
  $info["values"] = explode (",", $match[2]);
  # remove surrounding quotes from values
  $info["values"] = preg_replace ("/^'(.*)'$/", "\\1", $info["values"]);
  # determine whether column can contain NULL values
  $info["nullable"] = (strtoupper ($row[2]) == "YES");
  # get default value (unset value represents NULL)
  $info["default"] = $row[3];
  return ($info);
}
#@ _GET_ENUMORSET_INFO_

#@ _CHECK_ENUM_VALUE_
function check_enum_value ($conn, $db_name, $tbl_name, $col_name, $val)
{
  $valid = 0;
  $info = get_enumorset_info ($conn, $db_name, $tbl_name, $col_name);
  if ($info && strtoupper ($info["type"]) == "ENUM")
  {
    # use case-insensitive comparison because default collation
    # (latin1_swedish_ci) is case-insensitive (adjust if you use
    # a different collation)
    $val = strtoupper ($val);
    foreach ($info["values"] as $k => $v)
    {
      if ($val == strtoupper ($v))
      {
        $valid = 1;
        break;
      }
    }
  }
  return ($valid);
}
#@ _CHECK_ENUM_VALUE_

?>
