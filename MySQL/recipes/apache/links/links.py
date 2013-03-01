#!/usr/bin/python
# links.py - generate HTML hyperlinks

import sys
import cgi
import urllib
import MySQLdb
import Cookbook
from Cookbook_Webutils import *

title = "Query Output Display - Hyperlinks"

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

print "<p>Book vendors as static text:</p>"
#@ _DISPLAY_STATIC_URL_
stmt = "SELECT name, website FROM book_vendor ORDER BY name"
cursor = conn.cursor ()
cursor.execute (stmt)
items = []
for (name, website) in cursor.fetchall ():
  items.append ("Vendor: %s web site: http://%s" % (name, website))
cursor.close ()
print make_unordered_list (items)
#@ _DISPLAY_STATIC_URL_

print "<p>Book vendors as hyperlinks:</p>"
#@ _DISPLAY_HYPERLINK_URL_
stmt = "SELECT name, website FROM book_vendor ORDER BY name"
cursor = conn.cursor ()
cursor.execute (stmt)
items = []
for (name, website) in cursor.fetchall ():
  items.append ("<a href=\"http://%s\">%s</a>" \
        % (urllib.quote (website), cgi.escape (name, 1)))
cursor.close ()

# print items, but don't encode them; they're already encoded
print make_unordered_list (items, False)
#@ _DISPLAY_HYPERLINK_URL_

print "<p>Email directory:</p>"
#@ _DISPLAY_EMAIL_LIST_
stmt = """
    SELECT department, name, email
    FROM newsstaff
    ORDER BY department, name
"""
cursor = conn.cursor ()
cursor.execute (stmt)
items = []
for (dept, name, email) in cursor.fetchall ():
  link = make_email_link (name, email)
  dept = cgi.escape (dept, 1)
  items.append(dept + ": " + link)
cursor.close ()

# print items, but don't encode them; they're already encoded
print make_unordered_list (items, False)
#@ _DISPLAY_EMAIL_LIST_

print "<p>Some sample invocations of make_email_link():</p>"
print "<p>Name + address: " \
    + make_email_link ("Rex Conex", "rconex@wrrr-news.com") + "</p>"
print "<p>Name + address of None: " \
    + make_email_link ("Rex Conex", None) + "</p>"
print "<p>Name + empty string address: " \
    + make_email_link ("Rex Conex", "") + "</p>"
print "<p>Name + missing address: " \
    + make_email_link ("Rex Conex") + "</p>"
print "<p>Address as name: " \
    + make_email_link ("rconex@wrrr-news.com", "rconex@wrrr-news.com") \
    + "</p>"

conn.close ()

print "</body>"
print "</html>"
