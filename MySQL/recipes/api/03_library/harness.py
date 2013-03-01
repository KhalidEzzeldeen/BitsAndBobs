#!/usr/bin/python
# harness.py - test harness for Cookbook.py library

import sys
import MySQLdb
import Cookbook

try:
  conn = Cookbook.connect ()
  print "Connected"
except MySQLdb.Error, e:
  print "Cannot connect to server"
  print "Error code:", e.args[0]
  print "Error message:", e.args[1]
  sys.exit (1)

conn.close ()
print "Disconnected"
