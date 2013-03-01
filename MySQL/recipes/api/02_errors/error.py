#!/usr/bin/python
# error.py - demonstrate MySQL error-handling

import sys
import MySQLdb

#@ _FRAG_
try:
  conn = MySQLdb.connect (db = "cookbook",
                          host = "localhost",
                          user = "cbuser",
                          passwd = "cbpass")
  print "Connected"
except MySQLdb.Error, e:
  print "Cannot connect to server"
  print "Error code:", e.args[0]
  print "Error message:", e.args[1]
  sys.exit (1)
#@ _FRAG_

conn.close()
print "Disconnected"
