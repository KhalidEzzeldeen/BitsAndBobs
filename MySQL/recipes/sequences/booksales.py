#!/usr/bin/python
# booksales.py - show how to use LAST_INSERT_ID(expr)

import MySQLdb
import Cookbook

conn = Cookbook.connect ()

try:
#@ _UPDATE_COUNTER_
  cursor = conn.cursor ()
  cursor.execute ("""
                  INSERT INTO booksales (title,copies)
                  VALUES('The Greater Trumps',LAST_INSERT_ID(1))
                  ON DUPLICATE KEY UPDATE copies = LAST_INSERT_ID(copies+1)
                """)
  count = conn.insert_id ()
#@ _UPDATE_COUNTER_
  print "count:", count
  cursor.close ()
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e.args

conn.close ()
