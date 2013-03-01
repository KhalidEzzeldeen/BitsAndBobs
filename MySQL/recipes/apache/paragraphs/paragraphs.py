#!/usr/bin/python
# paragraphs.py - generate HTML paragraphs

import cgi
import MySQLdb
import Cookbook

title = "Query Output Display - Paragraphs"

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

#@ _DISPLAY_PARAGRAPH_
cursor = conn.cursor ()
cursor.execute ("SELECT NOW(), VERSION(), USER(), DATABASE()")
(now, version, user, db) = cursor.fetchone ()
cursor.close ()
if db is None:  # check database name
  db = "NONE"
para = ("Local time on the MySQL server is %s.") % now
print "<p>" + cgi.escape (para, 1) + "</p>"
para = ("The server version is %s.") % version
print "<p>" + cgi.escape (para, 1) + "</p>"
para = ("The current user is %s.") % user
print "<p>" + cgi.escape (para, 1) + "</p>"
para = ("The default database is %s.") % db
print "<p>" + cgi.escape (para, 1) + "</p>"
#@ _DISPLAY_PARAGRAPH_

conn.close ()

print "</body>"
print "</html>"
