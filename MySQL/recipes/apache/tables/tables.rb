#!/usr/bin/ruby -w
# tables.rb - generate HTML tables

require "cgi"
require "Cookbook"

title = "Query Output Display - Tables"

cgi = CGI.new("html4")
page =""

dbh = Cookbook.connect

page << cgi.p { "HTML table:" }

# _PRINT_CD_TABLE_
table_rows = cgi.tr {
               cgi.th { "Year" } +
               cgi.th { "Artist" } +
               cgi.th { "Title" }
             }
stmt = "SELECT year, artist, title FROM cd ORDER BY artist, year"
dbh.execute(stmt) do |sth|
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
# _PRINT_CD_TABLE_

page << cgi.p { "HTML table with rows in alternating colors:" }

# _PRINT_COLORED_CD_TABLE_
bgcolor = "silver"    # row-color variable
table_rows = cgi.tr {
               cgi.th("bgcolor" => bgcolor) { "Year" } +
               cgi.th("bgcolor" => bgcolor) { "Artist" } +
               cgi.th("bgcolor" => bgcolor) { "Title" }
             }
stmt = "SELECT year, artist, title FROM cd ORDER BY artist, year"
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    row.collect! do |val| CGI.escapeHTML(val.to_s) end
    # toggle the row-color variable
    bgcolor = (bgcolor == "silver" ? "white" : "silver")
    table_rows << cgi.tr {
                    cgi.td("bgcolor" => bgcolor) { row[0] } +
                    cgi.td("bgcolor" => bgcolor) { row[1] } +
                    cgi.td("bgcolor" => bgcolor) { row[2] }
                  }
  end
end
page << cgi.table("border" => "1") { table_rows }
# _PRINT_COLORED_CD_TABLE_

dbh.disconnect

cgi.out {
  cgi.html {
    cgi.head { cgi.title { title } } +
    cgi.body("bgcolor" => "white") { page }
  }
}
