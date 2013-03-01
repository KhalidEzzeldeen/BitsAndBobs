<?php
# paragraphs.php - generate HTML paragraphs

require_once "Cookbook.php";
require_once "Cookbook_Webutils.php";

$title = "Query Output Display - Paragraphs";

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

#@ _DISPLAY_PARAGRAPH_1_
$result =& $conn->query ("SELECT NOW(), VERSION(), USER(), DATABASE()");
if (!PEAR::isError ($result))
{
  list ($now, $version, $user, $db) = $result->fetchRow ();
  $result->free ();
  if (!isset ($db))
    $db = "NONE";
  $para = "Local time on the MySQL server is $now.";
  print ("<p>" . htmlspecialchars ($para) . "</p>\n");
  $para = "The server version is $version.";
  print ("<p>" . htmlspecialchars ($para) . "</p>\n");
  $para = "The current user is $user.";
  print ("<p>" . htmlspecialchars ($para) . "</p>\n");
  $para = "The default database is $db.";
  print ("<p>" . htmlspecialchars ($para) . "</p>\n");
}
#@ _DISPLAY_PARAGRAPH_1_

$conn->disconnect ();

# Display the paragraph with a lot of switching between modes

?>

<!-- _DISPLAY_PARAGRAPH_2_ -->
<p>Local time on the MySQL server is
<?php print (htmlspecialchars ($now)); ?>.</p>
<p>The server version is
<?php print (htmlspecialchars ($version)); ?>.</p>
<p>The current user is
<?php print (htmlspecialchars ($user)); ?>.</p>
<p>The default database is
<?php print (htmlspecialchars ($db)); ?>.</p>
<!-- _DISPLAY_PARAGRAPH_2_ -->

</body>
</html>
