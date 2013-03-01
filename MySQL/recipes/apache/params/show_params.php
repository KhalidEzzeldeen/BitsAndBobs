<?php
# show_params.php - print request parameter names and values

require_once "Cookbook_Webutils.php";

$title = "Script Input Parameters";

?>

<html>
<head>
<title><?php print ($title); ?></title>
</head>
<body bgcolor="white">

<?php

error_reporting (E_ALL);

function print_param ($name, $val)
{
  if ($val === NULL)
    $val = "[not set]";
  else if ($val == "")
    $val = "[empty string]";
  else if (!$val)
    $val = "[false]";
  if (is_array ($val))
    $val = "Array(" . join (", ", $val) . ")";
  print ("$name: " . htmlspecialchars ($val) . "<br />\n");
}

function print_param_array ($array)
{
  $count = 0;
  foreach ($array as $k => $v)
  {
    print_param ($k, $v);
    ++$count;
  }
  if ($count == 0)
    print ("[none]<br />\n");
}

# ----------------------------------------------------------------------

print_param ("QUERY_STRING", get_server_val ("QUERY_STRING"));
print_param ("REQUEST_URI", get_server_val ("REQUEST_URI"));
print_param ("SCRIPT_NAME", get_server_val ("SCRIPT_NAME"));
print_param ("PHP_SELF", get_server_val ("PHP_SELF"));
print_param ("get_self_path()", get_self_path ());

print_param ("get_magic_quotes_gpc ()", get_magic_quotes_gpc ());
print_param ("get_cfg_var (magic_quotes_gpc)", get_cfg_var ("magic_quotes_gpc"));

print_param ("get_cfg_var (register_globals)", get_cfg_var ("register_globals"));
if (function_exists ("ini_get"))
{
  print_param ("ini_get (magic_quotes_gpc)", ini_get ("magic_quotes_gpc"));
  print ("<br />\n");
  print_param ("ini_get (register_globals)", ini_get ("register_globals"));
  print ("<br />\n");
  print_param ("ini_get (track_vars)", ini_get ("track_vars"));
  print ("<br />\n");
}

print ("<hr />Parameters present in \$_GET array:");
print ("<br />\n");
if ($_GET === NULL)
  print ("array is not set\n");
else
  print_param_array ($_GET);
print ("<br />\n");

print ("<hr />Parameters present in \$HTTP_GET_VARS array:");
print ("<br />\n");
if ($HTTP_GET_VARS === NULL)
  print ("array is not set\n");
else
  print_param_array ($HTTP_GET_VARS);
print ("<br />\n");

print ("<hr />Parameters present in \$_POST array:");
print ("<br />\n");
if ($_POST === NULL)
  print ("array is not set\n");
else
  print_param_array ($_POST);
print ("<br />\n");

print ("<hr />Parameters present in \$HTTP_POST_VARS array:");
print ("<br />\n");
if ($HTTP_POST_VARS === NULL)
  print ("array is not set\n");
else
  print_param_array ($HTTP_POST_VARS);
print ("<br />\n");

# Could do $_FILES, $HTTP_POST_FILES, but the forms contain
# no upload fields...

$param_names = get_param_names ();
print ("Parameter names (using get_param_names()): "
    . join (", ", $param_names));
print ("<br />\n");
sort ($param_names);
foreach ($param_names as $k => $v)
  print_param ($v, get_param_val ($v));

print ("<br />\n");

# This example prints just the parameter names without the values

print ("Parameter names (using get_param_names(), but not print_param()): ");
print ("<br />\n");
#@ _PRINT_PARAM_NAMES_
$param_names = get_param_names ();
foreach ($param_names as $k => $v)
  print (htmlspecialchars ($v) . "<br />\n");
#@ _PRINT_PARAM_NAMES_

print ("<br />\n");

# Try a parmameter that (probably) doesn't exist.

print_param ("nonexistent-param", get_param_val ("nonexistent-param"));

$self_path = get_self_path ();

?>

<!--
include forms that can be used to submit requests via get and post
-->

<p>Form 1:</p>

<form method="get" action="<?php print ($self_path); ?>">
Enter a text value:
<input type="text" name="text_field" size="60">
<br />

Select any combination of colors:<br />
<select name="color[]" multiple="multiple">
<option value="red">red</option>
<option value="white">white</option>
<option value="blue">blue</option>
<option value="black">black</option>
<option value="silver">silver</option>
</select>

<br />
<input type="submit" name="choice" value="Submit by get">
</form>

<p>Form 2:</p>

<form method="post" action="<?php print ($self_path); ?>">
Enter a text value:
<input type="text" name="text_field" size="60">
<br />

Select any combination of colors:<br />
<select name="color[]" multiple="multiple">
<option value="red">red</option>
<option value="white">white</option>
<option value="blue">blue</option>
<option value="black">black</option>
<option value="silver">silver</option>
</select>
<br />

<input type="submit" name="choice" value="Submit by post">
</form>

</body>
</html>
