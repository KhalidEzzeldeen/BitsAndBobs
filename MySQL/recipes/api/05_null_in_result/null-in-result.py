#!/usr/bin/python

import Cookbook

conn = Cookbook.connect ()

try:
#@ _FETCHLOOP_
  cursor = conn.cursor ()
  cursor.execute ("SELECT name, birth, foods FROM profile")
  for row in cursor.fetchall ():
    row = list (row)  # convert nonmutable tuple to mutable list
    for i in range (0, len (row)):
      if row[i] == None:  # is the column value NULL?
        row[i] = "NULL"
    print "name: %s, birth: %s, foods: %s" % (row[0], row[1], row[2])
  cursor.close ()
#@ _FETCHLOOP_
except:
  print "Oops, the statement failed"

conn.close ()
