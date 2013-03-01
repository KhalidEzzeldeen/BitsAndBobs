<?php
# sess_track.php - session request counting/timestamping demonstration

#@ _INCLUDE_LIBRARY_
require_once "Cookbook_Session.php";
#@ _INCLUDE_LIBRARY_
# needed for make_unordered_list(), get_session_val(), set_session_val()
require_once "Cookbook_Webutils.php";

$title = "PHP Session Tracker";

# Open session and extract session values

session_start ();
$count = get_session_val ("count");
$timestamp = get_session_val ("timestamp");

# If the session is new, initialize the variables

if (!isset ($count))
  $count = 0;
if (!isset ($timestamp))
  $timestamp = array ();

# Increment counter, add current timestamp to timestamp array

++$count;
$timestamp[] = date ("Y-m-d H:i:s T");

if ($count < 10)  # save modified values into session variable array
{
  set_session_val ("count", $count);
  set_session_val ("timestamp", $timestamp);
}
else              # destroy session variables after 10 invocations
{
  session_unregister ("count");
  session_unregister ("timestamp");
}
session_write_close (); # save session changes

# Produce the output page

?>
<html>
<head>
<title><?php print ($title); ?></title>
</head>
<body bgcolor="white">

<?php

print ("<p>This session has been active for $count requests.</p>\n");
print ("<p>The requests occurred at these times:</p>\n");
print make_unordered_list ($timestamp);

?>

</body>
</html>
