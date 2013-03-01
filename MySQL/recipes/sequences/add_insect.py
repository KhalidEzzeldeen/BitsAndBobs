#!/usr/bin/python
# add_insect.py - demonstrate client-side insert_id() cursor method
# for getting the most recent AUTO_INCREMENT value.

import MySQLdb
import Cookbook

conn = Cookbook.connect ()

try:
#@ _INSERT_ID_
  cursor = conn.cursor ()
  cursor.execute ("""
                  INSERT INTO insect (name,date,origin)
                  VALUES('moth','2006-09-14','windowsill')
                """)
  seq = conn.insert_id ()
#@ _INSERT_ID_
  print "seq:", seq
  cursor.close ()
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e.args

conn.close ()
