#!/usr/bin/python
# get_connection_meta.py - get connection metadata

import sys
import MySQLdb
import Cookbook

try:
  conn = Cookbook.connect ()
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

try:
#@ _CURRENT_DATABASE_
  cursor = conn.cursor ()
  cursor.execute ("SELECT DATABASE()")
  row = cursor.fetchone ()
  cursor.close
  if row == None or len (row) == 0 or row[0] == None:
    db = "(no database selected)"
  else:
    db = row[0]
  print "Default database:", db
#@ _CURRENT_DATABASE_
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

conn.close ()
