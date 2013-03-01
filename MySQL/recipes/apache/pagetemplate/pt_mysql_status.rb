#!/usr/bin/ruby -w
# pt_mysql_status.rb - print some MySQL server status information

require "PageTemplate"
require "cgi"
require "Cookbook"

title = "MySQL Server Status"

dbh = Cookbook.connect

# Retrieve status information
now, version = dbh.select_one("SELECT NOW(), VERSION()")
# SHOW STATUS variable values are in second result column
queries = dbh.select_one("SHOW /*!50002 GLOBAL */ STATUS LIKE 'Questions'")[1]
uptime = dbh.select_one("SHOW /*!50002 GLOBAL */ STATUS LIKE 'Uptime'")[1]
q_per_sec = sprintf("%.2f", queries.to_f / uptime.to_f)

dbh.disconnect

pt = PageTemplate.new
pt.load("pt_mysql_status.tmpl")
pt["title"] = title
pt["now"] = now
pt["version"] = version
pt["queries"] = queries
pt["uptime"] = uptime
pt["q_per_sec"] = q_per_sec

cgi = CGI.new("html4")
cgi.out { pt.output }
