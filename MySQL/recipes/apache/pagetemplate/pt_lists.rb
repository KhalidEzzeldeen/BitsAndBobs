#!/usr/bin/ruby -w
# pt_lists.rb - generate HTML lists

require "PageTemplate"
require "cgi"
require "Cookbook"

title = "Query Output Display - Lists"

dbh = Cookbook.connect

# Fetch items for ordered, unordered lists
# (create an array of "scalar" values; the list actually consists of
# DBI::Row objects, but for single-column rows, applying the to_s
# method to each object results in the column value)

stmt = "SELECT item FROM ingredient ORDER BY id"
list = dbh.select_all(stmt)

# Fetch terms and definitions for a definition list
# (create a list of hash values, one hash per row)

defn_list = []
stmt = "SELECT note, mnemonic FROM doremi ORDER BY id"
dbh.execute(stmt) do |sth|
  sth.fetch_hash do |row|
    defn_list << row
  end
end

dbh.disconnect

pt = PageTemplate.new
pt.load("pt_lists.tmpl")
pt["title"] = title
pt["list"] = list
pt["defn_list"] = defn_list

cgi = CGI.new("html4")
cgi.out { pt.output }
