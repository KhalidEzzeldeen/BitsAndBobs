#!/usr/bin/python
# harness2.py - test harness for Cookbook.py library

# Does not catch exceptions, so this script simply dies if
# a connect error occurs.

import sys
import MySQLdb
import Cookbook

#@ _FRAG_
conn = Cookbook.connect ()
print "Connected"
conn.close ()
print "Disconnected"
#@ _FRAG_

