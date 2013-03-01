#!/usr/bin/ruby -w
# hits.rb - web page hit counter example

require "cgi"
require "Cookbook"

#@ _GET_HIT_COUNT_
def get_hit_count(dbh, page_path)
  dbh.do("INSERT INTO hitcount (path,hits) VALUES(?,LAST_INSERT_ID(1))
          ON DUPLICATE KEY UPDATE hits = LAST_INSERT_ID(hits+1)",
         page_path)
  return dbh.func(:insert_id)
end
#@ _GET_HIT_COUNT_

# If script is run from the command line, ENV["SCRIPT_NAME"] won't exist;
# fake it by using script name.

#@ _GET_SELF_PATH_
self_path = ENV["SCRIPT_NAME"]
#@ _GET_SELF_PATH_
self_path = $0 if self_path.nil?

title = "Hit Count Example"
page = ""

cgi = CGI.new("html4")

dbh = Cookbook.connect

page << cgi.p { "Page path: " + CGI.escapeHTML(self_path.to_s) }

#@ _DISPLAY_HIT_COUNT_
count = get_hit_count(dbh, self_path)
page << cgi.p { "This page has been accessed " + count.to_s + " times." }
#@ _DISPLAY_HIT_COUNT_

# Use a logging approach to hit recording.  This allows
# the most recent hits to be displayed.

if ENV["REMOTE_HOST"]
  host = ENV["REMOTE_HOST"]
elsif ENV["REMOTE_ADDR"]
  host = ENV["REMOTE_ADDR"]
else
  host = "UNKNOWN"
end

dbh.do("INSERT INTO hitlog (path, host) VALUES(?,?)", self_path, host)

# Display the most recent hits for the page

page << cgi.p { "Most recent hits:" }
table_rows = cgi.tr {
               cgi.th { "Hit" } +
               cgi.th { "Date" } +
               cgi.th { "Host" }
             }
stmt = "SELECT hits, DATE_FORMAT(t, '%Y-%m-%d %T'), host
        FROM hitlog
        WHERE path = ? ORDER BY hits DESC LIMIT 10"
dbh.execute(stmt, self_path) do |sth|
  sth.fetch do |row|
    row.collect! do |val| CGI.escapeHTML(val.to_s) end
    table_rows << cgi.tr {
                    cgi.td { row[0] } +
                    cgi.td { row[1] } +
                    cgi.td { row[2] }
                  }
  end
end
page << cgi.table("border" => "1") { table_rows }

dbh.disconnect

cgi.out {
  cgi.html {
    cgi.head { cgi.title { title } } +
    cgi.body("bgcolor" => "white") { page }
  }
}
