# Cookbook.py - library file with utility method for connecting to MySQL
# via MySQLdb module

import MySQLdb

host_name = "localhost"
db_name = "cookbook"
user_name = "cbuser"
password = "cbpass"

# Establish a connection to the cookbook database, returning a connection
# object.  Raise an exception if the connection cannot be established.

def connect ():
  return MySQLdb.connect (db = db_name,
                          host = host_name,
                          user = user_name,
                          passwd = password)
