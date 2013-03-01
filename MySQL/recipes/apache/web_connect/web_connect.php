<html>
<head>
<title>PHP Web Connect Page</title>
</head>
<body bgcolor="white">

<?php

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
print ("<p>Connected</p>\n");
$conn->disconnect ();
print ("<p>Disconnected</p>\n");

?>
