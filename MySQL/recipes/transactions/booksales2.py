#!/usr/bin/python
# booksales2.py - show how to update book sales counters using transactions.
# See booksales1.py for a nontransactional implementation.

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
              UPDATE booksales SET copies = copies+1 WHERE title = %s
            """, (title,))
    cursor.execute ("""
              SELECT copies FROM booksales WHERE title = %s
            """, (title,))
    (count,) = cursor.fetchone ()
    cursor.close ()
    conn.commit ()
  except MySQLdb.Error, e:
    try:
      conn.rollback ()
    except:
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
