#!/usr/bin/python
# affected_rows.py

import sys
import MySQLdb
import Cookbook

try:
  conn = Cookbook.connect ()
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

stmt = "UPDATE profile SET cats = cats+1 WHERE name = 'Fred'"
try:
#@ _FRAG_
  cursor = conn.cursor ()
  cursor.execute (stmt)
  print "Number of rows affected: %d" % cursor.rowcount
#@ _FRAG_
except:
  print "Oops, the statement failed"

conn.close ()

# illustrate how to get rows-matched counts rather than rows-changed counts

#@ _IMPORT_CONSTANTS_
import MySQLdb.constants.CLIENT
#@ _IMPORT_CONSTANTS_

try:
#@ _FOUND_ROWS_
  conn = MySQLdb.connect (db = "cookbook",
                          host = "localhost",
                          user = "cbuser",
                          passwd = "cbpass",
                          client_flag = MySQLdb.constants.CLIENT.FOUND_ROWS)
#@ _FOUND_ROWS_
except MySQLdb.Error, e:
  print "Message:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)
  print "Connected"

# this statement doesn't change any rows, but the row count should still
# be nonzero due to the use of rows-matched counts
stmt = "UPDATE limbs SET arms = 0 WHERE arms = 0"

try:
  cursor = conn.cursor ()
  cursor.execute (stmt)
  print "Number of rows affected: %d" % cursor.rowcount
except:
  print "Oops, the statement failed"

conn.close ()
