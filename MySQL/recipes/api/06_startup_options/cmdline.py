#!/usr/bin/python
# cmdline.py - demonstrate command-line option parsing in Python

import sys
import getopt
import MySQLdb

try:
  opts, args = getopt.getopt (sys.argv[1:],
                              "h:p:u:",
                              [ "host=", "password=", "user=" ])
except getopt.error, e:
  # for errors, print program name and text of error message
  print "%s: %s" % (sys.argv[0], e)
  sys.exit (1)

# default connection parameter values (all empty)
host_name = password = user_name = ""

# iterate through options, extracting whatever values are present
for opt, arg in opts:
  if opt in ("-h", "--host"):
    host_name = arg
  elif opt in ("-p", "--password"):
    password = arg
  elif opt in ("-u", "--user"):
    user_name = arg

# any remaining nonoption arguments are left in
# args and can be processed here as necessary

try:
  conn = MySQLdb.connect (db = "cookbook",
                          host = host_name,
                          user = user_name,
                          passwd = password)
  print "Connected"
except MySQLdb.Error, e:
  print "Cannot connect to server"
  print "Error:", e.args[1]
  print "Code:", e.args[0]
  sys.exit (1)

conn.close ()
print "Disconnected"
