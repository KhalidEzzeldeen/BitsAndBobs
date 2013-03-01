#!/usr/bin/ruby -w
# get_rs_meta.rb - run a statement and display its result set metadata

# The program runs a default statement, which can be overridden by supplying
# a statement as an argument on the command line.

require "Cookbook"

#@ _DEFAULT_STATEMENT_
stmt = "SELECT name, foods FROM profile"
#@ _DEFAULT_STATEMENT_
# override statement with command line argument if one was given
stmt = ARGV[0] if ARGV.length > 0

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

begin
#@ _DISPLAY_METADATA_
  puts "Statement: #{stmt}"
  sth = dbh.execute(stmt)
  # metadata information becomes available at this point ...
  puts "Number of columns: #{sth.column_names.size}"
  puts "Note: statement has no result set" if sth.column_names.size == 0
  sth.column_info.each_with_index do |info, i|
    printf "--- Column %d (%s) ---\n", i, info["name"]
    printf "sql_type:         %s\n", info["sql_type"]
    printf "type_name:        %s\n", info["type_name"]
    printf "precision:        %s\n", info["precision"]
    printf "scale:            %s\n", info["scale"]
    printf "nullable:         %s\n", info["nullable"]
    printf "indexed:          %s\n", info["indexed"]
    printf "primary:          %s\n", info["primary"]
    printf "unique:           %s\n", info["unique"]
    printf "mysql_type:       %s\n", info["mysql_type"]
    printf "mysql_type_name:  %s\n", info["mysql_type_name"]
    printf "mysql_length:     %s\n", info["mysql_length"]
    printf "mysql_max_length: %s\n", info["mysql_max_length"]
    printf "mysql_flags:      %s\n", info["mysql_flags"]
  end
  sth.finish
#@ _DISPLAY_METADATA_
rescue DBI::DatabaseError => e
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

dbh.disconnect
