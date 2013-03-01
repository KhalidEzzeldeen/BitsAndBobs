#!/usr/bin/ruby -w
# pt_tables.rb - generate HTML tables

require "PageTemplate"
require "cgi"
require "Cookbook"

title = "Query Output Display - Tables"

dbh = Cookbook.connect

# Fetch table rows
# (create a list of hash values, one hash per row)

rows = []
stmt = "SELECT year, artist, title FROM cd ORDER BY artist, year"
dbh.execute(stmt) do |sth|
  sth.fetch_hash do |row|
    rows << row
  end
end

dbh.disconnect

pt = PageTemplate.new
pt.load("pt_tables.tmpl")
pt["title"] = title
pt["rows"] = rows

cgi = CGI.new("html4")
cgi.out { pt.output }
