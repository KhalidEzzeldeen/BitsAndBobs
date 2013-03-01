#!/usr/bin/ruby -w
# get_storage_engines.rb - list supported storage engines

require "Cookbook"

#@ _GET_STORAGE_ENGINES_
def get_storage_engines(dbh)
  engines = []
  dbh.select_all("SHOW ENGINES").each do |engine, support|
    engines << engine if ["YES", "DEFAULT"].include?(support.upcase)
  end
  return engines
end
#@ _GET_STORAGE_ENGINES_

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

engines = get_storage_engines(dbh)
puts "Supported storage engines:"
engines.each do |engine| puts engine end

dbh.disconnect
