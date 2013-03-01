#!/usr/bin/python
# date_sent.py - fetch rows into dictionary, refer to columns by name

import Cookbook
import MySQLdb

conn = Cookbook.connect ()

#@ _FRAG_
cursor = conn.cursor (MySQLdb.cursors.DictCursor)
cursor.execute ("""
                SELECT srcuser,
                DATE_FORMAT(t,'%M %e, %Y') AS date_sent
                FROM mail
                """)
for row in cursor.fetchall ():
  print "user: %s, date sent: %s" \
           % (row["srcuser"], row["date_sent"])
cursor.close ()
#@ _FRAG_

conn.close ()
