<?php
# hits.php - web page hit counter example

require_once "Cookbook.php";
require_once "Cookbook_Utils.php";
require_once "Cookbook_Webutils.php";

$title = "Hit Count Example";

#@ _GET_HIT_COUNT_
function get_hit_count ($conn, $page_path)
{
  $stmt = "INSERT INTO hitcount (path,hits) VALUES(?,LAST_INSERT_ID(1))
           ON DUPLICATE KEY UPDATE hits = LAST_INSERT_ID(hits+1)";
  $result =& $conn->query ($stmt, array ($page_path));
  if (PEAR::isError ($result))
    die (htmlspecialchars ($conn->getMessage ()));
  $result =& $conn->query ("SELECT LAST_INSERT_ID()");
  if (PEAR::isError ($result))
    die (htmlspecialchars ($conn->getMessage ()));
  list ($hits) = $result->fetchRow ();
  $result->free ();
  return ($hits);
}
#@ _GET_HIT_COUNT_

?>

<html>
<head>
<title><?php print ($title); ?></title>
</head>
<body bgcolor="white">

<?php

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

#@ _GET_SELF_PATH_
$self_path = get_self_path ();
#@ _GET_SELF_PATH_

printf ("<p>Page path: %s</p>\n", htmlspecialchars ($self_path));

# Display a hit count

#@ _DISPLAY_HIT_COUNT_
$count = get_hit_count ($conn, $self_path);
print ("<p>This page has been accessed $count times.</p>\n");
#@ _DISPLAY_HIT_COUNT_

# Use a logging approach to hit recording.  This allows
# the most recent hits to be displayed.

$host = get_server_val ("REMOTE_HOST");
if (!isset ($host))
  $host = get_server_val ("REMOTE_ADDR");
if (!isset ($host))
  $host = "UNKNOWN";

$stmt = "INSERT INTO hitlog (path, host) VALUES(?,?)";
$result =& $conn->query ($stmt, array ($self_path, $host));
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));

# Display the most recent hits for the page

$stmt = "SELECT hits, DATE_FORMAT(t, '%Y-%m-%d %T'), host
         FROM hitlog WHERE path = ? ORDER BY hits DESC LIMIT 10";
$result =& $conn->query ($stmt, $self_path);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
print ("<p>Most recent hits:</p>\n");
print ("<table border=\"1\">\n");
printf ("<tr><th>%s</th><th>%s</th><th>%s</th></tr>\n",
        "Hit", "Date", "Host");
while (list ($hits, $date, $host) = $result->fetchRow ())
{
  printf ("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n",
          htmlspecialchars ($hits),
          htmlspecialchars ($date),
          htmlspecialchars ($host));
}
$result->free ();
print ("</table>\n");

$conn->disconnect ();

?>

</body>
</html>
