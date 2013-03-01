#!/usr/bin/python
# placeholder.py - demonstrate statement processing in Python
# (with placeholders)

import Cookbook
import MySQLdb

try:
  conn = Cookbook.connect ()
except MySQLdb.Error, e:
  print "Cannot connect to server"
  print "Error code:", e.args[0]
  print "Error message:", e.args[1]
  sys.exit (1)

print "Execute INSERT statement using placeholders"
try:
#@ _EXECUTE_PLACEHOLDER_1_
  cursor = conn.cursor ()
  cursor.execute ("""
                  INSERT INTO profile (name,birth,color,foods,cats)
                  VALUES(%s,%s,%s,%s,%s)
                  """, ("De'Mont", "1973-01-12", None, "eggroll", 4))
#@ _EXECUTE_PLACEHOLDER_1_
  print "Number of rows inserted: %d" % cursor.rowcount
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e

print "Execute SELECT statement using placeholders"
try:
#@ _EXECUTE_PLACEHOLDER_2_
  cursor = conn.cursor ()
  cursor.execute ("SELECT * FROM profile WHERE cats = %s", (2,))
  for row in cursor.fetchall ():
    print row
  cursor.close ()
#@ _EXECUTE_PLACEHOLDER_2_
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e

print "Construct INSERT statement using literal()"
try:
#@ _LITERAL_
  cursor = conn.cursor ()
  stmt = """
         INSERT INTO profile (name,birth,color,foods,cats)
         VALUES(%s,%s,%s,%s,%s)
         """ % \
         (conn.literal ("De'Mont"), \
         conn.literal ("1973-01-12"), \
         conn.literal (None), \
         conn.literal ("eggroll"), \
         conn.literal (4))
  cursor.execute (stmt)
#@ _LITERAL_
  print "Statement:"
  print stmt
  print "Number of rows inserted: %d" % cursor.rowcount
except:
  print "Oops, the statement failed"

conn.close ()

