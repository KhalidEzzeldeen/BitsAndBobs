#!/usr/bin/python
# distinct_col.py - resolve ambiguous join output column names using aliases

import MySQLdb
import Cookbook

conn = Cookbook.connect ()
cursor = conn.cursor (MySQLdb.cursors.DictCursor)

# First demonstrate the problem using a query that returns nonunique
# column names.  The code below just prints out the column names as
# returned by the dictionary cursor.  When MySQLdb discovers a nonunique
# name, it prepends the table name to it.

stmt = """
  SELECT artist.name, painting.title, states.name, painting.price
  FROM artist INNER JOIN painting INNER JOIN states
  ON artist.a_id = painting.a_id AND painting.state = states.abbrev
"""
cursor.execute (stmt)
row = cursor.fetchone ()
for key in row.keys ():
  print key

# Assign column aliases to provide distinct names.

#@ _FRAG_2_
stmt = """
  SELECT
    artist.name AS painter, painting.title,
    states.name AS state, painting.price
  FROM artist INNER JOIN painting INNER JOIN states
  ON artist.a_id = painting.a_id AND painting.state = states.abbrev
"""
cursor.execute (stmt)
row = cursor.fetchone ()
for key in row.keys ():
  print key
#@ _FRAG_2_

cursor.close ()
conn.close ()
