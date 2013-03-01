<?php
# Cookbook_Webutils.php - MySQL Cookbook web-related utilities

# ----------------------------------------------------------------------
# HTML list generation functions.  These return the list as a string.
# For ordered and unordered lists, pass the items in an array.  The array
# element values are the list items; element keys are ignored.  For
# definition list, pass an array of terms and an array of the corresponding
# definitions.

# The $encode argument should be true or false to indicate whether the
# function should perform HTML-encoding of list items.  Default is true.

#@ _MAKE_ORDERED_LIST_
function make_ordered_list ($items, $encode = TRUE)
{
  $str = "<ol>\n";
  foreach ($items as $k => $v)
  {
    if ($encode)
      $v = htmlspecialchars ($v);
    $str .= "<li>$v</li>\n";
  }
  $str .= "</ol>\n";
  return ($str);
}
#@ _MAKE_ORDERED_LIST_

#@ _MAKE_UNORDERED_LIST_
function make_unordered_list ($items, $encode = TRUE)
{
  $str = "<ul>\n";
  foreach ($items as $k => $v)
  {
    if ($encode)
      $v = htmlspecialchars ($v);
    $str .= "<li>$v</li>\n";
  }
  $str .= "</ul>\n";
  return ($str);
}
#@ _MAKE_UNORDERED_LIST_

#@ _MAKE_DEFINITION_LIST_
function make_definition_list ($terms, $definitions, $encode = TRUE)
{
  $str = "<dl>\n";
  $n = count ($terms);
  for ($i = 0; $i < $n; $i++)
  {
    $term = $terms[$i];
    $definition = $definitions[$i];
    if ($encode)
    {
      $term = htmlspecialchars ($term);
      $definition = htmlspecialchars ($definition);
    }
    $str .= "<dt>$term</dt>\n<dd>$definition</dd>\n";
  }
  $str .= "</dl>\n";
  return ($str);
}
#@ _MAKE_DEFINITION_LIST_

# Create an email hyperlink from a name and email address

#@ _MAKE_EMAIL_LINK_
function make_email_link ($name, $addr = NULL)
{
  $name = htmlspecialchars ($name);
  # return name as static text if address is NULL or empty
  if ($addr === NULL || $addr == "")
    return ($name);
  # return a hyperlink otherwise
  return (sprintf ("<a href=\"mailto:%s\">%s</a>", $addr, $name));
}
#@ _MAKE_EMAIL_LINK_

# ----------------------------------------------------------------------
# Utility functions to generate form list elements.

# make_radio_group ($name, $values, $labels, $default, $vertical)
# make_checkbox_group ($name, $values, $labels, $default, $vertical)
# make_popup_menu ($name, $values, $labels, $default)
# make_scrolling_list ($name, $values, $labels, $default, $size, $multiple)

# $vertical (true/false) indicates whether to put <br /> tags after
# each radio button or checkbox.
# $size indicates the number of visible items in a scrolling list.
# $multiple is true if a scrolling list is a multiple-pick list.
# For scrolling lists, $default should be a scalar for a single-pick
# list, a scalar or an array for a multiple-pick list.  For no default
# selection, pass an unset value or an empty array.


# Check arguments and return a string indicating the problem if they're
# not okay.  This way you get a visual indicator in the web page what
# the problem is.

#@ _MAKE_RADIO_GROUP_
function make_radio_group ($name, $values, $labels, $default, $vertical)
{
  $str = "";
  for ($i = 0; $i < count ($values); $i++)
  {
    # select the item if it corresponds to the default value
    $checked = ($values[$i] == $default ? " checked=\"checked\"" : "");
    $str .= sprintf (
                "<input type=\"radio\" name=\"%s\" value=\"%s\"%s />%s",
                htmlspecialchars ($name),
                htmlspecialchars ($values[$i]),
                $checked,
                htmlspecialchars ($labels[$i]));
    if ($vertical)
      $str .= "<br />"; # display items vertically
    $str .= "\n";
  }
  return ($str);
}
#@ _MAKE_RADIO_GROUP_

# $default can be a scalar or an array

#@ _MAKE_CHECKBOX_GROUP_
function make_checkbox_group ($name, $values, $labels, $default, $vertical)
{
  if (!is_array ($default))
    $default = array ($default);  # convert scalar to array
  $str = "";
  for ($i = 0; $i < count ($values); $i++)
  {
    # select the item if it corresponds to one of the default values
    $checked = "";
    foreach ($default as $k => $v)
    {
      if ($values[$i] == $v)
      {
        $checked = " checked=\"checked\"";
        break;
      }
    }
    $str .= sprintf (
              "<input type=\"checkbox\" name=\"%s\" value=\"%s\"%s />%s",
              htmlspecialchars ($name),
              htmlspecialchars ($values[$i]),
              $checked,
              htmlspecialchars ($labels[$i]));
    if ($vertical)
      $str .= "<br />"; # display items vertically
    $str .= "\n";
  }
  return ($str);
}
#@ _MAKE_CHECKBOX_GROUP_

