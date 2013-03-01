#!/usr/bin/python
# get_column_info.py - wrapper to demonstrate get_column_info()
# utility routine

# Assumes that you've created the "image" table!

import sys
import MySQLdb
import Cookbook
from Cookbook_Utils import *

db_name = "cookbook"
tbl_name = "image"

try:
  conn = Cookbook.connect ()
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

print "Using get_column_info()";
print "Column information for %s.%s table:" % (db_name, tbl_name)
info = get_column_info (conn, db_name, tbl_name)
for col_name in info:
  col_info = info[col_name]
  print "  Column: " + col_name
  for col_info_key in col_info:
    print "    %s: %s" % (col_info_key, col_info[col_info_key])

conn.close ()
