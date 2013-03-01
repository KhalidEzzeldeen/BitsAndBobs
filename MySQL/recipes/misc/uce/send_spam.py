#!/usr/bin/python
# send_spam.py - send junk mail to people listed in victim table

import sys
import os
import pwd
import re
import smtplib
import MySQLdb
import Cookbook

subject = "Important Junk Mail just for you!"
template = """
Dear %#salutation#% %#last_name#%,

This message is being sent to you because we know you'll be interested
in this special offer. Not everyone qualifies for this wonderful
opportunity, etc., etc., and we're certain you'll want to take
advantage of it immediately! For more details, visit our web site:
http://www.stupendous-offer-for-select-customers-only.com/
"""

try:
  from_addr = pwd.getpwuid (os.geteuid ())[0] + "@localhost"
except:
  print "Cannot determine current username"
  sys.exit (1);

conn = Cookbook.connect ()
try:
  cursor = conn.cursor (MySQLdb.cursors.DictCursor)
  cursor.execute ("SELECT * FROM victim")
  while (1):
    row = cursor.fetchone ()
    if row == None:
      break
    #print "name: %s, email: %s" \
    #       % (row["realname"], row["email"])

    # For each column name, look for markers matching that name in
    # the template and replace them with the column value.  Markers
    # are of the form %#xxx#% for column xxx.
    # Work with copy of template to avoid changing the original.

    msg = template
    for name in row.keys ():
      msg = re.sub ("%#" + name + "#%", row[name], msg)
    msg = "Subject: " + subject + "\n\n" + msg
    try:
      # send the message to the address in the email column
      server = smtplib.SMTP ("localhost")
      server.sendmail (from_addr, row["email"], msg)
      server.quit ()
    except smtplib.SMTPException, e:
      print "sendmail error:", e
      sys.exit (1)
  cursor.close ()
except MySQLdb.Error, e:
  print "%s (%s)" % (e.args[1], e.args[0])
  sys.exit (1)

conn.close ()
