#!/usr/bin/python
# stmt.py - demonstrate statement processing in Python
# (without placeholders)

import Cookbook
import MySQLdb

try:
  conn = Cookbook.connect ()
except MySQLdb.Error, e:
  print "Cannot connect to server"
  print "Error code:", e.args[0]
  print "Error message:", e.args[1]
  sys.exit (1)

print "Fetch rows with fetchone"
try:
#@ _FETCHONE_
  cursor = conn.cursor ()
  cursor.execute ("SELECT id, name, cats FROM profile")
  while 1:
    row = cursor.fetchone ()
    if row == None:
      break
    print "id: %s, name: %s, cats: %s" % (row[0], row[1], row[2])
  print "Number of rows returned: %d" % cursor.rowcount
  cursor.close ()
#@ _FETCHONE_
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e

print "Fetch rows with fetchall"
try:
#@ _FETCHALL_
  cursor = conn.cursor ()
  cursor.execute ("SELECT id, name, cats FROM profile")
  rows = cursor.fetchall ()
  for row in rows:
    print "id: %s, name: %s, cats: %s" % (row[0], row[1], row[2])
  print "Number of rows returned: %d" % cursor.rowcount
  cursor.close ()
#@ _FETCHALL_
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e

print "Fetch rows as dictionaries"
try:
#@ _DICT_CURSOR_
  cursor = conn.cursor (MySQLdb.cursors.DictCursor)
  cursor.execute ("SELECT id, name, cats FROM profile")
  for row in cursor.fetchall ():
    print "id: %s, name: %s, cats: %s" % (row["id"], row["name"], row["cats"])
  print "Number of rows returned: %d" % cursor.rowcount
  cursor.close ()
#@ _DICT_CURSOR_
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e

print "Execute UPDATE statement (no placeholders)"
try:
#@ _DO_1_
  cursor = conn.cursor ()
  cursor.execute ("UPDATE profile SET cats = cats+1 WHERE name = 'Fred'")
  print "Number of rows updated: %d" % cursor.rowcount
#@ _DO_1_
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e

conn.close ()
