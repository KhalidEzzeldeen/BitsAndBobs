<?php
#@ _HEAD_
# Cookbook_Session.php - MySQL-based session storage module

require_once "Cookbook.php";
#@ _HEAD_

# Define handler routines

#@ _OPEN_
function mysql_sess_open ($save_path, $sess_name)
{
global $mysql_sess_conn;

  # open connection to MySQL if it's not already open
  if (!$mysql_sess_conn)
  {
    # Do NOT use =& operator here!
    $mysql_sess_conn = Cookbook::connect ();
    if (PEAR::isError ($mysql_sess_conn))
    {
      $mysql_sess_conn = FALSE;
      return (FALSE);
    }
  }
  return (TRUE);
}
#@ _OPEN_

#@ _CLOSE_
function mysql_sess_close ()
{
global $mysql_sess_conn;

  if ($mysql_sess_conn)    # close connection if it's open
  {
    $mysql_sess_conn->disconnect ();
    $mysql_sess_conn = FALSE;
  }
  return (TRUE);
}
#@ _CLOSE_

#@ _READ_
function mysql_sess_read ($sess_id)
{
global $mysql_sess_conn;

  $stmt = "SELECT data FROM php_session WHERE id = ?";
  $result =& $mysql_sess_conn->query ($stmt, array ($sess_id));
  if (!PEAR::isError ($result))
  {
    list ($data) = $result->fetchRow ();
    $result->free ();
    if (isset ($data))
      return ($data);
    return ("");
  }
  return (FALSE);
}
#@ _READ_

#@ _WRITE_
function mysql_sess_write ($sess_id, $sess_data)
{
global $mysql_sess_conn;

  $stmt = "REPLACE php_session (id, data) VALUES(?,?)";
  $result =& $mysql_sess_conn->query ($stmt, array ($sess_id, $sess_data));
  return (!PEAR::isError ($result));
}
#@ _WRITE_

#@ _DESTROY_
function mysql_sess_destroy ($sess_id)
{
global $mysql_sess_conn;

  $stmt = "DELETE FROM php_session WHERE id = ?";
  $result =& $mysql_sess_conn->query ($stmt, array ($sess_id));
  return (!PEAR::isError ($result));
}
#@ _DESTROY_

#@ _GC_
function mysql_sess_gc ($sess_maxlife)
{
global $mysql_sess_conn;

  $stmt = "DELETE FROM php_session WHERE t < NOW() - INTERVAL ? SECOND";
  $result =& $mysql_sess_conn->query ($stmt, array ($sess_maxlife));
  return (TRUE);  # ignore errors
}
#@ _GC_

#@ _TAIL_
# Initialize the connection identifier, select user-defined
# session handling and register the handler routines

$mysql_sess_conn = FALSE;
ini_set ("session.save_handler", "user");
session_set_save_handler (
          "mysql_sess_open",
          "mysql_sess_close",
          "mysql_sess_read",
          "mysql_sess_write",
          "mysql_sess_destroy",
          "mysql_sess_gc"
        );
#@ _TAIL_
?>
