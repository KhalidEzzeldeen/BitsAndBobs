<?php
# cow_edit.php - Present a form for editing a record in the cow_order table

# Form has fields that are initialized to the column values from a record
# in the table.  (The script uses record 1.)

require_once "Cookbook.php";
require_once "Cookbook_Utils.php";
require_once "Cookbook_Webutils.php";

$title = "Cow Figurine Order Record Editing Form";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: "
       . htmlspecialchars ($conn->getMessage ()));

?>

<html>
<head>
<title><?php print ($title); ?></title>
<body bgcolor="white">

<?php

# Retrieve a record by ID from the cow_order table

#@ _FETCH_ORDER_INFO_
$id = 1;      # select record number 1
$stmt = "SELECT
           color, size, accessories,
           cust_name, cust_street, cust_city, cust_state
         FROM cow_order WHERE id = ?";
$result =& $conn->query ($stmt, $id);
if (PEAR::isError ($result))
  die ("Cannot select record $id");

if (!(list ($color, $size, $accessories,
      $cust_name, $cust_street, $cust_city, $cust_state)
        = $result->fetchRow ()))
  die ("Cannot select record $id");
$result->free ();
#@ _FETCH_ORDER_INFO_

print ("<p>Values to be loaded into form:</p>\n");
$values = array
(
  "id = $id (this is a hidden field; use \"show source\" to see it)",
  "color = $color",
  "size = $size",
  "accessories = $accessories",
  "name = $cust_name",
  "street = $cust_street",
  "city = $cust_city",
  "state = $cust_state"
);
print (make_unordered_list ($values));

#@ _SPLIT_ACCESSORY_VALUE_
$acc_val = explode (",", $accessories);
#@ _SPLIT_ACCESSORY_VALUE_

# Retrieve values for color list

#@ _FETCH_COLOR_LIST_
$color_values = array ();
$stmt = "SELECT color FROM cow_color ORDER BY color";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die ("Cannot fetch color list\n");
while (list ($val) = $result->fetchRow ())
  $color_values[] = $val;
$result->free ();
#@ _FETCH_COLOR_LIST_

# Retrieve metadata for size and accessory columns

#@ _FETCH_SIZE_INFO_
$size_info = get_enumorset_info ($conn, "cookbook", "cow_order", "size");
#@ _FETCH_SIZE_INFO_
#@ _FETCH_ACCESSORY_INFO_
$acc_info = get_enumorset_info ($conn, "cookbook",
                                "cow_order", "accessories");
#@ _FETCH_ACCESSORY_INFO_

# Retrieve values and labels for state list

#@ _FETCH_STATE_LIST_
$state_values = array ();
$state_labels = array ();
$stmt = "SELECT abbrev, name FROM states ORDER BY name";
$result =& $conn->query ($stmt);
if (PEAR::isError ($result))
  die ("Cannot fetch state list\n");
while (list ($abbrev, $name) = $result->fetchRow ())
{
  $state_values[] = $abbrev;
  $state_labels[] = $name;
}
$result->free ();
#@ _FETCH_STATE_LIST_

$conn->disconnect ();

# Generate various types of form elements, using the cow_order record
# to provide the default value for each element.

#@ _PRINT_START_FORM_
print ("<form action=\"" . get_self_path () . "\" method=\"post\">\n");
#@ _PRINT_START_FORM_

# Put ID value into a hidden field

#@ _PRINT_ID_HIDDEN_
print (make_hidden_field ("id", $id));
#@ _PRINT_ID_HIDDEN_

# Use color list to generate a pop-up menu

#@ _PRINT_COLOR_POPUP_
print ("<br />Cow color:<br />\n");
print (make_popup_menu ("color", $color_values, $color_values, $color));
#@ _PRINT_COLOR_POPUP_

# Use size column ENUM information to generate radio buttons

#@ _PRINT_SIZE_RADIO_
print ("<br />Cow figurine size:<br />\n");
print (make_radio_group ("size",
                         $size_info["values"],
                         $size_info["values"],
                         $size,
                         TRUE));   # display items vertically
#@ _PRINT_SIZE_RADIO_

# Use accessory column SET information to generate checkboxes

#@ _PRINT_ACCESSORY_CHECKBOX_
print ("<br />Cow accessory items:<br />\n");
print (make_checkbox_group ("accessories[]",
                            $acc_info["values"],
                            $acc_info["values"],
                            $acc_val,
                            TRUE));   # display items vertically
#@ _PRINT_ACCESSORY_CHECKBOX_

#@ _PRINT_CUST_NAME_TEXT_
print ("<br />Customer name:<br />\n");
print (make_text_field ("cust_name", $cust_name, 60));
#@ _PRINT_CUST_NAME_TEXT_

#@ _PRINT_CUST_STREET_TEXT_
print ("<br />Customer street address:<br />\n");
print (make_text_field ("cust_street", $cust_street, 60));
#@ _PRINT_CUST_STREET_TEXT_

#@ _PRINT_CUST_CITY_TEXT_
print ("<br />Customer city:<br />\n");
print (make_text_field ("cust_city", $cust_city, 60));
#@ _PRINT_CUST_CITY_TEXT_

#@ _PRINT_CUST_STATE_SCROLLING_SINGLE_
print ("<br />Customer state:<br />\n");
print (make_scrolling_list ("cust_state",
                            $state_values,
                            $state_labels,
                            $cust_state,
                            6,        # display 6 items at a time
                            FALSE));  # create single-pick list
#@ _PRINT_CUST_STATE_SCROLLING_SINGLE_

#@ _PRINT_END_FORM_
print ("<br />\n");
print (make_submit_button ("choice", "Submit Form"));
#@ _PRINT_END_FORM_

?>

</form>

</body>
</html>
