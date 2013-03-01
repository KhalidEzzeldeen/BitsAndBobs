#!/usr/bin/python
# option_file.py - demonstrate connect options for reading MySQL option files

import os
import sys
import MySQLdb

try:
#@ _FRAG1_
  option_file = os.environ["HOME"] + "/" + ".my.cnf"
  conn = MySQLdb.connect (db = "cookbook", read_default_file = option_file)
#@ _FRAG1_
  print "Connected"
except:
  print "Cannot connect to server"
  sys.exit (1)

conn.close ()
print "Disconnected"

try:
#@ _FRAG2_
  conn = MySQLdb.connect (db = "cookbook", read_default_group = "cookbook")
#@ _FRAG2_
  print "Connected"
except:
  print "Cannot connect to server"
  sys.exit (1)

conn.close ()
print "Disconnected"
