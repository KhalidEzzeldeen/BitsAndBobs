<?php

# read_mysql_option_file()

# Given the name of an option file and an option group name or array
# listing group names, read any options for the group(s) that are
# present in the file.
# Return an array of name/value pairs or FALSE if the file cannot be read.
# Options that are named in the file with no value have an empty string as
# their value in the returned array.
# Later instances of any given option supersede earlier instances.

# The default option group is "client" if no group is passed.

#@ _FUNCTION_
function read_mysql_option_file ($filename, $group_list = "client")
{
  if (is_string ($group_list))           # convert string to array
    $group_list = array ($group_list);
  if (!is_array ($group_list))           # hmm ... garbage argument?
    return (FALSE);
  $opt = array ();                       # option name/value array
  if (!@($fp = fopen ($filename, "r")))  # if file does not exist,
    return ($opt);                       # return an empty list
  $in_named_group = 0;  # set nonzero while processing a named group
  while ($s = fgets ($fp, 1024))
  {
    $s = trim ($s);
    if (ereg ("^[#;]", $s))              # skip comments
      continue;
    if (ereg ("^\[([^]]+)]", $s, $arg))  # option group line?
    {
      # check whether we're in one of the desired groups
      $in_named_group = 0;
      foreach ($group_list as $key => $group_name)
      {
        if ($arg[1] == $group_name)
        {
          $in_named_group = 1;    # we're in a desired group
          break;
        }
      }
      continue;
    }
    if (!$in_named_group)         # we're not in a desired
      continue;                   # group, skip the line
    if (ereg ("^([^ \t=]+)[ \t]*=[ \t]*(.*)", $s, $arg))
      $opt[$arg[1]] = $arg[2];    # name=value
    else if (ereg ("^([^ \t]+)", $s, $arg))
      $opt[$arg[1]] = "";         # name only
    # else line is malformed
  }
  return ($opt);
}
#@ _FUNCTION_

# Examples:
# 1) Read client options from a user option file, use them to
# establish a connection

# 2) Read system-wide option file, print server parameters listed there

require_once "DB.php";

#@ _EXAMPLES_
$opt = read_mysql_option_file ("/u/paul/.my.cnf");
$dsn = array
(
  "phptype"  => "mysqli",
  "username" => $opt["user"],
  "password" => $opt["password"],
  "hostspec" => $opt["host"],
  "database" => "cookbook"
);
$conn =& DB::connect ($dsn);
if (PEAR::isError ($conn))
  print ("Cannot connect to server\n");

$opt = read_mysql_option_file ("/etc/my.cnf", array ("mysqld", "server"));
foreach ($opt as $name => $value)
  print ("$name => $value\n");
#@ _EXAMPLES_

?>
