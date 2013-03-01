#!/usr/bin/ruby -w
# uniq_name.rb - show how to use PID to create table name

puts "PID: " + Process.pid.to_s
#@ _GENERATE_NAME_WITH_PID_
tbl_name = "tmp_tbl_" + Process.pid.to_s
#@ _GENERATE_NAME_WITH_PID_
puts "Table name: #{tbl_name}"
