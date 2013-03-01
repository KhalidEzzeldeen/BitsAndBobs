#!/usr/bin/python
# disp_origin.py - display list of distinct origin values from the insect
# table, numbering the output rows.

import MySQLdb
import Cookbook

conn = Cookbook.connect ()

try:
#@ _FRAG_
  cursor = conn.cursor ()
  cursor.execute ("SELECT DISTINCT origin FROM insect")
  count = 1
  for row in cursor.fetchall ():
    print count, row[0]
    count = count + 1
  cursor.close ()
#@ _FRAG_
except MySQLdb.Error, e:
  print "Oops, the statement failed"
  print e.args

conn.close ()
