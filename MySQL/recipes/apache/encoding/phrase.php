<?php
# phrase.php - demonstrate HTML-encoding and URL-encoding using
# values in phrase table.

require_once "Cookbook.php";

$title = "Links generated from phrase table";

?>

<html>
<head>
<title><?php print ($title); ?></title>
</head>
<body bgcolor="white">

<?php

print ("<p>$title</p>\n");

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

#@ _MAIN_
$stmt = "SELECT phrase_val FROM phrase ORDER BY phrase_val";
$result =& $conn->query ($stmt);
if (!PEAR::isError ($result))
{
  while (list ($phrase) = $result->fetchRow ())
  {
    # URL-encode the phrase value for use in the URL
    $url = "/mcb/mysearch.php?phrase=" . urlencode ($phrase);
    # HTML-encode the phrase value for use in the link label
    $label = htmlspecialchars ($phrase);
    printf ("<a href=\"%s\">%s</a><br />\n", $url, $label);
  }
  $result->free ();
}
#@ _MAIN_

$conn->disconnect ();

?>
