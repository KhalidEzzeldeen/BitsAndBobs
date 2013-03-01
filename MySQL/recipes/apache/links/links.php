<?php
# links.php - generate HTML hyperlinks

require_once "Cookbook.php";
require_once "Cookbook_Webutils.php";

$title = "Query Output Display - Hyperlinks";

?>

<html>
<head>
<title><?php print ($title); ?></title>
</head>
<body bgcolor="white">

<?php
# ----------------------------------------------------------------------

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

print ("<p>Book vendors as static text:</p>\n");
#@ _DISPLAY_STATIC_URL_
$stmt = "SELECT name, website FROM book_vendor ORDER BY name";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
$items = array ();
while (list ($name, $website) = $result->fetchRow ())
  $items[] = "Vendor: $name, web site: http://$website";
$result->free ();

print (make_unordered_list ($items));
#@ _DISPLAY_STATIC_URL_

print ("<p>Book vendors as hyperlinks:</p>\n");
#@ _DISPLAY_HYPERLINK_URL_
$stmt = "SELECT name, website FROM book_vendor ORDER BY name";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
$items = array ();
while (list ($name, $website) = $result->fetchRow ())
{
  $items[] = sprintf ("<a href=\"http://%s\">%s</a>",
                      $website, htmlspecialchars ($name));
}
$result->free ();

# don't encode the items, they're already encoded
print (make_unordered_list ($items, 0));
#@ _DISPLAY_HYPERLINK_URL_

print ("<p>Email directory:</p>\n");
#@ _DISPLAY_EMAIL_LIST_
$stmt = "SELECT department, name, email
          FROM newsstaff
          ORDER BY department, name";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die (htmlspecialchars ($result->getMessage ()));
$items = array ();
while (list ($dept, $name, $email) = $result->fetchRow ())
{
  $items[] = htmlspecialchars ($dept)
              . ": "
              .  make_email_link ($name, $email);
}
$result->free ();

# don't encode the items, they're already encoded
print (make_unordered_list ($items, 0));
#@ _DISPLAY_EMAIL_LIST_

print ("<p>Some sample invocations of make_email_link():</p>\n");
print ("<p>Name + address: "
    . make_email_link ("Rex Conex", "rconex@wrrr-news.com")
    . "</p>\n");
print ("<p>Name + unset address: "
    . make_email_link ("Rex Conex", NULL)
    . "</p>\n");
print ("<p>Name + empty string address: "
    . make_email_link ("Rex Conex", "")
    . "</p>\n");
print ("<p>Name + missing address: "
    . make_email_link ("Rex Conex")
    . "</p>\n");
print ("<p>Address as name: "
    . make_email_link ("rconex@wrrr-news.com", "rconex@wrrr-news.com")
    . "</p>\n");

$conn->disconnect ();

?>

</body>
</html>
