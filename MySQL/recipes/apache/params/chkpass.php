<?php
# chkpass.php - script to demonstrate the problem of not initializing
# global variables if register_globals is enabled.  The script assumes
# that register_global is enabled, of course.

# Invoke the script like this, and you'll see that $password_is_ok
# is true even though check_password() returns false:

# http://localhost/chkpass.php?password_is_ok=1

require_once "Cookbook.php";

# stub function that always returns 0 (false)

function check_password ($password) { return 0; }

#@ _FRAGMENT_
if (check_password ($password))
  $password_is_ok = 1;
#@ _FRAGMENT_
?>

<html>
<body bgcolor="white">

<p>
$password_is_ok is
<?php print ($password_is_ok ? "true" : "false"); ?>.
</p>

</body>
</html>