#@ _MAKE_POPUP_MENU_
function make_popup_menu ($name, $values, $labels, $default)
{
  $str = "";
  for ($i = 0; $i < count ($values); $i++)
  {
    # select the item if it corresponds to the default value
    $checked = ($values[$i] == $default ? " selected=\"selected\"" : "");
    $str .= sprintf (
              "<option value=\"%s\"%s>%s</option>\n",
              htmlspecialchars ($values[$i]),
              $checked,
              htmlspecialchars ($labels[$i]));
  }
  $str = sprintf (
            "<select name=\"%s\">\n%s</select>\n",
            htmlspecialchars ($name),
            $str);
  return ($str);
}
#@ _MAKE_POPUP_MENU_

# $default can be a scalar or an array

#@ _MAKE_SCROLLING_LIST_
function make_scrolling_list ($name, $values, $labels, $default,
                $size, $multiple)
{
  if (!is_array ($default))
    $default = array ($default);  # convert scalar to array
  $str = "";
  for ($i = 0; $i < count ($values); $i++)
  {
    # select the item if it corresponds to one of the default values
    $checked = "";
    foreach ($default as $k => $v)
    {
      if ($values[$i] == $v)
      {
        $checked = " selected=\"selected\"";
        break;
      }
    }
    $str .= sprintf (
              "<option value=\"%s\"%s>%s</option>\n",
              htmlspecialchars ($values[$i]),
              $checked,
              htmlspecialchars ($labels[$i]));
  }
  $str = sprintf (
            "<select name=\"%s\" size=\"%s\"%s>\n%s</select>\n",
            htmlspecialchars ($name),
            htmlspecialchars ($size),
            $multiple ? " multiple=\"multiple\"" : "",
            $str);
  return ($str);
}
#@ _MAKE_SCROLLING_LIST_

# ----------------------------------------------------------------------
# Utility functions to generate form hidden elements, text fields, and
# submit buttons.

# make_hidden_field ($name, $value)
# make_text_field ($name, $value, $size)
# make_submit_button ($name, $value)

#@ _MAKE_HIDDEN_FIELD_
function make_hidden_field ($name, $value)
{
  $str = sprintf (
            "<input type=\"hidden\" name=\"%s\" value=\"%s\" />\n",
            htmlspecialchars ($name),
            htmlspecialchars ($value));
  return ($str);
}
#@ _MAKE_HIDDEN_FIELD_

#@ _MAKE_TEXT_FIELD_
function make_text_field ($name, $value, $size = 10)
{
  $str = sprintf (
            "<input type=\"text\" name=\"%s\" value=\"%s\" size=\"%s\" />\n",
            htmlspecialchars ($name),
            htmlspecialchars ($value),
            htmlspecialchars ($size));
  return ($str);
}
#@ _MAKE_TEXT_FIELD_

#@ _MAKE_SUBMIT_BUTTON_
function make_submit_button ($name, $value)
{
  $str = sprintf (
            "<input type=\"submit\" name=\"%s\" value=\"%s\" />\n",
            htmlspecialchars ($name),
            htmlspecialchars ($value));
  return ($str);
}
#@ _MAKE_SUBMIT_BUTTON_

# ----------------------------------------------------------------------
# Functions for obtaining web input parameter and environment values

# All of the functions that extract values from the script environment
# return NULL if the requested value is not available.

# get_param_val() retrieves a get or post variable, stripping slashes
# added by magic_quotes_gpc if necessary.  Assumes that track_vars is on,
# but doesn't assume anything about magic_quotes_gpc, and is neutral to the
# setting of register_globals.  The function prefers the $_GET and $_POST
# arrays if they are available, falling back to $HTTP_GET_VARS and
# $HTTP_POST_VARS as necessary.

# The helper function strip_slash_helper() is used to strip backslashes,
# accounting for whether the value is a scalar or an array.  It works even
# for nested arrays (it's possible to create input parameters as nested
# arrays as of PHP 4).

#@ _STRIP_SLASH_HELPER_
function strip_slash_helper ($val)
{
  if (!is_array ($val))
    $val = stripslashes ($val);
  else
  {
    foreach ($val as $k => $v)
      $val[$k] = strip_slash_helper ($v);
  }
  return ($val);
}
#@ _STRIP_SLASH_HELPER_

#@ _GET_PARAM_VAL_
function get_param_val ($name)
{
global $HTTP_GET_VARS, $HTTP_POST_VARS;

  $val = NULL;
  if (isset ($_GET[$name]))
    $val = $_GET[$name];
  else if (isset ($_POST[$name]))
    $val = $_POST[$name];
  else if (isset ($HTTP_GET_VARS[$name]))
    $val = $HTTP_GET_VARS[$name];
  else if (isset ($HTTP_POST_VARS[$name]))
    $val = $HTTP_POST_VARS[$name];
  if (isset ($val) && get_magic_quotes_gpc ())
    $val = strip_slash_helper ($val);
  return ($val);
}
#@ _GET_PARAM_VAL_

