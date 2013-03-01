<?php
# upload.php - file upload demonstration

# This script demonstrates how to generate a form that includes a
# file upload field, and how to obtain information about a file and
# read its contents when one is uploaded.  The script does not save
# the file anywhere, so it is discarded when the script exits.

require_once "Cookbook_Webutils.php";

$title = "File Upload Demo";

function _get_upload_info ($name)
{
global $HTTP_POST_FILES, $HTTP_POST_VARS;

  # Look for information in PHP 4.1 $_FILES array first.
  # Check the tmp_name member to make sure there is a file. (The entry
  # in $_FILES might be present even if no file was uploaded.)
  if (isset ($_FILES))
  {
    if (isset ($_FILES[$name])
        && $_FILES[$name]["tmp_name"] != "none")
      return ($_FILES[$name]);
    return (FALSE);
  }
  # Look for information in PHP 4 $HTTP_POST_FILES array next.
  if (isset ($HTTP_POST_FILES))
  {
    if (isset ($HTTP_POST_FILES[$name])
        && $HTTP_POST_FILES[$name]["tmp_name"] != "none")
      return ($HTTP_POST_FILES[$name]);
    return (FALSE);
  }
  return (FALSE);
}

?>

<html>
<head>
<title><?php print ($title); ?></title>
<body bgcolor="white">

<?php

if (function_exists ("ini_get")) # ini_get() is PHP 4-only
{
  $uploads_allowed = (ini_get ("file_uploads") ? "yes" : "no");
  $max_filesize = ini_get ("upload_max_filesize");
  $tmp_dir = ini_get ("upload_tmp_dir");
  print ("file uploads allowed: $uploads_allowed<br />\n");
  print ("max upload file size: $max_filesize<br />\n");
  print ("tmp file dir: $tmp_dir<br />\n");
}

print ("<br />\n");

# Was a file uploaded?  If so, print some information about it.

#@ _GET_FILE_INFO_
$upload_file = _get_upload_info ("upload_file");

if (!$upload_file)
  print ("No file was uploaded<br />\n");
else
{
  print ("Information about uploaded file:<br />\n");
    printf ("Temp filename on server: %s<br />\n",
                htmlspecialchars ($upload_file["tmp_name"]));
    printf ("Filename on client host: %s<br />\n",
                htmlspecialchars ($upload_file["name"]));
    printf ("File size: %s<br />\n",
                htmlspecialchars ($upload_file["size"]));
    printf ("File MIME type: %s<br />\n",
                htmlspecialchars ($upload_file["type"]));
  # try to read file; open in binary mode
  $contents = "";
  if ($fp = fopen ($upload_file["tmp_name"], "rb"))
  {
    $contents = fread ($fp, $upload_file["size"]);
    fclose ($fp);
  }
  if (strlen ($contents) == $upload_file["size"])
    print ("<p>File contents were read without error.</p>");
  else
    print ("<p>File contents could not be read.</p>");
}
#@ _GET_FILE_INFO_

?>

<!-- Display the file upload form -->

<!-- #@ _UPLOAD_FORM_ -->
<form enctype="multipart/form-data" method="post"
    action="<?php print (get_self_path ()); ?>">
<input type="hidden" name="MAX_FILE_SIZE" value="4000000" />
<p>File to upload:</p>
<input type="file" name="upload_file" size="60" />
<br /><br />
<input type="submit" name="choice" value="Submit" />
</form>
<!-- #@ _UPLOAD_FORM_ -->

</body>
</html>
