#!/usr/bin/python
#@ _PROLOG_
# add_element.py - produce ALTER TABLE statement to add an element
# to an ENUM or SET column

import sys
import MySQLdb
import Cookbook

if len (sys.argv) != 5:
  print "Usage: add_element.py db_name tbl_name col_name new_element"
  sys.exit (1)
(db_name, tbl_name, col_name, new_elt) = (sys.argv[1:5])
#@ _PROLOG_

try:
  conn = Cookbook.connect ()
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

try:
#@ _GET_COLUMN_INFO_
  stmt = """
           SELECT COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
           FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s AND COLUMN_NAME = %s
         """
  cursor = conn.cursor ()
  cursor.execute (stmt, (db_name, tbl_name, col_name))
  info = cursor.fetchone ()
  cursor.close
  if info == None:
    print "Could not retrieve information for table %s.%s, column %s" \
                        % (db_name, tbl_name, col_name)
    sys.exit (1)
#@ _GET_COLUMN_INFO_
#@ _CONSTRUCT_QUERY_
  # get data type string; make sure it begins with ENUM or SET
  type = info[0]
  if type[0:5].upper() != "ENUM(" and type[0:4].upper() != "SET(":
    print "table %s.%s, column %s is not an ENUM or SET" % \
          (db_name, tbl_name, col_name)
    sys.exit(1)
  # insert comma and properly quoted new element just before closing paren
  type = type[0:len(type)-1] + "," + conn.literal (new_elt) + ")"

  # if column cannot contain NULL values, add "NOT NULL"
  if info[1].upper() == "YES":
    nullable = ""
  else:
    nullable = "NOT NULL ";

  # construct DEFAULT clause (quoting value as necessary)
  default = "DEFAULT " + conn.literal (info[2])

  print "ALTER TABLE `%s`.`%s`\n  MODIFY `%s`\n  %s\n  %s%s;" \
          % (db_name, tbl_name, col_name, type, nullable, default)
#@ _CONSTRUCT_QUERY_
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

conn.close ()