# Get a list of all the (unique) parameter names present in
# get or post variables.  The function prefers the $_GET and $_POST
# arrays if they are available, falling back to $HTTP_GET_VARS and
# $HTTP_POST_VARS as necessary.

#@ _GET_PARAM_NAMES_
function get_param_names ()
{
global $HTTP_GET_VARS, $HTTP_POST_VARS;

  # construct an array in which each element has a parameter name as
  # both key and value.  (Using names as keys eliminates duplicates.)
  $keys = array ();
  if (isset ($_GET))
  {
    foreach ($_GET as $k => $v)
      $keys[$k] = $k;
  }
  else if (isset ($HTTP_GET_VARS))
  {
    foreach ($HTTP_GET_VARS as $k => $v)
      $keys[$k] = $k;
  }
  if (isset ($_POST))
  {
    foreach ($_POST as $k => $v)
      $keys[$k] = $k;
  }
  else if (isset ($HTTP_POST_VARS))
  {
    foreach ($HTTP_POST_VARS as $k => $v)
      $keys[$k] = $k;
  }
  return ($keys);
}
#@ _GET_PARAM_NAMES_

# Given the name of a file upload field, return a four element associative
# array containing information about the file.  The element names are:
# tmp_name - name of temporary file on server
# name - original name of file on client
# size - size of file in bytes
# type - MIME type of file

# The function prefers the $_FILES array if it is available, falling back
# to $HTTP_POST_FILES as necessary.

#@ _GET_UPLOAD_INFO_
function get_upload_info ($name)
{
global $HTTP_POST_FILES, $HTTP_POST_VARS;

  # Look for information in PHP 4.1 $_FILES array first.
  # Check the tmp_name member to make sure there is a file. (The entry
  # in $_FILES might be present even if no file was uploaded.)
  if (isset ($_FILES))
  {
    if (isset ($_FILES[$name])
        && $_FILES[$name]["tmp_name"] != ""
        && $_FILES[$name]["tmp_name"] != "none")
      return ($_FILES[$name]);
  }
  # Look for information in PHP 4 $HTTP_POST_FILES array next.
  else if (isset ($HTTP_POST_FILES))
  {
    if (isset ($HTTP_POST_FILES[$name])
        && $HTTP_POST_FILES[$name]["tmp_name"] != ""
        && $HTTP_POST_FILES[$name]["tmp_name"] != "none")
      return ($HTTP_POST_FILES[$name]);
  }
  return (NULL);
}
#@ _GET_UPLOAD_INFO_

# Get the value of a server variable.  The function prefers the $_SERVER
# array if it is available, falling back to $HTTP_SERVER_VARS as necessary.

#@ _GET_SERVER_VAL_
function get_server_val ($name)
{
global $HTTP_SERVER_VARS;

  $val = NULL;
  if (isset ($_SERVER[$name]))
    $val = $_SERVER[$name];
  else if (isset ($HTTP_SERVER_VARS[$name]))
    $val = $HTTP_SERVER_VARS[$name];
  return ($val);
}
#@ _GET_SERVER_VAL_

# Return path to current script.  The function prefers the $_SERVER
# array if it is available, falling back to $HTTP_SERVER_VARS as
# necessary.

#@ _GET_SELF_PATH_
function get_self_path ()
{
global $HTTP_SERVER_VARS;

  $val = NULL;
  if (isset ($_SERVER["PHP_SELF"]))
    $val = $_SERVER["PHP_SELF"];
  else if (isset ($HTTP_SERVER_VARS["PHP_SELF"]))
    $val = $HTTP_SERVER_VARS["PHP_SELF"];
  return ($val);
}
#@ _GET_SELF_PATH_

# Get the value of a session variable.  The function prefers the $_SESSION
# array if it is available, falling back to $HTTP_SESSION_VARS as necessary.

#@ _GET_SESSION_VAL_
function get_session_val ($name)
{
global $HTTP_SESSION_VARS;

  $val = NULL;
  if (isset ($_SESSION[$name]))
    $val = $_SESSION[$name];
  else if (isset ($HTTP_SESSION_VARS[$name]))
    $val = $HTTP_SESSION_VARS[$name];
  return ($val);
}
#@ _GET_SESSION_VAL_

# Set the value of a session variable by installing it into the applicable
# session variable arrays.

#@ _SET_SESSION_VAL_
function set_session_val ($name, $val)
{
global $HTTP_SESSION_VARS;

  if (isset ($_SESSION))
    $_SESSION[$name] = $val;
  $HTTP_SESSION_VARS[$name] = $val;
}
#@ _SET_SESSION_VAL_

?>
