#!/usr/bin/python

import sys
import MySQLdb
import Cookbook

print """Content-Type: text/html

<html>
<head>
<title>Python Web Connect Page</title>
</head>
<body bgcolor="white">
"""

conn = Cookbook.connect ()
print "<p>Connected</p>"
conn.close ()
print "<p>Disconnected</p>"

print """
</body>
</html>
"""
