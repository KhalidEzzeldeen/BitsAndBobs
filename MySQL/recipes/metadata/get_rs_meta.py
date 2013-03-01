#!/usr/bin/python
# get_rs_meta.py - run a statement and display its result set metadata

# The program runs a default statement, which can be overridden by supplying
# a statement as an argument on the command line.

import sys
import MySQLdb
import Cookbook

#@ _DEFAULT_STATEMENT_
stmt = "SELECT name, foods FROM profile"
#@ _DEFAULT_STATEMENT_
# override statement with command line argument if one was given
if len (sys.argv) > 1:
  stmt = sys.argv[1]

try:
  conn = Cookbook.connect ()
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

try:
#@ _DISPLAY_METADATA_
  print "Statement: ", stmt
  cursor = conn.cursor ()
  cursor.execute (stmt)
  # metadata information becomes available at this point ...
  print "Number of rows:", cursor.rowcount
  if cursor.description == None:  # no result set
    ncols = 0
  else:
    ncols = len (cursor.description)
  print "Number of columns:", ncols
  if ncols == 0:
    print "Note: statement has no result set"
  for i in range (ncols):
    col_info = cursor.description[i]
    # print name, and then other information
    print "--- Column %d (%s) ---" % (i, col_info[0])
    print "Type:         ", col_info[1]
    print "Display size: ", col_info[2]
    print "Internal size:", col_info[3]
    print "Precision:    ", col_info[4]
    print "Scale:        ", col_info[5]
    print "Nullable:     ", col_info[6]
  cursor.close
#@ _DISPLAY_METADATA_
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

conn.close ()
