#!/usr/bin/python
# get_enumorset_info.py - wrapper to demonstrate get_enumorset_info()
# utility routine.

# Usage: get_enumorset_info.py db_name tbl_name col_name

import sys
import MySQLdb
import Cookbook
from Cookbook_Utils import *


if len (sys.argv) != 4:
  print "Usage: get_enumorset_info.py db_name tbl_name col_name"
  sys.exit (1)
db_name = sys.argv[1]
tbl_name = sys.argv[2]
col_name = sys.argv[3]

try:
  conn = Cookbook.connect ()
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

#@ _USE_FUNCTION_
info = get_enumorset_info (conn, db_name, tbl_name, col_name)
print "Information for " + db_name + "." + tbl_name + "." + col_name + ":"
if info == None:
  print "No information available (not an ENUM or SET column?)"
else:
  print "Name: " + info["name"]
  print "Type: " + info["type"]
  print "Legal values: " + ",".join (info["values"])
  if info["nullable"]:
    print "Nullable: yes"
  else:
    print "Nullable: no"
  if info["default"] == None:
    print "Default value: NULL"
  else:
    print "Default value: " + info["default"]
#@ _USE_FUNCTION_

conn.close ()
