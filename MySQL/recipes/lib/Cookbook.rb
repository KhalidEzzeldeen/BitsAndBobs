# Cookbook.rb - library file with utility method for connecting to MySQL
# via Ruby DBI module

require "dbi"

# Establish a connection to the cookbook database, returning a database
# handle.  Raise an exception if the connection cannot be established.

class Cookbook
  @@host = "localhost"
  @@db_name = "cookbook"
  @@user_name = "cbuser"
  @@password = "cbpass"

  # class method for connecting to server to access
  # cookbook database; returns database handle object.

  def Cookbook.connect
      return DBI.connect("DBI:Mysql:host=#{@@host};database=#{@@db_name}",
                         @@user_name, @@password)
  end
end
