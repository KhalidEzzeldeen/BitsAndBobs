<?php
# connect2.php - connect to the MySQL server, showing how to specify
# the DSN parameters using an array, and how to specify
# a port number or Unix domain socket path explicitly.

require_once "DB.php";

#@ _FRAG0_
$dsn = array
(
  "phptype"  => "mysqli",
  "username" => "cbuser",
  "password" => "cbpass",
  "hostspec" => "localhost",
  "database" => "cookbook"
);
$conn =& DB::connect ($dsn);
if (PEAR::isError ($conn))
  print ("Cannot connect to server\n");
#@ _FRAG0_
else
{
  print ("Connected\n");
  $conn->disconnect ();
  print ("Disconnected\n");
}

#@ _FRAG1_
$dsn = array
(
  "phptype"  => "mysqli",
  "username" => "cbuser",
  "password" => "cbpass",
  "hostspec" => "mysql.example.com",
  "port"     => 3307,
  "database" => "cookbook"
);
$conn =& DB::connect ($dsn);
if (PEAR::isError ($conn))
  print ("Cannot connect to server\n");
#@ _FRAG1_
else
{
  print ("Connected\n");
  $conn->disconnect ();
  print ("Disconnected\n");
}

#@ _FRAG2_
$dsn = array
(
  "phptype"  => "mysqli",
  "username" => "cbuser",
  "password" => "cbpass",
  "hostspec" => "localhost",
  "socket"   => "/var/tmp/mysql.sock",
  "database" => "cookbook"
);
$conn =& DB::connect ($dsn);
if (PEAR::isError ($conn))
  print ("Cannot connect to server\n");
#@ _FRAG2_
else
{
  print ("Connected\n");
  $conn->disconnect ();
  print ("Disconnected\n");
}

?>
