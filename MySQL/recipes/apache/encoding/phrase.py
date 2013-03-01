#!/usr/bin/python
# phrase.py - demonstrate HTML-encoding and URL-encoding using
# values in phrase table.

#@ _MAIN_1_
import cgi
import urllib
#@ _MAIN_1_
import MySQLdb
import Cookbook

title = "Links generated from phrase table"

# Print content type header, blank line that separates
# headers from page body, and first part of page

print "Content-Type: text/html"
print ""
print "<html>"
print "<head>"
print "<title>" + title + "</title>"
print "</head>"
print "<body bgcolor=\"white\">"

print "<p>" + title + "</p>"

conn = Cookbook.connect ()

#@ _MAIN_2_
stmt = "SELECT phrase_val FROM phrase ORDER BY phrase_val"
cursor = conn.cursor ()
cursor.execute (stmt)
for (phrase,) in cursor.fetchall ():
  # make sure that the value is a string
  phrase = str (phrase)
  # URL-encode the phrase value for use in the URL
  url = "/cgi-bin/mysearch.py?phrase=" + urllib.quote (phrase)
  # HTML-encode the phrase value for use in the link label
  label = cgi.escape (phrase, 1)
  print "<a href=\"%s\">%s</a><br />" % (url, label)
cursor.close ()
#@ _MAIN_2_

conn.close ()
