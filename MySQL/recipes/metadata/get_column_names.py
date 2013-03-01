#!/usr/bin/python
# get_column_names.py - wrapper to demonstrate get_column_names()
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

print "Using get_column_names()";
print "Columns in %s.%s table:" % (db_name, tbl_name)
names = get_column_names (conn, db_name, tbl_name)
print ", ".join (names)

# construct "all but" statement
print "Construct statement to select all but data column:"
#@ _ALL_BUT_
names = get_column_names (conn, db_name, tbl_name)
# remove "data" from list of names; use try because remove
# raises an exception if value isn't in list
try:
  names.remove ("data")
except:
  pass
stmt = "SELECT `%s` FROM `%s`.`%s`" % ("`, `".join (names), db_name, tbl_name)
#@ _ALL_BUT_
print stmt

conn.close ()
