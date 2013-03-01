<?php
# sess_demo.php - Simple session-stage counter.

# Uses PHP's default (file-based) session storage managment.

require_once "Cookbook_Webutils.php"; # needed for get_session_val()
                                      # and set_session_val()

session_start ();
$count = get_session_val ("count");
if (!isset ($count))
  $count = 0;
++$count;
set_session_val ("count", $count);

?>
<html>
<head><title>Session Demo</title></head>
<body bgcolor="white">

<p>
<?php
print ("This session has been active for $count requests.");
?>
</p>

</body>
</html>
