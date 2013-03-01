#!/usr/bin/python
# booksales1.py - show how to update book sales counters using
# LAST_INSERT_ID().  See booksales2.py for a transactional implementation.

import MySQLdb
import Cookbook

# Update a book's copies-sold count and return the resulting value,
# or zero if an error occurs.

#@ _UPDATE_BOOKSALES_
def update_booksales (conn, title):
  count = 0
  try:
    cursor = conn.cursor ()
    cursor.execute ("""
              UPDATE booksales SET copies = LAST_INSERT_ID(copies+1)
              WHERE title = %s
            """, (title,))
    cursor.execute ("SELECT LAST_INSERT_ID()")
    (count,) = cursor.fetchone ()
    cursor.close ()
  except MySQLdb.Error, e:
    pass
  return count
#@ _UPDATE_BOOKSALES_

conn = Cookbook.connect ()
# insert row for title if it's not already there
cursor = conn.cursor ()
cursor.execute ("""
                INSERT IGNORE INTO booksales (title,copies)
                VALUES('Bulldozer',0)
                """)
cursor.close
print update_booksales (conn, 'Bulldozer')
conn.close ()
