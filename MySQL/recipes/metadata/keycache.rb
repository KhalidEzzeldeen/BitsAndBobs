#! /usr/bin/ruby -w
# keycache.rb - Show MySQL key cache hit rate

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

#@ _HITRATE_
# Execute SHOW STATUS to get relevant server status variables, use
# names and values to construct hash of values keyed by names.
stat_hash = {}
stmt = "SHOW /*!50002 GLOBAL */ STATUS LIKE 'Key_read%'"
dbh.select_all(stmt).each { |name, value| stat_hash[name] = value }

key_reads = stat_hash["Key_reads"].to_f
key_reqs = stat_hash["Key_read_requests"].to_f
hit_rate = key_reqs == 0 ? 0 : 1.0 - (key_reads / key_reqs)

puts "        Key_reads: #{key_reads}"
puts "Key_read_requests: #{key_reqs}"
puts "         Hit rate: #{hit_rate}"
#@ _HITRATE_

dbh.disconnect
