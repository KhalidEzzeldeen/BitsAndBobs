#!/usr/bin/python
# lists.py - generate HTML lists

import sys
import cgi
import MySQLdb
import Cookbook
from Cookbook_Webutils import *

title = "Query Output Display - Lists"

# Print content type header, blank line that separates
# headers from page body, and first part of page

print "Content-Type: text/html"
print ""
print "<html>"
print "<head>"
print "<title>" + title + "</title>"
print "</head>"
print "<body bgcolor=\"white\">"

conn = Cookbook.connect ()

# Display some lists "manually", printing tags as items are fetched

print "<p>Ordered list:</p>"
#@ _ORDERED_LIST_INTERTWINED_
stmt = "SELECT item FROM ingredient ORDER BY id"
cursor = conn.cursor ()
cursor.execute (stmt)
print "<ol>"
for (item,) in cursor.fetchall ():
  if item is None:    # handle possibility of NULL item
    item = ""
  print "<li>" + cgi.escape (item, 1) + "</li>"
print "</ol>"
cursor.close ()
#@ _ORDERED_LIST_INTERTWINED_

print "<p>Unordered list:</p>"
#@ _UNORDERED_LIST_INTERTWINED_
stmt = "SELECT item FROM ingredient ORDER BY id"
cursor = conn.cursor ()
cursor.execute (stmt)
print "<ul>"
for (item,) in cursor.fetchall ():
  if item is None:    # handle possibility of NULL item
    item = ""
  print "<li>" + cgi.escape (item, 1) + "</li>"
print "</ul>"
cursor.close ()
#@ _UNORDERED_LIST_INTERTWINED_

print "<p>Definition list:</p>"
#@ _DEFINITION_LIST_INTERTWINED_
stmt = "SELECT note, mnemonic FROM doremi ORDER BY id"
cursor = conn.cursor ()
cursor.execute (stmt)
print "<dl>"
for (note, mnemonic) in cursor.fetchall ():
  if note is None:    # handle possibility of NULL values
    note = ""
  if mnemonic is None:
    mnemonic = ""
  print "<dt>" + cgi.escape (note, 1) + "</dt>" # note
  print "<dd>" + cgi.escape (mnemonic, 1) + "</dd>" # mnemonic
print "</dl>"
cursor.close ()
#@ _DEFINITION_LIST_INTERTWINED_

# Display some lists using utility functions

# Fetch items for use with ordered/unordered list functions

#@ _FETCH_ITEM_LIST_
# fetch items for list
stmt = "SELECT item FROM ingredient ORDER BY id"
cursor = conn.cursor ()
cursor.execute (stmt)
items = []
for (item,) in cursor.fetchall ():
  items.append (item)
cursor.close ()
#@ _FETCH_ITEM_LIST_

print "<p>Ordered list:</p>"
#@ _ORDERED_LIST_FUNCTION_
# generate HTML list
print make_ordered_list (items)
#@ _ORDERED_LIST_FUNCTION_

print "<p>Unordered list:</p>"
#@ _UNORDERED_LIST_FUNCTION_
# generate HTML list
print make_unordered_list (items)
#@ _UNORDERED_LIST_FUNCTION_

# Fetch terms and definitions for a definition list

#@ _FETCH_DEFINITION_LIST_
# fetch items for list
stmt = "SELECT note, mnemonic FROM doremi ORDER BY id"
cursor = conn.cursor ()
cursor.execute (stmt)
terms = []
definitions = []
for (note, mnemonic) in cursor.fetchall ():
  terms.append (note)
  definitions.append (mnemonic)
cursor.close ()
#@ _FETCH_DEFINITION_LIST_

print "<p>Definition list:</p>"
#@ _DEFINITION_LIST_FUNCTION_
# generate HTML list
print make_definition_list (terms, definitions)
#@ _DEFINITION_LIST_FUNCTION_

conn.close ()

print "</body>"
print "</html>"
