#!/usr/bin/python
# seqdiag.py - test AUTO_INCREMENT operations

import MySQLdb
import Cookbook

def init_table (conn):
  try:
    cursor = conn.cursor ()
    cursor.execute ("DROP TABLE IF EXISTS seqdiag")
    cursor.execute ("""
                  CREATE TABLE seqdiag
                  (seq INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY)
                """)
    cursor.close ()
  except MySQLdb.Error, e:
    print "Cannot create seqdiag table"
    print e.args

def gen_seq_val (cursor):
  try:
    cursor.execute ("INSERT INTO seqdiag (seq) VALUES(NULL)")
  except MySQLdb.Error, e:
    print "Cannot create AUTO_INCREMENT value"
    print e.args

conn = Cookbook.connect ()

init_table (conn)
cursor = conn.cursor ()

gen_seq_val (cursor)
seq = conn.insert_id ()
print "seq:", seq
cursor.execute ("SET @x = LAST_INSERT_ID(99)")
seq = conn.insert_id ()
print "seq after SET via insert_id():", seq
cursor.execute ("SELECT LAST_INSERT_ID()")
row = cursor.fetchone ()
seq = row[0]
print "seq after SET via LAST_INSERT_ID():", seq

cursor.close ()
conn.close ()

conn1 = Cookbook.connect ()
conn2 = Cookbook.connect ()

# Issue two sequence-generating queries using separate connection
# objects to see whether they interfere with each other's
# insert_id() value.
#@ _INDEPENDENT_CONNS_
cursor1 = conn1.cursor ()
cursor2 = conn2.cursor ()
gen_seq_val (cursor1)   # issue query that generates a sequence number
gen_seq_val (cursor2)   # issue another, using a different cursor
seq1 = conn1.insert_id ()
seq2 = conn2.insert_id ()
print "seq1:", seq1, "seq2:", seq2  # these values will be different
cursor1.close ()
cursor2.close ()
#@ _INDEPENDENT_CONNS_

conn1.close ()
conn2.close ()
