#!/usr/bin/ruby -w
# connect2.rb - connect to the MySQL server, showing how to specify
# a port number or Unix domain socket path explicitly.

require "dbi"

begin
#@ _FRAG1_
  dsn = "DBI:Mysql:host=mysql.example.com;database=cookbook" +
          ";port=3307"
#@ _FRAG1_
  puts "Connect using DSN = #{dsn}"
  dbh = DBI.connect(dsn, "cbuser", "cbpass")
  puts "Connected"
rescue
  puts "Cannot connect to server"
else
  dbh.disconnect
  puts "Disconnected"
end

begin
#@ _FRAG2_
  dsn = "DBI:Mysql:host=localhost;database=cookbook" +
          ";socket=/var/tmp/mysql.sock"
#@ _FRAG2_
  puts "Connect using DSN = #{dsn}"
  dbh = DBI.connect(dsn, "cbuser", "cbpass")
  puts "Connected"
rescue
  puts "Cannot connect to server"
else
  dbh.disconnect
  puts "Disconnected"
end
