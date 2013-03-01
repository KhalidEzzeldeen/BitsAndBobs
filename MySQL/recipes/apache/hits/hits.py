#!/usr/bin/python
# hits.py - web page hit counter example

import sys
import os
import cgi
import MySQLdb
import Cookbook

#@ _GET_HIT_COUNT_
def get_hit_count (conn, page_path):
  cursor = conn.cursor ()
  cursor.execute ("""
             INSERT INTO hitcount (path,hits) VALUES(%s,LAST_INSERT_ID(1))
             ON DUPLICATE KEY UPDATE hits = LAST_INSERT_ID(hits+1)
             """, (page_path,))
  cursor.close ()
  return (conn.insert_id ())
#@ _GET_HIT_COUNT_

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if os.environ.has_key ("SCRIPT_NAME"):
#@ _GET_SELF_PATH_
  self_path = os.environ["SCRIPT_NAME"]
#@ _GET_SELF_PATH_
else:
  self_path = sys.argv[0]

title = "Hit Count Example"

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

print "<p>Page path: " + cgi.escape (self_path, 1) + "</p>"

# Display a hit count

#@ _DISPLAY_HIT_COUNT_
count = get_hit_count (conn, self_path)
print "<p>This page has been accessed %d times.</p>" % count
#@ _DISPLAY_HIT_COUNT_

# Use a logging approach to hit recording.  This allows
# the most recent hits to be displayed.

if os.environ.has_key ("REMOTE_HOST"):
  host = os.environ["REMOTE_HOST"]
elif os.environ.has_key ("REMOTE_ADDR"):
  host = os.environ["REMOTE_ADDR"]
else:
  host = "UNKNOWN"

cursor = conn.cursor ()
cursor.execute ("""
                INSERT INTO hitlog (path, host) VALUES(%s,%s)
                """, (self_path, host))

# Display the most recent hits for the page

cursor.execute ("""
                SELECT hits, DATE_FORMAT(t, '%%Y-%%m-%%d %%T'), host
                FROM hitlog
                WHERE path = %s ORDER BY hits DESC LIMIT 10
                """, (self_path, ))
print "<p>Most recent hits:</p>"
print "<table border=\"1\">"
print "<tr><th>%s</th><th>%s</th><th>%s</th></tr>" % ("Hit", "Date", "Host")
for (hits, date, host) in cursor.fetchall ():
  print "<tr><td>%d</td><td>%s</td><td>%s</td></tr>" % \
        (hits, cgi.escape (date), cgi.escape (host))
print "</table>"

cursor.close ()
conn.close ()

print "</body>"
print "</html>"
