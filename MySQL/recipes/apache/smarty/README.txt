Some of the commands below might need to be done as root. (# prompt)

Get Smarty from smarty.php.net.  This is a file named something like
Smarty-2.6.14.tar.gz.  Unpack it to create a directory named
Smarty-2.6.14.

Decide on an installation directory for the parts of Smarty-2.6.14
that are needed for Smarty scripts.  I use /usr/local/lib/php/Smarty.

# mkdir /usr/local/lib/php/Smarty

Copy the relevant parts of the Smarty-2.6.14 directory to the installation
directory:

# cp -r Smarty-2.6.14/libs/* /usr/local/lib/php/Smarty

Add the installation directory to include_path in php.ini so
that PHP scripts can find the Smarty files with no special
handling. (Restart Apache if it uses mod_php.)

[Note: The Smarty site recommends putting the following directories
outside the document root. But if I do that, I'll need to set paths
in every script, or a wrapper to hide those details. Ugh.]

Set up Smarty directories in your application directory.  (I use
the mcb directory under the Apache document root.)  Change location
into that directory and execute the following commands:

% mkdir cache
% mkdir configs
% mkdir templates
% mkdir templates_c

These directories must be readable by the web server, and two of
them must also be writable.  To do this, set the group permissions
appropriately, and then change their group to be that used by the
web server.  Set the group permissions with these commands:

% chmod g+rx cache configs templates templates_c
% chmod g+w cache templates_c

Change the group for the directories to the group used by the web
server. You can determine the correct group by looking for a Group
line in the Apache httpd.conf file.  If the group is www, change
the group for the directories by executing this command (as root):

# chgrp www cache configs templates templates_c


Create a template file named sm_hello.tmpl in the templates directory:

<html>
<head>
<title>Smarty Test</title>
</head> 
<body>
<p>Hello, {$name}!</p>
<p>You are visiting from IP address {$addr}!</p>
</body>
</html>

Create a script named sm_hello.php in the application directory
(the directory containing the templates directory):

<?php
require "Smarty.class.php";

$smarty = new Smarty();
$smarty->assign("name", "world");
$smarty->assign("addr", $_SERVER["REMOTE_ADDR"]);
$smarty->display("sm_hello.tmpl");
?>

Request the script from your browser:

http://localhost/mcb/sm_hello.php

