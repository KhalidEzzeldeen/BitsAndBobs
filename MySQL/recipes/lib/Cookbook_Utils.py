# Cookbook_Utils.py - MySQL Cookbook utilities

import sys
import re
import MySQLdb

# Given database and table names, return a list containing the names
# of the table's columns, in table definition order.

#@ _GET_COLUMN_NAMES_
def get_column_names (conn, db_name, tbl_name):
  stmt = """
           SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
           ORDER BY ORDINAL_POSITION
         """
  cursor = conn.cursor ()
  cursor.execute (stmt, (db_name, tbl_name))
  names = []
  for row in cursor.fetchall ():
    names.append (row[0])
  cursor.close ()
  return (names)
#@ _GET_COLUMN_NAMES_

# Given database and table names, return a list containing the names
# of the table's columns, in table definition order.
# Given database and table names, return information about the table columns.
# Return value is a dictionary keyed by column name. Each array element is
# a dictionary keyed by name of column in the INFORMATION_SCHEMA.COLUMNS
# table.

#@ _GET_COLUMN_INFO_
def get_column_info (conn, db_name, tbl_name):
  stmt = """
           SELECT * FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
         """
  cursor = conn.cursor (MySQLdb.cursors.DictCursor)
  cursor.execute (stmt, (db_name, tbl_name))
  col_info = {}
  for row in cursor.fetchall ():
    col_info[row["COLUMN_NAME"]] = row
  cursor.close ()
  return (col_info)
#@ _GET_COLUMN_INFO_

# get_enumorset_info() - get metadata for an ENUM or SET column.
# Take a database connection and database, table, and column names.
# Return a dictionary with name, type, values, default, and
# nullable keys.  Return None if no info available.

#@ _GET_ENUMORSET_INFO_
def get_enumorset_info (conn, db_name, tbl_name, col_name):
  cursor = conn.cursor ()
  stmt = """
        SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s AND COLUMN_NAME = %s
        """
  cursor.execute (stmt, (db_name, tbl_name, col_name))
  row = cursor.fetchone ()
  cursor.close
  if row == None:
    return None

  # create dictionary to hold column information
  info = {}
  info["name"] = row[0]
  # get data type string; make sure it begins with ENUM or SET
  s = row[1]
  p = re.compile ("(ENUM|SET)\((.*)\)$", re.IGNORECASE)
  match = p.match (s)
  if not match:
    return None
  info["type"] = match.group (1)    # data type

  # get values by splitting list at commas, and then applying a
  # quote-stripping function to each one
  s = match.group (2).split (",")
  f = lambda x: re.sub ("^'(.*)'$", "\\1", x)
  info["values"] = map (f, s)

  # determine whether column can contain NULL values
  info["nullable"] = (row[2].upper() == "YES")

  # get default value (None represents NULL)
  info["default"] = row[3]
  return info
#@ _GET_ENUMORSET_INFO_

#@ _CHECK_ENUM_VALUE_
def check_enum_value (conn, db_name, tbl_name, col_name, val):
  valid = 0
  info = get_enumorset_info (conn, db_name, tbl_name, col_name)
  if info != None and info["type"].upper() == "ENUM":
    # use case-insensitive comparison because default collation
    # (latin1_swedish_ci) is case-insensitive (adjust if you use
    # a different collation)
    val = val.upper ()
    for v in info["values"]:
      if val == v.upper ():
        valid = 1
        break
  return (valid)
#@ _CHECK_ENUM_VALUE_
