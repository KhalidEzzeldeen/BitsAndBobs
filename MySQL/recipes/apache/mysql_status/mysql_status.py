#!/usr/bin/python
# mysql_status.py - print some MySQL server status information

import MySQLdb
import Cookbook

# Print header, blank line, and initial part of page

print """Content-Type: text/html

<html>
<head>
<title>MySQL Server Status</title>
</head>
<body bgcolor="white">
"""

# Connect to database
conn = Cookbook.connect ()

# Retrieve status information
cursor = conn.cursor ()
cursor.execute ("SELECT NOW(), VERSION()")
(now, version) = cursor.fetchone ()
# SHOW STATUS variable values are in second result column
cursor.execute ("SHOW /*!50002 GLOBAL */ STATUS LIKE 'Questions'")
queries = cursor.fetchone ()[1]
cursor.execute ("SHOW /*!50002 GLOBAL */ STATUS LIKE 'Uptime'")
uptime = cursor.fetchone ()[1]
q_per_sec = "%0.2f" % (float (queries) / float (uptime))
cursor.close ()

# Disconnect from database
conn.close ()

# Display status report
print "<p>Current time: " + str(now) + "</p>"
print "<p>Server version: " + version + "</p>"
print "<p>Server uptime (seconds): " + uptime + "</p>"
print "<p>Queries processed: " + queries + " (" \
    + q_per_sec + " queries/second)</p>"

# Print page trailer
print """
</body>
</html>
"""
