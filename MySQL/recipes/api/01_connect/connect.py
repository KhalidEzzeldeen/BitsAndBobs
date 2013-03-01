#!/usr/bin/python
# connect.py - connect to the MySQL server

import sys
import MySQLdb

try:
  conn = MySQLdb.connect (db = "cookbook",
                          host = "localhost",
                          user = "cbuser",
                          passwd = "cbpass")
  print "Connected"
except:
  print "Cannot connect to server"
  sys.exit (1)

conn.close ()
print "Disconnected"
