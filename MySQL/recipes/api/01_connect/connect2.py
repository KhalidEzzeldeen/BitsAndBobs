#!/usr/bin/python
# connect2.py - connect to the MySQL server, showing how to specify
# a port number or Unix domain socket path explicitly.

import MySQLdb

try:
#@ _FRAG1_
  conn = MySQLdb.connect (db = "cookbook",
                          host = "mysql.example.com",
                          port = 3307,
                          user = "cbuser",
                          passwd = "cbpass")
#@ _FRAG1_
except:
  print "Cannot connect to server"
else:
  print "Connected"
  conn.close ()
  print "Disconnected"

try:
#@ _FRAG2_
  conn = MySQLdb.connect (db = "cookbook",
                          host = "localhost",
                          unix_socket = "/var/tmp/mysql.sock",
                          user = "cbuser",
                          passwd = "cbpass")
#@ _FRAG2_
except:
  print "Cannot connect to server"
else:
  print "Connected"
  conn.close ()
  print "Disconnected"
