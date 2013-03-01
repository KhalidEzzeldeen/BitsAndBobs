<?php
# Cookbook.php - library file with utility method for connecting to MySQL
# via PEAR DB module

require_once "DB.php";

class Cookbook
{
  # Establish a connection to the cookbook database, returning a
  # connection object, or an error object if an error occurs.

  function connect ()
  {
    $dsn = array (
             "phptype"  => "mysqli",
             "username" => "cbuser",
             "password" => "cbpass",
             "hostspec" => "localhost",
             "database" => "cookbook"
           );
    return (DB::connect ($dsn));
  }

} # end Cookbook

?>
